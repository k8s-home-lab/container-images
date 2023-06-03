FROM ghcr.io/k8s-at-home/ubuntu-focal:rolling@sha256:c001f386f4860b3353dcb40dceafa4274bd7b77c8aa2def745fec26d58c8a0fd

ARG VERSION
USER root

# hadolint ignore=DL3008,DL3015,SC2086
RUN \
  apt-get -qq update \
  &&\
  apt-get -qq install -y \
    openjdk-11-jre-headless \
    python3 \
    unzip \
  && \
  ln -s /usr/bin/python3 /usr/bin/python \
  && \
  curl -fsSL -o /tmp/nzbhydra2.zip \
    "https://github.com/theotherp/nzbhydra2/releases/download/v${VERSION}/nzbhydra2-${VERSION}-linux.zip" \
  && unzip -q /tmp/nzbhydra2.zip -d /app \
  && curl -fsSL -o /app/nzbhydra2wrapperPy3.py \
    "https://raw.githubusercontent.com/theotherp/nzbhydra2/v${VERSION}/other/wrapper/nzbhydra2wrapperPy3.py" \
  && \
  apt-get remove -y unzip \
  && apt-get purge -y --auto-remove -o APT::AutoRemove::RecommendsImportant=false \
  && apt-get autoremove -y \
  && apt-get clean \
  && \
  rm -rf \
    /tmp/* \
    /var/lib/apt/lists/* \
    /var/tmp/ \
  && chown -R kah:kah /app \
  && chmod -R u=rwX,go=rX /app \
  && printf "umask %d" "${UMASK}" >> /etc/bash.bashrc

USER kah

EXPOSE 5076

COPY ./apps/nzbhydra2/entrypoint.sh /entrypoint.sh
CMD ["/entrypoint.sh"]

LABEL \
  org.opencontainers.image.title="NZBHydra2" \
  org.opencontainers.image.source="https://github.com/theotherp/nzbhydra2" \
  org.opencontainers.image.version="${VERSION}"
