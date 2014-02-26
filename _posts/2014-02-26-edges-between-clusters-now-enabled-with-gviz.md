---
layout: post
title: "Gviz（Graphviz ruby wrapper）でクラスタエッジとか無向グラフとか"
description: ""
category: 
tags: 
date: 2014-02-26
published: true
---
{% include JB/setup %}

Twitterで@k1LoWさんから、次のような質問というかリクエストを頂きました。

![Alt title ]({{ BASE_PATH }}/assets/images/2014/02/gviz_subgraph01.png)

> [Twitter / k1LoW: @merborne 突然すみません質問です!Givzでsub ...](https://twitter.com/k1LoW/status/437877575839268864 "Twitter / k1LoW: @merborne 突然すみません質問です!Givzでsub ...")

Graphvizではfdpレイアウトにおいて、subgraph（cluster）を結ぶエッジをそれらの名前を使って作ることができます。

![Alt title noshadow]({{ BASE_PATH }}/assets/images/2014/02/gviz_subgraph02.png)

> [Graphviz Example: Undirected Graph Clusters | Graphviz - Graph Visualization Software](http://www.graphviz.org/content/fdpclust "Graphviz Example: Undirected Graph Clusters | Graphviz - Graph Visualization Software")

Gvizでは、subgraphの名前は自動で付けられてしまう（cluster+0からの連番）のでこれができませんでした。またこの検証に際して、無向グラフ（undirected graph）にもちゃんと対応していなかったことも発覚しました。これは実に有難いリクエストになりました。

そんなわけで...

早々これらに対応したversion0.3.4をリリースしました。

> [gviz | RubyGems.org | your community gem host](https://rubygems.org/gems/gviz "gviz | RubyGems.org | your community gem host")
> 
> [melborne/Gviz](https://github.com/melborne/Gviz "melborne/Gviz")

Gvizで先のグラフを再現するには次のようにします。

{% gist 9221580 %}

Graphメソッドの第２引数に`:graph`を指定することにより無向グラフが描画されます。クラスタエッジを実現するにはlayoutに`fdp`を指定します。`subgraph`メソッドに任意の名前を渡します。`route`メソッドを使ってそれらの名前を結びます。

実行します。

    % ruby sample.rb
    % open sample.dot

次のようなグラフが得られます。

![Alt title noshadow]({{ BASE_PATH }}/assets/images/2014/02/gviz_subgraph03.png)


いいみたいですね。


---

<p style='color:red'>=== Ruby関連電子書籍100円〜で好評発売中！ ===</p>

[M'ELBORNE BOOKS]({{ BASE_PATH }}/books/ "M'ELBORNE BOOKS")

<a href="{{ BASE_PATH }}/books/">
  <img src="/assets/images/books/rack_cover.png" alt="rack" style="width:200px" />
</a>
<a href="{{ BASE_PATH }}/books/">
  <img src="/assets/images/books/ruby_pack8.png" alt="pack8" style="width:200px" />
</a>
<a href="{{ BASE_PATH }}/books/">
  <img src="/assets/images/books/ruby_parallel_cover.png" alt="ruby_parallel" style="width:200px" />
</a>


