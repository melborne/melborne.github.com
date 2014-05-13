---
layout: post
title: "スペースインベーダー、Graphviz侵略ス"
description: ""
category: 
tags: 
date: 2013-03-28
published: true
---
{% include JB/setup %}

(追記：2014-3-3) Gvizについてのまとめ頁を作りました。

> [Gvizの目次 - Rubyの世界からGraphvizの世界にこんにちは！]({{ BASE_PATH }}/2014/02/27/gviz-posts/ "Gvizの目次 - Rubyの世界からGraphvizの世界にこんにちは！")

---


Graphvizには「**osage**」という変わった名前のレイアウトがあります。これは多数のノードを整列して配置します。GraphvizのRubyラッパー「[gviz](https://rubygems.org/gems/gviz "gviz \| RubyGems.org \| your community gem host")」を使って100個のノードを整列表示するには次のようにします{% fn_ref 1 %}。

#### graph.ru
{% highlight ruby %}
global layout:'osage'
nodes shape:'square', width:'0.8'
100.times { |i| node i.to_id, label:i }

save :osage
{% endhighlight %}

ターミナルで`gviz`コマンドを実行し生成されたDOTファイルを開くと、次のグラフが得られます。

![invader noshadow]({{ site.url }}/assets/images/2013/03/invader1.png)

0と99は反転していますが、1から順番にノードが整列配置されているのがわかります。

前回の投稿ではGraphvizのこの能力を使ってカラータイルを作りましたが、今更ながらこれは正に「ドットマトリクス」であるなあと気付いたのでした。ドットマトリクスといえば、そう「ドット絵」です。

そんなわけで...

今回は、Graphvizで「スペースインベーダー」を描いてみるという、アホな企画です。良い子の皆さんは真似しないでくださいね。

ところで、スペースインベーダー、知ってますか？

## スペースインベーダーのドットマトリクス

まずは、ネットから次のようなインベーダーの画像を取得します。

![invader noshadow_noround]({{ site.url }}/assets/images/2013/03/invader2.png)


そして、この画像に基いて二次元配列データを作ります。座標値または座標レンジを使って画が存在するドットを指定していきます（ここでは横幅を12ドットとしています）。

{% highlight ruby %}
kani_map =
  [
    [3, 9],
    [4, 8],
    [3..9],
    [2, 3, 5..7, 9, 10],
    [1..11],
    [1, 3..9, 11],
    [1, 3, 9, 11],
    [4, 5, 7, 8],
  ]
{% endhighlight %}

## Pieceオブジェクトの生成

次に、Pieceクラスを用意して、このドットデータを持ったPieceオブジェクトを生成するようにします。デフォルトで画があるところにはtrue、無いところにはfalseをセットする二次元配列を、mapインスタンス変数で保持させます。

#### invader.rb
{% highlight ruby %}
class Piece
  attr_reader :name, :map
  def initialize(name, map, filling=true, width=12)
    @name, @width, @filling = name, width, filling
    @map = build_map(map)
  end

  private
  def build_map(map)
    map.map do |row|
      row.inject(Array.new(@width){ !@filling }) do |mem, val|
        start, length = conv2st_len(val)
        mem.fill(@filling, start, length)
      end
    end
  end

  def conv2st_len(val)
    case val
    when Fixnum then [val, 1]
    when Range  then [val.begin, val.size]
    else raise "Accept only Fixnum or Range"
    end
  end
end
{% endhighlight %}

build_mapメソッドは、すべてがfalse値の二次元配列を生成し、渡されたmapデータをArray#fillを使って埋め込むようにします。conv2st_lenメソッドは、座標値と座標レンジを統一的に扱えるように前処理します。

このPieceクラスを使って、先のデータに基づいたkaniオブジェクトを生成します。

{% highlight ruby %}
kani_map =
  [
    [3, 9],
    [4, 8],
    [3..9],
    [2, 3, 5..7, 9, 10],
    [1..11],
    [1, 3..9, 11],
    [1, 3, 9, 11],
    [4, 5, 7, 8],
  ]

kani = Piece.new(:kani, kani_map)

kani.map # => [[false, false, false, true, false, false, false, false, false, true, false, false], [false, false, false, false, true, false, false, false, true, false, false, false], [false, false, false, true, true, true, true, true, true, true, false, false], [false, false, true, true, false, true, true, true, false, true, true, false], [false, true, true, true, true, true, true, true, true, true, true, true], [false, true, false, true, true, true, true, true, true, true, false, true], [false, true, false, true, false, false, false, false, false, true, false, true], [false, false, false, false, true, true, false, true, true, false, false, false]]
{% endhighlight %}


## Pieceオブジェクトの描画

さて、データの準備ができたので、Graphvizで描画してみます。

#### graph.ru
{% highlight ruby %}
require "./invader"

kani_map =
  [
    [3, 9],
    [4, 8],
    [3..9],
    [2, 3, 5..7, 9, 10],
    [1..11],
    [1, 3..9, 11],
    [1, 3, 9, 11],
    [4, 5, 7, 8],
    [],[],[],[]
  ]

kani = Piece.new(:kani, kani_map)

global layout:'osage'
nodes shape:'square', width:'0.8', style:'filled'

kani.map.each_with_index do |row, i|
  row.each_with_index do |val, j|
    id = "#{i}_#{j}"
    color = val ? '#00FFFF' : '#000000'
    node id.to_id, label:'', color:color, fillcolor:color
  end
end

save :invader
{% endhighlight %}

osageレイアウトでは縦横のドット数が異なると配列がズレてしまうので、kani_mapでは横配列数(12ドット)に合わせて縦配列数を調整しています。eachでkaniオブジェクトのmapを展開し、各ドットの値（trueまたはfalse）に応じてノードの色を変えます。

出力です。

![invader noshadow_noround]({{ site.url }}/assets/images/2013/03/invader3.png)

Graphviz上にスペースインベーダーが現れました。

<br />

<br />

でも、カニ一匹じゃ、寂しいです..よね..

もっと広いキャンバスに、インベーダー表示したいですよね。

もう少しがんばって..みますか..

## Canvasオブジェクトの生成
Pieceオブジェクトを配置するCanvasオブジェクトを用意します。Canvasクラスを定義しましょう。

{% highlight ruby %}
class Canvas
  include Enumerable
  def initialize(size, filling=false)
    @map = Array.new(size) { Array.new(size) { filling } }
  end

  def each(&blk)
    @map.each(&blk)
  end

  def fill(x, y, piece)
    piece.map.each_with_index do |row, i|
      @map[y+i][x, row.size] = row
    end
    @map
  end
end
{% endhighlight %}

Canvasクラスは、任意サイズの二次元配列を保持します。そして`Canvas#fill`メソッドにより、Canvasオブジェクト上の任意の位置に、Pieceオブジェクトのマップを埋め込めるようにします。

さあ、Canvas上にkaniを埋め込んで表示します。

{% highlight ruby %}
require "./invader"

kani_map =
  [
    [3, 9],
    [4, 8],
    [3..9],
    [2, 3, 5..7, 9, 10],
    [1..11],
    [1, 3..9, 11],
    [1, 3, 9, 11],
    [4, 5, 7, 8],
  ]

kani = Piece.new(:kani, kani_map, '#00FFFF')

canvas = Canvas.new(120)
canvas.fill(50, 50, kani)

global layout:'osage'
nodes shape:'square', width:'0.8', style:'filled', penwidth:4

canvas.map.each_with_index do |row, i|
  row.each_with_index do |color, j|
    id = "#{i}_#{j}"
    color ||= '#000000'
    node id.to_id, label:'', color:color, fillcolor:color
  end
end

save :invader
{% endhighlight %}

ここでは、`Piece.new`の第3引数に色を直接渡しています。

出力です。

![invader noshadow_noround]({{ site.url }}/assets/images/2013/03/invader4.png)

よし。

じゃあ、全員集合といきましょうか。

{% highlight ruby %}
require "./invader"

ika_map = 
  [
    [5, 6],
    [4..7],
    [3..8],
    [2, 3, 5, 6, 8, 9],
    [2..9],
    [4, 7],
    [3, 5, 6, 8],
    [2, 4, 7, 9],
  ]

kani_map =
  [
    [3, 9],
    [4, 8],
    [3..9],
    [2, 3, 5..7, 9, 10],
    [1..11],
    [1, 3..9, 11],
    [1, 3, 9, 11],
    [4, 5, 7, 8],
  ]

tako_map =
  [
    [4..7],
    [1..10],
    [0..11],
    [0..2, 5, 6, 9..11],
    [0..11],
    [3, 4, 7, 8],
    [2, 3, 5, 6, 8, 9],
    [0, 1, 10, 11],
  ]

wall_map =
  [
    [3..12],
    [2..13],
    [1..14],
    [0..15],
    [0..15],
    [0..15],
    [0..15],
    [0..15],
    [0..15],
    [0..4, 11..15],
    [0..3, 12..15],
  ]

battery_map =
  [
    [6],
    [5..7],
    [5..7],
    [2..10],
    [1..11],
    [1..11],
    [1..11],
  ]

fire_map =
  [
    [1, 2],
    [0, 1],
    [1],
    [1, 2],
    [0, 1],
    [1],
    [1],
  ]

ika, kani, taco, wall, battery, fire =
  [
    [:ika, ika_map, '#00FF00'],
    [:kani, kani_map, '#00FFFF'],
    [:tako, tako_map, '#FF00FF'],
    [:wall, wall_map, '#FF0000'],
    [:battery, battery_map, '#00FFFF'],
    [:fire, fire_map, '#FFFF00'],
  ].map { |name, map, color| Piece.new(name, map, color) }


canvas = Canvas.new(120)

6.step(110, 16).each { |i| canvas.fill(i, 12, ika) }
6.step(110, 16).each { |i| canvas.fill(i, 28, kani) }
6.step(110, 16).each { |i| canvas.fill(i, 44, taco) }
12.step(110, 28).each { |i| canvas.fill(i, 85, wall) }
canvas.fill(23, 105, battery)
canvas.fill(28, 64, fire)


global layout:'osage'
nodes shape:'square', width:'0.8', style:'filled', penwidth:4

canvas.map.each_with_index do |row, i|
  row.each_with_index do |color, j|
    id = "#{i}_#{j}"
    color ||= '#000000'
    node id.to_id, label:'', color:color, fillcolor:color
  end
end

save :invader
{% endhighlight %}

<br />
<br />

どうだ。

<br />

<br />

![invader noshadow_noround]({{ site.url }}/assets/images/2013/03/invader5.png)

ヒャホー！

<br />

「スペースインベーダー、Graphviz侵略ス。」

<br />
<br />

{% gist 5254390 %}

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

{% footnotes %}
{% fn patchworkというレイアウトでも同様のことができます。 %}
{% endfootnotes %}

