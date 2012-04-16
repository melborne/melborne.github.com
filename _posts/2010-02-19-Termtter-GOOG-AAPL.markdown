---
layout: post
title: TermtterならGOOGだってAAPLだって
date: 2010-02-19
comments: true
categories:
---


Twitterが流行ってます
ＴＬには新しい製品やサービスの情報がぞくぞく流れてきます
そうなるとその会社の株価も気になりますよね?
ええ当然気になります
そんなわけで株価を表示するTermtter pluginを作りました

stock_price (またはstp) コマンドのあとにTicker Symbolを打ちます
![image](http://img.f.hatena.ne.jp/images/fotolife/k/keyesberry/20100219/20100219075804.png)


realtimeの情報が知りたければ -r オプションを付けます
![image](http://img.f.hatena.ne.jp/images/fotolife/k/keyesberry/20100219/20100219075800.png)


Ticker Symbolは複数渡せます
![image](http://img.f.hatena.ne.jp/images/fotolife/k/keyesberry/20100219/20100219075803.png)


でも株価を知りたいけど
Ticker Symbolが分からないってことありますよね?
そんなときは stock_find (またはstf) コマンドが使えます
![image](http://img.f.hatena.ne.jp/images/fotolife/k/keyesberry/20100219/20100219075802.png)


そしてその会社に興味を持ったなら
当然株価の履歴情報も知りたくなります
そんなときは stock_history (またはsth) コマンドを使ってください
日付指定なしでここ一週間ほどの履歴が表示されます
![image](http://img.f.hatena.ne.jp/images/fotolife/k/keyesberry/20100219/20100219075801.png)


では日付指定してYHOOの黄金期を見てみましょう
![image](http://img.f.hatena.ne.jp/images/fotolife/k/keyesberry/20100219/20100219075805.png)


Termtterってやっぱり便利ですね!

<del datetime="2010-03-03T19:05:08+09:00">残念ながら日本のマーケットには対応していませんorz..</del>
(追記:2010/3/3)日本のマーケットに対応しました！
[Ruby製ノコギリで株価を切り刻もう!]({{ site.url }}/2010/03/02/Ruby/)

使用にはyahoo_stock libraryが必要です
gem install yahoo_stock してください
すべてのcommandは添付のstock.rbにあります
termtterのpluginディレクトリにコピーして
plug stockしてください
ライセンスはTermtterに準拠します

[gist: 297408 - Termtter plugins- GitHub](http://gist.github.com/297408)
