#!/bin/bash
set -e

function leader_ip {
  echo $(curl -s http://rancher-metadata/2016-07-29/containers/$1-$2-1/primary_ip)
}

giddyup service wait scale --timeout 120

stack_name=$(curl -s http://rancher-metadata/2016-07-29/self/stack/name)
my_ip=$(giddyup ip myip)
master_ip=$(leader_ip $stack_name "redis")

echo "stack_name=$stack_name"
echo "my_ip=$my_ip"
echo "master_ip=$master_ip"

sed -i s/%master_ip%/$master_ip/g /etc/redis/sentinel.conf
sed -i s/%my_ip%/$my_ip/g /etc/redis/sentinel.conf
sed -i s/%sentinel_quorum%/$SENTINEL_QUORUM/g /etc/redis/sentinel.conf
sed -i s/%sentinel_down_after%/$SENTINEL_DOWN_AFTER/g /etc/redis/sentinel.conf
sed -i s/%sentinel_failover%/$SENTINEL_FAILOVER/g /etc/redis/sentinel.conf

exec docker-entrypoint.sh redis-server /etc/redis/sentinel.conf --sentinel
