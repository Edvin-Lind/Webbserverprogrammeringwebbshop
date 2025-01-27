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
      @databas = db.execute('SELECT * FROM databas')
      erb(:"index")
  end

  post '/create' do
      title = params['title']
      color = params['price']
      description = params['description']
      priority = params['stock']

      db.execute("INSERT INTO databas (title, price, description, stock) VALUES(?,?,?,?)", [title, price, description, stock])
      redirect("/")
  end

  delete '/delete/:id' do
      id = params['id']
      db.execute('DELETE FROM databas WHERE id = ?', [id])
      redirect('/')
  end

  get '/edit/:id' do
      id = params['id']
      @todo = db.execute('SELECT * FROM databas WHERE id = ?', [id]).first
      erb(:edit)
    end

  post '/edit/:id' do
      id = params['id']
      title = params['title']
      color = params['price']
      description = params['description']
      priority = params['stock']

      db.execute('UPDATE databas SET title = ?, price = ?, description = ?, stock = ? WHERE id = ?', [title, price, description, stock, id])
      redirect('/')
  end

end
