#!/bin/bash

# G
HARDWARE_KEY=$1
OUTPUT_LOCATION=$2
HARDWARE_FOLDER="${OUTPUT_LOCATION}/${HARDWARE_KEY}"

mkdir $HARDWARE_FOLDER
lscpu --json > "${HARDWARE_FOLDER}/${HARDWARE_KEY}_lscpu.json"
lsblk --json > "${HARDWARE_KEY}_lsblk.json"
lspci --vm > "${HARDWARE_KEY}_lspci.txt"
dmidecode -t memory > "${HARDWARE_FOLDER}/${HARDWARE_KEY}_dmidecode_memory.txt"
dmidecode -t bios > "${HARDWARE_FOLDER}/${HARDWARE_KEY}_dmidecode_bios.txt"
dmidecode -t system > "${HARDWARE_FOLDER}/${HARDWARE_KEY}_dmidecode_system.txt"

zip -r "${HARDWARE_FOLDER}.zip" $HARWARE_FOLDER

