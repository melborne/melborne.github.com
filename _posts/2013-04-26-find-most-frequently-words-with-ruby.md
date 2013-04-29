---
layout: post
title: "Rubyチュートリアル ─ 英文小説の最頻出ワードを見つけよう! ─"
description: ""
category: 
tags: 
date: 2013-04-26
published: true
---
{% include JB/setup %}

４年ほど前にプログラミング初学者だった僕が、無謀にも全17回に渡るRubyの初学者向けチュートリアル記事を書いたことがありました。この記事は当然に難産でしたが（まあ、いつもそうですが...）、記事を書くことを通して僕はRubyについて多くのことを学びました。今この記事を読み返すと、当時の自分の実力以上にがんばって書いているなという印象と共に、その頃からあまり成長していない今の自分に気付かされるのでした。

記事はちょっとユニークな小説風仕立ての序章から始まり、Rubyの特徴を数回を使って簡単に説明して、残りの章で英文小説から最頻出ワードを抽出し出力するチュートリアルを延々と続けていくという構成のものでした。ご存知かも知れませんが、Rubyで最頻出ワードを抽出するコードを書くのは造作ありません。しかしこのチュートリアルでは、最初にできたコードを壊し、これでもかこれでもか、というくらいに改良、時には改悪を加え続けていきます。そして最後には小説のユニークワードを抽出するクラスにまで辿り着くのですが、結果として、Rubyエキスパートの人がちょっと眉をひそめるような、危なげな過程を通してRubyの使い方を学ぶという変わった試みになっています。

それで今回、また無謀にもこれを電子書籍化して販売するということに相成りましたので、ここにお知らせ致します。Rubyを始めたけれども、なんかその良さがわからない、あるいは楽しく学べる書籍が見当たらないから学習が進まないなどの方がおられましたら、是非ともご購入検討頂けたら嬉しく思いますm(__)m

書籍化に際し、全体を見直し誤記の訂正、説明の補足、コードの修正を行いましたが、基本的な構成・内容については4年前に書いたものそのままです。電子書籍は、いつものようにGumroadを通して販売し、EPUB形式に加えkindleで扱えるMOBI形式を同梱しています。価格は100円です。


[M'ELBORNE BOOKS](http://melborne.github.io/books/ "M'ELBORNE BOOKS")

書籍化にあたって修正した内容のものを、あらためてこのブログに数回に分けて掲載します。今回は１章の終わりまでです。

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

+++++++++++++++++++++++++++++++++++++++++++++

#序章

─2023年─


インターネットにおけるワード枯渇問題が深刻化している。この10年で紙ベースのドキュメントから、ビットドキュメントへの移行が急速に進行し、現在では新刊書籍の90%は書店に置かれることなく、ネット上の大規模ストレージに直接格納されるようになった。人々の「本を読む」という習慣は、ネットインタフェースとしてのモバイルディスプレイに対峙するものに完全に置き換えられた。

そこで10年前には誰も想像しえなかった新たな問題が浮上してきた。それは、当初懸念されていたIPアドレスやストレージの枯渇問題ではなかった。

それはワード、とりわけ「**ASCIIワード**」の枯渇問題であった。

米国資源エネルギー庁主任研究員ドレス・コード博士の研究によれば、ネット上の特定英単語(以下ワードという)の出現数が10の68乗を超えると、ネット接続ストレージ上の対象ワードが消失するということが判明し、現在の指数関数的なワード伸長率を勘案すれば、5年後の2028年に最頻出の10ワードが消失し、7年後の2030年には100ワード、10年後の2033年には1000ワードが消失すると予言されている。

主要国政府による連携した対応により本年2月に、スウェーデン国ルンド([Lund](http://www.lund.se/default____141.aspx))にて、ワード枯渇問題に関する国際条約 ─ルンド条約─が制定され、主要20カ国はこれを直ちに批准した。本条約発効に伴い条約加盟各国には、国民による主要ワード30語の使用頻度を年内に30%以上削減することが課せられたことになる。各国政府は現在この問題の対応に追われている...

++++++++++++++++++++++++++++++++++++++++++

この影響は、世界小説家協会日本支部情報処理課に新人プログラマとして入社・配属されたあなたにも及んでいる。早々同課課長安藤はこの問題に対応するプロジェクトを発足し、あなたに以下の指令を出した。

「本日10時までに英文小説の最頻出ワードトップ30を特定せよ！」

そして、その結果をもって協会加盟の小説家たちにそれらのワードの使用を制限する通達を即時出せ、という。

あなたに与えられた時間は2時間しかない。しかも、あなたは初級プログラマである。

逡巡する気持ちを抱えながら席に戻ろうとするあなたの背中越しに、上司は一言付け加えた。

「無駄にワードは使うなよ。」

そんなこと分かっています。ワードエコのこの時代...

さてどうしようか。自分一人ではできそうにない。

誰かの助けが必要だ...

++++++++++++++++++++++++++++++++++++++++++

席に戻ると直ちにネットを検索し助けを求めた。

検索結果の一覧の中に『**Rubyチュートリアル ～英文小説の最頻出ワードを見つけよう！**』というタイトルのブログ投稿を見つけた。救われたか...

しかしRubyのことはよく知らない。でも、まずはこれを読んで見ようか...

<br />

<br />
<br />

---

# Rubyチュートリアル ～英文小説の最頻出ワードを見つけよう！

<br />

# １章　Rubyの特徴
忙しい読者の皆様が求めているものは、表題「英文小説の最頻出ワードを見つけよう！」に対するRubyのサンプルプログラムであることは熟知しています。しかしそれを速やかに理解するためには、Rubyに関する前提知識が必要です。少し時間をいただいて、最初にRubyの特徴的な事柄について説明させてください。

なおRubyは1993年に日本で生まれてから、複数回のヴァージョンアップを繰り返し、現在もなお進化の過程にあります。現行安定ヴァージョンはRuby4.8.10ですが、以下で説明する内容はレガシーヴァージョンでも動作します。またJRuby, PRuby, MRuby, SRubyあるいはLittleRuby, MicroRuby, uby, byでも動作するでしょう。ただ, Cuby, roobee, RubybuR, λRuby, ComeOn!RubyおよびLavieRubis, Ruby&#54861;（rubyインタプリタのハングルによる実装）, Rubykak&#257;（rubyインタプリタのマオリ語による実装）では動作しないでしょう（これらは2023年の未来予想を元に書かれています。^ ^;

さあ説明を始めましょう。

これから説明するのは次の4つの項目です

1. Rubyはオブジェクト指向です
1. Rubyのブロックは仮装オブジェクトです
1. クラスはオブジェクトの母であってクラスの子であるオブジェクトです
1. Rubyはユーザフレンドリです


{% csssig h2 id='ruby_object' %}
## Rubyはオブジェクト指向です
{% endcsssig %}

依然として現在主流のプログラミング言語は手続き型です。手続き型言語では手続きは関数などのかたちでモジュール化されていますが、データ構造はそれとは別に管理されています。

でもRubyではデータ構造も手続きと一緒にパッケージ化されており、それはオブジェクトと呼ばれています。つまりRubyではプログラムを組成する最小単位はオブジェクトです。そのためRubyプログラマのやるべきことは、「メモリ空間に必要なオブジェクトを生成し、それにメッセージを送ってその結果としてのオブジェクトを得る」というかたちでプログラムを組成することになります。

例えば、次の例はメモリ空間に文字列オブジェクトを生成し、それにlengthというメッセージを送っています。
{% highlight ruby %}
 'hippopotamus'.length # => 12
{% endhighlight %}
文字列をクォートすれば文字列オブジェクトが生成されます。生成された文字列オブジェクト'hippopotamus'は、内部に多数のメソッドを持っており、lengthメッセージが送られるとこれに対応するメソッドを検索し、あればそれを起動し結果を返します。

通常反応するメソッドは、送られるメッセージ名と同じ名前を持っています。ですからこれからはメッセージとメソッドを区別しないで用います。メッセージを受けるオブジェクトのことを、レシーバと言うことがあります。

注目して頂きたいのは、オブジェクトがメッセージを受けて返す値は、オブジェクトであるということです。つまり上で返された整数12は単なる整数ではなく、整数オブジェクト（正確には固定長整数オブジェクト）なのです。従ってこの返された値もメッセージを受け取ることができます。ですからRubyではこんな記述が許されます。
{% highlight ruby %}
 'hippopotamus'.length.even? # => true
{% endhighlight %}
これはメソッドチェーンと呼ばれることがあります。

別の例を示します。
{% highlight ruby %}
 ['donkey', 'alligator', 'hippopotamus'].at(0) # => "donkey"
{% endhighlight %}
これはメモリ空間に3つの文字列オブジェクトを要素として含んだ、１つの配列オブジェクトを生成し、それにatメソッドを0整数オブジェクトを引数に付けて送っているコードです。任意のオブジェクトを\[ \]で括ると配列オブジェクトが生成されます

このようにメッセージには引数を付けることができます。ただしRubyはオブジェクトしか相手にしませんから、この引数はオブジェクトでなければなりません。返される結果は配列の先頭要素の'donkey'文字列オブジェクトです。確認のためこの結果にもメソッドチェーンを試みてみましょう。
{% highlight ruby %}
 ['donkey', 'alligator', 'hippopotamus'].at(0) # => "donkey"
 ['donkey', 'alligator', 'hippopotamus'].at(0).length # => 6
 ['donkey', 'alligator', 'hippopotamus'].at(0).length.even? # => true
{% endhighlight %}

メソッドチェーンの個数に制限はありません。暇つぶしをしたいのなら次のようにしてもかまいません。
{% highlight bash %}
 1.next.next.next.next.next.next.next.next.next \
  .next.next.next.next.next.next.next.next.next \
  .next.next.next.next.next.next.next.next.next \
  .next.next.next.next.next.next.next.next.next \
  .next.next.next.next.next.next.next.next.next \
  .next.next.next.next.next.next.next.next.next \
  .next.next.next.next.next.next.next.next.next \
  .next.next.next.next.next.next.next.next.next \
  .next.next.next.next.next.next.next.next.next \
  .next.next.next.next.next.next.next.next.next \
  .next.next.next.next.next.next.next.next.next # => 100
{% endhighlight %}

{% csssig h2 id='ruby_block' %}
##Rubyのブロックは仮装オブジェクトです
{% endcsssig %}

次にRubyのブロックを説明します。

手続き型言語同様、Rubyもifやwhileなどの制御構造をサポートしており、メソッド定義式の中でこれらを使うことができます（メソッド定義の外でも使えます）。
{% highlight ruby %}
 def hello(name)
   if name.length > 10
     name.squeeze!
   else
     name += name.reverse
   end
   "Hello, #{name}."
 end
 
 hello('mississippi-hippopotamus') # => "Hello, misisipi-hipopotamus."
 hello('donkey') # => "Hello, donkeyyeknod."
{% endhighlight %}

case式というユニークな制御構造もあります。
{% highlight ruby %}
 def good_bye(name)
   new_name =
     case name.length
     when 1..8
       name.next.capitalize
     when 9..15
       name.upcase.chop
     else
       name.replace("too-long-name")
     end
   "Good-bye, #{new_name}!!"
 end
 
 good_bye('donkey') # => "Good-bye, Donkez!!"
 good_bye('alligator') # => "Good-bye, ALLIGATO!!"
 good_bye('mississppi-hippopotamus') # => "Good-bye, too-long-name!!"
{% endhighlight %}
コードをよく見て頂ければわかると思いますが、caseはcase式であり値を返します。Rubyでは多くの制御構造や構文が式であり値を返します。つまりRubyでは制御構造もオブジェクト的なのです。

しかし、これらの制御構造は真のオブジェクトではありません。したがってこのような制御構造をメソッドの引数として渡すことはできません。LispやSchemeなどの異次元言語では、これらの制御構造を何の苦もなく関数の引数として渡せるそうです。このような関数は高階関数などとブルジョワジーに呼ばれます。

しかしハンカチを噛む必要はありません。Rubyにはブロックがあります。制御構造をdo endまたは{ }のブロックに入れると、メソッドに引数のように渡せるようになります。
{% highlight ruby %}
 ['donkey', 'alligator', 'hippopotamus'].each do |name|
   salute =
     if name.start_with?('hip')
       'ばか！'
     else
       'やあ！'
     end
   puts salute + name
 end
 # >> やあ！donkey
 # >> やあ！alligator
 # >> ばか！hippopotamus
{% endhighlight %}
例では配列オブジェクトにeachメソッドを送る際にブロックを渡しています。これを受け取った配列オブジェクトは、各要素をブロック引数nameに順番に渡して、ブロックの制御構造を起動するのです。eachに渡すブロックの中身を変えれば、eachメソッドの働きは大幅に変更できます。

この項の表題における「仮装」はtypoではありません。そう制御構造はブロックでオブジェクトに仮装して、他のオブジェクトに入り込むのです！

制御構造をメソッドに付けてオブジェクトに渡せるようにする方法はまだあります。勘のいい人は気が付いたかもしれません。そう制御構造をオブジェクト化すればいいのです。手続きオブジェクト、メソッドオブジェクトなどがこれを可能にします。先を急がれるでしょうからこの話題はこれで終わりにします。

興味のある方は以下が参考になるかもしれません。
[Rubyのブロックはメソッドに対するメソッドのMix-inだ！](http://melborne.github.io/2008/08/09/Ruby-Mix-in/)

{% csssig h2 id='ruby_class' %}
##クラスはオブジェクトの母であってクラスの子であるオブジェクトです
{% endcsssig %}

こういう表現は「クレタ人は嘘つきである」と言った、クレタ人のセリフに聞こえるでしょう。でもわたしはクレタ人ではありません。Rubyワールドにおいてこの表題は事実なのです。

先に「オブジェクトは内部に多数のメソッドを持っており」と書きましたが、実際には持っていません。Rubyはクラスベースのオブジェクト指向言語であり、実際にメソッドを持っているのはオブジェクトの雛型となっているクラスです。オブジェクトはメッセージを受けると、密かに自分の属するクラスにアクセスして結果を得ているのです。

例えば 'donkey'.length というコードでは、文字列オブジェクト'donkey'は自分ではlengthメソッドを持っておらず、その属するStringクラスに問い合わせをして結果を得ます。基本的にすべてのメソッドはクラスが持っており、オブジェクトは自分の属性情報(自身のIDとか属するクラス名とか)しか持っていません。

つまりオブジェクトは「知らないことは俺に聞け！」と言って、陰でググってるわたしやあなたと大差ないのです！

Rubyには40以上の標準添付のクラスがあり、それぞれがその特性を示すような多数のメソッドを備えています。自分で新しいクラスを作ることも、他の人が作ったクラスを取り込むこともできます（kernelモジュールのrequireメソッドを使います）。オブジェクトはほぼ例外なく、これらの何れかのクラスから生成されます。

クラスとメソッドを一望できるページを作りましたので、どんなクラスがあってどんなメソッドを持っているかここで確かめてください。

[Ruby 1.9.3 Methods List](http://rbref.heroku.com/)

各メソッドはRubyリファレンスマニュアルにおけるメソッド解説にリンクしていますから、リンクを辿れば詳細を知ることができます。

一般にクラスはオブジェクトの雛型であると言われます。わたしもさっきそう言いました。でも雛型というと設計図をイメージします。そしてその設計図に基づいて、建造物という実体が作られるとイメージします。

しかしそのイメージはRubyのクラスに関しては正しくありません。なぜならRubyにおいてクラスは実体だからです。つまりクラスもメモリ空間の一部を占有するオブジェクトなのです。ですからクラス自身もメッセージを受信します。

{% highlight ruby %}
 Hash.ancestors # => [Hash, Enumerable, Object, Kernel, BasicObject]
{% endhighlight %}

クラスはメッセージを受けると自身の中に対応するメソッドを探し、あればそれを起動し結果を返します。このクラスに直接送られるメソッドを特にクラスメソッドと呼ぶことがあります。

前でオブジェクトはメッセージを受けると、属するクラスにメソッドを問い合わせると書きました。ではそのクラスが、対応するメソッドを持っていないときはどうなるでしょう。その答えが上のancestorsです。

ここで出力されたクラス群はHashクラスと血の繋がりはありませんが、武芸の師匠といった位置づけのクラスです（正確にはEnumerableとKernelはモジュールという特殊なクラスです）。だからancestorsというよりteachersといったほうがぴったりきます。つまりクラスが対応するメソッドを持たない場合、そのancestorsに順次問い合わせて答えを得ます。このような仕組みを技芸の継承・文化の継承に倣って、クラスの継承といいます。

すべてのクラスが答えることができるクラスメソッドはnewです。これはその属するオブジェクトを生み出すものです。
{% highlight ruby %}
 charlie = Person.new('Charlie', 12, :male)
{% endhighlight %}
Personクラスに名前、年齢、性別の属性情報を渡して、newメソッドを呼んでいます。

これでメモリ空間に１つの人オブジェクトが生まれます。このときnewメソッドを受けるクラスが既にオブジェクトとして、メモリ空間に生成されているということを忘れないでください。

誰がオブジェクトの母親かはclassメソッドで知ることができます。
{% highlight ruby %}
 carlie.class # => Person
 'alligator'.class # => String
 [1, 2, 3].class # => Array
{% endhighlight %}

ではオブジェクトを生み出すクラスは誰が生み出すのでしょう。答えは上と同様クラスにclassメソッドを送れば得られます。
{% highlight ruby %}
 String.class # => Class
 Array.class # => Class
 Person.class # => Class
{% endhighlight %}

RubyにおけるアダムとイブはClassという名を持ったクラスでした。次なる疑問は「ではClassクラスはいったい誰が生むのか？」です。これはご自身で試してみてください。驚愕の事実が得られます。

以上でクラスについてのこの項の説明は終わりです。わたしはクレタ人にならずに済んだでしょうか。

クラスに関して更に知りたい方は以下を参考にしてみてください。

[Rubyのクラスはオブジェクトの母、モジュールはベビーシッター](http://melborne.github.io/2008/08/16/Ruby/)

{% csssig h2 id='user_friendly' %}
##Rubyはユーザフレンドリです
{% endcsssig %}

Rubyにおいてオブジェクト指向はその基本的設計思想です。Ruby設計者まつもとゆきひろさん(愛称Matz)はその思想を頑なに守りながら、一方でプログラマーの負担を最小化するために、ユーザインタフェースをよりフレンドリなものにしました。そのいくつかを紹介します。

###メソッド呼び出しのシンタックスシュガー
オブジェクト指向の基本ルールに従えば、簡単な算術演算も整数オブジェクトに対するメソッド呼び出しのかたちを取ります。
{% highlight ruby %}
 6.+(2) # => 8
 6.-(2) # => 4
 6.*(2) # => 12
 6./(2) # => 3
{% endhighlight %}

しかしRubyでは慣れ親しんだ数学式の書き方ができます。
{% highlight ruby %}
 6 + 2 # => 8
 6 - 2 # => 4
 6 * 2 # => 12
 6 / 2 # => 3
{% endhighlight %}

オブジェクトの状態変数（Rubyではインスタンス変数と呼びます）への代入も次のように自然に書けます。
{% highlight ruby %}
 charlie = Person.new('Charlie', 12, :male)
 charlie.age = 18
{% endhighlight %}

この実際の定義は以下のようになっています。

{% highlight ruby %}
class Person
  def initialize(name, age, sex)
    @name, @age, @sex = name, age, sex
  end

  def age
    @age
  end
  
  def age=(age)
    @age = age
  end
end

charlie = Person.new('Charlie', 12, :male)
charlie.age = 18
charlie.age # => 18
{% endhighlight %}

つまり変数への代入に見える先の式は、実際は引数を伴ったメソッド呼び出しで、**charlie.age=(18)**と等価です。

このようなメソッド呼び出しのシンタックスシュガー(簡略表記)がRubyではできます。

###クラス定義およびレシーバの省略
Rubyではクラス定義をすることなく、コードを手続き型言語のように書くこともできます。
{% highlight ruby %}
 def fact(n)
   if n == 1
     1
   else
     n * fact(n-1)
   end
 end
 puts fact(10)
# >> 3628800
{% endhighlight %}

このようにいきなりメソッドfactを定義したり、レシーバを指定せずにputsメソッド呼んだりできます。

でもここでもオブジェクト指向設計は崩れていません。Matzはオブジェクト内でのメソッド呼び出しをそのレシーバを省略できるようにすると共に、クラスの外で書かれたコードがObjectクラスという基本クラスに自動設定されるようにし、これによって設計の一貫性を維持しつつ、手続き型記述を許せるようにしたのです。

Rubyの手続き型記述をよく使う方も、このことは頭の片隅にあって良いと思います。Rubyではクラスの外をトップレベルと呼ぶことがあります。

###変数・定数
以下の構文は変数carに対する値の代入ですが、Rubyではそれは正確な表現ではありません。
{% highlight ruby %}
 car = 'mini cooper'
{% endhighlight %}

「変数carで'mini cooper'文字列オブジェクトを参照できるようにする」と言ったほうがより正確です。つまり変数carは単なる参照ラベルに過ぎません。ですから、１つのオブジェクトに複数の変数を付けてもコピーは起きません。型といった概念もないので型宣言は不要です。Rubyでは次のコードは問題ありません。
{% highlight ruby %}
 a = 3
 b = 6
 c = a + b
 puts c
 a = 'mississippi'
 b = '-hippopotamus'
 c = a + b
 puts c
 # >> 9
 # >> mississippi-hippopotamus
{% endhighlight %}

’+’が算術演算子ではなくてメソッドであると前に書きました。前者のa + bは3整数オブジェクトに対して、6整数オブジェクトを引数に+メソッドを呼び出しています。その後a, bの参照先が変わって、後者のa + bは'mississippi'文字列オブジェクトに対して、'-hippopotamus'文字列オブジェクトを引数に +メソッドを呼び出しています。つまり+メソッドは、異なるタイプのオブジェクトに送られているのです。

そして整数オブジェクトでは+メソッドは、自身と引数を加算した整数オブジェクトを返すように、文字列オブジェクトでは、自身と引数を連結した文字列オブジェクトを返すようにそれぞれ定義されています。

定数に対する考え方も同じです。定数は大文字で始まり貼り替えの必要のない、つまり内容が変化しないオブジェクトを指す目的で使います。なおクラス定義は大文字で始まりますが(String, Array)、これらはクラスオブジェクトを指し示す定数です。

###括弧の省略
Rubyでは解釈に曖昧さが生じない限り、括弧を省略できます。
{% highlight ruby %}
 def say word
   "#{word} " * 3
 end
 puts say "Hello!"
 puts say say "Hi!"
 # >> Hello!　Hello!　Hello!　
 # >> Hi!　Hi!　Hi!　　Hi!　Hi!　Hi!　　Hi!　Hi!　Hi!　　
{% endhighlight %}

このオブジェクト原理主義的な書き方はこうです。
{% highlight ruby %}
 def say(word)
   "#{word} ".*(3)
 end
 puts(say("Hello!"))
 puts(say(say("Hi!")))
 # >> Hello!　Hello!　Hello!　
 # >> Hi!　Hi!　Hi!　　Hi!　Hi!　Hi!　　Hi!　Hi!　Hi!　　
{% endhighlight %}

括弧の省略はこのようにコードの見た目を改善し読みやすくします。しかし行き過ぎはむしろコードを読み難くします。文章の句読点を使うように適度に括弧を使うのが常識人です。

###多重代入と*(アスタリスク)
Rubyでは関連する複数の変数に対して同時に代入ができます。
{% highlight ruby %}
 a, b, c = 0, 1, 2
{% endhighlight %}

これを多重代入といいます。もちろん関連がなくてもできますが推奨されません。
{% highlight ruby %}
 SIZE, name, switch = {:L => 'large', :M => 'medium', :S => 'small' }, 'Ruby',  [0, 1]
{% endhighlight %}

メソッドは複数の返り値を返せるので、これを多重代入で受けることもできます。
{% highlight ruby %}
 class Fixnum
   def plus_multi(other)
     return self + other, self * other
   end
 end
 
 a, b = 3.plus_multi(4)
 a # => 7
 b # => 12
{% endhighlight %}

変数に*(アスタリスク)を付けるとマルチラベルになって、受けたオブジェクトを配列に入れてそれを指します。
{% highlight ruby %}
 *a = 1, 2, 3
 a # => [1, 2, 3]
{% endhighlight %}

Rubyではこれをメソッドの引数にも使えるのです。
{% highlight ruby %}
 def hello(*a)
   a.each { |name| puts "Hello, #{name}!" }
 end
 
 hello 'donkey', 'alligator', 'hippopotamus'
 # >> Hello, donkey!
 # >> Hello, alligator!
 # >> Hello, hippopotamus!
{% endhighlight %}

このようにRubyは純粋なオブジェクト指向言語でありながら、とてもユーザフレンドリな作りになっています。

呆れるほど長い前置きが続きました。でもこれで最初に掲げた4つの項目の説明は終わりです。もちろん説明はし尽くされていませんが、最初の目的を失しそうなのでここまでとします。

そろそろ本題に入りましょう。

（[続く]({{ BASE_PATH }}/2013/04/29/find-most-frequently-words-with-ruby-2/ "Rubyチュートリアル ─ 英文小説の最頻出ワードを見つけよう! ─（その２）")）

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

