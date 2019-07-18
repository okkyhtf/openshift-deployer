#!/bin/bash

# Base
BASE="wget git net-tools bind-utils yum-utils iptables-services bridge-utils bash-completion kexec-tools sos psacct pyOpenSSL python-cryptography python-lxml python-pip"

# OpenShift Logging
LOGGING="java-1.8.0-openjdk-headless patch"

# OpenShift Metrics
METRICS="httpd-tools python-passlib"

# Remote
REMOTE="tmux"

# Extras
EXTRAS="vim nano"

# Ansible version
VERSION="2.6.11"

# OpenShift CLI URL
OC_DIR="openshift-origin-client-tools-v3.11.0-0cbc58b-linux-64bit"
OC_TARBALL="${OC_DIR}.tar.gz"
OC_URL="https://github.com/openshift/origin/releases/download/v3.11.0/${OC_TARBALL}"

# Install all required packages
yum install -y ${BASE} ${LOGGING} ${METRICS} ${REMOTE} ${EXTRAS}

# Install Ansible
pip install "ansible==${VERSION}"

# Install OpenShift CLI
wget ${OC_URL} && tar xvvzpf ${OC_TARBALL} && mv ${OC_DIR}/oc /usr/local/bin/ && mv ${OC_DIR}/kubectl /usr/local/bin/ && rm -R ${OC_DIR} && rm -R ${IC_TARBALL}

