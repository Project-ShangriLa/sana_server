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

### POST /anime/v1/twitter/follwer/status

リクエストで指定されたアニメ公式アカウントの最新のフォロワー数を返却します

#### Request Body

| Property     | Value               |description|Sample|
| :------------ | :------------------ |:--------|:-------|
| Array    |String|対象のTwitterアカウントの配列|["usagi_anime","kinmosa_anime"] |


#### Response Body

| Property     | Value               |description|Sample|
| :------------ | :------------------ |:--------|:-------|
| Array    |follwer Object|データがない場合は空の配列|

##### follwer Object

| Property     | Value               |description|Sample|
| :------------ | :------------------ |:--------|:-------|
| account    |String|Twitterアカウント|usagi_anime|
| follwer    |Number|フォロワー数|12500|
| created_at   |Number|データの作成日時 UNIXTIMESTAMP|1446132941|
| updated_at   |Number|データの更新日時 UNIXTIMESTAMP|1446132941|



### POST /anime/v1/twitter/follwer/history

リクエストで指定されたアニメ公式アカウントのフォロワー数の履歴返却します

#### Request Body


| Property     |Value |Required|description|Sample|
| :------------|:-----|:-------|:----------|:-----|
| Array    |String|◯|対象のTwitterアカウントの配列|["usagi_anime","kinmosa_anime"] |
| size |Number|-|1アカウントの履歴最大数(※)|50|
| start_date |Number|-|検索対象の履歴開始日(unixtimestamp)||
| end_date |Number|-|検索対象の履歴終了日(unixtimestamp)||

※履歴最大数はサーバー側で制限をかけます、MAX50の予定

#### Response Body

| Property     | Value               |description|Sample|
| :------------ | :------------------ |:--------|:-------|
| Array    |history Base Object|データがない場合は空の配列|

##### history Base Object

| Property     | Value               |description|Sample|
| :------------ | :------------------ |:--------|:-------|
| account    |String|Twitterアカウント|usagi_anime|
| Array    |history Object|配列最大長=50||


##### history Object

| Property     | Value               |description|Sample|
| :------------ | :------------------ |:--------|:-------|
| follwer    |Number|フォロワー数|12500|
| updated_at   |Number|データの更新日時 UNIXTIMESTAMP|1446132941|
