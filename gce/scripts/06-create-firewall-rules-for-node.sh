#!/bin/bash

# Node to node SDN
echo "=> Creating Firewall Rule for OpenShift SDN..."
gcloud compute firewall-rules create ${CLUSTERID}-node-to-node \
  --direction=INGRESS \
  --priority=1000 \
  --network=${CLUSTERID_NETWORK} \
  --action=ALLOW \
  --rules=udp:4789 \
  --source-tags=${CLUSTERID}-node \
  --target-tags=${CLUSTERID}-node

# Infra to node kubelet
echo "=> Creating Firewall Rule for kubelet..."
gcloud compute firewall-rules create ${CLUSTERID}-infra-to-node \
  --direction=INGRESS \
  --priority=1000 \
  --network=${CLUSTERID_NETWORK} \
  --action=ALLOW \
  --rules=tcp:9100,tcp:10250 \
  --source-tags=${CLUSTERID}-infra \
  --target-tags=${CLUSTERID}-node
