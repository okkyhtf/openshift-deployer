#!/bin/bash

echo "=> Creating Public IP for Bastion..."
az network public-ip create \
  --name ${CLUSTERID}-bastion-static \
  --resource-group ${RESOURCE_GROUP} \
  --allocation-method Static

echo "=> Creating NIC for Bastion..."
az network nic create \
  --name ${CLUSTERID}-bastion-nic \
  --resource-group ${RESOURCE_GROUP} \
  --vnet-name ${VNET} \
  --subnet ${SUBNET} \
  --network-security-group ${CLUSTERID}-bastion-nsg \
  --public-ip-address ${CLUSTERID}-bastion-static

echo "=> Creating Bastion..."
az vm create \
  --resource-group ${RESOURCE_GROUP} \
  --name ${CLUSTERID}-bastion \
  --size ${BASTION_SIZE} \
  --image RedHat:RHEL:7-RAW:latest \
  --admin-user cloud-user \
  --ssh-key ~/.ssh/azure.pub \
  --os-disk-name ${CLUSTERID}-bastion-root \
  --os-disk-size-gb ${BASTION_ROOT_SIZE} \
  --nics ${CLUSTERID}-bastion-nic
