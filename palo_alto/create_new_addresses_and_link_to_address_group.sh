#!/bin/bash
# Created by: KKEILSON on 20250409

# Palo Alto Firewall credentials
FIREWALL_IP="192.168.1.1"  # Replace with your firewall IP
read -r -p "Enter Firewall Username: " USERNAME
read -r -s -p "Enter Firewall Password: " PASSWORD
echo  # Add a newline after the password prompt

# JSON file URL
JSON_URL="https://s3.amazonaws.com/okta-ip-ranges/ip_ranges.json"

# Address group name to add IPs to
ADDRESS_GROUP_NAME="Okta_US_Cell_1"

# Temporary file to store the JSON data
TEMP_JSON_FILE="/tmp/okta_ip_ranges.json"

# Fetch the JSON file
echo "Fetching JSON data from $JSON_URL..."
curl -s -o "$TEMP_JSON_FILE" "$JSON_URL"
if [[ $? -ne 0 ]]; then
    echo "Failed to download JSON file."
    exit 1
fi

# Extract IPs from the "us_cell_1" key
IP_LIST=$(jq -r '.us_cell_14[]' "$TEMP_JSON_FILE")
if [[ -z "$IP_LIST" ]]; then
    echo "No IPs found under 'us_cell_1'."
    exit 1
fi

# Initialize a counter for naming
COUNTER=1

# Loop through each IP and add it to the firewall
for IP in $IP_LIST; do
    # Generate a sequential name for the address object
    ADDRESS_NAME="okta_14_$COUNTER"

    # Create an address object for the IP
    echo "Adding address object: $ADDRESS_NAME for IP: $IP..."
    curl -k -u "$USERNAME:$PASSWORD" -X POST "https://$FIREWALL_IP/api/" \
        -d "type=config&action=set&xpath=/config/devices/entry/vsys/entry/address&element=<entry name='$ADDRESS_NAME'><ip-netmask>$IP</ip-netmask></entry>"

    # Add the address object to the address group
    echo "Adding $ADDRESS_NAME to address group $ADDRESS_GROUP_NAME..."
    curl -k -u "$USERNAME:$PASSWORD" -X POST "https://$FIREWALL_IP/api/" \
        -d "type=config&action=set&xpath=/config/devices/entry/vsys/entry/address-group/entry[@name='$ADDRESS_GROUP_NAME']/static&element=<member>$ADDRESS_NAME</member>"

    # Increment the counter
    COUNTER=$((COUNTER + 1))
done

# Commit the changes
echo "Committing changes to the firewall..."
curl -k -u "$USERNAME:$PASSWORD" -X POST "https://$FIREWALL_IP/api/" \
    -d "type=commit&cmd=<commit></commit>"

echo "Script execution completed."