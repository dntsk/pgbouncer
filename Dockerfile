FROM debian:bookworm-slim

ENV DEBIAN_FRONTEND=noninteractive

LABEL org.opencontainers.image.version="1.21.0" \
      org.opencontainers.image.ref.name="1.21.0" \
      org.opencontainers.image.title="pgbouncer" \
      org.opencontainers.image.description="PGBouncer application" \
      org.opencontainers.image.base.name="debian:bookworm-sim" \
      org.opencontainers.image.licenses="Apache-2.0" \
      org.opencontainers.image.vendor="DNTSK" \
      org.opencontainers.image.authors="info@dntsk.dev" \
      org.opencontainers.image.url="https://github.com/dntsk/pgbouncer"

WORKDIR /tmp
EXPOSE 6432
RUN useradd -ms /bin/false postgres

RUN apt-get update && DEBIAN_FRONTEND=noninteractive \
    apt-get -y install libpq-dev libcurl4-openssl-dev libssl-dev zlib1g-dev pkg-config gettext-base build-essential make git wget curl unzip && \
    rm -rf /tmp/* && \
    echo "deb http://apt.postgresql.org/pub/repos/apt bookworm-pgdg main" > /etc/apt/sources.list.d/pgdg.list && \
    curl -s https://www.postgresql.org/media/keys/ACCC4CF8.asc | apt-key add - && \
    apt-get update && DEBIAN_FRONTEND=noninteractive apt-get -y install postgresql-client-14 && \
    rm -rf /tmp/* && \
    wget -q https://github.com/libevent/libevent/releases/download/release-2.1.12-stable/libevent-2.1.12-stable.tar.gz \
    -O libevent.tar.gz && \
    tar zxf libevent.tar.gz && \
    cd libevent-* && \
    ./configure && \
    make && make install && \
    ln -s /usr/local/lib/libevent-2.1.so.7 /usr/lib/libevent-2.1.so.7 && \
    rm -rf /tmp/* && \
    wget -q https://pgbouncer.github.io/downloads/files/1.21.0/pgbouncer-1.21.0.tar.gz -O /tmp/pgbouncer.tar.gz && \
    cd /tmp && \
    tar zxf pgbouncer.tar.gz && \
    cd pgbouncer-* && \
    ./configure --prefix=/usr/local --with-libevent=/usr/local && \
    make && make install && \
    bash -c 'mkdir /var/{log,run}/pgbouncer' && bash -c 'chown postgres /var/{log,run}/pgbouncer' && \
    rm -rf /tmp/* && \
    apt-get autoremove --yes make git libpq-dev libcurl4-openssl-dev libssl-dev build-essential zlib1g-dev && \
    apt-get clean autoclean && \
    apt-get autoremove --yes && \
    rm -rf /var/lib/{apt,dpkg,cache,log}/


RUN touch /etc/pg_auth /etc/pgbouncer.ini && \
    chown postgres /etc/pg_auth /etc/pgbouncer.ini

USER postgres

CMD ["/usr/local/bin/pgbouncer", "/etc/pgbouncer.ini"]
