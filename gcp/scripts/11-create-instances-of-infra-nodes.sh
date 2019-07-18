#!/bin/bash

# Disks multizone and single zone support
eval "$MYZONES_LIST"

for i in $(seq 0 $(($INFRA_NODE_COUNT-1))); do
  zone[$i]=${ZONES[$i % ${#ZONES[@]}]}
  echo "=> Creating Persistent Disk \"${CLUSTERID}-infra-${i}-containers\" at \"${zone[$i]}\"..."
  gcloud compute disks create ${CLUSTERID}-infra-${i}-containers \
    --type=${INFRADISKTYPE} \
    --size=${INFRACONTAINERSSIZE} \
    --zone=${zone[$i]}
  echo "=> Creating Persistent Disk \"${CLUSTERID}-infra-${i}-local\" at \"${zone[$i]}\"..."
  gcloud compute disks create ${CLUSTERID}-infra-${i}-local \
    --type=${INFRADISKTYPE} \
    --size=${INFRALOCALSIZE} \
    --zone=${zone[$i]}
done

# Infrastructure instances multizone and single zone support
for i in $(seq 0 $(($INFRA_NODE_COUNT-1))); do
  zone[$i]=${ZONES[$i % ${#ZONES[@]}]}
  echo "=> Creating Compute Engine Instance \"${CLUSTERID}-infra-${i}\" at \"${zone[$i]}\"..."
  gcloud compute instances create ${CLUSTERID}-infra-${i} \
    --async \
    --machine-type=${INFRASIZE} \
    --subnet=${CLUSTERID_SUBNET} \
    --address="" \
    --no-public-ptr \
    --maintenance-policy=MIGRATE \
    --scopes=https://www.googleapis.com/auth/cloud.useraccounts.readonly,https://www.googleapis.com/auth/compute,https://www.googleapis.com/auth/devstorage.read_write,https://www.googleapis.com/auth/logging.write,https://www.googleapis.com/auth/monitoring.write,https://www.googleapis.com/auth/service.management.readonly,https://www.googleapis.com/auth/servicecontrol \
    --tags=${CLUSTERID}-infra,${CLUSTERID}-node,${CLUSTERID}ocp \
    --metadata "ocp-cluster=${CLUSTERID},${CLUSTERID}-type=infra" \
    --image=${OSIMAGE} \
    --image-project=${OSIMAGEPROJECT} \
    --boot-disk-size=${INFRADISKSIZE} \
    --boot-disk-type=${INFRADISKTYPE} \
    --boot-disk-device-name=${CLUSTERID}-infra-${i} \
    --disk=name=${CLUSTERID}-infra-${i}-containers,device-name=${CLUSTERID}-infra-${i}-containers,mode=rw,boot=no \
    --disk=name=${CLUSTERID}-infra-${i}-local,device-name=${CLUSTERID}-infra-${i}-local,mode=rw,boot=no \
    --metadata-from-file startup-script=./initialize-infra-node.sh \
    --zone=${zone[$i]}
done

