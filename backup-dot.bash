#!/bin/bash
#
# Backup dot-files
#
# Author: eric.dortmans@gmail.com

SOURCE=".bashrc .robot .ros"
DESTINATION=/media/eric/EricsBackup/dotfiles

# Flags suitable for ExFAT partition
# http://blog.marcelotmelo.com/linux/ubuntu/rsync-to-an-exfat-partition/
FLAGS="-rtD --exclude=*~ --delete --progress"

if ! [ -d ${DESTINATION} ]; then
    mkdir -p ${DESTINATION}
fi

for FILE in $SOURCE; 
do
    #cp -R $FILE $DESTINATION
    rsync ${FLAGS} ${FILE} ${DESTINATION}
    echo backup $FILE
done





