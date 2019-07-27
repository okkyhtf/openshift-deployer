#!/bin/bash

# Bucket to host registry
echo "=> Creating Bucket \"${CLUSTERID}-demo10447-registry\" for registry..."
gsutil mb -l ${REGION} gs://${CLUSTERID}-demo10447-registry

cat <<EOF > labels.json
{
  "ocp-cluster": "${CLUSTERID}"
}
EOF

gsutil label set labels.json gs://${CLUSTERID}-demo10447-registry
rm -f labels.json

