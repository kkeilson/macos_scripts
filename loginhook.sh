#!/bin/bash

# Untar Library Folder
# Created by: KKEILSON
# Date modified: 20191205
##############
### Change Log
###
### 20191204 - Initial commit
### 20191205 - Updated script to remove testing variables.
###            Tested and confirmed script is untaring under
###            user's home directory.
##############


#### Variables
flagdate="20191204"
dirTemplate="/Library/.Management/mac_template_2019.tar"

### Functions

homespaceCheck() {
  # Set up environment for Admin and Alumni users with temporary local home directory
  if [[ $dirHome =~ /Users/ ]]; then
    #Remove NetworkHome link
    $suExec "/bin/chmod 700 $dirHome/Desktop"
    $suExec "/bin/rm $dirHome/Desktop/$username"
    $suExec "/bin/chmod 500 $dirHome/Desktop"
    /usr/bin/open /Library/.Management/LocalAlert.app
    exit 0
  fi
}

moveLibrary() {
  todayDate=$(date +%Y%m%d)
  $suExec "/bin/mv $dirHome/Library $dirHome/Library.$todayDate"
}

createUserHomeDirectories() {
  folder_array=(Desktop Documents Music Pictures Movies .flags)
  for i in "${folder_array[@]}"
  do
     /bin/mkdir -p "$dirHome/$i"
  done
}

createLibrary() {
  $suExec "/usr/bin/tar xzpf $dirTemplate -C $dirHome --exclude='._*'"
  $suExec "/usr/bin/touch $fileFlag"
}

createDesktop() {
  # Copy Home icon to user's Desktop if it does not exist. Then we change permissions so they cannot delete the link or save to the Desktop Directory
  # First we check to see if Desktop Directory exists

  if [ ! -d "$dirHome/Desktop" ]; then
    # If it does not, create it
    $suExec "/bin/mkdir $dirHome/Desktop"
  else
    # If it does, make it writeable
    $suExec "/bin/chmod -R 755 $dirHome/Desktop"
  fi
}

createNetworkHome() {
  # Check for link on Desktop to Network Home
  if [ ! -L "$dirHome"/Desktop/"$username" ]; then
    # Create it if it does not exist
    $suExec "/bin/ln -s $dirHome $dirHome/Desktop"
  fi
  $suExec "/bin/chmod 500 $dirHome/Desktop"
}

##############################################
# NO CONFIGURATION NECESSARY BELOW THIS LINE #
##############################################

# Get UID  and GID of console user
sleep 5
username=$(logname)

# Run as console user
suExec="/usr/bin/su $username -c"

# Get User's Home Directory
dirHome=$($suExec "echo ~")

# Define library flag location
fileFlag="$dirHome/.flags/Library.$flagdate"

# Check if user is logged in as local or network account
homespaceCheck

# Check for existing Library Flag
if [ ! -f "$fileFlag" ]; then
    moveLibrary
    createUserHomeDirectories
    createLibrary
    $suExec "/bin/rm $dirHome/._Library"
    $suExec "/bin/chmod -R 755 $dirHome/.flags"
fi

# Create Desktop folder
createDesktop

# Create Network Home icon
createNetworkHome

exit 0
