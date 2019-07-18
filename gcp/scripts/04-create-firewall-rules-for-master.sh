#!/bin/bash

# Nodes to master
echo "=> Creating Firewall Rule for DNS..."
gcloud compute firewall-rules create ${CLUSTERID}-node-to-master \
  --direction=INGRESS \
  --priority=1000 \
  --network=${CLUSTERID_NETWORK} \
  --action=ALLOW \
  --rules=udp:8053,tcp:8053 \
  --source-tags=${CLUSTERID}-node \
  --target-tags=${CLUSTERID}-master

# Master to node
echo "=> Creating Firewall Rule for kubelet..."
gcloud compute firewall-rules create ${CLUSTERID}-master-to-node \
  --direction=INGRESS \
  --priority=1000 \
  --network=${CLUSTERID_NETWORK} \
  --action=ALLOW \
  --rules=tcp:10250 \
  --source-tags=${CLUSTERID}-master \
  --target-tags=${CLUSTERID}-node

# Master to master
echo "=> Creating Firewall Rule for etcd..."
gcloud compute firewall-rules create ${CLUSTERID}-master-to-master \
  --direction=INGRESS \
  --priority=1000 \
  --network=${CLUSTERID_NETWORK} \
  --action=ALLOW \
  --rules=tcp:2379,tcp:2380 \
  --source-tags=${CLUSTERID}-master \
  --target-tags=${CLUSTERID}-master

# Any to master
echo "=> Creating Firewall Rule for HTTPS..."
gcloud compute firewall-rules create ${CLUSTERID}-any-to-masters \
  --direction=INGRESS \
  --priority=1000  \
  --network=${CLUSTERID_NETWORK} \
  --action=ALLOW \
  --rules=tcp:443 \
  --source-ranges=${CLUSTERID_SUBNET_CIDR} \
  --target-tags=${CLUSTERID}-master

# Infra to master
echo "=> Creating Firewall Rule for Prometheus scrape job..."
gcloud compute firewall-rules create ${CLUSTERID}-infra-to-master \
  --direction=INGRESS \
  --priority=1000  \
  --network=${CLUSTERID_NETWORK} \
  --action=ALLOW \
  --rules=tcp:2379,tcp:8444 \
  --source-tags=${CLUSTERID}-infra \
  --target-tags=${CLUSTERID}-master
