# Build Geth in a stock Go builder container
FROM golang:1.9-alpine as builder

RUN apk add --no-cache make gcc musl-dev linux-headers

ADD . /go-ethzero
RUN cd /go-ethzero && make geth

# Pull Geth into a second stage deploy alpine container
FROM alpine:latest

RUN apk add --no-cache ca-certificates
COPY --from=builder /go-ethzero/build/bin/geth /usr/local/bin/

EXPOSE 9646 9647 21212 21212/udp 21213/udp
ENTRYPOINT ["geth"]
