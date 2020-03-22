require_relative 'config/database'
require_relative 'validators/name_validator'
require_relative 'validators/email_validator'
require_relative 'validators/user_validator'
require 'sinatra'
require 'erb'
require 'time'
require 'pry'

enable :sessions

users = DB[:users]
messages = DB[:messages]


post '/login' do
  @user = params
  @users = users
  user_validator = UserValidator.new(@user, @users)
  if user_validator.valid?
    session[:logged_in] = true
    user_hash = users.where(name: params[:name], password: params[:password]).to_a[0]
    session[:user_id] = user_hash[:id]
    redirect to('/')
  else
    puts @message
    redirect to('/register')
  end
end

post '/logout' do
  session[:logged_in] = false
  session[:user_id] = nil
  redirect to('/')
end

get '/register' do
  erb :register
end

post '/register' do
  @name = params[:name]
  @email = params[:email]

  @names = users.select('name')
  @emails = users.select('email')
  name_validator = NameValidator.new(@name, @names)
  email_validator = EmailValidator.new(@email, @emails)

  if name_validator.valid? & email_validator.valid?
    session[:user_id] = users.insert(:name => @name, :email => @email, :password => params[:password])
    session[:logged_in] = true
    redirect to('/home')
  else
    puts name_validator.message
    puts email_validator.message + params[:email]
  end
end

get '/' do
  if session[:logged_in]
    erb :index
  else
    erb :login
  end
end

get '/home' do
  if session[:logged_in]
    erb :home
  else
    redirect to('/')
  end
end

post '/contact' do
  messages.insert(:user_id => session[:user_id], :text => params[:message])
  erb :contact
end

get '/messages' do
  if session[:logged_in]
    @messages_list = messages.all
    erb :messages
  else
    redirect to('/')
  end
end

get "/messages/:id" do
  if session[:logged_in]
    @message = messages.where(id: params[:id]).to_a
    p @message
    @user = users.where(id: @message[0][:user_id]).to_a
    p @user
    erb :message
  else
    redirect to('/')
  end
end
