FROM crystallang/crystal

COPY . /tmp/
WORKDIR /tmp
RUN shards install && crystall build --release src/B.crystal

CMD ["/app/B"]
