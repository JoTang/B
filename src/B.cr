require "./B/*"
require "sqlite3"

module B
  
end

DB.open "sqlite3://./data.db" do |db|
  db.exec "CREATE TABLE IF NOT EXISTS transactions (
    id INTEGER PRIMARY KEY DESC,
    amount INTEGER,
    time INTEGER,    
    ip TEXT,
    ua TEXT,
    description TEXT
  )"
end
Kemal.run