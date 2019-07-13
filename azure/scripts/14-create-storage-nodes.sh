#!/bin/bash

for i in $(eval echo "{1..${STORAGE_NODE_COUNT}}"); do
  az network nic create
    --resource-group ${RESOURCE_GROUP} \
    --name ocp-cns-${i}VMNic \
    --vnet-name ${VNET} \
    --subnet ${SUBNET} \
    --network-security-group ${CLUSTERID}-storage-nsg \
    --internal-dns-name ${CLUSTERID}-ocp-storage-$i \
    --public-ip-address "";
done

for i in $(eval echo "{1..${STORAGE_NODE_COUNT}}"); do
  az vm create \
    --resource-group ${RESOURCE_GROUP} \
    --name ocp-cns-$i \
    --availability-set ocp-cns-instances \
    --size Standard_D8s_v3 \
    --image RedHat:RHEL:7-RAW:latest \
    --admin-user cloud-user \
    --ssh-key /root/.ssh/id_rsa.pub \
    --data-disk-sizes-gb 32 \
    --nics ocp-cns-${i}VMNic;
done

for i in $(eval echo "{1..${STORAGE_NODE_COUNT}}"); do
  az vm disk attach \
    --resource-group ${RESOURCE_GROUP} \
    --vm-name ocp-cns-$i \
    --disk ocp-cns-container-$i \
    --new --size-gb 64;
done

for i in $(eval echo "{1..${STORAGE_NODE_COUNT}}"); do
  az vm disk attach \
    --resource-group ${RESOURCE_GROUP} \
    --vm-name ocp-cns-$i \
    --disk ocp-cns-volume-$i \
    --sku Premium_LRS \
    --new \
    --size-gb 512;
 done
