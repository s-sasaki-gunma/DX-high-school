#!/bin/bash

# x11の有効化
sudo raspi-config nonint do_wayland W1

# VNCサーバの有効化
sudo raspi-config nonint do_vnc 0
sudo systemctl enable vncserver-x11-serviced.service
sudo systemctl start vncserver-x11-serviced.service

# VNCサーバの権限変更
echo "Authentication=VncAuth" | sudo tee -a /etc/vnc/config.d/common

# VNCサーバのパスワード設定（パスワードは「raspberry」としてありますが、必要に応じて書き換えてください）
echo "raspberry" | sudo vncpasswd -service