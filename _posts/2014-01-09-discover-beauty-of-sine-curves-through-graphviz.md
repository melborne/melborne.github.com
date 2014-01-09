---
layout: post
title: "Rubyでサインカーブを描いて癒やされる"
description: ""
category: 
tags: 
date: 2014-01-09
published: true
---
{% include JB/setup %}

前回の続きなわけです。

> [Graphvizがドローイングソフトになってしまった件について]({{ BASE_PATH }}/2014/01/08/graphviz-is-a-tool-for-drawing/ 'Graphvizがドローイングソフトになってしまった件について')

今回は、GvizのDraw系メソッドを使ってサインカーブを描いたら、その美しさに癒やされたという話です。


> [gviz | RubyGems.org | your community gem host](https://rubygems.org/gems/gviz 'gviz | RubyGems.org | your community gem host')
>
> [melborne/Gviz](https://github.com/melborne/Gviz 'melborne/Gviz')

つまり、Gvizでこんなお遊びもできるよという話ですね。

---

まずは座標軸を。

{% highlight ruby %}
#graph.ru
line :x, from:[-180,0], to:[180,0]
line :y, from:[0,-100], to:[0, 100]

save :sine
{% endhighlight %}

    % gviz build
    % open sine.dot

出力です。ちなみにこのlineは内部的には見えないノードを結ぶエッジで描いてます。

![Alt title noshadow]({{ BASE_PATH }}/assets/images/2014/01/sine1.png)

## point

さて、最初に`point`を使ってサインカーブを書いてみます。

{% highlight ruby %}
line :x, from:[-180,0], to:[180,0]
line :y, from:[0,-100], to:[0, 100]

r = 50
(-180).step(to:180, by:5).each do |i|
  y = r * Math.sin(i * Math::PI / 180.0)
  point :"#{i}", x:i, y:y
end

save :sine
{% endhighlight %}

このコードのポイント、何だか分かりますか？

そうです、Numeric#stepでキーワード引数使ってるところですね！Ruby2.1の新機能です。これまだ、るりまにも載っていません（riにはあります）。

出力です。

![Alt title noshadow]({{ BASE_PATH }}/assets/images/2014/01/sine2.png)

サインカーブです。美しいです。

## circle

さて、次に`circle`を使ってサインカーブに立体感を出してみます。


{% highlight ruby %}
line :x, from:[-180,0], to:[180,0]
line :y, from:[0,-100], to:[0, 100]

r = 50
(-180).step(to:180, by:5).each do |i|
  y = r * Math.sin(i * Math::PI / 180.0)
+  circle :"#{i}", x:i, y:y
end

save :sine
{% endhighlight %}

出力です。

![Alt title noshadow]({{ BASE_PATH }}/assets/images/2014/01/sine3.png)

立体感出ました。干渉縞が見えます。いいですね。

さて、次は少しcircleの径を弄ってみます。原点からの距離に応じて経を大きくします。

{% highlight ruby %}
line :x, from:[-180,0], to:[180,0]
line :y, from:[0,-100], to:[0, 100]

r = 50
(-180).step(to:180, by:5).each do |i|
  y = r * Math.sin(i * Math::PI / 180.0)
+  circle :"#{i}", x:i, y:y, r:(i*0.004).abs
end

save :sine
{% endhighlight %}

出力です。

![Alt title noshadow]({{ BASE_PATH }}/assets/images/2014/01/sine4.png)

うねってます、トルネードです。

もっと径を大きくしてみます。密度も増やし、色を付けて。


{% highlight ruby %}
+ nodes colorscheme:"blues9"
+ nums = (1..9).cycle

line :x, from:[-180,0], to:[180,0]
line :y, from:[0,-100], to:[0, 100]

r = 50
+ (-180).step(to:180, by:1).each do |i|
  y = r * Math.sin(i * Math::PI / 180.0)
+  circle :"#{i}", x:i, y:y, r:(i*0.02).abs, color:nums.next
end

save :sine
{% endhighlight %}

出力です。

![Alt title noshadow]({{ BASE_PATH }}/assets/images/2014/01/sine5.png)

印象が大分変わりました。サインカーブの面影が消えました。中心辺りじっと見てるとその渦の中に吸い込まれそうになります。美しいです。ところで、こういうときEnumerable#cycleは便利ですね。

## diamond

次に、`diamond`をやってみます。


{% highlight ruby %}
line :x, from:[-180,0], to:[180,0]
line :y, from:[0,-100], to:[0, 100]

r = 50
(-180).step(to:180, by:5).each do |i|
  y = r * Math.sin(i * Math::PI / 180.0)
+  diamond :"#{i}", x:i, y:y
end

save :sine
{% endhighlight %}

出力です。

![Alt title noshadow]({{ BASE_PATH }}/assets/images/2014/01/sine6.png)

金属棒を曲げたような硬質な感じがします。カーブのところの格子状模様がいいですね。

diamondのサイズを変えて、色を付けてみます。

{% highlight ruby %}
line :x, from:[-180,0], to:[180,0]
line :y, from:[0,-100], to:[0, 100]

r = 50
(-180).step(to:180, by:5).each do |i|
  y = r * Math.sin(i * Math::PI / 180.0)
+  diamond :"#{i}", x:i, y:y, width:5, color:"brown"
end

save :sine
{% endhighlight %}

出力です。

![Alt title noshadow]({{ BASE_PATH }}/assets/images/2014/01/sine7.png)

面白い形ができました。レモン絞りの突起のような形が中に見えます。

## star

Graphvizには`star`という変わったshapeもあります。最後にこれを出力してみましょう。

{% highlight ruby %}
line :x, from:[-180,0], to:[180,0]
line :y, from:[0,-100], to:[0, 100]

r = 50
(-180).step(to:180, by:5).each do |i|
  y = r * Math.sin(i * Math::PI / 180.0)
+  star :"#{i}", x:i, y:y, width:5, color:"gold"
end

save :sine
{% endhighlight %}

出力です。

![Alt title noshadow]({{ BASE_PATH }}/assets/images/2014/01/sine8.png)

頂点の軌跡が描くサインカーブが美しいです。

---

簡単なコードで変化に飛んだ実に美しい絵が描かれるものです。



---

<p style='color:red'>=== Ruby関連電子書籍100円で好評発売中！ ===</p>

[M'ELBORNE BOOKS]({{ BASE_PATH }}/books/ "M'ELBORNE BOOKS")

<a href="{{ BASE_PATH }}/books/">
  <img src="/assets/images/2012/ruby_parallel_cover.png" alt="ruby_parallel" style="width:200px" />
</a>
<a href="{{ BASE_PATH }}/books/">
  <img src="/assets/images/2012/rack_cover.png" alt="rack" style="width:200px" />
</a>
<a href="{{ BASE_PATH }}/books/">
  <img src="/assets/images/2012/js_oop_cover.png" alt="js_oop" style="width:200px" />
</a>

