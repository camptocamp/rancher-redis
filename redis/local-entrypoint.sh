#!/bin/bash
set -e

giddyup service wait scale --timeout 120

export MY_IP=$(giddyup ip myip)
master_ip=$(giddyup leader get)

echo "my_ip=$MY_IP"
echo "master_ip=$master_ip"

{ giddyup leader check \
  && echo "i am the leader"
} || {
  echo "i am not the leader"
  export SLAVEOF="slaveof $master_ip 6379"
}

confd -onetime -backend env
chown redis:redis /usr/local/etc/redis/redis.conf

exec docker-entrypoint.sh "$@"
