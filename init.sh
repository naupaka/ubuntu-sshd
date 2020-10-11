#!/bin/sh

# Create new user
useradd --shell /bin/bash -m -d /home $1
echo "$1:$2" | chpasswd
chown -R $1:$1 /home
chown -R $1:$1 /data

## Setup SSH and cron. s6 supervisor already installed for RStudio, so
## just create the run and finish scripts
mkdir -p /var/run/sshd
mkdir -p /etc/services.d/sshd
echo "#!/bin/bash
exec /usr/sbin/sshd -D
" > /etc/services.d/sshd/run
echo "#!/bin/bash
service ssh stop
" > /etc/services.d/sshd/finish
sed -i 's/PermitRootLogin no/PermitRootLogin yes/' /etc/ssh/sshd_config
echo "PasswordAuthentication yes" >> /etc/ssh/sshd_config
echo "AllowGroups ssh-users" >> /etc/ssh/sshd_config
