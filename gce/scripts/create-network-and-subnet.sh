#!/bin/bash

# Network
echo "=> Creating VPC Network \"${CLUSTERID_NETWORK}\"..."
gcloud compute networks create ${CLUSTERID_NETWORK} \
  --subnet-mode custom

# Subnet
echo "=> Creating Subnet \"${CLUSTERID_SUBNET}\" with CIDR \"${CLUSTERID_SUBNET_CIDR}\" in VPC Network \"${CLUSTERID_NETWORK}\"..."
gcloud compute networks subnets create ${CLUSTERID_SUBNET} \
  --network ${CLUSTERID_NETWORK} \
  --range ${CLUSTERID_SUBNET_CIDR}
