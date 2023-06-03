FROM docker.io/golang:1.18.5-alpine as builder

ARG TARGETPLATFORM
ARG BUILDPLATFORM
ARG VERSION

ENV CGO_ENABLED=0 \
    GOPATH=/go \
    GOBIN=/go/bin \
    GO111MODULE=on

WORKDIR /go/src/coredns

# We apply cap_net_bind_service so that coredns can be run as
# non-root and still listen on port less than 1024

# hadolint ignore=DL4006
RUN \
  export GOOS \
  && GOOS=$(echo ${TARGETPLATFORM} | cut -d / -f1) \
  && export GOARCH \
  && GOARCH=$(echo ${TARGETPLATFORM} | cut -d / -f2) \
  && export GOARM \
  && GOARM=$(echo ${TARGETPLATFORM} | cut -d / -f3 | cut -c2-) \
  && apk --no-cache --no-progress add ca-certificates git libcap \
  && git clone https://github.com/coredns/coredns.git --branch "v${VERSION}" --depth 1 --single-branch .

# Enable plugins
# hadolint ignore=DL3059
RUN sed -i '/^kubernetes:kubernetes/a k8s_gateway:github.com/ori-edge/k8s_gateway' plugin.cfg
# hadolint ignore=DL3059
RUN sed -i '/^sign:sign/a mdns:github.com/openshift/coredns-mdns' plugin.cfg
# hadolint ignore=DL3059
RUN sed -i '/^mdns:github/a alternate:github.com/coredns/alternate' plugin.cfg
# hadolint ignore=DL3059
RUN sed -i '/^alternate:github/a wgsd:github.com/jwhited/wgsd' plugin.cfg

# hadolint ignore=DL3059
RUN \
  go get github.com/ori-edge/k8s_gateway \
  && go get github.com/coredns/alternate \
  && go get github.com/openshift/coredns-mdns \
  && go get github.com/jwhited/wgsd \
  && go generate \
  && go mod tidy \
  && go build -ldflags "-s -w -X github.com/coredns/coredns/coremain.GitCommit=$(git describe --always)" -o coredns \
  && setcap cap_net_bind_service=+ep ./coredns

FROM gcr.io/distroless/static:nonroot

ARG VERSION

COPY --from=builder /go/src/coredns/coredns /coredns
COPY --from=builder /etc/ssl/certs/ca-certificates.crt /etc/ssl/certs/

COPY ./apps/coredns/Corefile /config/Corefile

USER nonroot:nonroot

EXPOSE 53 53/udp

CMD ["/coredns", "-conf", "/config/Corefile"]

LABEL org.opencontainers.image.title="CoreDNS" \
      org.opencontainers.image.source="https://github.com/coredns/coredns" \
      org.opencontainers.image.authors="Anthony Rabbito <hello@anthonyrabbito.com>" \
      org.opencontainers.image.version="${VERSION}" \
      coredns-external-plugins="alternate, mdns, wgsd, k8s_gateway"
