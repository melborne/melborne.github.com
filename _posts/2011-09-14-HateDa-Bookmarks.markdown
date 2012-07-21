---
layout: post
title: 僕はブログを書く ~ HateDa::Bookmarks の紹介
date: 2011-09-14
comments: true
categories:
tags: [ruby, hatena, visualization, processing]
---


    僕はブログを書く
    名前も知らない誰かが
    そのテーマに惹かれて
    きっと読んでくれるから
    
    僕はブログを書く
    年齢も性別も知らない誰かが
    僕と同じ関心を持って
    ブクマをしてくれるから
    
    僕はブログを書く
    きっと生涯会うことのない誰かが
    その内容に共感して
    スターやコメントをくれるから
    
    僕はブログを書く
    ブクマやスターを通して
    同じ関心を持っている人たちを
    見つけることができるから
    
    僕はブログを書く
    
    でもどうやったら
    僕のブログに良くブクマしてくれる人を
    簡単に見つけることができるの？
    どうやったら..


というわけで..

はてダのブックマーク情報を取得してブックマーカー別、記事別などの統計を得るための簡単なツールHateDa::BookmarksをRubyで作りました;)

##HateDa::Bookmarksの使い方
次のサイトからファイルをダウンロードします。htmlの解析にNokogiriを使っているので、なければ`gem install nokogiri`してください。

https://github.com/melborne/HateDa]([https://github.com/melborne/HateDa)

以下のように使います。
{% highlight ruby %}
>> require 'hateda'
>> bm = HateDa::Bookmarks.new(:keyesberry) # => #<HateDa::Bookmarks:0x00000100d22570 @username=:keyesberry, @total=nil, @dataset=nil>
>> bm.dataset
>> bm.dataset.first # => {:url=>"http://d.hatena.ne.jp/keyesberry/20110908/p1", :title=>"Ruby脳でCoffeeScriptのクラスを理解する - hp12c", :marker=>"nabetama", :tags=>["ruby", " coffeescript", " javascript", " js"], :note=>"", :time=>2011-09-13 00:00:00 +0900}
>> bm.total #=> 1647
{% endhighlight %}

Bookmarks#datasetメソッドではてなからブックマーク情報を取得し解析します。つまりそこからurl title marker tags note timeの情報を含んだハッシュのリストを生成します。一度取得したデータセットは@datasetにキャッシュされます。Bookmarks#totalメソッドで総ブックマーク数が得られます。

そしてBookmarks#group_by_topメソッドを使って、ブックマーカー別、エントリー別などの集計情報を生成できます。

{% highlight ruby %}
>> top10_markers = bm.group_by_top(:marker, 10).map{|name, list| [name, list.size]}
  # => [["yuiseki", 37], ["Watson", 26], ["tomisima", 23], ["kitokitoki", 16], ["taka222", 14], ["ohnishiakira", 12], ["ku-kai27", 10], ["Naruhodius", 10], ["aka5ping", 10], ["Layzie", 9]]
>> top10_entries = bm.group_by_top(:title, 10).map{|t, list| [t, list.size]}
  # => [["知って得する21のRubyのトリビアな記法 ~ 21 Trivia Notations you should know in Ruby - hp12c", 160], ["QuickSilver、君はランチャーなんかじゃない、実行統合環境だ！ - hp12c", 107], ["IRB　それはRubyistの魔法のランプ - hp12c", 96], ["1から始めるRuby - hp12c", 70], ["Rubyなら動くグラフも作れるよ！ - hp12c", 58], ["SinatraはDSLなんかじゃない、Ruby偽装を使ったマインドコントロールだ！ - hp12c", 53], ["Rubyのシンボルは文字列の皮を被った整数だ！ - hp12c", 45], ["Rubyで論理プログラミングしようよ! - hp12c", 41], ["RubyでANSIカラ - hp12c", 37], ["Ruby製ノコギリで株価を切り刻もう! - hp12c", 29]]
>> Layzie_bookmarks = bm.dataset.select{|h| h[:marker] == 'Layzie'}.map{|h|h[:title]}
  # => ["Rubyのクラスとメソッドを全部いっぺんに！ - 再改訂版 - hp12c", "オープンソース・プログラマも知っておきたい商標のこと（その４） - hp12c", "オープンソース・プログラマも知っておきたい商標のこと（その３） - hp12c", "オープンソース・プログラマも知っておきたい商標のこと（その２） - hp12c", "オープンソース・プログラマも知っておきたい商標のこと（その１） - hp12c", "SchemeとRubyでリストの操作を学ぼう - hp12c", "Ruby.Sinatra.Git.Heroku  #=> \"Happy Web Development!\" - hp12c", "Ruby.Sinatra.Git.Heroku #=> \"Happy Web Development!\"　(後編) - hp12c", "QuickSilver、君はランチャーなんかじゃない、実行統合環境だ！ - hp12c"]
{% endhighlight %}

なおブクマ数が4000を超える場合は、最新4000のブックマークのみを対象にしています{% fn_ref 1 %}。どれくらいの同時アクセスが許容されるのかよくわからないので..{% fn_ref 2 %}。

なおこのツールには以前紹介した、はてダの記事一覧を取得するツールも含まれています。

[Rubyではてダの記事一覧を取得してまとめ頁を作ろう！]({{ site.url }}/2011/01/27/Ruby/)

##Hatena Bookmarkers in Visual
折角なのでこのツールで取得した情報をビジュアライズするDemoサイトをProcessing.jsを使って作ってみました:)あなたのはてダのTOP20ブックマーカーを、グラフ表示するだけの簡単なサイトです。

![image](http://img.f.hatena.ne.jp/images/fotolife/k/keyesberry/20110914/20110914151214.png)

[Hatena Bookmarkers](http://hdbmkrs.heroku.com/)

トップページではてなIDを入れるとグラフが表示されます。最初のアクセスではデータ取得に数秒掛かります。グラフの各バーは各ユーザのサイトにリンクしていて、クリックするとオープンできます。これであなたのブログにブクマしてくれてる人の発信している情報に簡単にアクセスできますね!作りこみが甘い点はDemoということでご勘弁を..

なお現状でブクマ数が4000を超えるサイトのデータ取得がうまくいっていません。ローカルでは問題ないのですがHeroku上ではThreadがうまく生成されていないようです..どなたか解決策が分かりましたら教えて下さい^ ^;

一応サイトのコードも置いておきます。

[melborne/hdbmkrs - GitHub](https://github.com/melborne/hdbmkrs)

(comment)

> nice blog..
> >Dissertation Writing<br>thanks!

{% footnotes %}
   {% fn MAX_PAGESを200に設定 %}
   {% fn このあたりの常識をご存じの方教えて下さい! %}
{% endfootnotes %}

