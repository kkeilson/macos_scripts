#!/bin/bash

# Clear Adobe AE Cache for each user
# Created by: KKEILSON on 07/07/2022
# Description: Deletes AE cache folder, which is know to cause
#              issues with available storage.

for i in $(ls /Users/ | grep -v macadmin | grep -v Shared | grep -v .localized)
do
  echo "Deleting cache for user $i"
  rm -rf /Users/"$i"/Library/Caches/Adobe/After\ Effects/*
done

exit 0
