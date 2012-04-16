---
layout: post
title: Rubyのブロックはメソッドに対するメソッドのMix-inだ！
date: 2008-08-09
comments: true
categories:
---


Yugui著「初めてのRuby」を読んでいる。

{{ 4873113679 | amazon_medium_image }}
{{ 4873113679 | amazon_link }} by {{ '4873113679' | amazon_authors }}

7章メソッドには、ブロック付きメソッドのことが丁寧に記述されていて大変参考になる。

Rubyのブロックは分かったようで分からない代物だ。スーパーマリオブラザーズのように、間口が広くて奥が深い。少し真剣に向き合ってみた。完全理解にはほど遠いけれども、頭を整理するために今の理解を書いてみることにする。

##引数付きメソッド
Ruby空間における操作対象はオブジェクトである。オブジェクトは外からのメッセージを受け取ると、その中の対応するメソッドを起動してそこに書かれている手続きを実行する。
{% highlight ruby %}
  "Charlie".length  # => 7が返る
{% endhighlight %}
文字列オブジェクト"Charlie"にメッセージlengthが送られると、対応するlengthメソッドが起動され、7が返される。

メソッドは引数を取ることができる。メッセージのカッコ内に収められたオブジェクトは、メソッドに渡されその中で他のオブジェクトと協同することになる。

数字、文字列、配列、ハッシュ、範囲などはオブジェクトだから、それを受ける用意があるのなら、当然メソッドに渡すことができる。
{% highlight ruby %}
  class String
    def speak(word)
      case word
      when Integer
        word.times { print self, " " }
      else
        word.each { |item| print item, "-#{self} " }
      end
    end
  end
"moo".speak(5)           # => moo moo moo moo moo 
"moo".speak("hello!")    # => hello!-moo
"moo".speak([1, 2, 3])   # => 1-moo 2-moo 3-moo
"moo".speak({:love => 'lettuce',:hate => 'cucumber'})
             # => lovelettuce-moo hatecucumber-moo 
"moo".speak('a'..'h') 
      # => a-moo b-moo c-moo d-moo e-moo f-moo g-moo h-moo
{% endhighlight %}

オブジェクトには変数という名札を付けられるので、変数を付けてメソッドに渡すこともできる。
{% highlight ruby %}
n = 5
s = "hello!"
a = [1, 2, 3]
h = {:love => 'lettuce',:hate => 'cucumber'}
r = 'a'..'h'
"moo".speak(n)
"moo".speak(s)
"moo".speak(a)
"moo".speak(h)
"moo".speak(r)   # 結果は同じ
{% endhighlight %}

##ブロック
Rubyの構成要素の中にブレース { } または do end で表現されるブロックというものがある。ブロックは一連の手続きをその間に封入する。封入された一連の手続きは一塊のモジュールになる。
{% highlight ruby %}
  { "block me!" * 3 }
  do
    a = [1,2,3]
    s = "block me!"
    a << s
  end
{% endhighlight %}
一連の手続きもモジュールになれば他のオブジェクトと同様に、メソッドに渡すことができそうだけれども、ブロックはオブジェクトではないので、それはできない。
{% highlight ruby %}
  "moo".speak({ "block me!" * 3 })
                # => エラー(odd number list for Hash)
  "moo".speak(do
    a = [1,2,3]
    s = "block me!"
    a << s
  end)                  # => エラー(syntax error)
{% endhighlight %}

変数に代入することもできない。
{% highlight ruby %}
  b1 = { "block me!" * 3 }  # => エラー(odd number list for Hash)
  b2 = do
    a = [1,2,3]
    s = "block me!"
    a << s
  end                  # => エラー(syntax error)
 
  "moo".speak(b1)
  "moo".speak(b2)
{% endhighlight %}
##手続きオブジェクト
それならばブロックをオブジェクト化すればいい。ブロックの前にlambda(λ:ラムダ)(Proc.new、procでもよい)を付けると、ブロックは手続きオブジェクト(Proc)になる。オブジェクトになれば引数としてメソッドに渡せるし、変数への代入もできる。手続きオブジェクトになれば、メソッドと離れて存在することもできるようになる。
{% highlight ruby %}
  class String
    def speak(word)
      word.call.each { |item| print item, "-#{self} " }
               # Procオブジェクトをcallする
    end
  end
  b1 = lambda { "block me!" * 3 }
  b2 = lambda do
    a = [1,2,3]
    s = "block me!"
    a << s
  end
  "moo".speak(b1)      # => block me!block me!block me!-moo
  "moo".speak(b2)      # => 1-moo 2-moo 3-moo block me!-moo
{% endhighlight %}
Procオブジェクトを受け取ったメソッド内でcallメソッドを呼べば(Ruby1.9ではyieldメソッドも使える)、渡されたブロック内の手続きが実行される。

ブロックがオブジェクトになった以上、他のオブジェクトと同様に、機能的にはメソッドに複数渡せるし、配列などに入れてから渡すこともできる。

lambdaを使ってメッセージ送信側でブロックをオブジェクト化するのに代えて、メッセージ受信側でオブジェクト化する方法もある。メソッド仮引数にアンパサンド & をプリペンドすると、ブロックはここで手続きオブジェクトに変換されて、メソッド内で変数に代入できるようになる。
{% highlight ruby %}
  class String
    def speak(&word)                      #仮引数に&を付ける
      word.call.each { |item| print item, "-#{self} " }     
    end
  end
  "moo".speak { "block me!" * 3 }  
                    # => block me!block me!block me!-moo
  "moo".speak do
    a = [1,2,3]
    s = "block me!"
    a << s
  end        # => 1-moo 2-moo 3-moo block me!-moo
{% endhighlight %}
注意点はブロックをメッセージに付けるときそれをカッコの中に入れてはいけない。メッセージのカッコはオブジェクト引数のためのものであり、まだその時点ではブロックはオブジェクトになっていないからだ(カッコに入れていないブロックが受側でカッコで受けられるという構文にはちょっと違和感があるけど)。

##ブロック付きメソッド
手続きオブジェクトを利用することでブロックはメソッドにも渡せるし、変数にも代入できるポータブルなものになった。これこそ純粋オブジェクト指向プログラミングの真骨頂だ。

でもその分ユーザはオブジェクト生成コストを負担しなければいけない。ポータブル性を捨ててもそれを避けたい場合もある。

Rubyでは引数とは別にブロックを直接メッセージに付ける方法で、これを可能にする(&を用いた場合と同様、引数用のカッコの中にブロックを入れてはいけない)。Rubyは普段オブジェクトしか相手にしないけど、ブロックだけは特別扱いすることにしたのだ(この点では純粋オブジェクト指向プログラミングの看板に偽りありか？)。
{% highlight ruby %}
  class String
    def speak
      yield.each { |item| print item, "-#{self} " }  
　　　　　　　 # yieldでブロックを呼ぶ
    end
  end
  "moo".speak { "block me!" * 3 }
　　　　　      # => block me!block me!block me!-moo
  "moo".speak do
    a = [1,2,3]
    s = "block me!"
    a << s
  end         # => 1-moo 2-moo 3-moo block me!-moo
{% endhighlight %}
メッセージに直接付けたブロックはオブジェクトのように引数を通してメソッドに渡されるのではなく、メソッド内でキーワードyieldを呼ぶことによって、直接実行される。実行結果は手続きオブジェクトの場合と変わらない。

なお、手続きオブジェクトをブロックに戻したいときには、メッセージの送信側で先のアンパサンド付き引数が使える。
{% highlight ruby %}
  block = lambda { |i| print i, " " }
  5.times(&block)            # => 0 1 2 3 4
  3.upto(10, &block)      # => 3 4 5 6 7 8 9 10
{% endhighlight %}
この例の場合、ブロックは手続きオブジェクトの形で送られ、受側メソッドのyieldが呼ばれたときにブロックに戻されるようになる(と想像してます)。

##ブロックとメソッド
考えてみればブロックはメソッドによく似ている。メソッドだって一連の手続きをモジュール化したものだ。メソッド同様ブロックの戻り値は最後の評価式かreturnの引数だ(returnはオブジェクト化ブロックでのみ有効)。
{% highlight ruby %}
  def meth      # メソッド
    a = [1,2,3]
    s = "method me"
    a << s
  end
  do                  #ブロック
    a = [1,2,3]
    s = "block me!"
    a << s
  end
{% endhighlight %}

メソッドには名前は付き物だけれども、ブロックにはそれがないのでいわばブロックは...

名無しメソッドだ！

名無しの利点は彼がそこにいるのだったらいちいち名前を呼ばなくてもいい、ということなんだろうけど、その利点は僕の理解に余る。

メソッドは引数を取れる。だからきっとブロックも取れるに違いない。そうその通り。でもやり方がちょっと違う。ブロックではその内側先頭に用意した垂直バーで挟んで、引数を受け取る。
{% highlight ruby %}
  def meth(arg)      # メソッド
    a = [1,2,3]
    s = "method me"
    (a << s) * arg
  end
  do |arg|                 #ブロック
    a = [1,2,3]
    s = "block me!"
    (a << s) * arg
  end
{% endhighlight %}
ブロックはyieldが呼ぶのだからメソッド呼び出しのように、yieldに付けた引数がブロックに渡されることになる(手続きオブジェクトを生成した場合はProc#callがブロックを呼ぶのでその場合はcallメソッドにつけた引数)。

このときブロックを付けたメッセージに引数も付けて、これがyieldの引数として使われるようにしてもいい。
{% highlight ruby %}
  class String
    def speak(i)
      yield(i).each { |item| print item, "-#{self} " } 
　　　　　    # メソッドの引数 i をyieldに渡す
    end
  end
  "moo".speak(2) do |arg|
    a = [1,2,3]
    s = "block me!"
    (a << s) * arg
  end      
     # => -moo 2-moo 3-moo block me!-moo 1-moo 2-moo 3-moo block me!-moo
{% endhighlight %}
こうすると、メッセージに付けた引数が隣のブロックに直接渡されるように見える。でも実際には引数もブロックもメソッドに渡されて、その中のyieldで橋渡しされる。

##ブロックのパワー
メソッドの挙動は通常クラスの設計時にほぼ決まる。でもブロックを使うことでメソッドに元からある機能は大きく拡張されうる。ブロックはメソッドに後から一連の手続き(メソッド)を差し込める。まるでクラスにモジュールを差し込むみたいに。そうだからブロックは…

メソッドに対するメソッドのMix-inなんだ！

Mix-inの方法には制限はないけれども、渡したブロックを対象のオブジェクトと密に結合するものと、粗に結合するものとがある。

密に結合するものの代表例はイテレータ(繰り返し)である。
{% highlight ruby %}
  [1, 2, 3].each { |i| print i, " " }     # => 1 2 3
{% endhighlight %}
配列オブジェクトのeachメソッドは任意の手続きを記述したブロックをとって、この手続きを自身の各要素に順次適用するという処理を施す。

eachメソッドの実装等価コードは以下のようになる。
{% highlight ruby %}
  class Array
    def each
      n = 0
      while n < self.length
        yield self[n]
        n += 1
      end
    end
  end
{% endhighlight %}
yieldは配列の各要素1,2,3を順次取って呼び出され、その都度要素を出力する。

ブロックの中身を変えれば元のメソッドの中身は同じでも、得られる結果は大きく変わる。これこそがブロックのパワーだ。
{% highlight ruby %}
  [1,2,3].each { |i| puts "_R_" * i * i }  
# => _R_
  _R__R__R__R_
  _R__R__R__R__R__R__R__R__R_
{% endhighlight %}
汎用性が認められるのなら、イテレータメソッドを自分で定義してもいい。
{% highlight ruby %}
  class Array
    def each_after_divide(i)
      n = 0
      while n < self.length
        yield self[n]/i
        n += 1
      end
    end
  end
[1,2,3].each_after_divide(2.0) { |i| print i, " " }
　　　　　     # => 0.5 1.0 1.5
{% endhighlight %}

粗に結合するものの代表例はリソース管理だ。定型的な前処理、後処理を伴うこの種の手続きは定型処理をメソッドで定義して、可変的な処理の実体をブロックで書いて渡す。

ファイルをオープンしクローズする定型処理をメソッドで記述しておけば、具体的にファイルの中身を処理するコードだけをブロックで追加的に書けばいい。

##クロージャ
ブロックは名無しのメソッドで、だからほとんどメソッドを記述する気持ちで記述できる。でもちょっと違うところもある。

メソッドはdef  endの厚い壁によって、外部の空間とは完全に分断されている。だからメソッドの中からは外にあるローカルな変数は見えない。この厚い壁を透過できるのはインスタンス変数とそれ以上のグローバルな参照を許している変数(クラス変数、定数、グローバル変数を指しています)のみだ。

インスタンス変数とは特定のオブジェクト内で、他のオブジェクトをグローバル参照できるようにする変数である。

一方、ブロックのdo end あるいは { } はそれよりも壁が薄くて中から外が見える。つまり、外にあるローカルな変数が見える。ブロックの中ではインスタンス変数に頼らずに外の世界を把握し、場合によってはその状況を変えることができる(ブロックにおける変数の透過性については「初めてのRuby」に詳しい)。

一つのブロックから複数の手続きオブジェクトを生成するとき、個々の手続きオブジェクトは外のローカル変数が参照するオブジェクトを、その生成時に一緒に閉じこめることができる。それはあたかもオブジェクトがその生成時に、その状態をインスタンス変数に閉じこめるようだ。

メソッドにこのようなオブジェクト的な状態保持の機能を持たせたもの、それを一般にはクロージャーというようだ。Rubyのブロックはこの点から見れば、特定のオブジェクトに内包された簡易なオブジェクト生成機構である。

##メソッドオブジェクト
これほどブロックとメソッドとが似たものならば、当然メソッドもメッセージに付けて他のオブジェクトに渡せないかと考える。

RubyではメソッドをMethodオブジェクト化することによってそれもできる。手続きオブジェクトの場合と同じようにメソッドはオブジェクト化されるので、他のオブジェクト同様メッセージの引数として渡せるようになる。
{% highlight ruby %}
  class String
    def speak(arg, meth)
      meth.call(arg).each { |item| print item, "-#{self} " }
    end
  end
  def my_meth(arg)
    a = [1,2,3]
    s = "hello!"
    (a << s) * arg 
  end
  "moo".speak(2, method(:my_meth))　　# methodメソッドを使う
       # =>1-moo 2-moo 3-moo hello!-moo 1-moo 2-moo 3-moo hello!-moo
{% endhighlight %}
メソッドのオブジェクト化にはObjectのmethodメソッドを使う。

これはあくまでもメソッドなのでブロックと異なり状態保持の機能はない。

ブロック付きメソッドと同じように、メソッドオブジェクトを生成せずにメソッドを渡す方法もある。Objectのsendメソッドを使う。
{% highlight ruby %}
  class String
    def speak(meth)
      meth.each { |item| print item, "-#{self} " }
    end
  end
  def my_meth(arg)
    a = [1,2,3]
    s = "hello!"
    (a << s) * arg 
  end
  "moo".speak(send(:my_meth, 2))  # sendメソッドを使う
    # =>  1-moo 2-moo 3-moo hello-moo 1-moo 2-moo 3-moo hello!-moo
{% endhighlight %}
sendメソッドはメソッド名と共に引数を同時に取って、そのメソッドの実行結果を返す。だからspeakメソッド内の変数methがブロック付きメソッドにおけるyield相当になる。

最後にブロックの特性をまとめてみよう。

1. 名前のないメソッドである。
1. メソッドに後から差し込めるMix-inメソッドである。
1. 望めばオブジェクトになれる未登録オブジェクトである。
1. 外部状態を閉じ込めた簡易オブジェクトあるいはクロージャーである。

関連記事：
[Rubyのシンボルは文字列の皮を被った整数だ！]({{ site.url }}/2008/08/02/Ruby/)
[Rubyのyieldは羊の皮を被ったevalだ！]({{ site.url }}/2008/08/12/Ruby-yield-eval/)
[Rubyのクラスはオブジェクトの母、モジュールはベビーシッター]({{ site.url }}/2008/08/16/Ruby/)

