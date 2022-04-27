#!/bin/bash

if [ -d "/Applications/Toon Boom Storyboard Pro 7" ]; then

	/bin/rm -rf /Applications/Toon\ Boom\ Storyboard\ Pro\ 7

	pkgutil --forget com.company.pkg.toonboom.storyboard

fi
