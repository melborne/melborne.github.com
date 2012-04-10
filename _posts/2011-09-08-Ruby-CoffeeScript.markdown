---
layout: post
title: Ruby脳でCoffeeScriptのクラスを理解する
date: 2011-09-08
comments: true
categories:
---


Rubyは最高の言語だから
もっと普及していいと思うけれども
その障害となっているのはたぶん
「Rubyがビジュアルに訴えない言語」となっているからだよ
たしかにRubyにはRuby/TkとかShoesとかがあるけど
現代のプログラミングで「ビジュアル」と言ったら
暗黙的に「Web上の」という修飾が付くよね

一方でJavaScriptは
jQueryやCoffeeScriptの人気を見る限り
最高とは言えない言語だけれども
「ビジュアルに訴える言語」となっている点が
普及の大きな要因になっていると思うよ
つまりブラウザ上で実行できる唯一の言語たる地位が
JavaScriptの大きなアドバンテージなんだね

だから今のところ
「最高の言語でビジュアルなプログラミング」
をすることはできないけれども僕らにはCoffeeScriptがあるよ
CoffeeScriptはRubyの影響を大きく受けてるから
この言語を使って「ビジュアル」なプログラミングをすることが
現時点での最良の選択だと僕は思うんだよ

そんなわけで..

JavaScriptのことをよく知らないRuby脳の僕が
Coffeescriptのクラスのことを少し学んだので
ここでRubyのクラスと対比しつつ説明してみるよ
きっと誤解があると思うけど間違っていたら教えてね
なお以下ではCoffeeScriptのことを単にCoffeeと呼ぶよ

さっそくCoffeeを使って
簡単なクラスを定義してみるよ
{% highlight javascript %}
class Duck
  constructor: (@name, @age) ->
  say: ->
    "Quack Quack #{@name}!"
mofi = new Duck('Mofi', 12)
pipi = new Duck('Pipi', 9)
tete  = new Duck('Tete', 5)
mofi.say() # => "Quack Quack Mofi!"
pipi.say() # => "Quack Quack Pipi!"
tete.say() # => "Quack Quack Tete!"
{% endhighlight %}
Rubyを知っているならこのコードはすぐ読めるよね
new関数でDuckオブジェクトを生成して
sayメソッドを呼んでいるよ

対応するRubyコードはこんな感じかな
{% highlight ruby %}
class Duck
  def initialize(name, age)
    @name, @age, = name, age
  end
  
  def say
    "Quack Quack #{@name}"
  end
end
mofi = Duck.new('Mofi', 12)
pipi = Duck.new('Pipi', 9)
tete = Duck.new('Tete', 5)
mofi.say # => "Quack Quack Mofi"
pipi.say # => "Quack Quack Pipi"
tete.say # => "Quack Quack Tete"
{% endhighlight %}
インスタンス変数への初期値の代入構文は
Rubyにもほしい機能だよね

一見これらのコードは同じに見えるけど
異なる挙動が２つほどあるよ

１つ目はCoffeeでは先のコードで
既にインスタンス変数への外部からのアクセスが
可能になっている点だよ
確かめてみよう
{% highlight ruby %}
mofi.name = "mofy"
mofi.name # => mofy
mofi.say() # => Quack Quack Mofy!
{% endhighlight %}
読み出しも書き込みもできる
Rubyではメソッドを介してじゃないと
インスタンス変数にアクセスすることはできないので
Coffeeと等価にするには
アクセッサメソッドを定義する必要があるよ

２つ目は
sayの呼び出しには常にカッコが必要な点だよ
CoffeeでRubyのようにカッコを省略すると
次のような結果が返るよ
{% highlight javascript %}
mofi.say
# => function () {                                
         return "Quack Quack " + this.name + "!";
       }                                         
{% endhighlight %}
これはJavaScriptに変換された
sayのコードそのものだよ
そしてCoffeeではsayの後のカッコが
そのメソッドを実行させるんだね

つまりこういうことだよ
Coffee(JavaScript)では
オブジェクトの後に続く.nameや.sayは
オブジェクトの内部変数nameや
sayにセットされた値にアクセスする方法なんだよ
そしてJavaScriptでは
関数はファーストクラスのオブジェクトだから
他のデータと同じように
内部変数にそのままセットできるんだ
JavaScriptでは
このような内部変数をプロパティと呼ぶそうだよ

さてこれらの点を考慮して
Rubyのコードを修正すると次のようになるよ
{% highlight ruby %}
class Duck
  attr_accessor :name, :age
  def initialize(name, age)
    @name, @age, = name, age
  end
  
  def say
    ->{ "Quack Quack #{@name}" }
  end
end
mofi = Duck.new('Mofi', 12)
pipi = Duck.new('Pipi', 9)
tete = Duck.new('Tete', 5)
mofi.say.call # => "Quack Quack Mofi"
pipi.say.() # => "Quack Quack Pipi"
tete.say[] # => "Quack Quack Tete"
tete.say # => #<Proc:0x00000100866680@-:8 (lambda)>
{% endhighlight %}
attr_accessorの説明は不要だよね
sayメソッドはProcオブジェクトを返すようにして
呼び出し側でProc#callすれば
Coffeeと同様の結果が得られるよ
Proc#callの別名() []もここで示したよ

さて一応先のCoffeeコードを
JavaScriptにコンパイルしたものにも目を通してみるよ
CoffeeScriptの[公式サイト](http://jashkenas.github.com/coffee-script/#top)でTRY COFFSCRIPTすると
次のJavaScriptのコードが得られるんだ
{% highlight javascript %}
var Duck, mofi, pipi, tete;
Duck = (function() {
  function Duck(name, age) {
    this.name = name;
    this.age = age;
  }
  Duck.prototype.say = function() {
    return "Quack Quack " + this.name + "!";
  };
  return Duck;
})();
mofi = new Duck('Mofi', 12);
pipi = new Duck('Pipi', 9);
tete = new Duck('Tete', 5);
mofi.say();
pipi.say();
tete.say();
{% endhighlight %}

JavaScriptのことはよくわからないから
ここからの説明は僕の推測を大いに含んでいるよ
まずCoffeeにおけるconstructor: () -> というのが
function Duck(){} に変換されているから
constructorは関数定義になることがわかるよ
このDuck関数を実行してnewに渡すと
nameとageのプロパティを持った
オブジェクトが生成されるんだね
JavaScriptはRubyのような
クラスベースのオブジェクト指向ではなくて
コピーベースのオブジェクト指向だから
ここで生成された３つのオブジェクトmofi pipi teteは
Duckオブジェクトのコピーと考えればいいのかな

次にCoffeeにおける say: -> が
Duck.prototype.say = function(){} と変換されているよ
つまり
Duckオブジェクトのprototypeという名のプロパティに
sayプロパティが生成されてここに関数がセットされている
なるほど
コピーベースのオブジェクト指向においては
Duck.say = function(){} とすると関数の実体が
すべてのオブジェクトにコピーされてしまって
効率上問題がある
だからprototypeという共通の器を作って
そこに関数を置けるようにしたんだね

###メソッドの追加
さて次にオブジェクトに別のメソッドを追加してみよう
Rubyでインスタンスメソッドを追加するには
クラスを再オープンすればいいよね
{% highlight ruby %}
class Duck
  def how_old
    ->{ "I'm #{@age} years old." }
  end
end
mofi.how_old.call # => "I'm 12 years old."
pipi.how_old.call # => "I'm 9 years old."
{% endhighlight %}

Coffeeで同じことをするには
上で学んだようにDuckのprototypeプロパティに
関数をセットすればいいはずだよ
これはCoffeeでは次のようにするよ
{% highlight javascript %}
Duck::howOld = ->
  "I'm #{@age} years old."
mofi.howOld() # => "I'm 12 years old."
pipi.howOld() # => "I'm 9 years old."
{% endhighlight %}
Rubyで::は定数のスコープ演算子を表すから
これはちょっと間違えそうだね

JavaScriptにコンパイルするよ
{% highlight javascript %}
Duck.prototype.howOld = function() {
  return "I'm " + this.age + " years old.";
};
mofi.howOld(); # => "I'm 12 years old." 
pipi.howOld(); # => "I'm 9 years old."  
{% endhighlight %}
いいみたいだね
ちなみにJavaScriptでは
クラスを再オープンすることはできなさそうだね
Duckを再定義すると
別のDuckオブジェクトが定義されてしまうよ

###プロパティの追加
Coffeeでは個々のオブジェクトに
簡単にプロパティを設定できるよ
{% highlight javascript %}
pipi.color = 'brown'
pipi.swim = ->
  "swim #{@age} days!"
pipi.color # => 'brown'
pipi.swim() # => 'swim 9 days!'
{% endhighlight %}

もちろんこれらは
他のオブジェクトからは参照できないよ
{% highlight javascript %}
tete.color # => undefined
tete.swim() # => TypeError: Object #<Duck> has no method 'swim'
{% endhighlight %}

JavaScriptの対応コードは次のようになるよ
{% highlight ruby %}
pipi.color = 'brown';
pipi.swim = function() {
  return "swim " + this.age + " days";
};
pipi.color;
pipi.swim();
{% endhighlight %}

Coffeeのオブジェクトにおけるこの軽量さは
Ruby脳にはちょっと驚きだよ
まるでRubyのHashのようだね

さてRubyでもオブジェクト固有のメソッドを定義できるので
等価コードを書いてみるよ
{% highlight ruby %}
class << pipi
  attr_accessor :color
  def swim
    "swim #{@age} days!"
  end
end
pipi.color = 'brown'
pipi.color # => "brown"
pipi.swim # => "swim 9 days!"
tete.color # => undefined method `color'
tete.swim # => undefined method `swim'
{% endhighlight %}

Rubyではpipiオブジェクトについて
シングルトンクラスを開いて
各メソッドを定義する必要があるよ

ちなみにprototypeプロパティに定義された関数と
同名の関数をプロパティにセットすると
どうなるかは想像がつくよね
そのオブジェクトに関しては
それが優先して呼び出されるんだ
{% highlight javascript %}
class Duck
  constructor: (@name, @age) ->
  say: ->
    "Quack Quack #{@name}!"
mofi = new Duck('Mofi', 12)
pipi = new Duck('Pipi', 9)
tete  = new Duck('Tete', 5)
mofi.say = ->
  "Gaa Gaa #{@name}!"
mofi.say() # => "Gaa Gaa Mofi!"
pipi.say() # => "Quack Quack Pipi!"
tete.say() # => "Quack Quack Tete!"
{% endhighlight %}
この挙動はRubyでも同じだね

###クラスメソッド
さて次にDuckクラスに
クラスメソッドを定義することを考えてみるよ
まずはRubyにDuckの総数をカウントする
countクラスメソッドを定義してみるよ
{% highlight ruby %}
class Duck
  @@count = 0
  def self.count
    @@count
  end
  def initialize(name, age)
    @name, @age, = name, age
    @@count += 1
  end
end
mofi = Duck.new('Mofi', 12)
pipi = Duck.new('Pipi', 9)
tete = Duck.new('Tete', 5)
Duck.count # => 3
{% endhighlight %}
クラス変数@@countを初期化し
Duck.countメソッドを定義して
@@countにアクセスできるようにする
そしてinitializeでカウントアップするよ

CoffeeにおいてDuckクラスの外で
Duckのプロパティをセットするのは
Duck.count = 0でできるけど
クラス定義の中では次のように書くみたいだね
{% highlight ruby %}
class Duck
  @count: 0  または @count = 0
  constructor: (@name, @age) ->
    Duck.count += 1
mofi = new Duck('Mofi', 12)
pipi = new Duck('Pipi', 9)
tete  = new Duck('Tete', 5)
Duck.count # => 3
{% endhighlight %}
インスタンス変数と同じ @ を使うよ
ちょっと紛らわしいけどプロパティの中と外で
@の意味が変わることを覚えとけばいいね

###プライベート・メソッド
さて次にDuckにプライベートメソッドを定義してみるよ
Rubyではprivateキーワードで簡単にできるよね
eatメソッドで呼ばれるfoodメソッドを定義するね
{% highlight ruby %}
class Duck
  def eat
    ->{ "eat " + food }
  end
  private
  def food
    "meat!"
  end
end
mofi = Duck.new('Mofi', 12)
mofi.eat.call # => "eat meat!"
mofi.food # => private method `food' called
{% endhighlight %}

それでプライベートメソッドで
インスタンス変数を呼ぶことももちろんできるよ
{% highlight ruby %}
class Duck
  def eat
    ->{ "eat " + food }
  end
  private
  def food
    "#{@age} meat!"
  end
end
mofi = Duck.new('Mofi', 12)
mofi.eat.call # => "eat 12 meat!"
{% endhighlight %}

Coffeeでプライベートメソッドを定義するには
ちょっとわからないけど次のようにするのかな
{% highlight javascript %}
class Duck
  eat: ->
    "eat " + food()
  food = ->
    "beans"
 
mofi = new Duck('Mofi', 12)
mofi.eat() # => 'eat beans'
mofi.food() # => TypeError: Object #<Duck> has no method 'food'
{% endhighlight %}
オブジェクト内のfood変数に"beans"を返す
無名関数をセットするよ

次にfoodでインスタンス変数を呼ぶよ
{% highlight javascript %}
class Duck
  eat: ->
    "eat " + food()
  food = ->
    "#{@age} beans"
 
mofi = new Duck('Mofi', 12)
mofi.eat() # => 'eat undefined beans'
{% endhighlight %}

残念ながらこれがうまくいかないんだよ
ちょっと僕には理由がわからないんだけど..

ここでは引数でオブジェクトを指し示すthisを受け渡して
目的を達成するよ
{% highlight javascript %}
class Duck
  eat: ->
    "eat " + food(this)
  food = (obj)->
    "#{obj.age} beans"
 
mofi = new Duck('Mofi', 12)
mofi.eat() # => 'eat 12 beans'
{% endhighlight %}

僕が勉強したのはここまでだよ
Coffeeではクラスの継承もできるみたいなんだけど
それはまた別機会にするよ

(追記:2011-09-09) 記述を一部加筆・修正しました。