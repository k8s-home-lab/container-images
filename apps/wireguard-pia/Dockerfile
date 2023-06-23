FROM ghcr.io/k8s-home-lab/wireguard:rolling@sha256:ddc5c7a6d34d925132fa7470cfafbbe0f6aad263bf8d409ce1b596d0c27cf1de

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
  && printf "umask %d" "${UMASK:-0002}" >> /etc/bash.bashrc

USER kah
WORKDIR /app/manual-connections

COPY ./apps/wireguard-pia/entrypoint.sh /entrypoint.sh
CMD ["/entrypoint.sh"]
