#!/bin/bash

set -e

sudo mise self-update --yes

mise trust

mise install

echo 'eval "$(mise activate bash)"' >> ~/.bashrc
