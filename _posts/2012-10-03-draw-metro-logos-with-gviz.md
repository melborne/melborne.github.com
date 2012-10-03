---
layout: post
title: "東京の地下鉄の路線サインをGviz（Ruby Graphviz Wrapper）で描く"
description: ""
category: 
tags: [graphviz, gem] 
date: 2012-10-03
published: true
---
{% include JB/setup %}

前回の投稿で東京の地下鉄路線図を描きました。

> [東京の地下鉄をGviz（Ruby Graphviz Wrapper）で描く](http://melborne.github.com/2012/10/02/draw-metro-map-with-gviz/ '東京の地下鉄をGviz（Ruby Graphviz Wrapper）で描く')

こうなると路線サインもほしいです。作りましょう、[Gviz](https://rubygems.org/gems/gviz 'gviz | RubyGems.org | your community gem host')で。

## データの準備
前回使ったcolorsをそのまま使います。これに各路線のマークを統合します。
{% highlight ruby %}
# encoding: UTF-8
require "gviz"

colors = [["銀座線", "#f39700"], ["丸ノ内線", "#e60012"], ["日比谷線", "#9caeb7"], ["東西線", "#00a7db"], ["千代田線", "#009944"], ["有楽町線", "#d7c447"], ["半蔵門線", "#9b7cb6"], ["南北線", "#00ada9"], ["副都心線", "#bb641d"], ["浅草線", "#e85298"], ["三田線", "#0079c2"], ["新宿線", "#6cbb5a"], ["大江戸線", "#b6007a"], ["荒川線", "#7aaa16"], ["舎人ライナー", "#999999"]]

marks = %w(G M H T C Y Z N F A I S E).map(&:intern)

logodata = marks.zip(colors).map(&:flatten) # => [[:G, "銀座線", "#f39700"], [:M, "丸ノ内線", "#e60012"], [:H, "日比谷線", "#9caeb7"], [:T, "東西線", "#00a7db"], [:C, "千代田線", "#009944"], [:Y, "有楽町線", "#d7c447"], [:Z, "半蔵門線", "#9b7cb6"], [:N, "南北線", "#00ada9"], [:F, "副都心線", "#bb641d"], [:A, "浅草線", "#e85298"], [:I, "三田線", "#0079c2"], [:S, "新宿線", "#6cbb5a"], [:E, "大江戸線", "#b6007a"]]
{% endhighlight %}

## 路線サインの描画

さて下準備ができたので路線サインを描きます。各ノードの輪郭線を太くして色を付けます。フォントは「新ゴ」「Frutiger Condensed」というのが使われてるそうですが{% fn_ref 1 %}、ここでは似たもので代用します。
{% highlight ruby %}
Graph do
  nodes shape:'circle', penwidth:16, fontname:'Futura', fontsize:24
  logodata.each do |id, line, color|
    subgraph do
      global label:line, fontname:'Hiragino Maru Gothic Pro', labelloc:'b', color:'white'
      node id, color:color
    end
  end
  save(:logo, :png)
end
{% endhighlight %}


完成品はこちら！

<a href="{{ site.url }}/assets/images/2012/metrologo.png" rel="lightbox" title="Metro Logo"><img src="{{ site.url }}/assets/images/2012/metrologo.png" alt="metro noshadow" /></a>
（クリックで拡大します）


キレイキレイ！


以上ですm(__)m

----

関連記事：

[Yet Another Ruby Graphviz Interfaceを作ったからみんなで大量のグラフを作って遊ぼうよ！](http://melborne.github.com/2012/09/25/ruby-plus-graphviz-should-eql-gviz/ 'Yet Another Ruby Graphviz Interfaceを作ったからみんなで大量のグラフを作って遊ぼうよ！')

[Ruby Graphvizラッパー「Gviz」でアメリカ合衆国をデータビジュアライズしよう！](http://melborne.github.com/2012/09/27/usstates-map-data-vasualization-with-gviz/ 'Ruby Graphvizラッパー「Gviz」でアメリカ合衆国をデータビジュアライズしよう！')

[東京の地下鉄をGviz（Ruby Graphviz Wrapper）で描く](http://melborne.github.com/2012/10/02/draw-metro-map-with-gviz/ '東京の地下鉄をGviz（Ruby Graphviz Wrapper）で描く')

----

{% footnotes %}
{% fn http://kiccho.ausp.net/archives/2008/03/tokyo_metro_sign_font.html %}
{% endfootnotes %}

----

{{ 4892955655 | amazon_medium_image }}
{{ 4892955655 | amazon_link }} by {{ 4892955655 | amazon_authors }}

