#!/bin/bash

# This script must be run as root
if [ "$EUID" -ne 0 ]; then
  echo "Please follow the instructions in the Readme"
  exit
fi

echo "Installing dependencies"
apt install --assume-yes build-essential dfu-util unzip nginx samba virtualenv python2-dev \
  python2-setuptools-whl python2-pip-whl libffi-dev libncurses-dev libusb-dev avrdude \
  gcc-avr binutils-avr avr-libc stm32flash libnewlib-arm-none-eabi gcc-arm-none-eabi \
  binutils-arm-none-eabi libusb-1.0-0 libopenjp2-7 python3-libgpiod libcurl4-openssl-dev \
  libssl-dev liblmdb-dev libsodium-dev libjpeg-dev

# Create a new system user, add it to dialout (so it can access the serial port), and add the current user to the new user's group
echo "Creating printer user"
useradd --system --create-home --user-group printer
usermod -a -G printer $(id -un $UID)
usermod -a -G dialout printer

# Set up printer home directory
echo "Setting up printer directory"
mkdir /home/printer/printer_config /home/printer/printer_logs /home/printer/printer_gcode /home/printer/env
if [ -f "printer_config/printer.cfg" ]; then
  echo "Copying existing config"
  cp printer_config/* /home/printer/printer_config
else
  echo "Copying default config"
  cp configs/template/moonraker.conf /home/printer/printer_config
  touch /home/printer/printer_config/printer.cfg
fi

# Fix permissions
echo "Fixing permissions"
chmod -R 770 /home/printer/printer_config /home/printer/printer_logs /home/printer/printer_gcode /home/printer/env
chown -R printer:printer /home/printer/printer_config /home/printer/printer_logs /home/printer/printer_gcode /home/printer/env

echo "User setup complete!"
