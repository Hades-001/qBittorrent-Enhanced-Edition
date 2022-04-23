#!/bin/sh

set -eu

if [ "$(id -u)" = '0' ]; then
  chown -R "${PUID}:${PGID}" "${CONFIGURATION}" && \
  chown -R "${PUID}:${PGID}" "${DOWNLOADS}" && \
  chown -R "${PUID}:${PGID}" "${TORRENTS}" && \
  exec gosu "${PUID}:${PGID}" "$@"
else
  exec "$@"
fi
