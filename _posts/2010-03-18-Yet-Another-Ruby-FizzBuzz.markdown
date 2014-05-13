---
layout: post
title: Yet Another Ruby FizzBuzz
date: 2010-03-18
comments: true
categories:
---


FizzBuzzはプログラムする人の最初のfilterプログラムだ{% fn_ref 1 %}
だからプログラムをするのならFizzBuzzを解かなきゃならない
こうしてプログラムする人の数だけFizzBuzzが生まれる
そして今日もまた別のFizzBuzzが生まれた
{% highlight ruby %}
module Enumerable
  def fizzbuzz(opt)
    map do |num|
      opt.to_a.sort_by{|i, _| -i}.push([1, num])
      .detect {|i, _| (num % i).zero?}.last
    end
  end
end
puts (1..100).fizzbuzz(3 => 'Fizz', 5 => 'Buzz', 15 => 'FizzBuzz')
{% endhighlight %}

{% footnotes %}
   {% fn [どうしてプログラマに・・・プログラムが書けないのか?](http://www.aoky.net/articles/jeff_atwood/why_cant_programmers_program.htm %}
{% endfootnotes %}
