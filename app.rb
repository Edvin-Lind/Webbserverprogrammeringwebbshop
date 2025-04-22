require 'sinatra'
require 'sqlite3'
require_relative 'models/database_connection'
require_relative 'models/item'
require_relative 'models/user'

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
      @items = Item.all
      erb(:"index")
  end

  get '/signup' do
    erb(:"signup")
  end

  post '/users' do
    User.create(username: params['username'], password: params['password'], email: params['email'])
    redirect('/login')
  end

  get '/login' do
    erb(:"login")
  end

  post '/login' do
    user = User.find_by_username(params['username'])
    if user && user.password == params['password']
      session[:user_id] = user.id
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
    user = User.find_by_id(session[:user_id])
    if !session[:user_id]
      redirect ('/login')
    end

    Item.create(title: params['title'], price: params['price'], user_id: user.id, description: params['description'], stock:params['stock'])
    redirect('/')
  end

  delete '/delete/:id' do
    user = User.find_by_id(session[:user_id])
    item = Item.find_by_id(params[:id])
    item.delete(user) if item
    redirect('/')
  end

  get '/edit' do
    user = User.find_by_id(session[:user_id])
    redirect '/login' unless user

    if user.admin?
      @items = Item.all
    else
      @items = Item.find_by_user(user.id)
    end

    erb(:edit)
  end

  get '/editor/:id' do
    user = User.find_by_id(session[:user_id])
    if !session[:user_id]
      redirect ('/login')
    end

    if user.admin?
      item = Item.find_by_id(params[:id])
    else
      item = Item.find_by_id(params[:id])
      item = nil if item && item.user_id != user.id
    end

    if item
      @databasitem = item
      erb :editor
    else
      "You are not authorized to edit this product."
    end
  end

  post '/editor/:id' do
    user = User.find_by_id(session[:user_id])
    if !session[:user_id]
      redirect ('/login')
    end

    item = Item.find_by_id(params[:id])
    if item
      item.update({ title: params['title'], price: params['price'], description: params['description'], stock: params['stock'] }, user)
    end

    redirect('/')
  end

  post '/favorite/:id' do
    redirect('/login') unless session[:user_id]
    item_id = params[:id]

    existing = db.execute('SELECT * FROM favorites WHERE user_id = ? AND item_id = ?', [session[:user_id], item_id])
    if existing.empty?
      db.execute('INSERT INTO favorites (user_id, item_id) VALUES (?, ?)', [session[:user_id], item_id])
    end

    redirect('/')
  end

  get '/favorites' do
    redirect('/login') unless session[:user_id]

    rows = db.execute('SELECT items.* FROM items
                   JOIN favorites ON items.id = favorites.item_id
                   WHERE favorites.user_id = ?', [session[:user_id]])

    @favorites = rows.map { |row| Item.new(row) }

    erb :favorites
  end

end
