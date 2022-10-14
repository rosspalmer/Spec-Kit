#!/bin/bash

OUTPUT_LOCATION=$1

HOSTNAMECTL=$(hostnamectl)

# Matches lines from `hostnamectl` output
hostnamectl_value () {
  KEY=$1
  VAL=$("$HOSTNAMECTL" | grep "$KEY")
  [[ $VAL =~ ^.+:\s(.+)$ ]] && \
    echo BASH_REMATCH[1]
}

# Use machine ID from hostnamectl as unique identifier
UID=$(hostnamectl_value 'Machine ID')

# Pack hostnamectl values into JSON
HOSTNAME_JSON=$(cat << EOF
{
  "hostname": "$(hostnamectl_value 'hostname')",
  "icon_name": "$(hostnamectl_value 'Icon Name')",
  "chassis": "$(hostnamectl_value 'Chassis')",
  "machine_id": "$(hostnamectl_value 'Machine ID')",
  "operating_system": "$(hostnamectl_value 'Operating System')"
}
EOF
)

echo "$HOSTNAME_JSON"

# Show shorten system information using `lshw` util
lshw -short

