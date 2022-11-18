FROM docker.io/alpine:3.16 AS builder
ARG VERSION

WORKDIR /build

# hadolint ignore=DL4006,DL3018
RUN \
  apk add --no-cache \
    gcc \
    git \
    musl-dev \
    linux-headers \
  && git clone https://github.com/udp-redux/udp-broadcast-relay-redux.git . \
  && if [ -n "$VERSION" ]; then \
    NUMBER_COMMITS_TO_REVERT=$(( $(git rev-list --count --first-parent HEAD) - $(echo $VERSION|cut -d "." -f2) )); \
    git checkout "master~$NUMBER_COMMITS_TO_REVERT"; \
  fi \
  && gcc -g main.c -o udp-broadcast-relay-redux

FROM docker.io/alpine:3.16
WORKDIR /app
RUN \
  apk add --no-cache \
    bash
COPY --from=builder /build/udp-broadcast-relay-redux .
COPY ./apps/udp-broadcast-relay-redux/entrypoint.sh /entrypoint.sh
CMD ["/entrypoint.sh"]
