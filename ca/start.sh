#!/bin/bash
# vim: tabstop=4 shiftwidth=4 softtabstop=4
# -*- sh-basic-offset: 4 -*-

set -euo pipefail
IFS=$'\n\t'


cfssl serve \
    -port=8888 \
    -address=0.0.0.0 \
    -config=/etc/cfssl/ca-config.json \
    -ca=/opt/wott/cert/ca.pem \
    -ca-key=/opt/wott/cert/ca-key.pem
