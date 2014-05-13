---
layout: post
title: "RubyistたちのDRY症候群との戦い"
tagline: "Rubyで自動的にインスタンス変数をセットする"
description: ""
category: 
tags: 
date: 2013-09-27
published: true
---
{% include JB/setup %}

## DRY症候群

Rubyistの間では「[**DRY原則**](http://ja.wikipedia.org/wiki/Don%27t_repeat_yourself "Don't repeat yourself - Wikipedia")」が浸透しているので、彼らは重複や同じことの繰り返しを極端に嫌います。コードの中に繰り返しがあると、目や肌が乾燥してきて痒くなり落ち着きがなくなります。「DRY!DRY!DRY!」と叫び出す人もいます。アサヒスーパードライを飲み始める人もいます。これらの症状を総称して**「DRY症候群」**と言います。

Rubyの言語仕様はプログラマーがハッピーにコーディングできるよう考えられているので、RubyistをしてDRY症候群が発症することは稀ですが、日常的にDRY症候群を発症している人たちもいるようです。

以下は、DRY症候群を検査するためのテストコードです。コードを数秒間眺め、痒みが出てきたらあなたは重度のDRY症候群を患っています。

{% highlight ruby %}
class User
  attr_reader :name, :income
  def initialize(name, income)
    @name = name
    @income = income
  end

  def real_user?
    @income > 10_000_000
  end
end
{% endhighlight %}

痒みが出なかった人たちに向けて説明すると、「`initialize`におけるインスタンス変数への引数の引き渡しがDRYでない」、ということです。

それで大抵、彼らは以下を試し、うなだれるのです。

{% highlight ruby %}
class User
  attr_reader :name, :income
  def initialize(@name, @income)
  end

  def real_user?
    @income > 10_000_000
  end
end

# ~> -:3: formal argument cannot be an instance variable
# ~>   def initialize(@name, @income)
# ~>                       ^
# ~> -:3: formal argument cannot be an instance variable
# ~>   def initialize(@name, @income)
# ~>                                ^
{% endhighlight %}

## DartとCoffeeScriptの場合

グーグルが開発したプログラミング言語「[Dart](https://www.dartlang.org/ "Dart: Structured web apps")」では、[Automatic field initialization](https://www.dartlang.org/articles/idiomatic-dart/#automatic-field-initialization "Idiomatic Dart \| Dart: Structured web apps")という機能によって、以下のコードを、

{% highlight dart %}
class User {
  String name;
  num income;

  User(String name, num income) {
    this.name = name;
    this.income = income;
  }
}
{% endhighlight %}

以下のように書けるそうです。

{% highlight dart %}
class User {
  String name;
  num income;

  User(this.name, this.income);
}
{% endhighlight %}

同様に、「[CoffeeScript](http://jashkenas.github.io/coffee-script/ "CoffeeScript")」でも、以下を、

{% highlight coffeescript %}
class User
  constructor: (name, income) ->
    @name = name
    @income = income
{% endhighlight %}

以下のように書けるそうです（[classes, Inheritance, and Super](http://jashkenas.github.io/coffee-script/#classes "CoffeeScript")）。

{% highlight coffeescript %}
class User
  constructor: (@name, @income) ->
{% endhighlight %}

羨ましい。

これをもって、DartまたはCoffeeScriptへの鞍替えを検討しているRubyistも少なくないと聞きます。


## さっちゃんによるRuby版AFI

「**さっちゃん**」こと、@ne_sachirou殿がこの問題を解決すべく、Ruby版AFIの実装を公開してくれてます。

> [Dart風のautomatic field initializationをRubyで - c4se記：さっちゃんですよ☆](http://c4se.hatenablog.com/entry/2013/09/23/075129 "Dart風のautomatic field initializationをRubyで - c4se記：さっちゃんですよ☆")

記事によれば、以下のように`initialize`の定義のあとで`auto_attr_init`クラスメソッドを呼べば、initializeの引数が自動で同名のインスタンス変数にセットされるそうです。

{% highlight ruby %}
require 'auto_attr_init'

class Point
  attr_accessor :x, :y

  def initialize x, y; end
  auto_attr_init
end

p = Point.new 2, 4
assert_equal 2, p.x
assert_equal 4, p.y
{% endhighlight %}

自動セットする変数を限定したい場合は、auto_attr_initにシンボルで渡します。

実装は、ソースを[Ripper](http://doc.ruby-lang.org/ja/1.9.3/library/ripper.html "library ripper")で解析して、必要な処理を施して、[sorcerer](https://github.com/jimweirich/sorcerer "jimweirich/sorcerer")というツールでRubyのコードに戻す、ということをやってるそうです。スゴイです。


## @merborneによるなんちゃってRuby版AFI

さっちゃんのお陰で、DRY症候群問題は無事解消しました。

したがって僕の出番はないんですが、Ruby芸人を目指す身（！）としては、もっと安直にやれる方法を模索したくなりました。

で、私、@merborneも同じような機能をもった、「AutoAttrSet」というモジュールを作ったので公開します。

対象のクラスで`AutoAttrSet`モジュールをextendします。そしてCoffeeScriptのように、initializeで`＠`を付けて変数を渡します。

{% highlight ruby %}
require 'auto_attr_set'

class User
  extend AutoAttrSet

  attr_reader :name, :income
  def initialize(＠name, ＠income)
    
  end
  
  def real_user?
    @income > 10_000_000
  end
end

a_user = User.new('Charlie', 300_000)
a_user.name # => "Charlie"
a_user.income # => 300000
a_user.real_user? # => false
a_user.instance_variables # => [:@name, :@income]
{% endhighlight %}

デフォルト値が渡せない、`*`や`&`を伴う引数の後に渡せないなどの制約はありますが、このコードはシンタックスエラーにはなりません。普通の引数を間に挟むこともできます。

えっ？

...。

...バレちゃいましたか？

<br />

<br />

<br />

initializeの`＠`。

これは`'@'.ord # => 64`ではなく、`'＠'.ord # => 65312`なんです...。

## AutoAttrSetの実装

実装です。

{% gist 6728411 %}

簡単に説明します。Class.newをオーバーライドして、そこで`set_instance_variables`というメソッドを呼びます。set_instance_variablesでは、initializeをMethodオブジェクト化して`Method#parameters`でその引数を取り出します。取り出した引数のうち特定のフォームを持ったものを対象として、`instance_variable_set`を使ってインスタンス変数をセットします。特定のフォームは`name_for_instance_variable?`のcandidatesに登録しておきます。ここでは、`'＠'`または`'at_'`で始まる名前が登録されています。

`at_`の例も示しておきます。

{% highlight ruby %}
class Point
  extend AutoAttrSet
  attr_accessor :x, :y
  def initialize(at_x, z, at_y, *rest)
    
  end
end

po = Point.new(10, 20, 30)
po.x # => 10
po.y # => 30
po.instance_variables # => [:@x, :@y]
{% endhighlight %}

こんなもの書いてる暇があるなら、さっちゃんのコード読んでろって話ですが。


---


<p style='color:red'>=== Ruby関連電子書籍100円で好評発売中！ ===</p>

[M'ELBORNE BOOKS]({{ BASE_PATH }}/books/ "M'ELBORNE BOOKS")

<a href="{{ BASE_PATH }}/books/">
  <img src="/assets/images/2013/03/ruby_trivia_cover.png" alt="ruby_trivia" style="width:200px" />
</a>
<a href="{{ BASE_PATH }}/books/">
  <img src="/assets/images/2012/ruby_parallel_cover.png" alt="ruby_parallel" style="width:200px" />
</a>
<a href="{{ BASE_PATH }}/books/">
  <img src="/assets/images/2012/rack_cover.png" alt="rack" style="width:200px" />
</a>

