#!/bin/bash
# vim: tabstop=4 shiftwidth=4 softtabstop=4
# -*- sh-basic-offset: 4 -*-

set -euo pipefail
IFS=$'\n\t'


cfssl serve \
    -port=8888 \
    -address=0.0.0.0 \
    -ca=/opt/wott/certs/ca.pem \
    -ca-key=/opt/wott/certs/ca-key.pem
