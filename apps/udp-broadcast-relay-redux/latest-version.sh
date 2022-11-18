#!/usr/bin/env bash

MAJOR_VERSION=1
CHECKOUT_DIR=/tmp/udp-broadcast-relay-redux

if [ -d "${CHECKOUT_DIR}" ]; then
  cd "${CHECKOUT_DIR}"
  git pull > /dev/null
else
  git clone https://github.com/udp-redux/udp-broadcast-relay-redux.git "${CHECKOUT_DIR}" > /dev/null 2>&1
  cd "$CHECKOUT_DIR"
fi

number_of_commits=$(git rev-list --count --first-parent HEAD)

rm -rf "${CHECKOUT_DIR}"

printf "%s.%s.0" "${MAJOR_VERSION}" "${number_of_commits}"
