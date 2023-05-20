require 'sqlite3'

db = SQLite3::Database.new 'db/development.db'

db.execute <<-SQL
  CREATE TABLE users (
    id INTEGER PRIMARY KEY,
    name TEXT
  );
SQL

db.close