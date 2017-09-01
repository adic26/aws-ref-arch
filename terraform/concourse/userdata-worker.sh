#!/bin/bash -v

# Mount EBS device to specified location
mkfs -t ext4 /dev/xvdf
mkdir /opt/docker
mount /dev/xvdf /opt/docker

# Create concourse keys
mkdir -p keys/worker

aws s3 cp s3://concourse-${team_name}-keys/worker_key.pub ./keys/worker/worker_key.pub
aws s3 cp s3://concourse-${team_name}-keys/worker_key ./keys/worker/worker_key
aws s3 cp s3://concourse-${team_name}-keys/tsa_host_key.pub ./keys/worker/tsa_host_key.pub

mkdir -p /opt/docker/worker-state

# Run concourse
echo "${docker_compose_worker}" > docker-compose.yml
/usr/local/bin/docker-compose up -d