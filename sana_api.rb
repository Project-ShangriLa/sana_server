require "sinatra"
require "sinatra/json"
require "sequel"

#TODO DB接続情報は設定ファイルに書く
configure do
  set(:database_name) { 'anime_admin_development' }
  set(:database_hostname) { 'localhost' }
  set(:database_username) { 'root' }
  set(:database_password) { '' }
  set(:database_port) { '3306' }
end

def db_connection()
  Sequel.mysql2(@database_name, :host=>@database_hostname, :user=>@database_username, :password=>@database_password, :port=>@database_port)
end

get '/anime/v1/twitter/follower/status' do
  db = db_connection()
  data = { foo: "bar" }
  json data
end

get '/anime/v1/twitter/follower/history' do
  db = db_connection()
  data = { foo: "bar" }
  json data
end

get '/anime/v1/twitter/follower/history/week' do
  db = db_connection()
  data = { foo: "bar" }
  json data
end