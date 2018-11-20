FROM golang:1.8-stretch

WORKDIR /go/src/

# We pin the commit below to prevent unexpected changes upstream.
ARG CFSSL_COMMIT=ea4033a
RUN git clone https://github.com/cloudflare/cfssl.git $GOPATH/src/github.com/cloudflare/cfssl && \
    cd $GOPATH/src/github.com/cloudflare/cfssl && \
    git checkout --detach $CFSSL_COMMIT && \
    make && \
    cp -v bin/* /usr/local/bin/

RUN mkdir -p /etc/cfssl /opt/wott/certs
COPY ca-*  /etc/cfssl/
COPY server.json /etc/cfssl/

COPY start.sh /start.sh
CMD /start.sh
