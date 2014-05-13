---
layout: post
title: "ピクミンがGraphvizにやって来た！"
tagline: "Gvizアップデートのお知らせ"
description: ""
category: 
tags: 
date: 2013-08-09
published: true
---
{% include JB/setup %}

(追記：2014-3-3) Gvizについてのまとめ頁を作りました。

> [Gvizの目次 - Rubyの世界からGraphvizの世界にこんにちは！]({{ BASE_PATH }}/2014/02/27/gviz-posts/ "Gvizの目次 - Rubyの世界からGraphvizの世界にこんにちは！")

---

任天堂のWiiU向けゲーム「[ピクミン３](http://www.nintendo.co.jp/wiiu/ac3j/index.html "ピクミン３")」にハマってます。「ストーリーモード」もいいですが、ボッチじゃないなら「ミッションモード」と「ビンゴバトルモード」が最高です。ピクミンを集め、移動して、投げる。ただひたすらそれを繰り返すだけのゲームです。でも、ピクミンをいつ集め、どこに移動し、どのピクミンを投げるのか、それによって無限の組合せが生じ、その選択が勝負の行方を大きく左右するのです。段取り力が問われるのです。この段取りに対する不思議な向上意欲とピクミンの愛らしさとが相まって、僕はピクミンの世界から当分抜け出せそうにありません。


<p><a href="http://www.amazon.co.jp/任天堂-WUP-P-AC3J-ピクミン3/dp/B00CTK1JR2?SubscriptionId=06WK2XPKDH9TJJ979P02&tag=keyesblog05-22&linkCode=xm2&camp=2025&creative=165953&creativeASIN=B00CTK1JR2"><img class="amazon" src="http://ecx.images-amazon.com/images/I/615ai1TSkxL._SL160_.jpg" alt='noshadow' /></a>
<a href="http://www.amazon.co.jp/任天堂-WUP-P-AC3J-ピクミン3/dp/B00CTK1JR2?SubscriptionId=06WK2XPKDH9TJJ979P02&tag=keyesblog05-22&linkCode=xm2&camp=2025&creative=165953&creativeASIN=B00CTK1JR2">ピクミン3</a></p>

---

さて今回は、愛くるしくもどこか悲しげな顔をした「ピクミン」たちを、拙作`Gviz`を使ってGraphviz上に出現させたいと思います。

で、その前にGvizをアップデートしましたのでそのお知らせと宣伝を...

## Gviz 0.2.0

RubyによるGraphvizラッパー`Gviz`をアップデートしました（version 0.2.0）。

> [gviz \| RubyGems.org \| your community gem host](https://rubygems.org/gems/gviz 'gviz \| RubyGems.org \| your community gem host')

> [melborne/Gviz · GitHub](https://github.com/melborne/Gviz "melborne/Gviz · GitHub")

`Gviz`を使えば簡単に有向グラフや、米国統計地図や、地下鉄路線図や、フィボナッチと素数の出会いや、AKB48や、Rubyのロゴや、日本地図や、スペースインベーダーや、類似度世界地図などが描けます。

> [Yet Another Ruby Graphviz Interfaceを作ったからみんなで大量のグラフを作って遊ぼうよ！]({{ site.url }}/2012/09/25/ruby-plus-graphviz-should-eql-gviz/ "Yet Another Ruby Graphviz Interfaceを作ったからみんなで大量のグラフを作って遊ぼうよ！")
> 
> [Ruby Graphvizラッパー「Gviz」でアメリカ合衆国をデータビジュアライズしよう！]({{ site.url }}/2012/09/27/usstates-map-data-vasualization-with-gviz/ "Ruby Graphvizラッパー「Gviz」でアメリカ合衆国をデータビジュアライズしよう！")
> 
> [東京の地下鉄をGviz（Ruby Graphviz Wrapper）で描く]({{ site.url }}/2012/10/02/draw-metro-map-with-gviz/ "東京の地下鉄をGviz（Ruby Graphviz Wrapper）で描く")
> 
> [素数とフィボナッチ数の出会いをGviz（Ruby Graphviz Wrapper）で描く]({{ site.url }}/2012/10/07/meet-prime-with-fibonacci/ "素数とフィボナッチ数の出会いをGviz（Ruby Graphviz Wrapper）で描く")
> 
> [GvizでAKB48をビジュアライズするよ！]({{ site.url }}/2012/10/16/add-gviz-command-to-gviz-gem/ "GvizでAKB48をビジュアライズするよ！")
> 
> [GraphvizでRubyのロゴは描けますか？]({{ site.url }}/2012/12/04/simple-ruby-logo-with-gviz/ "GraphvizでRubyのロゴは描けますか？")
> 
> [Graphvizで作る、私たちの国「日本」の今度こそ本当の姿かたち]({{ site.url }}/2013/03/25/map-of-japan-2/ "Graphvizで作る、私たちの国「日本」の今度こそ本当の姿かたち")
> 
> [スペースインベーダー、Graphviz侵略ス]({{ site.url }}/2013/03/28/space-invader-invade-graphviz-kingdom/ "スペースインベーダー、Graphviz侵略ス")
> 
> [Graphvizで作る国旗の類似度世界地図]({{ site.url }}/2013/04/23/map-of-national-flags-with-graphviz/ "Graphvizで作る国旗の類似度世界地図")


## インストール
Graphvizが必要です。自分のプラットフォームに合ったものを以下から入手して下さい。

> [Download. \| Graphviz - Graph Visualization Software](http://www.graphviz.org/Download..php 'Download. \| Graphviz - Graph Visualization Software')

Gvizのインストールは`gem install gviz`でＯＫです。Rubyはたぶん1.9.3以降が必要となります。

## 変更点
ver0.2.0では機能の追加はありませんが、コマンドインタフェースに[Thor](http://whatisthor.com/ "Thor - Home")を使うことで仕様が少し変わりました（以前は、[Trollop](http://trollop.rubyforge.org/ "Trollop")を使っていました）。

ターミナル上で`gviz`コマンドを実行すると、簡単な説明とコマンドのリストが表示されます。

{% highlight bash %}
% gviz
Gviz is a tool for generating graphviz dot data with simple Ruby's syntax.
It works with a graph spec file (defaulting to load 'graph.ru').

Example of graph.ru:

  route :main => [:init, :parse, :cleanup, :printf]
  route :init => :make, :parse => :execute
  route :execute => [:make, :compare, :printf]

  save(:sample, :png)

Commands:
  gviz build [FILE]    # Build a graphviz dot data based on a file
  gviz help [COMMAND]  # Describe available commands or one specific command
  gviz man [NAME]      # Show available attributes, constants, colors for graphviz
  gviz version         # Show Gviz version

{% endhighlight %}

### gviz buildコマンド

以前の`gviz`コマンドは`gviz build`コマンドになりました。

gvizコマンドで表示される例に従って、'graph.ru'ファイルを用意しこのコマンドを実行します（ファイル名が'graph.ru'以外のときは引数としてファイル名を渡します）。

{% highlight bash %}
try_gviz% gviz build
try_gviz% ls
graph.ru   sample.dot sample.png
try_gviz% open sample.png
{% endhighlight %}

以下の画像が得られます。

![Alt title noshadow]({{ site.url }}/assets/images/2013/08/gviz_sample.png)

### gviz manコマンド

Graphvizで使用可能な属性や色の情報を表示するためのコマンドです。引数なしで実行すると引数として取れる属性が表示されます。

{% highlight bash %}
try_gviz% gviz man
Specify any of:
  graph, node, edge, subgraph, cluster
  arrows, shapes, layouts, output_formats
  color_names, color_schemes, full_color_names, full_color_schemes, svg_color_names, dark_colors

try_gviz% gviz man shapes
Arrows:
  box, lbox, rbox, obox, olbox, orbox, crow, lcrow, rcrow, diamond, ldiamond, rdiamond
  oldiamond, ordiamond, dot, odot, inv, linv, rinv, oinv, olinv, orinv, none, normal, lnormal
  onormal, olnormal, ornormal, tee, ltee, rtee, vee, lvee, rvee, curve, lcurve, rcurve
Shapes:
  box, polygon, ellipse, oval, circle, point, egg, triangle, plaintext, diamond, trapezium
  house, pentagon, hexagon, septagon, octagon, doublecircle, doubleoctagon
  invtriangle, invtrapezium, invhouse, Mdiamond, Msquare, Mcircle, rect, rectangle
  none, note, tab, folder, box3d, component, promoter, cds, terminator, utr, primersite
  fivepoverhang, threepoverhang, noverhang, assembly, signature, insulator
  rnastab, proteasesite, proteinstab, rpromoter, rarrow, larrow, lpromoter
Layouts:
  circo, dot, fdp, neato, nop, nop1, nop2, osage, patchwork, sfdp, twopi
Output formats:
  bmp, canon, dot, xdot, cmap, eps, fig, gd, gd2, gif, gtk, ico, imap, cmapx, imap_np, cmapx_np, ismap
  jpeg, jpe, pdf, plain, plain-ext, png, ps, ps2, svg, svgz, tif, tiff, vml, vmlz, vrml, wbmp, webp, xlib
{% endhighlight %}

<br />


## Graphvizでピクミンを描く

さて、Gvizの紹介が終わったので本題にいきましょう。ピクミンをGraphviz上で描きます。

と言っても、自分には絵心がないので、ネット上からピクミンの画像を拝借してそれをGraphviz上に転写する、ということにします（何の意味があるのかというのは置いておいて...）。

一方で、Graphvizにはそのノードに画像を貼り付ける`image`という属性があるので、これを使えば簡単に画像をGraphviz上に貼ることができてしまいます。これではあまりにも芸がないので、今回は以下のような方針をとります。

    1. 元画像における各ピクセルからその位置と色の情報を取得する。
    2. 取得した各ピクセルをノードとしてGraphviz上に配置する。

## ピクセル情報の取得

以下の画像を利用させて頂きます。

![Alt title noshadow]({{ site.url }}/assets/images/2013/08/yellow_pikmin.png)

<a href="http://pikmin3.nintendo.com/_ui/img/chars/pikminology/yellow.png">yellow.png (PNG 画像, 256x490 px)</a> ([Official Site - Pikmin 3 for Wii U](http://pikmin3.nintendo.com/ "Official Site - Pikmin 3 for Wii U"))

軽くて電気に強く、穴掘りも得意な黄ピクミンです。かわいい。

ピクセル情報の取得には[ImageMagick](http://www.imagemagick.org/script/index.php "ImageMagick: Convert, Edit, Or Compose Bitmap Images")とそのRubyインタフェースである[RMagick](http://www.imagemagick.org/RMagick/doc/index.html "RMagick 2.12.0 User's Guide and Reference")を使います。

`pikmin.rb`で次のようなコードを書いて、colors変数に各ピクセルの位置と色の情報を持ったハッシュを参照できるようにします。

{% highlight ruby %}
require "RMagick"

image_file = 'yellow.png'

img = Magick::ImageList.new(image_file).scale(0.5) # => yellow.png PNG 256x490=>128x245 128x245+0+0 DirectClass 8-bit

colors = {}
img.rows.times do |y|
  img.columns.times do |x|
    color = img.pixel_color(x, y).to_color(Magick::AllCompliance,false,8)
    colors[[x, y]] = color
  end
end

p colors
{% endhighlight %}

`to_color`メソッドの第3引数に8を渡すことで8ビット表現のRGBを取得するようにしています。colorsの中身は座標をキー、色を値としたハッシュデータです。

{% highlight ruby %}
>> {[0, 0]=>"black", [1, 0]=>"black", [2, 0]=>"black", [3, 0]=>"black", [4, 0]=>"black", [5, 0]=>"black", [6, 0]=>"black", [7, 0]=>"black", [8, 0]=>"black", [9, 0]=>"black", [10, 0]=>"black", [11, 0]=>"black", [12, 0]=>"black", [13, 0]=>"black", [14, 0]=>"black", [15, 0]=>"black", [16, 0]=>"black", [17, 0]=>"black", [18, 0]=>"black", [19, 0]=>"black", [20, 0]=>"black", [21, 0]=>"black", [22, 0]=>"black", [23, 0]=>"black", [24, 0]=>"black", [25, 0]=>"black", [26, 0]=>"black", [27, 0]=>"black", [28, 0]=>"black", [29, 0]=>"black", [30, 0]=>"black", [31, 0]=>"black", [32, 0]=>"black", [33, 0]=>"black", [34, 0]=>"black", [35, 0]=>"black", [36, 0]=>"black", [37, 0]=>"black", [38, 0]=>"black", [39, 0]=>"black", [40, 0]=>"black", [41, 0]=>"black", [42, 0]=>"black", [43, 0]=>"black", [44, 0]=>"black", [45, 0]=>"black", [46, 0]=>"black", [47, 0]=>"black", [48, 0]=>"black", [49, 0]=>"black", [50, 0]=>"black", [51, 0]=>"black", [52, 0]=>"black", [53, 0]=>"black", [54, 0]=>"black", [55, 0]=>"#FAFFFE", [56, 0]=>"#F7FFFD", [57, 0]=>"#F8FFFE", [58, 0]=>"#FFFFFF", [59, 0]=>"#FDFFFF", [60, 0]=>"#FAFFFE", [61, 0]=>"#FAFFFD", [62, 0]=>"#F8FFFF", [63, 0]=>"#F9FEFF", [64, 0]=>"#F8FAF8", [65, 0]=>"#F8F9F8", [66, 0]=>"#F8F8F8", [67, 0]=>"#F8F8F8", [68, 0]=>"#F5F8F8", [69, 0]=>"#F5F8F8", [70, 0]=>"#F1F8F6", [71, 0]=>"#F1F8F9", [72, 0]=>"#F3F5F5", [73, 0]=>"#F1F0F0", [74, 0]=>"black", [75, 0]=>"black",...
{% endhighlight %}

ImageList#scaleで画像サイズを1/2にしましたが、依然ピクセル数が31,360(128*245)もあるので、処理が困難そうです。背景色（black）と偶数座標ピクセルを間引いて対処します。

{% highlight ruby %}
img = Magick::ImageList.new(image_file).scale(0.5)

colors = {}
img.rows.times do |y|
  img.columns.times do |x|
+    next if [x, y].all?(&:even?)
    color = img.pixel_color(x, y).to_color(Magick::AllCompliance,false,8)
+    colors[[x, y]] = color unless color.match(/black/)
  end
end

colors.size # => 7811
{% endhighlight %}

このくらいの数なら対応できそうです。


## ノードの描画

さて、ピクセル情報が取得できたので、これらの情報を使ってGraphviz上にノードを描画します。色はノードの`fillcolor`、位置は`pos`属性をそれぞれ使います。

`pikmin.rb`に次のコードを書き足して、7811個のノードを描きます。

{% highlight ruby %}

global layout:'neato'
nodes shape:'circle', style:'filled'

colors.each do |(x,y), val|
  node :"#{x}#{y}", label:'', color:val, fillcolor:val, pos:"#{x},#{y}!"
end

save :pikmin
{% endhighlight %}

`gviz build`を実行しGraphviz DOTデータを生成します。

{% highlight bash %}
pikmin% gviz build pikmin.rb
pikmin% open pikmin.dot
{% endhighlight %}

さて、結果は...

![Alt title noshadow]({{ site.url }}/assets/images/2013/08/gv_fail_pikmin.png)

おおっ。

黄ピクミンがいる...けど...

<br />


ノードサイズを小さくし、座標を10倍にして配置を調整します。またGraphvizの座標系は左下が原点のようなのでこれも直します。

{% highlight ruby %}
global layout:'neato'
+nodes shape:'circle', style:'filled', width:0.3

colors.each do |(x,y), val|
+  node :"#{x}#{y}", label:'', color:val, fillcolor:val, pos:"#{x*10},#{-y*10}!"
end

save :pikmin
{% endhighlight %}


さあ、どうでしょう。

![Alt title noshadow]({{ site.url }}/assets/images/2013/08/gv_yellow_pikmin.png)

黄ピクミン！かわいい！

<br />

じゃあ、全員集合！

<img src="/assets/images/2013/08/gv_red_pikmin.png" alt="noshadow" style="width:100px" />
<img src="/assets/images/2013/08/gv_blue_pikmin.png" alt="noshadow" style="width:100px" />
<img src="/assets/images/2013/08/gv_yellow_pikmin.png" alt="noshadow" style="width:100px" />
<img src="/assets/images/2013/08/gv_rock_pikmin.png" alt="noshadow" style="width:100px" />
<img src="/assets/images/2013/08/gv_pink_pikmin.png" alt="noshadow" style="width:100px" />


Graphvizでピクミンでした :-)

{% gist 6192317 %}

> [gviz \| RubyGems.org \| your community gem host](https://rubygems.org/gems/gviz 'gviz \| RubyGems.org \| your community gem host')

> [melborne/Gviz · GitHub](https://github.com/melborne/Gviz "melborne/Gviz · GitHub")


---

<p><a href="http://www.amazon.co.jp/任天堂-WUP-P-AC3J-ピクミン3/dp/B00CTK1JR2?SubscriptionId=06WK2XPKDH9TJJ979P02&tag=keyesblog05-22&linkCode=xm2&camp=2025&creative=165953&creativeASIN=B00CTK1JR2"><img class="amazon" src="http://ecx.images-amazon.com/images/I/615ai1TSkxL._SL160_.jpg" alt='noshadow' /></a>
<a href="http://www.amazon.co.jp/任天堂-WUP-P-AC3J-ピクミン3/dp/B00CTK1JR2?SubscriptionId=06WK2XPKDH9TJJ979P02&tag=keyesblog05-22&linkCode=xm2&camp=2025&creative=165953&creativeASIN=B00CTK1JR2">ピクミン3</a></p>

