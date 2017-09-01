#!/bin/sh

AWS_PROFILE=$1

source resources_config.sh
source common_iam_functions.sh


########################################################################################
# Main
########################################################################################

# loop through all policies and create them
for ((i = 0; i < ${#CUSTOMER_MANAGED_POLICES[@]}; i++))
do
    create_role_policy `${CUSTOMER_MANAGED_POLICES[$i]} get policy_name` "`${CUSTOMER_MANAGED_POLICES[$i]} get policy_description`" `${CUSTOMER_MANAGED_POLICES[$i]} get policy_file` $AWS_PROFILE
done



# create a trust policy file to apply to each role
awsAccountNumber=$(aws $(get_cli_profile_argument_value $AWS_PROFILE) iam get-user --query User.Arn | sed 's/"//g' | cut -f 5 -d ':')
cat $IDP_TRUST_POLICY_TEMPLATE | sed "s/IDP_NAME/$IDP_NAME/g"  | sed "s/AWS_ACCOUNT_NUMBER/$awsAccountNumber/g"> trust-policy.json

# loop through all roles and create them
for ((i=0; i < ${#USER_ROLES[@]}; i++))
do
    ./create-user-role.sh ${USER_ROLES[$i]} "trust-policy.json" $AWS_PROFILE
done
rm trust-policy.json



# attach policies to roles
for ((i=0; i < ${#HBCD_ALL_ROLES_AND_POLICIES[@]}; i++))
do
    for policy in `${HBCD_ALL_ROLES_AND_POLICIES[$i]} get role_policies`
    do
        attach_policy_to_role `${HBCD_ALL_ROLES_AND_POLICIES[$i]} get role_name` $policy $AWS_PROFILE
    done
done

