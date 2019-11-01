#!/bin/bash
#
# After running this, the SSH, SCP or RSYNC command will never ask for your password any more.
#
# Usage: authMe hostName
#
# If necessary it will create a public/private keypair for you, then it will ssh 
# over to the other machine and copy your public key over. The ssh command will 
# prompt you for a password...for the last time.
#

ALGO=rsa # or dsa

if [ ! -f ~/.ssh/id_${ALGO}.pub ]
then
    echo 'id_${ALGO}.pub does not exist, creating'
    ssh-keygen -t ${ALGO}

fi
echo "Login as the remote user which you plan to use when you run ssh, scp, or rsync"
ssh $1 'cat >>.ssh/authorized_keys' <~/.ssh/id_${ALGO}.pub
#ssh $1 chmod 700 ~/.ssh/authorized_keys

