#!/bin/bash

OUTPUT_LOCATION=$1

# Get `hostnamectl` values
HOSTNAMECTL=$(hostnamectl)
HOSTNAME=$(echo "$HOSTNAMECTL" | grep "hostname" | awk -F ':' '{ print $2 }' | xargs)
ICON_NAME=$(echo "$HOSTNAMECTL" | grep "Icon name" | awk -F ':' '{ print $2 }' | xargs)
MACHINE_ID=$(echo "$HOSTNAMECTL" | grep "Machine" | awk -F ':' '{ print $2 }' | xargs)

echo "===+=== hostnamectl loaded ===+==="
echo
echo "hostname -> $HOSTNAME"
echo "icon_name -> $ICON_NAME"
echo "machine_id -> $MACHINE_ID"
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

# Get `lshw` in JSON format
LSHW_JSON=$(lshw -json)

echo "===+=== lshw loaded ===+==="
echo
lshw -short
echo

# Get total memory using `free`
TOTAL_MEMORY=$(free | awk '{if (NR==2) print $2}')

# Pack final json
OUTPUT_JSON=$(cat << EOF
{

  "hostname": "$HOSTNAME",
  "icon_name": "$ICON_NAME",
  "machine_id": "$MACHINE_ID",
  "cpu": "TODO",
  "total_memory": "$TOTAL_MEMORY",

  "lscpu": "$LSCPU_JSON",

  "lspci": "$LSPCI_JSON",

  "lshw": "$lshw"

}
EOF
)

OUTPUT_JSON > "$OUTPUT_LOCATION/$MACHINE_ID.json"