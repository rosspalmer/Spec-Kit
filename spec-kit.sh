#!/bin/bash

# Get root path for spec-ket package
ROOT_PATH="$(dirname -- "$(realpath "${BASH_SOURCE:-$0}")")"

echo "FIXME: ROOT $ROOT_PATH"

# Make spec-data folder in HOME directory if not exists
mkdir -p ~/spec-data

su -c "sh $ROOT_PATH/spec-kit/generate-specs.sh $HOME/spec-data"
