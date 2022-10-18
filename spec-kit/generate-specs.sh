#!/bin/bash

OUTPUT_LOCATION=$1

# Get `hostnamectl` values
HOSTNAMECTL=$(hostnamectl)
HOSTNAME=$(echo "$HOSTNAMECTL" | grep "hostname" | awk -F ':' '{ print $2 }' | xargs)
ICON_NAME=$(echo "$HOSTNAMECTL" | grep "Icon name" | awk -F ':' '{ print $2 }' | xargs)
MACHINE_ID=$(echo "$HOSTNAMECTL" | grep "Machine" | awk -F ':' '{ print $2 }' | xargs)

# Provide short console output for user
hostnamectl
echo
echo "===+=== hostnamectl loaded ===+==="

# Get `lscpu` CPU specs in JSON format
LSCPU_STRING=$(lscpu -J)
END_INDEX=$(expr ${#LSCPU_STRING} - 1)
LSCPU_JSON=$(echo "$LSCPU_STRING" | cut -c2-"$END_INDEX" | xargs -d '\n')

echo "===+=== lscpu loaded ===+==="


# Get `lshw` in JSON format
# FIXME remove outer list
LSHW_JSON=$(lshw -json)

echo "===+=== lshw loaded ===+==="
echo
lshw -short
echo

# Get total memory using `free`
CPU=$(lscpu | grep 'Model name' | awk -F ':' '{print $2}' | xargs)
TOTAL_MEMORY=$(free | awk '{if (NR==2) print $2}')

# Pack final json
OUTPUT_JSON=$(cat << EOF
{

  "hostname": "$HOSTNAME",
  "icon_name": "$ICON_NAME",
  "machine_id": "$MACHINE_ID",
  "cpu_model": "$CPU",
  "total_memory": "$TOTAL_MEMORY",

  "$LSCPU_JSON",

  "lshw": "$LSHW_JSON"

}
EOF
)

FILE_NAME="$OUTPUT_LOCATION/$MACHINE_ID"

# Write json and html files
echo "$OUTPUT_JSON" > "$FILE_NAME.json"
lshw -html > "$FILE_NAME.html"
