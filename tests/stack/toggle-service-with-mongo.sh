#!/usr/bin/env bash

set -ex

# Mongo Set-up
cd mongo
if [ ! -f mongo-key ] ; then
    openssl rand -base64 756 > mongo-key
    chmod 400 mongo-key
fi
terraform init
terraform apply

# Set up Toggle-Service
cd ../toggles
terraform init
terraform apply