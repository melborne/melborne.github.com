---
layout: post
title: "どうやらRubyはPerlにマージされたそうですよ。"
tagline: "Rubyの条件分岐をメソッド化する"
description: ""
category: 
tags: 
date: 2013-04-01
published: true
---
{% include JB/setup %}

変数の値が真か偽で制御を分岐する場合、Rubyでは普通「**if-else**」を使います。

{% highlight ruby %}
truth = "ruby is now twenty years old."
lie = "ruby was merged with perl."

april_first = true

ruby_status =
  if april_first
    lie
  else
    truth
  end

ruby_status # => "ruby was merged with perl."
{% endhighlight %}


条件分岐で返す式が短い場合、条件演算子「**? : **」もよく使われています。

{% highlight ruby %}
ruby_status = april_first ? lie : truth

ruby_status # => "ruby was merged with perl."
{% endhighlight %}


しかしこれらの制御構造にはそれらが制御構造であるがゆえの欠点があります。

それは、そのままではメソッドチェーンにちょっと乗せづらいということです。

{% highlight ruby %}
ruby_status = begin
  if april_first
    lie
  else
    truth
  end
end.capitalize

ruby_status # => "Ruby was merged with perl."

ruby_status = (april_first ? lie : truth).capitalize

ruby_status # => "Ruby was merged with perl."
{% endhighlight %}

<br />

そんなわけで...

<br />

条件分岐をメソッド化した「**_?**」メソッドというものを考えてみました。

{% highlight ruby %}
[true, false, nil].each do |obj|
  obj.instance_eval do
    define_singleton_method(:_?) do |*args, &blk|
      arg = args[obj ? 0 : 1]
      unless arg.nil?
        arg
      else
        blk ? blk[self] : self
      end
    end
  end
end
{% endhighlight %}

**true**, **false**, **nil**の各オブジェクトに**_?**メソッドを定義しています。このメソッドの第１引数にはselfがtrueのときに返す値を、第２引数にはselfがfalseのときに返す値を渡します。

先の例を_?メソッドを使って書き換えてみます。

{% highlight ruby %}
truth = "ruby is now twenty years old."
lie = "ruby was merged with perl."

april_first = true

ruby_status = april_first._?(lie, truth).capitalize

ruby_status # => "Ruby was merged with perl."

april_first = false

ruby_status = april_first._?(lie, truth).capitalize

ruby_status # => "Ruby is now twenty years old."
{% endhighlight %}



_?はブロックを取ることができ、手続きを返したいときはブロックで実現します。ブロック引数にはselfが渡るので、ブロックの中で条件分岐して手続きを書きます。ちょっとダサいですけど。

{% highlight ruby %}
april_first = true

april_first._? do |bool|
  if bool
    puts "*" * lie.size
    puts lie.upcase
    puts "*" * lie.size
  else
    puts "#" * truth.size
    puts truth.upcase
    puts "#" * truth.size
  end
end

# >> **************************
# >> RUBY WAS MERGED WITH PERL.
# >> **************************
{% endhighlight %}

ということで、どうやらRubyはPerlにマージされたそうですよ。

今年もどうぞよろしくお願いしますm(__)m


