#!/bin/bash

# Timezone
export TIMEZONE="Asia/Jakarta"

# Azure Resource Group
export RESOURCE_GROUP="MDR_Hackathon"

# Network configuration
export VNET="${CLUSTERID}-vnet"
export VNET_CIDR="10.0.0.0/16"

# Subnetwork configuration
export SUBNET="${CLUSTERID}-subnet"
export SUBNET_CIDR="10.0.0.0/24"
