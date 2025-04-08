require 'sqlite3'

module DatabaseConnection
  def self.connection
    @connection ||= begin
      db = SQLite3::Database.new("db/databas.sqlite")
      db.results_as_hash = true
      db
    end
  end
end
