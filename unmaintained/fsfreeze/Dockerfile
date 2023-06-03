FROM docker.io/alpine:3.16.0

ARG TARGETPLATFORM
ARG BUILDPLATFORM
ARG VERSION

RUN \
    apk add --no-cache \
        util-linux==${VERSION}

ENTRYPOINT ["/bin/ash", "-c"]
CMD ["while true; do sleep 3600; done;"]
