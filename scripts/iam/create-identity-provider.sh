#!/bin/bash

# load resource definitions
source resources_config.sh

AWS_PROFILE=$1
[ ! -z "$AWS_PROFILE" ] && AWS_PROFILE="--profile $AWS_PROFILE"

echo "Creating SAML Identify Provider named: $IDP_NAME"
aws $AWS_PROFILE iam create-saml-provider --saml-metadata-document file://$IDP_SAML_METADATA_FILE  --name $IDP_NAME

echo "Creating the IAM user that will be used as a proxy between the Identify Provider and AWS"
aws $AWS_PROFILE iam create-user --user-name $IDP_IAM_USER_NAME

echo "Creating the access keys for the IAM user. These are needed for the app to provision users with roles created in AWS."
aws $AWS_PROFILE iam create-access-key --user-name $IDP_IAM_USER_NAME

echo "Creating IAM policy for the services and operations the IDP user can access"
aws $AWS_PROFILE iam create-policy --policy-name $IDP_IAM_USER_ACCESS_POLICY_NAME --description "$IDP_IAM_USER_ACCESS_POLICY_DESCRIPTION" --policy-document file://$IDP_IAM_USER_ACCESS_POLICY

echo "Attaching the policy to the IAM user"
policyArn=$(aws $AWS_PROFILE iam list-policies --query "Policies[*].Arn" | grep -w $IDP_IAM_USER_ACCESS_POLICY_NAME | sed 's/,//' | sed 's/"//g' | sed 's/^[ \t]*//')
aws $AWS_PROFILE iam attach-user-policy --user-name $IDP_IAM_USER_NAME --policy-arn $policyArn

echo "You may now use the IAM users access/secret keys to finish configuring the Identify Providers"
