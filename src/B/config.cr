module B
  DATABASE_URL = ENV.fetch("B_DATABASE", "sqlite3://./data.db")
end