#!/bin/bash

yum install -y httpd-tools java-1.8.0-openjdk-headless python-passlib patch tmux
pip install 'ansible==2.6.11'
ansible all -i inventory.ini -b -m shell -a 'hostnamectl set-hostname $(hostname -f)'
ansible masters -i inventory.ini -b -m yum -a "name=tmux,httpd-tools state=latest"
ansible *-infras-* -i inventory.ini -b -m firewalld -a "port=1936/tcp permanent=true state=enabled"
ansible nodes -i inventory.ini -b -m firewalld -a "port=10256/tcp permanent=true state=enabled"
ansible all -i inventory.ini -b -m yum -a "name=* state=latest"
ansible all -i inventory.ini -b -m command -a "reboot"

