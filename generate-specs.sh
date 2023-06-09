#!/bin/bash

# First argument is path to store output result, must be absolute path
OUTPUT_LOCATION=$1
# Second argument is unique key for hardware unit being analyzed
HARDWARE_KEY=$2
# Final location variable created for writing results
HARDWARE_FOLDER="${OUTPUT_LOCATION}/${HARDWARE_KEY}"

# Generate unique folder at OUTPUT_LOCATION using input HARDWARE_KEY parameter
mkdir $HARDWARE_FOLDER
cd $HARDWARE_FOLDER

# Run hardware spec utilities and either save as JSON or raw text formats
sudo lscpu --json > "${HARDWARE_KEY}_lscpu.json"
sudo lsblk --json > "${HARDWARE_KEY}_lsblk.json"
sudo lspci -vm > "${HARDWARE_KEY}_lspci.txt"
sudo dmidecode -t memory > "${HARDWARE_KEY}_dmidecode_memory.txt"
sudo dmidecode -t bios > "${HARDWARE_KEY}_dmidecode_bios.txt"
sudo dmidecode -t system > "${HARDWARE_KEY}_dmidecode_system.txt"

# Zip all data files in generated folder into single 
# compressed file with HARDWARE_KEY input as file name 
cd ..
zip -r $HARDWARE_KEY.zip $HARDWARE_KEY/

# Remove folder of now zipped data
rm -r $HARDWARE_KEY
