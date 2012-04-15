---
layout: post
title: Rubyで回文数を求める
tagline: Rubyでオイラープロジェクトを解こう！Problem4
date: 2009-01-14
comments: true
categories:
---


[Problem 4 - Project Eulerより](http://projecteuler.net/index.php?section=problems&id=4)
> 
> A palindromic number reads the same both ways. The largest palindrome made from the product of two 2-digit numbers is 9009 = 91  99.
> Find the largest palindrome made from the product of two 3-digit numbers.
> 回文数はどちらからでも同じに読める。2つの二桁の数の積からできる最大の回文数は9009 = 91 × 99である。
> 2つの三桁の数の積からできる最大の回文数を求めよ。


なんかスマートではありません…

（チョンボなところ）
1. 計算量を減らすため任意のlimitを使っている
1. 数字を文字列に変換して回文数を見つけている
{% highlight ruby %}
def max_palindrome_from(digits)
  base = 10 ** digits - 1
  limit = base >= 9999 ? base - 1000 : base - 10 ** (digits-1)
  a, b = base, base
  candidate = 0
  loop do
    multi = a * b
    if multi.to_s == multi.to_s.reverse
      if multi > candidate
        candidate = multi
      end
    end
    b -= 1
    case 
    when b <= limit
      b = base
      a -= 1
    when a <= limit
      break
    end
  end
  candidate
end
max_palindrome_from(3) # => 906609
{% endhighlight %}
