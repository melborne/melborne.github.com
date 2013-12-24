---
layout: post
title: "僕が考えた最速・最小投資でRubyを学ぶ方法またはステマ乙"
description: ""
category: 
tags: 
date: 2013-12-24
published: true
---
{% include JB/setup %}

そろそろ軽くRubyをやってみたいけどなんか情報多すぎてどこから手を付けたらいいかわからない、リファレンス的なものとか言語論的なものとかコミュニティー的なものとかの情報は結構あるけど、もっとカジュアルでかと言ってどの言語でも使いまわせる的な説明じゃなくRubyらしさが浮き出てるようなもので、しかもちょっとしたCLIツールとかWebアプリとかを作れる程度に理解の手助けをしてくれるものがほしいけど、今の段階で大枚叩きたくないしという人向けに僕がRubyの道案内を致します。


## ステップ１（所要時間：０〜１０分、投資額：０円）

あなたのコンピュータでRuby2系を使えるようにします。

- Macなひと => Mavericksをインストールする。

- Windowsなひと => [RubyInstaller for Windows](http://rubyinstaller.org/ "RubyInstaller for Windows")でRuby2系をインストールする。

- Linuxなひと => ご自由に。

ターミナルを開いて以下のようにして確認します。

    % ruby -v
    ruby 2.0.0p0 (2013-02-24 revision 39474) [x86_64-darwin12.2.0]

同時に`irb`という対話型実行環境が導入されているはずです。ためしてみます。

    % irb
    irb(main):001:0> 123 ** 100
    => 97838805977257474352566705351629014033137938449734350966526074342064414099511156930426773522415958061389200997320437636836296142253482249885877442849062074323416253749444792245426920843456133929113701176246001
    irb(main):002:0> Math.sqrt 5
    => 2.23606797749979
    irb(main):003:0> puts "hello, world!"
    hello, world!
    => nil
    irb(main):004:0> ["Madrid", "Tokyo", "Istanbul"].find {|city| city.start_with?("T")}
    => "Tokyo"

<br/>

## ステップ２（所要時間：５分、投資額：０円）

以下のスライドを見ながら自らもirbを叩いて、Rubyのオブジェクト指向を感じる。

<script async class="speakerdeck-embed" data-id="50432e8fd956d50002024bc2" data-ratio="1.2945638432364097" src="//speakerdeck.com/assets/embed.js"></script>


Web版はこちらを。

> [「１から始めるRuby」 on Heroku](http://learn-ruby-from-one.herokuapp.com/#1 "Learn Ruby from One")


<br/>


## ステップ３（所要時間：30分、投資額：100円）

上のスライドを見てRubyに興味を持てたなら、M'ELBORNE出版{% fn_ref 1 %}から出ている以下の電子書籍を買って読みます:-)

> [M'ELBORNE BOOKS]({{ BASE_URL }}/books/ 'M'ELBORNE BOOKS')

<a href="{{ BASE_PATH }}/books/20121201start_ruby.html">
  <img src="/assets/images/2012/start_ruby.jpg" alt="start_ruby" style="width:200px" />
</a>

<a href="http://gum.co/RjRO" class="gumroad-button">電子書籍「これからRubyを始める人たちへ」EPUB版</a><script type="text/javascript" src="https://gumroad.com/js/gumroad-button.js"></script><script type="text/javascript" src="https://gumroad.com/js/gumroad.js"></script>

    上のリンクはGumroadにおける商品購入リンクになっています。クリックすると、オーバーレイ・ウインドウが立ち上がって、この場でクレジットカード決済による購入が可能です。購入にはクレジット情報およびメールアドレスの入力が必要になります。購入すると、入力したメールアドレスにコンテンツのDLリンクが送られてきます。

文庫本にして50頁ほどの短い本ですが、そのなかで簡単なRubyスクリプトの作成、Webアプリの作成、Rubyにおけるクラス構造の説明、メタプログラミングについてちょっと、オススメ紙本の紹介と欲張りな内容となっています。

事前に内容を確かめたい方、100円が大枚だという方はこちらへ。

> [これからRubyを始める人たちへ](http://melborne.github.io/2012/04/09/to-newbie/ "これからRubyを始める人たちへ")

電子本で読みたいけど、[Kindle Paperwhite](http://www.amazon.co.jp/Amazon-53-000955-Kindle-Paperwhite%EF%BC%88%E3%83%8B%E3%83%A5%E3%83%BC%E3%83%A2%E3%83%87%E3%83%AB%EF%BC%89/dp/B00CTUMNAO "Kindle Paperwhite")をお持ちでない方はこちらをインストールして。

> [Amazon.com: Free Kindle Reading Apps](http://www.amazon.com/gp/feature.html/ref=amb_link_361458882_3?ie=UTF8&docId=1000493771&pf_rd_m=ATVPDKIKX0DER&pf_rd_s=center-6&pf_rd_r=0MKXT4XT3WDHGDFHQS4R&pf_rd_t=1401&pf_rd_p=1354791822&pf_rd_i=1000464931 "Amazon.com: Free Kindle Reading Apps")

## ステップ４（所要時間：30分、投資額：100円）

上の書籍を読んでRubyにさらに興味が出てRubyでオブジェクト指向したいと思ったら、M'ELBORNE出版から出ている以下の電子書籍を買って読みます:-)

<a href="{{ BASE_PATH }}/books/20130207understand_ruby_object.html">
  <img src="/assets/images/2013/02/ruby_object_cover.png" alt="ruby_object" style="width:200px" />
</a>

<a href="http://gum.co/zxUk" class="gumroad-button">電子書籍「オブジェクトの理解から始めるRuby」EPUB版</a><script type="text/javascript" src="https://gumroad.com/js/gumroad-button.js"></script><script type="text/javascript" src="https://gumroad.com/js/gumroad.js"></script>

文庫本にして50頁ほどの短い本ですが、Rubyにおけるクラス、モジュール、オブジェクトの基本的事項をやさしく楽しい例と共に学べる内容になっています。

事前に内容を確かめたい方、100円が大枚だという方はこちらへ。

> [Rubyを始めたけど今ひとつRubyのオブジェクト指向というものが掴めないという人、ここに来て見て触って！](http://melborne.github.io/2013/02/07/understand-ruby-object/ "Rubyを始めたけど今ひとつRubyのオブジェクト指向というものが掴めないという人、ここに来て見て触って！")


## ステップ５（所要時間：50分、投資額：100円）

上の書籍を読んでRubyやりたいからなんか簡単なチュートリアルがほしいと思ったら、M'ELBORNE出版から出ている以下の電子書籍を買って読みます:-)

<a href="{{ BASE_PATH }}/books/20130426ruby_tutorial.html">
  <img src="/assets/images/2013/04/ruby_tutorial_cover.png" alt="ruty_tutorial" style="width:200px" />
</a>

<a href="http://gum.co/DBgJ" class="gumroad-button">電子書籍「Rubyチュートリアル ～英文小説の最頻出ワードを見つけよう!」EPUB/MOBI版</a><script type="text/javascript" src="https://gumroad.com/js/gumroad-button.js"></script><script type="text/javascript" src="https://gumroad.com/js/gumroad.js"></script>

文庫本にして170頁ほどの短い本ですが、英文小説の最頻出ワードを見つけるプログラムの作成を通してRubyの基礎を楽しく学ぶチュートリアルです。最初のプログラムの改善（ときには改悪）をこれでもかこれでもかと繰り返し（バージョン1〜29）その過程でRubyの書き方を学ぶものとなっています。

チュートリアルなげーよという方は、Rubyの特徴の説明が書かれた１章は読んで２章のチュートリアルは適当に切り上げて次のステップ６へどうぞ。

事前に内容を確かめたい方、100円が大枚だという方はこちらへ。

> [Rubyチュートリアル ─ 英文小説の最頻出ワードを見つけよう! ─](http://melborne.github.io/2013/04/26/find-most-frequently-words-with-ruby/ "Rubyチュートリアル ─ 英文小説の最頻出ワードを見つけよう! ─")

## ステップ６（所要時間：30分、投資額：100円）

上の書籍を読んでRubyいいよでも遅いよねと思っているなら、M'ELBORNE出版から出ている以下の電子書籍を買って読みます:-)

<a href="{{ BASE_PATH }}/books/20121213ruby_parallelize.html">
  <img src="/assets/images/2012/ruby_parallel_cover.png" alt="ruby_parallel" style="width:200px" />
</a>


<a href="http://gum.co/PjVk" class="gumroad-button">電子書籍「irbから学ぶRubyの並列処理 ~ forkからWebSocketまで」EPUB版 </a><script type="text/javascript" src="https://gumroad.com/js/gumroad-button.js"></script><script type="text/javascript" src="https://gumroad.com/js/gumroad.js"></script>

文庫本にして30頁ほどの短い本ですが、チュートリアルに沿ってRubyの並列処理の基礎を理解する内容になっています。本書を読めばRubyのfork、Thread、Reactor、EventMachine、WebSocketの基本的な使い方を学べます。

事前に内容を確かめたい方、100円が大枚だという方はこちらへ。

> [irbから学ぶRubyの並列処理 ~ forkからWebSocketまで](http://melborne.github.io/2011/09/29/irb-Ruby-fork-WebSocket/ "irbから学ぶRubyの並列処理 ~ forkからWebSocketまで")


## ステップ７（所要時間：40分、投資額：100円）

上の書籍を読んでRubyやるやるTipsも知りたいよと思っているなら、M'ELBORNE出版から出ている以下の電子書籍を買って読みます:-)

<a href="{{ BASE_PATH }}/books/20130304ruby_trivia.html">
  <img src="/assets/images/2013/03/ruby_trivia_cover.png" alt="trivia" style="width:200px" />
</a>

<a href="http://gum.co/owIqH" class="gumroad-button">電子書籍「知って得する！５５のRubyのトリビアな記法」EPUB/MOBI版</a><script type="text/javascript" src="https://gumroad.com/js/gumroad-button.js"></script><script type="text/javascript" src="https://gumroad.com/js/gumroad.js"></script>

文庫本にして120頁ほどの短い本ですが、実用的なTips、役に立たないトリビアを次から次へと紹介して読者を「へぇ」とか「ほぅ」とか言わせる内容になっています。

事前に内容を確かめたい方、100円が大枚だという方はこちらへ。

> [知って得する！５５のRubyのトリビアな記法](http://melborne.github.io/2013/03/04/ruby-trivias-you-should-know-4/ "知って得する！５５のRubyのトリビアな記法")

## ステップ８（所要時間：50分、投資額：100円）

上の書籍を読んでRubyでWebアプリやりたいと思っているなら、M'ELBORNE出版から出ている以下の電子書籍を買って読みます:-)

<a href="{{ BASE_PATH }}/books/20121224lerning_rack.html">
  <img src="/assets/images/2012/rack_cover.png" alt="rack" style="width:200px" />
</a>

<a href="http://gum.co/ZqRt" class="gumroad-button">電子書籍「エラーメッセージから学ぶRack」EPUB版 </a><script type="text/javascript" src="https://gumroad.com/js/gumroad-button.js"></script><script type="text/javascript" src="https://gumroad.com/js/gumroad.js"></script>

RackはRailsやSinatraなどのWebフレームワークでも採用されている、WebサーバーとWebアプリを繋ぐ重要なコンポーネントです。本書は文庫本にして145頁ほどの短い本ですが、rackupコマンドの実行に対するエラー出力を追っていきながら、Rackを学ぶチュートリアルになっています。

事前に内容を確かめたい方、100円が大枚だという方はこちらへ。

> [エラーメッセージから学ぶRack - 最初の一歩](http://melborne.github.io/2012/08/02/build-your-own-web-framework-with-rack/ "エラーメッセージから学ぶRack - 最初の一歩")


## ステップ９（所要時間：30分、投資額：105円）

上の書籍を読んでRackで動的サイトもいいけどブログとかには簡単に構築できる静的サイトがいいよねと思っているなら、M'ELBORNE出版から出ている以下の電子書籍を買って読みます:-)

<a href="{{ BASE_PATH }}/books/20121207jekyll.html">
  <img src="/assets/images/2013/05/jk/jekyll_cover.png" alt="rack" style="width:200px" />
</a>

<a href="http://gum.co/xfJY" class="gumroad-button">電子書籍「30分のチュートリアルでJekyllを理解する」EPUB/MOBI版</a><script type="text/javascript" src="https://gumroad.com/js/gumroad.js"></script>

Jekyllはブログのような静的サイトを構築するためのRuby製ファイルジェネレータです。本書は文庫本にして75頁ほどの短い本ですが、ブログサイトの構築を通してJekyllの基礎を学ぶチュートリアルになっています。ちなみに本ブログもJekyllを使ってgithub上に構築されています。

事前に内容を確かめたい方、100円が大枚だという方はこちらへ。

> [Jekyllいつやるの？ジキやルの？今でしょ！](http://melborne.github.io/2013/05/20/now-the-time-to-start-jekyll/ "Jekyllいつやるの？ジキやルの？今でしょ！")

## ステップ１０（所要時間：40分、投資額：100円）

上の書籍を読んでRubyもいいけどWebアプリやってるとJavaScriptの理解も大事だよねと思っているなら、M'ELBORNE出版から出ている以下の電子書籍を買って読みます:-)

<a href="{{ BASE_PATH }}/books/20121215js_oop.html">
  <img src="/assets/images/2012/js_oop_cover.png" alt="js_oop" style="width:200px" />
</a>

<a href="http://gum.co/wNxf" class="gumroad-button">電子書籍「Ruby脳が理解するJavaScriptのオブジェクト指向」EPUB版 </a><script type="text/javascript" src="https://gumroad.com/js/gumroad-button.js"></script><script type="text/javascript" src="https://gumroad.com/js/gumroad.js"></script>


本書は文庫本にして115頁ほどの短い本ですが、Rubyにおけるオブジェクト指向と対比しながらJavaScriptのオブジェクト指向を学ぶチュートリアルになっています。

事前に内容を確かめたい方、100円が大枚だという方はこちらへ。

> [Ruby脳が理解するJavaScriptのオブジェクト指向](http://melborne.github.io/2012/09/09/understand-js-oop-with-ruby-brain/ "Ruby脳が理解するJavaScriptのオブジェクト指向")

## ステップ１１（所要時間：３００分、投資額：500円）

ここまで読んでRubyはやる気があるけど言う通りにやったらお前に８００円も払わなならんのか気に食わんと思ったなら、M'ELBORNE出版から出ている先の８冊をパッケージにした「電子書籍「Ruby入門パッケージ８」EPUB/MOBI版」(500円)を買って読みます:-)

<a href="{{ BASE_PATH }}/books/20131224ruby_pack8.html">
  <img src="/assets/images/books/ruby_pack8.png" alt="ruby_pack8" style="width:200px" />
</a>

<a href="https://gum.co/WwoyT">電子書籍「Ruby入門パッケージ８」EPUB/MOBI版</a> <script type="text/javascript" src="https://gumroad.com/js/gumroad.js"></script>


## ステップ１２（所要時間：∞分、投資額：∞円）

ここまで読んでRubyやるけどもっとまともな電子書籍ないのと思ってるなら、僕が１年前に書いた以下の記事を読みます:-)

> [今年の冬休みに電子書籍であなたがRubyを習得しなければいけないたった一つの理由](http://melborne.github.io/2012/12/25/ebooks-for-learning-ruby/ "今年の冬休みに電子書籍であなたがRubyを習得しなければいけないたった一つの理由")

## ステップ１３（所要時間：60分、投資額：０〜Amazon出品者の気分円）

ここまで読んで本気でRubyやりたいからRubyの言語仕様の要点を端的に正確にちょっと古くてもいいから知りたいと思ってるなら、青木峰郎さんが書かれた以下の絶版本（通称RHG）の第１章と第８章を読みます。

> [Rubyソースコード完全解説](http://i.loveruby.net/ja/rhg/book/ "Rubyソースコード完全解説")
>
> [第1章 Ruby言語ミニマム](http://i.loveruby.net/ja/rhg/book/minimum.html "第1章 Ruby言語ミニマム")
>
> [第8章 Ruby言語の詳細](http://i.loveruby.net/ja/rhg/book/spec.html "第8章 Ruby言語の詳細")

{{ 4844317210 | amazon_medium_image }}
{{ 4844317210 | amazon_link }} by {{ 4844317210 | amazon_authors }}


<br/>


僕からは以上です。

Merry Christmas!

{% footnotes %}
{% fn M'ELBORNE出版はブログの記事を電子書籍化して販売する僕の実験的プロジェクトです。 %}
{% endfootnotes %}
