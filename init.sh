#!/bin/sh

# Create new user
useradd --shell /bin/bash -m -d /home $1
echo "$1:$2" | chpasswd
chown -R $1:$1 /home

BLASTDB=$BLASTDB:/blast-db
PATH=$PATH:/home/code

/usr/sbin/sshd -D
