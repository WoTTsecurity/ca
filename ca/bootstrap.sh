#!/bin/bash
# vim: tabstop=4 shiftwidth=4 softtabstop=4
# -*- sh-basic-offset: 4 -*-

set -euox pipefail
IFS=$'\n\t'

cd /ssl

# Generate root certificate if it doesn't exist.
if [ ! -f /ssl/root_ca.pem ]; then
    cfssl gencert -initca /csr/root-ca-csr.json | cfssljson -bare root_ca
fi

# Generate ca0 certificate if it doesn't exist.
if [ ! -f /ssl/intermediate_ca.pem ]; then
    cfssl gencert -initca /csr/ca0-ca-csr.json | cfssljson -bare intermediate_ca
    cfssl sign -ca root_ca.pem -ca-key root_ca-key.pem -config /csr/root-to-immediate-ca.json intermediate_ca.csr | cfssljson -bare intermediate_ca
    mkbundle root_ca.pem intermediate_ca.pem
fi

rm -f *.csr
