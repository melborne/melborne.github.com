---
layout: post
title: "チルダでRubyの式埋め込みをもっと便利に!?"
description: ""
category: 
tags: 
date: 2013-08-07
published: true
---
{% include JB/setup %}

Rubyでは文字列に式を埋め込めるという便利な機能があるよ。

{% highlight ruby %}
name = "Charlie"
job = :Teacher
account = 22360679

puts "#{name} is a #{job}.\nHis account is #{account}."

# >> Charlie is a Teacher.
# >> His account is 22360679.
{% endhighlight %}

でも、こういうときに埋め込み文字をシングルクォートなんかで強調したいってこと良くあるよね？

{% highlight ruby %}
puts "'#{name}' is a '#{job}'.\nHis account is '#{account}'."

# >> 'Charlie' is a 'Teacher'.
# >> His account is '22360679'.
{% endhighlight %}

これって、面倒くさくない？

そんなわけで...

こんな小ネタを...

{% highlight ruby %}
class Object
  def method_missing(m, *a, &b)
    m==:~ ? "'#{self}'" : super
  end
end
{% endhighlight %}

シングルクォートに代えて式の前に'~'(チルダ)を入れて...

{% highlight ruby %}
puts "#{~name} is a #{~job}.\nHis account is #{~account.inspect}."

# >> 'Charlie' is a 'Teacher'.
# >> His account is '22360679'.
{% endhighlight %}

数値のときにinspectしなきゃとかダサ...


久しぶりのブログ更新がこれじゃあねぇ...

----

関連記事：

[チルダがRubyのヒアドキュメントをもっと良くする](http://melborne.github.io/2012/04/27/ruby-heredoc-without-leading-whitespace/ "チルダがRubyのヒアドキュメントをもっと良くする")

[チルダがRubyカレーをもっと好きにさせる](http://melborne.github.io/2012/06/30/tilde-makes-curry-better/ "チルダがRubyカレーをもっと好きにさせる")


