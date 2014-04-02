---
layout: post
title: "Rubyでカウンタを作る最新の方法があると聞いて..."
description: ""
category: 
tags: 
date: 2014-04-01
published: true
---
{% include JB/setup %}

呼び出す度に数値が１づつ増えたり減ったりするカウンタを、Rubyで書くとしたらどうやりますか？

こんな感じですか。

{% highlight ruby %}
class Counter
  def initialize(init=1)
    @current = init
  end
  
  def inc
    @current += 1
  end

  def dec
    @current -= 1
  end
end

c = Counter.new
c.inc # => 2
c.inc # => 3
c.inc # => 4
c.inc # => 5

c.dec # => 4
c.dec # => 3
c.dec # => 2
c.dec # => 1
{% endhighlight %}

あるいはEnumeratorを使ったこんな感じですか。

{% highlight ruby %}
def counter(op=:+, init=1)
  Enumerator.new do |y|
    cur = init
    loop { y << cur; cur = cur.send(op, 1) }
  end
end

inc = counter
inc.next # => 1
inc.next # => 2
inc.next # => 3
inc.next # => 4

dec = counter(:-, 10)
dec.next # => 10
dec.next # => 9
dec.next # => 8
dec.next # => 7
{% endhighlight %}

それとも、`step`とか使いますか。

{% highlight ruby %}
def counter(n=1, by=1)
  n.step(by:by)
end

inc = counter
inc.next # => 1
inc.next # => 2
inc.next # => 3
inc.next # => 4

dec = counter(10, -1)

dec.next # => 10
dec.next # => 9
dec.next # => 8
dec.next # => 7
{% endhighlight %}

## 最新式カウンタ

でも、どうやらそうじゃないらしいんですよ、最新のやり方は。

こうやるらしいんです...。

{% highlight ruby %}
AprFl.set

def inc
  1
end
{% endhighlight %}

incメソッドを定義して初期値をセットすればいいらしいのです。

ほんとですかね？

実行してみます。

{% highlight ruby %}
inc # => 1
inc # => 2
inc # => 3
inc # => 4
{% endhighlight %}

なるほど。カウントアップしてる...。

`dec`もやってみますね。

{% highlight ruby %}
AprFl.set

def dec
  10
end

decrement # => 10
decrement # => 9
decrement # => 8
decrement # => 7
{% endhighlight %}

ほぅ。カウントダウンしている...。

それで、名前は`inc`や`dec`じゃなくてもいいようなんですよ。

{% highlight ruby %}
AprFl.set

def increment
  1
end

increment # => 1
increment # => 2
increment # => 3
increment # => 4

def decrement_for_me
  10
end

decrement_for_me # => 10
decrement_for_me # => 9
decrement_for_me # => 8
decrement_for_me # => 7
{% endhighlight %}

へぇ。

Counterクラスでもイケるそうなんです。

{% highlight ruby %}
AprFl.set

class Counter
  def initialize(init)
    @init = init
  end

  def inc
    @init
  end
end

c = Counter.new(3)
c.inc # => 3
c.inc # => 4
c.inc # => 5
c.inc # => 6
{% endhighlight %}

引数も取れるらしい。

{% highlight ruby %}
c.inc # => 7
c.inc # => 8
c.inc(2) # => 10
c.inc # => 11
c.inc(3) # => 14
c.inc # => 15
{% endhighlight %}

はぁ。

初期値に数字以外をセットするとどうなりますか？

{% highlight ruby %}
def inc
  "hello, world!"
end

inc # => "hello, world!"
inc # => "hello, world!"
inc # => "hello, world!"
inc # => "hello, world!"

def dec(chr)
  chr.next
end

dec('A') # => "B"
dec('A') # => "B"
dec('A') # => "B"
dec('A') # => "B"
{% endhighlight %}

普通の挙動ですね。

しかし、世の中知らないことだらけですよ。Rubyにこんなやり方あるなんて！



ということで、Rubyでカウンタを作る最新の方法を紹介しました！

<br/>
<br/>
<br/>

---

いやいや、`AprFl.set`、置いてけって。

{% highlight ruby %}
module AprFl
  def self.set
    t = Time.now
    define_aprfl_method if [t.mon, t.day] == [4, 1]
  end

  def self.define_aprfl_method
    TracePoint.trace(:return) do |tp|
      k, m, v = tp.defined_class, tp.method_id, tp.return_value
      op = 
        case m
        when /^inc/ then :+
        when /^dec/ then :-
        else next
        end
      k.class_eval {
        undef_method m
        define_method(m) { |*a, &b| v.send(op, (a.first||1)) rescue v }
      }
    end
  end
end
{% endhighlight %}

またTracePointねたですか。

---

関連記事：

[Rubyでワンタイムメソッドを実装して「スパイ大作戦」を敢行せよ！]({{ BASE_PATH }}/2014/03/15/mission-impossible-in-ruby/ "Rubyでワンタイムメソッドを実装して「スパイ大作戦」を敢行せよ！")


---

(追記:2014-4-2) stepの例を追加しました。

