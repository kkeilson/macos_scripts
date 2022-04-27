#!/bin/bash

if [ -d "/Applications/Toon Boom Harmony 17 Premium" ]; then

	/bin/rm -rf /Applications/Toon\ Boom\ Harmony\ 17\ Premium

	pkgutil --forget com.company.pkg.toonboom.harmony

fi
