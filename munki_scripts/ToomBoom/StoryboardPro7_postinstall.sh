#!/bin/bash

LICFILE="/usr/local/flexlm/licenses/license.dat"

/Applications/Toon\ Boom\ Storyboard\ Pro\ 7/Storyboard\ Pro\ 7.app/Contents/Tools/LicenseWizard.app/Contents/MacOS/LicenseWizard --console --install-anchor

if [ ! -e "$LICFILE" ]; then
    /bin/echo "Toom Boom License does not exist"
    /bin/echo "Seralizing"
    /bin/mkdir -p /usr/local/flexlm/licenses
    /bin/echo "SERVER ServerPath 0 27500" > $LICFILE
    /bin/echo "VENDOR toonboom PORT=27500" >> $LICFILE
    /bin/echo "USE_SERVER" >> $LICFILE
    /usr/sbin/chown root:wheel $LICFILE
    /bin/chmod 644 $LICFILE
    /bin/echo "Completed"
else
    /bin/echo "Toom Boom License file already exists"
    /bin/echo "Exiting"
fi
exit 0
