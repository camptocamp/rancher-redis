FROM redis:3.2
MAINTAINER Camptocamp

RUN apt-get update -y \
  && apt-get upgrade -y \
  && apt-get install -y curl sed \
  && rm -rf /var/lib/apt/lists/*

RUN wget -O /usr/local/bin/giddyup https://github.com/rancher/giddyup/releases/download/v0.16.0/giddyup \
    && echo '2737ddda2c329d681fe768ca8d7e8b25fb7571f8 /usr/local/bin/giddyup' | sha1sum -c - \
    && chmod +x /usr/local/bin/giddyup

EXPOSE 26379

ADD sentinel.conf /etc/redis/sentinel.conf
RUN chown redis:redis /etc/redis/sentinel.conf

COPY local-entrypoint.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/local-entrypoint.sh

ENV SENTINEL_QUORUM 2
ENV SENTINEL_DOWN_AFTER 30000
ENV SENTINEL_FAILOVER 180000

ENTRYPOINT ["local-entrypoint.sh"]
