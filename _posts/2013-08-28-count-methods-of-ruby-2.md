---
layout: post
title: "Rubyのメソッドをもう一度、数えましょう♫"
description: ""
category: 
tags: 
date: 2013-08-28
published: true
---
{% include JB/setup %}

「[Rubyのメソッドを数えましょう♫]({{ site.url }}/2013/08/27/count-methods-of-ruby/ "Rubyのメソッドを数えましょう♫")」の続きです...

---

<span style="color:#E50086">メグ</span>「ねえ、配列オブジェクトのメソッド数については分かったから、こんどはArrayクラス自身のメソッドについて教えてくれる？」

<span style="color:#6BBF3F">るびお</span>「...えっ？あぁ...。」


<span style="color:#E50086">メグ</span>「じゃあ、Arrayクラスに対して呼び出せるメソッドの数って、いくつあるのかな？」

<span style="color:#6BBF3F">るびお</span>「えっ？同じように`irb`を叩けばいいと思うんだけど...。」

{% highlight ruby %}
irb> Array.methods.size
=> 97
{% endhighlight %}

<span style="color:#6BBF3F">るびお</span>「ArrayクラスはClassクラスのインスタンスだから、こうしてもいいんだよ。」

{% highlight ruby %}
irb> Array.class
=> Class
irb> Class.instance_methods.size
=> 95
{% endhighlight %}

<span style="color:#6BBF3F">るびお</span>「げっ！」

<span style="color:#E50086">メグ</span>「るびお君の嘘つき！95個に減っちゃったじゃない。２個はどこに消えたのよ！」


<span style="color:#6BBF3F">るびお</span>「...」


<br />
<br />


<span style="color:#E50086">メグ</span>「るびお君、やっぱりまだまだね。シングルトンメソッドがあるじゃないのよ。Arrayクラスで自身のために定義されてるメソッドのことよ。なんで気が付かないかなあ。じゃあ、引数にfalseを渡すか、singleton_methodsしてみて。」

{% highlight ruby %}
irb> Array.methods.size
=> 97
irb> Array.methods(false).size
=> 2
irb> Array.singleton_methods
=> [:[], :try_convert]
{% endhighlight %}

<span style="color:#6BBF3F">るびお</span>「...」


<br />


<br />

<span style="color:#E50086">メグ</span>「気を取り直して。じゃあ、Arrayで呼べる97個のメソッドのうち95個はClassに定義されてるって理解でいいの？」

<span style="color:#6BBF3F">るびお</span>「引数にfalseを渡すの知ってるのに...。」

{% highlight ruby %}
irb> Class.instance_methods(false).size
=> 3
irb> Class.instance_methods(false)
=> [:allocate, :new, :superclass]
{% endhighlight %}

<span style="color:#E50086">メグ</span>「へぇ。Classクラスには３個しかメソッド無いんだ。じゃあ、残りはどこから来てるの？」

<span style="color:#6BBF3F">るびお</span>「明らかに意地悪してるよね？まあいいけど。Classの祖先を調べてよ。」

{% highlight ruby %}
irb> Class.ancestors
=> [Class, Module, Object, Kernel, BasicObject]
{% endhighlight %}

<span style="color:#E50086">メグ</span>「るびお君素敵！Classクラスって継承ツリーのルートじゃ無いんだ。ClassクラスのスーパークラスってModuleクラスなんだー。しかもこれらにはさっきの３つのメソッドの差しかないし。じゃあ、これらの祖先に定義されたインスタンスメソッドとClassクラスに定義されたインスタンスメソッドを合わせれば、95個になるのね！私やってみる！」


{% highlight ruby %}
irb> m = Module.instance_methods(false).size
=> 44
irb> o = Object.instance_methods(false).size
=> 0
irb> k = Kernel.instance_methods(false).size
=> 46
irb> bo = BasicObject.instance_methods(false).size
=> 8
irb> c = Class.instance_methods(false).size
=> 3
irb> m + o + k + bo + c
=> 101
{% endhighlight %}

<span style="color:#E50086">メグ</span>「あっ、数が合わない！」

<span style="color:#6BBF3F">るびお</span>「あのさぁ...。いい加減にしてよ。」

<span style="color:#E50086">メグ</span>「オーバーライド分引かなきゃ。論理和すればいいんだったわね。ふふっ。」

{% highlight ruby %}
irb> Class.ancestors.map{|klass| klass.instance_methods(false)}.inject{|mem, klass| mem | klass }.size
=> 95
{% endhighlight %}

<span style="color:#E50086">メグ</span>「正解！」

<span style="color:#6BBF3F">るびお</span>「...」





