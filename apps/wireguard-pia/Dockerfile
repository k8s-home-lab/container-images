FROM ghcr.io/aste88/wireguard:rolling@sha256:a66f70d94f29f252aecc4f898672546a6f3adb487e824c24115d7c8c7d1f3c4c

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
