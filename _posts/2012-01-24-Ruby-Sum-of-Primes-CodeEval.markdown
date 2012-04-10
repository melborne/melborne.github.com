---
layout: post
title: RubyでSum of Primesを解く-CodeEval
date: 2012-01-24
comments: true
categories:
---

##RubyでSum of Primesを解く-CodeEval
これもEnumeratorを使って

最初の1000個の素数の合計

{% gist 1656338 sum_prime.rb %}


id:rochefortさんのを見たら
{% highlight ruby %}
def prime?(n)
  !(2..n/2).any? { |i| (n%i).zero? }
end
{% endhighlight %}
となっていてなるほどー!

##RubyでFizz Buzzを解く -CodeEval
CodeEvalに登録したのでやって見たよ
Proc#curryを使って

与えられた整数でFizzBuzz

{% gist 1656338 fizz_buzz.rb %}
