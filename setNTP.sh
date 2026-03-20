#!/bin/bash

# NTP設定（追記するNTPサーバのローカルIPは環境に合わせて適宜書き換えてください）
echo "追記： /etc/systemd/timesyncd.conf"
cat <<EOL | sudo tee -a /etc/systemd/timesyncd.conf
NTP=192.168.0.2 ntp.jst.mfeed.ad.jp ntp.nict.jp time.google.com
EOL

# NTP有効化
sudo timedatectl set-ntp true
sudo systemctl daemon-reload
sudo systemctl restart systemd-timesyncd.service