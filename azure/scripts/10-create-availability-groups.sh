#!/bin/bash

az vm availability-set create \
  --resource-group ${RESOURCE_GROUP} \
  --name ${CLUSTERID}-ocp-master-instances

az vm availability-set create \
  --resource-group ${RESOURCE_GROUP} \
  --name ${CLUSTERID}-ocp-infra-instances

az vm availability-set create \
  --resource-group ${RESOURCE_GROUP} \
  --name ${CLUSTERID}-ocp-app-instances

az vm availability-set create \
  --resource-group ${RESOURCE_GROUP} \
  --name ${CLUSTERID}-ocp-storage-instances
