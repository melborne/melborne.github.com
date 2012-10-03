---
layout: post
title: "Yet Another Ruby Graphviz Interfaceを作ったからみんなで大量のグラフを作って遊ぼうよ！"
description: ""
category: 
tags: [graphviz, gem]
date: 2012-09-25
published: true
---
{% include JB/setup %}

このブログとかでたまに無向だとか有向だとかのチャートの方じゃないグラフが書きたいと思うことがあるよ。でまさかこのご時世で今更**VISIO**とかあり得ないから[Graphviz](http://www.graphviz.org/Home.php 'Graphviz')のdotファイルを書くことになるんだけどDOT言語は制御構造を持ってないから結局より高級な言語によるインタフェースが必要になるよ。で`Ruby`の出番ってことになるんだけどGithubで"**graphviz ruby**"で検索すると1200件以上ものリポジトリがヒットするんだよ。でこの中から適当なものを選んで使えばいいってことなんだろうけどさすがにこれだけあるとどれを選んでいいか全然わからないから結局[The Ruby Toolbox](https://www.ruby-toolbox.com/ 'The Ruby Toolbox')当たりで"**graphviz**"にヒットする20件くらいの中からDownload数の多いものを１つ２つ試してみるって結末になるよ。でそれらのインタフェースが今ひとつシックリ来ない要はRubyっぽくないとかおまえ内部ＤＳＬやり過ぎ！ってのに当たるともう面倒臭いからオレが適当にでっち上げたほうがいいかもって結論に至るんだけど。で一般に車輪の再発明は悪ってことになってるんだけどどうやらRuby界隈では奨励されているみたいな空気があるんだよね最近{% fn_ref 1 %}。

そんなわけで...

`Gviz`というRubyのGraphvizインタフェースを作りましたので、ここで紹介させて下さい^ ^;

## 使い方

まずは`gem install gviz`としまして、次のようなコードを書きます。

{% highlight ruby %}
require "gviz"

gv = Gviz.new
gv.graph do
  route :main => [:init, :parse, :cleanup, :printf]
  route :init => :make, :parse => :execute
  route :execute => [:make, :compare, :printf]
end

gv.save(:sample1, :png)
{% endhighlight %}
まずは`Gviz.new`でgvizオブジェクトを生成して、`graph`のブロックの中で`route`メソッドでルート、つまりノードとエッジの繋がりをハッシュ形式で記述します。シンボルだけを渡すと単独のノードを生成します。`save`メソッドは与えられたファイル名でdotファイルを出力します。更に上のようにフォーマットを指定すると、dotファイルに加えてその形式のファイルも出力します。saveせずに`puts gv`とすれば標準出力にdotのコードが出力されるので、`ruby sample.rb > sample1.dot`などとしてもいいです。

出力グラフは次のようになります。

<svg width="274pt" height="260pt"
 viewBox="0.00 0.00 274.00 260.00" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink">
<g id="graph1" class="graph" transform="scale(1 1) rotate(0) translate(4 256)">
<title>G</title>
<polygon fill="white" stroke="white" points="-4,5 -4,-256 271,-256 271,5 -4,5"/>
<g id="node1" class="node"><title>main</title>
<ellipse fill="none" stroke="black" cx="135" cy="-234" rx="30.0202" ry="18"/>
<text text-anchor="middle" x="135" y="-228.4" font-family="Times,serif" font-size="14.00">main</text>
</g>
<g id="node2" class="node"><title>init</title>
<ellipse fill="none" stroke="black" cx="31" cy="-90" rx="27" ry="18"/>
<text text-anchor="middle" x="31" y="-84.4" font-family="Times,serif" font-size="14.00">init</text>
</g>
<g id="edge2" class="edge"><title>main&#45;&gt;init</title>
<path fill="none" stroke="black" d="M109.879,-223.739C90.5298,-215.297 64.6824,-200.927 50,-180 37.3492,-161.968 32.8424,-137.181 31.3613,-118.344"/>
<polygon fill="black" stroke="black" points="34.8531,-118.097 30.8085,-108.305 27.8637,-118.482 34.8531,-118.097"/>
</g>
<g id="node3" class="node"><title>parse</title>
<ellipse fill="none" stroke="black" cx="90" cy="-162" rx="31.1178" ry="18"/>
<text text-anchor="middle" x="90" y="-156.4" font-family="Times,serif" font-size="14.00">parse</text>
</g>
<g id="edge4" class="edge"><title>main&#45;&gt;parse</title>
<path fill="none" stroke="black" d="M124.563,-216.765C118.997,-208.106 112.033,-197.273 105.817,-187.604"/>
<polygon fill="black" stroke="black" points="108.732,-185.666 100.38,-179.147 102.844,-189.452 108.732,-185.666"/>
</g>
<g id="node4" class="node"><title>cleanup</title>
<ellipse fill="none" stroke="black" cx="180" cy="-162" rx="41.0954" ry="18"/>
<text text-anchor="middle" x="180" y="-156.4" font-family="Times,serif" font-size="14.00">cleanup</text>
</g>
<g id="edge6" class="edge"><title>main&#45;&gt;cleanup</title>
<path fill="none" stroke="black" d="M145.437,-216.765C150.867,-208.317 157.629,-197.799 163.728,-188.312"/>
<polygon fill="black" stroke="black" points="166.844,-189.938 169.307,-179.633 160.955,-186.153 166.844,-189.938"/>
</g>
<g id="node5" class="node"><title>printf</title>
<ellipse fill="none" stroke="black" cx="234" cy="-18" rx="32.2368" ry="18"/>
<text text-anchor="middle" x="234" y="-12.4" font-family="Times,serif" font-size="14.00">printf</text>
</g>
<g id="edge8" class="edge"><title>main&#45;&gt;printf</title>
<path fill="none" stroke="black" d="M162.394,-225.885C184.853,-218.464 215.255,-204.411 230,-180 254.915,-138.752 248.096,-80.0711 240.979,-46.1253"/>
<polygon fill="black" stroke="black" points="244.315,-45.0095 238.697,-36.0265 237.487,-46.552 244.315,-45.0095"/>
</g>
<g id="node6" class="node"><title>make</title>
<ellipse fill="none" stroke="black" cx="31" cy="-18" rx="31.4242" ry="18"/>
<text text-anchor="middle" x="31" y="-12.4" font-family="Times,serif" font-size="14.00">make</text>
</g>
<g id="edge10" class="edge"><title>init&#45;&gt;make</title>
<path fill="none" stroke="black" d="M31,-71.6966C31,-63.9827 31,-54.7125 31,-46.1124"/>
<polygon fill="black" stroke="black" points="34.5001,-46.1043 31,-36.1043 27.5001,-46.1044 34.5001,-46.1043"/>
</g>
<g id="node7" class="node"><title>execute</title>
<ellipse fill="none" stroke="black" cx="121" cy="-90" rx="40.2818" ry="18"/>
<text text-anchor="middle" x="121" y="-84.4" font-family="Times,serif" font-size="14.00">execute</text>
</g>
<g id="edge12" class="edge"><title>parse&#45;&gt;execute</title>
<path fill="none" stroke="black" d="M97.3466,-144.411C100.923,-136.335 105.309,-126.431 109.329,-117.355"/>
<polygon fill="black" stroke="black" points="112.642,-118.517 113.491,-107.956 106.241,-115.682 112.642,-118.517"/>
</g>
<g id="edge18" class="edge"><title>execute&#45;&gt;printf</title>
<path fill="none" stroke="black" d="M143.596,-75.0027C161.054,-64.1875 185.367,-49.1266 204.382,-37.3471"/>
<polygon fill="black" stroke="black" points="206.312,-40.2689 212.97,-32.0274 202.626,-34.3182 206.312,-40.2689"/>
</g>
<g id="edge14" class="edge"><title>execute&#45;&gt;make</title>
<path fill="none" stroke="black" d="M101.471,-73.811C88.4198,-63.6599 71.106,-50.1935 56.9062,-39.1492"/>
<polygon fill="black" stroke="black" points="59.0035,-36.3465 48.9611,-32.9698 54.7059,-41.872 59.0035,-36.3465"/>
</g>
<g id="node8" class="node"><title>compare</title>
<ellipse fill="none" stroke="black" cx="125" cy="-18" rx="43.9209" ry="18"/>
<text text-anchor="middle" x="125" y="-12.4" font-family="Times,serif" font-size="14.00">compare</text>
</g>
<g id="edge16" class="edge"><title>execute&#45;&gt;compare</title>
<path fill="none" stroke="black" d="M121.989,-71.6966C122.43,-63.9827 122.959,-54.7125 123.451,-46.1124"/>
<polygon fill="black" stroke="black" points="126.946,-46.2878 124.023,-36.1043 119.958,-45.8883 126.946,-46.2878"/>
</g>
</g>
</svg>

対応出力フォーマットは以下を見て下さい。

> [Output Formats | Graphviz - Graph Visualization Software](http://www.graphviz.org/content/output-formats 'Output Formats | Graphviz - Graph Visualization Software')

この頁のソースを見れば分かりますが、上のグラフはSVG(Scalable Vector Graphics)で出力したものを張り付けています{% fn_ref 2 %}。

## グラフ、ノード、エッジの属性変更
次に先のグラフに対して色などの属性を変更してみます。

{% highlight ruby %}
require "gviz"

gv = Gviz.new
gv.graph do
  route :main => [:init, :parse, :cleanup, :printf]
  route :init => :make, :parse => :execute
  route :execute => [:make, :compare, :printf]

  #        ---- 追加 ----
  nodes(colorscheme:'piyg8', style:'filled')
  nodeset.each.with_index(1) { |nd, i| node(nd.id, fillcolor:i) }
  edges(arrowhead:'onormal', style:'bold', color:'magenta4')
  edge(:main_printf, arrowtail:'diamond', dir:'both', color:'#3355FF')
  global(bgcolor:'powderblue')
end

gv.save(:sample2, :png)
{% endhighlight %}
`nodes`メソッドは全ノードに対する属性をセットします。ここでは`piyg8`というカラーセットを指定しています。`nodeset`は全ノードのオブジェクトを呼び出します。`node`メソッドは個別ノードの属性をセットします。ここでは`fillcolor`でpiyg8カラーセットの色番号1〜8を各ノードに順にセットしています。

`edges`メソッドは全エッジに対する属性をセットします。ここではarrowhead, style, colorの属性を変更しています。`edge`メソッドは個別エッジの属性をセットします。対象エッジの指定はその両端ノードのidを`_`で連結したもので行います。`global`はグラフ全体の属性をセットします。ここでは背景色を変えています。

出力は次のようになります。

![sample2 noshadow](http://github.com/melborne/Gviz/raw/master/examples/sample2.png)

色見本は以下にあります。

[Color Names | Graphviz - Graph Visualization Software](http://www.graphviz.org/content/color-names 'Color Names | Graphviz - Graph Visualization Software')

グラフ、ノードおよびエッジの変更可能な属性については、以下を見て下さい。

[attrs | Graphviz - Graph Visualization Software](http://www.graphviz.org/content/attrs 'attrs | Graphviz - Graph Visualization Software')

またエッジの矢印の種類については以下を。

[Arrow Shapes | Graphviz - Graph Visualization Software](http://www.graphviz.org/content/arrow-shapes 'Arrow Shapes | Graphviz - Graph Visualization Software')

## エッジポート、ノード配置、サブグラフ

更に次の変更を加えます。

> 1. ノードに対するエッジの接続先（ポート）を変更
> 2. ノードの配置を変更
> 3. 一部のノードをサブグラフ化

{% highlight ruby %}
require "gviz"

gv = Gviz.new
gv.graph do
  route :main => [:init, :parse, :cleanup, :printf]
  route :init => :make, :parse => :execute
  route :execute => [:make, :compare, :printf]

  nodes colorscheme:'piyg8', style:'filled'
  nodeset.each.with_index(1) { |nd, i| node nd.id, fillcolor:i }
  edges arrowhead:'onormal', style:'bold', color:'magenta4'
  edge :main_printf, arrowtail:'diamond', dir:'both', color:'#3355FF'
  global bgcolor:'powderblue'

  #        ---- 追加 ----
  node :execute, shape:'Mrecord', label:'{<x>execute | {a | b | c}}'
  node :printf, shape:'Mrecord', label:'{printf |<y> format}'
  edge 'execute:x_printf:y'
  rank :same, :cleanup, :execute
  subgraph do
    global label:'SUB'
    node :init
    node :make
  end
end

gv.save(:sample3, :png)
{% endhighlight %}
`node`メソッドで:executeと:printfのshapeを`Mrecord`にし、label属性をセットするときポート情報を埋め込みます(\<x\>, \<y\>)。`edge`メソッドでエッジのidを指定するとき文字列を使い、各ノードidの後ろに`:`を挟んでポートidを付けます。

`rank`メソッドではそのランクの種類（ここでは:same）を指定し、対象ノードをリストアップします。サブグラフを作るときは`subgraph`メソッドのブロック内で指定します。

出力は次のようになります。

![sample3 noshadow](http://github.com/melborne/Gviz/raw/master/examples/sample3.png)

ノードの形については次を参考にして下さい。

[Node Shapes | Graphviz - Graph Visualization Software](http://www.graphviz.org/content/node-shapes 'Node Shapes | Graphviz - Graph Visualization Software')

## 日本地図を書く
別の例をやってみます。Gvizで日本地図に挑戦してみます。まずは[都道府県 - Wikipedia](http://ja.wikipedia.org/wiki/%E9%83%BD%E9%81%93%E5%BA%9C%E7%9C%8C '都道府県 - Wikipedia')を参考に、次のようなCSVファイル（pref.csv）を用意します。データは都道府県コード、地方区分、名称、隣接県のコードの順に並んでいます。

<script src="https://gist.github.com/3780615.js?file=pref.csv"></script>

このファイルをRubyに読み込んでGvizで都道府県地図を作ります。まずはCSVを読み込んで処理しやすいように加工します。

{% highlight ruby %}
# encoding: UTF-8
require "gviz"
require "csv"

header, *data = CSV.read('pref.csv')
data = data.map { |id, region, name, *link| [id.intern, region.to_i, name, link.map(&:intern)] }

data # => [[:"01", 1, "北海道", [:"02"]], [:"02", 2, "青森県", [:"01", :"03", :"05"]], [:"03", 2, "岩手県", [:"02", :"05", :"04"]], [:"04", 2, "宮城県", [:"03", :"05", :"06", :"07"]], [:"05", 2, "秋田県", [:"02", :"03", :"04", :"06"]], [:"06", 2, "山形県", [:"05", :"04", :"07", :"15"]], [:"07", 2, "福島県", [:"04", :"06", :"15", :"10", :"09", :"08"]], [:"08", 3, "茨城県", [:"07", :"09", :"11", :"12"]], [:"09", 3, "栃木県", [:"07", :"10", :"08", :"11"]], [:"10", 3, "群馬県", [:"07", :"09", :"11", :"20", :"15"]], [:"11", 3, "埼玉県", [:"10", :"09", :"08", :"12", :"13", :"19", :"20"]], [:"12", 3, "千葉県", [:"13", :"11", :"08"]], [:"13", 3, "東京都", [:"11", :"12", :"14", :"19"]], [:"14", 3, "神奈川県", [:"13", :"22", :"19"]], [:"15", 4, "新潟県", [:"06", :"07", :"10", :"20", :"16"]], [:"16", 4, "富山県", [:"15", :"20", :"21", :"17"]], [:"17", 4, "石川県", [:"16", :"21", :"18"]], [:"18", 4, "福井県", [:"17", :"21", :"25", :"26"]], [:"19", 4, "山梨県", [:"20", :"11", :"13", :"14", :"22"]], [:"20", 4, "長野県", [:"15", :"10", :"11", :"19", :"22", :"23", :"21", :"16"]], [:"21", 4, "岐阜県", [:"16", :"20", :"23", :"24", :"25", :"18", :"17"]], [:"22", 4, "静岡県", [:"23", :"20", :"19", :"14"]], [:"23", 4, "愛知県", [:"24", :"21", :"20", :"22"]], [:"24", 5, "三重県", [:"23", :"21", :"25", :"26", :"29", :"30"]], [:"25", 5, "滋賀県", [:"18", :"21", :"24", :"26"]], [:"26", 5, "京都府", [:"18", :"25", :"24", :"29", :"27", :"28"]], [:"27", 5, "大阪府", [:"26", :"29", :"30", :"28"]], [:"28", 5, "兵庫県", [:"26", :"27", :"33", :"31"]], [:"29", 5, "奈良県", [:"26", :"24", :"30", :"27"]], [:"30", 5, "和歌山県", [:"27", :"29", :"24"]], [:"31", 6, "鳥取県", [:"28", :"33", :"34", :"32"]], [:"32", 6, "島根県", [:"31", :"33", :"34", :"35"]], [:"33", 6, "岡山県", [:"28", :"31", :"32", :"34", :"37"]], [:"34", 6, "広島県", [:"33", :"31", :"32", :"35"]], [:"35", 6, "山口県", [:"32", :"34", :"40"]], [:"36", 7, "徳島県", [:"37", :"38", :"39"]], [:"37", 7, "香川県", [:"36", :"38", :"33"]], [:"38", 7, "愛媛県", [:"37", :"36", :"39"]], [:"39", 7, "高知県", [:"38", :"36"]], [:"40", 8, "福岡県", [:"35", :"44", :"43", :"41"]], [:"41", 8, "佐賀県", [:"40", :"42"]], [:"42", 8, "長崎県", [:"41"]], [:"43", 8, "熊本県", [:"40", :"44", :"45", :"46"]], [:"44", 8, "大分県", [:"40", :"43", :"45"]], [:"45", 8, "宮崎県", [:"44", :"43", :"46"]], [:"46", 8, "鹿児島県", [:"43", :"45", :"47"]], [:"47", 9, "沖縄県", [:"46"]]]
{% endhighlight %}

次にGVizでこれらを処理します。各都道府県をノードとし隣接県情報を使ってノードをつなぎます。
{% highlight ruby %}
# encoding: UTF-8
require "gviz"
require "csv"

header, *data = CSV.read('pref.csv')
data = data.map { |id, region, name, *link| [id.intern, region.to_i, name, link.map(&:intern)] }

gv = Gviz.new(:Pref)

gv.graph do
  data.each do |id, reg, name, link|
    route id => link
    node id, label: name
  end
end

gv.save(:pref, :png)
{% endhighlight %}

結果を見てみましょう。

![pref1 noshadow]({{ site.url }}/assets/images/pref1.png)

ややっ、これはヒドイ。

graphのレイアウトを`neato`に変えてみます。
{% highlight ruby %}
gv = Gviz.new(:Pref)
gv.graph do
  global layout:'neato'
  data.each do |id, reg, name, link|
    route id => link
    node id, label: name
  end
end

gv.save(:pref, :png)
{% endhighlight %}

さあどうでしょうか。

![pref2 noshadow]({{ site.url }}/assets/images/pref2.png)

南北が逆で見慣れないですが大分良くなりました。

ノードの重なりが気になるので重なり(overlap)を無くします。

{% highlight ruby %}
gv = Gviz.new(:Pref)
gv.graph do
  global layout:'neato', overlap:false
  data.each do |id, reg, name, link|
    route id => link
    node id, label: name
  end
end

gv.save(:pref, :png)
{% endhighlight %}

![pref3 noshadow]({{ site.url }}/assets/images/pref3.png)

何となく日本地図に見えてきましたか？

形はこれで良しとして（マジか）、色を付けて仕上げます:)

{% highlight ruby %}
gv = Gviz.new(:Pref)
gv.graph do
  global layout:'neato', overlap:false, label:'日本地図'
  nodes colorscheme:'set310'
  edges arrowhead:'none'
  data.each do |id, reg, name, link|
    route id => link
    node id, label: name, style:'filled', fillcolor:reg
  end
end

gv.save(:pref, :png)
{% endhighlight %}

日本地図の完成です！

![pref4 noshadow]({{ site.url }}/assets/images/pref4.png)

いいですね！

というわけで...

あなたも`Gviz`で何かグラフを作ってみませんか？

----

Github Repo: [melborne/Gviz](https://github.com/melborne/Gviz 'melborne/Gviz')

<script src="https://gist.github.com/3780615.js?file=pref.rb"></script>

----

{{ 4764902966 | amazon_medium_image }}
{{ 4764902966 | amazon_link }} by {{ 4764902966 | amazon_authors }}

----

{% footnotes %}
{% fn コメント行があるとうまくいかなかったのでコメント行を削除しています。 %}
{% fn rubysapporo: Keynote Yukihiro "Matz" Matsumoto "One size does not fit all" http://www.ustream.tv/recorded/25417206 %}
{% endfootnotes %}
