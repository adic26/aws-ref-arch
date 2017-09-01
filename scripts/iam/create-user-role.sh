#!/bin/sh

ROLE_NAME=$1
TRUST_POLICY=$2
AWS_PROFILE=$3

function print_usage
{
	echo "
Usage: $0 <role-name>  <trust-policy> <optional-aws-profile-name>
	<role-name>:  Name of the role to create
	<trust-policy>:  Name of the file containing the trust policy that will be applied to the role
	<optional-aws-profile-name>: Optional profile in the aws CLI credential file

Purpose:  Create a role in the desired AWS account.  Attaches a policy that allows the role to be assigned to a user/group in an Active Directory server"
}

if [ -z "$ROLE_NAME" ]
then
	print_usage
	exit 1
fi

[ ! -z "$AWS_PROFILE" ] && AWS_PROFILE=" --profile $AWS_PROFILE"

if [ "$ROLE_NAME" == "$(aws $AWS_PROFILE iam get-role --role-name $ROLE_NAME --query Role.RoleName --output text)" ] 
then
	echo "Role [ $ROLE_NAME ] already exists"
	exit 0
fi

# Create the role with the regular account user permissions policy
# Attach the Active Directory trust policy to the role.  This allows the role to be attached to a user/group in the Active Directory
aws $AWS_PROFILE iam create-role --role-name $ROLE_NAME --assume-role-policy-document file://$TRUST_POLICY


