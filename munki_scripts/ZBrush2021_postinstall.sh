#!/bin/sh

'/Applications/ZBrush_2021.6.6_FL_Installer.app/Contents/MacOS/installbuilder.sh' --mode unattended

/usr/bin/sed -i -e 's|\[IPress|//\[IPress|g' "/Applications/ZBrush 2021 FL/ZScripts/DefaultZScript.txt"

/bin/rm -rf '/Applications/ZBrush_2021.6.6_FL_Installer.app/'

exit 0
