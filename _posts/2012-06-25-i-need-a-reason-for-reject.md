---
layout: post
title: "Ruby、断るならちゃんと理由を言ってよ！"
description: ""
category: 
tags: [ruby, false] 
date: 2012-06-25
published: true
---
{% include JB/setup %}

## 情報を返す問い掛けメソッド
Rubyでメソッド名の最後に`?`マークが付いたものがあります。この種のメソッドは問い掛けメソッドであり、通常、`true`または`false`のbool値を返すよう実装されています。
{% highlight ruby %}
12.even? # => true
list.empty? # => false
path.file? # => true
{% endhighlight %}

しかしその中には、単にbool値を返すだけでなく、その結果の情報を返してくれるメソッドもあります。例えば、`Encoding.compatible?`です。

{% highlight ruby %}
str = 'hello'
str.encoding # => #<Encoding:UTF-8>
str2 = "\xa1".force_encoding("iso-8859-1")
str2.encoding # => #<Encoding:ISO-8859-1>
str3 = "\xa1".force_encoding("euc-jp")
str3.encoding # => #<Encoding:EUC-JP>

Encoding.compatible?(str, str2) # => #<Encoding:ISO-8859-1>
Encoding.compatible?(str2, str3) # => nil

str4 = str + str2
str4.encoding # => #<Encoding:ISO-8859-1>
{% endhighlight %}
渡された２つの文字列にエンコーディング互換性がない場合はnilを返しますが、互換性がある場合には、それらが結合されたときの文字列のエンコーディング情報を文字列で返します。

それから、これは正確にはメソッドではありませんが、`defined?`があります。
{% highlight ruby %}
val, $val, VAL = 1, 2, 3
def meth
  :hi
end

defined? val # => "local-variable"
defined? $val # => "global-variable"
defined? VAL # => "constant"
defined? meth # => "method"
defined? 10 # => "expression"
defined? x # => nil
{% endhighlight %}
`defined?`は任意の式を受け取って、その式が定義されていなければnilを返しますが、定義されている場合には、その式の種類を返します。

Rubyでは、falseとnil以外はすべてがtrueを意味するので、これらのメソッドは依然としてbool値を返すメソッドとして、うまく機能するのです。

## falseのときに情報を返すメソッド
一方で、Rubyではメソッドがfalseを返すとき、同時に情報を受け渡すことができません。falseとnil以外のオブジェクトはすべてtrueと判断されてしまうからです。

一般社会では、通常、リクエストに対する答えが*NO*のときにこそ、その理由がほしいものです。例えば..

    「社長、昇格してほしんだけど。」 => 「駄目だ！」
    「俺と付き合ってよ？」 => 「はっ？」

そんな答えじゃ納得いきません。なぜダメなのか、断る理由こそが重要なのです！

----

そんな背景から、Rubyにおいてfalseが返されるときに、その理由などの情報を同時に返す方法を考えてみました ^ ^;


その方法とは...



`FalseClass#to_s`を使うのです{% fn_ref 1 %}！

FalseClass#to_sにはdefaultで文字列`"false"`がセットされていますが、使い道はあまり無さそうです。そこで、これを使って情報を渡せるように再定義します。例を示します。

{% highlight ruby %}
class Movie < Struct.new(:title, :r18)
  def can_watch?(who)
    return true unless r18
    (who.age > 18).tap { |bool| set_reason(bool, who) }
  end

  private
  def set_reason(bool, who)
    t = title
    bool.class.instance_eval { remove_method :to_s }
    bool.define_singleton_method(:to_s) { "`#{t}` is for adult. and you are #{who.age}." }
  end
end
{% endhighlight %}
Movieクラスは、引数に渡されたユーザがその映画を見ることができるかを尋ねる`can_watch?`メソッドを持っています。`can_watch?`メソッドは、その映画がR-18指定のとき、ユーザの年齢に応じてtrueまたはfalseを返します。それと同時に、その結果に応じて、その理由に係る文字列を返す`FalseClass#to_s`または`TrueClass#to_s`を再定義します。

さあ、このクラスを使って、`Charlie`と`Bob`が目的の映画を見られるか判断してみましょう。

{% highlight ruby %}
movie = Movie["しんちゃんのプロレスごっこ", true] # => #<struct Movie title="しんちゃんのプロレスごっこ", r18=true>

Person = Struct.new(:name, :age)

charlie = Person[:Charlie, 13]  # => #<struct Person name=:Charlie, age=13>
bob = Person[:Bob, 21] # => #<struct Person name=:Bob, age=21>

[charlie, bob].each do |p|
  puts "#{p.name}'s result:"
  if reason = movie.can_watch?(p)
    puts "  Yes, you can! (reason: #{reason})"
  else
    puts "  No, you can't! (reason: #{reason})"
  end
  puts
end

# >> Charlie's result:
# >>   No, you can't! (reason: `しんちゃんのプロレスごっこ` is for adult. and you are 13.)
# >> 
# >> Bob's result:
# >>   Yes, you can! (reason: `しんちゃんのプロレスごっこ` is for adult. and you are 21.)
# >> 
{% endhighlight %}

結果がfalseのときも、見事にその理由が返ってきました。これなら断られても納得できますね！

----

{{ 4166606824 | amazon_medium_image }}
{{ 4166606824 | amazon_link }} by {{ 4166606824 | amazon_authors }}

----
(追記:2012-6-28) サンプルコードにremove_methodを追加しました。

参考: [モジュールをオープンしてメソッドを上書きする - わからん](http://d.hatena.ne.jp/kitokitoki/20120627/p2 'モジュールをオープンしてメソッドを上書きする - わからん')

{% footnotes %}
  {% fn もちろんネタですよ.. %}
{% endfootnotes %}


