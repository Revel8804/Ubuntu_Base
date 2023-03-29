#!/bin/bash
UPDATES=/scripts/updates.sh
HOSTNAMEFILE=/etc/hostname
read -p 'Hostname: ' HOSTNAME
read -p 'Password: ' PASSWORD
read -p 'IP Address: ' IP
read -p 'Gateway: ' GATEWAY
read -p 'Subnet CIDR: ' SUB
read -p 'DNS 1: ' DNS1
read -p 'DNS 2: ' DNS2
IF_NAME=$(ip route get 8.8.8.8 | awk '{print $5}')
cat <<EOF > /etc/netplan/01-netcfg.yaml
network:
    version: 2
    renderer: networkd
    ethernets:
        $IF_NAME:
                addresses:
                    - $IP/$SUB
                nameservers:
                    addresses: [$DNS1,$DNS2]
                routes:
                    - to: default
                      via: $GATEWAY
EOF
sudo netplan apply
echo -e "$PASSWORD\n$PASSWORD" | passwd revel
echo "$HOSTNAME" | tee /etc/hostname >/dev/null
sed -i "s/template/${HOSTNAME}/g" /etc/hosts
apt update
apt install joe fail2ban open-vm-tools -y
timedatectl set-timezone America/Chicago
mkdir /scripts/logs
if test -f "$UPDATES"; then
        rm -rf /scripts/updates.sh
fi
printf '#!/bin/bash\napt clean\napt update\napt upgrade -y\napt dist-upgrade -y\napt autoremove -y\napt autoclean -y\nif
chmod +x /scripts/updates.sh
crontab -l | { cat; echo "0 4 * * * /scripts/updates.sh"; } | crontab -
/scripts/updates.sh
