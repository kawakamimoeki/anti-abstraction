require 'sqlite3'

db = SQLite3::Database.new 'db/development.db'

db.execute "INSERT INTO users (name) VALUES (?)", ['Alice']
db.execute "INSERT INTO users (name) VALUES (?)", ['Bob']
db.execute "INSERT INTO users (name) VALUES (?)", ['Charlie']

db.close