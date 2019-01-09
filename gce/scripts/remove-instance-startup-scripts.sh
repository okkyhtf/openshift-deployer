#!/bin/bash

eval "$MYZONES_LIST"

# Master nodes
echo "=> Removing startup script for master nodes..."
for i in $(seq 0 $((${MASTER_NODE_COUNT}-1))); do
  zone[$i]=${ZONES[$i % ${#ZONES[@]}]}
  gcloud compute instances remove-metadata ${CLUSTERID}-master-${i} \
    --keys startup-script \
    --zone=${zone[$i]}
done

# Infrastructure nodes
echo "=> Removing startup script for infra nodes..."
for i in $(seq 0 $(($INFRA_NODE_COUNT-1))); do
  zone[$i]=${ZONES[$i % ${#ZONES[@]}]}
  gcloud compute instances remove-metadata ${CLUSTERID}-infra-${i} \
    --keys startup-script \
    --zone=${zone[$i]}
done

# Compute nodes
echo "=> Removing startup script for compute nodes..."
for i in $(seq 0 $(($APP_NODE_COUNT-1))); do
  zone[$i]=${ZONES[$i % ${#ZONES[@]}]}
  gcloud compute instances remove-metadata ${CLUSTERID}-compute-${i} \
    --keys startup-script \
    --zone=${zone[$i]}
done

