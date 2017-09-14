#!/bin/sh

# Create new user
useradd --shell /bin/bash $1
echo '$1:$2' | sudo chpasswd

/usr/sbin/sshd -D
