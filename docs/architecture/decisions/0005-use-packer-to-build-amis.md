# 4. Use Packer to Build AMIs

Date: 2017-07-27

## Status

Accepted

## Context

In provisioning infrastructure, we need a base image that will have have our dependencies pre-baked
  to ensure consistency in versions across machines and decrease the time it takes to provision our servers. 
  [Packer](https://www.packer.io/) is an open source HashiCorp product that allows us to automate 
  the creation of any machine image. What does Packer give us?
  * Automate creation of Amazon AMIs
  * Contents of machine image in code via Packer templates
  * Packer templates checked in Version Control
  * Command Line driven and able to integrate in CD pipeline
  * Ability to create identical images for multiple platforms
  * Use of Amazon EC2 instances as builders, as well as other options.
  * Ability to build an AMI off another AMI
  * Made by same company as Terraform


## Decision

There were two approaches used to create AMIs; the first was from an EC2 instance in the AWS console
 and the second was from Packer.
 1. In the short term, creating an ami from an EC2 instance is the easiest approach as it is a click
 of a button once an EC2 instance has been provisioned. The downside is once that instance is destroyed,
 we can't tell what is baked into the EC2 instance. If we want to use the AMI in the future, we'd have to
 document everything that was baked into the AMI. There is also complexity in the process to create a new 
 AMI, which isn't sustainable.
 2. Packer allows us automate the creation of AMIs with code. This allows us to make changes to the AMI
 in the future that can be tracked by VCS. This also means we can let the code document the contents 
 of the AMI. This is more sustainable, because we are able to build on what is needed in all machines 
 provisioned. 
 3. Packer is cloud agnostic -- if we ever make a decision to move from AWS, it'll be easier to switch to another 
 IaaS option.
 

## Consequences

1. Another tool to learn
2. Teams have a clear understanding of what exists in their AMIs
