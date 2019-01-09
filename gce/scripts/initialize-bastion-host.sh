#!/bin/bash

# Base
BASE="wget git net-tools bind-utils yum-utils iptables-services bridge-utils bash-completion kexec-tools sos psacct pyOpenSSL python-cryptography python-lxml"

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

# Install all required packages
yum install -y ${BASE} ${LOGGING} ${METRICS} ${REMOTE}

# Install Ansible
pip install "ansible==${VERSION}"


