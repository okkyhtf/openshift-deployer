#!/bin/bash

az network public-ip create \
  --resource-group ${RESOURCE_GROUP} \
  --name ${CLUSTERID}-masterExternalLB \
  --allocation-method Static

az network lb create \
  --resource-group ${RESOURCE_GROUP} \
  --name ${CLUSTERID}-OcpMasterLB \
  --public-ip-address ${CLUSTERID}-masterExternalLB \
  --frontend-ip-name ${CLUSTERID}-masterApiFrontend \
  --backend-pool-name ${CLUSTERID}-masterAPIBackend

az network lb probe create \
  --resource-group ${RESOURCE_GROUP} \
  --lb-name ${CLUSTERID}-OcpMasterLB \
  --name ${CLUSTERID}-masterHealthProbe \
  --protocol tcp \
  --port 443

az network lb rule create \
  --resource-group ${RESOURCE_GROUP} \
  --lb-name ${CLUSTERID}-OcpMasterLB \
  --name ${CLUSTERID}-ocpApiHealth \
  --protocol tcp \
  --frontend-port 443 \
  --backend-port 443 \
  --frontend-ip-name ${CLUSTERID}-masterApiFrontend \
  --backend-pool-name ${CLUSTERID}-masterAPIBackend \
  --probe-name ${CLUSTERID}-masterHealthProbe \
  --load-distribution SourceIPProtocol

