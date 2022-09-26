#!/bin/bash

# This script must be run as root
if [ "$EUID" -ne 0 ]; then
  echo "Please follow the instructions in the Readme"
  exit
fi

echo "Copying service files"
cp configs/service/klipper.service /etc/systemd/system/klipper.service
cp configs/service/moonraker.service /etc/systemd/system/moonraker.service
systemctl daemon-reload
systemctl enable klipper.service moonraker.service

echo "Setting up Nginx"
rm /etc/nginx/sites-enabled/default
cp configs/nginx/config/* /etc/nginx/conf.d/
cp configs/nginx/sites/* /etc/nginx/sites-available/
ln -s /etc/nginx/sites-available/mainsail /etc/nginx/sites-enabled/

echo "Setting up Mainsail"
chmod -R 777 /var/www
mkdir /var/www/mainsail
wget -q -O /var/www/mainsail.zip https://github.com/mainsail-crew/mainsail/releases/latest/download/mainsail.zip
unzip /var/www/mainsail.zip -d /var/www/mainsail
rm /var/www/mainsail.zip

echo "Setting up the Moonraker PolKit Policy"
cat >/etc/polkit-1/localauthority/50-local.d/moonraker.pkla <<-EndOfPolicy
[moonraker permissions]
Identity=unix-user:printer
Action=org.freedesktop.systemd1.manage-units;org.freedesktop.login1.power-off;org.freedesktop.login1.power-off-multiple-sessions;org.freedesktop.login1.reboot;org.freedesktop.login1.reboot-multiple-sessions;org.freedesktop.packagekit.*
ResultAny=yes
EndOfPolicy

echo "Complete! Starting services"
systemctl start klipper.service moonraker.service
systemctl restart nginx
echo "You can now access Mainsail at (some of) these hostnames:"
for i in $(hostname -I); do
  echo "http://$i/"
done
