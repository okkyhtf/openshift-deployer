#!/bin/bash

echo "=> Creating Public IP for Router..."
az network public-ip create \
  --resource-group ${RESOURCE_GROUP} \
  --name ${CLUSTERID}-router-external-lb \
  --allocation-method Static

echo "=> Creating Load Balancer for Router..."
az network lb create \
  --resource-group ${RESOURCE_GROUP} \
  --name ${CLUSTERID}-ocp-router-lb \
  --public-ip-address ${CLUSTERID}-router-external-lb \
  --frontend-ip-name ${CLUSTERID}-router-frontend \
  --backend-pool-name ${CLUSTERID}-router-backEnd

echo "=> Creating Load Balancer Probe for Router..."
az network lb probe create \
  --resource-group ${RESOURCE_GROUP} \
  --lb-name ${CLUSTERID}-ocp-router-lb \
  --name ${CLUSTERID}-router-health-probe \
  --protocol tcp \
  --port 80

echo "=> Creating Load Balancer Rule for HTTP Traffic..."
az network lb rule create \
  --resource-group ${RESOURCE_GROUP} \
  --lb-name ${CLUSTERID}-ocp-router-lb \
  --name ${CLUSTERID}-http-router-rule \
  --protocol tcp \
  --frontend-port 80 \
  --backend-port 80 \
  --frontend-ip-name ${CLUSTERID}-router-frontend \
  --backend-pool-name ${CLUSTERID}-router-backend \
  --probe-name ${CLUSTERID}-router-health-probe \
  --load-distribution SourceIPProtocol

echo "=> Creating Load Balancer Rule for HTTPS Traffic..."
az network lb rule create \
  --resource-group ${RESOURCE_GROUP} \
  --lb-name ${CLUSTERID}-ocp-router-lb \
  --name ${CLUSTERID}-https-router-rule \
  --protocol tcp \
  --frontend-port 443 \
  --backend-port 443 \
  --frontend-ip-name ${CLUSTERID}-router-frontend \
  --backend-pool-name ${CLUSTERID}-router-backend \
  --probe-name ${CLUSTERID}-router-health-probe \
  --load-distribution SourceIPProtocol
