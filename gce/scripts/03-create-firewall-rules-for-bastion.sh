#!/bin/bash

# External to bastion
echo "=> Creating Firewall Rule for SSH..."
gcloud compute firewall-rules create ${CLUSTERID}-external-to-bastion \
  --direction=INGRESS \
  --priority=1000 \
  --network=${CLUSTERID_NETWORK} \
  --action=ALLOW \
  --rules=tcp:22,icmp \
  --source-ranges=0.0.0.0/0 \
  --target-tags=${CLUSTERID}-bastion

# Bastion to all hosts
echo "=> Creating Firewall Rule for accessing all nodes..."
gcloud compute firewall-rules create ${CLUSTERID}-bastion-to-any \
  --direction=INGRESS \
  --priority=1000 \
  --network=${CLUSTERID_NETWORK} \
  --action=ALLOW --rules=all \
  --source-tags=${CLUSTERID}-bastion \
  --target-tags=${CLUSTERID}-node
