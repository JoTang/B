FROM crystallang/crystal

COPY . /tmp/
WORKDIR /tmp
RUN shards install && crystal build --release src/B.crystal

CMD ["/app/B"]
