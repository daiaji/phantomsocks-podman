FROM --platform=${TARGETPLATFORM} golang:alpine as builder

WORKDIR /root
RUN apk add --update git \
	&& git clone https://github.com/macronut/phantomsocks.git \
	&& cd ./phantomsocks \
	&& go build -tags rawsocket

FROM --platform=${TARGETPLATFORM} alpine:latest
WORKDIR /etc/phantomsocks

RUN apk add --no-cache ca-certificates

COPY --from=builder /root/phantomsocks/phantomsocks /usr/bin/
COPY config.json default.conf /etc/phantomsocks/

EXPOSE 1681/tcp
ENTRYPOINT [ "phantomsocks" ]
CMD ["-log", "1"]
