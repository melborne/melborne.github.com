---
layout: post
title: "Rubyのバグだと思ったら自分がバグだった ─ Enumerator解説編 ─"
description: ""
category: 
tags: 
date: 2013-10-08
published: true
---
{% include JB/setup %}

前の記事に対する回答がどこからも得られなかったので（当り前だ）、記事を書き直して自分で回答・解説してみます（泣）

> [Rubyのバグだと思ったら自分がバグだった ─ Enumerator編 ─](http://melborne.github.io/2013/10/06/is-this-a-bug-of-ruby-or-me/ "Rubyのバグだと思ったら自分がバグだった ─ Enumerator編 ─")

<br/>

---

一見問題無さそうな以下のコードにはバグがあります。

{% highlight ruby %}
def step(init, step=1)
  Enumerator.new do |y|
    loop { y << init; init += step }
  end
end

odd = step(1, 2)

odd.next # => 1
odd.next # => 3
odd.next # => 5
{% endhighlight %}

これは`Numeric#step`を使った以下のコードと同じ挙動を期待したものですが、実は正しく動作しないんです。

{% highlight ruby %}
odd = 1.step(Float::MAX.to_i, 2)

odd.next # => 1
odd.next # => 3
odd.next # => 5
{% endhighlight %}

バグがどこだか分かりますか？

お時間のある方はちょっと考えてみてくださいね。下に解説を書いておきます。もしかしたら、こんなことは常識なのかもしれませんけど。

<br/>
<br/>
<br/>
<br/>
<br/>
<br/>
<br/>
<br/>
<br/>
<br/>
<br/>
<br/>
<br/>
<br/>
<br/>
<br/>
<br/>
<br/>
<br/>
<br/>

###─ 解説 ─

まず、先の`step`メソッドで`rewind`すると、バグがあることがわかります。

{% highlight ruby %}
def step(init, step=1)
  Enumerator.new do |y|
    loop { y << init; init += step }
  end
end

odd = step(1, 2)

odd.next # => 1
odd.next # => 3
odd.next # => 5
odd.rewind
odd.next # => 5
odd.next # => 7
{% endhighlight %}

そう、rewindしないんです。今度は`take`してみます。

{% highlight ruby %}
odd = step(1, 2)

odd.next # => 1
odd.next # => 3
odd.next # => 5
odd.take(3) # => [5, 7, 9]
odd.next # => 11
odd.next # => 13
{% endhighlight %}

takeの開始位置がオブジェクトの先頭ではなく現在のカーソル位置から始まり、次のnextがtakeの次の値になっています。本来は次のようにならなければいけません。

{% highlight ruby %}
odd = step(1, 2)

odd.next # => 1
odd.next # => 3
odd.next # => 5
odd.take(3) # => [1, 3, 5]
odd.next # => 7
odd.next # => 9
{% endhighlight %}

このバグは`init`の値をEnumeratorのブロック内で一旦受けてループに渡すことで解消できます。

{% highlight ruby %}
def step(init, step=1)
  Enumerator.new do |y|
    current = init
    loop { y << current; current += step }
  end
end

odd = step(1, 2)

odd.next # => 1
odd.next # => 3
odd.next # => 5
odd.take(3) # => [1, 3, 5]
odd.next # => 7
odd.next # => 9
odd.rewind
odd.next # => 1
odd.next # => 3
{% endhighlight %}

このバグは、rewindやtake（eachに依存するメソッド）を呼ぶと、Enumerator生成時に渡したブロックがその度にcallされることにより起きます。つまりrewindやtakeしたときに、ブロック変数yで参照されるyielderオブジェクトには、最初に渡された初期値ではなく、イテレーションの最後の値が与えられてしまうのです。

## Enumeratorの実装

Enumeratorの外部イテレータとしての機能は、Fiberで実装されているそうです。自分はCが読めないのでRubiniusの実装を参考に、簡易版Enumerator（Enu)を書いてみました。

> [rubinius/kernel/common/enumerator.rb at master · rubinius/rubinius](https://github.com/rubinius/rubinius/blob/master/kernel/common/enumerator.rb "rubinius/kernel/common/enumerator.rb at master · rubinius/rubinius")

{% highlight ruby %}
class Enu
  include Enumerable
  def initialize(obj=nil, &blk)
    @obj = obj || Generator.new(&blk)
    reset
  end

  def each(&blk)
    @obj.each(&blk)
  end
  
  def reset
    @fiber = Fiber.new do
      @obj.each { |e| Fiber.yield(e) }
      raise StopIteration, "iteration has ended"
    end
  end

  def next
    @fiber.resume
  end

  def rewind
    reset
  end

  class Yielder
    def initialize(&blk)
      @proc = blk
    end
    
    def yield(*args)
      @proc[*args]
    end
    alias :<< :yield
  end

  class Generator
    def initialize(&blk)
      @proc = blk
    end

    def each(&blk)
      @proc[Yielder.new(&blk)]
    end
  end
end

if __FILE__ == $0
  def step(init, step=1)
    Enu.new do |y|
      current = init
      loop { y << current; current += step }
    end
  end

  odd = step(1, 2)

  odd.next # => 1
  odd.next # => 3
  odd.next # => 5
  odd.take(3) # => [1, 3, 5]
  odd.next # => 7
  odd.next # => 9
  odd.rewind
  odd.next # => 1
  odd.next # => 3
end
{% endhighlight %}

ブロックの呼び出し関係がちょっと複雑ですが、Enumerator.newにブロックが渡されたときには、そのブロック引数yにyielderオブジェクトをセットし、ブロック内の`Yielder#<<`でFiber.yield（Fiberを生成するEnu#reset内で実装）が呼ばれるようになります。そしてrewindしたときはresetが呼ばれその中でGenerator#eachが起動されます。またtakeしたときはEnu#eachを介してやはりGenerator#eachが起動されます。Generator#eachはyielderを引数としてEnuに渡したブロックをcallするのです。

何いってるか分かりますかね？説明がアレですね。コードを追ったほうが早いかもしれません。


ちょっとハマったので、記事にしてみました。

