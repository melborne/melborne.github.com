---
layout: post
title: "Rubyに存在演算子は存在するの？"
description: ""
category: 
tags: 
date: 2012-10-29
published: true
---
{% include JB/setup %}


CoffeeScriptには`存在演算子（Existential Operator）`なるものがあるそうだよ。これは変数が存在するかをチェックするものなんだ。

{% highlight coffeescript %}
# coffee
charlie = {name:'Charlie', age:50}

charlie.age -= 30 if timeMachine?
charlie.age # =>  50

timeMachine = 'YES'
charlie.age -= 30 if timeMachine?
charlie.age # =>  20

charlie.hobby ?= 'programming'

charlie.hobby # =>  programming
{% endhighlight %}

Rubyにはそのような演算子は無いけれども、`nil?`とか`defined?`とか`||=`とかを使えば同等のことができるよね。
{% highlight ruby %}
# ruby
User = Struct.new(:name, :age, :hobby)
charlie = User['Charlie', 50]

charlie.age -= 30 if defined?(time_machine)
charlie.age # => 50

time_machine = 'YES'
charlie.age -= 30 if defined?(time_machine)
charlie.age # => 20

charlie.hobby ||= 'programming'
charlie.hobby # => "programming"
{% endhighlight %}

でもね、CoffeeScriptの存在演算子はもう一歩先を行ってるんだよ。なんてったってプロパティチェーンの中でも使えちゃうんだから。
{% highlight coffeescript %}
# coffee
charlie.scores = {math:35, english:78, music:60}

charlie.scores?.math # => 35

liz = {name:'Liz', age:17}

liz.scores.math # => TypeError: Cannot read property 'math' of undefined
liz.scores?.math # => undefined
{% endhighlight %}
lizの結果を見てもらえばわかると思うけど、存在演算子を使えば`scores`が未定義でもエラーを吐かずに、出力を一つ前（scores）の返り値に戻せるんだ。


残念ながらRubyにはこれができる演算子やメソッドは無いんだよ。だから普通はみんなエラーを避けるため、途中結果を一旦変数に取って場合分けしてると思うんだ。
{% highlight ruby %}
# ruby
User = Struct.new(:name, :age, :hobby, :scores)
charlie = User['Charlie', 50]

charlie.scores = { math:35, english:78, music:60 }

charlie.scores[:math] # => 35

liz = User['Liz', 17]

liz.scores[:math]
# ~> -:17:in `<main>': undefined method `[]' for nil:NilClass (NoMethodError)

liz_scores = liz.scores
liz_scores ? liz_scores[:math] : nil # => nil
{% endhighlight %}

でも、それってスマートじゃないよね？悲しいよね？


## Rubyに存在メソッドを定義する

そんなわけで...

CoffeeScriptの存在演算子に対抗すべく、Rubyで存在メソッド`Object#al?`っていうのを考えてみたよ。`all?`じゃないからね。

{% highlight ruby %}
class Object
  def al?
    return !!self unless block_given?
    yield self if self
  end
end

charlie.scores.al?{ |sco| sco[:math] } # => 35
liz.scores.al? { |sco| sco[:math] } # => nil

charlie.scores.al? # => true
liz.scores.al? # => false
{% endhighlight %}
`al?`はブロックを取るよ。で、receiverがnilならnilを返すけど、そうでなければreceiverを引数にとってブロックの実行結果を返すんだ。ブロックがなければブール値を返すよ。

aliasもあるよ。

{% highlight ruby %}
# encoding: UTF-8
alias :ある? :al?

charlie.scores.ある?{ |sco| sco[:math] } # => 35
liz.scores.ある? { |sco| sco[:math] } # => nil
{% endhighlight %}
日本人のみんなはこっちを使えばいいと思うよ。

Ruby2.0で採用間違いなし！と思うんだけど、みんなはどう思う？


## Object#tapを使う
って、これじゃネタ止まりだよね..僕らにはもっと現実的な解決策が必要だよ。

で、いい方法を思いついたんだよ。

`Object#tap`を使うんだ。そう僕らには`tap`があるんだよ！

{% highlight ruby %}
charlie.scores.tap{ |s| break s[:math] if s } # => 35
liz.scores.tap{ |s| break s[:math] if s } # => nil
{% endhighlight %}

scoresがあるときはbreakでブロックの結果を返すけど、scoresがnilのときはtapの挙動通りブロックの結果は無視されてsocoresつまりnilが返るよ。ブロック中の`break`がミソだよ。

ちょっと冗長だけど、条件分岐よりはいいよね？

もちろん`tap+break`は、存在確認以外のことにも使えるよ。

{% highlight ruby %}
charlie.name.tap { |n| break n.center(10, '*').upcase if n.size < 7 } # => "Charlie"
liz.name.tap { |n| break n.center(10, '*').upcase if n.size < 7 } # => "***LIZ****"
{% endhighlight %}
この例では名前の長さを分岐の条件にしてるよ。

やっぱりRubyはおもしろいよね。

知ってるネタだったら、ゴメンね。

----

(追記：2012-10-31)

@yayuguさんにブコメで、RailsのActiveSupportに`Object#try`, `NilClass#try`なるものがあることを教えてもらったよ。

{% highlight ruby %}
require "active_support/all"

charlie.scores.try { |s| s[:math] } # => 35
liz.scores.try { |s| s[:math] } # => nil
{% endhighlight %}

折角だから実装も見てみるね。

{% highlight ruby %}
class Object
  def try(*a, &b)
    if a.empty? && block_given?
      yield self
    else
      __send__(*a, &b)
    end
  end
end

class NilClass
  def try(*args)
    nil
  end
end
{% endhighlight %}
NilClass#nilの実装がなんとも言えないねー。

`Object#try`では引数渡しもできるようになってるんだね。

{% highlight ruby %}
charlie.scores.try(:[], :math) # => 35
liz.scores.try(:[], :math) # => nil
{% endhighlight %}
その場合は`send`に移譲するから引数は必須だよ。

一方、Object#al?ではCoffeeScriptの存在演算子同様、無引数の場合はBool判定するから、この部分の挙動がちょっと違うんだ。
{% highlight ruby %}
class Object
  def al?
    return !!self unless block_given?
    yield self if self
  end
end

charlie.scores.al?{ |sco| sco[:math] } # => 35
liz.scores.al? { |sco| sco[:math] } # => nil

charlie.scores.al? # => true
liz.scores.al? # => false
{% endhighlight %}

`try`にもこの機能があっていいように思うんだけどどうなのかな。

----

{{ 4152090901 | amazon_medium_image }}
{{ 4152090901 | amazon_link }} by {{ 4152090901 | amazon_authors }}

