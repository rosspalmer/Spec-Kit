#!/bin/bash

# G
HARDWARE_KEY=$1
OUTPUT_LOCATION=$2
HARDWARE_FOLDER="${OUTPUT_LOCATION}/${HARDWARE_KEY}"

mkdir $HARDWARE_FOLDER
sudo lscpu --json > "${HARDWARE_FOLDER}/${HARDWARE_KEY}_lscpu.json"
sudo lsblk --json > "${HARDWARE_FOLDER}/${HARDWARE_KEY}_lsblk.json"
sudo lspci -vm > "${HARDWARE_FOLDER}/${HARDWARE_KEY}_lspci.txt"
sudo dmidecode -t memory > "${HARDWARE_FOLDER}/${HARDWARE_KEY}_dmidecode_memory.txt"
sudo dmidecode -t bios > "${HARDWARE_FOLDER}/${HARDWARE_KEY}_dmidecode_bios.txt"
sudo dmidecode -t system > "${HARDWARE_FOLDER}/${HARDWARE_KEY}_dmidecode_system.txt"

zip -r "${HARDWARE_FOLDER}.zip" "$HARWARE_FOLDER"

