#!/bin/bash

for i in $(eval echo "{1..${INFRA_NODE_COUNT}}"); do
  az network nic create \
    --resource-group ${RESOURCE_GROUP} \
    --name ${CLUSTERID}-ocp-infra-${i}VMNic \
    --vnet-name ${VNET} \
    --subnet ${SUBNET} \
    --network-security-group ${CLUSTERID}-infra-nsg \
    --lb-name ${CLUSTERID}-ocpRouterLB \
    --lb-address-pools ${CLUSTERID}-routerBackend \
    --internal-dns-name ${CLUSTERID}-ocp-infra-$i \
    --public-ip-address "";
done

for i in $(eval echo "{1..${INFRA_NODE_COUNT}}"); do
  az vm create \
    --resource-group ${RESOURCE_GROUP} \
    --name ${CLUSTERID}-ocp-infra-$i \
    --availability-set ${CLUSTERID}-ocp-infra-instances \
    --size ${INFRA_SIZE} \
    --image RedHat:RHEL:7-RAW:latest \
    --admin-user cloud-user \
    --ssh-key /root/.ssh/id_rsa.pub \
    --data-disk-sizes-gb ${INFRA_ROOT_SIZE} \
    --nics ${CLUSTERID}-ocp-infra-${i}VMNic;
done

for i in $(eval echo "{1..${INFRA_NODE_COUNT}}"); do
  az vm disk attach \
    --resource-group ${RESOURCE_GROUP} \
    --vm-name ${CLUSTERID}-ocp-infra-$i \
    --disk ${CLUSTERID}-ocp-infra-log-$i \
    --new \
    --size-gb ${INFRA_LOG_SIZE};
done

for i in $(eval echo "{1..${INFRA_NODE_COUNT}}"); do
  az vm disk attach \
    --resource-group ${RESOURCE_GROUP} \
    --vm-name ${CLUSTERID}-ocp-infra-$i \
    --disk ${CLUSTERID}-ocp-infra-container-$i \
    --new \
    --size-gb ${INFRA_CONTAINERS_SIZE};
done

for i in $(eval echo "{1..${INFRA_NODE_COUNT}}"); do
  az vm disk attach \
    --resource-group ${RESOURCE_GROUP} \
    --vm-name ${CLUSTERID}-ocp-infra-$i \
    --disk ${CLUSTERID}-ocp-infra-local-$i \
    --new \
    --size-gb ${INFRA_LOCAL_SIZE};
done
