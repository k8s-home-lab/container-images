FROM ghcr.io/k8s-at-home/ubuntu-focal:rolling@sha256:c001f386f4860b3353dcb40dceafa4274bd7b77c8aa2def745fec26d58c8a0fd as builder

ARG TARGETPLATFORM
ARG BUILDPLATFORM
ARG VERSION

USER root
WORKDIR /tmp

RUN \
  echo "**** set the platform ****" \
  && \
  case "${TARGETPLATFORM}" in \
    'linux/amd64') \
      export ARCH='x86_64'; \
    ;; \
    'linux/arm64') \
      export ARCH='aarch64'; \
    ;; \
  esac \
  && \
  echo "**** install packages ****" \
  && \
  apt-get update \
  && \
  apt-get install -y \
    cpio \
    rpm2cpio \
  && \
  echo "**** install emby ****" \
  && \
  mkdir -p /app/emby \
  && \
  curl -o \
    emby.rpm -L \
    "https://github.com/MediaBrowser/Emby.Releases/releases/download/${VERSION}/emby-server-rpm_${VERSION}_${ARCH}.rpm" \
  && \
  rpm2cpio emby.rpm \
    | cpio -i --make-directories \
  && \
  mv -t \
    /app/emby \
    /tmp/opt/emby-server/system/* \
    /tmp/opt/emby-server/lib/* \
    /tmp/opt/emby-server/bin/ff* \
    /tmp/opt/emby-server/etc \
    /tmp/opt/emby-server/extra/lib/*

FROM ghcr.io/k8s-at-home/ubuntu-focal:rolling@sha256:c001f386f4860b3353dcb40dceafa4274bd7b77c8aa2def745fec26d58c8a0fd

ARG TARGETPLATFORM
ARG BUILDPLATFORM
ARG VERSION

USER root
ENV NVIDIA_DRIVER_CAPABILITIES="compute,video,utility"

RUN \
  case "${TARGETPLATFORM}" in \
    'linux/amd64') \
      export EXTRA_INSTALL_ARG='mesa-va-drivers'; \
    ;; \
    'linux/arm64') \
      curl -s "https://keyserver.ubuntu.com/pks/lookup?op=get&search=0x6587ffd6536b8826e88a62547876ae518cbcf2f2" | apt-key add - \
      && echo "deb http://ppa.launchpad.net/ubuntu-raspi2/ppa-nightly/ubuntu focal main">> /etc/apt/sources.list.d/raspbins.list \
      && \
      export EXTRA_INSTALL_ARG='libomxil-bellagio0 libomxil-bellagio-bin libraspberrypi0'; \
      unset NVIDIA_DRIVER_CAPABILITIES; \
    ;; \
  esac \
  && \
  apt-get update && \
  apt-get install -y --no-install-recommends \
    libva2 ${EXTRA_INSTALL_ARG} \
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

COPY --from=builder /app/emby /app/emby
USER kah
WORKDIR /app

EXPOSE 8096 8920

COPY ./apps/emby/entrypoint.sh /entrypoint.sh
CMD ["/entrypoint.sh"]
