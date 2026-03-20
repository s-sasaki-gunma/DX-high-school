#!/bin/bash

# Proxy設定（環境に応じてproxyアドレスは書き換えてください）
SCHOOL_PROXY=http://proxy.in.gsn.ed.jp:8080/

# ラズベリーパイ設定
echo "Raspi Config"
sudo raspi-config nonint do_proxy all $SCHOOL_PROXY

# 環境変数
echo "環境変数（Proxy）"
export http_proxy=$SCHOOL_PROXY
export https_proxy=$SCHOOL_PROXY
export ftp_proxy=$SCHOOL_PROXY
export HTTP_PROXY=$SCHOOL_PROXY
export HTTPS_PROXY=$SCHOOL_PROXY
export FTP_PROXY=$SCHOOL_PROXY

echo "上書き： /etc/environment"
cat <<EOL | sudo tee /etc/environment
http_proxy=$SCHOOL_PROXY
https_proxy=$SCHOOL_PROXY
ftp_proxy=$SCHOOL_PROXY
HTTP_PROXY=$SCHOOL_PROXY
HTTPS_PROXY=$SCHOOL_PROXY
FTP_PROXY=$SCHOOL_PROXY
EOL
echo "source /etc/environment" | sudo tee -a /etc/profile

# apt
echo "上書き： /etc/apt/apt.conf.d/apt.conf"
cat <<EOL | sudo tee /etc/apt/apt.conf.d/apt.conf
Acquire::http::Proxy "$SCHOOL_PROXY";
Acquire::https::Proxy "$SCHOOL_PROXY";
Acquire::ftp::Proxy "$SCHOOL_PROXY";
Acquire::socks::Proxy "$SCHOOL_PROXY";
EOL

# pip
echo "上書き： ~/.pip/pip.conf"
mkdir ~/.pip
cat <<EOL | tee ~/.pip/pip.conf
[global]
proxy = $SCHOOL_PROXY
trusted-host = pypi.python.org
               pypi.org
               files.pythonhosted.org
EOL

# wget
echo "追記： /etc/wgetrc"
cat <<EOL | sudo tee -a /etc/wgetrc
http_proxy=$SCHOOL_PROXY
https_proxy=$SCHOOL_PROXY
ftp_proxy=$SCHOOL_PROXY
EOL

# curl
echo "上書き： ~/.curlrc"
cat <<EOL | sudo tee ~/.curlrc
proxy=$SCHOOL_PROXY
EOL

# git 
echo "上書き： ~/.gitconfig"
git config --global http.proxy $SCHOOL_PROXY
git config --global https.proxy $SCHOOL_PROXY
git config --global -l