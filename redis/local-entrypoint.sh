#!/bin/bash
set -e

giddyup service wait scale --timeout 120

my_ip=$(giddyup ip myip)
master_ip=$(giddyup leader get)

echo "my_ip=$my_ip"
echo "master_ip=$master_ip"

sed -i s/%my_ip%/$my_ip/g /usr/local/etc/redis/redis.conf

{ giddyup leader check \
  && echo "i am the leader"
} || {
  echo "i am not the leader"
  echo "slaveof $master_ip 6379" >> /usr/local/etc/redis/redis.conf
}

docker-entrypoint.sh "$@"
