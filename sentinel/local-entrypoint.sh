#!/bin/bash
set -e

function leader_ip {
  echo $(curl -s http://rancher-metadata/2016-07-29/containers/$1-$2-1/primary_ip)
}

giddyup service wait scale --timeout 120

stack_name=$(curl -s http://rancher-metadata/2016-07-29/self/stack/name)
container_name="redis"

export MY_IP=$(giddyup ip myip)

while [ "$(leader_ip $stack_name "redis")" = "Not found" ]
do
  echo "Waiting for redis to start up"
  sleep 0.1
done

master=''
containers=$(curl -s http://rancher-metadata/2016-07-29/stacks/${stack_name}/services/${container_name}/containers)
for container_output in $containers; do
  # container_output is like 0=redis-sentinel-redis-1
  container_idx=$(echo $container_output | sed 's/=.*//')
  container_ip=$(curl -s http://rancher-metadata/2016-07-29/stacks/${stack_name}/services/${container_name}/containers/${container_idx}/primary_ip)
  set +e
  role=$(redis-cli -h $container_ip -p 6379 info | grep role | tr -d '\r')
  set -e
  if [ "${role}" = "role:master" ]; then
    master=$container_ip
  fi
done

if [ -z "${master}" ]; then
  export MASTER_IP=$master
else
  export MASTER_IP=$(leader_ip $stack_name "redis")
fi

echo "stack_name=$stack_name"
echo "my_ip=$MY_IP"
echo "master_ip=$MASTER_IP"

confd -onetime -backend env
chown redis:redis /usr/local/etc/redis/sentinel.conf

exec docker-entrypoint.sh redis-server /usr/local/etc/redis/sentinel.conf --sentinel
