#!/bin/sh

AWS_PROFILE=$1

# import data and shared functions
source resources_config.sh
source common_iam_functions.sh

########################################################################################
function print_usage
{
	echo "
Usage: $0 <optional-aws-profile-name>
	<optional-aws-profile-name>: Optional profile in the aws CLI credential file

Purpose:  Delete all HBC Digital roles and policies from an account
"
}



########################################################################################
# Main
########################################################################################


# detach policies from roles
for ((i=0; i < ${#HBCD_ALL_ROLES_AND_POLICIES[@]}; i++))
do
    for policy in `${HBCD_ALL_ROLES_AND_POLICIES[$i]} get role_policies`
    do
        detach_policy `${HBCD_ALL_ROLES_AND_POLICIES[$i]} get role_name`  "$policy" $AWS_PROFILE
    done
done

# delete policies
for ((i = 0; i < ${#CUSTOMER_MANAGED_POLICES[@]}; i++))
do
    delete_policy `${CUSTOMER_MANAGED_POLICES[$i]} get policy_name` $AWS_PROFILE
done

# delete roles
for ((i=0; i < ${#USER_ROLES[@]}; i++))
do
    delete_role ${USER_ROLES[$i]} $AWS_PROFILE
done
