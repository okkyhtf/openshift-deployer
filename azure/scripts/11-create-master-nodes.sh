#!/bin/bash

for (( i=0; i<3; i++ ))
do
  echo "=> Creating NIC for Master ${i}..."
  az network nic create \
    --resource-group ${RESOURCE_GROUP} \
    --name ${CLUSTERID}-ocp-master-${i}-nic \
    --vnet-name ${VNET} \
    --subnet ${SUBNET} \
    --network-security-group ${CLUSTERID}-master-nsg \
    --lb-name ${CLUSTERID}-ocp-master-lb \
    --lb-address-pools ${CLUSTERID}-master-api-backend \
    --internal-dns-name ${CLUSTERID}-ocp-master-${i} \
    --public-ip-address "";
done

for (( i=0; i<3; i++ ))
do
  echo "=> Creating Master ${i}..."
  az vm create \
    --resource-group ${RESOURCE_GROUP} \
    --name ${CLUSTERID}-ocp-master-$i \
    --availability-set ${CLUSTERID}-ocp-master-instances \
    --size ${MASTER_SIZE} \
    --image RedHat:RHEL:7-RAW:latest \
    --admin-user cloud-user \
    --ssh-key ~/.ssh/azure.pub \
    --os-disk-name ${CLUSTERID}-ocp-master-root-$i \
    --os-disk-size-gb ${MASTER_ROOT_SIZE} \
    --nics ${CLUSTERID}-ocp-master-${i}-nic; 
done

for (( i=0; i<3; i++ ))
do
  echo "=> Creating and attaching log disk to Master ${i}..."
  az vm disk attach \
    --resource-group ${RESOURCE_GROUP} \
    --vm-name ${CLUSTERID}-ocp-master-$i \
    --name ${CLUSTERID}-ocp-master-log-$i \
    --new \
    --size-gb ${MASTER_LOG_SIZE};
done

for (( i=0; i<3; i++ ))
do
  echo "=> Creating and attaching container disk to Master ${i}..."
  az vm disk attach \
    --resource-group ${RESOURCE_GROUP} \
    --vm-name ${CLUSTERID}-ocp-master-$i \
    --name ${CLUSTERID}-ocp-master-container-$i \
    --new \
    --size-gb ${MASTER_CONTAINER_SIZE};
done

for (( i=0; i<3; i++ ))
do
  echo "=> Creating and attaching local volume disk to Master ${i}..."
  az vm disk attach \
    --resource-group ${RESOURCE_GROUP} \
    --vm-name ${CLUSTERID}-ocp-master-$i \
    --name ${CLUSTERID}-ocp-master-local-$i \
    --new \
    --size-gb ${MASTER_LOCAL_SIZE};
done

for (( i=0; i<3; i++ ))
do
  echo "=> Creating and attaching etcd disk to Master ${i}..."
  az vm disk attach \
    --resource-group ${RESOURCE_GROUP} \
    --vm-name ${CLUSTERID}-ocp-master-$i \
    --name ${CLUSTERID}-ocp-master-etcd-$i \
    --new \
    --size-gb ${MASTER_ETCD_SIZE};
done
