#!/bin/bash

# Disks multizone and single zone support
eval "$MYZONES_LIST"

for i in $(seq 0 $((${MASTER_NODE_COUNT}-1)))
do
  zone[$i]=${ZONES[$i % ${#ZONES[@]}]}
  echo "=> Creating Persistent Disk \"${CLUSTERID}-master-${i}-etcd\" at \"${zone[$i]}\"..."
  gcloud compute disks create ${CLUSTERID}-master-${i}-etcd \
    --type=${MASTERDISKTYPE} \
    --size=${ETCDSIZE} \
    --zone=${zone[$i]}
  echo "=> Creating Persistent Disk \"${CLUSTERID}-master-${i}-containers\" at \"${zone[$i]}\"..."
  gcloud compute disks create ${CLUSTERID}-master-${i}-containers \
    --type=${MASTERDISKTYPE} \
    --size=${MASTERCONTAINERSSIZE} \
    --zone=${zone[$i]}
  echo "=> Creating Persistent Disk \"${CLUSTERID}-master-${i}-local\" at \"${zone[$i]}\"..."
  gcloud compute disks create ${CLUSTERID}-master-${i}-local \
    --type=${MASTERDISKTYPE} \
    --size=${MASTERLOCALSIZE} \
    --zone=${zone[$i]}
done

# Master instances multizone and single zone support
for i in $(seq 0 $((${MASTER_NODE_COUNT}-1)))
do
  zone[$i]=${ZONES[$i % ${#ZONES[@]}]}
  echo "=> Creating Compute Engine Instance \"${CLUSTERID}-master-${i}\" at \"${zone[$i]}\"..."
  gcloud compute instances create ${CLUSTERID}-master-${i} \
    --async \
    --machine-type=${MASTERSIZE} \
    --subnet=${CLUSTERID_SUBNET} \
    --address="" \
    --no-public-ptr \
    --maintenance-policy=MIGRATE \
    --scopes=compute-rw,storage-rw,service-management,service-control,logging-write,monitoring-write \
    --service-account=${SERVICE_ACCOUNT}@${PROJECT}.iam.gserviceaccount.com \
    --tags=${CLUSTERID}-master,${CLUSTERID}-node \
    --metadata "ocp-cluster=${CLUSTERID},${CLUSTERID}-type=master" \
    --image=${OSIMAGE} \
    --image-project=${OSIMAGEPROJECT} \
    --boot-disk-size=${MASTERDISKSIZE} \
    --boot-disk-type=pd-ssd \
    --boot-disk-device-name=${CLUSTERID}-master-${i} \
    --disk=name=${CLUSTERID}-master-${i}-etcd,device-name=${CLUSTERID}-master-${i}-etcd,mode=rw,boot=no \
    --disk=name=${CLUSTERID}-master-${i}-containers,device-name=${CLUSTERID}-master-${i}-containers,mode=rw,boot=no \
    --disk=name=${CLUSTERID}-master-${i}-local,device-name=${CLUSTERID}-master-${i}-local,mode=rw,boot=no \
    --metadata-from-file startup-script=./initialize-master-node.sh \
    --zone=${zone[$i]}
done
