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

Line 23~27: 
   docker runでオプションをつけていたものをここに記載する。

* Docker-compose DB

Line 35~38:
   Databaseに接続するdatabase名、username, パスワード
   setting_release.pyにアプリがデータベースに接続するように設定している。

     

