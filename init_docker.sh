#!/bin/sh
set -eu

# Create the requested user if not the default rstudio account.
# Newer rocker images no longer honor -e USER=..., so we do it ourselves.
if [ -n "${USER:-}" ] && [ "${USER}" != "rstudio" ] && ! id "${USER}" >/dev/null 2>&1; then
    useradd -m -s /bin/bash -G staff,sudo "${USER}"
    if [ -n "${PASSWORD:-}" ]; then
        echo "${USER}:${PASSWORD}" | chpasswd
    fi
fi

# Set up their data directory and a copy of the default profile
chown -R "${USER}:${USER}" /data
mkdir -p "/home/${USER}"
cp /home/.profile "/home/${USER}/.profile"
chown "${USER}:${USER}" "/home/${USER}/.profile"

# Setup SSH under the s6 supervisor that rocker already runs for RStudio
mkdir -p /var/run/sshd /etc/services.d/sshd

cat > /etc/services.d/sshd/run <<'EOF'
#!/bin/bash
exec /usr/sbin/sshd -D
EOF

cat > /etc/services.d/sshd/finish <<'EOF'
#!/bin/bash
service ssh stop
EOF

chmod +x /etc/services.d/sshd/run /etc/services.d/sshd/finish

# Make sure password auth is actually enabled (handles include-dir overrides on modern Ubuntu)
sed -i 's/^#*PasswordAuthentication.*/PasswordAuthentication yes/' /etc/ssh/sshd_config
sed -i 's/^#*PermitRootLogin.*/PermitRootLogin yes/' /etc/ssh/sshd_config
mkdir -p /etc/ssh/sshd_config.d
echo "PasswordAuthentication yes" > /etc/ssh/sshd_config.d/00-password-auth.conf

exec /init