# 5. Use Terraform to Build AWS Infrastructure

Date: 2017-07-27

## Status

Accepted

## Context

What we need?
- Ability to provision AWS resources (EC2, VPC, etc...)
- Reusable provisioning components. We want other teams to be able to easily use the infra building blocks that we create.

What is nice to have?
- Terse and expressive markdown. 
- Strong community or enterprise involvement and support. We want to ensure that the tool we use is actively maintained, the community who uses it supports each other, and the tool we choose is familiar to new HBC team members. 


## Decision

We trialed both [CloudFormation](https://aws.amazon.com/cloudformation/) and [Terraform](https://www.terraform.io/intro/index.html) when choosing an infrastructure provisioning tool. Our team decided to use Terraform for the following reasons:
 1. While both Terraform and CloudFormation are able to create reusable components, we found that Terraform made it easier to create modular components. To reuse a CloudFormation component it must first be stored in S3, then imported into the current component you are building. This is great for teams that want to consume our components, but makes it very  difficult to maintain components because of large definition files -- which our team was producing (i.e. Canary, Microservice, Concourse). Terraform will allow you to break up your component definition into modular pieces that can be stored in local directories relative to the component you are building. An example of this can be seen in [mongo](../../../terraform/mongo). The benefit here is that Terraform allows us to utilize a design pattern that makes maintaining our component much easier.
 2. Being from AWS, CloudFormation will support provisioning any AWS resource. Terraform does not share this level of support but has a very strong and active community which has created Terraform resources for most AWS resources. We were never limited by terraform when provisioning new AWS resources.
 3. Cloudformation is specific to AWS, so if we ever change cloud providers, it would cause for a total rework in a new language. Terraform is cloud agnostic which makes it easier to switch to a new cloud provider if needed as it integrates.
 4. Terraform separates the stages of infrastructure provisioning to a `plan` stage followed by an `apply` stage. With this, developers are able to first check to see what infrastructure will be created/modified/destroyed before applying any infra changes. CloudFormation does not allow for a planning stage, and developers will need to debug issues only after applying their CloudFormation templates.
 5. Terraform is very terse. You write configurations using [HCL](https://www.terraform.io/docs/configuration/syntax.html) a HashiCorp created configuration language. This is much more readable than the JSON or YAML configuration needed for CloudFormation.

## Consequences

- Since Terraform is not created by AWS, there is a chance that it can not fully provision an AWS resource. We have not had this issue yet though.
- Terraform is a common tool -- there is a chance that new hires will already be familiar with creating infrastructure using Terraform.