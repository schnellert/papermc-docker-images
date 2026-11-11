#!/bin/bash

set -e

project="${DOWNLOAD_URL##*/}"
project="${project%%-*}"

if [ "$project" = "folia" ] || [ "$project" = "paper" ]; then
  echo "eula=${ACCEPT_EULA:-false}" > /data/eula.txt
  set -- nogui "$@"
fi

exec java -jar /app/runtime.jar "$@"
