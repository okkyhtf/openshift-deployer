#!/bin/bash

# Registry Storage
echo "=> Removing Registry Bucket..."
gsutil rb ${REGION} gs://${CLUSTERID}-registry

# Forwarding Rules
echo "=> Removing Forwarding Rules..."
gcloud compute forwarding-rules delete \
  ${CLUSTERID}-master-lb-forwarding-rule \
  ${CLUSTERID}-infra-http \
  ${CLUSTERID}-infra-https

# Target Pools
echo "=> Removing Target Pools"
gcloud compute target-pools delete \
  ${CLUSTERID}-infra

# HTTP Health Checks
echo "=> Removing HTTP Health Checks..."
gcloud compute http-health-checks delete \
  ${CLUSTERID}-infra-lb-healthcheck

# Firewall Rules
echo "=> Removing Firewall Rules..."
gcloud compute firewall-rules delete \
  ${CLUSTERID}-any-to-masters \
  ${CLUSTERID}-any-to-routers \
  ${CLUSTERID}-bastion-to-any \
  ${CLUSTERID}-external-to-bastion \
  ${CLUSTERID}-healthcheck-to-lb \
  ${CLUSTERID}-infra-to-infra \
  ${CLUSTERID}-infra-to-master \
  ${CLUSTERID}-infra-to-node \
  ${CLUSTERID}-master-to-master \
  ${CLUSTERID}-master-to-node \
  ${CLUSTERID}-node-to-master \
  ${CLUSTERID}-node-to-node

# Target TCP Proxies
echo "=> Removing Target TCP Proxies..."
gcloud compute target-tcp-proxies delete \
  ${CLUSTERID}-master-lb-target-proxy

# Instance Groups
echo "=> Removing Instance Groups..."
gcloud compute instance-groups unmanaged delete \
  ${CLUSTERID}-masters-${DEFAULT_ZONE}

# Backend Services
echo "=> Removing Backend Services..."
gcloud compute backend-services delete \
  ${CLUSTERID}-master-lb-backend

# Health Checks
echo "=> Removing Health Checks..."
gcloud compute health-checks delete \
  ${CLUSTERID}-master-lb-healthcheck

# Compute Instances
echo "=> Removing Compute Instances..."
gcloud compute instances delete \
  ${CLUSTERID}-bastion \
  ${CLUSTERID}-master-0 \
  ${CLUSTERID}-master-1 \
  ${CLUSTERID}-master-2 \
  ${CLUSTERID}-infra-0 \
  ${CLUSTERID}-infra-1 \
  ${CLUSTERID}-infra-2 \
  ${CLUSTERID}-compute-0 \
  ${CLUSTERID}-compute-1 \
  ${CLUSTERID}-compute-2

# Static IP Addresses
echo "=> Removing Static IP Addresses..."
gcloud compute addresses delete \
  ${CLUSTERID}-master-lb \
  ${CLUSTERID}-apps-lb \
  ${CLUSTERID}-bastion

# Subnets
echo "=> Removing Subnets..."
gcloud compute networks subnets delete \
  ${CLUSTERID}-subnet

# Networks
echo "=> Removing Networks..."
gcloud compute networks delete \
  ${CLUSTERID}-net

