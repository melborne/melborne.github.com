---
layout: post
title: Rubyで最小公倍数を求める
tagline: Rubyでオイラープロジェクトを解こう！Problem5
date: 2009-01-15
comments: true
categories:
---


[Problem 5 - Project Eulerより](http://projecteuler.net/index.php?section=problems&id=5)
> 
> 2520 is the smallest number that can be divided by each of the numbers from 1 to 10 without any remainder.
> What is the smallest number that is evenly divisible by all of the numbers from 1 to 20?
> 2520は1から10の各数字で割り切れる数の中で最小のものである。
> 同様に1から20の全ての数字で割り切れる最小の数は何か。


素直に20より大きい数字を順に1から20で割って
割り切れるものを見つける
{% highlight ruby %}
 def find_divisible(max)
   n = max
   loop do
     break n if divisible_all?(n, max)
     n += 1
   end
   n
 end
 def divisible_all?(number, max=10)
   1.upto(max) do |n|
     return false if number.modulo(n) != 0
   end
   true
 end
 t = Time.now
 find_divisible(20) # => 232792560
 Time.now - t # => 504.792946
{% endhighlight %}
500秒！
遅すぎる！
別のやり方ないかな

全ての数で割り切れるというのは…
要するに最小公倍数のことだよね？

[最小公倍数](http://ja.wikipedia.org/wiki/%E6%9C%80%E5%B0%8F%E5%85%AC%E5%80%8D%E6%95%B0) - Wikipediaより
> 
> 二つの整数に対して、どちらの倍数にもなっている最小の自然数をいう。

じゃあその求め方は？
> 
> 最小公倍数の計算には、最大公約数 GCD (Greatest Common Divisor) を用いて行う。どちらも 0 でない整数 a, b に対して、最小公倍数は、最大公約数 gcd(a, b) を用いて、
> ![image](http://img.f.hatena.ne.jp/images/fotolife/k/keyesberry/20090115/20090115082304.png)

> 二つの数に限らず、より多くの数の最小公倍数を求めたい場合は、上記のlcm関数を入れ子にすればよい。

なるほどなるほど
じゃあこれを入れ子にして
1から20の全てを求めればいいんだな
最大公約数は割り算を繰り返せば求められそうだ

最小公倍数を使った版
{% highlight ruby %}
 def find_divisible(max)
   case max
   when 2
     lcm(1, 2)
   else
     lcm(find_divisible(max-1), max)
   end
 end
 def lcm(a, b)
   a * b / gcd(a, b)
 end
 def gcd(a, b)
   a, b = b, a if a < b
   return a if b == 0
   _mod = a.modulo(b)
   if _mod == 0
     b
   else
     gcd(b, _mod)
   end
 end
 t = Time.now
 find_divisible 20 # => 232792560
 Time.now - t # => 0.000371
{% endhighlight %}
断然速いぞ！

Rubyのリファレンスをよく見たら…
Rationalという便利なライブラリーがあったのですね
{% highlight ruby %}
require "rational"
def find_divisible(max)
  case max
  when 2
    2.lcm(1)
  else
    max.lcm(find_divisible(max-1))
  end
end
find_divisible 20 # => 232792560
{% endhighlight %}
あれ？Ruby1.9ではrequireも不要みたいな…
