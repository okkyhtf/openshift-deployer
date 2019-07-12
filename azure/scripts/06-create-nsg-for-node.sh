#!/bin/bash

echo "=> Creating NSG for Node..."
az network nsg create \
  --resource-group ${RESOURCE_GROUP} \
  --name ${CLUSTERID}-node-nsg \
  --tags clusterid=${CLUSTERID} securitygroup=node

echo "=> Creating NSG Rule for SSH..."
az network nsg rule create \
  --resource-group ${RESOURCE_GROUP} \
  --nsg-name ${CLUSTERID}-node-nsg \
  --name ${CLUSTERID}-node-ssh  \
  --priority 500 \
  --source-address-prefixes VirtualNetwork \
  --destination-port-ranges 22 \
  --access Allow --protocol Tcp \
  --description "SSH from the bastion"

echo "=> Creating NSG Rule for Kubelet..."
az network nsg rule create \
  --resource-group ${RESOURCE_GROUP} \
  --nsg-name ${CLUSTERID}-node-nsg \
  --name ${CLUSTERID}-node-kubelet \
  --priority 525 \
  --source-address-prefixes VirtualNetwork \
  --destination-port-ranges 10250 \
  --access Allow --protocol Tcp \
  --description "kubelet"

echo "=> Creating NSG Rule for Elasticsearch..."
az network nsg rule create \
  --resource-group ${RESOURCE_GROUP} \
  --nsg-name ${CLUSTERID}-node-nsg \
  --name ${CLUSTERID}-node-sdn  \
  --priority 550 \
  --source-address-prefixes VirtualNetwork \
  --destination-port-ranges 4789 --access Allow \
  --protocol Udp \
  --description "ElasticSearch and ocp apps"

echo "=> Creating NSG Rule for Load Balancer healthcheck..."
az network nsg rule create \
  --resource-group ${RESOURCE_GROUP} \
  --nsg-name ${CLUSTERID}-node-nsg \
  --name ${CLUSTERID}-node-sdn  \
  --priority 575 \
  --source-address-prefixes VirtualNetwork \
  --destination-port-ranges 10256 --access Allow \
  --protocol Tcp \
  --description "Load Balancer health check"
