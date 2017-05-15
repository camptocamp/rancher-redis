# Redis Sentinel stack for Rancher

Allow to setup a Redis + Sentinel Stack on Rancher.
Redis Sentinel provides high availability for Redis. See the documentation on:
https://redis.io/topics/sentinel

## Ports

The ports used by the containers are:

* redis: 6379
* sentinel: 26379

## Variables

The default values of the environment variables for the Sentinel are as following

* SENTINEL_QUORUM: 2
* SENTINEL_DOWN_AFTER: 30000
* SENTINEL_FAILOVER: 180000

They can be customized in the 

## Scaling

* You must have at least 2 Redis instances on different hosts and 3 Sentinel on
  different hosts. This is required by the Sentinel design (see why on
  https://redis.io/topics/sentinel)

## Master

The container with the Rancher Primary IP is automatically set as Redis Master,
while the others will subscribe on it as `slaveof`.  The sentinels are
automatically registered on this master.

If the master container is deleted at some point (IP address changed), you
might need to elect manually the new master with the special `SENTINEL`
commands: `SENTINEL MONITOR mymaster <ip> <port> <quorum>`.

## Notes

* You need Sentinel support in your client library.
