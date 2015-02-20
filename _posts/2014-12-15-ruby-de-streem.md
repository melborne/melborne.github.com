---
layout: post
title: "Ruby de Streem"
description: ""
category: 
tags: 
date: 2014-12-15
published: true
---
{% include JB/setup %}

> のっぴきならない事情で暫くここを離れてたけど
> 
> 戻ってきたらMatzが新言語を作ってた
> 
> 僕がいないうちにRubyは捨てられてしまったの？
> 
> 僕が暫く目を離しているうちに世の中もMatzも変わってしまって
> 
> もうだれもRubyを愛さなくなってしまったの？
> 

------

[matz/streem](https://github.com/matz/streem "matz/streem")

# Streem - stream based concurrent scripting language

Streem is a concurrent scripting language based on a programming model
similar to shell, with influences from Ruby, Erlang and other
functional programming languages.

In Streem, a simple `cat` program looks like this:

{% highlight bash %}
STDIN | STDOUT
{% endhighlight %}

And a simple FizzBuzz will look like this:

{% highlight ruby %}
seq(100) | {|x|
  if x % 15 == 0 {
    "FizzBuzz"
  }
  else if x % 3 == 0 {
    "Fizz"
  }
  else if x % 5 == 0 {
    "Buzz"
  }
  else {
    x
  }
} | STDOUT
{% endhighlight %}

----

## Ruby de Streem

> でも
>
> 心配いらないよ、Ruby
> 
> もう僕が戻ってきたんだから
>
> 僕はここにいるよ
>



{% gist 4516e808dd4784981aef streem.rb %}


{% gist 4516e808dd4784981aef example.rb %}

ごめんなさいごめんなさい。

---

関連記事：

> [Rubyでパイプライン？](http://melborne.github.io/2014/03/05/filter-in-ruby/ "Rubyでパイプライン？")


