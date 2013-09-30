---
layout: post
title: "RubyのStringにもInfinityを！"
description: ""
category: 
tags: 
date: 2013-09-30
published: true
---
{% include JB/setup %}

少し前に、Fixnumに対抗してStringを「**えにゅめらぶる**」する暴挙に出たのです。つまりFixnumで、

{% highlight ruby %}
st = 37
st = (st..1.0/0).to_enum
st # => #<Enumerator: 37..Infinity:each>

n.times.map { st.next } # => [37, 38, 39, 40, 41, 42, 43, 44, 45, 46, 47, 48, 49, 50, 51, 52, 53, 54, 55, 56, 57, 58, 59, 60, 61, 62, 63, 64, 65, 66]
{% endhighlight %}

とできるのが羨ましくてStringで、

{% highlight ruby %}
module EnuString
  def to_enum
    Enumerator.new do |y|
      myself = self
      loop { y << myself; myself = myself.next }
    end
  end
end

String.send(:include, EnuString)

st = "abc37".to_enum
n = 30

n.times.map { st.next } # => ["abc37", "abc38", "abc39", "abc40", "abc41", "abc42", "abc43", "abc44", "abc45", "abc46", "abc47", "abc48", "abc49", "abc50", "abc51", "abc52", "abc53", "abc54", "abc55", "abc56", "abc57", "abc58", "abc59", "abc60", "abc61", "abc62", "abc63", "abc64", "abc65", "abc66"]
{% endhighlight %}

めでたし、めでたし。


と、やったのです。

> [Rubyの文字列だってえにゅめらぶるしたい！](http://melborne.github.io/2013/09/26/be-string-enumerable/ "Rubyの文字列だってえにゅめらぶるしたい！")

そうしたら「**さっちゃん**」こと@ne_sachirou殿より、こうツッコミが。

![Alt title]({{ site.url }}/assets/images/2013/09/tw_ne_sachirou1.png)

> [Twitter / ne_sachirou: .｡oO(to_enumじゃないのでto_enumと云ふ名前 ...](https://twitter.com/ne_sachirou/status/383727134511882240 "Twitter / ne_sachirou: .｡oO(to_enumじゃないのでto_enumと云ふ名前 ...")

鋭い指摘です。対話はこう続きます。

![Alt title]({{ site.url }}/assets/images/2013/09/tw_ne_sachirou2.png)

さっちゃんは本当に残酷ですが、芸人魂に火を付ける天才かも...。

そんなわけでこの記事を上げてみます（結果はあまり期待できない）。

---

## String::INFINITY

遂に、`String::INFINITY`というものを発見しまして...。

{% highlight ruby %}
String::INFINITY # => Infinity
{% endhighlight %}

これを使って、こういうことができるようになりました。

{% highlight ruby %}
str = Range.new('abc37', String::INFINITY).to_enum # => #<Enumerator: #<Enumerator::Generator:0x007faadc04be40>:each>

n = 30

n.times.map { str.next } # => ["abc37", "abc38", "abc39", "abc40", "abc41", "abc42", "abc43", "abc44", "abc45", "abc46", "abc47", "abc48", "abc49", "abc50", "abc51", "abc52", "abc53", "abc54", "abc55", "abc56", "abc57", "abc58", "abc59", "abc60", "abc61", "abc62", "abc63", "abc64", "abc65", "abc66"]
{% endhighlight %}

Fixnumと同じように、Rangeの最大値にInfinityをセットすることで無限文字列のRangeが作られます。

`Range.new`がお好みでない、ということなら次のようにします。

{% highlight ruby %}
str = r('abc37', String::INFINITY).to_enum # => #<Enumerator: #<Enumerator::Generator:0x007faadc04be40>:each>
{% endhighlight %}

まあこれはただのエイリアスです。

{% highlight ruby %}
def r(first, last)
  Range.new(first, last)
end
{% endhighlight %}

で、当然の疑問として、

「リテラルはどうした」ということです。やってみましょう。

{% highlight ruby %}
str = ('abc37'..String::INFINITY) # => 
# ~> -:67:in `<main>': bad value for range (ArgumentError)
{% endhighlight %}

orz...。

リテラルは`new`呼ばないんですね...。

## String::INFINITYの正体

まずはRangeのモンキーパッチを見ます。

{% highlight ruby %}
module RangeExtension
  def new(*args, &blk)
    obj = allocate
    obj.send(:initialize, *args, &blk)
    obj
  rescue ArgumentError
    first, last, *_ = args
    if first.is_a?(String) && last==String::INFINITY
      EnuString.new(first)
    else
      super
    end
  end
end

Range.extend(RangeExtension)
{% endhighlight %}

`Range.new`でArgumentErrorが起きた場合、その第１および第２引数をチェックして、第１が文字列、第２が`String::INFINITY`の場合には、EnuStringオブジェクトなるものを生成しています。

EnuStringの実装を見てみます。

{% highlight ruby %}
class EnuString < String
  def to_enum
    Enumerator.new do |y|
      myself = self
      loop { y << myself; myself = myself.next }
    end
  end

  def to_s
    "#{self}..Infinity"
  end
end
{% endhighlight %}

これは前回のEnuStringモジュールと同じです。で、String::INFINITYの正体ですが...。

{% highlight ruby %}
String::INFINITY = Float::INFINITY
{% endhighlight %}

詐欺！

まあ、これで`('文字列'..String::INFINITY)`でArgumentErrorが起きて、めでたしめでたしと。


## 無限文字列Rangeリテラル

それにしても。

「リテラルが使えないのは、ネタとしてもどうか」という声が聞こえます...。


それで、新しいRangeリテラルを考えました。

通常のRangeリテラルでは範囲演算子`..`を使いますが、終端を含まないリテラルを作る場合はドットが３つの範囲演算子`...`を使います。

これにヒントを得て、終端が`INFINITY`であるRangeリテラルではドットが１つの範囲演算子`.`を使うようにしたのです。

{% highlight ruby %}
str = ('abc37'.INFINITY).to_enum
n = 30

n.times.map { str.next } # => ["abc37", "abc38", "abc39", "abc40", "abc41", "abc42", "abc43", "abc44", "abc45", "abc46", "abc47", "abc48", "abc49", "abc50", "abc51", "abc52", "abc53", "abc54", "abc55", "abc56", "abc57", "abc58", "abc59", "abc60", "abc61", "abc62", "abc63", "abc64", "abc65", "abc66"]
{% endhighlight %}

ドットが１つじゃ心もとないという人向けに、`._`（ドットアンダーバー）も用意しました。

{% highlight ruby %}
str = ('abc37'._INFINITY).to_enum
n = 30

n.times.map { str.next } # => ["abc37", "abc38", "abc39", "abc40", "abc41", "abc42", "abc43", "abc44", "abc45", "abc46", "abc47", "abc48", "abc49", "abc50", "abc51", "abc52", "abc53", "abc54", "abc55", "abc56", "abc57", "abc58", "abc59", "abc60", "abc61", "abc62", "abc63", "abc64", "abc65", "abc66"]
{% endhighlight %}

これらが今ひとつ範囲に見えないという人向けに、さらに`-`演算子も用意しています（この場合はString::INFINITYを使います）。

{% highlight ruby %}
str = ('abc37' - String::INFINITY).to_enum
n = 30

n.times.map { str.next } # => ["abc37", "abc38", "abc39", "abc40", "abc41", "abc42", "abc43", "abc44", "abc45", "abc46", "abc47", "abc48", "abc49", "abc50", "abc51", "abc52", "abc53", "abc54", "abc55", "abc56", "abc57", "abc58", "abc59", "abc60", "abc61", "abc62", "abc63", "abc64", "abc65", "abc66"]
{% endhighlight %}


...。

<br />


ええ、もうやめておきます。バレバレですから...。


{% highlight ruby %}
module StringExtension
  INFINITY = Float::INFINITY
  def INFINITY
    EnuString.new(self)
  end
  alias :_INFINITY :INFINITY

  def -(other)
    raise ArgumentError, 'bad value for range' unless other==INFINITY
    EnuString.new(self)
  end
end

String.send(:include, StringExtension)
{% endhighlight %}

単なるStringオブジェクトのメソッド呼び出しでしたm(__)m


それにしても、文字列にInfinityという概念はあり得るんでしょうかねぇ。


まあ、通常、`(a_string..'zzz'*100).to_enum`くらいにしとけば問題ないんでしょうけど。


---

<p style='color:red'>=== Ruby関連電子書籍100円で好評発売中！ ===</p>

[M'ELBORNE BOOKS]({{ BASE_PATH }}/books/ "M'ELBORNE BOOKS")

<a href="{{ BASE_PATH }}/books/">
  <img src="/assets/images/2013/02/ruby_object_cover.png" alt="ruby_object" style="width:200px" />
</a>
<a href="{{ BASE_PATH }}/books/">
  <img src="/assets/images/2013/04/ruby_tutorial_cover.png" alt="ruby_tutorial" style="width:200px" />
</a>
<a href="{{ BASE_PATH }}/books/">
  <img src="/assets/images/2013/03/ruby_trivia_cover.png" alt="ruby_trivia" style="width:200px" />
</a>
