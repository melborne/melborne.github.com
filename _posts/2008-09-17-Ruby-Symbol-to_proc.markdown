---
layout: post
title: RubyのSymbol#to_procを考えた人になってみる
date: 2008-09-17
comments: true
categories:
---

Rubyのメソッドはブロックを取れる。ブロックはコードの塊だから、その内容に応じてメソッドの挙動を大きく変化させることができるんだ。

例えば、injectメソッドはリストタイプのオブジェクトに対して、たたみこみ演算を実行するものだけれど、これに加算を行うコードブロックを渡せばinjectメソッドはたたみこみ加算器となり、
{% highlight ruby %}
  (1..10).inject(5) { |mem, var| mem + var } # => 60
{% endhighlight %}
一方乗算を行うコードブロックを渡せば、たたみこみ乗算器となるんだ。
{% highlight ruby %}
  (1..5).inject(2) { |mem, var| mem * var } # => 240
{% endhighlight %}

また、mapメソッドはリストの各要素に同じ評価を与えるものだけれど、これにcapitalizeメソッドのコードブロックを渡せば、mapメソッドはcapitalize変換器となり、
{% highlight ruby %}
   ["ruby", "c", "lisp", "smalltalk"].map { |item| item.capitalize }      # => ["Ruby", "C", "Lisp", "Smalltalk"]
{% endhighlight %}
一方、lengthメソッドのコードブロックを渡せば、長さ演算器となるんだ。
{% highlight ruby %}
   ["ruby", "c", "lisp", "smalltalk"].map { |item| item.length }       # => [4, 1, 4, 9]
{% endhighlight %}
もちろんブロックにはもっと複雑なコードを渡せる。でも、意外と上で示したような単純な演算をさせることが多いよね。

そうすると、ただ各要素の加算をしたり長さを求めるときに、いちいちmemとかitemとかのブロック変数を書くのが面倒くさい。

なんとかならないかな…
{% highlight ruby %}
  (1..10).inject(5, :+) # => 60
{% endhighlight %}
とか書けたらすてきだなあ…

基の式はこうだから、
{% highlight ruby %}
  (1..10).inject(5) { |mem, var| mem + var } # => 60
{% endhighlight %}
こうはなるよね。
{% highlight ruby %}
  (1..10).inject(5) { |mem, var| mem.send(:+, var) } # => 60
{% endhighlight %}
Kernelのsendメソッドはシンボル化されたメソッド名を第1引数に取れるんだ。

ブロックをブロックとしてではなく、injectの引数として何とか渡したいなあ。

ならブロックをオブジェクト化すればいいんだ。
{% highlight ruby %}
  (1..10).inject(5, &lambda { |mem, var| mem.send(:+, var) }) # => 60
{% endhighlight %}
メソッドはその引数としてオブジェクトしか受け付けないけど、lambdaでブロックを手続きオブジェクトに変えてやれば、他のオブジェクトと同じようにカッコに入れられる。それで＆(アンパサンド)を前置すれば、呼び出し側(injectメソッド内部)ではブロックに戻されて、ブロックとして評価されるようになる。

さて、次にこの手続きオブジェクトをどこかに隠したいなあ。

そうか、シンボルのメソッドにしちゃえばいいんだよ！つまり、シンボルをこの手続きオブジェクトに変換するメソッドを書けばいいんだ。
{% highlight ruby %}
  class Symbol
    def to_proc
      lambda { |mem, var| mem.send(:+, var) }
    end
  end
  (1..10).inject(5, &:+.to_proc) # => 60
{% endhighlight %}

すごいな俺！

これでto_procが取れたら完成なんだけど…
{% highlight ruby %}
  class Symbol
    def to_proc
      lambda { |mem, var| mem.send(:+, var) }
    end
  end
  (1..10).inject(5, &:+) # => 60
{% endhighlight %}
あれ？取ってもうまくいくぞ。なんで？

そうか暗黙の型変換だよ。

＆を前置したからRubyは、それが手続きオブジェクトであると期待したんだ。でもその期待に反して＆を伴っていたのはシンボルだったので、そのオブジェクトに手続きオブジェクトへの変換を要求、つまりto_procメソッドを自動で送信したんだ。

できちゃったよ！ラッキーだな俺！

じゃあ、次にmapについても同じように考えてみよう。

基の式はこうだから、
{% highlight ruby %}
   ["ruby", "c", "lisp", "smalltalk"].map { |item| item.capitalize }
            # => ["Ruby", "C", "Lisp", "Smalltalk"]
{% endhighlight %}
こうはなるよね。
{% highlight ruby %}
   ["ruby", "c", "lisp", "smalltalk"].map { |item| item.send(:capitalize) }
            # => ["Ruby", "C", "Lisp", "Smalltalk"]
{% endhighlight %}
次に、ブロックをオブジェクト化する。
{% highlight ruby %}
   ["ruby", "c", "lisp", "smalltalk"].map(&lambda { |item| item.send(:capitalize) })
            # => ["Ruby", "C", "Lisp", "Smalltalk"]
{% endhighlight %}
それでこの手続きオブジェクトをシンボルのto_procメソッドにすれば完成だ。
{% highlight ruby %}
  class Symbol
    def to_proc
      lambda { |item| item.send(:capitalize) }
    end
  end
   ["ruby", "c", "lisp", "smalltalk"].map(&:capitalize)
            # => ["Ruby", "C", "Lisp", "Smalltalk"]
{% endhighlight %}
よし！

最後はこのto_procメソッドを一般化しなけりゃ。つまり、上の2つの例ではそれぞれのメソッド:+と:capitalizeがto_procに書かれてしまっている。これらはto_procメソッドの呼びだし元、つまりselfだからこれに置き換えよう。
{% highlight ruby %}
  class Symbol
    def to_proc
      lambda { |obj, *args| obj.send(self, *args) }
    end
  end
{% endhighlight %}
うまいことにRubyのブロックはクロージャとして外部環境を一緒に閉じ込めるから、to_proc内のブロックにおけるselfはその呼びだし元(先の例では:+, :capitalize)となる。

これでSymbol#to_procの完成だ！

----------------------------------------------------------------
ってか、こういうことを考えつく人はパッと閃いてサッと書いてしまうんでしょう…僕はSymbol#to_procをこうやってやっと理解できたのでした。

ただここまでくると、こんどはちょっと＆が邪魔に思えてくる。だからやっぱりこう書きたい。
{% highlight ruby %}
  (1..10).inject(5, :+) # => 60
{% endhighlight %}
あれ？実行できる…

これは？
{% highlight ruby %}
  (1..10).inject(5, '+') # => 60
{% endhighlight %}
これもOKだ。じゃあmapも？
{% highlight ruby %}
  ["ruby", "c", "lisp", "smalltalk"].map(:capitalize)
        # =>ArgumentError: wrong number of arguments (1 for 0)
{% endhighlight %}
mapはだめだった。

Ruby1.9のリファレンスマニュアルを調べてみると…

injectメソッドはシンボルを渡すと、それをメソッドとして呼ぶように実装されていた。{% fn_ref 1 %}

こうなるとmapもなんとかしたい。まずmapの実装等価コードをmappメソッドとして書いてみる。
{% highlight ruby %}
  module Enumerable
    def mapp
      i = 0
      while i < self.length
        self[i] = yield self[i]
        i += 1
      end
      self
    end
  end
{% endhighlight %}
こんな感じだろうか。
{% highlight ruby %}
  ["ruby", "c", "lisp", "smalltalk"].mapp(&:capitalize)
            # => ["Ruby", "C", "Lisp", "Smalltalk"]
  ["ruby", "c", "lisp", "smalltalk"].mapp { |item| item.capitalize }
           # => ["Ruby", "C", "Lisp", "Smalltalk"]
{% endhighlight %}
いいみたいだ。

次にブロックが渡されないときの処理を分岐して、その場合には渡された第1引数をメソッドとして呼ぶようにしてみる。
{% highlight ruby %}
  module Enumerable
    def mapp(*args)
      i = 0
      while i < self.length
        self[i] = block_given? ? yield(self[i]) : self[i].send(args[0])
        i += 1
      end
      self
    end
  end
{% endhighlight %}
ブロックの有無の判断にはblock_given?メソッドを使う。
{% highlight ruby %}
  ["ruby", "c", "lisp", "smalltalk"].mapp(:capitalize)
                # => ["Ruby", "C", "Lisp", "Smalltalk"]
  ["ruby", "c", "lisp", "smalltalk"].mapp('capitalize')
               # => ["Ruby", "C", "Lisp", "Smalltalk"]
  ["ruby", "c", "lisp", "smalltalk"].mapp(&:capitalize)
               # => ["Ruby", "C", "Lisp", "Smalltalk"]
  ["ruby", "c", "lisp", "smalltalk"].mapp { |item| item.capitalize }
               # => ["Ruby", "C", "Lisp", "Smalltalk"]
{% endhighlight %}
うまくいった。

ただどういうわけかmapを再定義して上記を実装するとうまくいかない。自分の理解の限界に来たのでここまでとします。

関連記事：[Rubyのブロックはメソッドに対するメソッドのMix-inだ！]({{ site.url }}/2008/08/09/Ruby-Mix-in/)
{% footnotes %}
   {% fn [instance method Enumerable#inject](http://doc.loveruby.net/refm/api/view/method/Enumerable/i/inject %}
{% endfootnotes %}
