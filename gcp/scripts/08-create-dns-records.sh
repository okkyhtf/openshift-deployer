#!/bin/bash

# Masters load balancer entry
echo "=> Creating DNS Record for master..."
export LBIP=$(gcloud compute addresses list \
  --filter="name:${CLUSTERID}-master-lb" \
  --format="value(address)")
gcloud dns record-sets transaction start \
  --zone=${DNSZONE}
gcloud dns record-sets transaction add ${LBIP} \
  --name=paas.${DOMAIN} \
  --ttl=${TTL} \
  --type=A \
  --zone=${DNSZONE}
gcloud dns record-sets transaction execute \
  --zone=${DNSZONE}

# Applications load balancer entry
echo "=> Creating DNS Record for applications..."
export APPSLBIP=$(gcloud compute addresses list \
  --filter="name:${CLUSTERID}-apps-lb" \
  --format="value(address)")
gcloud dns record-sets transaction start \
  --zone=${DNSZONE}
gcloud dns record-sets transaction add ${APPSLBIP} \
  --name=\*.apps.${DOMAIN} \
  --ttl=${TTL} \
  --type=A \
  --zone=${DNSZONE}
gcloud dns record-sets transaction execute \
  --zone=${DNSZONE}

# Bastion host
echo "=> Creating DNS Record for bastion..."
export BASTIONIP=$(gcloud compute addresses list \
  --filter="name:${CLUSTERID}-bastion" \
  --format="value(address)")
gcloud dns record-sets transaction start \
  --zone=${DNSZONE}
gcloud dns record-sets transaction add ${BASTIONIP} \
  --name=bastion.${DOMAIN} \
  --ttl=${TTL} \
  --type=A \
  --zone=${DNSZONE}
gcloud dns record-sets transaction execute \
  --zone=${DNSZONE}
