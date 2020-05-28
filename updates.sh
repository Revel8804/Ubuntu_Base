#!/bin/bash
sudo apt clean
sudo apt update
sudo apt upgrade -y
sudo apt dist-upgrade -y
sudo apt autoremove -y
sudo apt autoclean -y

if [ -f /var/run/reboot-required ]; then
  sudo shutdown -r now
fi
echo $(date) "Updates Complete" >> /scripts/logs/updates.log
find -type f \( -name 'updates.log' \) -size +1M -delete
