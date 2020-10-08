FROM postgres:13-alpine
WORKDIR /var/lib/postgresql/data
VOLUME /var/lib/postgresql/data
VOLUME /var/run/postgresql

ENV PGUSER postgres
ENV PGHOST /var/run/postgresql
ENV PGDATA /var/lib/postgresql/data
ENV PAGER 'pspg -s 0'
ENV PATH="$PATH:/scripts"

# Once postgresql 13 is available in the alpine image,
# we can add the modules postgresql postgresql-contrib again
# https://pkgs.alpinelinux.org/packages?name=postgresql&branch=edge
RUN apk add --no-cache bash curl nano pspg shadow su-exec jq && \
  cd /usr/local/bin && curl -L https://github.com/wal-g/wal-g/releases/download/v0.2.15/wal-g.linux-amd64.tar.gz | tar xzf - && \
  usermod -u 1000 postgres && \
  groupmod -g 1000 postgres && \
  mkdir -p /var/lib/postgresql/initdb.d /var/run/postgresql && \
  chown -R postgres:postgres /var/lib/postgresql /var/run/postgresql && \
  apk del shadow

STOPSIGNAL SIGINT
COPY --from=postgres:13-alpine /usr/local/bin/docker-entrypoint.sh /usr/local/bin/docker-entrypoint.sh
ADD ./scripts /scripts
ENTRYPOINT ["/scripts/entrypoint"]
CMD ["postgres"]
