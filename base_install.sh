#!/bin/bash
UPDATES=/scripts/updates.sh
HOSTNAMEFILE=/etc/hostname
read -p 'Hostname: ' HOSTNAME
echo "$HOSTNAME" | tee /etc/hostname >/dev/null
sed -i "s/template/${HOSTNAME}/g" /etc/hosts
apt update
apt install joe
apt install fail2ban
mkdir /scripts/
mkdir /scripts/logs
if test -f "$UPDATES"; then
	rm -rf /scripts/updates.sh
fi
printf '#!/bin/bash\napt clean\napt udpate\napt upgrade -y\napt dist-upgrade -y\napt autoremove-y\napt autoclean-y\n\nif [ -f /var/run/reboot-required ]; then\n  sudo shutdown -r now\nfi\necho $(date) "Updates Complete" >> /scripts/logs/updates.log\nfind -type f \( -name 'updates.log' \) -size +1M -delete\n' >> /scripts/updates.sh
chmod +x /scripts/updates.sh

