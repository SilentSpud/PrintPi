#!/bin/bash

SCRIPT_USER=$(whoami)
if [ "$SCRIPT_USER" != "printer" ]; then
  echo "Please follow the instructions in the Readme"
  exit
fi

echo "Setting up Klipper"
git clone https://github.com/KevinOConnor/klipper ~/klipper
virtualenv -p python2 ~/env/klippy
~/env/klippy/bin/pip install -r ~/klipper/scripts/klippy-requirements.txt

echo "Setting up Moonraker"
git clone https://github.com/Arksine/moonraker.git ~/moonraker
virtualenv -p python3 ~/env/moonraker
~/env/moonraker/bin/pip install -r ~/moonraker/scripts/moonraker-requirements.txt
