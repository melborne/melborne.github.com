---
layout: post
title: "Graphvizで作る、私たちの国「日本」の今度こそ本当の姿かたち"
description: ""
category: 
tags: 
date: 2013-03-25
published: true
---
{% include JB/setup %}

(追記：2014-3-3) Gvizについてのまとめ頁を作りました。

> [Gvizの目次 - Rubyの世界からGraphvizの世界にこんにちは！]({{ BASE_PATH }}/2014/02/27/gviz-posts/ "Gvizの目次 - Rubyの世界からGraphvizの世界にこんにちは！")

---

僕は前回、[antlabo](http://d.hatena.ne.jp/antlabo/)さんが公開されている[全国市区町村の隣接データ](http://d.hatena.ne.jp/antlabo/20121029/1351520444)に基いて、Graphvizで次のような日本を作りました。

<a href="{{ site.url }}/assets/images/2013/03/jpmap_svg.html" title="Metro Map"><img src="{{ site.url }}/assets/images/2013/03/jpmap_color.png" alt="japan noshadow" /></a>

> {% hatebu http://melborne.github.com/2013/03/22/map-of-japan/ "Graphvizで作る、私たちの国「日本」の本当の姿かたち" %}

ええ、これが「日本」です。

まあ、これはこれで面白かったのですが、全体的形状としては現実の日本国土とは程遠いものとなりました。都道府県の隣接情報に基いて日本を書いたときや、州の隣接情報に基いて米国を書いたときには、それなりに上手くいっていたのですが、今回のようにノード数が異常に多いとGraphvizにおける配置演算が難しくなって、隣接ノード間の距離がまちまちになってしまうのです。

それで、各市町村の位置情報があればうまくいくはずということで、どこかにそのようなデータがないか探してみたところ、[位置参照情報ダウンロードサービス](http://nlftp.mlit.go.jp/isj/ "位置参照情報ダウンロードサービス")という国土交通省のサイトを見つけ、早々ダウンロードして使ってみました。しかし、位置情報が街区単位（何丁目何番地）と細かく、データの前処理が面倒だなーと思っていたのでした。

そんな折、先のantlaboさんが僕とのツイッターでのやり取りをきっかけに、なんと、全国市町村の役所の位置情報データを公開してくれることになったのです。

> [都道府県市区町村データ公開その3 - 蟻の実験工房（別館ラボ）](http://d.hatena.ne.jp/antlabo/20130324/1364107139 "都道府県市区町村データ公開その3 - 蟻の実験工房（別館ラボ）")

スバラシイ！

そんなわけで...

今回は、この都道府県市区町村の位置情報に基いて日本地図を描いてみようと思います。ツールはいつものように[gviz](https://rubygems.org/gems/gviz "gviz | RubyGems.org | your community gem host")を使います。

ノードの位置情報を使ってGraphvizを描くことは既に、「[東京の地下鉄をGviz（Ruby Graphviz Wrapper）で描く](http://melborne.github.com/2012/10/02/draw-metro-map-with-gviz/ "東京の地下鉄をGviz（Ruby Graphviz Wrapper）で描く")」で経験しているので、今回はスムーズにいくと思います。では、ステップ・バイ・ステップで。

## インストール
Graphvizが必要です。自分のプラットフォームに合ったものを以下から入手して下さい。

> [Download. | Graphviz - Graph Visualization Software](http://www.graphviz.org/Download..php 'Download. | Graphviz - Graph Visualization Software')

Gvizのインストールは`gem install gviz`でＯＫです。Rubyは1.9.3以降が必要となります。

## データの前処理
まずは、先のantlaboさんのサイトから`city_location_utf8.csv`を取得します。このデータは以下のようなtab separated valueになってます{% fn_ref 1 %}。

{% highlight text %}
id	pref	name	lat	lon
673	三重県	いなべ市	35.16079322	136.5017665
796	三重県	亀山市	34.87762199	136.38172496
977	三重県	伊勢市	34.47547466	136.72519867
793	三重県	伊賀市	34.72972645	136.18121136
1040	三重県	南伊勢町	34.30874507	136.58644797
835	三重県	名張市	34.61712737	136.11750322
  ・
  ・
  ・
{% endhighlight %}

いつものようにこのデータを直接Gvizに渡してもいいんですが、今回は一手間掛けてCityオブジェクトを作りそれを渡すようにしてみます。`city.rb`というファイルを作ってCityクラスを作り、このデータに基いてCityオブジェクトを生成します。こんな感じです。

{% highlight ruby %}
# encoding: UTF-8
class City < Struct.new(:id, :pref, :name, :lat, :lon)
  @@cities = []
  class << self
    def cities
      @@cities
    end
  end

  def initialize(*args)
    @@cities << self
    super
  end
end
{% endhighlight %}
@@citiesに生成した全Cityオブジェクトを保持し、City.citiesでアクセスできるようにします。

では、CSVライブラリを使ってデータを読み出し、Cityオブジェクトを生成しましょう。

{% highlight ruby %}
require "csv"

tsv = CSV.table('city_location_utf8.csv', col_sep:"\t")

tsv.first # => #<CSV::Row id:673 pref:"三重県" name:"いなべ市" lat:35.16079322 lon:136.5017665>

tsv.each { |row| City.new(*row.fields) }

City.cities.size # => 1747
City.cities.first # => #<struct City id=673, pref="三重県", name="いなべ市", lat=35.16079322, lon=136.5017665>
{% endhighlight %}
こういうときは、`CSV.table`が便利です。詳しくは[こちら](http://melborne.github.com/2013/01/24/csv-table-method-is-awesome/ "Ruby標準添付ライブラリcsvのCSV.tableメソッドが最強な件について")を。

Graphvizで絶対位置を指定するときは値を正規化する必要があり、そのために緯度経度のレンジ（最小値-最大値）を使いますので、Cityクラスにこれらの値を保持させましょう。`City.lat_range`, `City.lon_range`を定義します。

{% highlight ruby %}
class City < Struct.new(:id, :pref, :name, :lat, :lon)
  @@lat_range = @@lon_range = nil
  class << self
    def lat_range
      @@lat_range ||= Range.new(*@@cities.map(&:lat).minmax)
    end

    def lon_range
      @@lon_range ||= Range.new(*@@cities.map(&:lon).minmax)
    end
  end
end

tsv = CSV.table('city_location_utf8.csv', col_sep:"\t")
tsv.each { |row| City.new(*row.fields) }

City.lat_range # => 24.34639481..45.36876935
City.lon_range # => 122.98877472..145.50658293
{% endhighlight %}

更に、都道府県別に色を付けたいので、都道府県の色情報をCityクラスに持たせます。色付けには前回同様`Colorable` gemを使います。

{% highlight ruby %}
require "colorable"

class City < Struct.new(:id, :pref, :name, :lat, :lon)
  @@pref_colors = nil
  class << self
    def pref_colors
      @@pref_colors ||= begin
        c = Colorable::Color.new(:alice_blue)
        prefs = @@cities.uniq { |city| city.pref }.map(&:pref)
        Hash[ prefs.map { |pr| [pr, c=c.next] } ]
      end
    end
  end
end

City.pref_colors # => {"三重県"=>#<Colorable::Color:0x007fbebb1db038 @name="Antique White", @rgb=[250, 235, 215], @hex=nil, @hsb=nil, @esc=nil>, "京都府"=>#<Colorable::Color:0x007fbebb1da458 @name="Aqua", @rgb=[0, 255, 255], @hex=nil, @hsb=nil, @esc=nil>, "佐賀県"=>#<Colorable::Color:0x007fbebb1d9440 @name="Aquamarine", @rgb=[127, 255, 212], @hex=nil, @hsb=nil, @esc=nil>, "兵庫県"=>#<Colorable::Color:0x007fbebb1d8158 @name="Azure", @rgb=[240, 255, 255], @hex=nil, @hsb=nil, @esc=nil>, "北海道"=>#<Colorable::Color:0x007fbebb1e3170 @name="Beige", @rgb=[245, 245, 220], @hex=nil, @hsb=nil, @esc=nil>, "千葉県"=>#<Colorable::Color:0x007fbebb1e1708 @name="Bisque", @rgb=[255, 228, 196], @hex=nil, @hsb=nil, @esc=nil>, ... , "鹿児島県"=>#<Colorable::Color:0x007fbebb1f3930 @name="Ghost White", @rgb=[248, 248, 255], @hex=nil, @hsb=nil, @esc=nil>}
{% endhighlight %}

## 日本地図の描画
さて、下準備ができました。gvizを使って日本地図を描画します。`graph.ru`ファイルを作って次のようなコードを書きます。

{% highlight ruby %}
# encoding: UTF-8
require "./city"

global layout:'neato', label:'Map of Japan', fontsize:200, size:16
nodes shape:'circle', width:1.4, style:'filled'
City.cities.each do |c|
  name = [c.pref, c.name].join("\n")
  lat, lon = [c.lat, c.lon].zip([City.lat_range, City.lon_range])
                           .map { |val, range| val.norm(range, 100..10000) }
  node c.id.to_id, label:name, pos:"#{lon},#{lat}!"
end

save :japan
{% endhighlight %}

gvizで定義された`Numeric#norm`を使ってCityオブジェクトが持っている緯度・経度情報を、生成されるグラフサイズに合わせて正規化します。これは、normの第２引数を試行錯誤して最適値を見つけます。Graphvizにおけるノードの絶対位置指定にはpos属性を使います。


ターミナルでgvizコマンドを実行し、graphvizで生成された画像を開きます。
{% highlight bash %}
% gviz
% open japan.dot
{% endhighlight %}

さあ、出力です。

![japan noshadow]({{ site.url }}/assets/images/2013/03/japanmap_mono.png)

おみごと！自画自賛！antlaboさんありがとう！

市町村役場の位置情報に基いて、私たちの国「日本」の姿かたちが描かれました。

## 日本地図のカラー化

前回同様、仕上げに色を付けます。

{% highlight ruby %}
# encoding: UTF-8
require "./city"

global layout:'neato', label:'Map of Japan', fontsize:200, size:16
nodes shape:'circle', width:1.4, style:'filled'
City.cities.each do |c|
  name = [c.pref, c.name].join("\n")
  lat, lon = [c.lat, c.lon].zip([City.lat_range, City.lon_range])
                           .map { |val, range| val.norm(range, 100..10000) }
+  color = City.pref_colors[c.pref]
+  fcolor = color.dark? ? 'white' : 'black'
+  node c.id.to_id, label:name, pos:"#{lon},#{lat}!", fillcolor:"#{color.hex}aa", fontcolor:fcolor
end

save :japan
{% endhighlight %}

出力はこちら。

<a href="{{ site.url }}/assets/images/2013/03/jpmap_svg2.html" title="Metro Map"><img src="{{ site.url }}/assets/images/2013/03/japanmap_color.png" alt="japan noshadow" /></a>

図をクリックするとSVGの頁が開きますので、手動で拡大できます（FirefoxはSVGのZoomに対応していないようです）。

以下は、一部地域の拡大図です。

近畿地方。

![japan noshadow]({{ site.url }}/assets/images/2013/03/japanmap_color_big1.png)

関東地方。

![japan noshadow]({{ site.url }}/assets/images/2013/03/japanmap_color_big2.png)

九州地方。

![japan noshadow]({{ site.url }}/assets/images/2013/03/japanmap_color_big3.png)


Numeric#normの第２引数を調整することで、ノードの密度を調整出来ます。ちなみに、SVG出力は、`10..100`で生成しました。

今回は以上です。

enjoy!

{% gist 5235218 %}

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

---

{% footnotes %}
{% fn ヘッダーの名前を一部編集しました %}
{% endfootnotes %}
