#!/bin/bash

echo "=> Creating Public IP for Master External Load Balancer..."
az network public-ip create \
  --resource-group ${RESOURCE_GROUP} \
  --name ${CLUSTERID}-master-external-lb \
  --allocation-method Static

echo "=> Creating Load Balancer for Master..."
az network lb create \
  --resource-group ${RESOURCE_GROUP} \
  --name ${CLUSTERID}-ocp-master-lb \
  --public-ip-address ${CLUSTERID}-master-external-lb \
  --frontend-ip-name ${CLUSTERID}-master-api-frontend \
  --backend-pool-name ${CLUSTERID}-master-api-backend

echo "=> Creating Load Balancer Probe for Master..."
az network lb probe create \
  --resource-group ${RESOURCE_GROUP} \
  --lb-name ${CLUSTERID}-ocp-master-lb \
  --name ${CLUSTERID}-master-health-probe \
  --protocol tcp \
  --port 443

echo "=> Creating Load Balancer Rule for Master..."
az network lb rule create \
  --resource-group ${RESOURCE_GROUP} \
  --lb-name ${CLUSTERID}-ocp-master-lb \
  --name ${CLUSTERID}-ocp-api-health \
  --protocol tcp \
  --frontend-port 443 \
  --backend-port 443 \
  --frontend-ip-name ${CLUSTERID}-master-api-frontend \
  --backend-pool-name ${CLUSTERID}-master-api-backend \
  --probe-name ${CLUSTERID}-master-health-probe \
  --load-distribution SourceIPProtocol

