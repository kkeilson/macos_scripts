#!/bin/bash

if [ ! -d "/Users/Shared/TechSmith/Camtasia" ]
then
    mkdir -p /Users/Shared/TechSmith/Camtasia
fi

openssl enc -base64 -d <<< "INSERT BASE64 LicenseKey" > /Users/Shared/TechSmith/Camtasia/LicenseKey

chmod 744 /Users/Shared/TechSmith/Camtasia/LicenseKey

exit 0
