# Contains all names of roles and resources that are created to manage Users
# All scripts in this directory will source this file and use the variables and functions within.

#############
# Global variables and their attributes that can be used.
# NOTE: Extensive use is made of functions defined in the script "shell_map.sh" which defines a HashMap datastructure for Bash < 3.0
# Author github repo:  https://github.com/bnegrao/shell_map
# The statement "shell_map new <variable-name>" defines the hasmap
# Keys are set in the map with the command substitution: `<variable-name> put <key> <string-value>`
# Keys are retrieved from the map with the command substitution: `<variable-name> get <key>`
#
# IDP_NAME -
#   Name of the SAML based Identity Provider
#
# IDP_SAML_METADATA_FILE -
#   Metadata file defining how to identify and communicate with the SAML Identity Provider.
#   The file should exists in the same directory as the executing script
#
# IDP_TRUST_POLICY_TEMPLATE -
#   Trust file that must be assigned to each user role to allow the Identify Provider to allow a Federated User to assume the role.
#   Every role created will use this trust policy.
#   NOTE: the name of the role in the template must use the placeholder ROLE_NAME and the identify provider name in the ARN must use the placeholder IDP_NAME
#
# IDP_IAM_USER_NAME -
#   Name of the IAM User whose permanent access keys will be used by the Identity Provider to integrate with AWS
#
# IDP_IAM_USER_ACCESS_POLICY -
#   Json formatted IAM policy files granting the Identify Provider permissions to List roles and Assume roles within the AWS account
#
# IDP_IAM_USER_ACCESS_POLICY_NAME -
#   Name of the Identity Provider IAM user access policy
#
# IDP_IAM_USER_ACCESS_POLICY_DESCRIPTION -
#   Description of the  Identity Provider IAM user access policy
#
# USER_ROLES -
#   An array of user role names
#
# CUSTOMER_MANAGED_POLICES -
#   An array of map objects representing the policies used by HBC AWS accounts.  Keys for each map:
#   policy_name - name of the policy
#   policy_file - json formatted policy file that exists in the same same directory as the executing script
#   policy_description - text description for the policy
#
# HBCD_ALL_ROLES_AND_POLICIES -
#   An array of map objects representing the policies that should be attached to a role.  Keys for each map:
#   role_name - name of the user role
#   role_policies - Space delimited string containing all the policies that should be attached to the user role defined in role_name
#


# include functions to implement hashmap data structure in bash 3.0:  https://github.com/bnegrao/shell_map
source shell_map.sh


# Name of the Okta Identity Provider
IDP_NAME="Okta_IdP"
IDP_SAML_METADATA_FILE="oktaIdP-metadata.xml"
IDP_IAM_USER_NAME="Okta"
IDP_IAM_USER_ACCESS_POLICY="policies/hbcd-okta-access-policy.json"
IDP_IAM_USER_ACCESS_POLICY_NAME="hbcd-okta-list-and-assume-roles"
IDP_IAM_USER_ACCESS_POLICY_DESCRIPTION="Grants the Okta IAM user permission to List roles and Assume roles through SAML"

# User roles
HBCD_USER=HbcdUser
HBCD_ADMIN=HbcdAdmin
HBCD_NETWORKING=HbcdNetworking

# Template for the Identity Provider trust policy
IDP_TRUST_POLICY_TEMPLATE="policies/hbcd-okta-trust-policy-template-policy.json"

# Array of all user roles
declare -a USER_ROLES=("$HBCD_USER" "$HBCD_ADMIN" "$HBCD_NETWORKING")

# Arrary of shell_map created maps representing all information needed to create a policy in AWS
declare -a CUSTOMER_MANAGED_POLICES=()

# Policy maps
shell_map new ALL_APPLICATION_SERVICES
ALL_APPLICATION_SERVICES put policy_name "HbcdAllowAllApplicationServices"
ALL_APPLICATION_SERVICES put policy_file "policies/hbcd-allow-all-application-services-policy.json"
ALL_APPLICATION_SERVICES put policy_description "Allow execution of all operations on application oriented services."
CUSTOMER_MANAGED_POLICES[0]=ALL_APPLICATION_SERVICES

shell_map new ALL_INFRASTRUCTURE_SERVICES
ALL_INFRASTRUCTURE_SERVICES put policy_name "HbcdAllowAllInfrastructureServices"
ALL_INFRASTRUCTURE_SERVICES put policy_file "policies/hbcd-allow-all-infrastructure-services-policy.json"
ALL_INFRASTRUCTURE_SERVICES put policy_description "Allow execution of all operations on infrastructure oriented services."
CUSTOMER_MANAGED_POLICES[1]=ALL_INFRASTRUCTURE_SERVICES

shell_map new ALLOW_ALL_IAM_DS
ALLOW_ALL_IAM_DS put policy_name "HbcdAllowAllIamDs"
ALLOW_ALL_IAM_DS put policy_file "policies/hbcd-allow-all-iam-ds-policy.json"
ALLOW_ALL_IAM_DS put policy_description "Allow execution of all operations on IAM and DS services."
CUSTOMER_MANAGED_POLICES[2]=ALLOW_ALL_IAM_DS

shell_map new ALLOW_ALL_NETWORKING
ALLOW_ALL_NETWORKING put policy_name "HbcdAllowAllNetworking"
ALLOW_ALL_NETWORKING put policy_file "policies/hbcd-allow-all-networking-policy.json"
ALLOW_ALL_NETWORKING put policy_description "Allow execution of all operations on the EC2, Route 53 and Route 53 Domains services."
CUSTOMER_MANAGED_POLICES[3]=ALLOW_ALL_NETWORKING

shell_map new ALLOW_RESTRICTED_IAM
ALLOW_RESTRICTED_IAM put policy_name "HbcdAllowRestrictedIam"
ALLOW_RESTRICTED_IAM put policy_file "policies/hbcd-allow-restricted-iam-policy.json"
ALLOW_RESTRICTED_IAM put policy_description "Allow execution of all operations on the IAM service that do not create/modify IAM users, no Group creation, no Role deletion and no policy attaches to user roles."
CUSTOMER_MANAGED_POLICES[4]=ALLOW_RESTRICTED_IAM

shell_map new ALLOW_RESTRICTED_EC2
ALLOW_RESTRICTED_EC2 put policy_name "HbcdAllowRestrictedEc2"
ALLOW_RESTRICTED_EC2 put policy_file "policies/hbcd-allow-restricted-ec2-policy.json"
ALLOW_RESTRICTED_EC2 put policy_description "Allow execution of all operations on the EC2 service that do not create/modify networking resources."
CUSTOMER_MANAGED_POLICES[5]=ALLOW_RESTRICTED_EC2


shell_map new ALLOW_RESTRICTED_ROUTE_53
ALLOW_RESTRICTED_ROUTE_53 put policy_name "HbcdAllowRestrictedRoute53"
ALLOW_RESTRICTED_ROUTE_53 put policy_file "policies/hbcd-allow-restricted-route53-policy.json"
ALLOW_RESTRICTED_ROUTE_53 put policy_description "Allow execution of all operations on Route 53 that do not modify Hosted Zones or DNS records."
CUSTOMER_MANAGED_POLICES[6]=ALLOW_RESTRICTED_ROUTE_53

# Arrays that group polices that must be applied to a single role
declare -a HBCD_USER_POLICIES=(`ALL_APPLICATION_SERVICES get policy_name` `ALL_INFRASTRUCTURE_SERVICES get policy_name` `ALLOW_RESTRICTED_ROUTE_53 get policy_name` `ALLOW_RESTRICTED_EC2 get policy_name` `ALLOW_RESTRICTED_IAM get policy_name`)

declare -a HBCD_ADMIN_POLICIES=(`ALL_APPLICATION_SERVICES get policy_name` `ALL_INFRASTRUCTURE_SERVICES get policy_name` `ALLOW_RESTRICTED_EC2 get policy_name` `ALLOW_RESTRICTED_ROUTE_53 get policy_name` `ALLOW_ALL_IAM_DS get policy_name`)

declare -a HBCD_NETWORKING_POLICIES=(`ALL_APPLICATION_SERVICES get policy_name` `ALL_INFRASTRUCTURE_SERVICES get policy_name` `ALLOW_RESTRICTED_IAM get policy_name` `ALLOW_ALL_NETWORKING get policy_name`)

# shell_map created maps that associate a role to the list of polices that must be applied to the role
policiesAsString="${HBCD_USER_POLICIES[@]}"
shell_map new HBCD_USER_ROLE_POLICIES
HBCD_USER_ROLE_POLICIES put role_name "$HBCD_USER"
HBCD_USER_ROLE_POLICIES put role_policies "$policiesAsString"

policiesAsString="${HBCD_ADMIN_POLICIES[@]}"
shell_map new HBCD_ADMIN_ROLE_POLICIES
HBCD_ADMIN_ROLE_POLICIES put role_name "$HBCD_ADMIN"
HBCD_ADMIN_ROLE_POLICIES put role_policies "$policiesAsString"

policiesAsString="${HBCD_NETWORKING_POLICIES[@]}"
shell_map new HBCD_NETWORKING_ROLE_POLICIES
HBCD_NETWORKING_ROLE_POLICIES put role_name "$HBCD_NETWORKING"
HBCD_NETWORKING_ROLE_POLICIES put role_policies "$policiesAsString"

# Array containing the maps of role|policies
declare -a HBCD_ALL_ROLES_AND_POLICIES=(HBCD_USER_ROLE_POLICIES HBCD_ADMIN_ROLE_POLICIES HBCD_NETWORKING_ROLE_POLICIES)


