#!/bin/bash

LOCALVOLDEVICE=$(readlink -f /dev/disk/by-id/google-*local*)
CONTAINERSDEVICE=$(readlink -f /dev/disk/by-id/google-*containers*)
LOCALDIR="/var/lib/origin/openshift.local.volumes"
CONTAINERSDIR="/var/lib/docker"

for device in ${LOCALVOLDEVICE} ${CONTAINERSDEVICE}
do
  mkfs.xfs ${device}
done

for dir in ${LOCALDIR} ${CONTAINERSDIR}
do
  mkdir -p ${dir}
  restorecon -R ${dir}
done

echo UUID=$(blkid -s UUID -o value ${LOCALVOLDEVICE}) ${LOCALDIR} xfs defaults,discard,gquota 0 2 >> /etc/fstab
echo UUID=$(blkid -s UUID -o value ${CONTAINERSDEVICE}) ${CONTAINERSDIR} xfs defaults,discard 0 2 >> /etc/fstab

mount -a

