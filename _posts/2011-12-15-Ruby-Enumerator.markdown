---
layout: post
title: Rubyのエニュメレータ内での破壊行為は止めてください!
date: 2011-12-15
comments: true
categories:
tags: [ruby]
---

RubyのArrayにはrotate!という便利なメソッドがあるよ。このメソッドは文字通り配列の要素をローテートするんだ。
{% highlight ruby %}
 a = [1,2,3]
 a.rotate! # => [2, 3, 1]
 a.rotate! # => [3, 1, 2]
 a # => [3, 1, 2]
{% endhighlight %}
メソッド名の最後に!(ビックリマーク)があるから、これは元のオブジェクト自身を変えるよ。

昨日、僕はこのrotate!メソッドにおけるローテートの過程を取りたいと思ったんだよ。で、次のようなコードを書いてみたんだ。
{% highlight ruby %}
 a = [1,2,3]
 3.times.map { a.rotate! }
{% endhighlight %}

そうしたら期待したものとは違う、次のような結果が返ってきたんだ。
{% highlight ruby %}
 # => [[1, 2, 3], [1, 2, 3], [1, 2, 3]]
{% endhighlight %}

あれ？

mapがいけないのかな..
{% highlight ruby %}
 q = []
 3.times { q << a.rotate! }
 q # => [[1, 2, 3], [1, 2, 3], [1, 2, 3]]
{% endhighlight %}

ローテートしてないのかと思って、ブロック内でpしてみたらちゃんとしてるんだよ。
{% highlight ruby %}
 a = [1,2,3]
 3.times.map { p a.rotate! } # => [[1, 2, 3], [1, 2, 3], [1, 2, 3]]
 # >> [2, 3, 1]
 # >> [3, 1, 2]
 # >> [1, 2, 3]
{% endhighlight %}
なんか変だな..

で、少し考えたら理由がわかったんだ。Array#rotate!はselfを返すんだったよ。
{% highlight ruby %}
 a = [1,2,3]
 a.object_id # => 2151892940
 3.times.map { a.rotate!.object_id } # => [2151892940, 2151892940, 2151892940]
{% endhighlight %}

つまりmapの返り値はa.rotate!のスナップショットの配列を返すんじゃなくて、元オブジェクトの参照の配列を返すんだよ。で、mapの返り値はすべての要素に対するイテレートが終わってから返されるから(当然だよね)。その時点つまり最後のa.rotate!の後における元オブジェクトの状態がすべての配列の要素として返されることになるんだ。

つまり、これは次のコードと同じようなことなんだよ。
{% highlight ruby %}
 a = [1,2,3]
 b = a.rotate!
 c = a.rotate!
 d = a.rotate!
 [b, c, d] # => [[1, 2, 3], [1, 2, 3], [1, 2, 3]]
{% endhighlight %}

だからスナップショットつまり途中経過がほしい場合はさっきみたいにpしたり、to_sしたりdupしたりする必要があるんだね。
{% highlight ruby %}
 a = [1,2,3]
 3.times.map { a.rotate!.to_s } # => ["[2, 3, 1]", "[3, 1, 2]", "[1, 2, 3]"]
 a = [1,2,3]
 3.times.map { a.rotate!.dup } # => [[2, 3, 1], [3, 1, 2], [1, 2, 3]]
{% endhighlight %}

同じことはほかのRubyの破壊的メソッドでも起きるよ。
{% highlight ruby %}
 s = "hello, world!"
 s.size.times.map { p s.chop! } # => ["", "", "", "", "", "", "", "", "", "", "", "", ""]
 # >> "hello, world"
 # >> "hello, worl"
 # >> "hello, wor"
 # >> "hello, wo"
 # >> "hello, w"
 # >> "hello, "
 # >> "hello,"
 # >> "hello"
 # >> "hell"
 # >> "hel"
 # >> "he"
 # >> "h"
 # >> ""
{% endhighlight %}

うっかりしてるとまたミスしそうだよ。分かってる人には当たり前のことなんだろうけど。僕はちょっと嵌っちゃったから書いてみたよ :)

<del datetime="2011-12-15T07:17:25+09:00">だからビルのエレベーター内での危険行為はもう止めようよ!</del>だからRubyのエニュメレータ内での破壊行為はもう止めようよ!
