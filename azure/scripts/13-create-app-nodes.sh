#!/bin/bash

for (( i=0; i<25; i++ ))
do
  echo "=> Creating NIC for App ${i}..."
  az network nic create \
    --resource-group ${RESOURCE_GROUP} \
    --name ${CLUSTERID}-ocp-app-${i}-nic \
    --vnet-name ${VNET} \
    --subnet ${SUBNET} \
    --network-security-group ${CLUSTERID}-node-nsg \
    --internal-dns-name ${CLUSTERID}-ocp-app-$i \
    --public-ip-address "";
done

for (( i=0; i<25; i++ ))
do
  echo "=> Creating App ${i}..."
  az vm create \
    --resource-group ${RESOURCE_GROUP} \
    --name ${CLUSTERID}-ocp-app-$i \
    --availability-set ${CLUSTERID}-ocp-app-instances \
    --size ${APP_SIZE} \
    --image RedHat:RHEL:7-RAW:latest \
    --admin-user cloud-user \
    --ssh-key ~/.ssh/azure.pub \
    --os-disk-name ${CLUSTERID}-ocp-app-root-$i \
    --os-disk-size-gb ${APP_ROOT_SIZE} \
    --nics ${CLUSTERID}-ocp-app-${i}-nic; \
done

for (( i=0; i<25; i++ ))
do
  echo "=> Creating and attaching log disk to App ${i}..."
  az vm disk attach \
    --resource-group ${RESOURCE_GROUP} \
    --vm-name ${CLUSTERID}-ocp-app-$i \
    --name ${CLUSTERID}-ocp-app-log-$i \
    --new \
    --size-gb ${APP_LOG_SIZE};
done

for (( i=0; i<25; i++ ))
do
  echo "=> Creating and attaching container disk to App ${i}..."
  az vm disk attach \
    --resource-group ${RESOURCE_GROUP} \
    --vm-name ${CLUSTERID}-ocp-app-$i \
    --name ${CLUSTERID}-ocp-app-container-$i \
    --new \
    --size-gb ${APP_CONTAINER_SIZE};
done

for (( i=0; i<25; i++ ))
do
  echo "=> Creating and attaching local volume disk to App ${i}..."
  az vm disk attach \
    --resource-group ${RESOURCE_GROUP} \
    --vm-name ${CLUSTERID}-ocp-app-$i \
    --name ${CLUSTERID}-ocp-app-local-$i \
    --new \
    --size-gb ${APP_LOCAL_SIZE};
done
