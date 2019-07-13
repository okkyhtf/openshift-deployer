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

# Master nodes settings
export MASTER_SIZE="Standard_D4s_v3"
export MASTER_NODE_COUNT="3"
export MASTER_ROOT_SIZE="32GB"
export MASTER_LOG_SIZE="32GB"
export MASTER_CONTAINERS_SIZE="64GB"
export MASTER_LOCAL_SIZE="32GB"
export MASTER_ETCD_SIZE="32GB"

# Infra nodes settings
export INFRA_SIZE="Standard_D8s_v3"
export INFRA_NODE_COUNT="3"
export INFRA_ROOT_SIZE="32GB"
export INFRA_LOG_SIZE="32GB"
export INFRA_CONTAINERS_SIZE="64GB"
export INFRA_LOCAL_SIZE="32GB"

# App nodes settings
export APP_SIZE="Standard_D8s_v3"
export APP_NODE_COUNT="20"
export APP_ROOT_SIZE="32GB"
export APP_LOG_SIZE="32GB"
export APP_CONTAINERS_SIZE="64GB"
export APP_LOCAL_SIZE="32GB"

# Storage nodes settings
export STORAGE_SIZE="Standard_D8s_v3"
export STORAGE_NODE_COUNT="10"
export STORAGE_ROOT_SIZE="32GB"
export STORAGE_LOG_SIZE="32GB"
export STORAGE_CONTAINERS_SIZE="64GB"
export STORAGE_LOCAL_SIZE="32GB"
