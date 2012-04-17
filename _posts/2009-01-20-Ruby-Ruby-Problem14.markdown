---
layout: post
title: Rubyで最長の数列を探す
tagline: Rubyでオイラープロジェクトを解こう！Problem14
date: 2009-01-20
comments: true
categories:
---


[Problem 14 - Project Eulerより](http://projecteuler.net/index.php?section=problems&id=14)
> 
> The following iterative sequence is defined for the set of positive integers:
> n → n/2 (n is even)
> n → 3n + 1 (n is odd)
> Using the rule above and starting with 13, we generate the following sequence:
> 13  40  20  10  5  16  8  4  2  1
> It can be seen that this sequence (starting at 13 and finishing at 1) contains 10 terms. Although it has not been proved yet (Collatz Problem), it is thought that all starting numbers finish at 1.
> Which starting number, under one million, produces the longest chain?
> NOTE: Once the chain starts the terms are allowed to go above one million.
> 正の整数の組に関して、次の反復数列条件を定義する。
> n →  n/2 (nが偶数のとき)
> n → 3n + 1 (nが奇数のとき)
> このルールを使い13から始めると、次の数列が作られる。
> 13  40  20  10  5  16  8  4  2  1
> 13から始まり1で終わるこの数列は10の項を含むということがわかるだろう。いまだ証明されていないが(コラッツ問題)、如何なる数字で始まっても1で終わると考えられる。
> 100万未満で、どの数字から始まったものが最長の連鎖を作るか。
> 注釈：連鎖が開始されたら項が100万を超えることはかまわない。


方針：

1. 数列はその終了条件がわかっているので再帰を使う
1. 各開始数と数列の長さをハッシュでペアにして持つ
1. その中から最長のものの開始数を抽出する

{% highlight ruby %}
 def longest_chain(range)
   pair = {}
   range.each do |n|
     pair[n] = sequence(n).length
   end
   pair.rassoc(pair.values.max).first
 end
 def sequence(start)
   return [1] if start == 1
   if start.even?
     sequence(start / 2).unshift(start)
   else
     sequence(3 * start + 1).unshift(start)
   end
 end
 t = Time.now
 longest_chain 1...1_000_000 # => 837799
 Time.now - t # => 95.898332
{% endhighlight %}
ちょっと時間が掛かります…
