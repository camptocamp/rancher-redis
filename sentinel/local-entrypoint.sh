#!/bin/bash
set -e

function leader_ip {
  echo $(curl -s http://rancher-metadata/2016-07-29/containers/$1-$2-1/primary_ip)
}

giddyup service wait scale --timeout 120

stack_name=$(curl -s http://rancher-metadata/2016-07-29/self/stack/name)
export MY_IP=$(giddyup ip myip)

while [ "$(leader_ip $stack_name "redis")" = "Not found" ]
do
  echo "Waiting for redis to start up"
  sleep 0.1
done
export MASTER_IP=$(leader_ip $stack_name "redis")

echo "stack_name=$stack_name"
echo "my_ip=$MY_IP"
echo "master_ip=$MASTER_IP"

confd -onetime -backend env
chown redis:redis /usr/local/etc/redis/sentinel.conf

exec docker-entrypoint.sh redis-server /usr/local/etc/redis/sentinel.conf --sentinel
