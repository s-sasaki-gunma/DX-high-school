#!/bin/bash

iw dev
sudo iw phy phy0 interface add ap0 type __ap
MAC=`iw dev | grep addr | tail -n 1 | awk '{print $2}'`
sudo ip link set ap0 address $MAC

cat <<EOL | sudo tee /etc/udev/rules.d/99-ap0.rules
SUBSYSTEM=="ieee80211", ACTION=="add|change", ATTR{macaddress}=="$MAC", KERNEL=="phy0", \
 RUN+="/sbin/iw phy phy0 interface add ap0 type __ap", \
 RUN+="/bin/ip link set ap0 address $MAC"
EOL

RPNN=SSID_DX_`echo $(hostname) | cut -c 1-4`
sudo nmcli connection add type wifi ifname ap0 con-name rpi_ap autoconnect yes ssid $RPNN 802-11-wireless.mode ap 802-11-wireless.band bg ipv4.method shared ipv4.address 192.168.111.1/24 ipv4.never-default yes wifi-sec.key-mgmt wpa-psk wifi-sec.pairwise ccmp wifi-sec.proto rsn wifi-sec.psk "12345678"
# 上記のネットワーク設定について、ipv4,addressとwifi-sec.pskは適宜変えてください
# ipv4,addressのデフォルト値：192.168.111.1/24
# wifi-sec.pskのデフォルト値：12345678

sudo nmcli connection reload
sudo nmcli connection up rpi_ap