FROM crystallang/crystal

RUN apt-get update && apt-get install sqlite3 libsqlite3-dev -y --no-install-recommends && apt-get clean && rm -rfv /var/lib/apt/lists/*

COPY . /tmp/
WORKDIR /tmp
RUN mkdir /code && shards install --production && shards build --release && mv /tmp/bin/B /code/B
WORKDIR /code

ENV KEMAL_ENV=production

CMD ["/code/B"]
