---
layout: post
title: Rubyで三角形の最大ルートを求める
tagline: Rubyでオイラープロジェクトを解こう！Problem18
date: 2009-01-25
comments: true
categories:
---


[Problem 18 - Project Eulerより](http://projecteuler.net/index.php?section=problems&id=18)
 
> By starting at the top of the triangle below and moving to adjacent numbers on the row below, the maximum total from top to bottom is 23.
>
>        <span style="color:#FF0000;">3</span>
>
>      <span style="color:#FF0000;">7</span> 5
>
>    2 <span style="color:#FF0000;">4</span> 6
>
>  8 5 <span style="color:#FF0000;">9</span> 3
>
> That is, 3 + 7 + 4 + 9 = 23.
>
> Find the maximum total from top to bottom of the triangle below:
>
> 次の三角形の頂点から始めて、隣接するその下の列の番号に移動していく場合、頂点から底辺までの合計の最大値は23である。
>
> つまり、3 + 7 + 4 + 9 = 23である。
>
> 次の三角形の頂点から底辺までの合計の最大値を求めよ。


難しかったけど以下の方針でなんとか

1. 三角形のデータを二次元配列のデータとして読み込む。
1. 底辺の各点から頂点に向かってそれぞれ合計を再帰的に求める(route_sum)。
1. それらの合計から最大値を選ぶ(max_route)。

{% highlight ruby %}
data = <<DATA
75
95 64
17 47 82
18 35 87 10
20 04 82 47 65
19 01 23 75 03 34
88 02 77 73 07 63 67
99 65 04 28 06 16 70 92
41 41 26 56 83 40 80 70 33
41 48 72 33 47 32 37 16 94 29
53 71 44 65 25 43 91 52 97 51 14
70 11 33 28 77 73 17 78 39 68 17 57
91 71 52 38 17 14 91 43 58 50 27 29 48
63 66 04 68 89 53 67 30 73 16 69 87 40 31
04 62 98 27 23 09 70 98 73 93 38 53 60 04 23
DATA
 TRI = data.split(/\n+/).map { |line| line.split(/\s+/).map { |e| e.to_i } }
 def max_route
   ans = []
   lev = TRI.length
   lev.times do |n|
     ans << route_sum(lev-1, n)
   end
   ans.max
 end
 def route_sum(lev, x)
   return TRI[0][0] if lev == 0
   return 0 if x < 0 or x > lev
   [route_sum(lev-1, x-1), route_sum(lev-1, x)].max + TRI[lev][x]
 end
 max_route2 # => 10xx
{% endhighlight %}

Euler Projectのフォーラムで
三角形の上から攻められることを知って愕然とする
そのほうがずっとエレガントだ

上から攻める版に書き直す
{% highlight ruby %}
data = <<DATA
75
95 64
17 47 82
18 35 87 10
20 04 82 47 65
19 01 23 75 03 34
88 02 77 73 07 63 67
99 65 04 28 06 16 70 92
41 41 26 56 83 40 80 70 33
41 48 72 33 47 32 37 16 94 29
53 71 44 65 25 43 91 52 97 51 14
70 11 33 28 77 73 17 78 39 68 17 57
91 71 52 38 17 14 91 43 58 50 27 29 48
63 66 04 68 89 53 67 30 73 16 69 87 40 31
04 62 98 27 23 09 70 98 73 93 38 53 60 04 23
DATA
 TRI = data.split(/\n+/).map { |line| line.split(/\s+/).map { |e| e.to_i } }
 def max_route(lev, x)
   return TRI[lev][x] if lev == TRI.length-1
   [max_route(lev+1, x), max_route(lev+1, x+1)].max + TRI[lev][x]
 end
 max_route(0, 0) # => 10xx
{% endhighlight %}
