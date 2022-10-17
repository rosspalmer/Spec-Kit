#!/bin/bash

RUN_MODE=$1

if [ "$RUN_MODE" == 'spec-only' ] || [ "$RUN_MODE" == 'linux-live' ]; then

  # Install required packages for spec job
  apt-get install lshw

  # Install required packages
  if [ "$RUN_MODE" == 'linux-live' ]; then
    apt-get install git
    apt-get install squashfs-tools
    apt-get install genisoimage
  fi

else

  echo "Incorrect run-mode argument $RUN_MODE: Use spec-only or linux-live"

fi