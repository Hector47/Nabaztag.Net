#!/bin/bash

echo "Please make sure that .NET 8 is instal in /opt/dotnet"
#sudo curl -sSL https://dot.net/v1/dotnet-install.sh | sudo bash /dev/stdin --version "8.0.6" --verbose --runtime aspnetcore --install-dir "/opt/dotnet"
echo "Installation started for Nabaztag.ServerCore"
echo "Stopping any previous service"
sudo systemctl is-active --quiet nabd.socket && sudo systemctl stop nabd.socket
sudo systemctl disable nabd.socket
sudo systemctl is-active --quiet nabd && sudo systemctl stop nabd
sudo systemctl disable nabd
sudo systemctl is-active --quiet nabaztag-servercore && sudo systemctl stop nabaztag-servercore
echo "Preparing service and config files"
dir=`pwd`
IFS='/' read -a subdir <<< ${dir}
search='s+/opt/nabsrv+'${dir}'+g'
sudo sed -i ${search} nabaztag-servercore.service
echo "Installing service in systemd"
sudo cp nabaztag-servercore.service /etc/systemd/system/nabaztag-servercore.service
sudo systemctl daemon-reload
sudo systemctl start nabaztag-servercore
sudo systemctl enable nabaztag-servercore
echo "Service installed and sarted"
echo "Rebooting"
sudo reboot
