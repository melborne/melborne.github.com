---
layout: post
title: Cocoaアプリ用Rubyのロードパスを設定しよう
date: 2008-03-05
comments: true
categories:
---


requireでロードされるライブラリファイルは
Rubyのロードパスに置かれる必要がある

現在のロードパスは以下で調べられる
 
> ruby -e 'puts $:'


独自のパスを追加したいときは
環境変数RUBYLIBに設定する
例えば、.zshrcに以下を記述する
 
> export RUBYLIB="$HOME/mylib"


CotEditorでは編集中のファイルに対して
Rubyスクリプトを実行できるけど
そのスクリプトで独自パスにあるライブラリをrequireするときは
上記の設定は生きない

CotEditorなどのCocoaアプリでRubyのロードパスを通すには
~/.MacOSX/environment.plistでRUBYLIBにパスを設定する必要がある
environment.plistが存在しなければ作成する
 
> <key>RUBYLIB</key> 
> <string>~/mylib</string>

設定を有効にするには再ログインが必要となる
