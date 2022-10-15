#!/bin/bash

# OUTPUT_LOCATION=$1

# Get `hostnamectl` values and trim
HOSTNAMECTL=$(hostnamectl | xargs)
echo "$HOSTNAMECTL"

# Use machine ID from hostnamectl as unique identifier
UID=$(echo "$HOSTNAMECTL" | grep "Machine" | awk -F ':' '{ print $2 }')
echo "Unique ID: $UID"

# Pack hostnamectl values into JSON
HOSTNAME_JSON="{$(echo "$HOSTNAMECTL" | awk -F ':' '{ print $1 $2 }')}"

echo "$HOSTNAME_JSON"

# Show shorten system information using `lshw` util
lshw -short

