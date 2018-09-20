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

* SENTINEL_QUORUM: 2 (Decides how many sentinel instances need to be up and have to agree.
This number must be lower than the amount of sentinels started.)
* SENTINEL_DOWN_AFTER: 30000 (How long should a master be down till it is considered as Subjectively Down)
* SENTINEL_FAILOVER: 180000 (Used as a delay for a Sentinel that tried to failover a master, but was voted against to try again immediately. Also used as a max time to acknowledge the replica as new master. Otherwise the failover will be canceled.)

They can be customized in the `docker-compose.yml` environment section.

## Scaling

* You must have at least 2 Redis instances on different hosts and 3 Sentinel on
  different hosts. This is required by the Sentinel design.
  The two redis instances are needed to of course get a failover in case one of those goes down.
  The three sentinel instances are needed because they need to agree on which redis instance to use. If we only have two we can't decide which instance has gone down.
  (for more details: see -> https://redis.io/topics/sentinel)
* The default rancher configurations in this project will create 3 redis container and 3 sentinel containers.

## Master

The container with the Rancher Primary IP is automatically set as Redis Master,
while the others will subscribe on it as `slaveof`.  The sentinels are
automatically registered on this master.

If the master container is deleted at some point (IP address changed), you
might need to elect manually the new master with the special `SENTINEL`
commands: `SENTINEL MONITOR mymaster <ip> <port> <quorum>`.

## Notes

* You need Sentinel support in your client library.
* Do not setup the healthchecks with automatic re-create to avoid having the IP addresses changing
* Prefer to use the "keep ip address" for rancher containers

## Credits

Credits to https://github.com/clescot/rancher-redis which was a great starting point for this stack.
