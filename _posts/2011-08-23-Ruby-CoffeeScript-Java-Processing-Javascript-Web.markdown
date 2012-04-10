---
layout: post
title: RubyのようなCoffeeScriptを使ってJavaのようなProcessingを書いてJavascriptで実行してWebでビジュアライジング・データを実現しようよ!
date: 2011-08-23
comments: true
categories:
---


「ビジュアライジング・データ ―Processingによる情報視覚化手法」(Ben Fry著) という
情報視覚化の実践的テクニックを解説する素晴らしい本があります

{{ 4873113784 | amazon_large_image }}

{{ 4873113784 | amazon_link }}

{{ 4873113784 | amazon_authors }}

この本では情報の視覚化にProcessingという
Javaをベースにしたグラフィック専用言語を使っています
Processingはマルチプラットフォームの統合開発環境に
その実行環境を備えていますが
エクスポート機能でJAVAアプレットを生成することで
成果物をWeb上に公開することもできます

http://processing.org/

しかしJAVAアプレットによる情報の視覚化に
不満を持っている人がいました
できればプラグインを介さずに
直接ブラウザのCanvas上で情報視覚化を実現したい
jQuery作者のJohn Resig氏はProcessingをJavaScriptにポートして
ブラウザ上でProcessingのコードを直接実行できるようにしました

[Processing.js](http://processingjs.org/)の登場です

一方で
Rubyしか知らない素人プログラマがいました
彼もWeb上での情報の視覚化をしてみたかったので
サイ本を入手してJavaScriptをマスターしようと考えました
Processing.jsの登場によりJavaScriptが書ければ
Processingによる情報の視覚化ができますからね
でもその異質感{% fn_ref 1 %}に簡単に跳ね返されて
ビジュアライジング・データの夢は儚く消えました
そして彼はつぶやきました

「世界が全部Rubyで記述できたらいいのに..」

でも
そんな日はなかなか来そうにありません

ところがそんな彼に一条の光明が差しました
まるでRubyと見間違うような
JavaScript用のコンパイラが登場したらしいのです!

その名もCoffeeScript

「プログラミング言語にジャワまでなら許せるけど、
コーヒーはねーよ」と内心思いつつも
その[サイト](http://jashkenas.github.com/coffee-script/)を覗いていみると..

「パパ　僕にも読めるよ!」

そんなわけで...

CoffeeScriptとProcessing.jsを使って
ビジュアライジング・データをしてみました :)

つまりRubyのようなCoffeeScriptを使って
JavaのようなProcessingのコードを書いて
Javascriptで実行して
WebのCanvas上でビジュアライジング・データを実現します
僕の言ってることわかりますか？

以下では
先の書籍にあった時系列グラフのサンプルをCoffeeScriptに移植し
Webブラウザで実行できるようにしたデモを紹介します
WebフレームワークはSinatra
開発環境はMac OSX Snow Leopardです
CoffeeScriptの書き方がたぶんイマイチなのはご容赦ください^^;
デモをHerokuにアップしたので
まずは見てやってください

[Visualizing-Data with Processing Demo](http://processing-demo.heroku.com/)

タブを切り替えると
グラフがぐにゅっとなるのが気持ちいいですよね
グラフは書籍にあったサンプルの他
2009年の国内人口推計{% fn_ref 2 %}を使っています

###ディレクトリ構成
最終的なファイル構成は以下のようになります
{% highlight ssh %}
.
├── Gemfile
├── Gemfile.lock
├── app.rb
├── config.ru
├── public
│&#160;&#160; ├── census.ssv
│&#160;&#160; ├── js
│&#160;&#160; │&#160;&#160; ├── graph.coffee
│&#160;&#160; │&#160;&#160; └── processing-1.2.3.min.js
│&#160;&#160; └── milk-tea-coffee.tsv
└── views
    ├── index.haml
    ├── layout.haml
    └── style.scss
{% endhighlight %}

###設計方針
以下のような方針でビジュアライジング・データを実現します
1. データを格納したcensus.ssv{% fn_ref 3 %}とmilk-tea-coffee.tsv{% fn_ref 4 %}をrubyで読みだして解析する
1. 解析したデータをJSON APIとして特定のURLで提供できるようにする
1. graph.coffeeにProcessingによるグラフ描画コードを記述する
1. graph.coffee側で解析データを非同期で取得しグラフに描画する

###app.rb
Webフレームワークのコントローラとなる
app.rbの要点だけを書きます
{% highlight ruby %}
get "/milk" do
  haml :index
end
get "/milk.json" do
  redirect '/milk' unless request.xhr?
  content_type :json
  parse_data('public/milk-tea-coffee.tsv', '\t', [5, 2.5, 10]).to_json
end
helpers do
  def parse_data(path, sep, intervals)
    q = {}
    File.open(path) do |file|
      q['label'] = retrieve_label(file.lines.first, sep) 
      q['data'] = retrieve_data(file.lines, sep)
      all_data = q['data'].map { |d| d[0..-2] }.flatten
      q['dataMin'], q['dataMax'] = all_data.min.floor, all_data.max.ceil
      q['intervals'] = intervals
    end
    q
  end
end
{% endhighlight %}
ここではグラフを描画するURLを'/milk'としています
JavaScriptから'/milk.json'がgetされると
データファイルをparse_dataメソッドで解析して
結果をJSONで返します
parse_dataでは
label data dataMin dataMax intervalsに値をセットします
labelとdataの取得はretrieve_label retrieve_dataに委ねますが
ここではその説明は省略します

###Processingオブジェクト(graph.coffee)
graph.coffeeは長いので分けて要点だけ説明します
{% highlight javascript %}
$ ->
  $.getJSON "/milk.json", (json) ->
    label = json.label
    data = json.data
    dataMax = Math.ceil(json.dataMax/10.0)*10
    dataMin = if json.dataMin > 0 then 0 else json.dataMin
    [yInterval, yIntervalMinor, xInterval] = json.intervals
    canvas = $("canvas#processing")[0]
    processing = new Processing(canvas, graph)
{% endhighlight %}
まずHTMLの読み込み完了を待って
jQueryの$.getJSONを使って非同期で
先のURLからJSON化されたデータを取得し
それぞれの値をグローバル変数にセットします

そしてnew Processing(canvas graph)で
グラフ描画の実体である
graphオブジェクトをcanvas要素に結びつけた
Processingオブジェクトを生成します
これによってgraphオブジェクト内のdrawメソッドが
指定のフレームレートで繰り返し実行され
Canvas上にグラフが描かれることになります

###graphオブジェクト(graph.coffee)
次にgraphオブジェクトを示します
{% highlight javascript %}
graph = (p) ->
  p.setup = ->
    [rowCount, columnCount] = [data.length-1, label.length-1]
    [dateMin, dateMax] = [data[0][columnCount], data[rowCount][columnCount]]
    [xMin, yMin] = [dateMin[0], dateMax[0]]
    p.size(can_w, can_h)
    p.frameRate(20)
    p.smooth()
    setTabPositions(p)
    for row in [0..rowCount]
      interpolators[row] = new Integrator(0)
      interpolators[row].set_target(data[row][0])
  p.draw = ->
    drawMainFrame(p)
    
    for row in [0..rowCount]
      interpolators[row].update()
      
    drawDataArea(p, areaColor)
    drawXLabels(p)
    drawYLabels(p)
    drawDataHighlight(p, [255, 63, 0])
    drawTabs(p)
{% endhighlight %}
graphオブジェクトは
setupメソッドとdrawメソッドを持っています
setupメソッドはgraphオブジェクトの生成時に実行されるので
ここでグラフのサイズやフレームレートなどを設定します
そしてdrawメソッドは指定フレームレートで
そこに書かれた処理を繰り返し実行します
グラフの枠組みをdrawMainFrame drawXLabels
drawYLabels drawTabsで描画し
グラフの描画は
drawDataArea drawDataHighlightで行っています

###drawDataArea(graph.coffee)
次にdrawDataAreaについて説明します
{% highlight javascript %}
graph = (p) ->
  drawDataArea = (p, color)->
    [r,g,b] = color
    p.fill(r,g,b)
    p.noStroke()
    p.beginShape()
    p.vertex(borderLeft, borderBottom)
    for row in [0..rowCount]
      year = data[row][columnCount][0]
      val = interpolators[row].value
      x = p.map(year, xMin, yMin, borderLeft, borderRight)
      y = p.map(val, dataMin, dataMax, borderBottom, borderTop)
      p.curveVertex(x, y)
      if row is 0 or row is rowCount
        p.curveVertex(x, y)
    p.vertex(borderRight, borderBottom)
    p.vertex(borderRight, borderBottom)
    p.endShape(p.CLOSE)
{% endhighlight %}
curveVertex関数を使ってデータエリアを描画します
色やストロークを決定した後
beginShape関数で描画を開始し
各点をcurveVertexでプロットして
endShape関数で終了します
他の描画関数も同じようなことをしているので
説明は省略します

###Integrator(graph.coffee)
ここで各点をプロットするときに
データ値を直接渡さずにinterpolatorを介します
interpolatorはBenFryによるIntegratorオブジェクトで
これを介すると描画点をターゲット値に向けて
徐々に増分して描画できるようになります
Integratorの実装を以下に示します
{% highlight javascript %}
class Integrator
  # Ben Fry's Integrator
  constructor: (@value, @damping=0.5, @attraction=0.2) ->
    @mass = 1
    @targeting = false
    @vel = 0
    @force = 0.1
  update: ->
    if @targeting
      @force += @attraction * (@target - @value)
    accel = @force / @mass
    @vel = (@vel + accel) * @damping
    @value += @vel
    @force = 0
  set_target: (t) ->
    @targeting = true
    @target = t
{% endhighlight %}

###layout.haml
{% highlight html %}
!!! 5
%html
  %head
    %meta{:charset => 'utf-8'}
    %title= APP_TITLE
    %link{:rel => 'stylesheet', :href => '/style.css'}
    %script{:src => "http://ajax.googleapis.com/ajax/libs/jquery/1.6.1/jquery.min.js"}
    %script{:src => '/js/processing-1.2.3.min.js'}
    %script{:src => "http://jashkenas.github.com/coffee-script/extras/coffee-script.js"}
    %script{:type => 'text/coffeescript', :src => '/js/graph.coffee'}
  %body
    = yield
{% endhighlight %}
layout.hamlではscriptとしてjquery.js 
processing.js coffee-script.js graph.coffee を読み込みます
coffee-script.jsはclientサイドで
coffeeファイルをjavascriptに変換します

###config.ru
{% highlight ruby %}
require 'bundler'
Bundler.require
$LOAD_PATH << File.expand_path(File.dirname(__FILE__))
require 'app'
mime_type :coffee, "text/coffeescript"
run Sinatra::Application
{% endhighlight %}
coffeeファイルを'text/coffeescript' mime_typeで扱えるよう
config.ruでその指定をします

説明が大雑把で詳細が掴めないと思いますが
ソースコードを添付しますので
そちらを参照頂ければ助かります^^;

https://github.com/melborne/ProcessingDemo

参考サイト:
[CoffeeScript + Processing.js == Crazy Delicious](http://dry.ly/2011/02/21/coffeescript--processingjs--crazy-delicious/)

関連記事:
[Processingアプレットをはてダに貼り付けよう！ - hp12c](http://d.hatena.ne.jp/keyesberry/20110204/p1)
[fun of Processing - hp12c](http://d.hatena.ne.jp/keyesberry/20110131/p1)
[fun of Processing! - hp12c](http://d.hatena.ne.jp/keyesberry/20110130/p1)
{% footnotes %}
   {% fn Rubyしか知らない個人の感想です %}
   {% fn http://www.stat.go.jp/data/jinsui/2009np/index.htm %}
   {% fn スペース区切りのテキストファイル %}
   {% fn タブ区切りのテキストファイル %}
{% endfootnotes %}
