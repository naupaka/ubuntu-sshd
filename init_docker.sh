#!/bin/sh

chown -R $USER:$USER /data
mkdir /home/$USER
cp /home/.profile /home/$USER/

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
# echo "AllowGroups ssh-users" >> /etc/ssh/sshd_config # couldn't figure out how to add $USER to group

/init
