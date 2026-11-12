#!/bin/bash

set -e

project=$(basename "$DOWNLOAD_URL" | cut -d- -f1)

if [ "$project" = "folia" ] || [ "$project" = "paper" ]; then
  # Writes eula.txt from ACCEPT_EULA and runs without GUI.
  echo "eula=${ACCEPT_EULA:-false}" > eula.txt
  set -- nogui "$@"
fi

exec java -jar /app/server.jar "$@"
