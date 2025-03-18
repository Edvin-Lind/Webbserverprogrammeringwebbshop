class App < Sinatra::Base
  configure do
      enable :method_override
    end

  def db
      return @db if @db

      @db = SQLite3::Database.new("db/databas.sqlite")
      @db.results_as_hash = true

      return @db
  end

  get '/' do
      @items = db.execute('SELECT * FROM items')
      erb(:"index")
  end

  post '/create' do
      title = params['title']
      color = params['price']
      description = params['description']
      priority = params['stock']
      owner_id = params['owner_id']

      db.execute("INSERT INTO items (title, price, owner_id, description, stock) VALUES(?,?,?,?)", [title, price, owner_id, description, stock])
      redirect("/")
  end

  delete '/delete/:id' do
      id = params['id']
      db.execute('DELETE FROM items WHERE id = ?', [id])
      redirect('/')
  end

  get '/edit' do
      @items = db.execute('SELECT * FROM items')
      erb(:edit)
    end

  post '/edit/:id' do
      id = params['id']
      title = params['title']
      color = params['price']
      description = params['description']
      priority = params['stock']
      owner_id = params['owner_id']

      db.execute('UPDATE items SET title = ?, price = ?, owner_id = ?, description = ?, stock = ? WHERE id = ?', [title, price, owner_id, description, stock, id])
      redirect('/')
  end

  get '/editor/:id' do
    id = params['id']
    @databasitem = db.execute('SELECT * FROM items WHERE id = ?', [id]).first
    erb(:editor)
  end

  post '/editor/:id' do
      id = params['id']
      title = params['title']
      price = params['price']
      description = params['description']
      stock = params['stock']

      db.execute('UPDATE items SET title = ?, price = ?, description = ?, stock = ? WHERE id = ?', [title, price, description, stock, id])
      redirect('/')
  end

end
