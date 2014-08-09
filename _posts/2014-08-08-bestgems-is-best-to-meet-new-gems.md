---
layout: post
title: "Ruby製サードパーティライブラリgemのトレンドを知るには「BestGems.org」がベスト"
description: ""
category: 
tags: 
date: 2014-08-08
published: true
---
{% include JB/setup %}

## ─質問１─

> Ruby製サードパーティライブラリ、要は`gem`で、何が人気なのかってこと、手っ取り早く知りたいんですけど。


## ─回答１─

> `RubyGems.org`の[statsページ](https://rubygems.org/stats "stats")を見てください。

![bestgem noshadow]({{ BASE_PATH }}/assets/images/2014/08/bestgems01.png)

## ─質問２─

> えっ？これだけ？この辺は万年上位で固定でしょ。もうちょっと俺の知らないバラエティに富んだものに出会いたいんだけど。俺、Rails用ないし。


## ─回答２─

> カテゴリー別なら`The Ruby Toolbox`があります。


![bestgem noshadow]({{ BASE_PATH }}/assets/images/2014/08/bestgems02.png)

> [The Ruby Toolbox - Terminal Coloring](https://www.ruby-toolbox.com/categories/Terminal_Coloring "The Ruby Toolbox - Terminal Coloring")

## ─質問３─

> あんた、俺の質問ちゃんと聞いてるの？カテゴリー別なんて言ってないし。それに、ここのカテゴリーってなんか俺的に信用ないんだよね。取りこぼし多いっていうか..。俺のgem出てこないっていうか..。


## ─回答３─

> `GitHub`のTrendingでここ最近の人気リポジトリが分かります。


![bestgem noshadow]({{ BASE_PATH }}/assets/images/2014/08/bestgems03.png)

> [Trending Ruby repositories on GitHub this month](https://github.com/trending?l=ruby&since=monthly "Trending Ruby repositories on GitHub this month")

これをメールで定期的にもらうこともできます。

> [Subscribe to GitHub's Explore Email](https://github.com/explore/subscribe "Subscribe to GitHub's Explore Email")

ターミナルで見たいならgemがあります。

> [git-trend というrubygemsを作りました - rochefort's blog](http://rochefort.hatenablog.com/entry/2014/06/09/070300 "git-trend というrubygemsを作りました - rochefort's blog")

## ─質問４─

> まあ、これはこれでいいんだけどさ。でも俺、確か、`gem`って言ったよね、さっき？人気gemの再発見したいんだけど。

## ─回答４─

@xmisaoさんが作った`BestGems.org`があります。約80,000個ある全gemの総合ダウンロードランキングが分かります。

![bestgem noshadow]({{ BASE_PATH }}/assets/images/2014/08/bestgems04.png)

> [BestGems -- Ruby Gems Download Ranking](http://bestgems.org/ "BestGems -- Ruby Gems Download Ranking")

BestGems.orgはオープンソースでもあります。

> [xmisao/bestgems.org](https://github.com/xmisao/bestgems.org "xmisao/bestgems.org")

## ─質問５─

ほぅ。じゃあ50番目に人気のあるgemが何かとかわかるの？

## ─回答５─


![bestgem noshadow]({{ BASE_PATH }}/assets/images/2014/08/bestgems05.png)

> [41-60 of all 79,598 gems](http://bestgems.org/total?page=3 "Total")

前日のダウンロード数（日別）のランキングも分かります。

> [Daily Download Ranking -- Best Gems](http://bestgems.org/daily "Daily Download Ranking -- Best Gems")

総合ランキングと日別ランキングの差から最近の人気度を図る`Featured`というものもあります。

![bestgem noshadow]({{ BASE_PATH }}/assets/images/2014/08/bestgems06.png)

> [Featured Gems Ranking -- Best Gems](http://bestgems.org/featured "Featured Gems Ranking -- Best Gems")


## ─質問６─

おー、これいいね。なんか、面白いgem見つけられるかも。

あれ、そう言えば、日毎のダウンロード数って、[RubyGems.orgのAPI](http://guides.rubygems.org/rubygems-org-api/ "RubyGems.org")じゃ、取れなかったと思うんだけど。

## ─回答６─

BestGems.orgにおけるgemの個別ページでは、ダウンロード数やランキングの伸びをグラフで見ることができます。

![bestgem noshadow]({{ BASE_PATH }}/assets/images/2014/08/bestgems07.png)

> [power_assert -- BestGems](http://bestgems.org/gems/power_assert "power_assert -- BestGems")

## ─質問７─

BestGems.orgは全gemについて日毎のダウンロード数、収集してるんだ。すごいな。そうすると、自分が作ったgemの成長過程をここで見ることもできる、ってわけだ。

いや、実は、自分の作ったgemのダウンロード数が気になっちゃって、ここのところ寝れなくってさ。勢いで、`mygegegems`ってgem作ったんだけど。あー、要はターミナルで自分のgemのダウンロード数見るやつ。

> [自分が公開しているgemの日々のダウンロード数が気になって寝られません。どうしたらいいでしょうか（Yawhoo知恵袋）](http://melborne.github.io/2014/07/14/count-your-gems-in-your-terminal/ "自分が公開しているgemの日々のダウンロード数が気になって寝られません。どうしたらいいでしょうか（Yawhoo知恵袋）")
>
>[mygegegems](https://rubygems.org/gems/mygegegems "mygegegems")

これ、一応前日からのダウンロード数の伸びが分かるようになってるんだけど、こんな感じで。

![bestgem noshadow]({{ BASE_PATH }}/assets/images/2014/08/bestgems08.png)

で、これ、アクセスした日だけダウンロード数をYAMLファイルに記録するんだけど、アクセスしない日もあるしね..。YAMLにどこまでデータ溜めるんだって話もあるし。

BestGems.orgの収集したデータにアクセスするAPIでもあったら、捗るんだけどな...。


## ─回答７─

`BestGems API`が公開されています。各gemについて、「総ダウンロード数」、「日別ダウンロード数」、「総合ランキング」および「日別ランキング」の各トレンド、つまりBestGems.org開設からの日毎のデータがJSONで取れます。

> [BestGems API v1 Specification · xmisao/bestgems.org Wiki](https://github.com/xmisao/bestgems.org/wiki/BestGems-API-v1-Specification "BestGems API v1 Specification · xmisao/bestgems.org Wiki")


## ─質問８─

えっ？API、あるの{% fn_ref 1 %}？

    % curl http://bestgems.org/api/v1/gems/mygegegems/total_downloads.json

    [{"date":"2014-08-07","total_downloads":583},{"date":"2014-08-06","total_downloads":569},{"date":"2014-08-05","total_downloads":569},{"date":"2014-08-04","total_downloads":563},{"date":"2014-08-03","total_downloads":557},{"date":"2014-08-02","total_downloads":550},{"date":"2014-08-01","total_downloads":544},{"date":"2014-07-31","total_downloads":542},{"date":"2014-07-30","total_downloads":534},{"date":"2014-07-29","total_downloads":489},{"date":"2014-07-28","total_downloads":466},{"date":"2014-07-27","total_downloads":444},{"date":"2014-07-26","total_downloads":441},{"date":"2014-07-25","total_downloads":441},{"date":"2014-07-24","total_downloads":428},{"date":"2014-07-23","total_downloads":359},{"date":"2014-07-22","total_downloads":326},{"date":"2014-07-21","total_downloads":326},{"date":"2014-07-20","total_downloads":312},{"date":"2014-07-19","total_downloads":303},{"date":"2014-07-18","total_downloads":303},{"date":"2014-07-17","total_downloads":303},{"date":"2014-07-16","total_downloads":301},{"date":"2014-07-15","total_downloads":255},{"date":"2014-07-14","total_downloads":202},{"date":"2014-07-13","total_downloads":141},{"date":"2014-07-12","total_downloads":6}]
    
おー、これはうれしい。

するってーと、だ。俺としてはこのデータを、Rubyのオブジェクトとして取り込めればいいんだな。まずは、ラッパークライアント書くか。

## ─回答８─

BestGems.org APIのRubyラッパーライブラリ`bestgems`があります。

> [bestgems](https://rubygems.org/gems/bestgems "bestgems")
> 
> [melborne/bestgems](https://github.com/melborne/bestgems "melborne/bestgems")

こう使います。

{% highlight ruby %}
require 'bestgems'

client = Bestgems.client

client.total_downloads(:rack) # => {"2014-08-08"=>48484297, "2014-08-07"=>48426620, "2014-08-06"=>48365953, "2014-08-05"=>48305390, "2014-08-04"=>48246069, "2014-08-03"=>48203248, ... }

client.daily_downloads(:rack) # => {"2014-08-08"=>57677, "2014-08-07"=>60667, "2014-08-06"=>60563, "2014-08-05"=>59321, "2014-08-04"=>42821, "2014-08-03"=>30640, ... }

client.total_ranking(:rack) # => {"2014-08-08"=>2, "2014-08-07"=>2, "2014-08-06"=>2, "2014-08-05"=>2, "2014-08-04"=>2, "2014-08-03"=>2, "2014-08-02"=>2, "2014-08-01"=>2, "2014-07-31"=>2, ... }

client.daily_ranking(:rack) # => {"2014-08-08"=>6, "2014-08-07"=>6, "2014-08-06"=>6, "2014-08-05"=>7, "2014-08-04"=>4, "2014-08-03"=>3, "2014-08-02"=>3, "2014-08-01"=>6, "2014-07-31"=>6, ... }
{% endhighlight %}


## ─質問９─

おー、こりゃ助かる。これ、誰が作ったの？

## ─回答９─

あなた様です{% fn_ref 2 %}。

## ─質問１０─

そうか、じゃあちょっと信用ならなぃ..。えっ？俺？...そうか、昨日書いたのか...。記憶力落ちたな。あー[octokit.rb](https://github.com/octokit/octokit.rb "octokit/octokit.rb")のコード<del>パクリ</del>ちらちら見ながら、書いてたわ..。

まあ、それはいいとして、BesGems.orgの話に戻るんだけど、全gemのランキングが分かるっていったよね？そうすると、不人気の、つまり「ぺけ」のほうのgemも分かるってことだよね？「不人気gemベスト５０」とか、ちょっと興味あるな...。それ、見せてみてよ..。

## ─回答１０─

こちらになります。

![bestgem noshadow]({{ BASE_PATH }}/assets/images/2014/08/bestgems09.png)


下から５番目...orz

---

(追記：2014-8-9) bestgems gemの仕様変更に伴い記述（コード）を変更しました。


{% footnotes %}
{% fn 実のところBestGems.orgのAPIはtwitter上での@xmisaoさんと僕とのやりとりで生まれたのでした。https://twitter.com/merborne/status/488681089586585600 %}
{% fn 今日はこれが言いたかった %}
{% endfootnotes %}
