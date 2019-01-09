#!/bin/bash

# Bucket to host registry
echo "=> Creating Bucket \"${CLUSTERID}-registry\" for registry..."
gsutil mb -l ${REGION} gs://${CLUSTERID}-registry

cat <<EOF > labels.json
{
  "ocp-cluster": "${CLUSTERID}"
}
EOF

gsutil label set labels.json gs://${CLUSTERID}-registry
rm -f labels.json

