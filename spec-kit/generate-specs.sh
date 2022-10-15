#!/bin/bash

# OUTPUT_LOCATION=$1

# Get `hostnamectl` values
HOSTNAMECTL=$(hostnamectl)
HOSTNAME=$(echo "$HOSTNAMECTL" | grep "hostname" | awk -F ':' '{ print $2 }' | xargs)
ICON_NAME=$(echo "$HOSTNAMECTL" | grep "Icon name" | awk -F ':' '{ print $2 }' | xargs)
MACHINE_ID=$(echo "$HOSTNAMECTL" | grep "Machine" | awk -F ':' '{ print $2 }' | xargs)

# Pack hostnamectl values into JSON
HOSTNAME_JSON=$(cat << EOF {
  "hostname": "$HOSTNAME"
}
EOF
)

echo "hostnamectl Loaded"
echo "$HOSTNAME_JSON"

# Show shorten system information using `lshw` util
lshw -short

