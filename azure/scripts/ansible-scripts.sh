#!/bin/bash

ansible nodes -m shell -a 'timedatectl set-timezone Asia/Jakarta'

ansible nodes -m shell -a 'mkfs.xfs /dev/sdc'
ansible nodes -m shell -a 'mkdir -p /var/log && restorecon -R /var/log'
ansible nodes -m shell -a 'mkfs.xfs /dev/sdd'
ansible nodes -m shell -a 'mkdir -p /var/lib/docker && restorecon -R /var/lib/docker'
ansible nodes -m shell -a 'mkfs.xfs /dev/sde'
ansible nodes -m shell -a 'mkdir -p /var/lib/origin/openshift.local.volumes && restorecon -R /var/lib/origin/openshift.local.volumes'

ansible nodes -m shell -a 'shutdown -r now'

ansible nodes -m shell -a 'subscription-manager register --username=XXX --password=XXX'
ansible nodes -m shell -a 'subscription-manager config --rhsm.auto_enable_yum_plugins=0'
ansible nodes -m shell -a 'subscription-manager refresh'
ansible nodes -m shell -a 'subscription-manager attach --pool=XXX'
ansible nodes -m shell -a 'subscription-manager repos --disable="*"'
ansible nodes -m shell -a 'yum-config-manager --disable \*'
ansible nodes -m shell -a 'subscription-manager repos --enable="rhel-7-server-rpms" --enable="rhel-7-server-extras-rpms" --enable="rhel-7-server-ose-3.11-rpms" --enable="rhel-7-server-ansible-2.6-rpms"'