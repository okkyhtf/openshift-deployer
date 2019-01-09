#!/bin/bash

# Timezone
export TIMEZONE="Asia/Jakarta"
# Google Project ID
export PROJECTID=""
# Google Region
export REGION="asia-southeast1"
export DEFAULTZONE="asia-southeast1-b"
# For multizone deployments
#ZONES=("asia-southeast1-a" "asia-southeast1-b" "asia-southeast1-c")
# For single zone deployments
ZONES=("asia-southeast1-b")
export MYZONES_LIST="$(declare -p ZONES)"
# Network and subnet configuration
export CLUSTERID_NETWORK="${CLUSTERID}-net"
export CLUSTERID_SUBNET="${CLUSTERID}-subnet"
# Subnet CIDR, modify if needed
export CLUSTERID_SUBNET_CIDR="10.240.0.0/24"
# DNS
#export DNSZONE="example-com"
#export DOMAIN="gce.example.com."
#export TTL=3600
# RHEL image to be used
#export RHELIMAGE="${CLUSTERID}-rhel-image"
#export IMAGEPROJECT="${PROJECTID}"
export OSIMAGE="centos-7-v20181210"
export OSIMAGEPROJECT="centos-cloud"
# Bastion settings
export BASTIONDISKSIZE="20GB"
export BASTIONSIZE="n1-standard-1"
# Master nodes settings
export MASTER_NODE_COUNT=3
export MASTERDISKSIZE="40GB"
export MASTERSIZE="n1-highmem-4"
export ETCDSIZE="50GB"
export MASTERCONTAINERSSIZE="20GB"
export MASTERLOCALSIZE="30GB"
# Infra nodes settings
export INFRA_NODE_COUNT=3
export INFRADISKSIZE="40GB"
# By default, 8Gi RAM is required to run elasticsearch pods
# as part of the aggregated logging component
export INFRASIZE="n1-highmem-4"
export INFRACONTAINERSSIZE="20GB"
export INFRALOCALSIZE="30GB"
# App nodes settings
export APP_NODE_COUNT=3
export APPDISKSIZE="40GB"
export APPSIZE="n1-highmem-4"
export APPCONTAINERSSIZE="20GB"
export APPLOCALSIZE="30GB"
# CNS nodes settings
#export CNS_NODE_COUNT=3
#export CNSDISKSIZE="40GB"
# By default, 8Gi RAM is required to run CNS nodes
#export CNSSIZE="n1-standard-8"
#export CNSDISKSIZE="40GB"
#export CNSCONTAINERSSIZE="20GB"
#export CNSGLUSTERSIZE="100GB"

