#!/bin/sh

REQUESTOR_VPC_ID="$1"
PEER_VPC_ID="$2"
PEER_ACCOUNT_ID="$3"
PROFILE="$4"

function usage {
echo "
Purpose: Create a peering connection between two VPCs in different AWS accounts.  The script DOES NOT update the route tables for the VPCs, which must still be performed.

Usage:  $0 <requesting-vpc-id> <peer-vpc-id> <peer-aws-account-id> <aws-profile>
<requesting-vpc-id>
  id of the vpc requesting the peering
<peer-vpc-id>
  id of the vpc the connection is being made
<peer-aws-account-id>
  AWS account id that owns the vpc being requested for a peering connection
<aws-profile>
  optional aws credentials file profile
  "
}

[ ! -z "$PROFILE" ] && PROFILE="--profile $PROFILE"

if [[ -z "$REQUESTOR_VPC_ID" || -z "$PEER_VPC_ID" || -z "$PEER_ACCOUNT_ID" ]]
then
   usage
   exit 0;
fi

aws $PROFILE ec2 create-vpc-peering-connection --vpc-id $REQUESTOR_VPC_ID --peer-vpc-id $PEER_VPC_ID --peer-owner-id $PEER_ACCOUNT_ID
