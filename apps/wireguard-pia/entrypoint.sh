#!/usr/bin/env bash

set -e

INTERFACE_UP=false

_shutdown () {
    local exitCode=$?
    if [[ ${exitCode} -gt 0 ]]; then
        echo "[ERROR] Received non-zero exit code (${exitCode}) executing the command "${BASH_COMMAND}" on line ${LINENO}."
    else
        echo "[INFO] Caught signal to shutdown."
    fi

    if [[ "${INTERFACE_UP}" == 'true' ]]; then
        echo "[INFO] Shutting down VPN!"
        sudo /usr/bin/wg-quick down "${INTERFACE}"
    fi
}

trap _shutdown EXIT

source "/shim/iptables-backend.sh"

sudo /app/manual-connections/run_setup.sh

CONFIG=`echo $CONFIGS | head -n 1`
INTERFACE="${CONFIG%.*}"

INTERFACE_UP=true

source "/shim/killswitch.sh"

sleep infinity &
wait $!
