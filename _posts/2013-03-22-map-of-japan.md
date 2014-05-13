---
layout: post
title: "Graphvizで作る、私たちの国「日本」の本当の姿かたち"
description: ""
category: 
tags: 
date: 2013-03-22
published: true
---
{% include JB/setup %}

(追記：2014-3-3) Gvizについてのまとめ頁を作りました。

> [Gvizの目次 - Rubyの世界からGraphvizの世界にこんにちは！]({{ BASE_PATH }}/2014/02/27/gviz-posts/ "Gvizの目次 - Rubyの世界からGraphvizの世界にこんにちは！")

---

antlaboさんがGraphvizを使って、北海道の市町村の隣接を可視化したものを公開されています。

> [Graphvizで北海道の市区町村の隣接を可視化してみました。 - 蟻の実験工房（別館ラボ）](http://d.hatena.ne.jp/antlabo/20130320/1363796474 "Graphvizで北海道の市区町村の隣接を可視化してみました。 - 蟻の実験工房（別館ラボ）")

この可視化の元データはwikipediaの情報を元にantlaboさんが作られたそうです。スバラシイ。

> [wikipediaの隣接市区町村の記載をデータベース化したものをcsvで公開 - 蟻の実験工房（別館ラボ）](http://d.hatena.ne.jp/antlabo/20121029/1351520444 "wikipediaの隣接市区町村の記載をデータベース化したものをcsvで公開 - 蟻の実験工房（別館ラボ）")

で、記事の中で全国可視化はデータ量が多くて上手くいかなかった旨が書かれていたので、自分も試してみたところ、無事出力できましたのでここに公開したいと思います。

##日本全国を可視化する
ここではGraphvizのRubyラッパーである拙作「[gviz](https://rubygems.org/gems/gviz "gviz \| RubyGems.org \| your community gem host")」を使います。

###隣接データの読み出し
まずは先のサイトから全国市町村隣接データ[city_rinsetsu_utf8.csv](http://spnene.antlabo.jp/data/city_rinsetsu_utf8.csv "")を取得します。このデータのフォーマットは以下のようになっています。

> ID(元),県名(元),市区町村名(元),ID(先),県名(先),市区町村名(先)

{% highlight text %}
673,三重県,いなべ市,626,岐阜県,大垣市
673,三重県,いなべ市,662,岐阜県,養老町
673,三重県,いなべ市,663,滋賀県,多賀町
673,三重県,いなべ市,721,三重県,東員町
673,三重県,いなべ市,722,三重県,桑名市
673,三重県,いなべ市,723,三重県,菰野町
673,三重県,いなべ市,712,滋賀県,東近江市
673,三重県,いなべ市,724,三重県,四日市市
673,三重県,いなべ市,675,岐阜県,海津市
796,三重県,亀山市,749,滋賀県,甲賀市
796,三重県,亀山市,773,三重県,鈴鹿市
  .
  .
  .
{% endhighlight %}

このデータをRubyで読み出して扱いやすいように前処理します。具体的には、最初にデータを各県ごとにグループ化し、それを市町村IDで更にグループ化します。
{% highlight ruby %}
# encoding: UTF-8
require "csv"

csv = CSV.read('city_rinsetsu_utf8.csv')

data = csv.group_by { |d| d[1] }.map { |k, v| [k, v.group_by(&:first)] }

# >> [["三重県", {"673"=>[["673", "三重県", "いなべ市", "626", "岐阜県", "大垣市"], ["673", "三重県", "いなべ市", "662", "岐阜県", "養老町"], ["673", "三重県", "いなべ市", "663", "滋賀県", "多賀町"], ["673", "三重県", "いなべ市", "721", "三重県", "東員町"], ["673", "三重県", "いなべ市", "722", "三重県", "桑名市"], ["673", "三重県", "いなべ市", "723", "三重県", "菰野町"], ["673", "三重県", "いなべ市", "712", "滋賀県", "東近江市"], ["673", "三重県", "いなべ市", "724", "三重県", "四日市市"], ["673", "三重県", "いなべ市", "675", "岐阜県", "海津市"]], "796"=>[["796", "三重県", "亀山市", "749", "滋賀県", "甲賀市"], ["796", "三重県", "亀山市", "773", "三重県", "鈴鹿市"], ["796", "三重県", "亀山市", "793", "三重県", "伊賀市"], ["796", "三重県", "亀山市", "816", "三重県", "津市"]], "977"=>[["977", "三重県", "伊勢市", "915", "三重県", "明和町_(三重県)"], ["977", "三重県", "伊勢市", "979", "三重県", "度会町"], ["977", "三重県", "伊勢市", "1039", "三重県", "鳥羽市"], ["977", "三重県", "伊勢市", "978", "三重県", "玉城町"], ["977", "三重県", "伊勢市", "1040", "三重県", "南伊勢町"], ["977", "三重県", "伊勢市", "1041", "三重県", "志摩市"]], "793"=>[["793", "三重県", "伊賀市", "749", "滋賀県", "甲賀市"], ["793", "三重県", "伊賀市", "816", "三重県", "津市"], ["793", "三重県", "伊賀市", "837", "奈良県", "山添村"], ["793", "三重県", "伊賀市", "795", "京都府", "南山城村"], ["793", "三重県", "伊賀市", "796", "三重県", "亀山市"], ["793", "三重県", "伊賀市", "835", "三重県", "名張市"], ["793", "三重県", "伊賀市", "836", "奈良県", "奈良市"]], "1040"=>[["1040", "三重県", "南伊勢町", "977", "三重県", "伊勢市"], ["1040", "三重県", "南伊勢町", "979", "三重県", "度会町"], ["1040", "三重県", "南伊勢町", "981", "三重県", "大紀町"], ["1040", "三重県", "南伊勢町", "1041", "三重県", "志摩市"]], "835"=>[["835", "三重県", "名張市", "793", "三重県", "伊賀市"], ... ]]}]]
{% endhighlight %}

### Graphvizで描画
下準備ができたので、Gvizを使ってGraphvizのDOTデータを生成します。各市町村をノードとし、隣接データに基いてノード同士を接続します。コードは次のようになります。

####map_japan.rb
{% highlight ruby %}
# encoding: UTF-8
require "csv"
require "gviz"

csv = CSV.read('city_rinsetsu_utf8.csv')

data = csv.group_by { |d| d[1] }.map { |k, v| [k, v.group_by(&:first)] }

Graph do
  global layout:'neato', overlap:false, label:'Map of Japan', fontsize:100
  nodes shape:'circle', width:1.6, style:'filled'
  edges arrowhead:'none', color:'gray'

  data.each do |pref, values|
    values.each do |city_id, neighbors|
      route city_id.intern => neighbors.map { |e| e[3].intern }
      city_label = neighbors.first[1, 2].join("\n").sub(/_\(.*?\)$/, '')
      node city_id.intern, label:city_label
    end
  end

  save :japan
end
{% endhighlight %}

Graphのブロックの中で、グラフを生成します。globalでグラフ全体、nodesでノードの属性、edgesでエッジの属性をそれぞれ設定します。eachでdataの中の情報にアクセスして、その情報に基づきrouteでノードの繋がりを作り、nodeで各ノードの属性をセットします。

コードを実行します。
{% highlight bash %}
%ruby map_japan.rb
{% endhighlight %}
これで、同ディレクトリに`japan.dot`ファイルが生成されます。自分の環境でDOT生成には1分20秒くらい掛かりました。

出力です。

![jpmap noshadow]({{ site.url }}/assets/images/2013/03/jpmap_mono.png)

ややっ。

何が何だかわからないでしょうが、拡大すると隣接市町村がエッジで繋がれているのがわかると思います。

![jpmap noshadow]({{ site.url }}/assets/images/2013/03/jpmap_mono_expand.png)

ちなみに、ノードの`shape:'circle'`を指定しないでDOTを生成したときファイルを開けなかったので、antlaboさんの環境でうまくいかなかったのはこれが原因かもしれません（circle指定でgraphviz側の配置演算が簡単になるから？）。

###カラー化

さて、やっぱりモノクログラフは寂しいので、県ごとに色付けしてみます。ここではカラー化に拙作「[colorable](https://rubygems.org/gems/colorable "colorable \| RubyGems.org \| your community gem host")」を使います。colorableでは`Color.new`で色を生成して、`Color#next`で順次次の色を出力できるのでこれを使って、県ごとにノードの色を作ります。出力フォーマットとしてSVGも指定しましょう。

{% highlight ruby %}
# encoding: UTF-8
require "csv"
require "gviz"
+require "colorable"

csv = CSV.read('city_rinsetsu_utf8.csv')

data = csv.group_by { |d| d[1] }.map { |k, v| [k, v.group_by(&:first)] }

+c = Colorable::Color.new(:alice_blue)

Graph do
+ global layout:'neato', overlap:false, label:'Map of Japan', fontsize:100, size:16
  nodes shape:'circle', width:1.6, style:'filled'
  edges arrowhead:'none', color:'gray'

  data.each do |pref, values|
    values.each do |city_id, neighbors|
      route city_id.intern => neighbors.map { |e| e[3].intern }
      city_label = neighbors.first[1, 2].join("\n").sub(/_\(.*?\)$/, '')
+     fcolor = c.dark? ? 'white' : 'black'
+     node city_id.intern, label:city_label, fillcolor:c.hex, fontcolor:fcolor
    end
+   c = c.next
  end

+  save :japan, :svg
end
{% endhighlight %}

出力です。



<a href="{{ site.url }}/assets/images/2013/03/jpmap_svg.html" title="Metro Map"><img src="{{ site.url }}/assets/images/2013/03/jpmap_color.png" alt="metro noshadow" /></a>

都道府県が色分けされました。ちなみに、一番下の水色エリアが「北海道」、中央左寄り黒が「埼玉」、その左上うぐいす色が「東京」、中央右寄り青色が「大阪」、上部紫色が「熊本」になります。それから、「沖縄」は右下深緑のエリアになります。やあ、北海道と沖縄って、こんなに近かったんですね！

図をクリックするとSVGの頁が開きますので、手動で拡大してお住まいの都市を見つけて下さい。一部を拡大図したものが下の図になります（自分の環境mac lionではfirefoxで拡大縮小が効きませんでした）。

enjoy!


![jpmap noshadow]({{ site.url }}/assets/images/2013/03/jpmap_color_expand.png)



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
  <img src="/assets/images/2013/03/ruby_trivia_cover.png" alt="trivia" style="width:200px" />
</a>

