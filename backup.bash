#!/bin/bash
#
# Backup
#
# Author: eric.dortmans@gmail.com

SOURCE=utils
DESTINATION=/media/eric/EricsBackup

# Flags suitable for ExFAT partition
# http://blog.marcelotmelo.com/linux/ubuntu/rsync-to-an-exfat-partition/
# https://www.scivision.co/rsync-to-exfat-drive/
#FLAGS="-rtD --exclude=*~ --cvs-exclude --delete --progress"
FLAGS="-vrltD --exclude=*~ --cvs-exclude --delete --progress --stats"

#echo $FLAGS

if [ -n "${1}" ]; then
    SOURCE="${1}"
fi

rsync ${FLAGS} ${SOURCE}/ ${DESTINATION}/${SOURCE}
diff -r ${SOURCE} ${DESTINATION}/${SOURCE}
