From ubuntu:14.04
MAINTAINER charles lescot lescot.charles{}gmail.com
ENV CACHE_FLAG 0
# Install and Upgrade the System
#RUN apt-get update
#RUN apt-get upgrade -yqq
# Install the dependencies
RUN apt-get update && apt-get upgrade -yqq && apt-get install -yqq build-essential gcc g++ openssl wget curl git-core libssl-dev libc6-dev ruby
# Clone the Unstable Version of redis that contains redis-cluster
RUN git clone -b 3.2.0 https://github.com/antirez/redis.git
# Install Redis and its Tools
WORKDIR /redis
RUN make
RUN gem install redis

#add giddyup
COPY giddyup /usr/local/bin/giddyup
RUN chmod 777 /usr/local/bin/giddyup


#add confd 
COPY confd-0.11.0-linux-amd64  /usr/local/bin/confd

RUN bash -c 'mkdir -p /etc/confd/{conf.d,templates}'
RUN chmod 777 /usr/local/bin/confd
COPY ./confd /etc/confd
RUN chmod a+x /etc/confd


# Add the Configuration of the cluster
#ADD redis.conf /redis/redis.conf
#ADD run.sh /run.sh
ADD start-cluster.sh /start-cluster.sh
RUN chmod 777 /start-cluster.sh

ENV REDIS_NODE_PORT=7000
ENTRYPOINT ["/start-cluster.sh"]
