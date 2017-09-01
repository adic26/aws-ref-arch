#!/bin/sh

########################################################################################
# Answers with  '--profile=$1' if a profile argument was given to the script
# otherwise answers with an empty string
#
# Arg 1: Optional profile in the aws CLI credential file
function get_cli_profile_argument_value
{
    local awsProfile=""
	[ ! -z "$1" ] && awsProfile="--profile $1"

	echo "$awsProfile"
}

########################################################################################
# Answers with the given policy name if it exists in the AWS account
# Arg 1:  The case insensitive name of the policy to find
# Arg 2:   Optional profile in the aws CLI credential file

function get_policy_name
{
	local awsProfile="$(get_cli_profile_argument_value $2)"
	aws $awsProfile  iam list-policies --query "Policies[*].PolicyName" | grep -w $1 | sed 's/,//' | sed 's/"//g' | sed 's/^[ \t]*//'
}


########################################################################################
# Create a customer managed policy in the AWS account
# Arg 1: Name of the policy
# Arg 2: Description of the policy
# Arg 3: policy file name
# Arg 4: Optional profile in the aws CLI credential file

function create_policy
{
	local awsProfile="$(get_cli_profile_argument_value $4)"

	if [ -z "$(get_policy_name $1)" ]; then
		echo "Creating Policy[$1]"
		aws $awsProfile iam create-policy --policy-name $1 --description "$2" --policy-document file://$3
	else
		echo "Policy [ $1 ] already exists"
	fi
}

########################################################################################
# Create a customer managed policy in the AWS account
# Arg 1: Name of the policy
# Arg 2: Optional profile in the aws CLI credential file

function get_policy
{
	local awsProfile="$(get_cli_profile_argument_value $2)"

    policyName="$(get_policy_name $1)"
	if [ -z "$policyName" ]; then
	    policyArn="$(get_policy_arn $policyName)"
	    if [ -z "$policyArn" ]; then
	        aws $awsProfile iam get-policy --policy-arn $policyArn
	    fi
	else
		echo "Policy [ $1 ] does not exist"
	fi
}



########################################################################################
# Attaches the given managed policy to a role
# Arg 1:  Name of the role
# Arg 2:  Name of the policy
# Arg 3:  Optional profile in the aws CLI credential file

function attach_policy_to_role
{
	local policyArn=$(get_policy_arn $2 $3)
	local awsProfile="$(get_cli_profile_argument_value $3)"

	if [ -z "$policyArn" ]; then
		echo "The policy[ $2 ] does not exist in AWS"
	else
		echo "Attaching policy [ $2 ] to role [ $1 ]"
		aws $awsProfile iam attach-role-policy --role-name $1 --policy-arn $policyArn
	fi
}

########################################################################################
# Create a customer managed policy in the AWS account
# Arg 1: Name of the policy
# Arg 2: Description of the policy
# Arg 3: policy file name
# Arg 4: Optional profile in the aws CLI credential file

function create_role_policy
{
	if [ -z "$(get_policy_name $1 $4)" ]; then
	    local awsProfile="$(get_cli_profile_argument_value $4)"
		echo "Creating Policy[$1]"
		aws $awsProfile iam create-policy --policy-name $1 --description "$2" --policy-document file://$3
	else
		echo "Policy [ $1 ] already exists"
	fi
}


########################################################################################
# Answers with the Amazon Resource Name for the given policy name
# Arg 1:  Name of the policy for which to find the ARN
# Arg 2:  Optional profile in the aws CLI credential file

function get_policy_arn
{
    local awsProfile="$(get_cli_profile_argument_value $2)"
    aws $awsProfile iam list-policies --query "Policies[*].Arn" | grep -w $1 | sed 's/,//' | sed 's/"//g' | sed 's/^[ \t]*//'
}

# Arg 1:  Role name
# Arg 2:  Optional profile in the aws CLI credential file
function find_existing_role
{
    local awsProfile="$(get_cli_profile_argument_value $2)"
 	aws $awsProfile iam get-role --role-name $1 --query Role.RoleName --output text
}

# Arg 1: Role name
# Arg 2: Policy name
# Arg 3:  Optional profile in the aws CLI credential file
function detach_policy
{
    local policyArn="$(get_policy_arn $2 $3)";
	if [ -n "$policyArn" ]; then
	    local awsProfile="$(get_cli_profile_argument_value $3)"
		echo "Detaching Policy [ $2 ] from Role[ $1 ]"
		aws $awsProfile iam detach-role-policy --role-name $1 --policy-arn $policyArn
	fi
}

# Arg 1: Policy name
# Arg 2: Optional profile in the aws CLI credential file
function delete_policy
{
    local policyArn="$(get_policy_arn $1 $2)"
	if [ -n "$policyArn" ]; then
	    local awsProfile="$(get_cli_profile_argument_value $2)"
		echo "Deleting Policy [ $1 ]"
		aws $awsProfile iam delete-policy --policy-arn $policyArn
	fi
}

# Arg 1: Role name
# Arg 2: Optional profile in the aws CLI credential file
function delete_role
{
	if [ -n "$(find_existing_role $1 $2)" ]; then
		echo "Deleting Role[ $1 ]"
		aws $awsProfile iam delete-role --role-name $1
	fi
}