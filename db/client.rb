require 'sqlite3'

class DB < SQLite3::Database
  def initialize(path = 'db/development.db')
    super(path)
  end
end