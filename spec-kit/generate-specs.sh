#!/bin/bash

# OUTPUT_LOCATION=$1

# Get `hostnamectl` values
HOSTNAMECTL=$(hostnamectl)
HOSTNAME=$(echo "$HOSTNAMECTL" | grep "hostname" | awk -F ':' '{ print $2 }' | xargs)
ICON_NAME=$(echo "$HOSTNAMECTL" | grep "Icon name" | awk -F ':' '{ print $2 }' | xargs)
MACHINE_ID=$(echo "$HOSTNAMECTL" | grep "Machine" | awk -F ':' '{ print $2 }' | xargs)

# Pack hostnamectl values into JSON
HOSTNAME_JSON=$(cat << EOF
{
  "hostname": "$HOSTNAME",
  "icon_name": "$ICON_NAME",
  "machine_id": "$MACHINE_ID"
}
EOF
)

echo "===+=== hostnamectl loaded ===+==="
echo
echo "$HOSTNAME_JSON"
echo

# Get `lshw` in JSON format
LSHW_JSON=$(lshw -json)

echo "===+=== lshw loaded ===+==="
echo
lshw -short
echo

# Get `lscpu` CPU specs in JSON format
LSCPU_JSON=$(lscpu -J)

echo "===+=== lscpu loaded ===+==="
echo
lscpu
echo

# Get `lspci` PCI specs in JSON format
LSPCI_JSON=$(lspci -J)

echo "===+=== lspci loaded ===+==="
echo
lspci
echo