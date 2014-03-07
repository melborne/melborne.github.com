---
layout: post
title: "DRY重患者RubyistのためのNullObjectパターン"
description: ""
category: 
tags: 
date: 2014-03-07
published: true
---
{% include JB/setup %}

以前私はRubyistはDRY症候群に掛かっているという記事を書いた。

> [RubyistたちのDRY症候群との戦い]({{ BASE_PATH }}/2013/09/27/auto-attr-set-in-ruby/ "RubyistたちのDRY症候群との戦い")

要約するとDRYじゃないコードを見るとRubyistはムズムズするといった内容だ。

前回私が書いた記事の中に、次のようなコードが出てきた。

{% highlight ruby %}
def run
  @methods.inject(@obj) do |mem, method|
    if custom = Filter.filters[method]
      custom.call(mem)
    else
      mem.send method
    end
  end
end
{% endhighlight %}

> [Rubyでパイプライン？]({{ BASE_PATH }}/2014/03/05/filter-in-ruby/ "Rubyでパイプライン？")

これは`@methods`に格納したメソッドを`@obj`に対し順次呼び出すが、同名のフィルタがFilter.filtersにあるのならそれをcallする、といったコードである。

あなたが重度のDRY症候群に掛かっているなら、このコードを見てムズムズしているに違いない。

これは一般に、「あるなら呼べ、そうでないならお前は黙ってろ」パターンと呼ばれている。以下も同様である。

{% highlight ruby %}
user.age if user

liz.score && liz.score[:math]
{% endhighlight %}

しかし、この頻出するパターンに対し患者たちは叫ぶ。「そうじゃない。僕たちはこう書きたいんだ。」

{% highlight ruby %}
def run
  @methods.inject(@obj) do |mem, method|
    Filter.filters[method].call(mem) || mem.send(method)
  end
end

user.age

liz.score[:math]
{% endhighlight %}

これを、「呼んで駄目なら黙ってろ」パターンという。

当然、Rubyからは次のような返事が帰ってくる。

{% highlight ruby %}
filter.rb:34:in `block in run': undefined method `call' for nil:NilClass (NoMethodError)
{% endhighlight %}

## 重患者のための即効性特効薬

そこで私は彼ら重度患者のために、21年の歳月を掛けてこの深刻なる問題について研究を重ねた。そして遂にその特効薬を開発したのだ。その名も「**NullObjectモジュール**」。

{% highlight ruby %}
module NullObject
  refine NilClass do
    def method_missing(m,*a,&b)
      self
    end
  end
end
{% endhighlight %}

患者たちは直ちに`using`を使ってあなたの体にNullObjectを注入せよ。

早期の回復を望んでいる。

私も一つ打っておくか...。

{% highlight ruby %}
using NullObject

User = Struct.new(:name, :age, :scores)

charlie = User.new('Charlie', 12)
charlie.scores = { math:35, english:78, music:60 }
charlie.scores[:math] # => 35

liz = User.new('Liz', 17)
liz.scores[:math] # => nil
{% endhighlight %}

---

ほんとうにヤバい人は、`naught`を使ってくださいm(__)m

> [avdi/naught](https://github.com/avdi/naught "avdi/naught")

---

関連記事：

> [Rubyに存在演算子は存在するの？](http://melborne.github.io/2012/10/29/existential-operator-in-ruby/ "Rubyに存在演算子は存在するの？")

