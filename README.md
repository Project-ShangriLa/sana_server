#Sana 紗凪
ShangriLa Anime API Server for Twitter Data

## Sana Server システム概要

### 説明

* アニメに関するTwitterのデータを返すREST形式のAPIサーバーのリファレンス実装です。
* ShangriLa Anime API のサブセットです。

### サーバーシステム要件

* Ruby 2.2+
* フレームワーク Sinatra

### インストール

#### DB
* MySQL、もしくはMySQL互換サーバーのインストール
* anime_admin_development データベース作成
* 必要なDDLの投入

#### sana batch

* 実際にTwitterのデータを取り扱うにはTwitterから定期的にデータを取得するバッチを実行する必要があります

#### API Server

```
bundle install
```

### 起動方法

```
bundle exec ruby sana.rb
```

## V1 API リファレンス

### エンドポイント

http://api.moemoe.tokyo/anime/v1

### 認証

V1では認証を行いません。


### レートリミット

なし

### GET /anime/v1/twitter/follwer/status

リクエストで指定されたアニメ公式アカウントの最新のフォロワー数を返却します

#### Request Body

| Property     | Value               |description|Sample|
| :------------ | :------------------ |:--------|:-------|
| accounts    |String|対象のTwitterアカウントをカンマ区切りにしたもの|"usagi_anime","kinmosa_anime"|


#### Response Body

| Property     | Value               |description|Sample|
| :------------ | :------------------ |:--------|:-------|
| Request twitter_account 1|follwer Object||"usagi_anime": {..}|
| Request twitter_account 2|follwer Object||"kinmosa_anime": {..}|
| Request twitter_account X|follwer Object||"lovelive_staff": {..}|

##### follwer Object

| Property     | Value               |description|Sample|
| :------------ | :------------------ |:--------|:-------|
| follwer    |Number|フォロワー数|12500|
| created_at   |Number|データの作成日時 UNIXTIMESTAMP|1446132941|
| updated_at   |Number|データの更新日時 UNIXTIMESTAMP|1446132941|



### GET /anime/v1/twitter/follwer/history

リクエストで指定されたアニメ公式アカウントのフォロワー数の履歴返却します

#### Request Parameter


| Property     |Value |Required|description|Sample|
| :------------|:-----|:-------|:----------|:-----|
| accounts    |◯|String|対象のTwitterアカウントをカンマ区切りにしたもの|"usagi_anime","kinmosa_anime"|
| size |Number|-|1アカウントの履歴最大数(※) デフォルト50|50|
| start_date |Number|-|unixtimestampで指定した日時より過去のデータを取得 where start_date > updated_at |1446132941|

※履歴最大数はサーバー側で制限をかけます。50以上は無視され50に修正されます。

#### Response Body

| Property     | Value               |description|Sample|
| :------------ | :------------------ |:--------|:-------|
| Request twitter_account 1|history Object Array|配列最大長=50|"usagi_anime": []|
| Request twitter_account 2|history Object Array||"kinmosa_anime": []|
| Request twitter_account X|history Object Array||"lovelive_staff": []|


##### history Object

| Property     | Value               |description|Sample|
| :------------ | :------------------ |:--------|:-------|
| follwer    |Number|フォロワー数|12500|
| updated_at   |Number|データの更新日時 UNIXTIMESTAMP|1446132941|

データは更新日時の昇順でソートされ格納されている