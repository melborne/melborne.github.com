---
layout: post
title: "Rubyのメソッドを数えましょう♫"
description: ""
category: 
tags: 
date: 2013-08-27
published: true
---
{% include JB/setup %}


<span style="color:#E50086">メグ</span>「ねえ、`[1,2,3]`みたいな配列オブジェクトに対して呼び出せるメソッドの数って、いくつくらいあるの？」

<span style="color:#6BBF3F">るびお</span>「えっ？そんなの`irb`叩いてRubyに聞けば直ぐわかるじゃん。こうだよ。」

{% highlight ruby %}
irb> [1,2,3].methods.size
=> 167
{% endhighlight %}

<span style="color:#6BBF3F">るびお</span>「配列オブジェクトはArrayクラスのインスタンスだから、こうしてもいいんだよ。」

{% highlight ruby %}
irb> [1,2,3].class
=> Array
irb> Array.instance_methods.size
=> 167
{% endhighlight %}

<span style="color:#E50086">メグ</span>「167個もあるの。じゃあ、それが全部Arrayに定義されてるのね？」

<span style="color:#6BBF3F">るびお</span>「あーそれはね、そうじゃないんだよ。Arrayに定義されてる分を知りたいときは、引数にfalseを渡すんだ。」

{% highlight ruby %}
irb> Array.instance_methods(false).size
=> 89
{% endhighlight %}

<span style="color:#E50086">メグ</span>「そうなの。じゃあ、残りはどこから来てるの？」

<span style="color:#6BBF3F">るびお</span>「うん。いい質問だね。それはね、Arrayの祖先から来てるんだよ。祖先が誰かって？それもRubyが教えてくれるよ。ほら。」

{% highlight ruby %}
irb> Array.ancestors
=> [Array, Enumerable, Object, Kernel, BasicObject]
{% endhighlight %}

<span style="color:#E50086">メグ</span>「るびお君素敵！じゃあ、これらの祖先に定義されたインスタンスメソッドとArrayに定義されたインスタンスメソッドを合わせれば、167個になるのね！」

<span style="color:#6BBF3F">るびお</span>「そうさ。メグは飲み込みが早いなあ。じゃあ、早速数えてみよう。ほら。」

{% highlight ruby %}
irb> e = Enumerable.instance_methods(false).size
=> 48
irb> o = Object.instance_methods(false).size
=> 0
irb> k = Kernel.instance_methods(false).size
=> 46
irb> bo = BasicObject.instance_methods(false).size
=> 8
irb> a = Array.instance_methods(false).size
=> 89
irb> e + o + k + bo + a
=> 191
{% endhighlight %}

<span style="color:#6BBF3F">るびお</span>「げっ！」

<span style="color:#E50086">メグ</span>「るびお君の嘘つき！191個もあるじゃない。24個はどこに消えたのよ！」

<span style="color:#6BBF3F">るびお</span>「...」


<br />
<br />


<span style="color:#E50086">メグ</span>「るびお君、あなたまだまだね。オーバーライド分があるじゃないのよ。Arrayで継承元のメソッドが再定義されてたら、その分は差し引かなきゃ。なんで気が付かないかなあ。じゃあ、論理和してみるわよ。」

{% highlight ruby %}
irb> Array.ancestors.map{|klass| klass.instance_methods(false)}.inject{|mem,klass| mem | klass }.size
=> 167
{% endhighlight %}

<span style="color:#6BBF3F">るびお</span>「...」


<br />

---

(追記：2013-08-28) 続きを書きました。

[Rubyのメソッドをもう一度、数えましょう♫]({{ site.url }}/2013/08/28/count-methods-of-ruby-2/ "Rubyのメソッドをもう一度、数えましょう♫")


