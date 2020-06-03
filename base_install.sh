#!/bin/bash
UPDATES=/scripts/updates.sh
HOSTNAMEFILE=/etc/hostname
read -p 'Hostname: ' HOSTNAME
read -p 'Password: ' PASSWORD
echo -e "$PASSWORD\n$PASSWORD" | passwd administrator
echo "$HOSTNAME" | tee /etc/hostname >/dev/null
sed -i "s/template/${HOSTNAME}/g" /etc/hosts
apt update
apt install joe fail2ban open-vm-tools ntp -y
mkdir /scripts/logs
if test -f "$UPDATES"; then
	rm -rf /scripts/updates.sh
fi
printf '#!/bin/bash\napt clean\napt update\napt upgrade -y\napt dist-upgrade -y\napt autoremove -y\napt autoclean -y\nif test -f "/scripts/base_install.sh"; then\n\trm "/scripts/base_install.sh"\nfi\nif [ -f /var/run/reboot-required ]; then\n  sudo shutdown -r now\nfi\necho $(date) "Updates Complete" >> /scripts/logs/updates.log\nfind -type f \( -name 'updates.log' \) -size +1M -delete\n' >> /scripts/updates.sh
chmod +x /scripts/updates.sh
(crontab -l && echo "0 4 * * * /scripts/updates.sh") | crontab -
/scripts/updates.sh


