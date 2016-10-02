FROM crystallang/crystal

ADD . /app
RUN shards install && crystall build --release src/B.crystal

CMD ["/app/B"]
