---
layout: post
title: Rubyで友愛数を探す
tagline: Rubyでオイラープロジェクトを解こう！Problem21
date: 2009-01-27
comments: true
categories:
---


[Problem 21 - Project Eulerより](http://projecteuler.net/index.php?section=problems&id=21)
> 
> Let d(n) be defined as the sum of proper divisors of n (numbers less than n which divide evenly into n).
> If d(a) = b and d(b) = a, where a != b, then a and b are an amicable pair and each of a and b are called amicable numbers.
> For example, the proper divisors of 220 are 1, 2, 4, 5, 10, 11, 20, 22, 44, 55 and 110; therefore d(220) = 284. The proper divisors of 284 are 1, 2, 4, 71 and 142; so d(284) = 220.
> Evaluate the sum of all the amicable numbers under 10000.
> d(n)をnの真約数(nを割り切れるn以下の数字)の合計と定義しよう。
> d(a) = b and d(b) = a (ただしa != b)であるとき、aとbは友愛ペアであり、a、bそれぞれは友愛数と呼ばれる。
> 例えば、220の真約数は、1, 2, 4, 5, 10, 11, 20, 22, 44, 55および110であるから、d(220) = 284となる。284の真約数は、1, 2, 4, 71および142であるから、d(284) = 220となる。
> 10000未満の全ての友愛数の和を求めよ。


上の条件をそのまま素直に書いてみる
{% highlight ruby %}
 def d(n)
   (1...n).inject(0) { |sum, v| n%v == 0 ? sum + v : sum }
 end
 def sum_amicables(limit)
   (1...limit).inject(0) do |sum, a|
     (d(b = d(a)) == a and a != b) ? sum + a : sum
   end
 end
 t = Time.now
 sum_amicables 10000 # => 3xxxx
 Time.now - t # => 31.430755
{% endhighlight %}

やっぱりd(n)メソッドがちょっと遅い
ちょっとキレイでないけど
factorで因数を求めてから約数を求める
{% highlight ruby %}
 def d(i)
   f = factor(i)
   com = [1]
   (1...f.length).each do |i|
     com << f.combination(i).map { |e| e.inject(:*) }.uniq
   end
   com.flatten.inject(:+)
 end
 def factor(n)
   result = []
   (2..n).each do |i|
     while n % i == 0
       n /= i
       result << i
     end
     break if n == 1
   end
   result
 end
 def sum_amicables(limit)
   (1...limit).inject(0) do |sum, a|
     (d(b = d(a)) == a and a != b) ? sum + a : sum
   end
 end
 t = Time.now
 sum_amicables 10000 # => 3xxxx
 Time.now - t # => 5.993918
{% endhighlight %}
速度的には改善された
