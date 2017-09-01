#!/usr/bin/env bash

set -e

sudo mkdir -p /etc/yum.repos.d
sudo tee -a /etc/yum.repos.d/mongodb-org-${MONGO_VERSION}.repo <<EOF

[mongodb-org-${MONGO_VERSION}]
name=MongoDB Repository
baseurl=https://repo.mongodb.org/yum/amazon/2013.03/mongodb-org/${MONGO_VERSION}/x86_64/
gpgcheck=1
enabled=1
gpgkey=https://www.mongodb.org/static/pgp/server-${MONGO_VERSION}.asc

EOF

sudo yum install -y mongodb-org jq