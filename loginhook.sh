#!/bin/bash

# Untar Library folder
# Used as a login hook
# Created by: KKEILSON
# Date modified: 20191204
### Change Log

#### Variables
flagdate="20191204"
dirTemplate="/Library/.Management/mac_template_2019.tar"

# Get User's Home Directory
dirHome=$HOME

# Define flag
fileFlag="$dirHome/.flags/Library.$flagdate"

# Get UID  and GID of console user
#uidNumber=$(id -u "$USER")
#username=$(id -u -n "$USER")
username=$USER
#gidNumber=$(id -g "$USER")

# Run as console user
suExec="/usr/bin/su $username -c"

homespaceCheck(){
  # Set up environment for Admin and Alumni users with temporary local home directory
  if [[ $HOME =~ /Users/ ]]; then
    #Remove NetworkHome link
    $suExec "/bin/chmod 700 $HOME/Desktop"
    $suExec "/bin/rm $HOME/Desktop/$username"
    $suExec "/bin/chmod 500 $HOME/Desktop"
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

createLibrary(){
  $suExec "/usr/bin/tar xzpf $dirTemplate -C $dirHome --exclude='._*'"
  $suExec "/usr/bin/touch $fileFlag"
}

# Check for existing Library Flag
if [ ! -f "$fileFlag" ]; then
    moveLibrary
    createUserHomeDirectories
    createLibrary
    $suExec "/bin/rm $dirHome/._Library"
    $suExec "/bin/chmod -R 755 $dirHome/.flags"
else
    echo "$FILE does exist"
fi

# Copy Home icon to user's Desktop if it does not exist. Then we change permissions so they cannot delete the link or save to the Desktop Directory
# First we check to see if Desktop Directory exists

if [ ! -d "$dirHome/Desktop" ]; then
  # If it does not, create it
  $suExec "/bin/mkdir $dirHome/Desktop"
else
  # If it does, make it writeable
  $suExec "/bin/chmod -R 755 $dirHome/Desktop"
fi

# Check for link on Desktop to Network Home
if [ ! -L "$HOME"/Desktop/"$username" ]; then
  # Create it if it does not exist
  $suExec "/bin/ln -s $HOME $HOME/Desktop"
fi
$suExec "/bin/chmod 500 $HOME/Desktop"
