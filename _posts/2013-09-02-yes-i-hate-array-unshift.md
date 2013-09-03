---
layout: post
title: "ええ、ハッキリ言います。私はRubyのArray#unshiftが嫌いです。"
description: ""
category: 
tags: 
date: 2013-09-02
published: true
---
{% include JB/setup %}


Rubyで配列に要素を追加する場合は、通常`Array#push`または`#<<`を使います。

{% highlight ruby %}
numbers = [3, 4, 5]

numbers.push(6, 7, 8) # => [3, 4, 5, 6, 7, 8]
numbers << 9
numbers # => [3, 4, 5, 6, 7, 8, 9]
{% endhighlight %}

でも、時として要素を配列の先頭に追加したいことがあります。この場合は、`Array#unshift`を使います。

{% highlight ruby %}
numbers.unshift(0, 1, 2)
numbers # => [0, 1, 2, 3, 4, 5, 6, 7, 8, 9]
{% endhighlight %}

オブジェクト指向の宿命でしょうが、「左側に追加されるもの」が「右側に置かれる」この構文はハッキリ言ってイケテません。

ええ、私は`Array#unshift`が好きになれません。

<br />


で、私、このためにRubyに新しい構文考えましたよ！

こんなのです。

{% highlight ruby %}
_[-3, -2, -1] >> numbers

numbers # => [-3, -2, -1, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9]
{% endhighlight %}

どうですか？`_`（アンダースコア）が気になりますか？

{% highlight ruby %}
_ = Class.new(Array) do
  def >>(array)
    array.unshift(*self)
  end
end

_[-3, -2, -1] >> numbers

numbers # => [-3, -2, -1, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9]
{% endhighlight %}

ふざけたモンキーパッチばかりやってると、また怒られちゃうので、今日はこの辺で。

あなたも嫌いなメソッドありますか？

---

(追記：2013-09-03)

ブコメでなぜ`Array#>>`じゃないのか、つまり

{% highlight ruby %}
class Array
  def >>(array)
    array.unshift(*self)
  end
end

numbers = [*0..9] # => [0, 1, 2, 3, 4, 5, 6, 7, 8, 9]

[-3, -2, -1] >> numbers

numbers # => [-3, -2, -1, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9]
{% endhighlight %}

とすれば`_`（アンダースコア）は不要じゃないかという意見がありました。

もっともなご意見ですが、そうすると記事のネタ度が下がりマジ度が上がるという問題があったので、このブログの性質上ここでは採用しませんでした。

と、言いたいところですが、実はふざけた実装ばかり考えていた結果、一番まともな実装に気づかなかった（！）というのが本当のところですorz

ただ、どうでしょう。この手の提案は既にありそうですし、`Array#<<`との対称性がないというのもイタイところですねー。

