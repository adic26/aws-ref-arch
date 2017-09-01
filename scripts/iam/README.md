# User Management
A user in AWS is a unique identity assigned to an entity.  The entity can be a human or a process.

***IAM Users***

Users managed through AWS Identity mangagement system.  IAM users can be assigned to groups, can be issued permanent Access/Secret keys for programmtic access and can be assigned login credentials to the AWS console.

***Federated Users***

Users managed by a service external to AWS and are delegated access to AWS APIs and Console.  Federated users cannot be assigned to groups, cannot receive permanent Access/Secret keys and cannot be assigned login credentials to the AWS console. Federated users may be granted access to these AWS resources (Console and APIs) through an Identity Provider (using SAML or OpenId Connect protocols).  

**HBCD Federated User Management**

A centralized Active Directory server currently exists to manage all user access to system owned by HBC Digital; ad.digital.hbc.com (refered to as Digital AD from now on).  This Active Directory server will be integrated as the user identity provider for each AWS account managed by HBC Digital.  The Okta Single Sign On service will be used to integrate the Digital AD and AWS. Users will be provisioned through Okta (imported from AD and assigned AWS role(s)) and will authenticate through Okta for access to the AWS console and APIs on the command line.

Roles will be assigned to users/groups in the AD.  Console access will use a separate login url for each account (e.g. s5aprod.awsapps.com/console for Saks Prod and o5apreprod.awsapps.com/console for Off 5th Pre prod).  Programmatic API access must use temporarily issued keys from the Security Token Service (not required if running in an ec2 server). Temporary keys have a maximum lifetime of 12 hours.

**Roles and the Permissions they are Granted**

The following are the only roles that a user may be assigned when access the AWS console or API.  Following each role are the permissions granted each role.

**HbcdUser** 

* Readonly IAM access, the ability to create policies and roles.  No ability to delete roles, users, groups, policies.
* No access to Directory Service
* Access to EC2 service except creation and deletion of any networking resource.
* Readonly access to Route53
* Full access to all other AWS application and infrastructure services

**HbcdAdmin** 

* Grants full IAM and Directory Service access along with all application and infrastructure service access.  
* Access to EC2 service except creation and deletion of any networking resource.
* Readonly access to Route53
* Full access to all other AWS application and infrastructure services

**HbcdNetworking**

* Full access to EC2 and Route 53
* Readonly IAM access, the ability to create policies and roles.  No ability to delete roles, users, groups, policies.
* Full access to all other AWS application and infrastructure services


**So...what are these scripts for?**

All User management and access resources are created from scripts in this directory.  Before executing any script, ensure you have the AWS cli installed and configured.  Every script accepts an optional profile argument that corresponds to a profile section in the **~/.aws/credentials** file of your aws cli.  You **MUST** use access/secret keys for an IAM user that has full IAM api access to the account that you are configuring.  
## Tasks

The following tasks must be executed for every AWS account that will be managed by HBC Digital and executed in the order listed. An Okta organization must have been created and the Single Sign On product activated.  The scripts may work with a dev, preview or production Okta environment.

1. [Create AWS Application In Okta](docs/CreateApplicationInOkta.md)
4. [Verify access to AWS console and command line](docs/VerifyAccessToAWS.md)

## Ongoing User Management
Lastly, we will discuss the ongoing management of users with existing AWS applications in Okta.

