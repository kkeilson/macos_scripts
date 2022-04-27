#!/bin/bash

LICFILE="/usr/local/flexlm/licenses/license.dat"

/Applications/Toon\ Boom\ Harmony\ 20\ Premium/Harmony\ 20\ Premium.app/Contents/Applications/LicenseWizard.app/Contents/MacOS/LicenseWizard --console --install-anchor

if [ ! -e "$LICFILE" ]; then
    /bin/echo "Toom Boom License does not exist"
    /bin/echo "Creating license file"
    /bin/mkdir -p /usr/local/flexlm/licenses
    /bin/echo "SERVER ServerPath 0 27500" > $LICFILE
    /bin/echo "VENDOR toonboom PORT=27500" >> $LICFILE
    /bin/echo "USE_SERVER" >> $LICFILE
    /usr/sbin/chown root:wheel $LICFILE
    /bin/chmod 644 $LICFILE
    /bin/echo "Completed"
else
    /bin/echo "Toom Boom license file already exists"
    /bin/echo "Exiting"
fi
exit 0
