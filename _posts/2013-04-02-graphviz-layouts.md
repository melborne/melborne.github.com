---
layout: post
title: "Graphvizレイアウトサンプル"
description: ""
category: 
tags: 
date: 2013-04-02
published: true
---
{% include JB/setup %}

Graphvizには複数のレイアウトフォーマットがありますが、どれも名前が変わっていて生成されるレイアウトを名前から想像することが困難です。幾つかのレイアウトの説明は[Graphvizのサイト](http://www.graphviz.org/ "Graphviz | Graphviz - Graph Visualization Software")に書いてあるのですが、それを読んでもやっぱりピンと来ません。その結果、毎度グラフを作るたびにレイアウトを試行錯誤することになります。

でも、レイアウトはやっぱりサンプルを見るのが一番手っ取り早いですよね。

<br/>

そんなわけで...

<br/>

Graphvizのレイアウトサンプルを作って、ここに貼っておくことにします。サンプルの作成にはいつもの様に[Gviz](https://rubygems.org/gems/gviz "gviz | RubyGems.org | your community gem host")を使います。ちなみにGviz0.1.2では、gvizコマンドの-mオプションでlayouts一覧を表示できるようになりました。

{% highlight bash %}
% gviz -m layouts
Layouts:
  circo, dot, fdp, neato, nop, nop1, nop2, osage, patchwork, sfdp, twopi
{% endhighlight %}

<br/>

##サンプル生成─その１

最初に、１つのノードに対し複数のノードを連結したグラフを書いてみます。コードは次のようになります{% fn_ref 1 %}。ノードの色付けをするために[Colorable gem](https://rubygems.org/gems/colorable "colorable | RubyGems.org | your community gem host")を使っています。


{% gist 5292308 graph.ru %}

このコードのディレクトリでgvizコマンドを実行し、各レイアウト毎のpng画像を得ます。
{% highlight bash %}
% gviz
% open *.png
{% endhighlight %}

<br/>


##レイアウトサンプル─その１
生成されたレイアウト画像は以下のとおりです。

###dot
階層型のデフォルトレイアウトです。

![graphviz noshadow]({{ site.url }}/assets/images/2013/04/dot.png)


###neato
ばねモデルによる**neato**レイアウトです。全体のエネルギーが最小になるようなレイアウトを実現します。ノードが100程度のグラフ生成に適しているそうです。

![graphviz noshadow]({{ site.url }}/assets/images/2013/04/neato.png)

###fdp
同じくばねモデルによるレイアウトです。**neato**に似てますが、アルゴリズムが異なるようです。

![graphviz noshadow]({{ site.url }}/assets/images/2013/04/fdp.png)

###sfdp
**fdp**のマルチスケール版とのことです。ノードが大量にあるグラフに適しているそうです。

![graphviz noshadow]({{ site.url }}/assets/images/2013/04/sfdp.png)

###twopi
放射状レイアウトです。

![graphviz noshadow]({{ site.url }}/assets/images/2013/04/twopi.png)

###circo
環状レイアウトです。

![graphviz noshadow]({{ site.url }}/assets/images/2013/04/circo.png)

###osage
ノードを整列配置するレイアウトです。

![graphviz noshadow]({{ site.url }}/assets/images/2013/04/osage.png)

###patchwork
ノードをパッチワークのように配置するレイアウトです。

![graphviz noshadow]({{ site.url }}/assets/images/2013/04/patchwork.png)

<br />

レイアウトを変えただけで、こんなに多様なグラフが描けるなんて。Graphviz最高ですよね。

##サンプル生成─その２

続いて、バイナリーツリー型のグラフを生成してみます。コードは以下のとおり。

{% gist 5292308 tree.ru %}

ツリー生成のコードが若干トリッキーかも知れませんが、上から順番にツリーを作っているので追えばわかると思います。loopとeachを一気に抜けて終了するために**catch-throw**を使っています。

<br/>


##レイアウトサンプル２
生成されたレイアウト画像は以下のとおりです。

###dot

![graphviz noshadow]({{ site.url }}/assets/images/2013/04/tree_dot.png)

###neato

![graphviz noshadow]({{ site.url }}/assets/images/2013/04/tree_neato.png)

###fdp
![graphviz noshadow]({{ site.url }}/assets/images/2013/04/tree_fdp.png)

###sfdp
![graphviz noshadow]({{ site.url }}/assets/images/2013/04/tree_sfdp.png)

###twopi
![graphviz noshadow]({{ site.url }}/assets/images/2013/04/tree_twopi.png)

###circo
![graphviz noshadow]({{ site.url }}/assets/images/2013/04/tree_circo.png)

###osage
![graphviz noshadow]({{ site.url }}/assets/images/2013/04/tree_osage.png)

###patchwork
![graphviz noshadow]({{ site.url }}/assets/images/2013/04/tree_patchwork.png)


キレイ、キレイ！

以上、Graphvizのレイアウトサンプルを生成してみました。


---

<p style='color:red'>=== Ruby関連電子書籍100円で好評発売中！ ===</p>

[M'ELBORNE BOOKS]({{ site.url }}/books/ "M'ELBORNE BOOKS")

<a href="{{ BASE_PATH }}/books/">
  <img src="/assets/images/2012/start_ruby.jpg" alt="start_ruby" style="width:200px" />
</a>
<a href="{{ BASE_PATH }}/books/">
  <img src="/assets/images/2013/02/ruby_object_cover.png" alt="ruby_object" style="width:200px" />
</a>
<a href="{{ BASE_PATH }}/books/">
  <img src="/assets/images/2012/rack_cover.png" alt="rack" style="width:200px" />
</a>

---

{% footnotes %}
{% fn nop系の出力が上手くいかなかったので除外しました %}
{% endfootnotes %}
