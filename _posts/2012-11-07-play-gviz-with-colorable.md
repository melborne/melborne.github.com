---
layout: post
title: "Rubyライブラリ「Colorable」とGvizを使ってGraphvizで綺麗なリングを描く"
description: ""
category: 
tags: 
date: 2012-11-07
published: true
---
{% include JB/setup %}

(追記：2013-05-15) Colorableを大幅アップデートしました（version 0.2.0）。その結果、この記事で書かれたバージョンとの互換性がなくなっています。現在の機能に関しては以下の記事を参考にしてください。

> {% hatebu http://melborne.github.io/2013/05/15/color-handler-colorable-gem-updated/ "Rubyで色を扱うライブラリ「Colorable」をアップデートしましたのでお知らせいたします" %}

----

Rubyで「色」というものを扱う機会はそう多くはないでしょう。Rubyはどちらかと言うと、クライアントサイドつまり接客系ではなく、サーバーサイドつまり裏方系言語ですからね。それでも接客系言語に向けて色情報を渡したり、そのラッパーになったりする機会はあるとおもいます。そんなときはRubyでも色を扱う必要がでてきます。

実際、拙作GraphvizのRubyラッパー「[Gviz](https://rubygems.org/gems/gviz 'gviz')」で色付きグラフを作るときには、色指定で色々と苦労します。

[RubyGems.org](https://rubygems.org/ 'RubyGems.org')で検索すると、ANSIカラー以外の色関係のライブラリがそれなりの数ヒットします。しかし、ざっと見たところ自分の欲しい物が見つかりません。というか、なんか探すの面倒臭いんですよね..


<br/>

そんなわけで... 車輪の再発明と思いつつも... 勉強を兼ねまして...

<br/>

`Colorable`というRGBとかHSBとかの色を扱うライブラリを作りました^ ^; ちょっとまだ中途半端な出来ですが。

> [colorable | RubyGems.org | your community gem host](https://rubygems.org/gems/colorable 'colorable | RubyGems.org | your community gem host')

----

## 使い方
`gem install colorable`して、次のように使います。

### Colorable::Color
{% highlight ruby %}
require "colorable"

c = Colorable::Color.new(:alice_blue)

c # => rgb(240,248,255)
c.name # => "Alice Blue"
c.rgb # => [240, 248, 255]
c.hex # => "#F0F8FF"
c.hsb # => [208, 6, 100]

c2 = Colorable::Color.new([0, 255, 255])

c2 # => rgb(0,255,255)
c2.name # => "Aqua"
c2.rgb # => [0, 255, 255]
c2.hex # => "#00FFFF"
c2.hsb # => [180, 100, 100]
{% endhighlight %}
`Color.new`は[X11の色名称](http://ja.wikipedia.org/wiki/X11%E3%81%AE%E8%89%B2%E5%90%8D%E7%A7%B0 'X11の色名称 - Wikipedia')またはRGB値の配列を引数に取り、colorオブジェクトを生成します。色名称は文字列またはシンボルを受け付けます。そしてRGB値に基いてHEXおよびHSB(Hue, Saturation, Brightness)値を返します。

Colorには`#next`,`#prev`というメソッドがあります。これらはX11カラーにおける次の色、前の色を順次出力します。
{% highlight ruby %}
c = Colorable::Color.new(:alice_blue)

c.next.name # => "Antique White"
10.times.map { c = c.next; c.name } # => ["Antique White", "Aqua", "Aquamarine", "Azure", "Beige", "Bisque", "Black", "Blanched Almond", "Blue", "Blue Violet"]


c2 = Colorable::Color.new(:alice_blue)

c2.prev.name # => "Yellow Green"
10.times.map { c2 = c2.prev; c2.name } # => ["Yellow Green", "Yellow", "White Smoke", "White", "Wheat", "Violet", "Turquoise", "Tomato", "Thistle", "Teal"]
{% endhighlight %}
X11のカラーセット（144色）は環状になっているので`#next`,`#prev`は循環します。

これらのメソッドは、デフォルトでその名前順に色を出力しますが、`:rgb`, `:hsb`などの並びを指定する引数を渡すことにより、その並びでの色を順に出力させることができます。
{% highlight ruby %}
c = Colorable::Color.new(:alice_blue)

c.next(:rgb).name # => "Honeydew"
10.times.map { c = c.next(:rgb); c.name } # => ["Honeydew", "Azure", "Sandy Brown", "Wheat", "Beige", "White Smoke", "Mint Cream", "Ghost White", "Salmon", "Antique White"]


c2 = Colorable::Color.new(:alice_blue)

c2.prev(:hsb).name # => "Steel Blue"
10.times.map { c2 = c2.prev(:hsb); c2.name } # => ["Steel Blue", "Light Sky Blue", "Sky Blue", "Deep Sky Blue", "Light Blue", "Powder Blue", "Cadet Blue", "Dark Turquoise", "Cyan", "Aqua"]
{% endhighlight %}

### Colorable::Colorset
多数の色をまとめて扱いたいときは、`Colorable::Colorset`を使います。

{% highlight ruby %}
cs = Colorable::Colorset.new

cs.first(10).map(&:name) # => ["Alice Blue", "Antique White", "Aqua", "Aquamarine", "Azure", "Beige", "Bisque", "Black", "Blanched Almond", "Blue"]
cs.last(10).map(&:hex) # => ["#008080", "#D8BFD8", "#FF6347", "#40E0D0", "#EE82EE", "#F5DEB3", "#FFFFFF", "#F5F5F5", "#FFFF00", "#9ACD32"]
{% endhighlight %}

異なる並びのカラーセットを得たいときは、`Colorset.[]`メソッドを使います。
{% highlight ruby %}
cs = Colorable::Colorset[:rgb]

cs.first(10).map(&:name) # => ["Black", "Navy", "Dark Blue", "Medium Blue", "Blue", "Dark Green", "Green2", "Teal", "Dark Cyan", "Deep Sky Blue"]
cs.last(10).map(&:rgb) # => [[255, 240, 245], [255, 245, 238], [255, 248, 220], [255, 250, 205], [255, 250, 240], [255, 250, 250], [255, 255, 0], [255, 255, 224], [255, 255, 240], [255, 255, 255]]

cs = Colorable::Colorset[:hsb]

cs.first(10).map(&:name) # => ["Black", "Dim Gray", "Gray2", "Dark Gray", "Gray", "Silver", "Light Gray", "Gainsboro", "White Smoke", "White"]
cs.last(10).map(&:hsb) # => [[302, 49, 85], [322, 89, 78], [327, 92, 100], [330, 59, 100], [338, 73, 69], [341, 6, 100], [341, 49, 86], [349, 91, 86], [351, 25, 100], [352, 29, 100]]
{% endhighlight %}

----

## Gvizとともに使う
さて、Colorableが`Color#next`や`Colorset`を使って色の並びを取得できることがわかりました。これを`Gviz`を使って視覚的に表現してみます。ここでは名前順、RGB順およびHSB順の色の並びを比較してみますね。Gvizは`gem i gviz`で取得します。

まずは名前順です。graph.ruファイルを用意して次のコードを打ち込みます。

{% highlight ruby %}
# graph.ru
require "colorable"

color = Colorable::Color.new(:black)

global layout:'neato', size:20
nodes shape:'circle', style:'filled'

loop do
  nxt = color.next
  route color.name.to_id => nxt.name.to_id
  [color, nxt].each do |c|
    fcolor = c.dark? ? '#FFFFFF' : '#000000'
    node c.name.to_id, label:c.name, fillcolor:c.hex, fontcolor:fcolor
  end
  color = nxt
  break if color.name == "Black"
end

save :color, :png
{% endhighlight %}

各色をノードとし`Color#next`で順に次の色を名前順に呼び出していきます。`route`メソッドで隣合うノード同士を順につないでいき、最初の色（"Black"）が現れたところでloopを抜けます。

このファイルのあるディレクトリで`gviz`コマンドを実行すれば、以下の出力が得られます。

![Alt ColorLing noshadow]({{ site.url }}/assets/images/2012/color0.png)

名前順の色リングができました。

ノードのサイズがばらばらですから、これを固定することでよりビジュアルに訴えるものに仕上げます。

{% highlight ruby %}
require "colorable"

color = Colorable::Color.new(:black)

global layout:'neato', size:20
+ nodes shape:'circle', style:'filled', width:4

loop do
  nxt = color.next
  route color.name.to_id => nxt.name.to_id
  [color, nxt].each do |c|
    fcolor = c.dark? ? '#FFFFFF' : '#000000'
    node c.name.to_id, label:c.name, fillcolor:c.hex, fontcolor:fcolor
  end
  color = nxt
  break if color.name == "Black"
end

save :color, :png
{% endhighlight %}

出力です。

![Alt ColorLing noshadow]({{ site.url }}/assets/images/2012/color1.png)

名前は隠れちゃいましたけど、なかなかキレイですね。しかし色の並びが名前順なので、色変化としての並びはばらばらです。

今度はRGB順でリングを作ってみます。nextに`:rgb`の引数を渡します。

{% highlight ruby %}
require "colorable"

color = Colorable::Color.new(:black)

global layout:'neato', size:20
nodes shape:'circle', style:'filled', width:4

loop do
+  nxt = color.next(:rgb)
  route color.name.to_id => nxt.name.to_id
  [color, nxt].each do |c|
    fcolor = c.dark? ? '#FFFFFF' : '#000000'
    node c.name.to_id, label:c.name, fillcolor:c.hex, fontcolor:fcolor
  end
  color = nxt
  break if color.name == "Black"
end

save :color, :png
{% endhighlight %}

出力です。

![Alt ColorLing noshadow]({{ site.url }}/assets/images/2012/color2.png)

かなりキレイな配色になりました。

しかしRGBカラーモデル（混色系）は各色成分の量で変化していくので、人間の色認識の感覚からはズレていてちょっと不十分な印象です。

今度はHSBカラーモデル（顕色系）を試します。nextの引数を`:hsb`に変えます。

{% highlight ruby %}
require "colorable"

color = Colorable::Color.new(:black)

global layout:'neato', size:20
nodes shape:'circle', style:'filled', width:4

loop do
+  nxt = color.next(:hsb)
  route color.name.to_id => nxt.name.to_id
  [color, nxt].each do |c|
    fcolor = c.dark? ? '#FFFFFF' : '#000000'
    node c.name.to_id, label:c.name, fillcolor:c.hex, fontcolor:fcolor
  end
  color = nxt
  break if color.name == "Black"
end

save :color, :png
{% endhighlight %}

出力です。

![Alt ColorLing noshadow]({{ site.url }}/assets/images/2012/color3.png)

人間が見てより自然な色変化になりました。

（正直もっと綺麗なグラデーションになることを期待したんですけど...もしかしたらHSBの演算が間違っているのかもしれません。あとで検証してみます。）

最後に、ノードのwidthを20にして再度HSBの並びを出力してみます。

![Alt ColorLing noshadow]({{ site.url }}/assets/images/2012/color4.png)


Graphvizでこんなに綺麗なリングが描けるなんて、ちょっと感動しませんか？

以上、「Colorable」ライブラリおよびそのGvizにおける使用例を紹介しました。

----

(追記：2014-3-3) Gvizについてのまとめ頁を作りました。

> [Gvizの目次 - Rubyの世界からGraphvizの世界にこんにちは！]({{ BASE_PATH }}/2014/02/27/gviz-posts/ "Gvizの目次 - Rubyの世界からGraphvizの世界にこんにちは！")

---

{{ '0375810919' | amazon_medium_image }}
{{ '0375810919' | amazon_link }} by {{ '0375810919' | amazon_authors }}

