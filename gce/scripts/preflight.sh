#!/bin/bash

ansible *-infras-* -i inventory.ini -b -m firewalld -a "port=1936/tcp permanent=true state=enabled"
ansible nodes -i inventory.ini -b -m firewalld -a "port=10256/tcp permanent=true state=enabled"
ansible all -i inventory.ini -b -m yum -a "name=* state=latest"
ansible all -i inventory.ini -b -m command -a "reboot"

