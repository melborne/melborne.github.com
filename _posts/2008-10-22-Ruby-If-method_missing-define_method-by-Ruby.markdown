---
layout: post
title: メソッドが見つからないならRubyに作ってもらえばいいよ！ - If method_missing, define_method by Ruby -
date: 2008-10-22
comments: true
categories:
---

##メソッド定義
Rubyのオブジェクトはメッセージに反応する。つまりオブジェクトがメッセージを受けると、オブジェクトは対応するメソッドを見つけてその結果を返す。

Rubyではオブジェクト自身はメソッドを持っていない。だからオブジェクトは自身が属するクラスにアクセスして、対応するメソッドを得てその結果を返す。

つまりRubyのメソッドはクラスに定義される。

メソッド定義はdef文で行う。
{% highlight ruby %}
 class Person
   def name(arg)
    "My name is #{arg}"
   end
 end
 my = Person.new
 my.name "Charlie" # => "My name is Charlie"
{% endhighlight %}
特定のクラスで定義されたメソッドは、そのクラスから生成されるオブジェクトで使えるようになる。

RubyではすべてのクラスはClassクラスから生成されたオブジェクトである。だからClassクラスで定義されたメソッドは、すべてのクラスで使えるようになる。
{% highlight ruby %}
  class Class
    def mother
      "My mother is #{self.class}"
    end
  end
  class Person
   p mother
  end
    # >> "My mother is Class"
{% endhighlight %}

もちろんClassクラスでも！
{% highlight ruby %}
  class Class
    p mother
  end
    # >> "My mother is Class"
{% endhighlight %}

##singletonクラスでのメソッド定義
通常一つのクラスからは複数のオブジェクトが生成されるので、それらのオブジェクトは同じメソッドを共有することになる。だけど、特定のオブジェクトだけが使えるメソッドを定義したい場合もある。

そのためにRubyではsingletonクラス(特異クラス)が用意されている。
{% highlight ruby %}
  my = Person.new
  his = Person.new
  class << my
    def secret
      "My account number is #100789"
    end
  end
  my.secret # => "My account number is #100789"
  his.secret # => 15: undefined method `secret' for #<Person:0x23168> (NoMethodError)
{% endhighlight %}
略記法もある{% fn_ref 1 %}
{% highlight ruby %}
  my = Person.new
  def my.secret  #myのselfメソッドにする
    "My account number is #100789"
  end
  my.secret # => "My account number is #100789"
{% endhighlight %}
前にも書いたようにRubyではクラスもオブジェクトだから、クラスに対してもsingletonクラスを用意して
そこでメソッドを定義できる。このsingletonクラスで定義されるメソッドは、そのクラスだけが使えるメソッドになる。
{% highlight ruby %}
  class Person
  end
  class << Person
    def secret
      "My secret code is #{self.to_s.reverse}."
    end
  end
  Person.secret # => "My secret code is nosreP."
{% endhighlight %}
略記法のほうが広く使われている。
{% highlight ruby %}
  class Person
    def self.secret
      "My secret code is #{self.to_s.reverse}."
    end
  end
  Person.secret # => "My secret code is nosreP."
{% endhighlight %}
このようなクラスが使うメソッドは、一般にクラスメソッドと呼ばれるけれど、機能上普通のオブジェクトが使うメソッドと変わりはない。もちろんClassクラスもオブジェクトだから、singletonクラスを定義できる。
{% highlight ruby %}
  class Class
    def self.secret
      "My secret code is #{self.to_s.reverse}."
    end
  end
  Class.secret # => "My secret code is ssalC."
{% endhighlight %}

##モジュールにおけるメソッド定義
Rubyにはモジュールというクラスに似たオブジェクトがある。モジュールはクラスと違ってオブジェクトを生成できないけれども、そこにメソッドを定義することはできる。特定のクラスに特定のモジュールをincludeすることによって、そのクラスから生成されるオブジェクトにおいて、モジュールに定義されたメソッドが使えるようになる。
{% highlight ruby %}
  module Secret
    def secret
      "My secret code is #{self.to_s.reverse}."
    end
  end
  class Person
    include Secret
  end
  my = Person.new
  my.secret # => "My secret code is >46a32x0:nosreP<#."
{% endhighlight %}
モジュールもクラス同様オブジェクトだから、モジュールに対してもsingletonクラスを定義できる。
{% highlight ruby %}
  module Secret
  end
  class << Secret
    def secret
      "My secret code is #{self.to_s.reverse}."
    end
  end
  Secret.secret # => "My secret code is terceS."
{% endhighlight %}
クラス同様略記法の方が一般的だ。
{% highlight ruby %}
  module Secret
    def self.secret
      "My secret code is #{self.to_s.reverse}."
    end
  end
  Secret.secret # => "My secret code is terceS."
{% endhighlight %}
モジュールはModuleクラスから生成されるので、Moduleクラスに定義されたメソッドはすべてのモジュールで使えるようになる。
{% highlight ruby %}
  class Module
    def secret
      "My secret code is #{self.to_s.reverse}."
    end
  end
  module Secret
  end
  Secret.secret # => "My secret code is terceS."
{% endhighlight %}
なおClassクラスはModuleクラスのサブクラスだから、Moduleクラスに定義されたメソッドはClassクラスに定義されたメソッドとなり、従ってすべてのクラスでも使えるようになる。
{% highlight ruby %}
  class Module
    def secret
      "My secret code is #{self.to_s.reverse}."
    end
  end
  class Person
  end
  Person.secret # => "My secret code is nosreP."
{% endhighlight %}

##動的メソッド定義 -define_method
メソッドはクラスにdef文で定義すると書いた。つまり通常メソッドはクラスの設計時に定義される。だけどメソッドを必要に応じて後から定義したい場合もある。

そのような場合メソッド定義をネストすればいい。
{% highlight ruby %}
  class Person
    def method_maker
      def name(word)
        "My name is #{word}"
      end
    end
  end
  my = Person.new
  my.method_maker
  my.name "Charlie" # => "My name is Charlie"
{% endhighlight %}
こうすれば外側のメソッドが呼ばれたとき、初めて内側のメソッドが定義されるようになる。

でもせっかく後から定義するんだからもっと柔軟に定義できたらうれしい。例えばメソッド名をユーザの入力で決めるとか。

それに答えるのがModuleクラスのdefine_methodだ。
{% highlight ruby %}
  class Person
    def method_maker(meth_name)
      define_method(meth_name) do |word|
        "My #{meth_name} is #{word}."
      end
    end
  end
  my = Person.new
  my.method_maker(:name)
  my.name "Charlie"
{% endhighlight %}
これでmethod_makerによってnameメソッドが作られて、myオブジェクトから呼べるようになる。
{% highlight ruby %}
  # ~> -:5:in `method_maker': undefined method `define_method' for #<Person:0x23f14> (NoMethodError)
  # ~> 	from -:12
{% endhighlight %}

残念ながらこれはうまくいかないようだ。エラーメッセージをよく見ると、Personクラスのオブジェクトに対してdefine_methodを呼んでるようだ。つまりdef文の中のコンテキストは、Personクラスのオブジェクトということらしい。確かめてみよう。
{% highlight ruby %}
  class Person
    def method_maker(meth_name)
      p self
    end
  end
  my = Person.new
  my.method_maker(:name)
    # >> #<Person:0x23c08>
{% endhighlight %}
やっぱりそうだ。def文の中ではselfはPersonクラスのオブジェクトになってる。Personクラスにメソッドを定義したいんだからそれじゃだめだ。Personクラスのコンテキストでdefine_methodを呼びたいんだ。

こんなときはeval系メソッドが使える。class_evalはクラスのコンテキストで渡されたブロックを評価する。だからPersonクラスに対してclass_evalを呼び出して、そのブロックの中でdefine_methodを定義すればいい。
{% highlight ruby %}
  class Person
    def method_maker(meth_name)
      Person.class_eval do
        define_method(meth_name) do |word|
          "My #{meth_name} is #{word}."
        end
      end
    end
  end
  my = Person.new
  my.method_maker(:name)
  my.name "Charlie" # => "My name is Charlie."
  my.method_maker(:old_name)
  my.old_name "Henry" # => "My old_name is Henry."
  my.method_maker(:size)
  my.size "XXL" # => "My size is XXL."
{% endhighlight %}

クラスのユーザが後からメソッドを追加できるなんて素敵だ。

method_makerに可変長引数を渡せるようにすれば、もう少しよくなる。
{% highlight ruby %}
  class Person
    def method_maker(*meth_names)
      meth_names.each do |meth_name|
        Person.class_eval do
          define_method(meth_name) do |word|
            "My #{meth_name} is #{word}."
          end
        end
      end
    end
  end
  my = Person.new
  my.method_maker :name, :old_name, :size
  my.name "Charlie" # => "My name is Charlie."
  my.old_name "Henry" # => "My old_name is Henry."
  my.size "XXL" # => "My size is XXL."
{% endhighlight %}
ここでdefine_methodは、Personクラスのコンテキストで評価されているので、Personクラスの特定のオブジェクト(my)でmethod_makerを呼ぶと、Personクラスの他のオブジェクトでは既にname, old_name, sizeの各メソッドが使える。
{% highlight ruby %}
  his = Person.new
  his.name "Peter" # => "My name is Peter."
  his.old_name "arthur" # => "My old_name is arthur."
  his.size "M" # => "My size is M."
{% endhighlight %}

でも各オブジェクト毎に使えるメソッドを変えたい場合もある。そんなときはオブジェクトのsingletonクラスのコンテキストで、define_methodが評価されるようにすればいい。
{% highlight ruby %}
  class Person
    def method_maker(*meth_names)
      obj_singleton = class << self; self end
      meth_names.each do |meth_name|
        obj_singleton.class_eval do
          define_method(meth_name) do |word|
            "My #{meth_name} is #{word}."
          end
        end
      end
    end
  end
  my = Person.new
  my.method_maker :name, :old_name, :size
  my.name "Charlie" # => "My name is Charlie."
  my.old_name "Henry" # => "My old_name is Henry."
  my.size "XXL" # => "My size is XXL."
  his = Person.new
  his.name "Peter" # ~> -:25: undefined method `name' for #<Person:0x1f824> (NoMethodError)
  his.method_maker :name, :age, :address
  his.name "Peter" # => "My name is Peter."
  his.age 21 # => "My age is 21."
  his.address "New York" # => "My address is New York."
{% endhighlight %}

##動的メソッド定義 -method_missing
ここまで来ると欲が出てくる。メソッドを追加するのにいちいちmethod_makerメソッドを、呼ばなければならないのはスマートじゃない。

そこでmethod_missingメソッドの出番だ。method_missingは呼び出されたメソッドが未定義のときに、Rubyが自動で起動するフックメソッドだ。
{% highlight ruby %}
  class Person < BasicObject
    def initialize(*meths)
      meths.each { |meth| __send__(meth) }
    end
    def method_missing(meth_name)
      obj_singleton = class << self; self end
      obj_singleton.class_eval do
        define_method(meth_name) do |word|
          "My #{meth_name} is #{word}."
        end
      end
    end
  end
  my = Person.new :name, :old_name, :size
  my.name "Charlie" # => "My name is Charlie."
  my.old_name "Henry" # => "My old_name is Henry."
  my.size "XXL" # => "My size is XXL."
  his = Person.new :name, :age, :address, :class
  his.name "Peter" # => "My name is Peter."
  his.age 21 # => "My age is 21."
  his.address "New York" # => "My address is New York."
  his.class "Premier" # => "My class is Premier."
{% endhighlight %}
上のコードではinitializeメソッドにおいて、引き渡されたメソッド名を呼び出すようにしている。こうすればオブジェクトの生成時にmethod_missingが呼ばれて、対応するメソッドが定義されるようになる。

でもユーザがクラス階層にある既存のメソッドを引き渡した場合、Rubyはそのクラス階層をすべて探索して、そのメソッドを見つけるからmethod_missingは当然呼ばれない。例のようにPersonクラスをBasicObjectのサブクラスにすれば、そのリスクは最小になる(例ではObject#class)。

さらにmethod_missingが、定義したメソッドの結果を返すようにすれば、オブジェクト生成時にメソッド名を渡す必要もなくなる。
{% highlight ruby %}
  class Person < BasicObject
    def method_missing(meth_name, word)
      obj_singleton = class << self; self end
      obj_singleton.class_eval do
        define_method(meth_name) do |word|
          "My #{meth_name} is #{word}."
        end
      end
      __send__("#{meth_name}", word)  #定義したメソッドを返す
    end
  end
  my = Person.new
  my.name "Charlie" # => "My name is Charlie."
  my.old_name "Henry" # => "My old_name is Henry."
  my.size "XXL" # => "My size is XXL."
  his = Person.new
  his.name "Peter" # => "My name is Peter."
  his.age 21 # => "My age is 21."
  his.address "New York" # => "My address is New York."
  his.class "Premier" # => "My class is Premier."
{% endhighlight %}

上の例では未定義のinstanceメソッドの呼び出しに対して、method_missingが起動して対応するinstanceメソッドが定義されるようにした。

こうなると未定義のクラスメソッドの呼び出しに対しても、method_missingを起動させて対応するクラスメソッドを定義できるようにもしたくなる。その場合、method_missingおよびdefine_methodをクラスのsingletonクラスのコンテキスト、つまりクラスメソッドで定義すればいい。
{% highlight ruby %}
  class Country < BasicObject
    def self.method_missing(meth_name)
      cls_singleton = class << self; self end
      cls_singleton.class_eval do
        define_method(meth_name) do |word|
          instance_variable_set("@#{meth_name}", word)
        end
      end
    end
    capital; language; population
  end
  class Japan < Country
    capital "Tokyo"
    language "Japanese"
    population 127433494
    def self.to_s
      "Japan\n Capital: #{@capital}\n Language: #{@language}\n Population: #{@population}"
    end
  end
  class Denmark < Country
    capital "Copenhagen"
    language "Danish"
    population 5475791
    def self.to_s
      "Denmark\n Capital: #{@capital}\n Language: #{@language}\n Population: #{@population}"
    end
  end
  puts Japan
  puts Denmark
  # =>
    Japan
      Capital: Tokyo
      Language: Japanese
      Population: 127433494
    Denmark
      Capital: Copenhagen
      Language: Danish
      Population: 5475791
{% endhighlight %}
この例ではCountryクラスの最後でクラスメソッドを呼ぶことでそれらを定義し、CountryクラスのサブクラスであるJapanとDenmarkで、それらのメソッドを使っている。定義したメソッドはメソッド名のインスタンス変数に引数をセットする。

なおBasicObjectは他のクラス同様、Classクラスのオブジェクトなので、instanceメソッドの場合と異なって、そこから継承された多数のクラスメソッドがある。だからそれらとの衝突が起きないよう注意が必要だ。

##まとめ

1. メソッドはクラスに定義される。
1. クラスに定義されるメソッドはそのクラスから生成される各オブジェクトで使える。
1. クラスはClassクラスのオブジェクト(インスタンス)だからClassクラスに定義されたメソッドは各クラスで使える。
1. singletonクラスに定義されるメソッドはそのオブジェクト専用になる。
1. クラスメソッドとはクラスのsingletonクラスに定義されたメソッドである。
1. モジュールに定義されるメソッドはそれがincludeされたクラスのオブジェクト(インスタンス)で使える。
1. メソッド定義をネストすれば外側のメソッドが呼ばれたときに内側のメソッドが定義されるようになる。
1. class_evalとdefine_methodを使って動的にメソッドを定義できる。
1. method_missingを使って自動的にメソッドが生成されるようにできる。

追記2008-10-26：Countryクラスでclass_variable_setでなくinstance_variable_setを使うよう修正。
{% footnotes %}
   {% fn 適切じゃないけど理解を容易にするために %}
{% endfootnotes %}
