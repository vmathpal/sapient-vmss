#!/bin/bash
sudo yum upgrade -y &&
sudo yum check-update; sudo yum install -y gcc libffi-devel python-devel openssl-devel epel-release
sudo yum install -y python3-pip python3-wheel
LC_CTYPE=en_US.UTF-8
export LC_CTYPE 
sudo python3 -m pip install --upgrade --force-reinstall pip
python3 -m pip install setuptools_rust
python3 -m pip install ansible
