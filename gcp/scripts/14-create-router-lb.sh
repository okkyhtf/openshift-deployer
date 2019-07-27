#!/bin/bash

# Health check
echo "=> Creating Health Check for HAProxy..."
gcloud compute http-health-checks create ${CLUSTERID}-infra-lb-healthcheck \
  --port 1936 \
  --request-path "/healthz" \
  --check-interval=10s \
  --timeout=10s \
  --healthy-threshold=3 \
  --unhealthy-threshold=3

# Target Pool
echo "=> Creating Target Pool \"${CLUSTERID}-infra\"..."
gcloud compute target-pools create ${CLUSTERID}-infra \
  --http-health-check ${CLUSTERID}-infra-lb-healthcheck

for i in $(seq 0 $(($INFRA_NODE_COUNT-1)))
do
  echo "=> Adding infra nodes to target pool..."
  gcloud compute target-pools add-instances ${CLUSTERID}-infra \
    --instances=${CLUSTERID}-infra-${i}
done

# Forwarding rules and firewall rules
export APPSLBIP=$(gcloud compute addresses list \
  --filter="name:${CLUSTERID}-apps-lb" \
  --format="value(address)")

echo "=> Creating Forwarding Rule for HTTP..."
gcloud compute forwarding-rules create ${CLUSTERID}-infra-http \
  --ports 80 \
  --address ${APPSLBIP} \
  --region ${REGION} \
  --target-pool ${CLUSTERID}-infra

echo "=> Creating Forwarding Rule for HTTPS..."
gcloud compute forwarding-rules create ${CLUSTERID}-infra-https \
  --ports 443 \
  --address ${APPSLBIP} \
  --region ${REGION} \
  --target-pool ${CLUSTERID}-infra

