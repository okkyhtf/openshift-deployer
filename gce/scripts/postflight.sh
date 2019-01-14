#!/bin/bash

ansible masters[0] -i inventory.ini -b -m fetch -a "src=/root/.kube/config dest=/root/.kube/config flat=yes"

oc project openshift
oc apply -f https://raw.githubusercontent.com/jboss-container-images/openjdk/openjdk18-dev/templates/image-streams.json
oc apply -f https://raw.githubusercontent.com/jboss-container-images/openjdk/openjdk18-dev/templates/openjdk-web-basic-s2i.json
oc apply -f https://raw.githubusercontent.com/amsokol/openshift-golang-template/master/openshift-golang-template.yaml
