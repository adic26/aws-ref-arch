#!/usr/bin/env bash

set -e

# Install docker
sudo yum update -y
sudo yum install docker -y
sudo service docker start
sudo usermod -a -G docker ec2-user

# Install docker-compose
sudo pip install docker-compose

docker-compose --version


