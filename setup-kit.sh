#!/bin/bash

# Get shared output location to be stored in the 
OUTPUT_PATH=$1

# Get root path for spec-kit package
ROOT_PATH="$(dirname -- "$(realpath "${BASH_SOURCE:-$0}")")"

echo 'alias spec-kit="sudo sh $ROOT_PATH/spec-kit.sh $OUTPUT_PATH"' >> ~/.bashrc
