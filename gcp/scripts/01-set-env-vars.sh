#!/bin/bash

# Timezone
export TIMEZONE="Asia/Jakarta"

# Google Project ID
export PROJECTID="PROJECT"
export SERVICE_ACCOUNT="SERVICE_ACCOUNT"

# Google Region
export REGION="asia-southeast1"
export DEFAULTZONE="asia-southeast1-b"

# For multizone deployments
#ZONES=("asia-southeast1-a" "asia-southeast1-b" "asia-southeast1-c")
# For single zone deployments
ZONES=("asia-southeast1-b")
export MYZONES_LIST="$(declare -p ZONES)"

# Network and subnet configuration
export CLUSTERID_NETWORK="openshift-net"
export CLUSTERID_SUBNET="openshift-subnet"

# Subnet CIDR, modify if needed
export CLUSTERID_SUBNET_CIDR="10.240.1.0/24"

# DNS
export DNSZONE="DNSZONE"
export DOMAIN="DOMAIN"
export TTL=300

# RHEL image to be used
#export RHELIMAGE="demo10447-rhel-image"
#export IMAGEPROJECT="rht-id-ocp-labs"
#export OSIMAGE="centos-7-v20181210"
#export OSIMAGEPROJECT="centos-cloud"
export OSIMAGE="RHELIMAGE"
export OSIMAGEPROJECT="IMAGEPROJECT"

# Bastion settings
export BASTIONDISKSIZE="16GB"
export BASTIONDISKTYPE="pd-standard"
export BASTIONSIZE="n1-standard-2"

# Master nodes settings
export MASTER_NODE_COUNT=3
export MASTERDISKSIZE="32GB"
export MASTERDISKTYPE="pd-ssd"
export MASTERSIZE="n1-highmem-4"
export ETCDSIZE="32GB"
export MASTERCONTAINERSSIZE="64GB"
export MASTERLOCALSIZE="8GB"

# Infra nodes settings
export INFRA_NODE_COUNT=3
export INFRADISKSIZE="32GB"
export INFRADISKTYPE="pd-ssd"
# By default, 8Gi RAM is required to run elasticsearch pods
# as part of the aggregated logging component
export INFRASIZE="n1-highmem-4"
export INFRACONTAINERSSIZE="64GB"
export INFRALOCALSIZE="8GB"

# App nodes settings
export APP_NODE_COUNT=3
export APPDISKSIZE="32GB"
export APPDISKTYPE="pd-ssd"
export APPSIZE="n1-highmem-4"
export APPCONTAINERSSIZE="64GB"
export APPLOCALSIZE="8GB"

# CNS nodes settings
#export CNS_NODE_COUNT=3
#export CNSDISKSIZE="40GB"
# By default, 8Gi RAM is required to run CNS nodes
#export CNSSIZE="n1-standard-8"
#export CNSDISKSIZE="40GB"
#export CNSCONTAINERSSIZE="20GB"
#export CNSGLUSTERSIZE="100GB"

