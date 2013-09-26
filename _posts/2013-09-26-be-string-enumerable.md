---
layout: post
title: "Rubyの文字列だってえにゅめらぶるしたい！"
description: ""
category: 
tags: 
date: 2013-09-26
published: true
---
{% include JB/setup %}

## Fixnumの場合

適当な初期値から連続する番号のリストを作りたいです。Rangeを配列展開するのが簡単そうです。

{% highlight ruby %}
st = 37 # 初期値
n = 30  # リストの長さ

(st...(st+n)).to_a # => [37, 38, 39, 40, 41, 42, 43, 44, 45, 46, 47, 48, 49, 50, 51, 52, 53, 54, 55, 56, 57, 58, 59, 60, 61, 62, 63, 64, 65, 66]

# または

[*st...(st+n)] # => [37, 38, 39, 40, 41, 42, 43, 44, 45, 46, 47, 48, 49, 50, 51, 52, 53, 54, 55, 56, 57, 58, 59, 60, 61, 62, 63, 64, 65, 66]
{% endhighlight %}

`Fixnum#next`は次の数を返すので、これを使ってもできそうです。

{% highlight ruby %}
st = 37 # 初期値
n = 30  # リストの長さ

n.times.map { st = st.next } # => [38, 39, 40, 41, 42, 43, 44, 45, 46, 47, 48, 49, 50, 51, 52, 53, 54, 55, 56, 57, 58, 59, 60, 61, 62, 63, 64, 65, 66, 67]
{% endhighlight %}

でも、`st = st.next`がやな感じです。しかも数字が１つずれてるし。ちょっと工夫が必要です。

{% highlight ruby %}
st = 37
n = 30

n.times.map { st.tap { st = st.next } } # => [37, 38, 39, 40, 41, 42, 43, 44, 45, 46, 47, 48, 49, 50, 51, 52, 53, 54, 55, 56, 57, 58, 59, 60, 61, 62, 63, 64, 65, 66]
{% endhighlight %}

んー。結果はいいですが、さらにやな感じが増しました。

もっとマシな方法はないですか。

そう、`Enumerator`ですね。

{% highlight ruby %}
st = 37
st = (st..1.0/0).to_enum
st # => #<Enumerator: 37..Infinity:each>

n.times.map { st.next } # => [37, 38, 39, 40, 41, 42, 43, 44, 45, 46, 47, 48, 49, 50, 51, 52, 53, 54, 55, 56, 57, 58, 59, 60, 61, 62, 63, 64, 65, 66]
{% endhighlight %}

1.0/0はInfinity（浮動小数点における正の無限大）を作ります。mapのブロックの中が非常にスッキリしました。数字のズレもなく、再代入もない。

Enumeratorを使う利点は、事前にその生成個数を決めなくていい点と、初期状態を復元できる点です。

{% highlight ruby %}
st = 37
st = (st..1.0/0).to_enum

n.times.map { st.next } # => [37, 38, 39, 40, 41, 42, 43, 44, 45, 46, 47, 48, 49, 50, 51, 52, 53, 54, 55, 56, 57, 58, 59, 60, 61, 62, 63, 64, 65, 66]

st.next # => 67
st.rewind
st.next # => 37

st.take(40) # => [37, 38, 39, 40, 41, 42, 43, 44, 45, 46, 47, 48, 49, 50, 51, 52, 53, 54, 55, 56, 57, 58, 59, 60, 61, 62, 63, 64, 65, 66, 67, 68, 69, 70, 71, 72, 73, 74, 75, 76]

st.take_while { |i| i < 48 } # => [37, 38, 39, 40, 41, 42, 43, 44, 45, 46, 47]

require 'prime'

st.lazy.select { |i| Prime.prime? i }.take(20).force # => [37, 41, 43, 47, 53, 59, 61, 67, 71, 73, 79, 83, 89, 97, 101, 103, 107, 109, 113, 127]
{% endhighlight %}

## Stringの場合

さて、本題にいきまして...。

先の例と同様に、文字列で、適当な初期値から連続する番号のリストを作りたいです。まずはRangeの配列展開で。

{% highlight ruby %}
st = "abc37"
ed = "abc66"
n = 30

(st..ed).to_a # => ["abc37", "abc38", "abc39", "abc40", "abc41", "abc42", "abc43", "abc44", "abc45", "abc46", "abc47", "abc48", "abc49", "abc50", "abc51", "abc52", "abc53", "abc54", "abc55", "abc56", "abc57", "abc58", "abc59", "abc60", "abc61", "abc62", "abc63", "abc64", "abc65", "abc66"]

# または

[*st..ed] # => ["abc37", "abc38", "abc39", "abc40", "abc41", "abc42", "abc43", "abc44", "abc45", "abc46", "abc47", "abc48", "abc49", "abc50", "abc51", "abc52", "abc53", "abc54", "abc55", "abc56", "abc57", "abc58", "abc59", "abc60", "abc61", "abc62", "abc63", "abc64", "abc65", "abc66"]
{% endhighlight %}

nから最後の番号を作るのが面倒なので、手抜きしました。

Stringも#nextを持っているので、同じようにやってみます。

{% highlight ruby %}
st = "abc37"
n = 30

n.times.map { st.tap { st = st.next } } # => ["abc37", "abc38", "abc39", "abc40", "abc41", "abc42", "abc43", "abc44", "abc45", "abc46", "abc47", "abc48", "abc49", "abc50", "abc51", "abc52", "abc53", "abc54", "abc55", "abc56", "abc57", "abc58", "abc59", "abc60", "abc61", "abc62", "abc63", "abc64", "abc65", "abc66"]
{% endhighlight %}

できましたが、mapのブロック内がやっぱりやな感じですね。

と、ここでStringにはFixnumにはない、`String#next!`（破壊的メソッド）があるのを思い出しました。これ使ってもう少しマシにできますか。

{% highlight ruby %}
st = "abc37"
n = 30

n.times.map { st.next! } # => ["abc67", "abc67", "abc67", "abc67", "abc67", "abc67", "abc67", "abc67", "abc67", "abc67", "abc67", "abc67", "abc67", "abc67", "abc67", "abc67", "abc67", "abc67", "abc67", "abc67", "abc67", "abc67", "abc67", "abc67", "abc67", "abc67", "abc67", "abc67", "abc67", "abc67"]
{% endhighlight %}

この結果に、びっくりしてる人いますか？なら、これ読んでみてください。面倒な人はタイトルだけでも覚えて下さい。

> [Rubyのエニュメレータ内での破壊行為は止めてください!](http://melborne.github.io/2011/12/15/Ruby-Enumerator/ "Rubyのエニュメレータ内での破壊行為は止めてください!")

## Stringでえにゅめらぶる

そんなわけで、文字列でも、効率的できれいなコードを書くために、エニュメレータに頼りたくなるという訳です。ところが、結果はこうです。

{% highlight ruby %}
st = "abc37".to_enum
n = 30

n.times.map { st.next } # => 

# ~> -:4:in `next': undefined method `each' for "abc37":String (NoMethodError)
{% endhighlight %}

<br />


そこで、分別のないモンキーパッチャーの出番です！

{% highlight ruby %}
module EnuString
  def to_enum
    Enumerator.new do |y|
      myself = self
      loop { y << myself; myself = myself.next }
    end
  end
end

String.send(:include, EnuString)

st = "abc37".to_enum
n = 30

n.times.map { st.next } # => ["abc37", "abc38", "abc39", "abc40", "abc41", "abc42", "abc43", "abc44", "abc45", "abc46", "abc47", "abc48", "abc49", "abc50", "abc51", "abc52", "abc53", "abc54", "abc55", "abc56", "abc57", "abc58", "abc59", "abc60", "abc61", "abc62", "abc63", "abc64", "abc65", "abc66"]
{% endhighlight %}

めでたし、めでたし。


