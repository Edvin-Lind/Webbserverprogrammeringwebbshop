require_relative 'database_connection'

class User
  attr_accessor :id, :username, :password, :email

  def initialize(attrs)
    @id = attrs['user_id']
    @username = attrs['username']
    @password = attrs['password']
    @email = attrs['email']
  end

  def self.db
    DatabaseConnection.connection
  end

  def self.find_by_id(id)
    row = db.execute('SELECT * FROM users WHERE user_id = ?', id).first
    row ? new(row) : nil
  end

  def self.find_by_username(username)
    row = db.execute('SELECT * FROM users WHERE username = ?', username).first
    row ? new(row) : nil
  end

  def admin?
    username == 'admin'
  end

  def self.create(params)
    db.execute('INSERT INTO users (username, password, email) values (?,?,?)', [params[:username], params[:password], params[:email]])
  end
end
