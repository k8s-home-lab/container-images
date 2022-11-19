FROM ghcr.io/aste88/wireguard:rolling@sha256:3ee036e2102ae4efe7790ea25c4fdd0a43e15e455b71c5096574771bbc61ca69

ARG VERSION
USER root
COPY ./apps/wireguard-pia/build /build
WORKDIR /tmp

# hadolint ignore=DL3008,DL3015,SC2086
RUN \
  apt-get -qq update \
  && \
  apt-get -qq install -y \
    curl \
    jq \
    unzip \
  && \
  curl -fsSL -o /tmp/app.zip "https://github.com/pia-foss/manual-connections/archive/refs/tags/v${VERSION}.zip" \
  && unzip -q /tmp/app.zip -d  /tmp \
  && mv /tmp/manual-connections-${VERSION} /app/manual-connections \
  && \
  rm /etc/sudoers.d/kah \
  && mv /build/sudoers_kah /etc/sudoers.d/kah \
  && chown root:root /etc/sudoers.d/* \
  && chmod 644 /etc/sudoers.d/* \
  && \
  apt-get purge -y --auto-remove -o APT::AutoRemove::RecommendsImportant=false \
  && apt-get autoremove -y \
  && apt-get clean \
  && \
  rm -rf \
    /tmp/* \
    /var/lib/apt/lists/* \
    /var/tmp/ \
    /build \
  && chmod -R u=rwX,go=rX /app \
  && printf "umask %d" "${UMASK}" >> /etc/bash.bashrc

USER kah
WORKDIR /app/manual-connections

COPY ./apps/wireguard-pia/entrypoint.sh /entrypoint.sh
CMD ["/entrypoint.sh"]
