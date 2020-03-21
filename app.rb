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
    session[:user_id] = users.where(params)
    p session
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
    puts 'Looks valid enough' + @email
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
  @name = params[:name]
  @email = params[:email]

  @names = users.select('name')
  @emails = users.select('email')
  name_validator = NameValidator.new(@name, @names)
  email_validator = EmailValidator.new(@email, @emails)
  puts 'Hey there, you are now in a post'
  if name_validator.valid? & email_validator.valid?
    puts 'Looks valid enough' + @email
    user_id = users.insert(:name => @name, :email => @email)
    messages.insert(:user_id => user_id, :text => params[:message])
  else
    puts name_validator.message
    puts email_validator.message + params[:email]
  end
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
    @user = users.where(id: @message[0][:user_id]).to_a
    erb :message
  else
    redirect to('/')
  end
end
