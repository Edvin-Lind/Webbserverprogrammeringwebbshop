require 'sinatra'
require 'sqlite3'

class App < Sinatra::Base
  configure do
      enable :method_override
      enable :sessions
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

  get '/signup' do
    erb(:"signup")
  end

  post '/users' do
    username = params['username']
    email = params['email']
    password = params['password']

    db.execute('INSERT INTO users (username, password, email) VALUES (?, ?, ?)', [username, password, email])
    redirect('/login')
  end

  get '/login' do
    erb(:"login")
  end

  post '/login' do
    username = params['username']
    password = params['password']

    user = db.execute('SELECT * FROM users WHERE username = ?', [username]).first
    if user && user['password'] == password
      session[:user_id] = user['user_id']
      redirect('/')
    else
      "Invalid login credentials."
    end
  end

  get '/logout' do
    session.clear
    redirect('/')
  end

  post '/create' do
      title = params['title']
      color = params['price']
      description = params['description']
      priority = params['stock']
      owner_id = params['user_id']

      db.execute("INSERT INTO items (title, price, user_id, description, stock) VALUES(?,?,?,?,?)", [title, price, user_id, description, stock])
      redirect("/")
  end

  delete '/delete/:id' do
    item_id = params[:id]
    db.execute('DELETE FROM items WHERE id = ? AND user_id = ?', [item_id, session[:user_id]])
    redirect('/')
  end

  get '/edit' do
    if !session[:user_id]
      redirect ('/login')
    end

    @items = db.execute('SELECT * FROM items WHERE user_id = ?', [session[:user_id]])
    erb(:edit)
  end

  get '/editor/:id' do
    if !session[:user_id]
      redirect ('/login')
    end

    item_id = params[:id]
    item = db.execute('SELECT * FROM items WHERE id = ? AND user_id = ?', [item_id, session[:user_id]]).first
    if item
      @databasitem = item
      erb :editor
    else
      "You are not authorized to edit this product."
    end
  end

  post '/editor/:id' do
    id = params['id']
    title = params['title']
    price = params['price']
    description = params['description']
    stock = params['stock']

    db.execute('UPDATE items SET title = ?, price = ?, description = ?, stock = ? WHERE id = ? AND user_id = ?',
    [title, price, description, stock, item_id, session[:user_id]])
    redirect('/')
  end
end
