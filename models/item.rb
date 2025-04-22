require_relative 'database_connection'

class Item
  attr_accessor :id, :title, :price, :description, :stock, :user_id

  def initialize(attrs)
    @id          = attrs['id']
    @title       = attrs['title']
    @price       = attrs['price']
    @description = attrs['description']
    @stock       = attrs['stock']
    @user_id     = attrs['user_id']
  end

  def self.db
    DatabaseConnection.connection
  end

  def self.all
    db.execute('SELECT * FROM items').map { |row| new(row) }
  end

  def self.find_by_id(id)
    row = db.execute('SELECT * FROM items WHERE id = ?', id).first
    row ? new(row) : nil
  end

  def self.find_by_user(user_id)
    rows = db.execute('SELECT * FROM items WHERE user_id = ?', user_id)
    rows.map { |row| new(row) }
  end

  def self.create(params)
    db.execute("INSERT INTO items (title, price, user_id, description, stock) VALUES (?, ?, ?, ?, ?)", [params[:title], params[:price], params[:user_id], params[:description], params[:stock]])
  end

  def update(params, current_user)
    if current_user.admin?
      self.class.db.execute('UPDATE items SET title = ?, price = ?, description = ?, stock = ? WHERE id = ?', [params[:title], params[:price], params[:description], params[:stock], id])
    else
      self.class.db.execute('UPDATE items SET title = ?, price = ?, description = ?, stock = ? WHERE id = ? AND user_id = ?', [params[:title], params[:price], params[:description], params[:stock], id, current_user.id])
    end
  end

  def delete(current_user)
    if current_user.admin?
      self.class.db.execute('DELETE FROM items WHERE id = ?', id)
    else
      self.class.db.execute('DELETE FROM items WHERE id = ? AND user_id = ?', [id, current_user.id])
    end
  end
end
