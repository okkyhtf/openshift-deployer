#!/bin/bash

LOCALVOLDEVICE=$(readlink -f /dev/disk/by-id/google-*local*)
ETCDDEVICE=$(readlink -f /dev/disk/by-id/google-*etcd*)
CONTAINERSDEVICE=$(readlink -f /dev/disk/by-id/google-*containers*)
LOCALDIR="/var/lib/origin/openshift.local.volumes"
ETCDDIR="/var/lib/etcd"
CONTAINERSDIR="/var/lib/docker"

for device in ${LOCALVOLDEVICE} ${ETCDDEVICE} ${CONTAINERSDEVICE}
do
  mkfs.xfs ${device}
done

for dir in ${LOCALDIR} ${ETCDDIR} ${CONTAINERSDIR}
do
  mkdir -p ${dir}
  restorecon -R ${dir}
done

echo UUID=$(blkid -s UUID -o value ${LOCALVOLDEVICE}) ${LOCALDIR} xfs defaults,discard,gquota 0 2 >> /etc/fstab
echo UUID=$(blkid -s UUID -o value ${ETCDDEVICE}) ${ETCDDIR} xfs defaults,discard 0 2 >> /etc/fstab
echo UUID=$(blkid -s UUID -o value ${CONTAINERSDEVICE}) ${CONTAINERSDIR} xfs defaults,discard 0 2 >> /etc/fstab

mount -a

