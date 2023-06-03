FROM ghcr.io/k8s-at-home/ubuntu-jammy:rolling@sha256:d07c99ab3a87b76e4a8460d5d6c2c3ff18d55c20f84e777aa3c2db698e1db075

ARG TARGETPLATFORM
ARG BUILDPLATFORM
ARG VERSION
USER root

ENV \
  SONARR__INSTANCE_NAME="Sonarr" \
  SONARR__BRANCH="widowmaker" \
  SONARR__PORT="8989"

# hadolint ignore=DL3008,DL3015,SC2086
RUN \
  apt-get -qq update \
  && \
  apt-get -qq install -y \
    ca-certificates \
    libicu70 \
    libsqlite3-0 \
    xmlstarlet \
  && \
  case "${TARGETPLATFORM}" in \
    'linux/amd64') export ARCH='x64' ;; \
    'linux/arm64') export ARCH='arm64' ;; \
  esac \
  && \
  curl -fsSL -o /tmp/sonarr.tar.gz \
    "https://sonarr.servarr.com/v1/update/${SONARR__BRANCH}/updatefile?version=${VERSION}&os=linux&runtime=netcore&arch=${ARCH}" \
  && tar ixzf /tmp/sonarr.tar.gz -C /app --strip-components 1 \
  && \
  rm -rf \
    /app/Sonarr.Update* \
  && \
  printf "UpdateMethod=docker\nBranch=%s\nPackageVersion=%s\nPackageAuthor=[Team k8s-at-home](https://github.com/k8s-at-home)" "${SONARR__BRANCH}" "${VERSION}" > /app/package_info \
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

EXPOSE ${SONARR__PORT}/tcp

COPY ./apps/sonarr-nightly/config.xml.tmpl /app/config.xml.tmpl
COPY ./apps/sonarr-nightly/entrypoint.sh /entrypoint.sh
CMD ["/entrypoint.sh"]

LABEL \
  org.opencontainers.image.title="${SONARR__INSTANCE_NAME}" \
  org.opencontainers.image.source="https://github.com/Sonarr/Sonarr" \
  org.opencontainers.image.version="${VERSION}"
