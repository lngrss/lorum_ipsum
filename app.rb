require_relative 'config/database'
require_relative 'validators/name_validator'
require_relative 'validators/email_validator'
require 'sinatra'
require 'erb'
require 'time'
require 'pry'

users = DB[:users]
messages = DB[:messages]

get '/' do
  erb :index
end

get '/home' do
  erb :home
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
  @messages_list = messages.all
  erb :messages
end

get "/messages/:id" do
  @message = messages.where(id: params[:id]).to_a
  @user = users.where(id: @message[0][:user_id]).to_a
  puts @user
  erb :message
end
