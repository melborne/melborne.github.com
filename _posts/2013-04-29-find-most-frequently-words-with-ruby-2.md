---
layout: post
title: "Rubyチュートリアル ─ 英文小説の最頻出ワードを見つけよう! ─（その２）"
description: ""
category: 
tags: 
date: 2013-04-29
published: true
---
{% include JB/setup %}

この記事は、─	[電子書籍「Rubyチュートリアル ～英文小説の最頻出ワードを見つけよう!」EPUB/MOBI版](http://melborne.github.io/books/20130426ruby_tutorial.html "Rubyチュートリアル ～英文小説の最頻出ワードを見つけよう!")─の公開第２弾です（[第１弾はこちら](http://melborne.github.io/2013/04/26/find-most-frequently-words-with-ruby/ "Rubyチュートリアル ─ 英文小説の最頻出ワードを見つけよう! ─")）。本書第２章のバージョン01〜13の範囲を掲載しています。	

電子書籍版は、タブレット端末向けのEPUBとKindle向けのMOBI形式を用意しています。もちろんデスクトップ向けのEPUBリーダー（[Kitabu他](https://itunes.apple.com/jp/app/kitabu/id492498910?mt=12 "Mac App Store - Kitabu")）および[Kindleリーダー](http://www.amazon.com/gp/feature.html?ie=UTF8&docId=1000493771 "Amazon.com: Free Kindle Reading Apps")も提供されていますので、本書をPCまたはMacで読むこともできます。１００円と大変お求めやすい価格になっておりますので、ご購入検討頂けましたら大変に嬉しく思いますm(__)m	

![Alt title]({{ site.url }}/assets/images/2013/04/ruby_tutorial_cover.png)

<a href="http://gum.co/DBgJ" class="gumroad-button">電子書籍「Rubyチュートリアル ～英文小説の最頻出ワードを見つけよう!」EPUB/MOBI版</a><script type="text/javascript" src="https://gumroad.com/js/gumroad-button.js"></script><script type="text/javascript" src="https://gumroad.com/js/gumroad.js"></script>

    （目次）
    序章
    １章　Rubyの特徴
      Rubyはオブジェクト指向です
      Rubyのブロックは仮装オブジェクトです
      クラスはオブジェクトの母であってクラスの子であるオブジェクトです
      Rubyはユーザフレンドリです
    ２章　最頻出ワードを見つける
      バージョン01（最初の一歩）
      バージョン02（処理の分離）
      バージョン03（injectメソッド）
      バージョン04（sort_byメソッド）
      バージョン05（takeメソッド）
      バージョン06（take_byメソッドの定義）
      バージョン07（Enumerable#take_byの定義）
      バージョン08（top_by_valueの定義）
      バージョン09（top_by_valueの改良）
      バージョン10（DRY原則）
      バージョン11（block_given?メソッド）
      バージョン12（DRY再び）
      バージョン13（block_given?の移動）
      バージョン14（ARGF.take_wordsの定義）
      バージョン15（make_freq_dicの定義）
      バージョン16（スクリプトのクラス化）
      バージョン17（top_by_lengthの定義）
      バージョン18（DRY三度）
      バージョン19（入力の拡張）
      バージョン20（ネットアクセス）
      バージョン21（メソッドの追加）
      バージョン22（出力形式の再考）
      バージョン23（pretty_printの定義）
      バージョン24（GUI版）
      バージョン25（クラスの拡張）
      バージョン26（他の演算メソッドの定義）
      バージョン27（DRY四度）
      バージョン28（ユニークワードの抽出）
      バージョン29（仕上げ）
    終章
    謝辞

---

# ２章　最頻出ワードを見つける

さてこれまでに得た知識を基礎として、目的のRubyスクリプトを作ります。最初にベースとなるコードを提示して、これを少しずつ改良していきながらRubyを学びます。

まずは手元にRubyで処理できる英文小説のテキストファイルを用意します。以下のサイトがよさそうです。

[Top 100 - Project Gutenberg](http://www.gutenberg.org/browse/scores/top "Top 100 - Project Gutenberg")

ここから気に入った小説をplain text形式で2、3ダウンロードします。

もしrubyインタプリタが手元にないか、ヴァージョンが古いのなら、[Ruby公式サイト](http://www.ruby-lang.org/ja/)にアクセスして入手します。4.8.10があればいいですが1.9.3でも2.0でも足ります。ターミナルを開いて ruby -v と打てばインストールされているrubyのヴァージョンが分かります。

さて準備が整ったら、まずは入力と出力をイメージしましょう。このRubyスクリプトの名前をtopwords.rbとします。もちろんtop10.rbでもtopoftheworld.rbでもかまいません。
{% highlight ruby %}
 $ ruby topwords.rb novel1.txt novel2.txt novel3.txt
 {'this' => 123, 'is' => 85, 'a' => 65, 'ruby' => 30, ... }
{% endhighlight %}

rubyインタプリタにスクリプト名と上で入手したファイルを渡します。その実行結果として、最頻出単語とその出現数のリストが得られる、そんなイメージがよさそうです。

次にRubyスクリプトの大ざっぱなプランを描きます。

例えば次のように、

1. コマンド引数として渡したファイルをスクリプトに取り込むためにARGFというオブジェクトを使う
1. ARGFから順次ファイルの行を読み出す
1. 読み出した行から単語を切り出す
1. ハッシュオブジェクトを用意して単語とその出現数の対を格納する
1. ハッシュオブジェクトの内容をその出現数の順位で並べ替える
1. その上位30を取り出す


 
{% csssig h2 id='version01' class='version' %}
##バージョン01（最初の一歩）
{% endcsssig %}

突然ですが、この方針による最初のスクリプトは次のようになりました。
{% highlight ruby %}
 dic = Hash.new(0)
 while line = ARGF.gets
   line.downcase!
   while line.sub!(/[a-z]+/, "")
     word = $&
     dic[word] += 1
   end
 end
 
 p dic.sort { |a, b| b[1] <=> a[1] }[0...30]
{% endhighlight %}

最初に単語と出現数のリストを格納するハッシュオブジェクトを用意します。ハッシュは通常 dic = {}で簡単に生成できますが、ここでは対応するキーがない場合のデフォルト値0を設定するために、newメソッドを呼んでいます。これにより6行目の増分が可能になります。

Rubyはスクリプトに指定した引数をファイル名とみなして、その内容を持ったARGFというオブジェクトを作り出します。ARGFオブジェクトは、その内容にアクセスするためのメソッド群を持っており、ここではその１つであるgetsメソッドを使って、ファイルの各行を文字列オブジェクトとして得ています。

ARGFといわれてもピンと来ませんが、何かの略です。たぶんAiR GolFかARGument Filesです。

いえ、わかりました。ARt GarFunkelの略です。そのうちPRSMというのも出てくると思います。

以下のサイトで「ARGF」を検索しリンクを辿れば、ARGFが持っているメソッドを調べられます。

[Ruby 1.9.3 Methods List](http://rbref.heroku.com/)

whileループで順次ファイルの行を変数lineに読み込みます。getsメソッドはファイルの終わりに来るとnilを返しますから、ここでループが終わります。読み込まれた行はdowncase!メソッドで小文字に変換され、次にsub!メソッドでそこから単語を切り出します。

sub!メソッドは第1引数の正規表現の条件にマッチしたものを、第2引数(ここでは空文字)に置き換えます。sub!メソッドは元のline文字列オブジェクト自体を変更します。つまりlineはマッチするたびに短くなっていき、最後にはマッチするものが無くなってnilが返りループが終わります。マッチした単語はその都度変数$&でアクセスできます。

取得したwordでハッシュdicのキーにアクセスし、対応するバリューを増分します。dicに対応wordが無い場合、デフォルト値0で項目が作成され1増分されます。

次にハッシュオブジェクトであるdicをソートします。sortメソッドはハッシュの\[key, value\]を要素とする配列の配列を作り、ブロックの条件でこれをソートした結果を返します。ここではvalue値の大小でソートします。降順ソートとするためa,bを逆に書きます。

最後に\[ \]メソッドに0...30の範囲オブジェクトを渡して、対象の配列オブジェクトのみを取り出します。ドットが3つであることに注意してください。この場合は30つまり31番目の要素は範囲外になります。

では、実際に入手したファイルでこのスクリプトを実行してみましょう。
{% highlight ruby %}
 $ ruby topwords.rb 11.txt 1342.txt 18503.txt 
 [["the", 16077], ["of", 9823], ["and", 7482], ["to", 7098], ["in", 4456], ["a", 3841], ["that", 3161], ["was", 3040], ["it", 2919], ["i", 2881], ["her", 2550], ["she", 2313], ["as", 2134], ["you", 2071], ["not", 2057], ["be", 2044], ["is", 2033], ["his", 2009], ["he", 1940], ["for", 1927], ["with", 1875], ["on", 1638], ["had", 1567], ["but", 1519], ["s", 1495], ["all", 1363], ["at", 1344], ["by", 1308], ["this", 1249], ["have", 1201]]
{% endhighlight %}

うまくいきました。'the'が英文小説における最頻出ワードであることが分かりました。上の正規表現は「'」にうまく対応していないので完全ではありませんが、一応これで仕事が片づきました。上司に報告が必要な人は、この結果をプリントアウトしてください。

{% csssig h2 id='version02' class='version' %}
##バージョン02（処理の分離）
{% endcsssig %}

10行程度のスクリプトで目的を達成できました。前置きばかりが長かったこの連載もこれで終えられます。

でも...

わたしはどうも気に入りません。先のコードは分かりにくいというか、Rubyっぽくないというか...

もう一度スクリプトを見てみます。
{% highlight ruby %}
 dic = Hash.new(0)
 while line = ARGF.gets
   line.downcase!
   while line.sub!(/[a-z]+/, "")
     word = $&
     dic[word] += 1
   end
 end
 
 p dic.sort { |a, b| b[1] <=> a[1] }[0...30]
{% endhighlight %}

不満点を言えば...

!を忘れただけで無限ループに陥るのがヤです。「こら」と「こら！」で確かに雰囲気は変わりますが、怒っていることに変わりはありません。

「$&」記号が意味不明です。しかも中途半端です。「$&♀」なら納得しますが...（ええ、男には無くてはならないものです）。

subの第2引数も何かを忘れちゃったようでヤです。できれば省略したい。

なによりもオブジェクト指向してません。

そうです。気に入らないなら改良しましょう。リファクタリングです。

単語を切り出す処理をdicを作る処理と切り分けましょう。
{% highlight ruby %}
 WORDS = ARGF.read.downcase.scan(/[a-z]+/)
 dic = Hash.new(0)
 for word in WORDS
   dic[word] += 1
 end
 p dic.sort { |a, b| b[1] <=> a[1] }[0...30]
{% endhighlight %}

一行目を見てください。「Rubyはオブジェクト指向です」のところで説明した、メソッドチェーンです。ここではARGFに対しreadメソッドで一気にファイルを読み出し、まとめて小文字化した文字列オブジェクトを得ています。そしてscanメソッドを使ってそこから単語を切り出しています。scanメソッドはマッチした単語の配列を返します。これをWORDSで参照できるようにします。

次にfor文でWORDSから単語を一つずつ取り出し辞書を作ります。

1行目がオブジェクト指向的なコードになり、機能的にも(1)単語の切り出し(2)辞書dicの作成(3)ソートの各処理が分離して全体がすっきりしました。大分好きなかたちになりました。

 
{% csssig h2 id='version03' class='version' %}
##バージョン03（injectメソッド）
{% endcsssig %}
でもこうなると、(2)がオブジェクト指向的でなく、制御構造中心になっているところが気になる人は気になります。

リファクタリングしましょう。
{% highlight ruby %}
 WORDS = ARGF.read.downcase.scan(/[a-z]+/)
 DICTIONARY = WORDS.inject(Hash.new(0)) { |dic, word| dic[word] += 1 ; dic }
 p DICTIONARY.sort { |a, b| b[1] <=> a[1] }[0...30]
{% endhighlight %}

配列のinjectメソッドは畳み込みという処理をする便利なメソッドです。injectは引数とブロックを取って引数で渡されたオブジェクトに、配列の各要素をブロック内の条件で投入していきます。

次のコードは配列要素を順次引数10に加算した結果を返します。
{% highlight ruby %}
 p [1, 2, 3].inject(10) { |mem, var| mem + var } 
 # >> 16
{% endhighlight %}

上のスクリプトでは引数に初期値0のハッシュを与えて、ブロック内で辞書を作ります。なおinjectメソッドからの返り値をハッシュオブジェクトとするために、ブロックの返り値をdicとする必要があります。

スクリプトが3行になりました。極めてワードエコなコードです。Rubyのパワーを垣間見ます。これなら上司も喜びます。

オブジェクト指向の良いところは、文章を読むように左から右にコードを読めるところです。ファイルを読んで小文字にして単語を取り出す。単語からその出現数の辞書を作る。辞書をソートして先頭の30件を取り出す。

さあ目的は達成できました。スクリプトもRubyっぽくなりました。気分がいいです。

{% csssig h2 id='version04' class='version' %}
##バージョン04（sort_byメソッド）
{% endcsssig %}

先のスクリプトにわたしは何の不満もありません。でもリファクタリングはクセになります。3行目のsortのブロックが気になる人には気になります。

{% highlight ruby %}
 p DICTIONARY.sort { |a, b| b[1] <=> a[1] }[0...30]
{% endhighlight %}


少し直しましょう。
{% highlight ruby %}
 WORDS = ARGF.read.downcase.scan(/[a-z]+/)
 DICTIONARY = WORDS.inject(Hash.new(0)) { |dic, word| dic[word] += 1 ; dic }
 p DICTIONARY.sort_by { |key, val| val }.slice(-30..-1)
{% endhighlight %}

sortに代えてsort_byを使いました。辞書の要素数が多ければこちらのほうが速度的に有利です。これは好みの問題かもしれませんが。\[\]に代えてsliceを使いました。sort_byが昇順ソートになっているので、sliceの範囲オブジェクトは最後尾(-1)から指定しています。

 
{% csssig h2 id='version05' class='version' %}
##バージョン05（takeメソッド）
{% endcsssig %}
でも次の方がもっとすっきりします。
{% highlight ruby %}
 WORDS = ARGF.read.downcase.scan(/[a-z]+/)
 DICTIONARY = WORDS.inject(Hash.new(0)) { |dic, word| dic[word] += 1 ; dic }
 p DICTIONARY.sort_by { |key, val| -val }.take(30)
{% endhighlight %}

valを負数にすれば降順ソートになります。takeメソッドは先頭から30要素を取ります。

###TMTOWTDI
「同じことをやるのに複数のやり方があっていい」というのがPerlの流れを汲むRubyの流儀です。ですからRubyではこのように同じ処理を複数の方法で実現できます。

この「同じことをやるのに複数のやり方があっていい」という考え方は、英語では -TMTOWTDI- といいます。

> There's More Than One Way To Do It

だそうです。最初に見たとき、

> TiMe TO WheTher Die or Ill

かと思いました。

でもいま、本当の答えに気が付きました。 -TMTOWTDI- は正規表現だったんです。

> /Today's (Mon|Tue) Or (Wed|Thu) Day/I

 
{% csssig h2 id='version06' class='version' %}
##バージョン06（take_byメソッドの定義）
{% endcsssig %}
やり方が複数あることに最初は戸惑うかもしれません。でもジブンノカタチニコダワル派には麻薬になります。

ではもう少しコダワッテ...

この「ハッシュをソートして端からいくつか取る」というのは、汎用性がありそうです。標準メソッドに似たようなtake_whileというのはあるのですが、目的のものはありません。

では、これをtake_byメソッドとしてHashクラスに作りましょう。
{% highlight ruby %}
 class Hash
   def take_by(nth)
     sort_by { |elem| yield elem }.take(nth)
   end
 end
 
 WORDS = ARGF.read.downcase.scan(/[a-z]+/)
 DICTIONARY = WORDS.inject(Hash.new(0)) { |dic, word| dic[word] += 1 ; dic }
 p DICTIONARY.take_by(30) { |key, val| -val }
 p DICTIONARY.take_by(30) { |key, val| val }
 
 # >[["the", 16077], ["of", 9823], ["and", 7482], ["to", 7098], ["in", 4456], ["a", 3841], ["that", 3161], ["was", 3040], ["it", 2919], ["i", 2881], ["her", 2550], ["she", 2313], ["as", 2134], ["you", 2071], ["not", 2057], ["be", 2044], ["is", 2033], ["his", 2009], ["he", 1940], ["for", 1927], ["with", 1875], ["on", 1638], ["had", 1567], ["but", 1519], ["s", 1495], ["all", 1363], ["at", 1344], ["by", 1308], ["this", 1249], ["have", 1201]]
 [["rained", 1], ["grows", 1], ["pearly", 1], ["hinder", 1], ["overturn", 1], ["interpose", 1], ["infuse", 1], ["prescribes", 1], ["escaping", 1], ["guinness", 1], ["belch", 1], ["humbling", 1], ["appropriately", 1], ["luminous", 1], ["frailty", 1], ["rightful", 1], ["nods", 1], ["purple", 1], ["sepulcher", 1], ["hollow", 1], ["rivaled", 1], ["pearls", 1], ["eyed", 1], ["judaizing", 1], ["fulton", 1], ["taylor", 1], ["coincidence", 1], ["apocalypticae", 1], ["clime", 1], ["atoning", 1]]
{% endhighlight %}

あまり好まれるやり方ではありませんが、このようにRubyでは組み込みのクラスを開いてそこにメソッドを追加することも簡単にできるのです。

これでDICTIONARYに対するメソッド呼び出しが１つで済むようになりました。

ちょっと分かりづらいかもしれませんが、キモはメソッド定義中のyieldです。yieldがあるとメソッド呼び出しの際に、ブロックを取れるようになります。メソッドが呼び出されて実行がyieldに達すると、ブロックが実行されます。

上の例ではsort_byのブロック引数elemに、ハッシュの最初の要素つまりkey, valueの組が渡されると、yieldがtake_byに付けられたブロックの中身-valになります。

{% csssig h2 id='version07' class='version' %}
##バージョン07（Enumerable#take_byの定義）
{% endcsssig %}
更に欲が出てきました。このtake_byというメソッドを配列でも使いたくなりました。

実は先のsort_byというメソッドはHashクラスにもArrayクラスにも定義されていません。それが定義されているのはEnumerableというモジュールです。モジュールというのはクラスの亜種です。オブジェクトを生成できないクラスです。飛べない鳥ニワトリのようなものです（説明のためモジュールおよびニワトリに対するこのような差別的発言をお許しください）。

EnumerableモジュールをHashおよびArrayクラスにインクルードすることで、sort_byの夢のコラボが実現しています。

我らtake_byにも夢を実現させましょう。
{% highlight ruby %}
 module Enumerable
   def take_by(nth)
     sort_by { |elem| yield elem }.take(nth)
   end
 end
 
 WORDS = ARGF.read.downcase.scan(/[a-z]+/)
 DICTIONARY = WORDS.inject(Hash.new(0)) { |dic, word| dic[word] += 1 ; dic }
 p DICTIONARY.take_by(30) { |key, val| -val }
 p WORDS.take_by(30) { |word| -word.length }
 
 #> [["the", 16077], ["of", 9823], ["and", 7482], ["to", 7098], ["in", 4456], ["a", 3841], ["that", 3161], ["was", 3040], ["it", 2919], ["i", 2881], ["her", 2550], ["she", 2313], ["as", 2134], ["you", 2071], ["not", 2057], ["be", 2044], ["is", 2033], ["his", 2009], ["he", 1940], ["for", 1927], ["with", 1875], ["on", 1638], ["had", 1567], ["but", 1519], ["s", 1495], ["all", 1363], ["at", 1344], ["by", 1308], ["this", 1249], ["have", 1201]]
 #> ["communicativeness", "congregationalist", "indestructibility", "disinterestedness", "misrepresentation", "superciliousness", "unenforceability", "unenforceability", "incomprehensible", "inextinguishable", "discontentedness", "internationalism", "incomprehensible", "unenforceability", "congratulations", "acknowledgments", "accomplishments", "unrighteousness", "condescendingly", "congratulations", "transformations", "merchantibility", "notwithstanding", "congratulations", "recommendations", "appropriateness", "congratulations", "contemporaneous", "comprehensively", "thoughtlessness"]
{% endhighlight %}

すばらしい！

配列オブジェクトを指すWORDSに対して、ワード長降順の条件でtake_byメソッドを呼んでいます。

実はわたくし最頻出ワードよりも最長ワードに興味があったのですよ。'incomprehensibleなcongregationalist'になりたい！そんな今日この頃です...

さて...

もう終わりでしょうか？気になる人には気になるところは、もうないでしょうか。

 
{% csssig h2 id='version08' class='version' %}
##バージョン08（top_by_valueの定義）
{% endcsssig %}
take_byでよく使いそうなのは、やっぱり最大値最小値でソートしてtakeでしょう。take_byとは別にHashクラスにこれらtop_by_value, bottom_by_valueを定義するというのはどうでしょうか。
{% highlight ruby %}
 module Enumerable
   def take_by(nth)
     sort_by { |elem| yield elem }.take(nth)
   end
 end
 
 class Hash
   def top_by_value(nth)
     take_by(nth) { |key, val| -val }
   end
 
   def bottom_by_value(nth)
     take_by(nth) { |key, val| val }
   end
 end
 
 WORDS = ARGF.read.downcase.scan(/[a-z]+/)
 DICTIONARY = WORDS.inject(Hash.new(0)) { |dic, word| dic[word] += 1 ; dic }
 p DICTIONARY.top_by_value(30)
 p DICTIONARY.bottom_by_value(30)
{% endhighlight %}

DICTIONARYに対するメソッド呼び出しがすっきりしました。

繰り返しになりますが、組み込みクラスやモジュールに汎用性のないメソッドを追加することは褒められたことではありません。ここではRubyを学ぶために多少の無茶をしている点、ご了承下さい。

実行結果は次のようになります。
{% highlight ruby %}
#> [["the", 16077], ["of", 9823], ["and", 7482], ["to", 7098], ["in", 4456], ["a", 3841], ["that", 3161], ["was", 3040], ["it", 2919], ["i", 2881], ["her", 2550], ["she", 2313], ["as", 2134], ["you", 2071], ["not", 2057], ["be", 2044], ["is", 2033], ["his", 2009], ["he", 1940], ["for", 1927], ["with", 1875], ["on", 1638], ["had", 1567], ["but", 1519], ["s", 1495], ["all", 1363], ["at", 1344], ["by", 1308], ["this", 1249], ["have", 1201]]
#> [["rained", 1], ["grows", 1], ["pearly", 1], ["hinder", 1], ["overturn", 1], ["interpose", 1], ["infuse", 1], ["prescribes", 1], ["escaping", 1], ["guinness", 1], ["belch", 1], ["humbling", 1], ["appropriately", 1], ["luminous", 1], ["frailty", 1], ["rightful", 1], ["nods", 1], ["purple", 1], ["sepulcher", 1], ["hollow", 1], ["rivaled", 1], ["pearls", 1], ["eyed", 1], ["judaizing", 1], ["fulton", 1], ["taylor", 1], ["coincidence", 1], ["apocalypticae", 1], ["clime", 1], ["atoning", 1]]
{% endhighlight %}

ん～

これじゃbottom_by_valueはあまり意味がありませんね。

 
{% csssig h2 id='version09' class='version' %}
##バージョン09（top_by_valueの改良）
{% endcsssig %}
ブロックを取って範囲を限定できるようにしたら、もう少しマシになるかもしれません。
{% highlight ruby %}
 module Enumerable
   def take_by(nth)
     sort_by { |elem| yield elem }.take(nth)
   end
 end
 
 class Hash
    def top_by_value(nth)
     select { |key, val| yield val }.take_by(nth) { |key, val| -val }
    end
 
    def bottom_by_value(nth)
     select { |key, val| yield val }.take_by(nth) { |key, val| val }
    end
 end
 
 WORDS = ARGF.read.downcase.scan(/[a-z]+/)
 DICTIONARY = WORDS.inject(Hash.new(0)) { |dic, word| dic[word] += 1 ; dic }
 p DICTIONARY.top_by_value(30) { |val| val < 400 }
 p DICTIONARY.bottom_by_value(30) { |val| val > 100 }
{% endhighlight %}

top_by_value, bottom_by_valueではselectメソッドを使って、対象範囲を限定できるようにしました。結果に少し意味がでました。
{% highlight ruby %}
 #> [["know", 386], ["up", 383], ["into", 382], ["its", 380], ["did", 378], ["am", 377], ["than", 377], ["little", 376], ["can", 372], ["may", 370], ["how", 365], ["every", 365], ["only", 361], ["man", 361], ["now", 361], ["first", 358], ["other", 358], ["christ", 358], ["should", 353], ["mrs", 352], ["after", 346], ["again", 346], ["come", 344], ["see", 338], ["some", 338], ["well", 329], ["world", 326], ["bennet", 323], ["prophecy", 322], ["never", 317]]
 #> [["gave", 101], ["forth", 101], ["course", 101], ["thy", 102], ["speak", 102], ["get", 102], ["head", 102], ["home", 103], ["bible", 103], ["pleasure", 103], ["seemed", 104], ["together", 105], ["why", 105], ["high", 106], ["thou", 106], ["myself", 106], ["daniel", 108], ["hand", 109], ["near", 109], ["often", 110], ["better", 110], ["hear", 110], ["left", 110], ["believe", 110], ["moment", 111], ["find", 111], ["half", 113], ["really", 114], ["prophet", 114], ["book", 114]]
{% endhighlight %}

{% csssig h2 id='version10' class='version' %}
##バージョン10（DRY原則）
{% endcsssig %}

なかなかいいですね。さてこれでもう完成でしょうか...

いいえ！問題が発生しました！先のコードはDRY原則に反します！！

「DON'T REPEAT YOURSELF!」

達人プログラマは言いました。

「お前は二人も要らないよ！」

あるいは、

「愚鈍なる君の二度手間はダメ！」

そうです、同じコードの繰り返しは罪なのです！

もう一度コードを見てみましょう。
{% highlight ruby %}
 class Hash
    def top_by_value(nth)
     select { |key, val| yield val }.take_by(nth) { |key, val| -val }
    end
 
    def bottom_by_value(nth)
     select { |key, val| yield val }.take_by(nth) { |key, val| val }
    end
 end
{% endhighlight %}

「-」記号１つの差はありますが...確かに...そっくりです。Yes, I repeat myself...

Hashクラスにtake_by_valueというメソッドを作って、上のコードを1ヶ所に集約します。
{% highlight ruby %}
 class Hash
   def top_by_value(nth, &blk)
     take_by_value(nth, lambda { |v| -v }, &blk)
   end
 
   def bottom_by_value(nth,&blk)
     take_by_value(nth, lambda { |v| v }, &blk)
   end
 
   private
   def take_by_value(nth, sort_opt)
     select { |key, val| yield val }.take_by(nth) { |key, val| sort_opt[val] }
   end
 end
{% endhighlight %}
差し当たりtake_by_valueはクラスの中から呼ぶだけなので、その可視性をprivateにします。

take_by_valueはtop_by_valueおよびbottom_by_valueに渡される引数nthの他、手続きオブジェクトsort_optを引数に取ります。top_by_valueおよびbottom_by_value側では、{|v| -v}または{|v| v}をlambdaでオブジェクト化して渡します。take_by_valueのsort_opt[val]は受け取った手続きオブジェクトを実行します。これはsort_opt.call(val)でもいいです。

またtop_by_valueおよびbottom_by_valueでは、受け取るブロックをtake_by_valueに引き渡すために、&blkでブロックを一旦オブジェクト化する必要があります。

ちょっと込み入った話になりました。関連する話題はここにも書いているので、参考になるかもしれません。

[Rubyのブロックはメソッドに対するメソッドのMix-inだ！](http://melborne.github.io/2008/08/09/Ruby-Mix-in/)

兎に角、これでもう達人は怒らないでしょうか。

あっ！ちょっと問題を発見しました。top_by_valueにブロックを与えないで渡すとエラーがでます。
{% highlight ruby %}
 WORDS = ARGF.read.downcase.scan(/[a-z]+/)
 DICTIONARY = WORDS.inject(Hash.new(0)) { |dic, word| dic[word] += 1; dic }
 p DICTIONARY.top_by_value(30)
{% endhighlight %}
{% highlight ruby %}
 $ ruby topwords.rb 11.txt 1342.txt 18503.txt 
 topwords.rb:109:in `block in take_by_value': no block given (yield)
{% endhighlight %}

ブロックを渡さない場合は、範囲を限定しない結果を返すべきです。

 
{% csssig h2 id='version11' class='version' %}
##バージョン11（block_given?メソッド）
{% endcsssig %}
ブロックがあるか無いかを判定するメソッドとしてblock_given?があります。それを使ってブロックがない場合、代わりのブロックをtake_by_valueに渡してあげます。
{% highlight ruby %}
 class Hash
   def top_by_value(nth, &blk)
     blk = lambda { |v| v } unless block_given?
     take_by_value(nth, lambda { |v| -v }, &blk)
   end
   
   def bottom_by_value(nth, &blk)
     blk = lambda { |v| v } unless block_given?
     take_by_value(nth, lambda { |v| v }, &blk)
   end
   
   private
   def take_by_value(nth, sort_opt)
     select { |key, val| yield val }.take_by(nth) { |key, val| sort_opt[val] }
   end
 end
{% endhighlight %}

上の例ではblock_given?の代わりに引数blkを使ってもいいです。これで問題はなくなりました。

と　こ　ろ　が！

また恐ろしいことが起こりました。Hashクラスを見てください。
{% highlight ruby %}
 class Hash
   def top_by_value(nth, &blk)
     blk = lambda { |v| v } unless block_given?
     take_by_value(nth, lambda { |v| -v }, &blk)
   end
   
   def bottom_by_value(nth,&blk)
     blk = lambda { |v| v } unless block_given?
     take_by_value(nth, lambda { |v| v }, &blk)
   end
   
   private
   def take_by_value(nth, sort_opt)
     select { |key, val| yield val }.take_by(nth) { |key, val| sort_opt[val] }
   end
 end
{% endhighlight %}

lambda {|v| v }が4回も！
Don't Repeat Yourself! Yes, I repeat myself!!

達人...大至急直しますから...

 
{% csssig h2 id='version12' class='version' %}
##バージョン12（DRY再び）
{% endcsssig %}

lambda {|v| v }という手続きを返すoptというメソッドを定義しましょう。
{% highlight ruby %}
 class Hash
   def top_by_value(nth, &blk)
     blk = opt unless blk
     take_by_value(nth, opt(false), &blk)
   end
 
   def bottom_by_value(nth,&blk)
     blk = opt unless blk    
     take_by_value(nth, opt, &blk)
   end
 
   private
   def take_by_value(nth, sort_opt)
     select { |key, val| yield val }
     .take_by(nth) { |key, val| sort_opt[val] }
   end
 
   def opt(flag=true)
     lambda { |v| flag ? v : -v }
   end
 end
{% endhighlight %}

optメソッドのflag引数にデフォルトでtrueをセットしておきます。そうすればvalueがマイナスのときだけfalseを渡せばいいのです。

果たしてこれでコードが読みやすくなったのか、わたしにはわかりません。これはちょっとやり過ぎかもしれませんが、達人に怒られないということがここでは重要なのです。


 
{% csssig h2 id='version13' class='version' %}
##バージョン13（block_given?の移動）
{% endcsssig %}

と...ここまでやってミスに気が付きました。バージョン11のところでblock_given?の判定を、top_by_valueとbottom_by_valueのところでしました。でもこれをtake_by_valueのところでやればいいんです。そうすれば上のような手間は不要です。バージョン12はこんなやり方もあるんだという、ご理解でお願いします...

{% highlight ruby %}
 class Hash
   def top_by_value(nth, &blk)
     take_by_value(nth, lambda { |v| -v }, &blk)
   end

   def bottom_by_value(nth,&blk)
     take_by_value(nth, lambda { |v| v }, &blk)
   end

   private
   def take_by_value(nth, sort_opt)
     select { |key, val| block_given? ? yield(val) : val }
     .take_by(nth) { |key, val| sort_opt[val] }
   end
 end
{% endhighlight %}

take_by_value内で条件演算子(条件 ? 真 : 偽)を使って、ブロックの有無でyieldするかしないか分けています。

（続く）

---

![Alt title]({{ site.url }}/assets/images/2013/04/ruby_tutorial_cover.png)

<a href="http://gum.co/DBgJ" class="gumroad-button">電子書籍「Rubyチュートリアル ～英文小説の最頻出ワードを見つけよう!」EPUB/MOBI版</a><script type="text/javascript" src="https://gumroad.com/js/gumroad-button.js"></script><script type="text/javascript" src="https://gumroad.com/js/gumroad.js"></script>

このリンクはGumroadにおける商品購入リンクになっています。クリックすると、オーバーレイ・ウインドウが立ち上がって、この場でクレジットカード決済による購入が可能です。購入にはクレジット情報およびメールアドレスの入力が必要になります。購入すると、入力したメールアドレスにコンテンツのDLリンクが送られてきます。

---

<p style='color:red'>=== Ruby関連電子書籍100円で好評発売中！ ===</p>

[M'ELBORNE BOOKS]({{ BASE_PATH }}/books/ "M'ELBORNE BOOKS")

<a href="{{ BASE_PATH }}/books/">
  <img src="/assets/images/2012/start_ruby.jpg" alt="start_ruby" style="width:200px" />
</a>
<a href="{{ BASE_PATH }}/books/">
  <img src="/assets/images/2013/02/ruby_object_cover.png" alt="ruby_object" style="width:200px" />
</a>
<a href="{{ BASE_PATH }}/books/">
  <img src="/assets/images/2012/ruby_parallel_cover.png" alt="ruby_parallel" style="width:200px" />
</a>

