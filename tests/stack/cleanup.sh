#!/usr/bin/env bash

set -ex

cd toggles
terraform destroy -force
rm -rf ./.terraform
rm -rf ./*.tfstate*
cd ../mongo

terraform destroy -force
rm -rf ./.terraform
rm -rf ./*.tfstate*
rm -f mongo-key