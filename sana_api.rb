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
  Sequel.mysql2(settings.database_name,
                :host=>settings.database_hostname,
                :user=>settings.database_username,
                :password=>settings.database_password,
                :port=>settings.database_port)
end

get '/anime/v1/twitter/follower/status' do
  accounts = params[:accounts]

  result = {}
  return json result if accounts.nil?

  db = db_connection()
  base_ids = db[:bases].filter(:twitter_account => accounts.split(',')).select(:id,:twitter_account).order(:cours_id).all

  account_name_hash = {}
  #重複を除いたIDリストを作成
  base_ids.each{|base|
    account_name_hash[base[:twitter_account]] = base[:id]
  }

  p account_name_hash
  target_ids = account_name_hash.map{ |k,v| v }
  id_name_map = account_name_hash.invert

  p id_name_map

  status_list = db[:twitter_statuses].filter(:bases_id => target_ids).select(:bases_id, :follower, :updated_at).all

  result = {}

  status_list.each {|status|
    name = id_name_map[status[:bases_id]]
    follower = status[:follower]
    updated_at = status[:updated_at].to_i
    result[name] = { 'follower' => follower, 'updated_at' => updated_at}
  }

  json result
end

get '/anime/v1/twitter/follower/history' do
  account = params[:account]
  end_date = params[:end_date]

  result = {}
  return json result if account.nil? or end_date.nil?

  db = db_connection()
  data = { foo: "bar" }
  json data
end

get '/anime/v1/twitter/follower/history/week' do
  account = params[:accounts]
  end_date = params[:end_date]

  result = {}
  return json result if account.nil? or end_date.nil?

  db = db_connection()
  data = { foo: "bar" }
  json data
end