---
layout: post
title: "Rubyのinjectで逆ポーランド記法電卓を書くYO!"
description: ""
category: 
tags: [ruby, rpn]
date: 2012-06-19
published: true
---
{% include JB/setup %}

「{{ 4274068854 | amazon_link }}」を読んでます。この本のタイトルとカバーデザインはかなりミスリードですね！もしこの本を入門書と呼ぶのなら、僕の脳に相当の問題があるか、Haskellが相当に難解であるかの何れかと断定せざるを得ません。いや、おそらく問題は僕の脳にあるのでしょう。そうであれば安心です。プログラム言語はツールなのですから難解であってはなりませんからね。Rubyはアヒル言語ですから、知らないうちに僕の脳もすっかりアヒル脳になっていたのですね.. ミスリードだなんて言ってすいませんでしたm(__)m{% fn_ref 1 %}

さて、この本の第10章にHaskellによる「逆ポーランド記法電卓」の例が出ていました。例ではその実現に畳み込み演算が使われていたので、[前回記事](http://melborne.github.com/2012/06/18/i-am-inject-lover-too/ 'YOUたち!RubyでinjectしちゃいなYO!')にしたinjectを使ってRubyでこの電卓を書いてみます。

##逆ポーランド記法
逆ポーランド記法では演算子が数字の後にきます。

{% highlight bash %}
3 4 + # => 7
3 4 + 5 * # => 35
{% endhighlight %}

この演算をプログラムで実現するには、（１）数式を構成するトークンを先頭からスタックに入れていき、（２）演算子が出てきたところで、前の2つの数字を取り出して演算を実行し、（３）結果をスタックに戻す、という操作を繰り返せばいいです。

##Rubyのコード
RPNクラスを用意し、そのクラスメソッドrunで引数に渡した計算式を含む文字列に対する演算を実行するようにしましょう。次のようなイメージです。
{% highlight ruby %}
RPN.run("3 4 + 5 *") # => 35
{% endhighlight %}

受け取った文字列をトークンに分割し、injectのブロック内でcaseで処理を切り分けます。まずは四則演算に対応して。
{% highlight ruby %}
class RPN
  def self.run(exp)
    tokenize(exp).inject([]) do |m, token|
      case token
      when /^[-+*\/]$/
        m << m.pop(2).inject($&)
      when /^[\d.]+$/
        m << $&.to_f
      else
        raise ARgumentError, "operator `#{token}` not defined"
      end
    end.shift
  end

  def self.tokenize(s)
    s.split
  end
  private_class_method :tokenize
end

RPN.run("3 4 +") # => 7.0
RPN.run("3 4 + 5.5 *") # => 38.5
RPN.run("3 4 + 5 * 6 7 / -") # => 34.142857142857146
RPN.run("3 4 **") # => 
# ~> -:36:in `block in run': operator `**` not defined (ArgumentError)
{% endhighlight %}
case式では数字ならスタックmに挿入し、演算子ならスタックから2つの数字をpopして演算し、結果をスタックに挿入します。渡された式が文法的に正しいならinjectを出た後スタックには1つの値が残っているはずなので、それを結果としてshiftします。

べき乗(**)、log(ln)、sumにも対応します。

{% highlight ruby %}
class RPN
  def self.run(exp)
    tokenize(exp).inject([]) do |m, token|
      case token
      when /^[-+\/]|\*{1,2}$/
        m << m.pop(2).inject($&)
      when 'ln'
        m << Math.log(m.pop)
      when 'sum'
        m << m.inject(:+).tap{ m.clear }
      when /^[\d.]+$/
        m << $&.to_f
      else
        raise ArgumentError, "operator `#{token}` not defined"
      end
    end.shift
  end

  def self.tokenize(s)
    s.split
  end
  private_class_method :tokenize
end

RPN.run("3 4 +") # => 7.0
RPN.run("3 4 + 5.5 *") # => 38.5
RPN.run("3 4 + 5 * 6 7 / -") # => 34.142857142857146
RPN.run("3 4 **") # => 81.0
RPN.run("2.7 ln") # => 0.9932517730102834
RPN.run("1 2 3 4 5 sum 5 /") # => 3.0
{% endhighlight %}
いいですね！

少しだけリファクタして完成です。

{% highlight ruby %}
class RPN
  def self.run(exp)
    res = tokenize(exp).inject([]) { |m, token| m << evaluate(token, m) }

    raise(ArgumentError, "expression is not completed") unless res.size==1
    res.first
  end

  def self.tokenize(s)
    s.split
  end

  def self.evaluate(token, m)
    case token
    when /^[-+\/]|\*{1,2}$/
      m.pop(2).inject($&)
    when 'ln'
      Math.log(m.pop)
    when 'sum'
      m.inject(:+).tap{ m.clear }
    when /^[\d.]+$/
      $&.to_f
    else
      raise ArgumentError, "operator `#{token}` not defined"
    end
  end
  private_class_method :tokenize, :evaluate
end

if __FILE__ == $0
  RPN.run("3 4 +") # => 7.0
  RPN.run("3 4 + 5.5 *") # => 38.5
  RPN.run("3 4 + 5 * 6 7 / -") # => 34.142857142857146
  RPN.run("3 4 **") # => 81.0
  RPN.run("2.7 ln") # => 0.9932517730102834
  RPN.run("1 2 3 4 5 sum 5 /") # => 3.0
end
{% endhighlight %}

Rubyもなかなか簡潔ですよね！


[RPN — Gist](https://gist.github.com/2948894 'RPN — Gist')

----
{{ 4274068854 | amazon_medium_image }}
{{ 4274068854 | amazon_link }} by {{ 4274068854 | amazon_authors }}

{% footnotes %}
  {% fn Haskellがわからず、悔しくてこういう文章を書いているのです。ごめんなさい。 %}
{% endfootnotes %}
