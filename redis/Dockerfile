FROM redis:3.2
MAINTAINER Camptocamp

RUN apt-get update -y \
  && apt-get upgrade -y \
  && apt-get install -y curl sed \
  && rm -rf /var/lib/apt/lists/*

RUN wget -O /usr/local/bin/giddyup https://github.com/rancher/giddyup/releases/download/v0.16.0/giddyup \
    && echo '2737ddda2c329d681fe768ca8d7e8b25fb7571f8 /usr/local/bin/giddyup' | sha1sum -c - \
    && chmod +x /usr/local/bin/giddyup

COPY conf/redis.conf /usr/local/etc/redis/redis.conf
COPY local-entrypoint.sh /usr/local/bin/local-entrypoint.sh
RUN chmod +x /usr/local/bin/local-entrypoint.sh

ENTRYPOINT ["local-entrypoint.sh"]
CMD ["redis-server", "/usr/local/etc/redis/redis.conf"]
