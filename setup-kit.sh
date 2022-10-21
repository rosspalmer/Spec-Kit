#!/bin/bash

# Get root path for spec-kit package
ROOT_PATH="$(dirname -- "$(realpath "${BASH_SOURCE:-$0}")")"

sudo sh $ROOT_PATH/spec-kit/required-kit.sh

echo "alias spec-kit=\"sh $ROOT_PATH/spec-kit.sh\"" >> ~/.bashrc
