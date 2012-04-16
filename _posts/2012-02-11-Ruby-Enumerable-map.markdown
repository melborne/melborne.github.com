---
layout: post
title: RubyのEnumerable#mapをもっと便利にしたいよ
date: 2012-02-11
comments: true
categories:
tags: [ruby, enumerable]
---

次のような名前のリストがあって、

{% highlight ruby %}
langs = ["ruby", "python", "lisp", "haskell"]
{% endhighlight %}

名前の先頭を大文字にするとしたら、君ならどうする？

そう普通Enumerable#mapを使って次のようにするよね。
{% highlight ruby %}
langs = ["ruby", "python", "lisp", "haskell"]
langs.map { |lang| lang.capitalize } # => ["Ruby", "Python", "Lisp", "Haskell"]
{% endhighlight %}

Enumerable#mapってほんと死ぬほど便利だよ。僕はRubyの魅力の80％はmapが占めてるんじゃないかって、たまに感じることがあるよ.. :)

でもただ先の例で大文字にするだけなのにブロックって、ちょっと大げさすぎると思わない？

もちろんそうなんだよ。そう思うRubyistが沢山いたからmapは次のように書けるようにもなってるんだ。

{% highlight ruby %}
langs = ["ruby", "python", "lisp", "haskell"]
langs.map(&:capitalize) # => ["Ruby", "Python", "Lisp", "Haskell"]
{% endhighlight %}
シンボルに&を付けてmapに渡すと暗黙的にSymbol#to_procが呼ばれて、そこで配列の各要素にcapitalizeが適用されるよ。この記法のお陰でmapは一層使い勝手が良くなってるよ。

じゃあ今度は先の言語名のリストから、その「言語使いのリスト」に変換してほしいんだけど..つまり言語名の後に'ist'を付けてほしいんだ{% fn_ref 1 %}

そう次のようにするよね。
{% highlight ruby %}
langs = ["ruby", "python", "lisp", "haskell"].map(&:capitalize)
langs.map { |lang| lang + 'ist' } # => ["Rubyist", "Pythonist", "Lispist", "Haskellist"]
{% endhighlight %}
これって悔しいよね。'ist'を足すだけなのに、またブロックを書かなきゃいけない。

同じように次のような場合もブロックを書かなきゃいけない。
{% highlight ruby %}
[1, 2, 3].map { |i| i + 10 } # => [11, 12, 13]
(1..5).map { |i| i**2 } # => [1, 4, 9, 16, 25]
[[1,2,3,4], [5,6,7,8], [9,10,11,12]].map { |arr| arr.last(2) } # => [[3, 4], [7, 8], [11, 12]]
["ruby", "python", "lisp", "haskell"].map { |lang| lang[-2, 2] } # => ["by", "on", "sp", "ll"]
{% endhighlight %}

僕はすごく悔しいよ..

そんなわけで..

Enumerable#mappを考えたよ!
{% highlight ruby %}
module Enumerable
  def mapp(op=nil, *args, &blk)
    op ? map { |e| op.intern.to_proc[e, *args]} : map(&blk)
  end
end
langs.mapp(:+, 'ist') # => ["Rubyist", "Pythonist", "Lispist", "Haskellist"]
{% endhighlight %}
つまりmappでは引数にメソッドとその引数が取れるんだ。

{% highlight ruby %}
[1, 2, 3].mapp(:+, 10) # => [11, 12, 13]
(1..5).mapp(:**, 2) # => [1, 4, 9, 16, 25]
[[1,2,3,4], [5,6,7,8], [9,10,11,12]].mapp(:last, 2) # => [[3, 4], [7, 8], [11, 12]]
["ruby", "python", "lisp", "haskell"].mapp(:[], -2, 2) # => ["by", "on", "sp", "ll"]
{% endhighlight %}

ブロックを渡せばmapに処理を投げるからmapの代わりとしても使えるよ。
{% highlight ruby %}
[1, 2, 3].mapp { |i| i + 10 } # => [11, 12, 13]
(1..5).mapp { |i| i**2 } # => [1, 4, 9, 16, 25]
[[1,2,3,4], [5,6,7,8], [9,10,11,12]].mapp { |arr| arr.last(2) } # => [[3, 4], [7, 8], [11, 12]]
["ruby", "python", "lisp", "haskell"].mapp { |lang| lang[-2, 2] } # => ["by", "on", "sp", "ll"]
{% endhighlight %}

誰でも考えそうだから既出のアイディアだったらゴメンね。

って、もっと高度なことをまめさんがしてました^ ^;

[map が面倒なので DelegateMap - まめめも](http://d.hatena.ne.jp/ku-ma-me/20090312/p1)

まあ折角書いたから..

ゴメンナサイm(__)m

関連記事:[RubyのSymbol#to_procを考えた人になってみる]({{ site.url }}/2008/09/17/Ruby-Symbol-to_proc/)

(追記:2012-2-14)Twitterを通してすごい荒業を知ったよ{% fn_ref 2 %}
{% highlight ruby %}
 [1,2,3].map(&1.method(:+)) #=> [2,3,4]
{% endhighlight %}
スゴイね!でもメソッド呼び出しのオブジェクトが引数と入れ替わっちゃってるから、:+, :*くらいしか用途がなさそうだけどね..

{% footnotes %}
   {% fn 怒らないで! %}
   {% fn https://twitter.com/tmaeda/statuses/168380640734085120 %}
{% endfootnotes %}
