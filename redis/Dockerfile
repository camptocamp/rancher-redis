FROM redis:4.0
MAINTAINER Camptocamp

RUN apt-get update -y \
  && apt-get upgrade -y \
  && apt-get install -y curl sed \
  && rm -rf /var/lib/apt/lists/*

RUN curl -s -L -o /usr/local/bin/giddyup https://github.com/rancher/giddyup/releases/download/v0.16.0/giddyup \
    && echo '2737ddda2c329d681fe768ca8d7e8b25fb7571f8 /usr/local/bin/giddyup' | sha1sum -c - \
    && chmod +x /usr/local/bin/giddyup \
    && curl -s -L -o /usr/local/bin/confd https://github.com/kelseyhightower/confd/releases/download/v0.11.0/confd-0.11.0-linux-amd64 \
    && echo 'dd4479abccb24564827dcf14fcb73ccc5bba8aeb  /usr/local/bin/confd' | sha1sum -c - \
    && chmod +x /usr/local/bin/confd

COPY conf.d /etc/confd/conf.d
COPY templates /etc/confd/templates
RUN mkdir -p /usr/local/etc/redis/

COPY local-entrypoint.sh /usr/local/bin/local-entrypoint.sh
RUN chmod +x /usr/local/bin/local-entrypoint.sh

ENTRYPOINT ["local-entrypoint.sh"]
CMD ["redis-server", "/usr/local/etc/redis/redis.conf"]
