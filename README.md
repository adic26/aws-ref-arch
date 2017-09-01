Rogue Squadron Infra
=======

## Pre-requisite

Make sure you have:

1. [Terraform](https://brew.sh/) installed
2. Configured aws credentials (i.e. aws configure)

## Structure

[`./terraform`](terraform): Terraform modules used

[`./tests`](tests): tests against the Terraform modules (bleeding edge version), named by module

[`./concourse-images`](concourse-images): Docker images that the aws-ref-arch Concourse pipeline uses to build and deploy 

## Terraform modules

**[Canary](terraform/canary)**: Use this module if you wish to release your microservice using the [canary technique](https://martinfowler.com/bliki/CanaryRelease.html).

**[Concourse](terraform/concourse)**: Use this module if you wish to setup [Concourse CI](https://concourse.ci/index.html) for your team. 

**[Microservice](terraform/microservice)**: Use this module if you wish to deploy a single application stack on AWS. This can be used for releasing to lower environments or deploying services that do not need a canary.

**[Mongo](terraform/mongo)**: Use this module if you wish to create a [mongo replica set](https://docs.mongodb.com/manual/replication/).