#!/bin/bash

for (( i=0; i<4; i++ ))
do
  az network nic create
    --resource-group ${RESOURCE_GROUP} \
    --name ocp-storage-${i}-nic \
    --vnet-name ${VNET} \
    --subnet ${SUBNET} \
    --network-security-group ${CLUSTERID}-storage-nsg \
    --internal-dns-name ${CLUSTERID}-ocp-storage-$i \
    --public-ip-address "";
done

for (( i=0; i<4; i++ ))
do
  az vm create \
    --resource-group ${RESOURCE_GROUP} \
    --name ocp-storage-$i \
    --availability-set ocp-storage-instances \
    --size Standard_D8s_v3 \
    --image RedHat:RHEL:7-RAW:latest \
    --admin-user cloud-user \
    --ssh-key ~/.ssh/azure.pub \
    --os-disk-name ${CLUSTERID}-ocp-storage-root-$i \
    --os-disk-size-gb ${STORAGE_ROOT_SIZE} \
    --nics ocp-storage-${i}-nic;
done

for (( i=0; i<4; i++ ))
do
  az vm disk attach \
    --resource-group ${RESOURCE_GROUP} \
    --vm-name ocp-storage-$i \
    --name ocp-storage-log-$i \
    --new \
    --size-gb ${STORAGE_LOG_SIZE};
done

for (( i=0; i<4; i++ ))
do
  az vm disk attach \
    --resource-group ${RESOURCE_GROUP} \
    --vm-name ocp-storage-$i \
    --name ocp-storage-container-$i \
    --new \
    --size-gb ${STORAGE_CONTAINER_SIZE};
done

for (( i=0; i<4; i++ ))
do
  az vm disk attach \
    --resource-group ${RESOURCE_GROUP} \
    --vm-name ocp-storage-$i \
    --name ocp-storage-local-$i \
    --new \
    --size-gb ${STORAGE_LOCAL_SIZE};
done

for (( i=0; i<4; i++ ))
do
  az vm disk attach \
    --resource-group ${RESOURCE_GROUP} \
    --vm-name ocp-storage-$i \
    --name ocp-storage-volume-$i \
    --sku Premium_LRS \
    --new \
    --size-gb ${STORAGE_VOLUME_SIZE};
 done
