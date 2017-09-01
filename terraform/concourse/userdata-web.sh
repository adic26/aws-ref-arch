#!/bin/bash -v

# Mount EBS device to specified location
mkfs -t ext4 /dev/xvdf
mkdir /opt/docker
mount /dev/xvdf /opt/docker

# Create concourse keys
mkdir -p keys/web

aws s3 cp s3://concourse-${team_name}-keys/session_signing_key ./keys/web/session_signing_key
aws s3 cp s3://concourse-${team_name}-keys/tsa_host_key ./keys/web/tsa_host_key
aws s3 cp s3://concourse-${team_name}-keys/session_signing_key.pub ./keys/web/session_signing_key.pub
aws s3 cp s3://concourse-${team_name}-keys/worker_key.pub ./keys/web/worker_key.pub

cp ./keys/web/worker_key.pub ./keys/web/authorized_worker_keys

mkdir -p /opt/docker/worker-state

# Run concourse
echo "${docker_compose_web}" > docker-compose.yml
/usr/local/bin/docker-compose up -d
