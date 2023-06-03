FROM ubuntu:jammy

ARG VERSION

ARG TARGETARCH
ENV TARGETARCH=${TARGETARCH:-amd64}

# DEBIAN_FRONTEND: https://askubuntu.com/questions/972516/debian-frontend-environment-variable
# APT_KEY_DONT_WARN_ON_DANGEROUS_USAGE: http://stackoverflow.com/questions/48162574/ddg#49462622
ENV \
  DEBCONF_NONINTERACTIVE_SEEN=true \
  DEBIAN_FRONTEND="noninteractive" \
  APT_KEY_DONT_WARN_ON_DANGEROUS_USAGE=DontWarn

# hadolint ignore=DL3008
RUN \
  apt-get -qq update \
  && apt-get -qq install -y --no-install-recommends \
    bash \
    ca-certificates \
    curl \
    dnsutils \
    jq \
    tzdata \
    zip \
  && curl -fsSL -o /usr/local/bin/kubectl "https://dl.k8s.io/release/v${VERSION}/bin/linux/${TARGETARCH}/kubectl" \
  && chmod +x /usr/local/bin/kubectl \
  && apt-get clean \
  && rm -rf \
    /tmp/* \
    /var/lib/apt/lists/ \
    /var/tmp/*

CMD [ "/usr/local/bin/kubectl" ]

LABEL "maintainer"="Devin Buhl <devin.kray@gmail.com>, Bernd Schorgers <me@bjw-s.dev>"
LABEL "org.opencontainers.image.source"="https://github.com/k8s-at-home/container-images"
