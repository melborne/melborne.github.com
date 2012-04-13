---
layout: post
title: Termtter is a Sandbox for Rubyists!
date: 2010-01-23
comments: true
categories:
---


Termtter　それはTwitterクライアント
名前を聞けば　誰でもわかる
ターミナル用　Twitterとすぐわかる

Termtter　gem install termtterでOKだ
軽やかにtermtterと　打ち込めば
ターミナルに広がる　ANSI color

Termtter　それはRubyで書かれてる
だから僕にも　きっとわかる
Rubie{% fn_ref 1 %}の僕にも いつかはわかる

Termtter　それはプラグインでできている
基本機能も　ユーザコードも
コマンド全部が　プラグインでできている

$
listだって　aliasだって
updateだって　openだって
そう
Termtter is a Sandbox for Rubyists!

Termtter　だから無限に拡張できる
基本機能も　変更できる
アイデア次第で　どこまでも

shellだって　fibだって
irbだって　gだって
そう
Termtter is a Sandbox for Rubyists!

D.S.（$に戻って繰り返し）
そう
Termtter is a Sandbox for Rubyists!

～Termtter開発チームへの感謝に代えて～
[Termtter](http://termtter.org/)
[System.Exit &#8211; Termtter &#8211; ターミナルエミュレータ上で動作する Twitter クライアント](http://jugyo.org/blog/2931)

##この2週間のつぶやき
http://twitter.com/merborne
-(10/01/06 11:19) hello from rubytter!
-(10/01/06 11:47) termtterを入れてみたのだけど、api.rb#try_authでこける。 
-(10/01/06 11:52) try again from rubytter
-(10/01/07 11:01) Helo from termtter
-(10/01/07 11:02) おー Termtter
-(10/01/07 11:04) ライブラリがちゃんとインストールされてなかったみたい。ruby19をdeactivateしたらうまくいっ た。
-(10/01/07 14:23) termtter is colorized on screen but tmux.
-(10/01/08 10:13) なんか日本語入力がうまくいかない
-(10/01/09 21:03) hi from rubytter!
-(10/01/13 09:55) termtterでリンクを開くのはuri-open pluginを使えばいいんだ。
-(10/01/13 09:59) ε=&#8932;&#8933;
-(10/01/13 10:00) ε=&#8932;&#8933;&#8932;&#8933;&#8932;&#8933;&#8932;&#8933;&#8932;&#8933;&#8932;&#8933;&#8932;&#8933;&#8932;&#8933;&#8932;&#8933;&#8932;&#8933;
-(10/01/13 10:32) train plugin...
-(10/01/13 11:33) 芸術 爆発しろ!
-(10/01/13 13:11) 爆発くろ 爆発しろ!
-(10/01/13 13:12) 爆発あか！ 爆発しろ!
-(10/01/13 13:12) !ろし発爆 爆発しろ!
-(10/01/13 13:13) plugin bomb 爆発しろ!
-(10/01/13 13:24) Listening now: 雪の華 (6:01) パク・ヒョシン Sorry, I love you
-(10/01/13 13:26) iTunes plugin
-(10/01/13 13:26) Listening now: God (4:10) John Lennon John Lennon/Plastic Ono Band
-(10/01/13 14:03) #termtterが壊れた [ERROR] Rubytter::APIError: Rate limit exceeded. Clients may not make more than 150 requests per hour. web
-(10/01/13 14:06) jugyo: @merborne API limit ですね  (reply_to [$ca])
-(10/01/13 14:21) @jugyo どうもです。followersコマンドしたら固まったのが原因かな。termtter楽しいです。勉強 になります。  (reply_to [$bz]) web
-(10/01/13 15:06) #termtter息を吹き返す
-(10/01/13 19:45) termtterの中でirbも使える!
-(10/01/13 22:32) termtterの中でgも使える! g (1..10).inject(:*)とか interactive g?
-(10/01/14 18:13) termtterで使っているTermColorライブラリ面白い
-(10/01/14 18:16) irb -rtermcolorとしてputs "<on_green><red><underline>Hello, TermColor!</underline></red></on_green>".termcolorとか
-(10/01/14 18:17) puts TermColor.colorize('hello', 'red')とか
-(10/01/14 18:28) でTermColorはHighLineというライブラリを使っていて、こちらはerbを使う。irb -rhighline/importしして say "Hello, <%= color('HighLine!', :red, :on_green, :underline) %>とか
-(10/01/14 18:42) HighLineにはinput validationもあってans = ask("love or hate?: "){|q| q.in = %w(love hate)}とかできる
-(10/01/14 19:15) termtterの色を変える方法を未だ発見できず...blueが見づらいので
-(10/01/14 19:20) jugyo: @merborne eval config.plugins.stdout.colors = , :magenta, :cyan ] みたいにすると使う色を変えられます  (reply_to [$bq])
-(10/01/14 19:29) @jugyo できました　ありがとうございます  (reply_to [$cb])
-(10/01/15 09:27) TerminalのANSIカラーを調整できるツールを見つけた これでtermtterを一層キレイに! http://www.culater.net/software/TerminalColors/TerminalColors.php
-(10/01/15 09:29) TerminalColors leopard版も http://niw.at/articles/2007/11/02/TerminalColoreopard/ja
-(10/01/15 09:54) termtterでurlを短くするにはtinyurl pluginを使えばいいんだ #termtter Termtter> 
-(10/01/15 10:00) termtter上でtinyurlを展開して表示するにはexpand-tinyurl pluginを使えばいいんだ
-(10/01/15 10:19) termtterで特定のポストのurlを開くにはopen pluginを使って o ID とすればいいんだ
-(10/01/15 11:26) termtterでポストを削除するにはdel [ID]とすればいいんだ 直前のポストならdel とだけすればいいんだ
-(10/01/15 11:31) termtterでポスト前にconfirmationするにはconfirm pluginを使えばいいんだ config.confirm=trueも試してみたけど動かなかった
-(10/01/15 11:33) jugyo: @merborne config.confirm=true が動かないのはおかしいですねぇ..  (reply_to [$bb])
-(10/01/15 15:17) termtterで写真をポストするにはtwitpic pluginを使って twitpic [message] /path/to/a/photo.jpg とすればいいんだ(要twitpic gem)
-(10/01/15 19:01) termtterで日本語が長くなると挙動が変になる やっぱ環境がおかしい ruby入れ直そうかな
-(10/01/17 15:25) termtterで20件以上のポストを見たい場合は l -40 とかすればいいんだ
-(10/01/17 15:27) termtterで古いポストを遡りたいときは list_with_opts pluginを使って l -p=2とかすればいいんだ
-(10/01/17 21:48) termtterでステータスのurlを開くにはuri-open pluginを使えばいいんだ
-(10/01/17 22:01) uri-openでは uo in $arとしても uo listか ら=> uo 3としても uo allとしてもいいんだ
-(10/01/18 09:04) termtterで日本語を入力するときに行の折り返し位置で挙動がおかしくなっていたのはTerminal.appのエミュレーション設定で行の折り返しを逆にするがオンになっていたからだったた
-(10/01/18 19:01) hello_from_frfx_w_tmtr
-(10/01/22 19:14) termtterでhashtagを付けてupdateするときは hashtag add termtterとすればpromptがtag付きになりupdateに自動でhashtagが付くんだ
-(10/01/22 19:18) hashtag listで一覧 hashtag clearで消去 一時的にhashtagを付けたくないときはraw_updateでポ ストすればいいんだ
-(10/01/22 19:29) termtterでコマンドを短くしたいときはalias li uri-open listとするかconfigにconfig.plugins.alias.aliases={:li=>'uri-open list'}とすればいいんだ
{% footnotes %}
   {% fn RubieはRuby+newbieからなる造語です %}
{% endfootnotes %}
