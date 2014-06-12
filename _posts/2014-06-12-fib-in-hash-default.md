---
layout: post
title: "RubyのHashの秘密 その２"
tagline: "Yet Another Fibonacci in Ruby"
description: ""
category: 
tags: 
date: 2014-06-12
published: true
---
{% include JB/setup %}


{% highlight ruby %}
fib = Hash.new { |h,k| h[k] = h[k-1] + h[k-2] }
          .tap { |h| h.update 0=>0, 1=>1 }

t = Time.now
puts fib[10]
puts fib[100]
puts fib[1000]
puts "#{Time.now - t} sec"
# >> 55
# >> 354224848179261915075
# >> 43466557686937456435688527675040625802564660517371780402481729089536555417949051890403879840079255169295922593080322634775209689623239873322471161642996440906533187938298969649928516003704476137795166849228875
# >> 0.003656 sec
{% endhighlight %}

あるいは、

{% highlight ruby %}
fib = {0=>0,1=>1}
fib.default_proc = ->h,k{ h[k] = h[k-1] + h[k-2] }

fib[100] # => 354224848179261915075
{% endhighlight %}

とか。

有名か。

---

関連記事：

> [RubyのHashの秘密]({{ BASE_PATH }}/2014/06/11/secret-in-rubys-hash/ "RubyのHashの秘密")

