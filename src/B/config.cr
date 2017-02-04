module B
  DATABASE_URL = "sqlite3://" + ENV.fetch("B_DATABASE", "data.db")
end