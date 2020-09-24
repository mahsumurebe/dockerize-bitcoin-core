#!/usr/bin/env bash
set -e

chown -R bitcoin "${COIN_ROOT_DIR}/"

if [ "$(echo "$1" | cut -c1)" = "-" ]; then
  set -- bitcoind "$@"
fi

if [ "$1" = "bitcoind" ] || [ "$1" = "bitcoin-cli" ]; then
  # Set config file
  set -- "$@" -conf="$COIN_CONF_FILE"
fi
if [ "$1" = "bitcoind" ]; then
  # Set config file
  set -- "$@" -printtoconsole
fi

if [ "$1" = "bitcoind" ] || [ "$1" = "bitcoin-cli" ] || [ "$1" = "bitcoin-tx" ]; then
  exec gosu bitcoin "$@"
else
  exec "$@"
fi
