#!/bin/bash

echo "=> Creating Availability Set for Master..."
az vm availability-set create \
  --resource-group ${RESOURCE_GROUP} \
  --name ${CLUSTERID}-ocp-master-instances

echo "=> Creating Availability Set for Infra..."
az vm availability-set create \
  --resource-group ${RESOURCE_GROUP} \
  --name ${CLUSTERID}-ocp-infra-instances

echo "=> Creating Availability Set for Apps..."
az vm availability-set create \
  --resource-group ${RESOURCE_GROUP} \
  --name ${CLUSTERID}-ocp-app-instances

echo "=> Creating Availability Set for Storage..."
az vm availability-set create \
  --resource-group ${RESOURCE_GROUP} \
  --name ${CLUSTERID}-ocp-storage-instances
