#!/bin/bash

sudo yum upgrade -y &&
sudo rpm --import https://packages.microsoft.com/keys/microsoft.asc
echo -e "[azure-cli]
name=Azure CLI
baseurl=https://packages.microsoft.com/yumrepos/azure-cli
enabled=1
gpgcheck=1
gpgkey=https://packages.microsoft.com/keys/microsoft.asc" | sudo tee /etc/yum.repos.d/azure-cli.repo
sudo yum check-update; sudo yum install -y gcc libffi-devel python-devel openssl-devel epel-release
sudo yum install -y python3-pip python3-wheel
sudo yum install git -y
sudo cp /tmp/id_rsa /home/vmathpal/.ssh
chmod 400 /home/vmathpal/.ssh/id_rsa
sudo chown -R vmathpal /home/vmathpal/.ssh
LC_CTYPE=en_US.UTF-8
export LC_CTYPE 
sudo python3 -m pip install --upgrade --force-reinstall pip
python3 -m pip install setuptools_rust
sudo yum install -y azure-cli
python3 -m pip install ansible
python3 -m pip install -r /tmp/requirements-azure.txt
