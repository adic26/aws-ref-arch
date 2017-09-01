# Microservice

This module provisions the infrastructure needed to deploy a HBC microservice. The infrastructure that will be created in AWS can be seen below:

![Microservice Infrastructure](microservice-diagram.png)

An example of how to use this module can be seen in the [canary module](../canary).

## Usage

1. Source the microservice module to your terraform file. See [canary](../canary/main.tf) for an example.
2. Set the required microservice input variables -- you may do this by using a [terraform.tfvars](https://www.terraform.io/intro/getting-started/variables.html#from-a-file) file or provide these directly your `main.tf` file.

        terraform.tfvars:
        * app_name            | Name of application (ex: "hello-world")     
        * component           | Name of component (ex: "live") 
        * app_port            | Port to run application that is exposed in docker image (ex: "8080") 
        * ping_path           | Endpoint for application health check (ex: "/_internal_/ping")
        * image               | Docker image for microservice, including version (ex: "hbc-docker.jfrog.io/toggle-service:latest")
        * asg_min             | Minimum instances for app autoscaling group (ex: "1")
        * asg_max             | Maximum instances for app autoscaling group (ex: "2")
        * asg_desired         | Desired instances for app autoscaling group (ex: "1")
        * hbc_banner          | Banner deployed within (ex: multi-tenant, bay, saks...)
        * hbc_group           | HBC Tech group name (ex: back-office, path-to-purchase, search)
        * hbc_env             | Environment executing within (i.e. production or pre-production)
        * lb_security_group   | Security group for load balancer (ex: "sg-xxxxxxxx")
        * app_security_group  | Security group for application (ex: "sg-xxxxxxxx")
        * shared_kms_key      | KMS Key for shared parameters stored in AWS Parameter Store 
        * subnet_ids          | List of subnet ids for application autoscaling group (ex: [ "subnet-xxxxxxxx", "subnet-xxxxxxxx" ])       
        * key_name            | Name of EC2 kekypair for ssh access to provisioned instances (ex: "super-secret-key")
        * instance_type       | Type of EC2 instance to use for each container (ex: "t2.micro")          
        * env_vars            | [Map] Environment variables that are specific to your microservice
        
      Reference [variables.tf](variables.tf) for the list of microservice input variables as well as a short description of them.

3. Run `terraform plan` to see what infrastructure will be provisioned.
4. Deploy your microservice by executing `terraform apply`.

## Tests

See the microservice [test](../../tests/microservice) directory.