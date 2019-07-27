#!/bin/bash

echo "=> Creating NSG for Storage..."
az network nsg create \
  --resource-group ${RESOURCE_GROUP} \
  --name ${CLUSTERID}-storage-nsg \
  --tags clusterid=${CLUSTERID} securitygroup=storage

echo "=> Creating NSG Rule for SSH..."
az network nsg rule create \
  --resource-group ${RESOURCE_GROUP} \
  --nsg-name ${CLUSTERID}-storage-nsg \
  --name ${CLUSTERID}-node-ssh  \
  --priority 500 \
  --source-address-prefixes VirtualNetwork \
  --destination-port-ranges 22 \
  --access Allow --protocol Tcp \
  --description "SSH from the bastion"

echo "=> Creating NSG Rule for Kubelet..."
az network nsg rule create \
  --resource-group ${RESOURCE_GROUP} \
  --nsg-name ${CLUSTERID}-storage-nsg \
  --name ${CLUSTERID}-node-kubelet \
  --priority 525 \
  --source-address-prefixes VirtualNetwork \
  --destination-port-ranges 10250 \
  --access Allow --protocol Tcp \
  --description "kubelet"

echo "=> Creating NSG Rule for Elasticsearch..."
az network nsg rule create \
  --resource-group ${RESOURCE_GROUP} \
  --nsg-name ${CLUSTERID}-storage-nsg \
  --name ${CLUSTERID}-node-sdn  \
  --priority 550 \
  --source-address-prefixes VirtualNetwork \
  --destination-port-ranges 4789 --access Allow \
  --protocol Udp \
  --description "ElasticSearch and ocp apps"

echo "=> Creating NSG Rule for Gluster SSH..."
az network nsg rule create \
  --resource-group ${RESOURCE_GROUP} \
  --nsg-name ${CLUSTERID}-storage-nsg \
  --name ${CLUSTERID}-gluster-ssh  \
  --priority 575 \
  --source-address-prefixes VirtualNetwork \
  --destination-port-ranges 2222 \
  --access Allow --protocol Tcp \
  --description "Gluster SSH"

echo "=> Creating NSG Rule for Gluster Daemon..."
az network nsg rule create \
  --resource-group ${RESOURCE_GROUP} \
  --nsg-name ${CLUSTERID}-storage-nsg \
  --name ${CLUSTERID}-gluster-daemon  \
  --priority 600 \
  --source-address-prefixes VirtualNetwork \
  --destination-port-ranges 24008 \
  --access Allow --protocol Tcp \
  --description "Gluster Daemon"

echo "=> Creating NSG Rule for Gluster Management..."
az network nsg rule create \
  --resource-group ${RESOURCE_GROUP} \
  --nsg-name ${CLUSTERID}-storage-nsg \
  --name ${CLUSTERID}-gluster-mgmt  \
  --priority 625 \
  --source-address-prefixes VirtualNetwork \
  --destination-port-ranges 24009 \
  --access Allow --protocol Tcp \
  --description "Gluster Management"

echo "=> Creating NSG Rule for Gluster Clients..."
az network nsg rule create \
  --resource-group ${RESOURCE_GROUP} \
  --nsg-name ${CLUSTERID}-storage-nsg \
  --name ${CLUSTERID}-gluster-client  \
  --priority 650 \
  --source-address-prefixes VirtualNetwork \
  --destination-port-ranges 49152-49664 \
  --access Allow --protocol Tcp \
  --description "Gluster Clients"

echo "=> Creating NSG Rule for Portmap TCP..."
az network nsg rule create \
  --resource-group ${RESOURCE_GROUP} \
  --nsg-name ${CLUSTERID}-storage-nsg \
  --name ${CLUSTERID}-portmap-tcp  \
  --priority 675 \
  --source-address-prefixes VirtualNetwork \
  --destination-port-ranges 111 \
  --access Allow --protocol Tcp \
  --description "Portmap tcp"

echo "=> Creating NSG Rule for Portmap UDP..."
az network nsg rule create \
  --resource-group ${RESOURCE_GROUP} \
  --nsg-name ${CLUSTERID}-storage-nsg \
  --name ${CLUSTERID}-portmap-udp  \
  --priority 700 \
  --source-address-prefixes VirtualNetwork \
  --destination-port-ranges 111 \
  --access Allow --protocol Udp \
  --description "Portmap udp"

echo "=> Creating NSG Rule for Gluster Blocks..."
az network nsg rule create \
  --resource-group ${RESOURCE_GROUP} \
  --nsg-name ${CLUSTERID}-storage-nsg \
  --name ${CLUSTERID}-gluster-iscsi  \
  --priority 725 \
  --source-address-prefixes VirtualNetwork \
  --destination-port-ranges 3260 \
  --access Allow --protocol Tcp \
  --description "Gluster Blocks"

echo "=> Creating NSG Rule for Gluster Blocks..."
az network nsg rule create \
  --resource-group ${RESOURCE_GROUP} \
  --nsg-name ${CLUSTERID}-storage-nsg \
  --name ${CLUSTERID}-gluster-block  \
  --priority 750 \
  --source-address-prefixes VirtualNetwork \
  --destination-port-ranges 24010 \
  --access Allow --protocol Tcp \
  --description "Gluster Block"