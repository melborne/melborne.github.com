---
layout: post
title: "Rubyのバグだと思ったら自分がバグだった ─ Enumerator編 ─"
description: ""
category: 
tags: 
date: 2013-10-06
published: true
---
{% include JB/setup %}


###─ 問題 ─

以下のコードのバグを指摘せよ。

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

これは`Numeric#step`を使った以下のコードと同じ挙動が期待されている。

{% highlight ruby %}
odd = 1.step(Float::MAX.to_i, 2)

odd.next # => 1
odd.next # => 3
odd.next # => 5
{% endhighlight %}


###─ 解説 ─

ブコメ参照せよ。

以上。

---

ちょっとハマったので、問題にしてみましたよ！


