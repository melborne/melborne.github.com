---
layout: post
title: "落ちていくRubyistのためのMethopオブジェクト"
description: ""
category: 
tags: 
date: 2014-04-20
published: true
---
{% include JB/setup %}

RubyistはどんどんLazyになっていってmapにブロック渡すのも面倒という古今です。

こう書けばいいところを、

{% highlight ruby %}
%w(ybur si citsatnaf egaugnal).map { |str| str.reverse } # => ["ruby", "is", "fantastic", "language"]
{% endhighlight %}

こう書いて、

{% highlight ruby %}
%w(ybur si citsatnaf egaugnal).map(&:reverse) # => ["ruby", "is", "fantastic", "language"]
{% endhighlight %}

堕落していきます。

いや、mapだけじゃありません。ブロック取るメソッド全般にそれは蔓延しています。

{% highlight ruby %}
require "prime"

(1..100).select(&:prime?) # => [2, 3, 5, 7, 11, 13, 17, 19, 23, 29, 31, 37, 41, 43, 47, 53, 59, 61, 67, 71, 73, 79, 83, 89, 97]

%w(red yellow green white blue black).uniq(&:size) # => ["red", "yellow", "green", "blue"]
{% endhighlight %}

で、更に落ちていって引数を渡そうと試み、

{% highlight ruby %}
%w(ruby violin novel).map(&:+, 'ist') # => 
# ~> -:1: syntax error, unexpected ',', expecting ')'

(1..10).select(&:>, 5) # => 
# ~> -:1: syntax error, unexpected ',', expecting ')'
{% endhighlight %}

死ぬのです..。

## Methopクラス

そんな悲しい末路のあなたのため（僕のため？）に`Methopクラス`なるものを作ったのでなんとか堕落しつつも末永く生きていってください...。

{% highlight ruby %}
class Methop
  def self.[](method)
    new(method).build
  end

  def initialize(method)
    @method = method
  end
  
  def build
    ->arg, obj{ obj.send(@method, arg) }.curry
  end
end
{% endhighlight %}

`Methop.[]`がカリー化したProcオブジェクトを返します。

このように使います。

{% highlight ruby %}
Plus = Methop[:+]

%w(ruby violin novel).map(&Plus['ist']) # => ["rubyist", "violinist", "novelist"]

[1, 5, 10].map(&Plus[2]) # => [3, 7, 12]

Bigger = Methop[:>]

(1..10).select(&Bigger[5]) # => [6, 7, 8, 9, 10]
{% endhighlight %}

もちろん、直接渡してもいいです。

{% highlight ruby %}
(1..10).map(&Methop[:**][2]) # => [1, 4, 9, 16, 25, 36, 49, 64, 81, 100]

%w(red yellow green white blue black).select(&Methop[:match][/bl/]) # => ["blue", "black"]
{% endhighlight %}

いや、ブロック書こうよ..。

---

関連記事:

> [RubyのEnumerable#mapをもっと便利にしたいよ](http://melborne.github.io/2012/02/11/Ruby-Enumerable-map/ "RubyのEnumerable#mapをもっと便利にしたいよ")

---

<p style='color:red'>=== Ruby関連電子書籍100円〜で好評発売中！ ===</p>

[M'ELBORNE BOOKS]({{ BASE_PATH }}/books/ "M'ELBORNE BOOKS")

<a href="{{ BASE_PATH }}/books/">
  <img src="/assets/images/books/rack_cover.png" alt="rack" style="width:200px" />
</a>
<a href="{{ BASE_PATH }}/books/">
  <img src="/assets/images/books/ruby_pack8.png" alt="pack8" style="width:200px" />
</a>
<a href="{{ BASE_PATH }}/books/">
  <img src="/assets/images/books/ruby_parallel_cover.png" alt="ruby_parallel" style="width:200px" />
</a>

