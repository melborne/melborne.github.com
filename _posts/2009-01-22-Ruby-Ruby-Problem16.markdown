---
layout: post
title: Rubyで桁の合計を求める ～Rubyでオイラープロジェクトを解こう！Problem16
date: 2009-01-22
comments: true
categories:
---

##Rubyで桁の合計を求める ～Rubyでオイラープロジェクトを解こう！Problem16
[Problem 16 - Project Eulerより](http://projecteuler.net/index.php?section=problems&id=16)
> 
> [tex:2^{15} = 32768] and the sum of its digits is 3 + 2 + 7 + 6 + 8 = 26.
> What is the sum of the digits of the number [tex:2^{1000}]?
> [tex:2^{15} = 32768] の各桁の合計は 3 + 2 + 7 + 6 + 8 = 26である。
> [tex:2^{1000}]の各桁の合計はいくつか。


算数的でないけど
{% highlight ruby %}
 def sum_of_digits(n)
   n.to_s.split("").map { |s| s.to_i }.inject(:+)
 end
 sum_of_digits(2**1000) # => 1366
{% endhighlight %}

もう少し算数的に
{% highlight ruby %}
 def sum_of_digits(n)
   sum = 0
   begin
     n, b = n.divmod(10)
     sum += b
   end until n == 0 and b == 0
   sum
 end
 sum_of_digits(2**1000) # => 1366
{% endhighlight %}
##Rubyで最短ルート数を探す ～Rubyでオイラープロジェクトを解こう！Problem15
[Problem 15 - Project Eulerより](http://projecteuler.net/index.php?section=problems&id=15)
> 
> Starting in the top left corner of a 2×2 grid, there are 6 routes (without backtracking) to the bottom right corner.
> ![image](http://img.f.hatena.ne.jp/images/fotolife/k/keyesberry/20090121/20090121100543.gif)

> How many routes are there through a 20×20 grid?
> 2×2グリッドの左上の角からスタートした場合、右下の角に至るには6つのルートがある(引き返しはなし)。
> では20×20のグリッドではいくつのルートがあるか。


任意の交点に至るルートは
その真上と左隣の交点からだけなので
そこまでのルートの合計が
任意の交点に至るルートの数になる

交点横一列の要素数の配列を作り
ここに対応する交点に至るルート数を格納する
{% highlight ruby %}
 def routes(x,y)
   points = Array.new(x+1, 1)
   y.times do |n|
     (points.length).times do |i|
       next if i == 0
       points[i] = points[i-1] + points[i]
     end
   end
   points.last
 end
 routes(20,20) # => 137846528820
{% endhighlight %}

これは再帰でもいけそうだ
こちらのほうがエレガントだ
{% highlight ruby %}
 def routes(x, y)
   return 1 if x == 0 or y == 0
   routes(x, y-1) + routes(y, x-1)
 end
 routes(20, 20) # =>
{% endhighlight %}
でもいつまで待っても答えが出ない…