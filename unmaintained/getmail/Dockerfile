FROM ghcr.io/k8s-at-home/ubuntu-focal:rolling@sha256:c001f386f4860b3353dcb40dceafa4274bd7b77c8aa2def745fec26d58c8a0fd

ARG VERSION
USER root

# hadolint ignore=DL3008
RUN \
  apt-get -qq update \
  && apt-get -qq install -y --no-install-recommends \
    python3-pip \
  && pip3 install --no-cache-dir getmail6=="${VERSION}" \
  && apt-get clean \
  && rm -rf \
    /tmp/* \
    /var/lib/apt/lists/ \
    /var/tmp/*

USER kah

CMD [ "/usr/local/bin/getmail" ]
