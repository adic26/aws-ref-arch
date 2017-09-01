#!/bin/sh

set -x

HOSTED_ZONE_ID="$1"
VPC_ID="$2"
ZONE_OWNER_PROFILE="$3"
REQUESTOR_PROFILE="$4"
REGION="us-east-1"

function usage {
echo "
Purpose:  When a VPC created in one AWS account wishes to be associated with a Route 53 Hosted Zone in a separate AWS account, the account owning the hosted zone must send the requesting account a 'CreateVPCAssociationAuthorization'.  Then the requesting account must send a 'AssociateVPCWithHostedZone'. Reference: https://aws.amazon.com/premiumsupport/knowledge-center/private-hosted-zone-different-account/

Usage:  $0 <hosted-zone-id> <vpc-id> <zone-owner-profile> <requestor-profile>
<hosted-zone-id>
  id of the hosted zone to associate with the vpc
<vpc-id>
  id of the vpc to associate with the hosted zone
<zone-owner-profile>
  aws credentials file profile of the account that owns the zone
<requestor-profile>
  aws credentials file profile of the accout that owns the vpc to associate with the zone
  "
}


if [[ -z "$HOSTED_ZONE_ID" || -z "$VPC_ID" || -z "$REQUESTOR_PROFILE" || -z "$ZONE_OWNER_PROFILE" ]]
then
   usage
   exit 0;
fi

#authorize association by zone owner
aws --profile $ZONE_OWNER_PROFILE route53 create-vpc-association-authorization --hosted-zone-id $HOSTED_ZONE_ID --vpc VPCRegion=$REGION,VPCId=$VPC_ID

#request authorization in requesting account
aws --profile $REQUESTOR_PROFILE route53 associate-vpc-with-hosted-zone --hosted-zone-id $HOSTED_ZONE_ID --vpc VPCRegion=$REGION,VPCId=$VPC_ID

#delete the authorization from account that owns the zone
aws --profile $ZONE_OWNER_PROFILE route53 delete-vpc-association-authorization --hosted-zone-id $HOSTED_ZONE_ID --vpc VPCRegion=$REGION,VPCId=$VPC_ID


