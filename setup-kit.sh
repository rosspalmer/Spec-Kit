#!/bin/bash

# Get root path for spec-ket package
ROOT_PATH="$(dirname -- "$(realpath "${BASH_SOURCE:-$0}")")"

# FIXME remove debug print
echo "ROOT PATH: $ROOT_PATH"

su -c "sh ""$ROOT_PATH"/spec-kit/required-kit.sh""

echo "alias spec-kit=\"sh $ROOT_PATH/spec-kit.sh\"" >> ~/.bashrc
