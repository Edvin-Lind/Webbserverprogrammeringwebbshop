require 'sqlite3'

class Seeder

  def self.seed!
    drop_tables
    create_tables
    populate_tables
  end

  def self.drop_tables
    db.execute('DROP TABLE IF EXISTS databas')
  end

  def self.create_tables
    db.execute('CREATE TABLE databas (
                id INTEGER PRIMARY KEY AUTOINCREMENT,
                title TEXT NOT NULL,
                price INTEGER NOT NULL,
                description TEXT,
                stock INTEGER,
                owner_id INTEGER NOT NULL)')
  end

  def self.populate_tables
    db.execute('INSERT INTO databas (title, price, description, stock, owner_id) VALUES ("test",   "100", "häst för 100 spänn! Hugg till om du vill ha (har bara tre).", 3, 321133)')
    db.execute('INSERT INTO databas (title, price, description, stock, owner_id) VALUES ("test2",    "1000", "Hello i try to sell rat for 1000 kr.", 20, 327518)')
    db.execute('INSERT INTO databas (title, price, description, stock, owner_id) VALUES ("test3",  "10000", "lorem ipsum sit dolor", 100, 762891)')
    db.execute('INSERT INTO databas (title, price, description, stock, owner_id) VALUES ("Atombomb för lågt pris!",  "50", "B24 vätebomb, har haft lite problem med detonatorn, bra skick", 2, 452277)')
  end

  private
  def self.db
    return @db if @db
    @db = SQLite3::Database.new('db/databas.sqlite')
    @db.results_as_hash = true
    @db
  end
end


Seeder.seed!
