#!/bin/bash

echo "=> Creating NSG for Infra..."
az network nsg create \
  --resource-group ${RESOURCE_GROUP} \
  --name ${CLUSTERID}-infra-node-nsg \
  --tags clusterid=${CLUSTERID} securitygroup=infra

echo "=> Creating NSG Rule for SSH..."
az network nsg rule create \
  --resource-group ${RESOURCE_GROUP} \
  --nsg-name ${CLUSTERID}-infra-node-nsg \
  --name ${CLUSTERID}-infra-ssh  \
  --priority 500 \
  --source-address-prefixes VirtualNetwork \
  --destination-port-ranges 22  \
  --access Allow --protocol Tcp \
  --description "SSH from the bastion"

echo "=> Creating NSG Rule for OpenShift Router..."
az network nsg rule create \
  --resource-group ${RESOURCE_GROUP} \
  --nsg-name ${CLUSTERID}-infra-node-nsg \
  --name ${CLUSTERID}-router-ports  \
  --priority 525 \
  --source-address-prefixes AzureLoadBalancer \
  --destination-port-ranges 80 443  \
  --access Allow --protocol Tcp \
  --description "OpenShift router"

echo "=> Creating NSG Rule for Elasticsearch..."
az network nsg rule create \
  --resource-group ${RESOURCE_GROUP} \
  --nsg-name ${CLUSTERID}-infra-node-nsg \
  --name ${CLUSTERID}-infra-ports  \
  --priority 550 \
  --source-address-prefixes VirtualNetwork \
  --destination-port-ranges 9200 9300 \
  --access Allow --protocol Tcp \
  --description "ElasticSearch"

echo "=> Creating NSG Rule for Kubelet..."
az network nsg rule create \
  --resource-group ${RESOURCE_GROUP} \
  --nsg-name ${CLUSTERID}-infra-node-nsg \
  --name ${CLUSTERID}-node-kubelet  \
  --priority 575 \
  --source-address-prefixes VirtualNetwork \
  --destination-port-ranges 10250 \
  --access Allow --protocol Tcp \
  --description "kubelet"

echo "=> Creating NSG Rule for OpenShift SDN..."
az network nsg rule create \
  --resource-group ${RESOURCE_GROUP} \
  --nsg-name ${CLUSTERID}-infra-node-nsg \
  --name ${CLUSTERID}-node-sdn  \
  --priority 600 \
  --source-address-prefixes VirtualNetwork \
  --destination-port-ranges 4789 \
  --access Allow --protocol Udp \
  --description "OpenShift sdn"

echo "=> Creating NSG Rule for OpenShift Router..."
az network nsg rule create \
  --resource-group ${RESOURCE_GROUP} \
  --nsg-name ${CLUSTERID}-infra-node-nsg \
  --name ${CLUSTERID}-router-ports \
  --priority 625 \
  --destination-port-ranges 80 443 \
  --access Allow --protocol Tcp \
  --description "OpenShift router"
