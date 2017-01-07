FROM crystallang/crystal

RUN apt-get update && apt-get install sqlite3 libsqlite3-dev -y --no-install-recommends && apt-get clean && rm -rfv /var/lib/apt/lists/*

COPY . /tmp/
WORKDIR /tmp
RUN shards build --production && mv /tmp/bin/B /code/B && rm -rf /tmp
WORKDIR /code

CMD ["/code/B"]
