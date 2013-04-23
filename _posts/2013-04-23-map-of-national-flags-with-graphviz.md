---
layout: post
title: "Graphvizで作る国旗の類似度世界地図"
description: ""
category: 
tags: 
date: 2013-04-23
published: true
---
{% include JB/setup %}

antlaboさんが世界の国旗の類似度を可視化した作品を公開しています。

> [国旗の類似度を可視化](http://infanimation.antlabo.jp/kokki/index.html "国旗の類似度を可視化")
>
> [世界の国旗の類似度を可視化＆似ている国旗TOP30 （今回はデータ付き ） - 蟻の実験工房（別館ラボ）](http://d.hatena.ne.jp/antlabo/20130421/1366526239 "世界の国旗の類似度を可視化＆似ている国旗TOP30 （今回はデータ付き ） - 蟻の実験工房（別館ラボ）")

これは[LIRE（Lucene Image Retrieval）](http://www.lire-project.net/ "LIRE – Lucene Image Retrieval | The Java visual information retrieval library")というJAVAの画像類似検索向けライブラリを使って、204の国旗の類似度を計算したデータに基いて作られているそうです。国旗画像下の緑の十字をクリックするとその国旗を中心にした類似国旗が順に辿れるようになっています。やあ、スバラシイ。

ちなみに画像自体の特徴量（色、形状、テクスチャなど）をベースに類似検索をする方式をCBIR（Content-Based Image Retrieval）というそうですが、LIREはその方式で画像を比較します。

加えて、antlaboさんはこの国旗の類似度データも公開してくれています。当然、Graphviz-er（Graphviz-ist?）としてはこれを見過ごすことはできません:-)

そんなわけで...

ここでは、[Gviz（RubyによるGraphvizのインタフェースライブラリ）](https://rubygems.org/gems/gviz "gviz | RubyGems.org | your community gem host")を使った簡単な国旗の類似度可視化をやってみたいと思います。意味ある出力が得られればいいんですが...


## CSVデータの読み込み
提供されているデータは次のフォーマットを持ったCSVデータです（ヘッダー名は加工しています）。
{% highlight text %}
id,sim,name1,path1,name2,path2
10736941,99.3,Indonesia,images/Indonesia.jpg,Monaco,images/Monaco.jpg
10736713,89.0,Honduras,images/Honduras.jpg,Nicaragua,images/Nicaragua.jpg
10719944,87.1,El_Salvador,images/El_Salvador.jpg,Nicaragua,images/Nicaragua.jpg
...
{% endhighlight %}
id, 類似度（sim）に続き、対比する国の国名と画像パスが並びます。

データを展開したフォルダにおいて`graph.ru`のファイル名でデータを読み出します。
####graph.ru
{% highlight ruby %}
require "csv"

data = CSV.table('kokkidata.csv')

data.headers # => [:id, :sim, :name1, :path1, :name2, :path2]
d = data.first
d # => #<CSV::Row id:10736941 sim:99.3 name1:"Indonesia" path1:"images/Indonesia.jpg" name2:"Monaco" path2:"images/Monaco.jpg">
d[:sim] # => 99.3
d[:name1] # => "Indonesia"
d[:name2] # => "Monaco"
{% endhighlight %}

## グラフの描画
では、graphviz上に画像を読み込んで表示してみましょう。

データにおける国旗の類似度は10.0〜99.3まで幅がありますが、まずは何も考えずにすべての対比される国旗をエッジで結んだグラフを書いてみます。グラフのレイアウトには**fdp**を使ってみます。
####graph.ru
{% highlight ruby %}
require "csv"

data = CSV.table('kokkidata.csv')

global layout:'fdp', bgcolor:'whitesmoke', label:'Map of National Flags', fontsize:36
nodes shape:'none', fontcolor:'#444444'
edges arrowhead:'none', color:'#AAAAAA'

data.each do |r|
  id1, id2 = r[:name1].to_id, r[:name2].to_id
  node id1, image:r[:path1], label:r[:name1], labelloc:'b'
  node id2, image:r[:path2], label:r[:name2], labelloc:'b'
  route id1 => id2
end

save :flag, :png
{% endhighlight %}
Graphvizではimage属性を使うことでノードに画像を貼ることができます。

そして`gviz`コマンドを実行し、生成された`flag.png`を開きます。
{% highlight bash %}
% gviz
% open flag.png
{% endhighlight %}

{% lightbox  2013/04/flag1.png, title, alt noshadow %}
（クリックで拡大します）

ややっ。

国旗の画像は貼られましたが、なんか意味不明です。当然といえば当然の結果ですが。

## グラフの描画２

こんどは、エッジで結ぶ国旗を限定してみます。類似度が40.0より高い国旗だけをリンクするようにします。

{% highlight ruby %}
require "csv"

data = CSV.table('kokkidata.csv')

global layout:'fdp', bgcolor:'whitesmoke', label:'Map of National Flags', fontsize:36
nodes shape:'none', fontcolor:'#444444'
edges arrowhead:'none', color:'#AAAAAA'

data.each do |r|
  id1, id2 = r[:name1].to_id, r[:name2].to_id
  node id1, image:r[:path1], label:r[:name1], labelloc:'b'
  node id2, image:r[:path2], label:r[:name2], labelloc:'b'
+  route id1 => id2 if r[:sim] > 40.0
end

save :flag, :png
{% endhighlight %}

さあ、どうでしょう。

{% lightbox  2013/04/flag2.png, title, alt noshadow %}
（クリックで拡大します）

おっ。

なんとなく北米大陸にも似た形のマップが描画されました。日本のポジションがいいじゃないですか。

グラフをよく見ると、青系の国旗が左上に集合し、赤系は右上、黄色が入ったものがその下に、さらにその下に黒が入った国旗が集合しているのが分かります。類似度に応じたエッジの重み付け（エッジの長さを類似度に応じて調整するなど）をすることなく、単に類似度40.0以下のエッジを外しただけで、画像の集まりに傾向が見られるようになりました{% fn_ref 1 %}。

中央に円図形を持ったバングラデシュ（Bangladesh）やパラオ（Palau）と日本の国旗の類似度が低いことなどからみて、LIERでは色の特徴量に対する比重が大きい気がします。

それにしても、世界には同じような図柄の国旗が沢山あるんですねー。antlaboさんが言うようにその歴史と重ねあわせてみたら面白そうです。

以上、Graphvizを使った簡単な国旗の類似度におけるビジュアライゼーションでした。

---

参考記事： [類似画像検索システムを作ろう - 人工知能に関する断創録](http://aidiary.hatenablog.com/entry/20091003/1254574041 "類似画像検索システムを作ろう - 人工知能に関する断創録")


{% footnotes %}
{% fn エッジの長さや太さで類似度の重み付けをしてみましたが、面白い結果は得られませんでした。 %}
{% endfootnotes %}
