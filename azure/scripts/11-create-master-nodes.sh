#!/bin/bash

for i in $(eval echo "{1..${MASTER_NODE_COUNT}}"); do
  az network nic create \
    --resource-group ${RESOURCE_GROUP} \
    --name ${CLUSTERID}-ocp-master-${i}VMNic \
    --vnet-name ${VNET} \
    --subnet ${SUBNET} \
    --network-security-group ${CLUSTERID}-master-nsg \
    --lb-name ${CLUSTERID}-OcpMasterLB \
    --lb-address-pools ${CLUSTERID}-masterAPIBackend \
    --internal-dns-name ${CLUSTERID}-ocp-master-${i} \
    --public-ip-address "";
done

for i in $(eval echo "{1..${MASTER_NODE_COUNT}}"); do
  az vm create \
    --resource-group ${RESOURCE_GROUP} \
    --name ${CLUSTERID}-ocp-master-$i \
    --availability-set ${CLUSTERID}-ocp-master-instances \
    --size ${MASTER_SIZE} \
    --image RedHat:RHEL:7-RAW:latest \
    --admin-user cloud-user \
    --ssh-key /root/.ssh/id_rsa.pub \
    --data-disk-sizes-gb ${MASTER_ROOT_SIZE} \
    --nics ${CLUSTERID}-ocp-master-${i}VMNic; 
done

for i in $(eval echo "{1..${MASTER_NODE_COUNT}}"); do
  az vm disk attach \
    --resource-group ${RESOURCE_GROUP} \
    --vm-name ${CLUSTERID}-ocp-master-$i \
    --disk ${CLUSTERID}-ocp-master-log-$i \
    --new \
    --size-gb ${MASTER_LOG_SIZE};
done

for i in $(eval echo "{1..${MASTER_NODE_COUNT}}"); do
  az vm disk attach \
    --resource-group ${RESOURCE_GROUP} \
    --vm-name ${CLUSTERID}-ocp-master-$i \
    --disk ${CLUSTERID}-ocp-master-containers-$i \
    --new \
    --size-gb ${MASTER_CONTAINERS_SIZE};
done

for i in $(eval echo "{1..${MASTER_NODE_COUNT}}"); do
  az vm disk attach \
    --resource-group ${RESOURCE_GROUP} \
    --vm-name ${CLUSTERID}-ocp-master-$i \
    --disk ${CLUSTERID}-ocp-master-local-$i \
    --new \
    --size-gb ${MASTER_LOCAL_SIZE};
done

for i in $(eval echo "{1..${MASTER_NODE_COUNT}}"); do
  az vm disk attach \
    --resource-group ${RESOURCE_GROUP} \
    --vm-name ${CLUSTERID}-ocp-master-$i \
    --disk ${CLUSTERID}-ocp-master-etcd-$i \
    --new \
    --size-gb ${MASTER_ETCD_SIZE};
done
