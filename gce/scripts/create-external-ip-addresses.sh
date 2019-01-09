#!/bin/bash

# Masters load balancer
echo "=> Creating External IP Address for master..."
gcloud compute addresses create ${CLUSTERID}-master-lb \
    --ip-version=IPV4 \
    --global

# Applications load balancer
echo "=> Creating External IP Address for applications..."
gcloud compute addresses create ${CLUSTERID}-apps-lb \
    --region ${REGION}

# Bastion host
echo "=> Creating External IP Address for bastion..."
gcloud compute addresses create ${CLUSTERID}-bastion \
  --region ${REGION}
