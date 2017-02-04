# B

Probably the most shabby money management backend in the world.

## Run with Docker
```bash
TBD
```

## Build and Run by hand

Make sure you have [Crystal](https://crystal-lang.org/) installed.

```bash
git clone https://github.com/whtsky/B.git
cd B
shards install --production
shards build --release

KEMAL_ENV=production B_DATABASE=sqlite3://./data.db bin/B
```
Currently only SQLite3 database is supported.

## Usage

B only provides JSON API for create transaction and list all transactions. Check `api.yaml` to see API doc. ( It's a [Swagger](http://swagger.io/) YAML )

## Contributing

1. Fork it ( https://github.com/whtsky/B/fork )
2. Create your feature branch (git checkout -b my-new-feature)
3. Commit your changes (git commit -am 'Add some feature')
4. Push to the branch (git push origin my-new-feature)
5. Create a new Pull Request

## Contributors

- [whtsky](https://github.com/whtsky) whtsky - creator, maintainer
