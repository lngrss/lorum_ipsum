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

  if name_validator.valid? & email_validator.valid?
    user_id = users.insert(:name => @name, :email => @email)
    messages.insert(:user_id => user_id, :text => params[:message])
  else
    puts name_validator.message
    puts email_validator.message
  end
  erb :contact
end

# get '/messages' do
#   @users_list = users.all
#   erb :messages
# end
