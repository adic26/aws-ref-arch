# 3. Run Microservice Container Directly on EC2 Instances

Date: 2017-07-27

## Status

Accepted

## Context

The organization wants to move its microservice infrastructure to AWS. We need to decide how to run microservice containers on AWS.

#### Organizational Context: Decentralization of Ownership

The organization leadership wants to make teams fully own microservices. Full ownership here means they own _both code and infrastructure_ of certain microservices and how they perform in production.

The organization leadership wants to minimize shared services that when down will impact multiple teams (e.g. a shared container orchestration cluster). However, it is acceptable to depend on shared services that are managed by external parties, such as AWS or JFrog.

## Decision

We will run Docker containers directly on EC2 instances. Each EC2 instance will run one microservice container. We will use Autoscaling Groups to run / manage multiple instances of a microservice.

The primary reason for this decision is the organizational decision to give teams full ownership and to not have a separate platform / infrastructure team.

## Consequences

### Decentralized Infrastructure

There is no shared cluster to deploy to. Infrastructure is managed fully on per-microservice basis.

There is no per-team cluster to deploy to. Teams do not need to maintain both a container cluster and their containers. Instead they manage EC2 instances directly.
 
### Skills Expectation

All project team members are expected to be familiar with AWS products and be able to maintain infrastructure on AWS, since they cannot rely on a separate infrastructure / platform team.

There is no expectation to learn any container orchestration abstractions.

### Tied to AWS

Since we rely directly on AWS primitives, it will require considerable effort to move to another cloud provider if we decide to one day.