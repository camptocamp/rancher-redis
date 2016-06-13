#!/bin/bash
function leader_ip {
  echo $(curl -s http://rancher-metadata/2015-12-19/containers/$1_$2_1/primary_ip)
}
/usr/local/bin/giddyup service wait scale --timeout 120
stack_name=`curl -s http://rancher-metadata/2015-12-19/self/stack/name`
port=`curl -s http://rancher-metadata/2015-12-19/self/container/ports/0| sed  "s/.*:\([0-9]\{3,6\}\)\(\/tcp\|\/http\)\?/\1/g"`
my_ip=`echo $(curl -s http://rancher-metadata/2015-12-19/self/container/primary_ip)`
master_ip=$(leader_ip $stack_name "redis")

echo "my_ip=$my_ip"
echo "master_ip=$master_ip"
echo "stack_name=$stack_name"
echo "port=$port"

sed -i s/%port%/$port/g /usr/local/etc/redis/redis.conf
sed -i s/%my_ip%/$my_ip/g /usr/local/etc/redis/redis.conf

if [ "$my_ip" == "$master_ip" ]
then
        echo "i am the leader"
else
        echo "slaveof $master_ip $port" >> /usr/local/etc/redis/redis.conf

fi

redis-server /usr/local/etc/redis/redis.conf  
