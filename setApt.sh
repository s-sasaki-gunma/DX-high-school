#!/bin/bash

# aptリポジトリの更新
cat <<EOL | sudo tee /etc/apt/sources.list
#deb http://deb.debian.org/debian bookworm main contrib non-free non-free-firmware
#deb http://deb.debian.org/debian-security/ bookworm-security main contrib non-free non-free-firmware
#deb http://deb.debian.org/debian bookworm-updates main contrib non-free non-free-firmware
# Uncomment deb-src lines below then 'apt-get update' to enable 'apt-get source'
#deb-src http://deb.debian.org/debian bookworm main contrib non-free non-free-firmware
#deb-src http://deb.debian.org/debian-security/ bookworm-security main contrib non-free non-free-firmware
#deb-src http://deb.debian.org/debian bookworm-updates main contrib non-free non-free-firmware

deb http://raspbian.raspberrypi.org/raspbian/ bookworm main contrib non-free rpi
deb https://ftp.tsukuba.wide.ad.jp/debian/ bookworm-backports main non-free-firmware
deb https://ftp.tsukuba.wide.ad.jp/debian/ bookworm main contrib non-free non-free-firmware
deb https://ftp.tsukuba.wide.ad.jp/debian/ bookworm-updates main contrib non-free non-free-firmware
EOL

# aptによる更新
HTTP_PROXY=http://proxy.in.gsn.ed.jp:8080/
sudo apt clean
sudo apt -y update --fix-missing
KEYS=`sudo -E apt -y update 2>/dev/null | grep NO_PUBKEY | awk '{print $3}'`
for key in $KEYS
do
sudo -E apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --keyserver-option http-proxy=$HTTP_PROXY --recv-keys $key
done
sudo apt -y update --fix-missing
sudo apt -y upgrade --fix-missing --fix-broken
sudo apt -y autoremove