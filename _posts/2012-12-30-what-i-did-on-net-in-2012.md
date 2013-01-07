---
layout: post
title: "2012年僕の周りに起こったはじめての出来事"
description: ""
category: 
tags: 
date: 2012-12-30
published: true
---
{% include JB/setup %}

今年はいろいろと「**初めてづくし**」の１年だったよ。だから「**はじめて**」をキーワードにしてこの１年を振り返ってみることにしたよ。もちろん僕は「ネットに生きてる」からネットにおける出来事限定でね。

##１月　はじめてDankogai氏にdisられる

１月の頭に僕はソートアルゴリズムに関する次のような記事を書いたんだよ。

> {% hatebu  http://melborne.github.com/2012/01/09/notitle/ 新ソートアルゴリズム「配列挿入ソート」だ! %}

クイックソートの５倍も速い「配列挿入ソート」ってアルゴリズムを考えたって記事だよ。いろいろと制約があるし極めて単純だからもちろんネタだったんだけど、なんと、PerlのDankogai氏から「そりゃおまえ、世界最古のソートだから」ってツッコミが入ったんだよ。

> [404 Blog Not Found:algorithm - bucket sort - 比較しなければソートは相当速い](http://blog.livedoor.jp/dankogai/archives/51764496.html '404 Blog Not Found:algorithm - bucket sort - 比較しなければソートは相当速い')

このことを通して僕は「あー無知って素晴らしいな」って学んだんだよ。だってDankogai氏から突っ込まれるなんてチャンス（栄誉）は一生のうちにそうないだろうからね。

##３月　はじめてrubygemを作成し公開する

今までもまあなんちゃってプログラムは適当に書いて[Github](https://github.com/melborne 'melborne')で公開はしてきたよ。でもgemは一度も作ったことはなかったんだよ。それでこのブログをはてなからGithub Pagesに移行するに当たってgsub_filterってツールを作ったので、これでgemを作ってみることにしたんだ。

そうしたら`bundle gem <gem_name>`コマンドを使えば、思いの外簡単にgemが作れて、`rake release`一発で公開できることがわかったんだよ。以下の記事を参考にしながらね。

> [ASCIIcasts - “Episode 245 - Bundlerでgemを作る”](http://ja.asciicasts.com/episodes/245-new-gem-with-bundler 'ASCIIcasts - “Episode 245 - Bundlerでgemを作る”')

結局、この１年で次の５つのgemを作ることができたんだ。


![Alt title]({{ site.url }}/assets/images/2012/gems.png)

graphvizのRubyラッパーである`gviz`が2000超DLで一番人気だけど、`hateda2md`が1700もDLされてるって、どういうことなんだろうね。でもまあ作ったものに関心を持ってくれる人がいるっていうのは、うれしいもんだよね。RubyGems.orgへのリンクとこのブログにおける紹介ページを公開順に挙げておくよ。

### [gsub_filter](https://rubygems.org/gems/gsub_filter 'gsub_filter | RubyGems.org | your community gem host')
> 
> {% hatebu http://melborne.github.com/2012/03/24/gsub_filter/ 'RubyのGsubチェーンはイケてない?' %}

### [hateda2md](https://rubygems.org/gems/hateda2md 'hateda2md | RubyGems.org | your community gem host')
> 
> {% hatebu http://melborne.github.com/2012/05/05/to-be-hatena-notation-or-to-be-markdown/ '一生涯はてな記法しますか？それともMarkdownしますか？' %}


### [gviz](https://rubygems.org/gems/gviz 'gviz | RubyGems.org | your community gem host')
> 
> {% hatebu http://melborne.github.com/2012/09/25/ruby-plus-graphviz-should-eql-gviz/ 'Yet Another Ruby Graphviz Interfaceを作ったからみんなで大量のグラフを作って遊ぼうよ！' %}

### [colorable](https://rubygems.org/gems/colorable 'colorable | RubyGems.org | your community gem host')
> 
> {% hatebu http://melborne.github.com/2012/11/07/play-gviz-with-colorable/ 'Rubyライブラリ「Colorable」とGvizを使ってGraphvizで綺麗なリングを描く' %}

### [maliq](https://rubygems.org/gems/maliq 'maliq | RubyGems.org | your community gem host')
> 
> {% hatebu http://melborne.github.com/2012/12/03/when-bloggers-become-publishers/ 'RubyによるMarkdownをベースにしたEPUB電子書籍の作り方と出版のお知らせ' %}


##４月　JekyllとGithub Pagesでブログをはじめる
僕のブログは６年間はてだにお世話になってたんだけど([hp12c](http://d.hatena.ne.jp/keyesberry/ 'hp12c'))、まあいろいろと不満もあったよ。その一方でなんかGithub上でブログを運営できる[GitHub Pages](http://pages.github.com/ 'GitHub Pages')というのがあって、そこでブログをやってるとHackerっぽくてクール見えるって噂が流れてきたんだ。で、まあ僕はそーゆうのに弱いから一念発起して移転することにしたんだよ。

ブログは[jekyll](http://jekyllrb.com/ 'jekyll')と[Jekyll-Bootstrap](http://jekyllbootstrap.com/ 'Blogging with Jekyll Tutorial | Jekyll-Bootstrap')を使って構築したんだ。移転は容易ならざるものだったけど、その過程でいろいろと勉強になることがあったよ。移転の工程は記事にできてないんだけど、関連記事として次のものを書いているよ。

> {% hatebu http://melborne.github.com/2012/05/13/first-step-of-jekyll/ 30分のチュートリアルでJekyllを理解する %}
> 
> {% hatebu http://melborne.github.com/2012/05/05/to-be-hatena-notation-or-to-be-markdown/ 一生涯はてな記法しますか？それともMarkdownしますか？ %}

##４月　はじめてブックマークが1000を超える
ブログを移転するにあたって心配だったのは、はてなを離れたら記事に対するアクセスがなくなるんじゃないかってことだったよ。まあ元々大した数じゃないから気にしてもしょうがないんだけどね。で、少し気合を入れてRubyの入門記事を移転に併せて書いてみたんだ。そうしたらそれが空前のアクセスとなってブクマが1,000を超えたんだ。

> {% hatebu http://melborne.github.com/2012/04/09/to-newbie/ 'これからRubyを始める人たちへ' %}

「Windowsを質に入れてMacbook airを」ってくだりが問題発言視されて炎上気味になったことも、アクセスを多くしたってのが皮肉なところではあるけどね。このことでWindowsを愛してる人たちが結構いることを知ったんだ。ブコメでは僕のことを「Mac厨」っていう人たちがいたけれど、どう見ても僕は「Ruby厨」だから、そこんとこよろしくね。これからはその手の発言には気をつけるよ。この記事は今でもコンスタントに100前後のページビューがあるんだ。

##７月　はじめてふぃちゃりくえすとする

Rubyの機能に対するはじめてのFeature Requestを[Ruby Issue Tracking System](http://bugs.ruby-lang.org/projects/ruby?jump=issues '概要 - Ruby - Ruby Issue Tracking System')に出したよ。

> {% hatebu http://melborne.github.com/2012/07/03/feature-request-enumerable-with/ 'はじめてのふぃちゃありくえすと〜Ruby編' %}

最初は`Object#do`っていうのと、`Enumerable#with`の２件だけど、更に２件追加して以下の４件をリクエストしたんだ。

> [Feature #6684: Object#do - ruby-trunk - Ruby Issue Tracking System](http://bugs.ruby-lang.org/issues/6684 'Feature #6684: Object#do - ruby-trunk - Ruby Issue Tracking System')
> 
> [Feature #6687: Enumerable#with - ruby-trunk - Ruby Issue Tracking System](http://bugs.ruby-lang.org/issues/6687#change-28453 'Feature #6687: Enumerable#with - ruby-trunk - Ruby Issue Tracking System')
> 
> [Feature #6758: Object#sequence - ruby-trunk - Ruby Issue Tracking System](http://bugs.ruby-lang.org/issues/6758#change-28415 'Feature #6758: Object#sequence - ruby-trunk - Ruby Issue Tracking System')
> 
> [Feature #6801: String#~ for a here document - ruby-trunk - Ruby Issue Tracking System](http://bugs.ruby-lang.org/issues/6801 'Feature #6801: String#~ for a here document - ruby-trunk - Ruby Issue Tracking System')

まあ何れも採用には至っていないけれども、ここでもいろいろと学ぶことがあったよ。patch無しのこんな素人発想のリクエストに対してもRuby Communityは真摯に対応してくれること、Communityにはいろいろな国のRubyistが活発に活動していること、大量のRequest TrafficをさばくRubyコミッタの人たちがほんとうにRubyを支えているんだと実感できたこと、などだよ。もう僕は逆立ちしてしか寝ることができないよ！

##７月　はじめてMatzと交流する
7月に僕はRubyにおいてシーケンスを簡単に生成する`Object#repeat`を考えたって記事を書いたよ。

> {% hatebu http://melborne.github.com/2012/07/12/object-repeat-take-care-of-sequence/ 'RubyにおけるシーケンスはObject#repeatに任せなさい！' %}

で、この記事はなかなか評判が良かったんだけど、すごいオマケが最後に付いてきたんだよ。そう、Matzがこの機能に対して次のようにツイートしたんだ。

![Alt title]({{ site.url }}/assets/images/matz_tweet_repeat.png)

で、舞い上がっちゃった僕は、これはどうですかあれはどうですかってreplyしたんだけど、Matzの納得いくものは出せなかったんだ。そうしたらこれを眺めていたRubyistたちがいろいろと名前案を出してくれて、最終的に僕はそれを抱えて`Object#sequence`という名前でFeature Requestすることができたんだよ。今のところこれが採用される動きはないけれども、なんかわくわくぞくぞくする経験ができたんだよ。

##１０月　AdSenseをはじめる
１０月に入ってからこのブログにGoogleのAdSenseを貼らせてもらっているよ。申し込みから２、３日で設置が完了したのであまりの簡単さに拍子抜けしたよ。まあこの手のブログにおける収益は高が知れてるだろうけど、手間なしで稼げるってやっぱいいよね。

##１２月　はじめて電子書籍を作成し出版する
gemのところで出てきたけれどもMarkdownのドキュメントからepubを作る[maliq](https://rubygems.org/gems/maliq 'maliq | RubyGems.org | your community gem host')というツールを作ったんだ。

> {% hatebu http://melborne.github.com/2012/12/03/when-bloggers-become-publishers/ 'RubyによるMarkdownをベースにしたEPUB電子書籍の作り方と出版のお知らせ' %}

それでこのツールを使ってこのブログの記事を電子書籍化して[Gumroad](https://gumroad.com/ 'Gumroad')で出版したんだ。もちろん本の出版なんてはじめての出来事だよ。そして１２月中に次の５冊を出すことができたんだよ（各100円だから良かったら買ってみてね ^ ^;）。

<div class="books">
  <div class="book" id="">
    <div class="cover">
      <img src='{{ site.url }}/assets/images/2012/start_ruby.jpg' alt='Start Ruby Book' />
    </div>
    <div class="buyButton">
      {% gumroad RjRO Gumroadで購入 %}
    </div>
  </div>
  <div class="book" id="">
    <div class="cover">
      <img src='{{ site.url }}/assets/images/2012/jekyll_cover.jpg' alt='Jekyll Book' />
    </div>
    <div class="buyButton">
      {% gumroad xfJY Gumroadで購入 %}
    </div>
  </div>
  <div class="book" id="">
    <div class="cover">
      <img src='{{ site.url }}/assets/images/2012/ruby_parallel_cover.png' alt='Ruby Parallel Book' />
    </div>
    <div class="buyButton">
      {% gumroad PjVk Gumroadで購入 %}
    </div>
  </div>
  <div class="book" id="">
    <div class="cover">
      <img src='{{ site.url }}/assets/images/2012/js_oop_cover.png' alt='JS OOP Book' />
    </div>
    <div class="buyButton">
      {% gumroad wNxf Gumroadで購入 %}
    </div>
  </div>
  <div class="book" id="">
    <div class="cover">
      <img src='{{ site.url }}/assets/images/2012/rack_cover.png' alt='Rack Book' />
    </div>
    <div class="buyButton">
      {% gumroad ZqRt Gumroadで購入 %}
    </div>
  </div>
</div>

<div style='clear:both;'></div>

既に公開されたブログの記事にお金を払ってくれる人がいるのか疑問に思う人もいると思うんだ。僕もそうだったし。でも実際にやってみて、それにいろんな意味付けをして買ってくれる人が世の中にはいるということが分かったんだよ。もちろん公表できるほどの数量ではないけれども、それはね、金品以上の価値を僕に与えてくれているんだ。

---

2012年、僕に起こった「はじめての出来事」は以上のようなものだよ。来年はどんな年になるかな。目標や抱負といったものは僕にはないけれども、今年以上に何か新しいことをはじめられたらうれしいな。


