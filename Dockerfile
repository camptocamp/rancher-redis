FROM redis:3.2.0

COPY giddyup /usr/local/bin/giddyup
RUN chmod 777 /usr/local/bin/giddyup

RUN apt-get update -y && apt-get upgrade -y && apt-get install -y curl sed 

COPY conf/redis.conf /usr/local/etc/redis/redis.conf
COPY  start-redis.sh /start-redis.sh
RUN chmod 777 /start-redis.sh
CMD [ "/start-redis.sh"]
