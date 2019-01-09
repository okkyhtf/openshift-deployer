#!/bin/bash

oc project openshift
oc apply -f https://raw.githubusercontent.com/jboss-container-images/openjdk/openjdk18-dev/templates/image-streams.json
oc apply -f https://raw.githubusercontent.com/jboss-container-images/openjdk/openjdk18-dev/templates/openjdk-web-basic-s2i.json
oc apply -f https://raw.githubusercontent.com/amsokol/openshift-golang-template/master/openshift-golang-template.yaml
