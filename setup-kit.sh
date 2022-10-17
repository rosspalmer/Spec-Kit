#!/bin/bash

# Get root path for spec-ket package
ROOT_PATH="$(dirname -- "$(readlink -f "${BASH_SOURCE}")")"

sh "$ROOT_PATH/spec-kit/required-kit.sh"

echo "alias spec-kit=\"sh $ROOT_PATH/spec-kit.sh\"" >> ~/.bashrc


