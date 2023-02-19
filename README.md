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