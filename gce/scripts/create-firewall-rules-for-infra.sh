#!/bin/bash

# Infra node to infra node
echo "=> Creating Firewall Rule for Elasticsearch..."
gcloud compute firewall-rules create ${CLUSTERID}-infra-to-infra \
  --direction=INGRESS \
  --priority=1000 \
  --network=${CLUSTERID_NETWORK} \
  --action=ALLOW \
  --rules=tcp:9200,tcp:9300 \
  --source-tags=${CLUSTERID}-infra \
  --target-tags=${CLUSTERID}-infra

# Routers
echo "=> Creating Firewall Rule for HTTP/HTTPS..."
gcloud compute firewall-rules create ${CLUSTERID}-any-to-routers \
  --direction=INGRESS \
  --priority=1000 \
  --network=${CLUSTERID_NETWORK} \
  --source-ranges 0.0.0.0/0 \
  --target-tags ${CLUSTERID}-infra \
  --allow tcp:443,tcp:80
