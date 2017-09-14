#!/bin/sh

# Create new user
useradd --shell /bin/bash $1
sudo echo '$1:$2' | chpasswd

/usr/sbin/sshd -D
