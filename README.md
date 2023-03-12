# ec2-docker-python_todolist
*Dockerfile
Line 2:
   FROM: 使用するイメージ(alpineの3.13.5) alpine=Linuxのdistribution
   AS: 記述されているコマンドのタイプ、目的
Line 3: 
   LABEL: nameタグ
Line 6:
   RUN: 実行内容を記述
   apk add: alpineパッケージ管理コマンドをaddする
   --no-cache: パッケージを一時保存しないようにする。イメージを余計に保存してデータ容量を使ってしまうため。
   bash, gitもインストールしている。
Line 7: 
　 curlをインストール
Line 10:
   WheelはPythonがファイルをアーカイブする機能

Line 13:
   COPY: copyする。
   COPY /src/requirements* /build/
   src配下にあるrequirmentsから始まるファイルをbuild配下にコピーする。
Line 14:   
   WORKDIR: Linuxのcdと同じ意味

Line 17:
   wheel: zipファイルのような形式に固めて保存している。
Line 18:
   install: wheelしたファイルをインストール

Line 21:
   src配下すべてのフォルダをappにコピー
* buildを迅速化のためにLine 13とcopyを分けている。変更があると最初からbuildをして時間がかかるため。

 Line 25: 
    CMD: コマンドを実行（テストのため)
* docker build時はrunコマンドで実行、runの後のdocker imageを動かすときはCMDで実行する。

本番環境↓
  Line 32:
     jq=Json形式でテキストを形成する
     bats=テストで使用するコマンド

  Line 35:
     addgroup -gで ID1000番台のグループをappという名前で作成、
     -u 1000   
     addduser -u でユーザーID1000番台のappという名前のユーザーを作成して先に作成したappグループに追加する。

   
　Line 39, 40
     --from=test: Line 1のAS testからファイルをコピーする。testからbuildとappをコピーして本番環境でをそれぞれbuildとappを作成する。
     もともとのファイルがroot権限になっているためchown(change owner)でapp user, app groupに変更する。セキュリティの観点で。
     build(パッケージ関係のフォルダ)
     app(sourceコードフォルダ)
　Line 41
     requirments fileに記載のものをインストール。
     -f build: build（ここにパッケージをインストールしてあるので）にパッケージを探しに行ってインストールする。
  Line 42:
     パッケージをbuildからインストールし終えたので、buildディレクトリを削除する。


* docker ignore
  
  Line 2:
     .sqlite3のファイルはコピーしないように。
     **：.sqlite3とついているすべてのファイルが対象

* Docker Compose 

Line 1: 
   docker composeのバージョン指定

Line 3~12:
   testとreleaseのサービスのコンテナのビルド
context: .   current directly をdockerの作業対象にしている。   
dockerfile: ビルドするfileを指定。


depends on:  ここのdbが問題なかったら上記リリースサービスのコンテナのビルドが発動する。
     service healthyの判断は下記30~33行目のhealthcheckで判断する。

release:
  build: ここでreleaseコンテナ基本の設定をして下記extendsのappとmigrateで用途に分けて細かくコマンドで指示するイメージ。 
  environment: 
       Django setting module:  がdbに接続するための環境変数の記載
      

extends: 
   file:  別のdocker-compose.ymlファイルから呼んでくることもできる。


   service: 任意のコンテナサービス名

app (コンテナ): 上記releaseの情報を受けてアレンジ(webサーバー系のコマンド)を加える。

migrate (コンテナ): 上記releaseの情報を受けてアレンジ(migrateのコマンド)を加える。

command: 
      docker runでオプションをつけていたものをここに記載する。

* Docker-compose DB

db: 
  environment: 
       環境変数を指定
　      Databaseに接続するdatabase名、username, パスワード
   
   
   *setting_release.pyにアプリがデータベースに接続するように設定している。

   volumes: コンテナは毎回使い捨て のためファイルを作成して、追記しても次コンテナを起ち上げた時にはファイルもなくなっている。そのためvolumeでコンテナの外のコンテナ管理領域(/var/lib/docker/volumes/todobackend/_data/static/)とコンテナ内の指定ディレクトリを紐づけして、管理領域のディレクトリに作成したファイルをコンテナ作成起動時に自動的に反映させる。
public:/publicで互いのディレクトリを紐づけしている。

Docker fileに下記を記載してコンテナにファイルの実行権限を与える。
# Create public volume
RUN mkdir /public
RUN chown app:app /public
VOLUME /public

   publicはこちらで決めたvolumeの名前

*acceptance bats追加
batsのコンテナの追加     

*Makefile
10行目 docker-compose build
コンテナエラー対策のためbuildコマンドを配置
14行目 docker-compose up --abort-on-container-exit migrate
コンテナbuildエラー対策のため作成中にエラーが起これば、コンテナを破棄して終了するオプション。

*Line 42:　die on term
異常が起こって終了するときに緊急終了させないで、コンテナを通常終了（すべて処理を終わらせてから）させるため。

Line: 43, 44
process, thread同時処理のプロセスの設定、性能改善