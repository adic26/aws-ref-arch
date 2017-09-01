#!/bin/bash -v

# Run app
ARTIFACTORY_PWD=$(aws ssm get-parameters --names artifactory2.password --with-decryption --region us-east-1 | jq -r ."Parameters[0].Value")
ARTIFACTORY_USERNAME=$(aws ssm get-parameters --names artifactory2.username --with-decryption --region us-east-1 | jq -r ."Parameters[0].Value")

until docker login -u $ARTIFACTORY_USERNAME -p $ARTIFACTORY_PWD hbc-docker.jfrog.io; do sleep 2; done

echo "${docker_compose}" > docker-compose.yml
until /usr/local/bin/docker-compose up -d; do sleep 2; done

