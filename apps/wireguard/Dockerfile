FROM ghcr.io/aste88/ubuntu-focal:rolling@sha256:dcd1c67f0944051da3eacfcbfee0afe173ab065398058f117bb6314684ee9581

ARG VERSION
USER root
COPY ./apps/wireguard/build /build
WORKDIR /tmp

# hadolint ignore=DL3008,DL3015,SC2086
RUN \
  export EXTRA_INSTALL_ARG="build-essential git" \
  && apt-get -qq update \
  && \
  apt-get -qq install -y \
    iptables \
    iproute2 \
    openresolv \
    inetutils-ping \
    sudo \
    ${EXTRA_INSTALL_ARG} \
  && git clone https://git.zx2c4.com/wireguard-tools . \
  && git clone https://git.zx2c4.com/wireguard-linux-compat \
  && git checkout "v${VERSION}" \
  && make -C src -j"$(nproc)" \
  && make -C src install \
  && sed -i "s:sysctl -q net.ipv4.conf.all.src_valid_mark=1:# skipping setting net.ipv4.conf.all.src_valid_mark:" /usr/bin/wg-quick \
  && mv /build/sudoers_kah /etc/sudoers.d/kah \
  && chown root:root /etc/sudoers.d/* \
  && chmod 644 /etc/sudoers.d/* \
  && \
  apt-get remove -y ${EXTRA_INSTALL_ARG} \
  && apt-get purge -y --auto-remove -o APT::AutoRemove::RecommendsImportant=false \
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

COPY ./apps/wireguard/shim/* /shim/
COPY ./apps/wireguard/entrypoint.sh /entrypoint.sh
CMD ["/entrypoint.sh"]
