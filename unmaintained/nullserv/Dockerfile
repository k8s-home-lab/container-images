FROM golang:alpine AS build-env

ARG TARGETPLATFORM

ENV CGO_ENABLED=0

WORKDIR /apps

# hadolint ignore=DL4006
RUN \
  export GOOS \
  && /bin/ash \
  && apk --no-cache --no-progress add ca-certificates git libcap \
  && GOOS=$(echo ${TARGETPLATFORM} | cut -d / -f1) \
  && export GOARCH \
  && GOARCH=$(echo ${TARGETPLATFORM} | cut -d / -f2) \
  && export GOARM \
  && GOARM=$(echo ${TARGETPLATFORM} | cut -d / -f3 | cut -c2-) \
  && git clone https://github.com/bmrzycki/nullserv.git . \
  && ./mkbuildinfo.sh \
  && go build -a -ldflags '-w -extldflags "-static"' -o nullserv ./*.go

FROM scratch
COPY --from=build-env /apps/nullserv /

ENTRYPOINT ["/nullserv"]
