---
layout: post
title: "JavaScript脳で理解するRubyのオブジェクト指向"
description: ""
category: 
tags: [ruby, oop, metaprogramming] 
date: 2012-09-11
published: true
---
{% include JB/setup %}


「世の中がRubyで埋まればいいのに」と思うあなたの気持ちとは裏腹に、世界は一層多様で複雑なものに向かっています。エントロピーは日々増大しています。

人々は、その非効率性を指して**「多様性は悪である」**といいます。しかし画一的世界は創作の原動力となる人々のモチベーションを低下させ、そのやる気を奪います。つまり複雑で理解できない混沌として多様な世界こそが、人々に前に進むエネルギーを注入するのです。

僕たちはハリウッド映画を見るとき、韓国ドラマを見るとき、それから日本人が演じるドラマを見るときに、その文化や歴史的背景に基づく演出の僅かな違いに目ざとく気付きます。そしてその違いによって脳は刺激を受け活動を開始するのです。何一つ同じものなどありません。

僕の脳は完全にJavaScript脳です{% fn_ref 1 %}。他言語の知識は無いと言っていいです{% fn_ref 2 %}。その結果、プログラム言語の世界が極めて画一的に見えています。これは極めて不健全で、何も生み出せない危険な状態です。あまり時間はありませんが、何とかして僕はこの多様な世界を受容する力を手に入れなければなりません。世界平和のためにも。

そんなわけで...

JavaScript脳の僕がRubyのオブジェクト指向をここ数日学んだので、今の理解を書いておきます。当然に不理解に基づく間違いが含まれています。ご指摘助かります。なお、以下のコードの実行結果はruby1.9.3に基づいています。

## オブジェクトの生成
Rubyはプロトタイプベースのオブジェクト指向言語です。オブジェクトは一または複数のプロパティを持てます。プロパティとは、そのオブジェクトに紐付いたデータ（オブジェクトを含む）で、ラベルで参照できるものです。今、`name`と`age`というプロパティを持った２つのオブジェクトCharlie, Earlを生成します。
{% highlight ruby %}
class Charlie
  def self.name
    'Charlie'
  end

  def self.age
    12
  end
end

class Earl
  def self.name
    'Earl'
  end

  def self.age
    14
  end
end

Charlie.name # => "Charlie"
Charlie.age # => 12

Earl.name # => "Earl"
Earl.age # => 14
{% endhighlight %}
オブジェクト生成に`class`式を使っていますが、これはクラスベースのオブジェクト指向をイミテートしたものです。勘違いを生むのでclassを**「良くない部品（The Bad Parts）」**に分類するRubyistもいるようです。各オブジェクトのプロパティに対するアクセスは、上述のようにJavaScriptのプロパティ参照と同じ方法で、`.(ピリオド)`を使って行うことができます。`def`式における`self`はそのオブジェクト自身を指しているので重要です。これを忘れてdefすると誤動作を起こすので、これをThe Bad Partsに分類する人もいます。

なお、生成時のオブジェクト名は大文字からという制約がありますが、気に入らないなら次のようにします。
{% highlight ruby %}
charlie = Charlie
earl = Earl

charlie.name # => "Charlie"
charlie.age # => 12

earl.name # => "Earl"
earl.age # => 14
{% endhighlight %}

また、オブジェクトに対するプロパティの追加や変更は、変数に値を代入するが如くに極めて簡単に行えます。各オブジェクトに、生まれた日からの日数を計算する`age_in_days`プロパティを追加してみます。

{% highlight ruby %}
Charlie.age_in_days = ->{ Charlie.age * 365 }
Earl.age_in_days = ->{ Charlie.age * 365 }

Charlie.age_in_days[]
Earl.age_in_days[]
{% endhighlight %}

JavaScript同様Rubyにおいて関数（定義）はオブジェクトであり、このようにプロパティにセットできます。プロパティ名を介して参照される関数は、`[]`(角括弧)を付することで実行されます。従って`[]`は必須です。以下ではプロパティにセットされた関数を`メソッド`と呼ぶことがあります。さて、メソッドを実際に呼んでみましょう。

{% highlight ruby %}
Charlie.age_in_days[] # => undefined method `age_in_days=' for Charlie:Class (NoMethodError) 
Earl.age_in_days[] # => undefined method `age_in_days=' for Earl:Class (NoMethodError)
{% endhighlight %}

エラーが出ました。どうやら1.9系にはバグがあるようです。次のパッチを当てて、もう一度試してみます。
{% highlight ruby %}
[Charlie, Earl].each do |klass|
  def klass.method_missing(name, *data)
    case name
    when /^(.+)=$/
      (class << self; self end).send(:attr_accessor, $1)
      instance_variable_set("@#{$1}", data.first)
    else
      super
    end
  end
end

Charlie.age_in_days = ->{ Charlie.age * 365 }
Earl.age_in_days = ->{ Earl.age * 365 }

Charlie.age_in_days[] # => 4380
Earl.age_in_days[] # => 5110
{% endhighlight %}
いいですね！

未定義のプロパティの参照に対しては`undefined`が返されます。
{% highlight ruby %}
Charlie.job # => `method_missing': undefined method `job' for Charlie:Class (NoMethodError)
{% endhighlight %}

## プロパティ探索
しかし一方で、未定義ながら特定のプロパティに対しては所定の値が返されます。`class`プロパティを呼んでみます。
{% highlight ruby %}
Charlie.class # => Class
{% endhighlight %}

CharlieオブジェクトのコンストラクタはClassオブジェクトであるという結果が返ってきました。

未定義のプロパティが呼べたという事実をどう解釈すればいいでしょうか。可能性の一つはオブジェクトの生成時にRubyが自動でそのようなプロパティをセットしたということです。

確かめてみます。
{% highlight ruby %}
Charlie.methods(false).include?(:age) # => true
Charlie.methods(false).include?(:class) # => false
Charlie.methods(false).include?(:methods) # => false
{% endhighlight %}

`methods`メソッドに対して、上で定義した`age`はtrueを返しましたが、`class`およびこの呼び出しメソッド自体もfalseを返しました。つまりこれらのプロパティはCharlieオブジェクトには存在しないのです。

つまりCharlieオブジェクトにはそのプロパティ探索に関して、別のオブジェクトがリンクされているのです。この別のオブジェクトは`superclass`プロパティで参照できます。
{% highlight ruby %}
Charlie.superclass # => Object
{% endhighlight %}

`Object`オブジェクトがCharlieオブジェクトにリンクしていることが分かりました。このオブジェクトをRubyではプロトタイプオブジェクトといいます。`superclass`というプロパティ名はミスリーディングですね。では、このオブジェクトが先のプロパティを持っているかを確かめてみます。
{% highlight ruby %}
Object.methods(false).include?(:class) # => false
Object.methods(false).include?(:methods) # => false
{% endhighlight %}
残念ながら、持ってませんでした...えーっと...


実はこれらは（Kernelモジュールのインスタンスメソッド）-> （Classクラスのインスタンスメソッド）-> （Objectクラスのクラスメソッド）という流れになるのですが、話が複雑になるのでここでは持っているとしてください。話し合わないし。m(__)m

参考までに。
{% highlight ruby %}
Kernel.instance_methods(false).include?(:class) # => true
Kernel.instance_methods(false).include?(:methods) # => true
Class.instance_methods.include?(:class) # => false
Class.instance_methods.include?(:methods) # => true
{% endhighlight %}

以上により、オブジェクトのプロパティが呼ばれたとき、そのオブジェクトに対象プロパティがあればそれを返すが、無い場合はsuperclassプロパティにセットされたオブジェクトのプロパティを探索する。そして対象プロパティがそこにあればそれを返すということが分かりました。

ここで仮に、プロトタイプオブジェクトにも対象プロパティが見つからなかった場合はどうなるのでしょうか。これは想像が付きますよね。プロトタイプオブジェクトもCharlieオブジェクトと同種のオブジェクトですから、superclassプロパティを持ってるはずです。よって、ここから更にその先のオブジェクトを辿るのでしょう。Charlieの先の先、つまりそのプロトタイプオブジェクトのsuperclassにセットされたオブジェクトを見てみましょう。
{% highlight ruby %}
Charlie.superclass.superclass # => BasicObject
Charlie.superclass.superclass.superclass # => nil
{% endhighlight %}
`BasicObject`が返ってきました。更にそのsuperclassを調べると、今度は`nil`が返ってきました。つまりこの場合、プロパティ探索の旅（プロトタイプチェーン）はここで終了ということですね。

## プロトタイプチェーンを使う
さて、この辺で最初のコードに戻ります。
{% highlight ruby %}
class Charlie
  def self.name
    'Charlie'
  end

  def self.age
    12
  end
end

class Earl
  def self.name
    'Earl'
  end

  def self.age
    14
  end
end

### a patch
[Charlie, Earl].each do |klass|
  def klass.method_missing(name, *data)
    case name
    when /^(.+)=$/
      (class << self; self end).send(:attr_accessor, $1)
      instance_variable_set("@#{$1}", data.first)
    else
      super
    end
  end
end
### end of a patch

Charlie.age_in_days = ->{ Charlie.age * 365 }

Earl.age_in_days = ->{ Earl.age * 365 }

Charlie.name # => "Charlie"
Charlie.age # => 12
Charlie.age_in_days[] # => 4380

Earl.name # => "Earl"
Earl.age # => 14
Earl.age_in_days[] # => 5110
{% endhighlight %}

このコードを見て、ムズムズしない人はいないでしょう。そう`age_in_days`メソッドがDRY原則に反しています。その結果どういった問題が生じるでしょう。

仮に、銀河の歪みによって地球の公転周期が今の３倍、つまり１年が365*3=1095日になったらどうなりますか？その場合、あなたはすべての人オブジェクトのage_in_daysメソッドを１つづつ修正しなければなりません。

先ほどのプロパティ探索の機構を利用してこの問題を解決します。つまり人の原型となる`Person`オブジェクトを定義してプロトタイプチェーンに組み込むのです。
{% highlight ruby %}
class Person
  def self.name
    'unknown'
  end

  def self.age
    1
  end

  def self.age_in_days
    ->{ Person.age * 365 * 3 }
  end
end

Person.name # => "unknown"
Person.age # => 1
Person.age_in_days[] # => 1095
{% endhighlight %}
Personオブジェクトが生成できました。これをCharlie, Earlの各オブジェクトのプロトタイプとなるよう、それらのsuperclassにセットして、age_in_daysを呼んでみます。`class SUBCLASS < SUPERCLASS; end`という構文を使います。

{% highlight ruby %}
class Charlie < Person; end

class Earl < Person; end

# ~> superclass mismatch for class Charlie (TypeError)
# ~> superclass mismatch for class Earl (TypeError)

Charlie.age_in_days[] # => 
Earl.age_in_days[] # => 
{% endhighlight %}
superclassがミスマッチであるとのエラーが出ました。どうやらまだバグがあるようです。

時間の関係上、誰かからパッチが出るのを期待しつつ{% fn_ref 3 %}^ ^;、ここではCharlie, Earlオブジェクトを再定義することで話を進めます。

{% highlight ruby %}
class Person
  def self.name
    'unknown'
  end

  def self.age
    1
  end

  def self.age_in_days
    ->{ self.age * 365 * 3 }
  end
end

class Charlie < Person
  def self.name
    'Charlie'
  end

  def self.age
    12
  end
end

class Earl < Person
  def self.name
    'Earl'
  end

  def self.age
    14
  end
end

Charlie.age_in_days[] # => 13140

Earl.age_in_days[] # => 15330
{% endhighlight %}

プロトタイプチェーンがどう変化したか確認してみます。
{% highlight ruby %}
Charlie.superclass # => Person
Charlie.superclass.superclass # => Object
Charlie.superclass.superclass.superclass # => BasicObject
Charlie.superclass.superclass.superclass.superclass # => nil
{% endhighlight %}
見事にpersonオブジェクトが間に差し込まれています。


## オブジェクトコンストラクタ
さて、引き続きPersonを型とする別のオブジェクトを生成してみます。
{% highlight ruby %}
class Person
  def self.name
    'unknown'
  end

  def self.age
    1
  end

  def self.age_in_days
    ->{ self.age * 365 * 3 }
  end
end

class Zena < Person
  def self.name
    'Zena'
  end
end

class Rio < Person
  def self.name
    'Rio'
  end

  def self.age
    18
  end
end

class Jackie < Person
  def self.name
    'Jackie'
  end

  def self.age
    21
  end
end

Zena.name # => "Zena"
Zena.age # => 1
Zena.age_in_days[] # => 1095

Rio.name # => "Rio"
Rio.age # => 18
Rio.age_in_days[] # => 19710

Jackie.name # => "Jackie"
Jackie.age # => 21
Jackie.age_in_days[] # => 22995
{% endhighlight %}

クラスベースのオブジェクト指向に慣れた人にとって、このオブジェクト生成プロセスは面倒に感じられることでしょう。もっと簡便にオブジェクトを生成する方法はないでしょうか。

Rubyの関数が使えそうです。そう関数でオブジェクトのコンストラクタを作るのです。nameとageを引数にとって、これらをプロパティとしたオブジェクトを返す、そんな関数です。コンストラクタらしく、大文字から始まるPersonコンストラクタを定義します。
{% highlight ruby %}
def Person(name, age)
  unless Object.const_defined?(:Person)
    proto = Class.new do |c|
      def self.age_in_days
        ->{ self.age * 365 * 3 }
      end
    end
    Object.const_set('Person', proto)
  end
  
  Class.new(Person) do |c|
    (class << self; self end).class_eval do
      define_method(:name) { name }
      define_method(:age) { age }
    end
  end
end
{% endhighlight %}
ここでの重要なポイントは、age_in_daysプロパティを持ったプロトタイプオブジェクト（Person）を生成し、返されるオブジェクトのsuperclassにこれをセットすることです。一応、Personが存在する場合はunless式で無駄な処理が繰り返されないようにします。これで先のコードとほぼ同様のオブジェクトをコンストラクタを使って生成できそうです。

やってみます。
{% highlight ruby %}
Zena = Person('Zena', 1) # => Zena
Rio = Person('Rio', 18) # => Rio
Jackie = Person('Jackie', 21) # => Jackie

Zena.name # => "Zena"
Zena.age # => 1
Zena.age_in_days[] # => 1095
Zena.superclass # => Person

Rio.name # => "Rio"
Rio.age # => 18
Rio.age_in_days[] # => 19710
Rio.superclass # => Person

Jackie.name # => "Jackie"
Jackie.age # => 21
Jackie.age_in_days[] # => 22995
Jackie.superclass # => Person
{% endhighlight %}
いいですね！


## Person.new
ここまで来れば僕が何を言いたいのかが分かると思います。

えっ？何ですか？

a Rubyist: 「Rubyってクラスベースのオブジェクト指向なんだけど」


...


まさか！


{% highlight ruby %}
class Person
  attr_accessor :name, :age
  def initialize(name, age)
    @name, @age = name, age
  end

  def age_in_days
    self.age * 365
  end
end

Person.superclass # => Object

zena = Person.new('Zena', 1) # => #<Person:0x00000101043600 @name="Zena", @age=1>
rio = Person.new('Rio', 18) # => #<Person:0x00000101043150 @name="Rio", @age=18>
jackie = Person.new('Jackie', 21) # => #<Person:0x00000101042d40 @name="Jackie", @age=21>

zena.name # => "Zena"
zena.age # => 1
zena.age_in_days # => 365
zena.class # => Person

rio.name # => "Rio"
rio.age # => 18
rio.age_in_days # => 6570
rio.class # => Person

jackie.name # => "Jackie"
jackie.age # => 21
jackie.age_in_days # => 7665
jackie.class # => Person
{% endhighlight %}


関連記事：[Ruby脳が理解するJavaScriptのオブジェクト指向](http://melborne.github.com/2012/09/09/understand-js-oop-with-ruby-brain/ 'Ruby脳が理解するJavaScriptのオブジェクト指向')

---

![JS OOP Ebook]({{ site.url }}/assets/images/2012/js_oop_cover.png)

<a href="http://gum.co/wNxf" class="gumroad-button">電子書籍「Ruby脳が理解するJavaScriptのオブジェクト指向」EPUB版 </a><script type="text/javascript" src="https://gumroad.com/js/gumroad-button.js"></script><script type="text/javascript" src="https://gumroad.com/js/gumroad.js"></script>

このリンクはGumroadにおける商品購入リンクになっています。クリックすると、オーバーレイ・ウインドウが立ち上がって、この場でクレジットカード決済による購入が可能です。購入にはクレジット情報およびメールアドレスの入力が必要になります。購入すると、入力したメールアドレスにコンテンツのDLリンクが送られてきます。

---

{{ 4048687158 | amazon_medium_image }}
{{ 4048687158 | amazon_link }} by {{ 4048687158 | amazon_authors }}

---

{% footnotes %}
  {% fn 嘘です。 %}
  {% fn Rubyしか知りません。 %}
  {% fn 僕にはうまく出来ませんでした。Rubyの力で僕のパパを貧乏父さんから金持ち父さんにしてよ！ http://melborne.github.com/2012/05/19/rich-dad-poor-dad/ %}
{% endfootnotes %}


