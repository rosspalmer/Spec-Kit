#!/bin/bash

# NOTE: Most be run with root permissions

# Get root path for spec-ket package
KIT_PATH="$(dirname -- "$(readlink -f "${BASH_SOURCE}")")"

# Clone linux live repo and move to `/tmp`
git clone https://github.com/Tomas-M/linux-live.git
mv -r ./linux-live /tmp/linux-live

# Modify name for generated image
sed -i 's/\bLIVEKITNAME="linux"\b/LIVEKITNAME="spec-kit"/g'

# Copy over logo file
cp "$KIT_PATH/spec-kit-logo.png" /tmp/linux-live/bootfiles/bootlogo.png

# Add persist setting for USB setup
sed -i -E 's/\bAPPEND.+\b/& perch/g' /tmp/linux-live/bootfiles/

# Run linux-live build script to create imagine
sh /tmp/linux-live/build
