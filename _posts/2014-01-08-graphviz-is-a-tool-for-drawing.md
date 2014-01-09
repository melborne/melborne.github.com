---
layout: post
title: "Graphvizがドローイングソフトになってしまった件について"
tagline: "Gviz ver0.3.0リリースのお知らせ"
description: ""
category: 
tags: 
date: 2014-01-08
published: true
---
{% include JB/setup %}

GraphvizのRubyラッパーであるGvizというツールを作っておりまして。

> [gviz | RubyGems.org | your community gem host](https://rubygems.org/gems/gviz 'gviz | RubyGems.org | your community gem host')
>
> [melborne/Gviz](https://github.com/melborne/Gviz 'melborne/Gviz')

それは、次のような`graph.ru`というファイルを用意して、

{% highlight ruby %}
route :main => [:init, :parse, :cleanup, :printf]
route :init => :make, :parse => :execute
route :execute => [:make, :compare, :printf]

save :sample
{% endhighlight %}

そのディレクトリで`gviz build`コマンドを実行すると、DOTファイルが出来上がるという代物です。

{% highlight bash %}
% gviz build
% open sample.dot
{% endhighlight %}

![Alt title noshadow]({{ BASE_PATH }}/assets/images/2014/01/gviz_draw1.png)

ネットワーク図とかクラス図とか系統樹などを描くのに適しています。

## ドローイング？

でも、もっとアーティスティックな図も描きたいよね、Graphvizで。

というわけで...。

Gvizをアップデート（ver 0.3.0）しまして、Drawライクなメソッド群を追加しました。

ここで言うDrawライクなメソッドというのは、ノードの形のメソッド名を持ちx, y座標を引数に取るメソッドのことです。

## 使い方

こんなふうに使います。

{% highlight ruby %}
# graph.ru
line :a, from:[-100,0], to:[100,0]
line :b, from:[0,-100], to:[0,100]
circle :c
rect :d, x:50, y:50, fillcolor:"green", label:"Rect"
triangle :e, x:50, y:-50, fillcolor:"cyan"
diamond :f, x:-50, y:50, fillcolor:"magenta"
egg :g, x:-50, y:-50, fillcolor:"yellow", label:"Egg"

save :draw
{% endhighlight %}

各メソッドの第１引数にはユニークなIDを渡します。座標は図の中心点で、省略すると原点(0,0)となります。lineはfromを省略すると原点からの線分になります。これらのメソッドを使うとgraph layoutが`neato`に自動で設定されます。

{% highlight bash %}
% gviz build
% open draw.dot
{% endhighlight %}

![Alt title noshadow]({{ BASE_PATH }}/assets/images/2014/01/gviz_draw2.png)

なお、saveメソッドの第２引数にはpngなどの出力フォーマットを指定できるのですが、これを使うと座標のスケールが変わってしまうので調整が必要になります。Graphvizビューワのexport機能を使ったほうがいいでしょう。

circleのサイズは`r`属性で指定し、他の図形は`width`と`height`属性で指定します。

{% highlight ruby %}
nodes colorscheme:"blues8"

square :a, width:4, fillcolor:3

8.downto(1).each do |r|
  circle r.to_id, x:-(r-8)*10, y:(r-8)*10, r:r/4.0, fillcolor:r
end

save :draw2
{% endhighlight %}

出力です。

![Alt title noshadow]({{ BASE_PATH }}/assets/images/2014/01/gviz_draw3.png)


Drawライクなメソッドにはplaintext, none以外のノードの全shapeが含まれます。Gviz::SHAPESで全shapeを取得できるので、全メソッドを使って図形を出力してみます。

{% highlight ruby %}
require 'colorable'

cs = Colorable::Colorset.new

shapes = (Gviz::SHAPES - ['plaintext', 'none'])

r = 500
deg = 0.step(to:360, by:5)

shapes.each do |shape|
  i = deg.next
  x = r * Math.cos(i * Math::PI / 180.0)
  y = r * Math.sin(i * Math::PI / 180.0)
  c = cs.next
  send shape, i.to_id, x:x, y:y, fillcolor:"#{c.hex}aa", label:shape
end

save :draw3
{% endhighlight %}


![Alt title noshadow]({{ BASE_PATH }}/assets/images/2014/01/gviz_draw4.png)

## 曲線

残念ながら曲線を描くcurveのようなメソッドはありません。

「おまっ、曲線も描けないでドローイングとか言ってんの？」って話です。

いやいや、僕らには数式があるじゃないですか〜。

> [geometry - Is this Batman equation for real? - Mathematics Stack Exchange](http://math.stackexchange.com/questions/54506/is-this-batman-equation-for-real 'geometry - Is this Batman equation for real? - Mathematics Stack Exchange')

{% gist 8316694 %}


![Alt title noshadow]({{ BASE_PATH }}/assets/images/2014/01/gviz_batman.png)

ね？


お前は何がしたいんだ、って感じですが。


---

(追記：2013-1-9) 関連記事を書きました。

> [Rubyでサインカーブを描いて癒やされる]({{ BASE_PATH }}/2014/01/09/discover-beauty-of-sine-curves-through-graphviz/ 'Rubyでサインカーブを描いて癒やされる')

