#!/bin/bash

az network public-ip create \
  --resource-group ${RESOURCE_GROUP} \
  --name ${CLUSTERID}-routerExternalLB \
  --allocation-method Static

az network lb create \
  --resource-group ${RESOURCE_GROUP} \
  --name ${CLUSTERID}-OcpRouterLB \
  --public-ip-address ${CLUSTERID}-routerExternalLB \
  --frontend-ip-name ${CLUSTERID}-routerFrontEnd \
  --backend-pool-name ${CLUSTERID}-routerBackEnd

az network lb probe create \
  --resource-group ${RESOURCE_GROUP} \
  --lb-name ${CLUSTERID}-OcpRouterLB \
  --name ${CLUSTERID}-routerHealthProbe \
  --protocol tcp \
  --port 80

az network lb rule create \
  --resource-group ${RESOURCE_GROUP} \
  --lb-name ${CLUSTERID}-OcpRouterLB \
  --name ${CLUSTERID}-routerRule \
  --protocol tcp \
  --frontend-port 80 \
  --backend-port 80 \
  --frontend-ip-name ${CLUSTERID}-routerFrontEnd \
  --backend-pool-name ${CLUSTERID}-routerBackEnd \
  --probe-name ${CLUSTERID}-routerHealthProbe \
  --load-distribution SourceIPProtocol

az network lb rule create \
  --resource-group ${RESOURCE_GROUP} \
  --lb-name ${CLUSTERID}-OcpRouterLB \
  --name ${CLUSTERID}-httpsRouterRule \
  --protocol tcp \
  --frontend-port 443 \
  --backend-port 443 \
  --frontend-ip-name ${CLUSTERID}-routerFrontEnd \
  --backend-pool-name ${CLUSTERID}-routerBackEnd \
  --probe-name ${CLUSTERID}-routerHealthProbe \
  --load-distribution SourceIPProtocol
