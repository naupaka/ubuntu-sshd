#!/bin/bash

# Create new user
useradd --shell /bin/bash $1
echo '$1:$2' | chpasswd

/usr/sbin/sshd -D
