# PrintPi

A custom Klipper/Moonraker/Mainsail implementation that uses a separate user account for the printer services, allowing the Pi to be used for other projects at the same time.

**Note:** This is tested on a Raspberry Pi 4 running 64-bit Ubuntu.
## Step 1: Dependencies

```shell
sudo apt update --allow-releaseinfo-change && sudo apt upgrade --assume-yes
sudo apt install --assume-yes git
```

## Step 2: Setup

Clone this repository onto your Raspberry Pi:

```shell
git clone https://github.com/SilentSpud/PrintPi printpi
cd ./printpi
```

Copy your existing moonraker.conf and printer configs into `printer_config` if you have any.
If not, they'll be generated from default templates

## Step 3: Automated Scripts

```shell
sudo scripts/01-setup-init.sh
sudo -u printer scripts/02-setup-printer.sh
sudo scripts/03-setup-services.sh
```
