#!/bin/bash

for (( i=0; i<3; i++ ))
do
  echo "=> Creating NIC for Infra ${i}..."
  az network nic create \
    --resource-group ${RESOURCE_GROUP} \
    --name ${CLUSTERID}-ocp-infra-${i}-nic \
    --vnet-name ${VNET} \
    --subnet ${SUBNET} \
    --network-security-group ${CLUSTERID}-infra-nsg \
    --lb-name ${CLUSTERID}-ocp-router-lb \
    --lb-address-pools ${CLUSTERID}-router-backend \
    --internal-dns-name ${CLUSTERID}-ocp-infra-$i \
    --public-ip-address "";
done

for (( i=0; i<3; i++ ))
do
  echo "=> Creating Infra ${i}..."
  az vm create \
    --resource-group ${RESOURCE_GROUP} \
    --name ${CLUSTERID}-ocp-infra-$i \
    --availability-set ${CLUSTERID}-ocp-infra-instances \
    --size ${INFRA_SIZE} \
    --image RedHat:RHEL:7-RAW:latest \
    --admin-user cloud-user \
    --ssh-key ~/.ssh/azure.pub \
    --os-disk-name ${CLUSTERID}-ocp-infra-root-$i \
    --os-disk-size-gb ${INFRA_ROOT_SIZE} \
    --nics ${CLUSTERID}-ocp-infra-${i}-nic;
done

for (( i=0; i<3; i++ ))
do
  echo "=> Creating and attaching log disk to Infra ${i}..."
  az vm disk attach \
    --resource-group ${RESOURCE_GROUP} \
    --vm-name ${CLUSTERID}-ocp-infra-$i \
    --name ${CLUSTERID}-ocp-infra-log-$i \
    --new \
    --size-gb ${INFRA_LOG_SIZE};
done

for (( i=0; i<3; i++ ))
do
  echo "=> Creating and attaching container disk to Infra ${i}..."
  az vm disk attach \
    --resource-group ${RESOURCE_GROUP} \
    --vm-name ${CLUSTERID}-ocp-infra-$i \
    --name ${CLUSTERID}-ocp-infra-container-$i \
    --new \
    --size-gb ${INFRA_CONTAINER_SIZE};
done

for (( i=0; i<3; i++ ))
do
  echo "=> Creating and attaching local volume disk to Infra ${i}..."
  az vm disk attach \
    --resource-group ${RESOURCE_GROUP} \
    --vm-name ${CLUSTERID}-ocp-infra-$i \
    --name ${CLUSTERID}-ocp-infra-local-$i \
    --new \
    --size-gb ${INFRA_LOCAL_SIZE};
done
