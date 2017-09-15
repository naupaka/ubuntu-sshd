#!/bin/sh

# Create new user
useradd --shell /bin/bash -m -d /home $1
echo "$1:$2" | chpasswd

/usr/sbin/sshd -D
