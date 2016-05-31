#!/bin/bash
/usr/local/bin/giddyup service wait scale --timeout 120
connection_string=$(/usr/local/bin/giddyup ip stringify --suffix :6379 --delimiter " " redis/redis)
./src/redis-trib.rb create  --replicas 0 $connection_string
