#!/bin/bash

for i in $(eval echo "{1..${APP_NODE_COUNT}}"); do
  az network nic create \
    --resource-group ${RESOURCE_GROUP} \
    --name ${CLUSTERID}-ocp-app-${i}VMNic \
    --vnet-name ${VNET} \
    --subnet ${SUBNET} \
    --network-security-group ${CLUSTERID}-node-nsg \
    --internal-dns-name ${CLUSTERID}-ocp-app-$i \
    --public-ip-address "";
done

for i in $(eval echo "{1..${APP_NODE_COUNT}}"); do
  az vm create \
    --resource-group ${RESOURCE_GROUP} \
    --name ${CLUSTERID}-ocp-app-$i \
    --availability-set ${CLUSTERID}-ocp-app-instances \
    --size ${APP_SIZE} \
    --image RedHat:RHEL:7-RAW:latest \
    --admin-user cloud-user \
    --ssh-key /root/.ssh/id_rsa.pub \
    --data-disk-sizes-gb ${APP_ROOT_SIZE} \
    --nics ${CLUSTERID}-ocp-app-${i}VMNic; \
done

for i in $(eval echo "{1..${APP_NODE_COUNT}}"); do
  az vm disk attach \
    --resource-group ${RESOURCE_GROUP} \
    --vm-name ${CLUSTERID}-ocp-app-$i \
    --disk ${CLUSTERID}-ocp-app-log-$i \
    --new
    --size-gb ${APP_LOG_SIZE};
done

for i in $(eval echo "{1..${APP_NODE_COUNT}}"); do
  az vm disk attach \
    --resource-group ${RESOURCE_GROUP} \
    --vm-name ${CLUSTERID}-ocp-app-$i \
    --disk ${CLUSTERID}-ocp-app-container-$i \
    --new
    --size-gb ${APP_CONTAINERS_SIZE};
done

for i in $(eval echo "{1..${APP_NODE_COUNT}}"); do
  az vm disk attach \
    --resource-group ${RESOURCE_GROUP} \
    --vm-name ${CLUSTERID}-ocp-app-$i \
    --disk ${CLUSTERID}-ocp-app-local-$i \
    --new
    --size-gb ${APP_LOCAL_SIZE};
done
