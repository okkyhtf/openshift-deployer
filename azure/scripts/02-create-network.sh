#!/bin/bash

echo "=> Creating Vnet and Subnet..."
az network vnet create \
  --name ${VNET} \
  --resource-group ${RESOURCE_GROUP} \
  --tags clusterid=${CLUSTERID} \
  --subnet-name ${SUBNET} \
  --address-prefix ${VNET_CIDR} \
  --subnet-prefix ${SUBNET_CIDR}
