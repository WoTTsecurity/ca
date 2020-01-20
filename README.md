# WoTT CA Backend


## Crash course in CFSSL

There's a good [crash course](https://coreos.com/os/docs/latest/generate-self-signed-certificates.html) that walks through the basics of how to get CFSSL up and running.


## Bootstrapping

First, we need to fire up CFSSL locally to generate the root certificate. This certificate should ideally be generated in an air-gapped machine.

```
$ cd ca
$ docker build . -t wott-ca
$ docker network create wott
$ docker run --rm -ti  -v "$(pwd)":/csr -v $(dirname "$(pwd)")/ssl:/ssl wott-ca bash
```

Once you're inside the container, we can start generating certificates:

```
$ bootstrap.sh
$ exit
```

You have now generated the required components for the CA server and should have the following files in the `../ssl` directory:

* `root_ca-key.pem`
* `root_ca.pem`
* `intermediate_ca-key.pem`
* `intermediate_ca.pem`

It critical that you keep `root_ca*.pem` offline and not on any remote server as this allows the owner to generate any subsequent keys.

You now need to copy the `intermediate_ca*.pem` files to the remote server to setup ca0.wott.local.

To get launch the server, run:

```
$ docker run --rm -ti \
    --name wott-ca \
    --net wott \
    -v $(dirname "$(pwd)")/ssl/intermediate_ca-key.pem:/opt/wott/certs/intermediate_ca-key.pem:ro \
    -v $(dirname "$(pwd)")/ssl/intermediate_ca.pem:/opt/wott/certs/intermediate_ca.pem:ro \
    -p 8888:8888 \
    wott-ca
```


Once deployed on the remote server you can use the same tool to generate the cert required for mtls.wott.io

```
$ cfssl gencert -ca /opt/wott/certs/intermediate_ca.pem -ca-key /opt/wott/certs/intermediate_ca-key.pem mtls-csr.json | cfssljson -bare mtls
```


## Rotating the intermediate certificate

On the air gapped machine with the root certificates, take the following steps:

* Launch into the container from the boostrapping step
* Rename the old intermediate and add `.bak` or similar
* Re-run `bootstrap.sh` and you should receive your new intermediate files

In a secure fashion (e.g. using an encrypted flash drive), copy the intermediate files along with `cert-bundle.crt`.

* Copy the intermediate files to the CA server, and restart the server
* Append the new intermediate certificate from `cert-bundle.crt` at the tail of [api repo](https://github.com/WoTTsecurity/api/blob/master/backend/files/cert-bundle.crt)
* Rotate the secret in the Nginx Ingress controller:

```
$ kubectl delete secret generic wott-ca -n api
$ kubectl create secret generic wott-ca -n api --from-file=ca.crt=backend/files/cert-bundle.crt
```

### Troubleshooting

To verify that everything worked, make sure you spin up a new node and then verify that the certificate checks out both from a *new* and old node.

```
$ openssl verify -verbose -CAfile new-ca.crt  client.crt
```
