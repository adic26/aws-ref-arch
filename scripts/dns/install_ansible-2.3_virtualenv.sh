#!/bin/sh

echo "Installing a virtualenv to contain an executable ansible version 2.3 and boto3
The virtualenv will be created in the directory $HOME/virtualenv/ansible.
"

if [ ! `which pip` ]; then
  echo "installing pip"
  sudo -H easy_install pip
fi

[ ! `which virtualenv` ] && sudo -H pip install virtualenv

[ -d $HOME/virtualenv/ansible-2.3 ] && sudo -H rm -rf $HOME/virtualenv/ansible-2.3

virtualenv -v --no-site-packages $HOME/virtualenv/ansible-2.3

source $HOME/virtualenv/ansible-2.3/bin/activate
pip install ansible==2.3.1.0
pip install boto3
pip install botocore
pip install boto

echo "export PYTHONPATH=${HOME}/virtualenv/ansible-2.3/lib/python2.7/site-packages:${PYTHONPATH}" >> $HOME/virtualenv/ansible-2.3/bin/activate
deactivate
