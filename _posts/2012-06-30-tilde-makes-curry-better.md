---
layout: post
title: "チルダがRubyカレーをもっと好きにさせる"
description: ""
category: 
tags: [ruby, proc, curry]
date: 2012-06-30
published: true
---
{% include JB/setup %}

`Proc#curry`は関数（正確にはProcオブジェクト）をカリー化するためのメソッドです。「**カリー化**」とは、複数の引数を取る関数に対して、一度にその一部ずつ引数を取れるようにすることです。関数に一部の引数を渡すことを部分適用といいます。
{% highlight ruby %}
multi = ->x,y{ x * y }.curry # => #<Proc:0x0000010109ae00 (lambda)>

multi_by2 = multi[2] # => #<Proc:0x0000010109a928 (lambda)>
multi_by5 = multi[5] # => #<Proc:0x0000010109a478 (lambda)>

[*1..10].map { |i| multi_by2[i] } # => [2, 4, 6, 8, 10, 12, 14, 16, 18, 20]
[*1..10].map { |i| multi_by5[i] } # => [5, 10, 15, 20, 25, 30, 35, 40, 45, 50]
{% endhighlight %}
この例ではカリー化したmultiオブジェクトに2を部分適用して`multi_by2`を、5を部分適用して`multi_by5`をそれぞれ生成しています。つまり関数をカリー化すると、一つの関数から複数の関数を生成できるようになるのです。ステキです。DRYです。

Haskellでは関数はもともとカリー化されているそうです。おしゃれです。食べたいです。Rubyではカリー化できるのはProcオブジェクトに限られており、しかも明示的に`Proc#curry`を呼ぶ必要があります。残念です。悲しいです。

そこでせめてこの呼び出しの抵抗感を少なくして、Rubyにおけるカリー化を促進するために、`Proc#~`を考えてみましたよ！
{% highlight ruby %}
class Proc
  alias :~ :curry
end
{% endhighlight %}
以上。

...

これにより先のmultiは次のように書けます。
{% highlight ruby %}
multi = ~->x,y{ x * y }
{% endhighlight %}
これでRubyでも関数がもともとカリー化されていたように見えますね！


最後に、Proc#~を使ったFizzBuzzの例を。
{% highlight ruby %}
def fizzbuzzize(i)
  mod_zero = ~->base,n{ n.%(base).zero? }
  case i
  when mod_zero[15] then 'FizzBuzz'
  when mod_zero[3]  then 'Fizz'
  when mod_zero[5]  then 'Buzz'
  else i
  end
end

[*1..100].map { |i| fizzbuzzize i } # => [1, 2, "Fizz", 4, "Buzz", "Fizz", 7, 8, "Fizz", "Buzz", 11, "Fizz", 13, 14, "FizzBuzz", 16, 17, "Fizz", 19, "Buzz", "Fizz", 22, 23, "Fizz", "Buzz", 26, "Fizz", 28, 29, "FizzBuzz", 31, 32, "Fizz", 34, "Buzz", "Fizz", 37, 38, "Fizz", "Buzz", 41, "Fizz", 43, 44, "FizzBuzz", 46, 47, "Fizz", 49, "Buzz", "Fizz", 52, 53, "Fizz", "Buzz", 56, "Fizz", 58, 59, "FizzBuzz", 61, 62, "Fizz", 64, "Buzz", "Fizz", 67, 68, "Fizz", "Buzz", 71, "Fizz", 73, 74, "FizzBuzz", 76, 77, "Fizz", 79, "Buzz", "Fizz", 82, 83, "Fizz", "Buzz", 86, "Fizz", 88, 89, "FizzBuzz", 91, 92, "Fizz", 94, "Buzz", "Fizz", 97, 98, "Fizz", "Buzz"]
{% endhighlight %}


Melborne the Sticker of Tilde

----

関連記事：

[チルダがRubyのヒアドキュメントをもっと良くする](http://melborne.github.com/2012/04/27/ruby-heredoc-without-leading-whitespace/ 'チルダがRubyのヒアドキュメントをもっと良くする')

----
{{ '481634523X' | amazon_medium_image }}
{{ '481634523X' | amazon_link }} by {{ '481634523X' | amazon_authors }}

