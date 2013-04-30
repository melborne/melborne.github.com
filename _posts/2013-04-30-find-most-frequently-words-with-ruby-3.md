---
layout: post
title: "Rubyチュートリアル ─ 英文小説の最頻出ワードを見つけよう! ─（その３）"
description: ""
category: 
tags: 
date: 2013-04-30
published: true
---
{% include JB/setup %}

この記事は、─	[電子書籍「Rubyチュートリアル ～英文小説の最頻出ワードを見つけよう!」EPUB/MOBI版](http://melborne.github.io/books/20130426ruby_tutorial.html "Rubyチュートリアル ～英文小説の最頻出ワードを見つけよう!")─の公開第３弾です（[第１弾はこちら](http://melborne.github.io/2013/04/26/find-most-frequently-words-with-ruby/ "Rubyチュートリアル ─ 英文小説の最頻出ワードを見つけよう! ─")）。本書第２章のバージョン14〜21の範囲を掲載しています。	

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

{% csssig h2 id='version14' class='version' %}
##バージョン14（ARGF.take_wordsの定義）
{% endcsssig %}
さてもう改良点はないでしょうか。スクリプト全体をもう一度みてみましょう。

{% highlight ruby %}
 module Enumerable
   def take_by(nth)
     sort_by { |elem| yield elem }.take(nth)
   end
 end
 
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
 
 WORDS = ARGF.read.downcase.scan(/[a-z]+/)
 DICTIONARY = WORDS.inject(Hash.new(0)) { |dic, word| dic[word] += 1; dic }
 p DICTIONARY.top_by_value(30)
{% endhighlight %}

3行目が思いの外すっきりしたので、1行目のメソッドチェーンが気になりだしました。ちょっと病的な感覚かもしれません。でも楽しいRubyの学習のために先に進みます。

「添付ファイルから単語を取って配列に入れる」という操作は汎用性がありそうです。今度はこれをいじりましょう。ARGFに対するtake_wordsメソッドを定義します。

オブジェクトに対するメソッドの追加は、今まで見てきたようにそのオブジェクトが属するクラスにメソッドを定義することで実現するのが普通です。しかしここではARGFオブジェクトに直接メソッドを追加してみたいと思います。


これはそのオブジェクト専用の名無しクラスにメソッドを定義することで実現できます。
{% highlight ruby %}
 class << ARGF
   def take_words(regexp)
     read.downcase.scan(regexp)
   end
 end
 
 WORDS = ARGF.take_words(/[a-z]+/)
 DICTIONARY = WORDS.inject(Hash.new(0)) { |dic, word| dic[word] += 1; dic }
 p DICTIONARY.top_by_value(30)
{% endhighlight %}

この場合クラスに名前を与えずに、オブジェクトを<<で接ぎ木します。この無名クラスはSingletonクラスまたは特異クラスなどと呼ばれます。

クラスを定義しない別の書き方もあります。
{% highlight ruby %}
 def ARGF.take_words(regexp)
   read.downcase.scan(regexp)
 end
{% endhighlight %}
こう書いたときSingletonメソッドまたは特異メソッドなどと呼ばれます。

take_wordsには正規表現を渡せるようにしてます。先頭がx,y,zで始まる単語のみを対象に最頻出ワード30をリストしてみましょう。
{% highlight ruby %}
 WORDS = ARGF.take_words(/[xyz][a-z]+/)
 DICTIONARY = WORDS.inject(Hash.new(0)) { |dic, word| dic[word] += 1; dic }
 p DICTIONARY.top_by_value(30)
 
 #> [["you", 2071], ["zabeth", 636], ["your", 597], ["ys", 556], ["ying", 322], ["years", 226], ["yes", 214], ["ything", 176], ["ydia", 172], ["yet", 163], ["young", 144], ["xt", 143], ["ye", 137], ["year", 124], ["yself", 108], ["zzy", 97], ["yed", 82], ["ybody", 77], ["ylon", 75], ["zed", 67], ["ze", 64], ["yourself", 60], ["xpected", 58], ["yton", 58], ["yphon", 55], ["xactly", 54], ["yond", 54], ["xed", 52], ["yright", 48], ["yone", 45]]
{% endhighlight %}

Singletonメソッドについては以下が参考になるかもしれません。

[Rubyを始めたけど今ひとつRubyのオブジェクト指向というものが掴めないという人、ここに来て見て触って！](http://melborne.github.io/2013/02/07/understand-ruby-object/ "Rubyを始めたけど今ひとつRubyのオブジェクト指向というものが掴めないという人、ここに来て見て触って！")

 
{% csssig h2 id='version15' class='version' %}
##バージョン15（make_freq_dicの定義）
{% endcsssig %}

ここまで来るともう止まりません。はっきり言って2行目も気になります。
{% highlight ruby %}
 DICTIONARY = WORDS.inject(Hash.new(0)) { |dic, word| dic[word] += 1; dic }
{% endhighlight %}

しかも頻出ワード辞書というのは汎用性がありそうです。make_freq_dicメソッドとしてArrayに定義しましょう。ええこれは明らかに行き過ぎです（いや、もうとっくに行き過ぎです..）。Arrayに定義されるべきメソッドは、あらゆる種類の配列で使われうるメソッドのみを定義すべきです。でも、もうわたしにも止められないのです！
{% highlight ruby %}
 class Array
   def make_freq_dic
     inject(Hash.new(0)) { |dic, word| dic[word] += 1; dic }
   end
 end
 
 WORDS = ARGF.take_words(/[a-z]+/)
 DICTIONARY = WORDS.make_freq_dic
 p DICTIONARY.top_by_value(30)
{% endhighlight %}

すっきりです。ARGFから単語を取り出しWORDSで参照する、WORDSから頻出ワードを作ってDICTIONARYで参照する、DICTIONARYから頻出トップ30を取って出力する、１つのオブジェクトに１つのメソッド。さすがにもう気が済みました。わたしの暴走を許してくださりありがとうございます。

{% csssig h2 id='version16' class='version' %}
##バージョン16（スクリプトのクラス化）
{% endcsssig %}
でも待ってください。そこまで汎用性がある汎用性があるって言うのなら...

クラスにでもしたらどうですか？

それならArrayクラスなどの組み込みクラスにも迷惑は掛かりませんし、なるほどいい考えかもしれません。

では、テキストファイルを受け取ると、英単語頻度辞書を生成するWordDictionaryクラスを作りましょう。まず現在のスクリプト全体を掲載します。
{% highlight ruby %}
 module Enumerable
   def take_by(nth)
     sort_by { |elem| yield elem }.take(nth)
   end
 end
 
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
 
 class << ARGF
   def take_words(regexp)
     read.downcase.scan(regexp)
   end
 end
 
 class Array
   def make_freq_dic
     inject(Hash.new(0)) { |dic, word| dic[word] += 1; dic }
   end
 end
 
 WORDS = ARGF.take_words(/[a-z]+/)
 DICTIONARY = WORDS.make_freq_dic
 p DICTIONARY.top_by_value(30)
{% endhighlight %}

これらのコードにおける各メソッドをWordDictionaryクラスに実装します。このクラスはARGFオブジェクトを引数に取って、そこからワード辞書オブジェクトを生成します。Enumerableのtake_byはWordDictionary以外でも使えそうなのでこのまま残します。

上のスクリプトは次のように生まれ変わりました。
{% highlight ruby %}
 module Enumerable
   def take_by(nth)
     sort_by { |elem| yield elem }.take(nth)
   end
 end
 
 class WordDictionary
   include Enumerable
 
   def initialize(argf)
     @words = argf.read.downcase.scan(/[a-z]+/)
     @freq_dic = @words.inject(Hash.new(0)) { |dic, word| dic[word] += 1; dic }
   end
 
   def each
     @freq_dic.each { |elem| yield elem }
   end
 
   def top_by_frequency(nth, &blk)
     take_by_value(nth, lambda { |v| -v }, &blk)
   end
 
   def bottom_by_frequency(nth, &blk)
     take_by_value(nth, lambda { |v| v }, &blk)
   end
 
   private
   def take_by_value(nth, sort_opt)
     @freq_dic.select { |key, val| block_given? ? yield(val) : val }
              .take_by(nth) { |key, val| sort_opt[val] }
   end
 end
 
 wdic = WordDictionary.new(ARGF)
 p wdic.top_by_frequency(30)
 p wdic.bottom_by_frequency(30) { |val| val > 100 }
{% endhighlight %}

ざっと眺めてみると先のコードが大体そのまま移管されているのが分かると思います。top_by_valueとbottom_by_valueは、目的を分かりやすくするために名前をそれぞれ、top_by_frequencyとbottom_by_frequencyに変えました。
 
変わったところを列挙してみます。

1. WordDictionaryクラス
1. include Enumerable
1. initializeメソッド
1. eachメソッド
 
クラス定義はキーワードclassに続き、大文字で始まるクラス名を指定して行います。スクリプトが実行されたとき、このクラス定義からそのクラス名で参照可能なクラスオブジェクトが生成されます。

include EnumerableによってEnumerableモジュールに追加したtake_byメソッドが使えるようになります。

initializeメソッドは、WordDictionaryクラスを生成するnewメソッドが呼ばれたときに自動で実行されるメソッドです。通常ここにオブジェクトの初期化処理を書きます。

WordDictionaryでは単語を切り出してその結果の配列を@wordsというインスタンス変数で参照できるようにします。次いで頻出ワード辞書を作り出しその結果のハッシュを、@freq_dicインスタンス変数で参照できるようにしています。

eachメソッドにはちょっとしたマジックがあります。Enumerableモジュールには繰り返し処理のための便利なメソッドが多数存在しますが、eachメソッドをうまく定義すればWordDictionaryで生成されるオブジェクトでも、これらの便利なメソッドが使えるようになるのです。例をあとで示します。

スクリプトの最後の3行でこのWordDictionaryクラスの使い方が分かると思います。

ARGFを引数に取ったnewメソッドをWordDictionaryクラスに送り、これによって単語辞書オブジェクトを生成します。

「newメソッドなんて定義してないのに何故呼べるの？」と考えた人は鋭いです。理由はこうです。

すべてのクラスは何らかのクラスの継承クラスです。明示的に継承元クラスを指定する場合はclass WordDictionary < Hash のようにします。明示的な指定がない場合Rubyは自動でObjectクラスをその継承元クラスとして指定します。ですからWordDictionaryクラスはObjectクラスの被継承者です。そして被継承者は継承元のメソッドすべてを自由に使えるのです。

さて、eachメソッドのマジックを１つ見せます。
{% highlight ruby %}
 wdic = WordDictionary.new(ARGF)
 wdic.group_by { |word, freq| word.length }
     .select { |len, word| len > 14 }
     .sort
     .each { |len, word| print "#{len} => #{word.transpose.first}\n"}

 #> 15 => ["representations", "merchantibility", "accomplishments", "acknowledgments", "inconsistencies", "conscientiously", "superintendence", "congratulations", "thoughtlessness", "recommendations", "uncompanionable", "disappointments", "condescendingly", "transformations", "transfiguration", "ecclesiasticism", "notwithstanding", "representatives", "appropriateness", "characteristics", "contemporaneous", "unrighteousness", "remorselessness", "comprehensively"]
 #> 16 => ["unenforceability", "superciliousness", "incomprehensible", "discontentedness", "inextinguishable", "internationalism"]
 #> 17 => ["disinterestedness", "misrepresentation", "communicativeness", "congregationalist", "indestructibility"]
{% endhighlight %}

Enumerableモジュールに定義されているgroup_byメソッドを、WordDictionaryクラスのオブジェクトで使った例です。ワード長が15以上のものをグループ別に表示させています。自作のクラスがこれでずっと高級になりました。Enumerableモジュールが持っているメソッドは以下で調べられます。

[module Enumerable](http://doc.ruby-lang.org/ja/1.9.3/class/Enumerable.html "module Enumerable")

{% csssig h2 id='version17' class='version' %}
##バージョン17（top_by_lengthの定義）
{% endcsssig %}
次にバージョン07で示したような、最長ワードトップ30を出力するメソッドtop_by_lengthも定義しましょう。
{% highlight ruby %}
 class WordDictionary
   def top_by_length(nth, &blk)
     list = take_by_key(nth, lambda { |key| -key.length }, &blk)
     list.map { |word, freq| [word, freq, word.length] }
   end
 
   private
   def take_by_value(nth, sort_opt)
     @freq_dic.select { |key, val| block_given? ? yield(val) : val }.take_by(nth) { |key, val| sort_opt[val] }
   end
 
   def take_by_key(nth, sort_opt)
     @freq_dic.select { |key, val| block_given? ? yield(val) : val }.take_by(nth) { |key, val| sort_opt[key] }
   end
 end
 wdic = WordDictionary.new(ARGF)
 p wdic.top_by_length(30) { |val| val > 100 }
{% endhighlight %}

ここでは将来に備えて、take_by_valueと同じようにtake_by_keyを定義して、top_by_lengthはこれを使うようにします。

top_by_lengthはその語と出現数に加えて、語長を返すようにしています。Arrayクラスのmapメソッドをここでは使っています。mapメソッドはinjectメソッド同様とても便利なメソッドです。配列の各要素の内容をブロックの処理結果で置き換えます。上の例は list.map { |item| item << item[0].length } でもいいです。

出力はこんな感じです。
{% highlight ruby %}
#> [["illustration", 160, 12], ["therefore", 127, 9], ["catherine", 126, 9], ["jerusalem", 120, 9], ["gutenberg", 285, 9], ["elizabeth", 636, 9], ["prophecy", 322, 8], ["together", 105, 8], ["anything", 117, 8], ["pleasure", 103, 8], ["judgment", 134, 8], ["believe", 110, 7], ["collins", 180, 7], ["between", 114, 7], ["wickham", 194, 7], ["bingley", 306, 7], ["replied", 136, 7], ["history", 189, 7], ["himself", 178, 7], ["against", 164, 7], ["because", 116, 7], ["however", 179, 7], ["through", 185, 7], ["nothing", 235, 7], ["sabbath", 215, 7], ["herself", 312, 7], ["another", 144, 7], ["project", 262, 7], ["without", 263, 7], ["thought", 215, 7]]
{% endhighlight %}

 
{% csssig h2 id='version18' class='version' %}
##バージョン18（DRY三度）
{% endcsssig %}
またも問題発生！DRY違反です！
{% highlight ruby %}
   def take_by_value(nth, sort_opt)
     @freq_dic.select { |key, val| block_given? ? yield(val) : val }.take_by(nth) { |key, val| sort_opt[val] }
   end
 
   def take_by_key(nth, sort_opt)
     @freq_dic.select { |key, val| block_given? ? yield(val) : val }.take_by(nth) { |key, val| sort_opt[key] }
   end
{% endhighlight %}

take_by_key_or_valメソッドを定義して、これを回避します。
{% highlight ruby %}
   def take_by_value(nth, sort_opt, &blk)
     val = lambda { |key, val| val }
     take_by_key_or_val(nth, sort_opt, val, &blk)
   end
 
   def take_by_key(nth, sort_opt, &blk)
     key = lambda { |key, val| key }
     take_by_key_or_val(nth, sort_opt, key, &blk)
   end
 
   def take_by_key_or_val(nth, sort_opt, by)
     @freq_dic.select { |key, val| block_given? ? yield(val) : val }.take_by(nth) { |key, val| sort_opt[by[key, val]] }
   end
{% endhighlight %}
ふぅ

 
{% csssig h2 id='version19' class='version' %}
##バージョン19（入力の拡張）
{% endcsssig %}
さて次は何ですか？そうですね...

せっかくクラスを作ったのに、コマンド引数しか取れないっていうのは寂しいです。では次はWordDictionaryクラスがファイル名か文字列を直接受け取れるようにしましょう。

そのためにinput_to_stringメソッドを定義し、initializeメソッドで入力を適切に変換するようにします。
{% highlight ruby %}
 class WordDictionary
   def initialize(input)
     input = input_to_string(input)
     @words = input.downcase.scan(/[a-z]+/)
     @freq_dic = @words.inject(Hash.new(0)) { |dic, word| dic[word] += 1 ; dic }
   end
   
   private
   def input_to_string(input)
    case input
    when String
      begin
        File.open(input, "r:utf-8") { |f| return f.read }
      rescue
        puts "Argument has assumed as a text string" 
        input
      end
    when ARGF.class
      input.read
    else
      raise "Wrong argument. ARGF, file or string are acceptable."
    end
   end
 end
 wdic1 = WordDictionary.new(ARGF)
 wdic2 = WordDictionary.new('11.txt')
 wdic3 = WordDictionary.new(<<-EOS)
 It was all very well to say 'Drink me,' but the wise little Alice was not going to do THAT in a hurry. 'No, I'll look first,' she said, 'and see whether it's marked "poison" or not'; for she had read several nice little histories about children who had got burnt, and eaten up by wild beasts and other unpleasant things, all because they WOULD not remember
 the simple rules their friends had taught them: such as, that a red-hot poker will burn you if you hold it too long; and that if you cut your finger VERY deeply with a knife, it usually bleeds; and she had never forgotten that, if you drink much from a bottle marked 'poison,' it is almost certain to disagree with you, sooner or later.
EOS
 p wdic1.top_by_frequency(10)
 p wdic2.top_by_frequency(10)
 p wdic3.top_by_frequency(10)
 
 #> [["the", 4507], ["to", 4243], ["of", 3728], ["and", 3658], ["her", 2225], ["i", 2069], ["a", 2012], ["in", 1936], ["was", 1848], ["she", 1710]]
 #> [["the", 1818], ["and", 940], ["to", 809], ["a", 690], ["of", 631], ["it", 610], ["she", 553], ["i", 545], ["you", 481], ["said", 462]]
 #> [["it", 5], ["you", 5], ["and", 5], ["that", 4], ["had", 4], ["a", 4], ["if", 3], ["she", 3], ["to", 3], ["not", 3]]
{% endhighlight %}

input_to_stringにおいて、case式を使って入力の種類を切り分けました。when Stringでは最初ファイル名として処理できるか試み、できない場合は文字列として処理できるようにしました。うまくいっているようです。

WordDictionary.new(<<-EOS)...は、ヒアドキュメントという記法を使っています。任意記号EOSで挟まれた行が文字列として解釈されます。

{% csssig h2 id='version20' class='version' %}
##バージョン20（ネットアクセス）
{% endcsssig %}
ここまで来たらもう一歩。

小説データは元々ネットにあるんですから、いちいちファイルにダウンロードしないで、直接ネットから取れたらうれしいです。

open-uriライブラリというのを使うと、httpに簡単にアクセスできるようになります。
{% highlight ruby %}
  require "open-uri"
  class WordDictionary
	private
    def input_to_string(input)
     case input
     when /^http/
       begin
         open(input) { |f| return f.read }
       rescue Exception => e
         puts e
         exit
       end
     when String
       begin
         File.open(input, "r:utf-8") { |f| return f.read }
       rescue
         puts "Argument has assumed as a text string" 
         input
       end
     when ARGF.class
       input.read
     else
       raise "Wrong argument. ARGF, file or string are acceptable."
     end
    end
  end
  wdic = WordDictionary.new('http://www.gutenberg.org/files/245/245.txt')
  p wdic.top_by_length(30)
#> [["inconsequentialities", 1, 20], ["straightforwardly", 1, 17], ["unenforceability", 1, 16], ["acquaintanceship", 3, 16], ["reproachlessness", 1, 16], ["misunderstanding", 1, 16], ["stenographically", 1, 16], ["preposterousness", 1, 16], ["responsibilities", 1, 16], ["incomprehensible", 1, 16], ["charlottesville", 1, 15], ["acknowledgments", 1, 15], ["unrighteousness", 2, 15], ["multitudinously", 1, 15], ["unphilosophical", 1, 15], ["impossibilities", 2, 15], ["inconspicuously", 1, 15], ["inconsequential", 2, 15], ["conscientiously", 1, 15], ["notwithstanding", 3, 15], ["merchantibility", 1, 15], ["architecturally", 2, 15], ["daguerreotypist", 1, 15], ["representations", 1, 15], ["unhandkerchiefs", 1, 15], ["correspondingly", 3, 15], ["picturesqueness", 2, 15], ["proportionately", 1, 15], ["unconsciousness", 1, 15], ["exemplification", 1, 15]]
{% endhighlight %}

open-uriライブラリをrequireして、input_to_stringに新しい分岐条件を加えます。ネットアクセスがうまくいかない場合は、エラーメッセージを表示してスクリプトの実行を終了します。

これで一層便利になりました。

 
{% csssig h2 id='version21' class='version' %}
##バージョン21（メソッドの追加）
{% endcsssig %}
もう少し実用的なメソッドも追加しましょう。

オブジェクトを読みやすいかたちで出力するto_sメソッドと、オブジェクトの部分オブジェクトを返すselectメソッドを定義します。
{% highlight ruby %}
 class WordDictionary
   def to_s
     @freq_dic.to_s
   end
   def select(regexp)
     text = @words.select { |key, val| key =~ regexp }.join(" ")
     WordDictionary.new(text)
   end
 end
{% endhighlight %}

次の例はselectメソッドにより、先頭がxyzの何れかで始まる語の集合からなる新しいWordDictionaryオブジェクトを生成し、これをto_sメソッドで出力しています。
{% highlight ruby %}
 wdic = WordDictionary.new(ARGF)
 puts xyz_dic = wdic.select(/^[xyz]/)
 p xyz_dic.top_by_length(5)
#> {"you"=>2071, "yes"=>90, "zealand"=>1, "your"=>597, "yourself"=>60, "yesterday"=>18, "yet"=>163, "young"=>144, "yer"=>4, "ye"=>90, "yelp"=>1, "youth"=>17, "yawned"=>3, "zigzag"=>1, "yours"=>26, "yards"=>2, "year"=>124, "yawning"=>3, "x"=>2, "yelled"=>1, "xi"=>1, "xii"=>3, "yard"=>1, "years"=>226, "zip"=>3, "youngest"=>15, "younger"=>30, "yielding"=>4, "yield"=>8, "yawn"=>2, "york"=>13, "yourselves"=>5, "younge"=>4, "youths"=>1, "yielded"=>5, "yale"=>4, "zeph"=>3, "zephaniah"=>1, "zech"=>2, "zion"=>4, "zealots"=>3, "zinzendorf"=>6, "xxxiii"=>1, "xxv"=>3, "xxvi"=>1, "y"=>8, "zama"=>1, "zealous"=>2, "xiii"=>8, "yea"=>6, "zinzendorfs"=>1, "xenophon"=>3, "youthful"=>1, "yearly"=>2, "xxix"=>1, "xh"=>1, "zoroaster"=>2, "xciii"=>1, "zeal"=>2, "zambezi"=>1, "xerxes"=>11, "xv"=>1, "yellow"=>1, "xxiii"=>1}

#> [["zinzendorfs", 1, 11], ["zinzendorf", 6, 10], ["yourselves", 5, 10], ["zoroaster", 2, 9], ["zephaniah", 1, 9]]
{% endhighlight %}

++++++++++++++++++++++++++++++++++++++++++++++

さてずいぶんと長い道のりを来ました。スクリプトは一時僅か3行にまで短くできたのに、現在80行を超えるまでに肥大化しました。ワードエコではありません。

ここで最初のコードと3行のコードと、現在のコードとを見比べてみましょうか。

（バージョン01）
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

（バージョン03）
{% highlight ruby %}
 WORDS = ARGF.read.downcase.scan(/[a-z]+/)
 DICTIONARY = WORDS.inject(Hash.new(0)) { |dic, word| dic[word] += 1 ; dic }
 p DICTIONARY.sort { |a, b| b[1] <=> a[1] }[0...30]
{% endhighlight %}

（バージョン21）
{% highlight ruby %}
 require 'open-uri'
 module Enumerable
   def take_by(nth)
     sort_by { |elem| yield elem }.take(nth)
   end
 end
 
 class WordDictionary
   include Enumerable
 
   def initialize(input)
     input = input_to_string(input)
     @words = input.downcase.scan(/[a-z]+/)
     @freq_dic = @words.inject(Hash.new(0)) { |dic, word| dic[word] += 1 ; dic }
   end
 
   def each
     @freq_dic.each { |elem| yield elem }
   end
 
   def top_by_frequency(nth, &blk)
     take_by_value(nth, lambda { |v| -v }, &blk)
   end
 
   def bottom_by_frequency(nth, &blk)
     take_by_value(nth, lambda { |v| v }, &blk)
   end
 
   def top_by_length(nth, &blk)
     list = take_by_key(nth, lambda { |key| -key.length }, &blk)
     list.map { |word, freq| [word, freq, word.length] }
   end
 
   def to_s
     @freq_dic.to_s
   end
 
   def select(regexp)
     text = @words.select { |key, val| key =~ regexp }.join(" ")
     WordDictionary.new(text)
   end
 
   private
  def input_to_string(input)
   case input
   when /^http/
     begin
       open(input) { |f| return f.read }
     rescue Exception => e
       puts e
       exit
     end
   when String
     begin
       File.open(input, "r:utf-8") { |f| return f.read }
     rescue
       puts "Argument has assumed as a text string." 
       input
     end
   when ARGF.class
     input.read
   else
     raise "Wrong argument. ARGF, file or string are acceptable."
   end
  end
 
   def take_by_value(nth, sort_opt, &blk)
     val = lambda { |key, val| val }
     take_by_key_or_val(nth, sort_opt, val, &blk)
   end
 
   def take_by_key(nth, sort_opt, &blk)
     key = lambda { |key, val| key }
     take_by_key_or_val(nth, sort_opt, key, &blk)
   end
 
   def take_by_key_or_val(nth, sort_opt, by)
     @freq_dic.select { |key, val| block_given? ? yield(val) : val }.take_by(nth) { |key, val| sort_opt[by[key, val]] }
   end
 end
 wdic = WordDictionary.new(ARGF)
 p wdic.top_by_frequency(20)
{% endhighlight %}

確かにスクリプトは肥大化しています。果たして今までの労力は無駄だったんでしょうか。ワードエコでなくなった分、よくなったことがあるんでしょうか。

はい、あります。それは単語辞書が、単なる制御構造からオブジェクトになったことです。

オブジェクトになった利点の１つは、コードがポータブルになるということです。つまりそれが持つデータを維持しながら、他のオブジェクトに送って相互作用させたり、データベースに保存したりできます。同時に内容の異なる複数の辞書オブジェクトを生成し、これらを相互に連携して結果を得る(内容の比較とか)といったこともできるようになります。これらはネットワーク越しであってもかまいません。

他の利点は機能の追加が容易になる点です。クラスにメソッドを追加することで、単語辞書を対象にした新たな機能が容易に追加できます。既にいくつかの機能追加を見てきました。

最初のヴァージョンのスクリプトに機能を追加することを想像頂ければ、この利点は明らかでしょう。このようにオブジェクトは機能追加のフレームワークになっているのです。

今までの苦労も、未来に対する投資というかたちで報われそうです。そろそろ幕を閉じるときが来たようです。

（続く）

---

![Alt title]({{ BASE_PATH }}/assets/images/2013/04/ruby_tutorial_cover.png)

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

