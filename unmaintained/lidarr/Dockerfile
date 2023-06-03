FROM ghcr.io/k8s-at-home/ubuntu-jammy:rolling@sha256:d07c99ab3a87b76e4a8460d5d6c2c3ff18d55c20f84e777aa3c2db698e1db075

ARG TARGETPLATFORM
ARG BUILDPLATFORM
ARG VERSION
USER root

ENV \
  LIDARR__INSTANCE_NAME="Lidarr" \
  LIDARR__BRANCH="master" \
  LIDARR__PORT="8686"

# hadolint ignore=DL3008,DL3015,SC2086
RUN \
  apt-get -qq update \
  && \
  apt-get -qq install -y \
    ca-certificates \
    libchromaprint-tools \
    libicu70 \
    libsqlite3-0 \
    xmlstarlet \
  && \
  case "${TARGETPLATFORM}" in \
    'linux/amd64') export ARCH='x64' ;; \
    'linux/arm64') export ARCH='arm64' ;; \
  esac \
  && \
  curl -fsSL -o /tmp/lidarr.tar.gz \
    "https://lidarr.servarr.com/v1/update/${LIDARR__BRANCH}/updatefile?version=${VERSION}&os=linux&runtime=netcore&arch=${ARCH}" \
  && tar ixzf /tmp/lidarr.tar.gz -C /app --strip-components 1 \
  && \
  rm -rf \
    /app/lidarr.Update* \
  && \
  printf "UpdateMethod=docker\nBranch=%s\nPackageVersion=%s\nPackageAuthor=[Team k8s-at-home](https://github.com/k8s-at-home)" "${LIDARR__BRANCH}" "${VERSION}" > /app/package_info \
  && \
  apt-get autoremove -y \
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

EXPOSE ${LIDARR__PORT}/tcp

COPY ./apps/lidarr/config.xml.tmpl /app/config.xml.tmpl
COPY ./apps/lidarr/entrypoint.sh /entrypoint.sh
CMD ["/entrypoint.sh"]

LABEL \
  org.opencontainers.image.title="${LIDARR__INSTANCE_NAME}" \
  org.opencontainers.image.source="https://github.com/Lidarr/Lidarr" \
  org.opencontainers.image.version="${VERSION}"
