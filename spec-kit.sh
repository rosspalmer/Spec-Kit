#!/bin/bash

# Get root path for spec-ket package
ROOT_PATH="$(dirname -- "$(readlink -f "${BASH_SOURCE}")")"

# Make spec-data folder in HOME directory if not exists
mkdir -p ~/spec-data

sh "$ROOT_PATH/spec-kit/generate-specs.sh" ~/spec-data
