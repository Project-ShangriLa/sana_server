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

  #p account_name_hash
  return json result if base_ids.nil? || base_ids.length == 0

  target_ids = account_name_hash.map{ |k,v| v }
  id_name_map = account_name_hash.invert

  #p id_name_map

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
  end_datetime = nil

  result = {}
  return json result if account.nil?

  if end_date != nil
    #変換できないと0に
    end_datetime = Time.at(end_date.to_i)
    #0だと1970年あたりになる
  end

  db = db_connection()

  base = db[:bases].filter(:twitter_account => account).select(:id).order(:cours_id).reverse.first

  p base
  return json result if base.nil?

  #Sequel.expr(:col) > 123
  history = []

  if end_datetime.nil?
    history = db[:twitter_status_histories].filter(:bases_id => base[:id]).select(:follower, :updated_at).order(:updated_at).reverse.limit(100).all
  else
    history = db[:twitter_status_histories].filter(:bases_id => base[:id]).select(:follower, :updated_at).where(Sequel.expr(:updated_at) < end_datetime).order(:updated_at).reverse.limit(100).all
  end



  result = history.map {|x| { 'follower' => x[:follower],  'updated_at' => x[:updated_at].to_i } }
  json result
end

#バッチは不定期に毎日何回もDBにデータを格納するため日付単位のデータが欲しい場合はクライアントはこちらを呼びだす
#基本的に00:00に近いデータをその日のデータとしている
get '/anime/v1/twitter/follower/history/daily' do
  LIMIT_DAYS = 30
  account = params[:account]
  days = params[:days]

  result = []
  return json result if account.nil?

  days_i = days.to_i

  days_i = 7 if params[:days].nil? || days_i == 0 || days_i > LIMIT_DAYS

  db = db_connection()
  base = db[:bases].filter(:twitter_account => account).select(:id).order(:cours_id).reverse.first
  return json result if base.nil?

  #SQLはSana Batch(diff)から転載
  def build_past_follower_sql(id, past_hours)
    past_follower_sql = <<EOS
SELECT bases_id,follower,get_date FROM twitter_status_histories WHERE
bases_id = #{id} AND
get_date
between date_add(date(now()), interval - #{past_hours} day) and date_format(now(), '%Y.%m.%d') order by id;
EOS
    past_follower_sql
  end

  history = []
  tmp_day =  nil
  db.fetch(build_past_follower_sql(base[:id], days_i)) do |row|
    if tmp_day != row[:get_date].day
      history << row
      tmp_day = row[:get_date].day
    end
  end

  #
  result = history.map{|h|
    #h[:get_date] = h[:update_at] なのでどちらでもよい
    { 'follower' => h[:follower], 'updated_at' => h[:get_date].to_i, 'yyyy-mm-dd' => h[:get_date].strftime('%Y-%m-%d') }
  }

  json result
end