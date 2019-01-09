#!/bin/bash

# Health check
echo "=> Creating Health Check for HTTPS..."
gcloud compute health-checks create https ${CLUSTERID}-master-lb-healthcheck \
    --port 443 \
    --request-path "/healthz" \
    --check-interval=10s \
    --timeout=10s \
    --healthy-threshold=3 \
    --unhealthy-threshold=3

# Create backend and set client ip affinity to avoid websocket timeout
echo "=> Creating TCP Backend Service with client IP affinity..."
gcloud compute backend-services create ${CLUSTERID}-master-lb-backend \
    --global \
    --protocol TCP \
    --session-affinity CLIENT_IP \
    --health-checks ${CLUSTERID}-master-lb-healthcheck \
    --port-name ocp-api

eval "$MYZONES_LIST"

# Multizone and single zone support for instance groups
for i in $(seq 0 $((${MASTER_NODE_COUNT}-1))); do
  zone[$i]=${ZONES[$i % ${#ZONES[@]}]}
  echo "=> Creating Instance Group \"${CLUSTERID}-masters-${zone[$i]}\" at \"${zone[$i]}\" with backend service"
  gcloud compute instance-groups unmanaged create ${CLUSTERID}-masters-${zone[$i]} \
    --zone=${zone[$i]}
  gcloud compute instance-groups unmanaged set-named-ports ${CLUSTERID}-masters-${zone[$i]} \
    --named-ports=ocp-api:443 \
    --zone=${zone[$i]}
  gcloud compute instance-groups unmanaged add-instances ${CLUSTERID}-masters-${zone[$i]} \
    --instances=${CLUSTERID}-master-${i} \
    --zone=${zone[$i]}
  # Instances are added to the backend service
  gcloud compute backend-services add-backend ${CLUSTERID}-master-lb-backend \
    --global \
    --instance-group ${CLUSTERID}-masters-${zone[$i]} \
    --instance-group-zone ${zone[$i]}
done

# Do not set any proxy header to be transparent
echo "=> Disabling proxy headers..."
gcloud compute target-tcp-proxies create ${CLUSTERID}-master-lb-target-proxy \
    --backend-service ${CLUSTERID}-master-lb-backend \
    --proxy-header NONE

export LBIP=$(gcloud compute addresses list \
  --filter="name:${CLUSTERID}-master-lb" \
  --format="value(address)")

# Forward only 443/tcp port
echo "=> Creating Forwarding Rule for HTTPS..."
gcloud compute forwarding-rules create ${CLUSTERID}-master-lb-forwarding-rule \
  --global \
  --target-tcp-proxy ${CLUSTERID}-master-lb-target-proxy \
  --address ${LBIP} \
  --ports 443

# Allow health checks from Google health check IPs
echo "=> Creating Firewall Rule for health check..."
gcloud compute firewall-rules create ${CLUSTERID}-healthcheck-to-lb \
  --direction=INGRESS \
  --priority=1000 \
  --network=${CLUSTERID_NETWORK} \
  --source-ranges 130.211.0.0/22,35.191.0.0/16 \
  --target-tags ${CLUSTERID}-master \
  --allow tcp:443

