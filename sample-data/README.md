# Using sample data

Fire up the test container:

```
$ docker run --rm -ti \
    --name wott-ca-test \
    --net wott \
    -v $(dirname "$(pwd)")/sample-data:/sample-data \
    wott-ca bash

```


Switch to the temp directory:
```
$ cd /tmp
```

Check that we can sign a valid certificate:


```
$ cfssl gencert -remote=wott-ca:8888 /sample-data/valid-csr.json 2>/dev/null | python /sample-data/parse.py
[...]
$ openssl x509 -in tmp.crt -text -noout
[...]
$ openssl rsa -in tmp.key -check
[...]
```

We should only be allowed to sign certificates matching the RegEx `[0-9a-f]{32}\.d\.wott\.local` so let's try one that shouldn't work too:


```
$ cfssl gencert -remote=wott-ca:8888 /sample-data/invalid-csr.json 2>/dev/null | python /sample-data/parse.py
[...]
$ openssl x509 -in tmp.crt -text -noout
[...]
$ openssl rsa -in tmp.key -check
[...]
```

