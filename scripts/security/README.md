# If the AWS Jumpbox server hd5pjmp01lx is terminated, take the steps below to quickly rebuild it 

## Steps to recreate the jumpbox in AWS
SSH to host hd1pbk01lx

clone this repo to /tmp/

Then sudo to the rbackup user and cd to the playbooks directory

> sudo -iu rbackup

> cd ~/playbooks

## Run the jumpbox-creation playbook against the local inventory file within the same directory as the playbook

> ansible-playbook -i /tmp/aws-ref-arch/scripts/security/local /tmp/aws-ref-arch/scripts/security/jumpbox-creation.yml


