#!/bin/bash
# vim: tabstop=4 shiftwidth=4 softtabstop=4
# -*- sh-basic-offset: 4 -*-

cd /ssl

cfssl gencert \
    -initca /etc/cfssl/ca-csr.json \
    | cfssljson -bare ca -

cfssl gencert \
    -ca=ca.pem \
    -ca-key=ca-key.pem \
    -config=/etc/cfssl/ca-config.json \
    -profile=server /etc/cfssl/server.json \
    | cfssljson -bare server
