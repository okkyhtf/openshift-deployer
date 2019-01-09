#!/bin/bash

# Disks multizone and single zone support
eval "$MYZONES_LIST"

for i in $(seq 0 $(($APP_NODE_COUNT-1))); do
  zone[$i]=${ZONES[$i % ${#ZONES[@]}]}
  echo "=> Creating Persistent Disk \"${CLUSTERID}-compute-${i}-containers\" at \"${zone[$i]}\"..."
  gcloud compute disks create ${CLUSTERID}-compute-${i}-containers \
    --type=pd-ssd \
    --size=${APPCONTAINERSSIZE} \
    --zone=${zone[$i]}
  echo "=> Creating Persistent Disk \"${CLUSTERID}-compute-${i}-local\" at \"${zone[$i]}\"..."
  gcloud compute disks create ${CLUSTERID}-compute-${i}-local \
    --type=pd-ssd \
    --size=${APPLOCALSIZE} \
    --zone=${zone[$i]}
done

# Application instances multizone and single zone support
for i in $(seq 0 $(($APP_NODE_COUNT-1))); do
  zone[$i]=${ZONES[$i % ${#ZONES[@]}]}
  echo "=> Creating Compute Engine Instance \"${CLUSTERID}-compute-${i}\" at \"${zone[$i]}\"..."
  gcloud compute instances create ${CLUSTERID}-compute-${i} \
    --async \
    --machine-type=${APPSIZE} \
    --subnet=${CLUSTERID_SUBNET} \
    --address="" \
    --no-public-ptr \
    --maintenance-policy=MIGRATE \
    --scopes=https://www.googleapis.com/auth/cloud.useraccounts.readonly,https://www.googleapis.com/auth/compute,https://www.googleapis.com/auth/devstorage.read_only,https://www.googleapis.com/auth/logging.write,https://www.googleapis.com/auth/monitoring.write,https://www.googleapis.com/auth/service.management.readonly,https://www.googleapis.com/auth/servicecontrol \
    --tags=${CLUSTERID}-node,${CLUSTERID}ocp \
    --metadata "ocp-cluster=${CLUSTERID},${CLUSTERID}-type=compute" \
    --image=${OSIMAGE} \
    --image-project=${OSIMAGEPROJECT} \
    --boot-disk-size=${APPDISKSIZE} \
    --boot-disk-type=pd-ssd \
    --boot-disk-device-name=${CLUSTERID}-compute-${i} \
    --disk=name=${CLUSTERID}-compute-${i}-containers,device-name=${CLUSTERID}-compute-${i}-containers,mode=rw,boot=no \
    --disk=name=${CLUSTERID}-compute-${i}-local,device-name=${CLUSTERID}-compute-${i}-local,mode=rw,boot=no \
    --metadata-from-file startup-script=./initialize-compute-node.sh \
    --zone=${zone[$i]}
done
