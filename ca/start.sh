#!/bin/bash
# vim: tabstop=4 shiftwidth=4 softtabstop=4
# -*- sh-basic-offset: 4 -*-

set -euo pipefail
IFS=$'\n\t'

LOG_LEVEL=${LOG_LEVEL:-1}

cfssl serve \
    -loglevel=${LOG_LEVEL} \
    -port=8888 \
    -address=0.0.0.0 \
    -config=/etc/cfssl/ca-config.json \
    -ca=/opt/wott/certs/intermediate_ca.pem \
    -ca-key=/opt/wott/certs/intermediate_ca-key.pem
