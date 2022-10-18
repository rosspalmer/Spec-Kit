#!/bin/bash

# NOTE: Most be run with root permissions

# Install requirements for linux-live setup
apt-get install git
apt-get install squashfs-tools
apt-get install genisoimage

# Get root path for spec-ket package
KIT_PATH="$(dirname -- "$(realpath "${BASH_SOURCE:-$0}")")"

# Clone linux live repo and move to `/tmp`
git clone https://github.com/Tomas-M/linux-live.git
cp -r ./linux-live /tmp/linux-live
rm -r ./linux-live

# Modify name for generated image
sed -i 's/\bLIVEKITNAME="linux"\b/LIVEKITNAME="spec-kit"/g'

# Copy over logo file
cp "$KIT_PATH/spec-kit-logo.png" /tmp/linux-live/bootfiles/bootlogo.png

# Add persist setting for USB setup
sed -i -E 's/\bAPPEND.+\b/& perch/g' /tmp/linux-live/config

# Run linux-live build script to create imagine
sh /tmp/linux-live/build
