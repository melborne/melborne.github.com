---
layout: post
title: "GvizでAKB48をビジュアライズするよ！"
description: ""
category: 
tags: 
date: 2012-10-16
published: true
---
{% include JB/setup %}


(追記：2013-08-09) Gvizバージョンアップによりgvizコマンドの仕様が変更になりました（version0.2.0）。詳細は以下の記事を参照してください。

> [ピクミンがGraphvizにやって来た！]({{ site.url }}/2013/08/09/now-pikmin-come-to-graphviz/ "ピクミンがGraphvizにやって来た！")


---

RubyによるGraphvizラッパー`Gviz`のversion0.0.7を公開しました。

> [gviz | RubyGems.org | your community gem host](https://rubygems.org/gems/gviz 'gviz | RubyGems.org | your community gem host')

`Gviz`を使えば簡単に[有向グラフ]({{ site.url }}/2012/09/25/ruby-plus-graphviz-should-eql-gviz/)や[米国統計地図]({{ site.url }}/2012/09/27/usstates-map-data-vasualization-with-gviz/)や[地下鉄路線図]({{ site.url }}/2012/10/02/draw-metro-map-with-gviz/)が書けます。

## インストール
Graphvizが必要です。自分のプラットフォームに合ったものを以下から入手して下さい。

> [Download. | Graphviz - Graph Visualization Software](http://www.graphviz.org/Download..php 'Download. | Graphviz - Graph Visualization Software')

Gvizのインストールは`gem install gviz`でＯＫです。Rubyはたぶん1.9.3が必要となります。

## 追加機能
ver0.0.7で以下の機能が追加されました。

    1. gvizコマンド
    2. multiple edge指定
    3. Object#to_id

### gvizコマンド
`gviz`コマンドで一層簡単にグラフを作成できるようになりました。

適当なディレクトリに`graph.ru`ファイルを用意して、そこに次のようなグラフコードを書きます。

{% highlight ruby %}
#graph.ru
nodes style:'filled', colorscheme:'set39'
route :Lisp => [:Ruby, :Python, :Ocaml, :Perl]
route :Ruby => [:Mantra, :Groovy], :Python => [:Ruby, :JavaScript]
route :JavaScript => [:ActionScript, :ObjectiveJ]
rank :same, :Ruby, :Python, :Ocaml, :Perl
nodeset.each { |n| node n.id, color:[*1..9].sample }

save(:sample, :png)
{% endhighlight %}

`gviz`コマンドを実行します。
{% highlight bash %}
gviz
{% endhighlight %}

これにより次のような`sample.dot`および`sample.png`が生成されます。

![Alt title noshadow]({{ site.url }}/assets/images/2012/dot_sample.png)

つまり`gviz`コマンドは、`Gviz#graph`のブロックで上記コードを書いたときと同じものを出力します。

graph.ru以外のファイル名を使いたいときはコマンドに渡して下さい。

### multiple edge指定
Gviz#edgeに渡すidが`*`(アスタリスク)を含むとき、複数のエッジを更新します。

{% highlight ruby %}
add(:a => [:b, :c])
edge('a_*', color:'red')
{% endhighlight %}
上記により:a_b, :a_cの２つのエッジの色をまとめて赤に変更できます。つまりこれは以下と等価です。

{% highlight ruby %}
edge(:a_b, color:'red')
edge(:a_c, color:'red')
{% endhighlight %}

### Object#to_id
ノードやエッジのidを簡単に生成するための補助メソッドです。`Object#to_id`はそのオブジェクト固有のidを生成しシンボルで返します。次のように使います。
{% highlight ruby %}
name = "秋元康"
id = name.to_id # => :"2572637362590069661" 
node name.to_id, label:name
{% endhighlight %}

以上です。

`Gviz`のソースはギットハブにあります。

> [melborne/Gviz](https://github.com/melborne/Gviz 'melborne/Gviz')

## AKB48をビジュアライズする
やっぱり新機能の紹介だけではつまらないので、少し凝ったサンプルを示します。

今時AKBのメンバー名と所属チームくらいは知っておきたいものです。関係グラフを作って覚えましょう。

### データの取得
次のような汎用スクレイパーをでっち上げて、AKB48公式サイトからメンバーのデータをぶっこ抜きます。

<script src="https://gist.github.com/3898896.js?file=scraper.rb"></script>

これで以下のような出力が得られます。

{% highlight ruby %}
{"チームA"=>[["iwasa_misaki", "岩佐 美咲"], ["ohta_aika", "多田 愛佳"], ["ooya_shizuka", "大家 志津香"], ["katayama_haruka", "片山 陽加"], ["kuramochi_asuka", "倉持 明日香"], ["kojima_haruna", "小嶋 陽菜"], ["shinoda_mariko", "篠田 麻里子"], ["takajo_aki", "高城 亜樹"], ["takahashi_minami", "高橋 みなみ"], ... 中略 ... "研究生"=>[["omori_miyuu", "大森 美優"], ["sasaki_yukari", "佐々木 優佳里"], ["hirata_rina", "平田 梨奈"], ["eguchi_aimi", "江口 愛実"], ["Aigasa_Moe", "相笠 萌"], ["Iwatate_Saho", "岩立 沙穂"], ["Umeta_Ayano", "梅田 綾乃"], ["Okada_Ayaka", "岡田 彩花"], ["Kitazawa_Saki", "北澤 早紀"], ["Shinozaki_Ayana", "篠崎 彩奈"], ["Takashima_Yurina", "髙島 祐利奈"], ["Murayama_Yuiri", "村山 彩希"], ["Mogi_Shinobu", "茂木 忍"], ["Uchiyama_Natsuki", "内山 奈月"], ["Okada_Nana", "岡田 奈々"], ["Kojima_Mako", "小嶋 真子"], ["Nishino_Miki", "西野 未姫"], ["Hashimoto_Hikari", "橋本 耀"], ["Maeda_Mitsuki", "前田 美月"]]}
{% endhighlight %}

### graph.ruを書く
さてこのデータを使ってグラフを描きます。layoutを`fdp`として各メンバーの情報からノードとエッジを作ります。

{% highlight ruby %}
# encoding: UTF-8
MEMBER = {"チームA"=>[["iwasa_misaki", "岩佐 美咲"], ["ohta_aika", "多田 愛佳"], ["ooya_shizuka", "大家 志津香"], ["katayama_haruka", "片山 陽加"], ["kuramochi_asuka", "倉持 明日香"], ["kojima_haruna", "小嶋 陽菜"], ... 中略 ... ["Shinozaki_Ayana", "篠崎 彩奈"], ["Takashima_Yurina", "髙島 祐利奈"], ["Murayama_Yuiri", "村山 彩希"], ["Mogi_Shinobu", "茂木 忍"], ["Uchiyama_Natsuki", "内山 奈月"], ["Okada_Nana", "岡田 奈々"], ["Kojima_Mako", "小嶋 真子"], ["Nishino_Miki", "西野 未姫"], ["Hashimoto_Hikari", "橋本 耀"], ["Maeda_Mitsuki", "前田 美月"]]}

global layout:'fdp', label:'AKB48', size:16

MEMBER.each do |team, members|
  node team.to_id, label:team
  members.each do |id, name|
    route team.to_id => id.to_id
    node id.to_id, label:name
  end
end

save :akb, :png
{% endhighlight %}
`route`でチーム名ノードを中心にその所属メンバーのノードがリンクするようにします。

graph.ruのディレクトリで`gviz`コマンドを実行します。
{% highlight bash %}
gviz
{% endhighlight %}

これにより次のような`akb.png`が出力されます。

<a href="{{ site.url }}/assets/images/2012/akb1.png" rel="lightbox" title="AKB"><img src="{{ site.url }}/assets/images/2012/akb1.png" alt="akb noshadow" /></a>
（クリックで拡大します）

### 色を付ける
色情報を適当に用意して、各ノードに色を付けます。
{% highlight ruby %}
COLOR = [["チームA", '#F576A3'], ["チームK", '#77B800'], ["チームB", '#34B6E4'], ["チーム4", '#F8D800'], ["研究生", '#9932CC'], ["昇格メンバー", '#FF8C00']]

global layout:'fdp', label:'AKB48', size:16
+nodes style:'filled'
+edges color:'#777777'

MEMBER.each do |team, members|
+  color = COLOR.assoc(team)[1]
+  node team.to_id, label:team, color:color
  members.each do |id, name|
    route team.to_id => id.to_id
+    node id.to_id, label:name, color:color, fillcolor:color+'33'
  end
end

save :akb, :png
{% endhighlight %}

再度`gviz`コマンドを実行します。

<a href="{{ site.url }}/assets/images/2012/akb2.png" rel="lightbox" title="AKB"><img src="{{ site.url }}/assets/images/2012/akb2.png" alt="akb noshadow" /></a>
（クリックで拡大します）

グラフに色が付きました。

### リーダーを区別する
AKBの各チームにはリーダーがいます。リーダーのノードを２重円にして他と識別できるようにします。
{% highlight ruby %}
LEADERS = ["takahashi_minami", "akimoto_sayaka", "kashiwagi_yuki", "oba_mina"]

LEADERS.each do |leader|
  node leader.to_id, peripheries:2
end
{% endhighlight %}

出力です。
<a href="{{ site.url }}/assets/images/2012/akb3.png" rel="lightbox" title="AKB"><img src="{{ site.url }}/assets/images/2012/akb3.png" alt="akb noshadow" /></a>
（クリックで拡大します）

### 仕上げ
最後にノードを真円とし、フォントや線の幅を調整して完成とします。

{% highlight ruby %}
+global layout:'fdp', label:'AKB48', size:16, fontsize:48, fontname:'Helvetica'
+nodes style:'filled', shape:'circle', fontname:'Futura', width:1.3
+edges color:'#777777', arrowhead:'none', penwidth:2

MEMBER.each do |team, members|
  color = COLOR.assoc(team)[1]
  node team.to_id, label:team, color:color
  members.each do |id, name|
+    name.sub!(/\s+/, "\n")
    route team.to_id => id.to_id
+    node id.to_id, label:name, color:color, fillcolor:color+'33', penwidth:3
  end
end

LEADERS = ["takahashi_minami", "akimoto_sayaka", "kashiwagi_yuki", "oba_mina"]

LEADERS.each do |leader|
  node leader.to_id, peripheries:2
end

save :m, :png
{% endhighlight %}

出力です。

<a href="{{ site.url }}/assets/images/2012/akb4.png" rel="lightbox" title="AKB"><img src="{{ site.url }}/assets/images/2012/akb4.png" alt="akb noshadow" /></a>
（クリックで拡大します）

いいですね！

### One More Thing..
あっ、大事な要素を一つ忘れていました..

画像付きのノードを一つだけ足します。画像は適当なところから拾ってきて同じディレクトリに置きます。
{% highlight ruby %}
node :yasusu, label:"", image:'yasusu.jpg', shape:'circle', width:1.5, penwidth:10, color:'pink', fillcolor:'white', imagescale:true, fixedsize:true, peripheries:5
{% endhighlight %}

これで完成です！

<a href="{{ site.url }}/assets/images/2012/akb5.png" rel="lightbox" title="AKB"><img src="{{ site.url }}/assets/images/2012/akb5.png" alt="akb noshadow" /></a>
（クリックで拡大します）

ホントはもちろんメンバーの画像がいいんですけどねぇ。

あなたもGvizでAKB48してみませんか？

<script src="https://gist.github.com/3898896.js?file=graph.ru"></script>


----

{{ "B008V2IB9G" | amazon_medium_image }}
{{ "B008V2IB9G" | amazon_link }}

