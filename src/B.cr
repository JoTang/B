require "./B/*"
require "sqlite3"

module B
  
end

DB.open B::DATABASE_URL do |db|
  db.exec "CREATE TABLE IF NOT EXISTS transactions (
    id INTEGER PRIMARY KEY,
    amount INTEGER,
    time INTEGER DESC,
    ip TEXT,
    ua TEXT,
    description TEXT
  )"
end

Kemal.run