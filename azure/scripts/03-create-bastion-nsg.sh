#!/bin/bash

echo "=> Creating NSG for Bastion..."
az network nsg create \
  --resource-group ${RESOURCE_GROUP} \
  --name ${CLUSTERID}-bastion-nsg \
  --tags clusterid=${CLUSTERID} securitygroup=bastion

echo "=> Creating NSG Rule for SSH..."
az network nsg rule create \
  --resource-group ${RESOURCE_GROUP} \
  --nsg-name ${CLUSTERID}-bastion-nsg \
  --name ${CLUSTERID}-bastion-nsg-ssh  \
  --priority 500 \
  --destination-port-ranges 22 \
  --access Allow --protocol Tcp \
  --description "SSH access from Internet"
