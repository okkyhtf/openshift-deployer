#!/bin/bash

export BASTIONIP=$(gcloud compute addresses list \
  --filter="name:${CLUSTERID}-bastion" \
  --format="value(address)")
echo "=> Creating Compute Engine Instance \"${CLUSTERID}-bastion\"..."
gcloud compute instances create ${CLUSTERID}-bastion \
  --async \
  --machine-type=${BASTIONSIZE} \
  --subnet=${CLUSTERID_SUBNET} \
  --address=${BASTIONIP} \
  --maintenance-policy=MIGRATE \
  --scopes=https://www.googleapis.com/auth/cloud.useraccounts.readonly,https://www.googleapis.com/auth/compute,https://www.googleapis.com/auth/devstorage.read_write,https://www.googleapis.com/auth/logging.write,https://www.googleapis.com/auth/monitoring.write,https://www.googleapis.com/auth/service.management.readonly,https://www.googleapis.com/auth/servicecontrol \
  --tags=${CLUSTERID}-bastion \
  --metadata "ocp-cluster=${CLUSTERID},${CLUSTERID}-type=bastion" \
  --image=${OSIMAGE} \
  --image-project=${OSIMAGEPROJECT} \
  --boot-disk-size=${BASTIONDISKSIZE} \
  --boot-disk-type=${BASTIONDISKTYPE} \
  --boot-disk-device-name=${CLUSTERID}-bastion \
  --metadata-from-file startup-script=./initialize-bastion-host.sh \
  --zone=${DEFAULTZONE}
