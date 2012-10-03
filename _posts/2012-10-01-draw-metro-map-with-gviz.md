---
layout: post
title: "東京の地下鉄をGviz（Ruby Graphviz Wrapper）で描く"
description: ""
category: 
tags: [graphviz, gem]
date: 2012-10-02
published: true
---
{% include JB/setup %}

全国の駅情報を提供する[『駅データ．ｊｐ』](http://www.ekidata.jp/index.html '『駅データ．ｊｐ』')という素晴らしいサイトがあります。無料でダウンロードできるCSV形式の駅データには各駅の管理鉄道会社や路線の情報だけでなく、駅の経度・緯度情報までもが含まれています。マコトニスバラシイ。イママデシラナカッタノガハズカシイ。

そんなわけで...

今回は[Gviz](https://rubygems.org/gems/gviz 'gviz | RubyGems.org | your community gem host')を使って、東京の地下鉄、すなわち東京メトロ＋都営（東京都交通局）の路線図に挑戦してみます。


## 駅データの取得

まずは駅データを取得します。先のサイトのダウンロード頁からマスターデータ（m_station.csv）をDLします。サイトの仕様書頁にあるように、各駅情報は次の14フィールドで構成されています。

#### データ仕様

     1. 鉄道概要コード
     2. 路線コード
     3. 駅コード
     4. 路線並び順
     5. 駅並び順
     6. 駅グループコード
     7. 駅タイプ
     8. 鉄道概要名
     9. 路線名
    10. 駅名
    11. 都道府県コード
    12. 経度
    13. 緯度
    14. 表示フラグ


## 地下鉄データの抽出
次にこのデータをRubyで読み出して、東京の地下鉄の駅情報だけを抽出します。ファイル名は`metro.rb`とします。
#### \#metro.rb
{% highlight ruby %}
# encoding: UTF-8
require "csv"

header, *data = CSV.read('m_station.csv')

metrodata = data.select { |d| d[7].match(/東京メトロ|東京都交通局/) }
                .group_by { |d| d[8] }

metrodata # =>  {"東京メトロ銀座線"=>[["28", "28001", "2800101", "28001", "2800101", "2100201", "2", "東京メトロ", "東京メトロ銀座線", "浅草", "13", "139.797592", "35.710733", "1"], ["28", "28001", "2800102", "28001", "2800102", "2800102", "2", "東京メトロ", "東京メトロ銀座線", "田原町", "13", "139.790897", "35.709897", "1"], ... 中略 ... "日暮里・舎人ライナー"=>[["99", "99342", "9934201", "99305", "9934201", "1130218", "1", "東京都交通局", "日暮里・舎人ライナー", "日暮里", "13", "139.771287", "35.727908", "1"], ["99", "99342", "9934202", "99305", "9934202", "1130217", "1", "東京都交通局", "日暮里・舎人ライナー", "西日暮里", "13", "139.766857", "35.731954", "1"] ... ]}
{% endhighlight %}

## 地下鉄路線一覧
さて下準備が整ったので、Gvizで路線図を直ぐにでも描きたいところですが、感じをつかむためまずは路線一覧というのを作ってみます。

コードは以下のようになります。
{% highlight ruby %}
# encoding: UTF-8
require "gviz"

Graph(:Metro) do
  global label:'Metro of Tokyo', size:16
  metrodata.each do |line, stations|
    subgraph do
      global label:line
      stlength = stations.length
      stations.each.with_index(1) do |st, i|
        st_id, st_name, st_seq = st.values_at(2, 9, 4)
        st_id = st_id.intern
        next_id = "#{st_seq.to_i+1}".intern

        edge [st_id, next_id].join('_') if i < stlength
        node st_id, label:st_name
      end
    end
  end
  save(:metro, :png)
end
{% endhighlight %}

ここではグラフの生成に`Graph`メソッド（ver.0.0.4で導入）というショートカットを使っています。これは、`Gviz.new(:Metro).graph`と等価です。

Graphメソッドのブロックでは、`metrodata`から順次駅情報を読み出し、`edge`および`node`メソッドに必要な情報を渡してグラフ情報を生成しています。各路線毎の駅情報は`subgraph`の中で読み出します。

出力を見てみます。

<a href="{{ site.url }}/assets/images/2012/metro1.png" rel="lightbox" title="Metro List"><img src="{{ site.url }}/assets/images/2012/metro1.png" alt="metro noshadow" /></a>
（クリックで拡大します）

簡単なコードでなかなか綺麗な一覧ができました。

### 色を付ける
でもやっぱり地下鉄グラフに色がないのは悲しすぎます。地下鉄のシンボルカラーを次のサイトから取得して、色を付けます。

> [地下鉄のシンボルカラー メトロカラー - Metro Color](http://www.colordic.org/m/ '地下鉄のシンボルカラー メトロカラー - Metro Color')

足りないものは補って取得した色情報を配列で保持します。
{% highlight ruby %}
colors = [["銀座線", "#f39700"], ["丸ノ内線", "#e60012"], ["日比谷線", "#9caeb7"], ["東西線", "#00a7db"], ["千代田線", "#009944"], ["有楽町線", "#d7c447"], ["半蔵門線", "#9b7cb6"], ["南北線", "#00ada9"], ["副都心線", "#bb641d"], ["浅草線", "#e85298"], ["三田線", "#0079c2"], ["新宿線", "#6cbb5a"], ["大江戸線", "#b6007a"], ["荒川線", "#7aaa16"], ["舎人ライナー", "#999999"]]
{% endhighlight %}

そしてグラフをカラー化します。
{% highlight ruby %}
Graph(:Metro) do
  global label:'Metro of Tokyo', size:16
+ edges arrowhead:'none', penwidth:10
+ nodes style:'bold'
  metrodata.each do |line, stations|
    subgraph do
      global label:line
      stlength = stations.length
      stations.each.with_index(1) do |st, i|
        st_id, st_name, st_seq = st.values_at(2, 9, 4)
        st_id = st_id.intern
        next_id = "#{st_seq.to_i+1}".intern
+       color = (c = colors.detect { |ln, c| line.match /#{ln}/ }) ? c[1] : "#999999"

+       edge [st_id, next_id].join('_'), color:color if i < stlength
+       node st_id, label:st_name, color:color
      end
    end
  end
  save(:metro, :png)
end
{% endhighlight %}

結果を見てみます。

<a href="{{ site.url }}/assets/images/2012/metro2.png" rel="lightbox" title="Metro List"><img src="{{ site.url }}/assets/images/2012/metro2.png" alt="metro noshadow" /></a>

（クリックで拡大します）

キレイです。

さて、実はこの路線情報には一部間違いがあります。そう、丸ノ内線の「中野坂上」で路線は分岐しなければいけません。

これに対応したコードを入れて、地下鉄路線一覧の完成です。
{% highlight ruby %}
Graph(:Metro) do
  global label:'Metro of Tokyo', size:16
  edges arrowhead:'none', penwidth:10
  nodes style:'bold'
  metrodata.each do |line, stations|
    subgraph do
      global label:line
      stlength = stations.length
      stations.each.with_index(1) do |st, i|
        st_id, st_name, st_seq = st.values_at(2, 9, 4)
        st_id = st_id.intern
        next_id = "#{st_seq.to_i+1}".intern
        color = (c = colors.detect { |ln, c| line.match /#{ln}/ }) ? c[1] : "#999999"

        node st_id, label:st_name, color:color
+       case st_id
+       when :'2800220' # 中野坂上
+         edge [st_id, :'2800226'].join('_'), color:color # 中野坂上 => 中野新橋
+       when :'2800225' # 荻窪
+         next
+       end

        edge [st_id, next_id].join('_'), color:color if i < stlength
      end
    end
  end
  save(:metro, :png)
end
{% endhighlight %}

結果です。
<a href="{{ site.url }}/assets/images/2012/metro3.png" rel="lightbox" title="Metro List"><img src="{{ site.url }}/assets/images/2012/metro3.png" alt="metro noshadow" /></a>

（クリックで拡大します）

いいですね！

## 地下鉄路線図
さあここからが本番です。先のコードを生かしつつ、各駅の経度・緯度情報を使って地下鉄路線図を作ります。

Graphvizの各ノードは`pos`という属性を使ってその絶対座標を指定することができます。subgraphを外しlayoutを`neato`とし、最初はダメ元で各駅の経度・緯度情報をそのまま`pos`に渡してみます。最後の`!`を忘れずに。

{% highlight ruby %}
Graph(:Metro) do
+ global label:'Metro of Tokyo', size:16, layout:'neato'
  edges arrowhead:'none', penwidth:10
  nodes style:'bold'

  metrodata.each do |line, stations|
-   subgraph do
    stlength = stations.length
    stations.each.with_index(1) do |st, i|
      st_id, st_name, st_seq = st.values_at(2, 9, 4)
      st_id = st_id.intern
      next_id = "#{st_seq.to_i+1}".intern
      color = (c = colors.detect { |ln, c| line.match /#{ln}/ }) ? c[1] : "#999999"

+     pos_x = st[11]
+     pos_y = st[12]

+     node st_id, label:st_name, color:color, pos:"#{pos_x},#{pos_y}!"
      case st_id
      when :'2800220' # 中野坂上
        edge [st_id, :'2800226'].join('_'), color:color # 中野坂上 => 中野新橋
      when :'2800225' # 荻窪
        next
      end

      edge [st_id, next_id].join('_'), color:color if i < stlength
    end
-   end
  end
  save(:metro, :png)
end
{% endhighlight %}

結果は如何に！

<a href="{{ site.url }}/assets/images/2012/metro4.png" rel="lightbox" title="Metro List"><img src="{{ site.url }}/assets/images/2012/metro4.png" alt="metro noshadow" /></a>

Onz...

甘くはありませんでした...

### 座標の正規化
つまり駅座標情報を正規化して出力サイズに合わせて調整する必要があります。

Gviz ver0.0.4では正規化のために`Numeric#norm`というメソッドを用意しました。このメソッドは、任意の範囲内の特定の数値を0.0〜1.0の範囲の対応位置にマッピングします。第１引数にその任意の範囲をRangeオブジェクトで渡します。また、第２引数に所定のRangeオブジェクトを与えると、正規化する範囲を0.0〜1.0以外にすることができます。

早速metrodataから緯度経度の最大最小値を取得してRangeオブジェクトを生成し、試してみます。
{% highlight ruby %}

flatdata = metrodata.values.flatten(1)
lon_minmax = flatdata.map { |d| d[11].to_f }.minmax_by { |d| d.to_f }
lat_minmax = flatdata.map { |d| d[12].to_f }.minmax_by { |d| d.to_f }

lon_range = Range.new(*lon_minmax) # => 139.612434..139.958972
lat_range = Range.new(*lat_minmax) # => 35.586859..35.814544

139.812935.norm(lon_range) # => 0.5785830125412325
139.812935.norm(lon_range, 100..1000) # => 620.7247112871092
35.710702.norm(lat_range) # => 0.5439225245404847
35.710702.norm(lat_range, 100..1000) # => 589.5302720864363
{% endhighlight %}

さてこれを使って各駅の経度・緯度を正規化し、もう一度トライします。
{% highlight ruby %}
Graph(:Metro) do
  global label:'Metro of Tokyo', size:16, layout:'neato'
  edges arrowhead:'none', penwidth:10
  nodes style:'bold'

  metrodata.each do |line, stations|
    stlength = stations.length
    stations.each.with_index(1) do |st, i|
      st_id, st_name, st_seq = st.values_at(2, 9, 4)
      st_id = st_id.intern
      next_id = "#{st_seq.to_i+1}".intern
      color = (c = colors.detect { |ln, c| line.match /#{ln}/ }) ? c[1] : "#999999"

+     pos_x = st[11].to_f.norm(lon_range, 1000..5000).round # 10..60 for svg
+     pos_y = st[12].to_f.norm(lat_range, 1000..5000).round # 10..60 for svg

      node st_id, label:st_name, color:color, pos:"#{pos_x},#{pos_y}!"
      case st_id
      when :'2800220' # 中野坂上
        edge [st_id, :'2800226'].join('_'), color:color # 中野坂上 => 中野新橋
      when :'2800225' # 荻窪
        next
      end

      edge [st_id, next_id].join('_'), color:color if i < stlength
    end
  end
  save(:metro, :svg)
end
{% endhighlight %}

さあどうだ！

<a href="{{ site.url }}/assets/images/2012/metro_svg.html" title="Metro Map"><img src="{{ site.url }}/assets/images/2012/metro5.png" alt="metro noshadow" /></a>
（クリックでSVGによる路線図が開きます。手動で拡大してみて下さい）

スバラシイ！

なお上記正規化範囲はトライ＆エラーで獲得します。pngではうまく行かず、範囲を10..60としてSVGでの出力が成功しました。

ノードを透過カラーで表現した別バージョンも用意してみます。
{% highlight ruby %}
Graph(:Metro) do
  global label:'Metro of Tokyo', size:16, layout:'neato'
+ edges arrowhead:'none', penwidth:2
+ nodes style:'filled', fontcolor:'white'

  metrodata.each do |line, stations|
    stlength = stations.length
    stations.each.with_index(1) do |st, i|
      st_id, st_name, st_seq = st.values_at(2, 9, 4)
      st_id = st_id.intern
      next_id = "#{st_seq.to_i+1}".intern
      color = (c = colors.detect { |ln, c| line.match /#{ln}/ }) ? c[1] : "#999999"

      pos_x = st[11].to_f.norm(lon_range, 1000..5000).round # 10..60 for svg
      pos_y = st[12].to_f.norm(lat_range, 1000..5000).round # 10..60 for svg

+     node st_id, label:st_name, fillcolor:color+'aa', pos:"#{pos_x},#{pos_y}!"
      case st_id
      when :'2800220' # 中野坂上
        edge [st_id, :'2800226'].join('_'), color:color # 中野坂上 => 中野新橋
      when :'2800225' # 荻窪
        next
      end

      edge [st_id, next_id].join('_') if i < stlength
    end
  end
  save(:metro, :svg)
end
{% endhighlight %}

出力です。

<a href="{{ site.url }}/assets/images/2012/metro_svg2.html" title="Metro Map"><img src="{{ site.url }}/assets/images/2012/metro6.png" alt="metro noshadow" /></a>

（クリックでSVGによる路線図が開きます。手動で拡大してみて下さい）

拡大すると駅の重なりがわかると思います。

Enjoy Metro Map with Gviz!

[Gviz sample: Tokyo Metro with m_station data of 駅.jp — Gist](https://gist.github.com/3815566 'Gviz sample: Tokyo Metro with m_station data of 駅.jp — Gist')

----

関連記事：

[Yet Another Ruby Graphviz Interfaceを作ったからみんなで大量のグラフを作って遊ぼうよ！](http://melborne.github.com/2012/09/25/ruby-plus-graphviz-should-eql-gviz/ 'Yet Another Ruby Graphviz Interfaceを作ったからみんなで大量のグラフを作って遊ぼうよ！')

[Ruby Graphvizラッパー「Gviz」でアメリカ合衆国をデータビジュアライズしよう！](http://melborne.github.com/2012/09/27/usstates-map-data-vasualization-with-gviz/ 'Ruby Graphvizラッパー「Gviz」でアメリカ合衆国をデータビジュアライズしよう！')

[東京の地下鉄の路線サインをGviz（Ruby Graphviz Wrapper）で描く](http://melborne.github.com/2012/10/03/draw-metro-logos-with-gviz/ '東京の地下鉄の路線サインをGviz（Ruby Graphviz Wrapper）で描く')

----

{{ 'B007OVX460' | amazon_medium_image }}
{{ 'B007OVX460' | amazon_link }}


