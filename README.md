# WoTT CA Backend


## Crash course in CFSSL

There's a good [crash course](https://coreos.com/os/docs/latest/generate-self-signed-certificates.html) that walks through the basics of how to get CFSSL up and running.


## Bootstrapping

First, we need to fire up CFSSL so that we can generate the initial certificates, do this by running:

```
$ cd agent
$ docker build . -t wott-ca
$ docker run --rm -ti  -v $(pwd)/../ssl:/ssl wott-ca bash
```

Once you're inside the container, we can start generating certificates:

```
$ cd /ssl
$ cfssl gencert -initca /etc/cfssl/ca-csr.json | cfssljson -bare ca -
$ cfssl gencert -ca=ca.pem -ca-key=ca-key.pem -config=/etc/cfssl/ca-config.json -profile=server /etc/cfssl/server.json | cfssljson -bare server

```
