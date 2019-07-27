#!/bin/bash

# Disks multizone and single zone support
eval "$MYZONES_LIST"

for i in $(seq 0 $(($APP_NODE_COUNT-1)))
do
  zone[$i]=${ZONES[$i % ${#ZONES[@]}]}
  echo "=> Creating Persistent Disk \"${CLUSTERID}-compute-${i}-containers\" at \"${zone[$i]}\"..."
  gcloud compute disks create ${CLUSTERID}-compute-${i}-containers \
    --type=${APPDISKTYPE} \
    --size=${APPCONTAINERSSIZE} \
    --zone=${zone[$i]}
  echo "=> Creating Persistent Disk \"${CLUSTERID}-compute-${i}-local\" at \"${zone[$i]}\"..."
  gcloud compute disks create ${CLUSTERID}-compute-${i}-local \
    --type=${APPDISKTYPE} \
    --size=${APPLOCALSIZE} \
    --zone=${zone[$i]}
done

# Application instances multizone and single zone support
for i in $(seq 0 $(($APP_NODE_COUNT-1)))
do
  zone[$i]=${ZONES[$i % ${#ZONES[@]}]}
  echo "=> Creating Compute Engine Instance \"${CLUSTERID}-compute-${i}\" at \"${zone[$i]}\"..."
  gcloud compute instances create ${CLUSTERID}-compute-${i} \
    --async \
    --machine-type=${APPSIZE} \
    --subnet=${CLUSTERID_SUBNET} \
    --address="" \
    --no-public-ptr \
    --maintenance-policy=MIGRATE \
    --scopes=compute-rw,storage-rw,service-management,service-control,logging-write,monitoring-write \
    --service-account=${SERVICE_ACCOUNT}@${PROJECT}.iam.gserviceaccount.com \
    --tags=${CLUSTERID}-node,${CLUSTERID}ocp \
    --metadata "ocp-cluster=${CLUSTERID},${CLUSTERID}-type=compute" \
    --image=${OSIMAGE} \
    --image-project=${OSIMAGEPROJECT} \
    --boot-disk-size=${APPDISKSIZE} \
    --boot-disk-type=${APPDISKTYPE} \
    --boot-disk-device-name=${CLUSTERID}-compute-${i} \
    --disk=name=${CLUSTERID}-compute-${i}-containers,device-name=${CLUSTERID}-compute-${i}-containers,mode=rw,boot=no \
    --disk=name=${CLUSTERID}-compute-${i}-local,device-name=${CLUSTERID}-compute-${i}-local,mode=rw,boot=no \
    --metadata-from-file startup-script=./initialize-compute-node.sh \
    --zone=${zone[$i]}
done
