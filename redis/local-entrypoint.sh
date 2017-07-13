#!/bin/bash
set -e

giddyup service wait scale --timeout 120

stack_name=$(curl -s http://rancher-metadata/2016-07-29/self/stack/name)
container_name="redis"

my_ip=$(giddyup ip myip)

master_ip=''
containers_ip=$(giddyup ip stringify --delimiter=" ")
for container_ip in $containers_ip; do
  if [ "${my_ip}" != "${container_ip}" ]; then
    set +e
    role=$(redis-cli -h $container_ip -p 6379 info | grep role | tr -d '\r')
    set -e
    if [ "${role}" = "role:master" ]; then
      master_ip=$container_ip
    fi
  fi
done

if [ -z "${master_ip}" ]; then
  master_ip=$(giddyup leader get)
fi

export MY_IP=$(giddyup ip myip)

if [ "${MY_IP}" = "${master_ip}" ]; then
  echo "role: master"
else
  echo "role: slave"
  export SLAVEOF="slaveof $master_ip 6379"
fi

echo "IP: $MY_IP"
echo "Master IP: $master_ip"

confd -onetime -backend env
chown redis:redis /usr/local/etc/redis/redis.conf

exec docker-entrypoint.sh "$@"
