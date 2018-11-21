# WoTT CA Backend


## Crash course in CFSSL

There's a good [crash course](https://coreos.com/os/docs/latest/generate-self-signed-certificates.html) that walks through the basics of how to get CFSSL up and running.


## Bootstrapping

First, we need to fire up CFSSL so that we can generate the initial certificates, do this by running:

```
$ cd ca
$ docker build . -t wott-ca
$ docker network create wott
$ docker run --rm -ti  -v $(dirname "$(pwd)")/ssl:/ssl wott-ca bash
```

Once you're inside the container, we can start generating certificates:

```
$ bootstrap.sh
$ rm /ssl/*.csr
$ exit
```

You have now generated the required components for the CA server and should have the following files in the `../ssl` directory:

* ca-key.pem
* ca.pem
* server-key.pem
* server.pem

These are the keys for both the CA and for the server.

To get launch the server, run:

```
$ docker run --rm -ti \
    --name wott-ca \
    --net wott \
    -v $(dirname "$(pwd)")/ssl/ca-key.pem:/opt/wott/certs/ca-key.pem:ro \
    -v $(dirname "$(pwd)")/ssl/ca.pem:/opt/wott/certs/ca.pem:ro \
    -p 80:8888 \
    wott-ca
```
