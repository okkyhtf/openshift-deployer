#!/bin/bash

for i in 1 2 3; do
  az network nic create \
    --resource-group ${RESOURCE_GROUP} \
    --name ${CLUSTERID}-ocp-master-${i}VMNic \
    --vnet-name ${VNET} \
    --subnet ${SUBNET} \
    --network-security-group ${CLUSTERID}-master-nsg \
    --lb-name ${CLUSTERID}-OcpMasterLB \
    --lb-address-pools ${CLUSTERID}-masterAPIBackend \
    --internal-dns-name ocp-master-${i} \
    --public-ip-address "";
done

for i in 1 2 3; do
  az vm create \
    --resource-group ${RESOURCE_GROUP} \
    --name ${CLUSTERID}-ocp-master-$i \
    --availability-set ${CLUSTERID}-ocp-master-instances \
    --size Standard_D4s_v3 \
    --image RedHat:RHEL:7-RAW:latest \
    --admin-user cloud-user \
    --ssh-key /root/.ssh/id_rsa.pub \
    --data-disk-sizes-gb 32 \
    --nics ${CLUSTERID}-ocp-master-${i}VMNic;
done

for i in 1 2 3; do
  az vm disk attach \
    --resource-group ${RESOURCE_GROUP} \
    --vm-name ${CLUSTERID}-ocp-master-$i \
    --disk ${CLUSTERID}-ocp-master-container-$i \
    --new \
    --size-gb 32;
done

for i in 1 2 3; do
  az vm disk attach \
    --resource-group ${RESOURCE_GROUP} \
    --vm-name ${CLUSTERID}-ocp-master-$i \
    --disk ${CLUSTERID}-ocp-master-etcd-$i \
    --new \
    --size-gb 32;
done
