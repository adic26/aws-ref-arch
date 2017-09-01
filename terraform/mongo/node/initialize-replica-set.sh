#!/bin/bash

set -ex

sudo -iu root

# Wait for internet connectivity
until ping -c 1 ietf.org
do
  sleep 5;
done

service mongod stop

# Mount EBS device to Mongo data file
mkfs -t ext4 /dev/xvdf
mkdir -p /data/db
mount /dev/xvdf /data/db

# Start Mongo with replica set
aws s3 cp s3://${s3_bucket_name}/keyfile ~/mongo-cluster-keyfile
chmod 400 ~/mongo-cluster-keyfile

mongod --replSet "${replica_set_name}" --keyFile ~/mongo-cluster-keyfile --syslog &

# Wait for Mongo to start
until egrep -i "waiting for connections on port" /var/log/messages
do
  sleep 1;
done

# Initiate Mongo replica set. If condition makes sure this only runs on Primary Node
if [ ! -z "${secondary0_ip}" ]; then

until nc -z ${secondary0_ip} ${port}; do sleep 2; done
until nc -z ${secondary1_ip} ${port}; do sleep 2; done

export IP=`/sbin/ip -o -4 addr list eth0 | awk '{print $4}' | cut -d/ -f1`

export admin_password=$(aws ssm get-parameters --names ${parameter_key_namespace}/${admin_password_key} --with-decryption --region us-east-1 | jq ."Parameters[0].Value" --raw-output)

mongo <<EOF
use admin

rs.initiate(
   {
      _id: "${replica_set_name}",
      version: 1,
      members: [
         { _id: 0, host : "$IP:${port}" },
         { _id: 1, host : "${secondary0_ip}:${port}" },
         { _id: 2, host : "${secondary1_ip}:${port}" }
      ]
   }
)

while(rs.status().members[0].stateStr !== "PRIMARY") {
  print("Waiting for master...");
  sleep(1000);
}

sleep(5000);

use admin

db.createUser(
  {
    "user" : "${admin_username}",
    "pwd" : "$admin_password",
    roles: [ { "role" : "userAdminAnyDatabase", "db" : "admin" }, { "role" : "clusterAdmin", "db" : "admin" } ]
  }
)
EOF

export db_password=$(aws ssm get-parameters --names ${parameter_key_namespace}/${db_password_key} --with-decryption --region us-east-1 | jq ."Parameters[0].Value" --raw-output)

mongo admin -u ${admin_username} -p $admin_password <<EOF

use ${db_name}

db.createUser(
  {
    "user" : "${db_username}",
    "pwd"  : "$db_password",
    roles: [ { "role" : "readWrite", "db" : "${db_name}" } ]
   }
)
EOF

fi
