#!/bin/bash

# Jamf Pro credentials
JAMF_URL="https://tenant.jamfcloud.com"

# Prompt for Username
read -r -p "Enter your password: " USERNAME

# Prompt for Password
read -r -s -p "Enter your password: " PASSWORD
echo

# Get Bearer Token
token_response=$(curl -s -X POST "${JAMF_URL}/api/v1/auth/token" \
    -u "${USERNAME}:${PASSWORD}" \
    -H "Accept: application/json")

BEARER_TOKEN=$(echo "$token_response" | jq -r .token)

if [ -z "$BEARER_TOKEN" ] || [ "$BEARER_TOKEN" == "null" ]; then
    echo "Failed to retrieve Bearer Token"
    exit 1
fi

echo "Bearer Token retrieved successfully."

# Read serial numbers from a CSV file into an array
SERIAL_NUMBERS=()
CSV_FILE="serial_numbers.csv" # Replace with the path to your CSV file

if [ ! -f "$CSV_FILE" ]; then
    echo "CSV file not found: $CSV_FILE"
    exit 1
fi

while IFS=, read -r SERIAL; do
    SERIAL_NUMBERS+=("$SERIAL")
done < "$CSV_FILE"

# Loop through each serial number
for SERIAL in "${SERIAL_NUMBERS[@]}"; do
    echo "Searching for Serial Number: $SERIAL"
    
    # Get computer details by serial number
    computer_response=$(curl -s -X GET "${JAMF_URL}/JSSResource/computers/serialnumber/$SERIAL" \
        -H "Authorization: Bearer $BEARER_TOKEN" \
        -H "Accept: application/json")
    
    # Extract MAC address using jq
    MAC_ADDRESS=$(echo "$computer_response" | jq -r '.computer.hardware.mac_address')
    
    if [ "$MAC_ADDRESS" == "null" ] || [ -z "$MAC_ADDRESS" ]; then
        echo "No MAC address found for Serial Number: $SERIAL"
    else
        echo "MAC Address for Serial Number $SERIAL: $MAC_ADDRESS"
    fi
done