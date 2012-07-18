---
layout: post
title: "RubyにおけるシーケンスはObject#repeatに任せなさい！"
description: ""
category: 
tags: [ruby, repeat]
date: 2012-07-12
published: ruby
---
{% include JB/setup %}
Rubyにおいてシーケンス、つまり意味的に連続する要素の並びを簡単に生成する`Object#repeat`というものを考えましたよ！以前に考えたEnumerable#repeatを単にすべてのオブジェクトに拡張したものですけど。

{% highlight ruby %}
class Object
  def repeat(init=true, &blk)
    x = self
    Enumerator.new do |y|
      y << x if init
      loop { y << (x = yield x) }
    end
  end
end
{% endhighlight %}

repeatは、そのレシーバオブジェクトを初期値として、渡されたブロックを繰り返し適用します。適用の結果はEnumeratorオブジェクトでラップされているので、遅延評価されます。

以下に、問題に答える形で使い方を見せますね。比較のためrepeatを使わない方法も適宜示します。

## 1. 初項1、公差2の等差数列の最初の20項を求めなさい。
repeatを使うと等差数列は次のように書けます。
{% highlight ruby %}
1.repeat { |x| x + 2 }.take(20) # => [1, 3, 5, 7, 9, 11, 13, 15, 17, 19, 21, 23, 25, 27, 29, 31, 33, 35, 37, 39]
{% endhighlight %}
ブロックで公差を足していくだけです。

repeatを使わない場合は、Integer#stepを使うんでしょうね。
{% highlight ruby %}
1.step(Float::MAX.to_i, 2).take(20) # => [1, 3, 5, 7, 9, 11, 13, 15, 17, 19, 21, 23, 25, 27, 29, 31, 33, 35, 37, 39]
{% endhighlight %}
簡潔ですが、Float::MAX.to_iというのがちょっとトリッキーですね。


## 2. 初項3、公比2の等比数列の最初の20項を求めなさい。
次に等比数列です。
{% highlight ruby %}
3.repeat { |x| x * 2 }.take(20) # => [3, 6, 12, 24, 48, 96, 192, 384, 768, 1536, 3072, 6144, 12288, 24576, 49152, 98304, 196608, 393216, 786432, 1572864]
{% endhighlight %}
極めて自然に書けます。


repeatを使わない場合は、どう書くんですかね。
{% highlight ruby %}
x = 3
n = 1
res = []
while n <= 20
  res << x
  x = x * 2
  n += 1
end
res  # => [3, 6, 12, 24, 48, 96, 192, 384, 768, 1536, 3072, 6144, 12288, 24576, 49152, 98304, 196608, 393216, 786432, 1572864]
{% endhighlight %}
一応答えは出ますが、Rubyistはこんなことしませんよね。次のほうがもう少しマシでしょうか。

{% highlight ruby %}
x = 3
[3] + 19.times.map { x = x * 2 } # => [3, 6, 12, 24, 48, 96, 192, 384, 768, 1536, 3072, 6144, 12288, 24576, 49152, 98304, 196608, 393216, 786432, 1572864]
{% endhighlight %}

## 3. １で求めた等差数列がその第１階差数列となるような数列を求めなさい。
階差数列は、数列の隣合う項の差から生成される数列です。わかりにくいので答えを先に言うと、[1, 2, 5, 10, 17..]が解です。この数列の各項の差が、[1, 3, 5, 7...]となって、１で求めた数列と等しいことが分かると思います。

repeatを使うと一式で階差数列を作ることができます。
{% highlight ruby %}
[1, 1].repeat { |a, b| [a+2, a+b] }.take(20).map(&:last) # => [1, 2, 5, 10, 17, 26, 37, 50, 65, 82, 101, 122, 145, 170, 197, 226, 257, 290, 325, 362]
{% endhighlight %}
配列の先頭位置で順次公差２の等差数列を作っていき、配列の２項位置で階差数列を作っていきます。最後に２項だけを取り出せばOKです。

repeatを使わない場合、等差数列を作った上でinjectするんでしょうか。
{% highlight ruby %}
seq = 1.step(Float::MAX.to_i, 2).take(20) # => [1, 3, 5, 7, 9, 11, 13, 15, 17, 19, 21, 23, 25, 27, 29, 31, 33, 35, 37, 39]

y = seq.first
seq.inject([y]) { |m, x| m << y = x + y } # => [1, 2, 5, 10, 17, 26, 37, 50, 65, 82, 101, 122, 145, 170, 197, 226, 257, 290, 325, 362, 401]
{% endhighlight %}

## 4. フィボナッチ数列の最初の20項を求めなさい。
みんな大好きフィボナッチです。repeatで書くと次のようになります。
{% highlight ruby %}
[0, 1].repeat { |a, b| [b, a + b] }.take(20).map(&:first) # => [0, 1, 1, 2, 3, 5, 8, 13, 21, 34, 55, 89, 144, 233, 377, 610, 987, 1597, 2584, 4181]
{% endhighlight %}
初項0,1を配列として渡すことで、簡潔に書けます。

repeatを使わない場合はどうでしょう。
{% highlight ruby %}
a, b = 0, 1
[0] + 19.times.map { a, b = b, a + b }.map(&:first) # => [0, 1, 1, 2, 3, 5, 8, 13, 21, 34, 55, 89, 144, 233, 377, 610, 987, 1597, 2584, 4181]
{% endhighlight %}
なかなか簡潔ですが、初項の処理が気になるといえば、気になります。

## 5. トリボナッチ数列の最初の20項を求めなさい。
フィボナッチが先行する２項の和を項の値とするのに対して、トリボナッチは先行する３項の和を値とする数列です。repeatを使って。
{% highlight ruby %}
[0, 1, 1].repeat { |a, b, c| [b, c, a + b + c] }.take(20).map(&:first) # => [0, 1, 1, 2, 4, 7, 13, 24, 44, 81, 149, 274, 504, 927, 1705, 3136, 5768, 10609, 19513, 35890]
{% endhighlight %}
いいですね。

repeatを使わない例。
{% highlight ruby %}
a, b, c = 0, 1, 1
[0] + 19.times.map { a, b, c = b, c, a + b + c }.map(&:first) # => [0, 1, 1, 2, 4, 7, 13, 24, 44, 81, 149, 274, 504, 927, 1705, 3136, 5768, 10609, 19513, 35890]
{% endhighlight %}

## 6. ニュートン法を使って5の平方根を求めなさい。
ニュートン法でnの平方根を求めるときは、任意の近似値xを選び、xとn/xの平均を取ってより良い近似値xを得ます。これを繰り返し十分に良い近似値が得られたら処理を終えるようにします。

loopを使った解法は、次のようになります。
{% highlight ruby %}
a = 5
x = 1.0
eps = 0.0001
loop do
  y = x
  x = (x + a/x) / 2.0
  break x if (x - y).abs < eps
end
x # => 2.236067977499978
{% endhighlight %}


一方で、repeatを使うと次のように書けます。
{% highlight ruby %}
a = 5
eps = 0.0001
1.0.repeat { |x| (x + a/x) / 2.0 }
   .each_cons(2)
   .detect { |a, b| (a - b).abs < eps }[1] # => 2.236067977499978
{% endhighlight %}


## 7. Aから始まるExcelの列名ラベルを60個生成しなさい。
repeatを使わない場合は、次のようになるでしょうか。
{% highlight ruby %}
c = '@'
60.times.map { c = c.succ } # => ["A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z", "AA", "AB", "AC", "AD", "AE", "AF", "AG", "AH", "AI", "AJ", "AK", "AL", "AM", "AN", "AO", "AP", "AQ", "AR", "AS", "AT", "AU", "AV", "AW", "AX", "AY", "AZ", "BA", "BB", "BC", "BD", "BE", "BF", "BG", "BH"]
{% endhighlight %}

repeatを使うと、より簡潔に書けます。
{% highlight ruby %}
'A'.repeat { |x| x.succ }.take(60) # => ["A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z", "AA", "AB", "AC", "AD", "AE", "AF", "AG", "AH", "AI", "AJ", "AK", "AL", "AM", "AN", "AO", "AP", "AQ", "AR", "AS", "AT", "AU", "AV", "AW", "AX", "AY", "AZ", "BA", "BB", "BC", "BD", "BE", "BF", "BG", "BH"]
{% endhighlight %}


## 8. 2進数10110011を10進変換しなさい（String#to_iを使ってはいけない）。
repeatを使わない例。
{% highlight ruby %}
b = 10110011
sum = 0
n = 0
while b >= 1
  b, r = b.divmod(10) 
  sum += r*2**n
  n += 1
end
sum # => 179
{% endhighlight %}

repeatを使って。
{% highlight ruby %}
digit = 1.repeat { |x| x*2 }

10110011.repeat(false) { |m,| m.divmod(10) }.take(8)
        .map { |_, i| i*digit.next }.inject(:+) # => 179
{% endhighlight %}
あまり簡潔じゃないですね^ ^;

## 9. ランダムなブール値の並び20項を生成しなさい。但し、trueが連続してはいけない。
repeatを使わないと、ローカル変数で前の値を保持して、次のように書くのでしょう。
{% highlight ruby %}
prev = true
seq = 20.times.map do
  prev = prev ? false : [true, false].sample
end
seq # => [false, true, false, false, true, false, true, false, false, true, false, true, false, true, false, true, false, false, false, false]
{% endhighlight %}

repeatを使うと、これは次のように簡潔に書けます。
{% highlight ruby %}
true.repeat { |bool| bool ? false : [true, false].sample }.take(20) # => [true, false, true, false, true, false, true, false, true, false, true, false, true, false, true, false, false, false, true, false]
{% endhighlight %}

## 10. ランダムなブール値の並び20項を生成しなさい。但し、trueが3つ連続してはいけない。
repeatを使わない場合、先の例と同様にローカル変数で前の値２つを保持する必要があります。
{% highlight ruby %}
prev = prev2 = true
seq = 20.times.map do
  tmp = prev
  prev = [prev, prev2].all? ? false : [true, false].sample
  prev2 = tmp
  prev
end
seq # => [false, false, false, false, true, false, false, true, false, true, true, false, false, false, true, true, false, false, false, false]
{% endhighlight %}

repeatを使うと、次のように書けます。
{% highlight ruby %}
[true, true].repeat { |a, b| [ b, [a, b].all? ? false : [true, false].sample ] }.take(20).map(&:last) # => [true, false, true, true, false, false, true, false, false, false, true, false, false, true, false, true, true, false, false, true]
{% endhighlight %}
いいですね。


`Object#repeat`を紹介しました。なかなか便利そうですよね？また、調子に乗ってFeatureリクエストしちゃおうかな..

----

(追記：2012-07-14)

大変なことが起こりました..

この記事に対し昨日、Matzがつぶやいたのです。

![matz says]({{ site.url }}/assets/images/matz_tweet_repeat.png)

このつぶやきを僕は、**「名前さえ良ければRubyに採用してもいいよとMatzが言ってる」**と解釈していいのですか？それとも、**「昨日言ってくれれば良かったんだけどねー（つまり「おととい来やがれ」の婉曲表現）」**と解釈すべきなのですか？

いや、真実はどうであれ、ここはポジティブに前者だと考えるべきでしょう。The Power of Positive Thinking.

### 名前重要
そうすると、名前です、なまえ。**「名前重要」**。もちろん個人的には`repeat`はなかなかな名前だと思っていたのですが、ここはまず、なぜ`repeat`がMatzにとって「名前がなあ」なのか考えてみます。

`repeat`という語は複数のプログラミング言語で使われており、それは概ねRubyにおける`loop`と等価、つまり**「単純繰り返し」**のための機能を提供するもののようです。この点からすると、Object#repeatはその機能を知らないユーザにとっては、次のような機能を提供するものと想像される可能性があります。

{% highlight ruby %}
1.repeat(5) # => [1, 1, 1, 1, 1]
{% endhighlight %}
つまりrepeatは単にレシーバオブジェクトを繰り返した結果を返すメソッドであると想像するのです。なるほど合理性があります。恐らくMatzもこのようなことを懸念したんだと想像します。

一方で、`Object#repeat`の本来の機能は「そのレシーバオブジェクトを初期値として、渡されたブロックを繰り返し適用する」ことで、より正確に言うならば、**「レシーバオブジェクトを繰り返すのではなく、ブロック内手続きをレシーバオブジェクトに繰り返し適用する」**メソッドなのです。

再考すると確かに、repeatではその機能を説明しきれていない感がありますね。

そこで、代替案を考えてみましたよ！すなわち、「繰り返し適用」を意味する`repeat_apply`です。ちょっとメソッド名が長くなる点に不満はありますが、その機能をより的確に表していると言えるんじゃないでしょうか。

ということで、`Object#repeat`を取り下げ、`Object#repeat_apply`でどうでしょう？

って、ここで「どうでしょう？」っていっても何も進まないでしょうけど...。結果はどうであれ、機能的には評判が良い感じなので、Featureリクエストの準備します。ちなみに`repeat_call`という案も第２候補として挙げておきます。

----

関連記事：

[Rubyのrepeat関数でフィボナッチ、トリボナッチ、テトラナッチ！](http://melborne.github.com/2011/07/01/Ruby-repeat/ 'Rubyのrepeat関数でフィボナッチ、トリボナッチ、テトラナッチ！')

----

{{ 4837804535 | amazon_medium_image }}
{{ 4837804535 | amazon_link }} by {{ 4837804535 | amazon_authors }}

