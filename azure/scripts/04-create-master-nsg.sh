#!/bin/bash

echo "=> Creating NSG for Master..."
az network nsg create \
  --resource-group ${RESOURCE_GROUP} \
  --name ${CLUSTERID}-master-nsg \
  --tags clusterid=${CLUSTERID} securitygroup=master

echo "=> Creating NSG Rule for SSH..."
az network nsg rule create \
  --resource-group ${RESOURCE_GROUP} \
  --nsg-name ${CLUSTERID}-master-nsg \
  --name ${CLUSTERID}-master-ssh  \
  --priority 500 \
  --source-address-prefixes VirtualNetwork \
  --destination-port-ranges 22 \
  --access Allow --protocol Tcp \
  --description "SSH from the bastion"

echo "=> Creating NSG Rule for etcd..."
az network nsg rule create \
  --resource-group ${RESOURCE_GROUP} \
  --nsg-name ${CLUSTERID}-master-nsg \
  --name ${CLUSTERID}-master-etcd  \
  --priority 525 \
  --source-address-prefixes VirtualNetwork \
  --destination-port-ranges 2379 2380 \
  --access Allow --protocol Tcp \
  --description "ETCD service ports"

echo "=> Creating NSG Rule for Master API..."
az network nsg rule create \
  --resource-group ${RESOURCE_GROUP} \
  --nsg-name ${CLUSTERID}-master-nsg \
  --name ${CLUSTERID}-master-api \
  --priority 550 \
  --destination-port-ranges 443 \
  --access Allow --protocol Tcp \
  --description "API port"

echo "=> Creating NSG Rule for Master API Load Balancer..."
az network nsg rule create \
  --resource-group ${RESOURCE_GROUP} \
  --nsg-name ${CLUSTERID}-master-nsg \
  --name ${CLUSTERID}-master-api-lb \
  --source-address-prefixes VirtualNetwork \
  --priority 575 \
  --destination-port-ranges 443 \
  --access Allow --protocol Tcp \
  --description "API port"

echo "=> Creating NSG Rule for TCP DNS and Fluentd..."
az network nsg rule create \
  --resource-group ${RESOURCE_GROUP} \
  --nsg-name ${CLUSTERID}-master-nsg \
  --name ${CLUSTERID}-master-ocp-tcp  \
  --priority 600 \
  --source-address-prefixes VirtualNetwork \
  --destination-port-ranges 8053 \
  --access Allow --protocol Tcp \
  --description "TCP DNS and fluentd"

echo "=> Creating NSG Rule for TCP DNS and Fluentd..."
az network nsg rule create \
  --resource-group ${RESOURCE_GROUP} \
  --nsg-name ${CLUSTERID}-master-nsg \
  --name ${CLUSTERID}-master-ocp-udp  \
  --priority 625 \
  --source-address-prefixes VirtualNetwork \
  --destination-port-ranges 8053 \
  --access Allow --protocol Udp \
  --description "UDP DNS and fluentd"

echo "=> Creating NSG Rule for Kubelet..."
az network nsg rule create \
  --resource-group ${RESOURCE_GROUP} \
  --nsg-name ${CLUSTERID}-master-nsg \
  --name ${CLUSTERID}-node-kubelet  \
  --priority 650 \
  --source-address-prefixes VirtualNetwork \
  --destination-port-ranges 10250 \
  --access Allow --protocol Tcp \
  --description "kubelet"

echo "=> Creating NSG Rule for OpenShift SDN..."
az network nsg rule create \
  --resource-group ${RESOURCE_GROUP} \
  --nsg-name ${CLUSTERID}-master-nsg \
  --name ${CLUSTERID}-node-sdn  \
  --priority 675 \
  --source-address-prefixes VirtualNetwork \
  --destination-port-ranges 4789 \
  --access Allow --protocol Udp \
  --description "OpenShift SDN"

