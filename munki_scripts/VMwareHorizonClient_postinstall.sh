#!/bin/sh

if [ -d "/Applications/VMware Horizon Client.app" ];
     then
          #Install USB drivers
          /Applications/VMware\ Horizon\ Client.app/Contents/Library/InitUsbServices.tool
fi

exit 0
