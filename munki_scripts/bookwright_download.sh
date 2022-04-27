#!/bin/bash

PATH=/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin:/usr/local/munki export PATH

# Vendor supplied DMG file
#VendorDMG="BookWright.dmg"

# Download vendor supplied DMG file into /tmp/
#curl https://downloads.blurb.com/bookwright_v2/1.3.6/BookWright.dmg -o /tmp/$VendorDMG
#curl -L http://www.blurb.com/booksmart_download/bookwright?platform=mac -o /tmp/$VendorDMG

#curl -L http://www.blurb.com/booksmart_download/bookwright?platform=mac -o /tmp/BookWright.dmg

curl -L https://downloads.blurb.com/booksmart_download/bookwright?platform=mac -o /tmp/BookWright.dmg

# Mount vendor supplied DMG File
#hdiutil attach /tmp/$VendorDMG -nobrowse
hdiutil attach /tmp/BookWright.dmg -nobrowse

# Copy contents of vendor supplied DMG file to /Applications/
# Preserve all file attributes and ACLs
cp -pPR /Volumes/BookWright/BookWright.app /Applications/

# Identify the correct mount point for the vendor supplied DMG file
#BookWrightDMG="$(hdiutil info | grep "/Volumes/BookWright" | awk '{ print $1 }')"

# Unmount the vendor supplied DMG file
#hdiutil detach $BookWrightDMG

hdiutil detach $(hdiutil info | grep "/Volumes/BookWright" | awk '{ print $1 }')

# Remove the downloaded vendor supplied DMG file
#rm -f /tmp/$VendorDMG
rm -rf /tmp/BookWright.dmg


exit 0
