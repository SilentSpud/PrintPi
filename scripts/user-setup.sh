#!/bin/bash

# This script must be run as root
if [ "$EUID" -ne 0 ]
  then echo "Please run as root"
  exit
fi

# Create new system user printer and add user with uid 1000 to its group
useradd --system --create-home --user-group printer
usermod -a -G printer $(id -un 1000)