---
layout: post
title: Rubyのrepeat関数でフィボナッチ、トリボナッチ、テトラナッチ！
date: 2011-07-01
comments: true
categories:
tags: [ruby, functional]
---

１または複数の初期値に任意の関数を繰り返し適用して、その結果のリストを返す汎用関数repeatを定義しよう。
{% highlight ruby %}
def repeat(f, *args)
  Enumerator.new { |y| loop { y << (*args = f[*args]) } }
end
{% endhighlight %}
repeatは関数f{% fn_ref 1 %}とfの初期値となるargsを引数に取り、Enueratorオブジェクトを返す。

Enumeratorのブロックの中ではloopによってargsを関数fに適用した結果が、繰り返しyつまりEnumerable::Yielderオブジェクトに渡される。

次にフィボナッチだ。
{% highlight ruby %}
def fib
  ->a,b{ [b, a+b] }
end
{% endhighlight %}
fib関数は数列上の並んだ2つの数a,bを取り、次の並びとしてその上位の数bとa,bの和の組を返す。

さあ、今作成した2つの関数repeatとfibを使って、フィボナッチ数列の第20位までを求めよう。
{% highlight ruby %}
fibonacci = repeat(fib, 0, 1)
fibonacci.take(20).map(&:first) # => [1, 1, 2, 3, 5, 8, 13, 21, 34, 55, 89, 144, 233, 377, 610, 987, 1597, 2584, 4181, 6765]
{% endhighlight %}

もちろんfib関数は高階関数である必要はない。通常の関数でいい。
{% highlight ruby %}
def fibm(a, b)
  [b, a+b]
end
{% endhighlight %}

ただしこの場合は関数をオブジェクト化して、repeat関数に渡す必要がある。
{% highlight ruby %}
fibonacci = repeat(method(:fibm), 0, 1)
fibonacci.take(20).map(&:first) # => [1, 1, 2, 3, 5, 8, 13, 21, 34, 55, 89, 144, 233, 377, 610, 987, 1597, 2584, 4181, 6765]
{% endhighlight %}

次はトリボナッチだ。フィボナッチが前2項の和を取るのに対して、トリボナッチは前3項の和を取る。
{% highlight ruby %}
def tribo
  ->a,b,c{ [b, c, a+b+c] }
end
{% endhighlight %}

これをrepeat関数に渡して結果を得よう。
{% highlight ruby %}
tribonacci = repeat(tribo, 0, 0, 1)
tribonacci.take(20).map(&:first) # => [0, 1, 1, 2, 4, 7, 13, 24, 44, 81, 149, 274, 504, 927, 1705, 3136, 5768, 10609, 19513, 35890]
{% endhighlight %}

そしてテトラナッチだ、テトラナッチは前4項の和を取る。
{% highlight ruby %}
def tetra
  ->a,b,c,d{ [b, c, d, a+b+c+d] }
end
{% endhighlight %}

同じくrepeat関数に渡して結果を得よう。
{% highlight ruby %}
tetranacci = repeat(tetra, 0, 0, 0, 1)
tetranacci.take(20).map(&:first) # => [0, 0, 1, 1, 2, 4, 8, 15, 29, 56, 108, 208, 401, 773, 1490, 2872, 5536, 10671, 20569, 39648]
{% endhighlight %}

このように１つのrepeat関数を定義することで、フィボナッチ、トリボナッチ、テトラナッチの各数列を容易に導きだすことができた。

もちろん、repeat関数の応用範囲は数列の算出に留まらない。ニュートンラプソン法による平方根の算出は次のようになる。
{% highlight ruby %}
def sqrt
  ->n,x{ (x + n/x) / 2.0 }.curry
end
sqrt3 = repeat(sqrt[3], 1.0).take(10).last # => 1.7320508075688772
sqrt5 = repeat(sqrt[5], 1.0).take(10).last # => 2.23606797749979
sqrt7 = repeat(sqrt[7], 1.0).take(10).last # => 2.6457513110645907
{% endhighlight %}

____
(追記:2011-7-1)
さらに進んでEnumerable#repeatというのはどうだろうか

{% highlight ruby %}
module Enumerable
  def repeat
    x = self
    Enumerator.new { |y| loop { y << (x = yield x) }}
  end
end
{% endhighlight %}
Enumerable#repeatはselfに初期値を与え、ブロックで繰り返し適用する関数を定義する。

このメソッドを使った先の演算は以下のようになる。
{% highlight ruby %}
fibonacci = [0,1].repeat { |a, b|  [b, a+b] }
fibonacci.take(20).map(&:first) # => [1, 1, 2, 3, 5, 8, 13, 21, 34, 55, 89, 144, 233, 377, 610, 987, 1597, 2584, 4181, 6765]
tribonacci = [0,0,1].repeat { |a,b,c|  [b, c, a+b+c] }
tribonacci.take(20).map(&:first) # => [0, 1, 1, 2, 4, 7, 13, 24, 44, 81, 149, 274, 504, 927, 1705, 3136, 5768, 10609, 19513, 35890]
tetranacci = [0,0,0,1].repeat { |a, b, c, d|  [b, c, d, a+b+c+d] }
tetranacci.take(20).map(&:first) # => [0, 0, 1, 1, 2, 4, 8, 15, 29, 56, 108, 208, 401, 773, 1490, 2872, 5536, 10671, 20569, 39648]
sq5 = [5, 1.0].repeat { |n, x|  [n, (x + n/x) / 2.0] }
sq5.take(10).last.last # => 2.23606797749979
{% endhighlight %}

このほうがRubyっぽいかもしれない。

____
関連記事：

1. [Rubyでフィボナッチ、トリボナッチ、テトラナッチ！そして僕はヒトリボッチ(2009-01-11)]({{ site.url }}/2009/01/11/Ruby-2009-01-11/)
1. [Rubyを使って「なぜ関数プログラミングは重要か」を解読しよう！(その３)(2011-02-01)]({{ site.url }}/2011/02/01/Ruby-2011-02-01/)

参考： [トリボナッチ](http://ja.wikipedia.org/wiki/%E3%83%95%E3%82%A3%E3%83%9C%E3%83%8A%E3%83%83%E3%83%81%E6%95%B0)

{% footnotes %}
   {% fn 正確には[]メソッドでcallされる手続きオブジェクト %}
{% endfootnotes %}
