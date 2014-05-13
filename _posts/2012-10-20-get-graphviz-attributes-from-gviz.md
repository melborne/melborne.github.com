---
layout: post
title: "GvizでGraphvizのノードの形とかエッジの形とか使える色の名前とかの属性情報をゲットするよ！"
description: ""
category: 
tags: 
date: 2012-10-20
published: true
---
{% include JB/setup %}

(追記：2014-3-3) Gvizについてのまとめ頁を作りました。

> [Gvizの目次 - Rubyの世界からGraphvizの世界にこんにちは！]({{ BASE_PATH }}/2014/02/27/gviz-posts/ "Gvizの目次 - Rubyの世界からGraphvizの世界にこんにちは！")

---

[Graphviz](http://www.graphviz.org/ 'Graphviz \| Graphviz - Graph Visualization Software')は楽しいです。簡単なコードで複雑なグラフを一瞬で生成してくれます。ノードやエッジの形を変えたり色を付けたりそれらの属性を調整することで、グラフは一層リッチになります。

でもこの属性が余りにも多岐にわたるので、その選択は時に困難を極めます。そのたびにGraphvizのサイトに逝って使える属性を確認する必要がでてきます。せめて使える属性の一覧が手元にほしいと切に思います。

そんなわけで..

RubyによるGraphvizラッパー`Gviz`の、そんな機能を含んだversion0.1.1を公開しましたのでお知らせします。

> [Gviz \| RubyGems.org \| your community gem host](https://rubygems.org/gems/gviz 'gviz \| RubyGems.org \| your community gem host')


## 属性情報の一覧表示
ver0.1.1ではgvizコマンドの`--man`または`-m`オプションで、Graphvizの各種属性情報を一覧する機能が追加されました。一覧できる属性情報は次の14種です。

    graph, node, edge, subgraph, cluster,
    arrows, shapes, output_formats
    color_names, color_schemes,
    full_color_names, full_color_schemes,
    svg_color_names, dark_colors

一部の出力を見てみます。
{% highlight bash %}
% gviz -m man
--man(-m) accepts any of them:
  graph, node, edge, subgraph, cluster,
  arrows, shapes, output_formats
  color_names, color_schemes,
  full_color_names, full_color_schem

--------------------
% gviz -m color_names
Color names:
  aliceblue, antiquewhite, aquamarine, azure, beige, bisque, black, blanchedalmond
  blueviolet, brown, burlywood, cadetblue, chartreuse, chocolate, coral
  cornsilk, crimson, cyan, darkgoldenrod, darkgreen, darkkhaki, darkolivegreen
  darkorchid, darksalmon, darkseagreen, darkslateblue, darkslategray
  darkturquoise, darkviolet, deeppink, deepskyblue, dimgray, dimgrey, dodgerblue
  floralwhite, forestgreen, gainsboro, ghostwhite, gold, goldenrod, gray, green
  grey, honeydew, hotpink, indianred, indigo, invis, ivory, khaki, lavender
  lawngreen, lemonchiffon, lightblue, lightcoral, lightcyan, lightgoldenrod
  lightgray, lightgrey, lightpink, lightsalmon, lightseagreen, lightskyblue
  lightslategray, lightslategrey, lightsteelblue, lightyellow, limegreen, linen
  maroon, mediumaquamarine, mediumblue, mediumorchid, mediumpurple
  mediumslateblue, mediumspringgreen, mediumturquoise, mediumvioletred
  mintcream, mistyrose, moccasin, navajowhite, navy, navyblue, none, oldlace, olivedrab
  orangered, orchid, palegoldenrod, palegreen, paleturquoise, palevioletred
  peachpuff, peru, pink, plum, powderblue, purple, red, rosybrown, royalblue, saddlebrown
  sandybrown, seagreen, seashell, sienna, skyblue, slateblue, slategray, slategrey
  springgreen, steelblue, tan, thistle, tomato, transparent, turquoise, violet

--------------------
% gviz -m shapes     
Shapes:
  box, polygon, ellipse, oval, circle, point, egg, triangle, plaintext, diamond, trapezium
  house, pentagon, hexagon, septagon, octagon, doublecircle, doubleoctagon
  invtriangle, invtrapezium, invhouse, Mdiamond, Msquare, Mcircle, rect, rectangle
  none, note, tab, folder, box3d, component, promoter, cds, terminator, utr, primersite
  fivepoverhang, threepoverhang, noverhang, assembly, signature, insulator

--------------------
% gviz -m arrows
Arrows:
  box, lbox, rbox, obox, olbox, orbox, crow, lcrow, rcrow, diamond, ldiamond, rdiamond
  oldiamond, ordiamond, dot, odot, inv, linv, rinv, oinv, olinv, orinv, none, normal, lnormal

--------------------
% gviz -m node
Node attributes (type|default|minimum|notes):
  URL (escString | <none> |  | svg, postscript, map only)
  area (double | 1.0 | >0 | patchwork only)
  color (color/colorList | black |  | )
  colorscheme (string |  |  | )
  comment (string |  |  | )
  distortion (double | 0.0 | -100.0 | )
  fillcolor (color/colorList | lightgrey(nodes)black(clusters) |  | )
  fixedsize (bool | false |  | )
  fontcolor (color | black |  | )
  fontname (string | Times-Roman |  | )
  fontsize (double | 14.0 | 1.0 | )  gradientangle (int |  |  | )
  group (string |  |  | dot only)
  height (double | 0.5 | 0.02 | )
  href (escString |  |  | svg, postscript, map only)
  id (escString |  |  | svg, postscript, map only)
      ------- 中略 -------
  shape (shape | ellipse |  | )
  shapefile (string |  |  | )
  showboxes (int | 0 | 0 | dot only)
  sides (int | 4 | 0 | )
  skew (double | 0.0 | -100.0 | )
  sortv (int | 0 | 0 | )
  style (style |  |  | )
  target (escString/string | <none> |  | svg, map only)
  tooltip (escString |  |  | svg, cmap only)
  vertices (pointList |  |  | write only)
  width (double | 0.75 | 0.01 | )
  xlabel (lblString |  |  | )
  z (double | 0.0 | -MAXFLOAT-1000 | )
{% endhighlight %}

これらのデータは[Documentation \| Graphviz - Graph Visualization Software](http://www.graphviz.org/Documentation.php 'Documentation \| Graphviz - Graph Visualization Software')を元にしています。

ローカルで`gviz`コマンドを叩けば属性情報が得られるので、そのたびにGraphvizのサイトにアクセスしないで済みます。助かりますね！

## 属性情報定数
一方で、上記一覧の出力を見てこんな不満の声が聞こえてきました。

    色とか形とかの名前がわかってもねぇ。結局現物見ないとなにがなんだか..

まあおっしゃる通りです..

実は上記属性情報はRubyのコードとして定数化しているので、グラフコードの中で呼ぶことができます。つまりGvizクラスは属性情報として次の定数を持っています。

    ARROWS, SHAPES, OUTPUT_FORMATS
    COLOR_NAMES, COLOR_SCHEMES,
    FULL_COLOR_NAMES, FULL_COLOR_SCHEMES,
    SVG_COLOR_NAMES, DARK_COLORS
    ATTR_BASE

ここで`ATTR_BASE`はgraph, node, edge, subgraph, clusterの属性情報を格納しており、`Gviz.ATTR`メソッドをを介して各要素の属性にアクセスできるようになっています。
{% highlight ruby %}
require 'gviz'

Gviz.ATTR :edge => [["URL", ["escString", "<none>", nil, "svg, postscript, map only"]], ["arrowhead", ["arrowType", "normal", nil, nil]], ["arrowsize", ["double", "1.0", "0.0", nil]], ["arrowtail", ["arrowType", "normal", nil, nil]], ["color", ["color/colorList", "black", nil, nil]], ["colorscheme", ["string", nil, nil, nil]], ["comment", ["string", nil, nil, nil]], ["constraint", ["bool", "true", nil, "dot only"]],  --- 中略 ---  ["tailtooltip", ["escString", nil, nil, "svg, cmap only"]], ["target", ["escString/string", "<none>", nil, "svg, map only"]], ["tooltip", ["escString", nil, nil, "svg, cmap only"]], ["weight", ["intdouble", "1", "0(dot)1(neato,fdp)", nil]], ["xlabel", ["lblString", nil, nil, nil]]]
{% endhighlight %}

という訳で、これらの属性情報定数を使って属性値をビジュアライズしたグラフを描き、それを手元で参照すればいいって寸法になります。

## 属性情報サンプルグラフを作る
早速属性情報定数を使ってサンプルグラフを書いてみます。

まずは`COLOR_NAMES`を使って色付きノードを描きます。
{% highlight ruby %}
#graph.ru
global layout:'neato'
nodes style:'filled'

COLOR_NAMES.each do |c|
  fc = DARK_COLORS.include?(c) ? 'white' : 'black'
  node c.intern, label:c, fillcolor:c, color:c, fontcolor:fc
end

save :attributes
{% endhighlight %}

ファイルのディレクトリで`gviz`コマンドを実行し、生成されたdotファイルを開きます。
{% highlight bash %}
% gviz
% open attributes.dot
{% endhighlight %}

結果は次のようになります。

<a href="{{ site.url }}/assets/images/2012/attr1.png" rel="lightbox" title="Graph Attributes"><img src="{{ site.url }}/assets/images/2012/attr1.png" alt="attributes noshadow" /></a>
（クリックで拡大します）

このファイルをローカルに置いておけばいつでも色見本を参照できます。

ここでは更に進んでノードの型（shape）を重ねてみます。
{% highlight ruby %}
global layout:'neato'
nodes style:'filled'

+ shapes = SHAPES.cycle

COLOR_NAMES.each do |c|
  fc = DARK_COLORS.include?(c) ? 'white' : 'black'
+  s = shapes.next
+  node c.intern, label:"#{c}\n#{s}", fillcolor:c, color:c, fontcolor:fc,
+                 shape:s
end

save :attributes, :png
{% endhighlight %}

gvizしてattributes.dotを開きます。自分の環境では一部のshapeは無効化されて`box`になるとの警告がでましたが、結果は次のとおりです。

<a href="{{ site.url }}/assets/images/2012/attr2.png" rel="lightbox" title="Graph Attributes"><img src="{{ site.url }}/assets/images/2012/attr2.png" alt="attributes noshadow" /></a>
（クリックで拡大します）

楽しいですね！

ここでは更にもう一歩進んで、エッジ情報も載せましょう。
{% highlight ruby %}
+ global layout:'neato', overlap:false, size:16
nodes style:'filled'

shapes = SHAPES.cycle

COLOR_NAMES.each do |c|
  fc = DARK_COLORS.include?(c) ? 'white' : 'black'
  s = shapes.next
  node c.intern, label:"#{c}\n#{s}", fillcolor:c, color:c, fontcolor:fc,
                 shape:s
end

+ arrows = ARROWS.cycle
+ 
+ COLOR_NAMES.shuffle.each_slice(7) do |sun, *astros|
+   arr = arrows.next
+   route sun => astros
+   edge "#{sun}_*", arrowhead:arr, label:arr
+ end

save :attributes, :png
{% endhighlight %}

こんなグラフが出力されました。

<a href="{{ site.url }}/assets/images/2012/attr3.png" rel="lightbox" title="Graph Attributes"><img src="{{ site.url }}/assets/images/2012/attr3.png" alt="attributes noshadow" /></a>
（クリックで拡大します）

このグラフを参照すれば、使える色、ノードの形、エッジの形が一度に全部見られますね！

以上、Gvizの新機能の紹介でした。

{{ 4873114896 | amazon_medium_image }}
{{ 4873114896 | amazon_link }} by {{ 4873114896 | amazon_authors }}
