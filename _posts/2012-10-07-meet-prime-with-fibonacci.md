---
layout: post
title: "素数とフィボナッチ数の出会いをGviz（Ruby Graphviz Wrapper）で描く"
description: ""
category: 
tags: [graphviz, gem] 
date: 2012-10-07
published: true
---
{% include JB/setup %}

(追記：2014-3-3) Gvizについてのまとめ頁を作りました。

> [Gvizの目次 - Rubyの世界からGraphvizの世界にこんにちは！]({{ BASE_PATH }}/2014/02/27/gviz-posts/ "Gvizの目次 - Rubyの世界からGraphvizの世界にこんにちは！")

---

数字は社会生活における便利な道具の一つです。一方でそれはまた多くの人々を魅了して止まない迷宮の世界です。つまり数字は実用と神秘なる美しさとを同時に兼ね備えた概念なのです。

というわけで...

Gvizを使って今度は数字の美しさを表現してみようと思います。素数とフィボナッチ数を使います。

## 300までの数字を並べる
まずは単純に1〜300までの数字を平面的に並べてみます。Gvizで300個のノードを生成し、`neato`レイアウトで描画します。

{% highlight ruby %}
require "gviz"

max = 300
label = 'Numbers upto 300'

Graph do
  global layout:'neato', label:label, fontsize:54, size:15
  nodes shape:'circle', style:'filled'

  (1..max).each { |i| node :"#{i}" }
  
  save :number, :png
end
{% endhighlight %}

出力は次のようになりました。

<a href="{{ site.url }}/assets/images/2012/number1.png" rel="lightbox" title="Numbers"><img src="{{ site.url }}/assets/images/2012/number1.png" alt="numbers noshadow" /></a>
（クリックで拡大します）

カエルの卵みたいでちょっと気持ち悪いです。

## 素数列を取り出す

さて次に、ここから素数列のみを取り出し、それらのノードを順にエッジでリンクしてみます。

やはりグラフには色がないと寂しいので、素数列には青系の色を付けるようにしましょう。まずは色名をリスト（一行に一つの名前）で持ったテキストファイル[colors.txt](https://gist.github.com/3844917#file_colors.txt 'colors.txt')を読み出して、青系色を抽出します。

{% highlight ruby %}
File.open('colors.txt') do |f|
  COLORS = f.read.lines.map(&:chomp).reject { |l| l.empty? }
end

def color_pick(regex)
  COLORS.select { |c| c.match regex }
end

blues = color_pick(/(blue|cyan)\D*$/)

blues # => ["aliceblue", "blue", "blueviolet", "cadetblue", "cornflowerblue", "cyan", "darkslateblue", "deepskyblue", "dodgerblue", "lightblue", "lightcyan", "lightskyblue", "lightslateblue", "lightsteelblue", "mediumblue", "mediumslateblue", "midnightblue", "navyblue", "powderblue", "royalblue", "skyblue", "slateblue", "steelblue"]
{% endhighlight %}

色の準備ができたので、次に素数列を作って`route`メソッドでエッジでリンクされたノード列を作ります。

{% highlight ruby %}
require "prime"

max = 300
primes = Prime.each(max)

label = 'Prime Numbers upto 300'

Graph do
  global layout:'neato', label:label, fontsize:54, size:15
  nodes shape:'circle', style:'filled'

  (1..max).each { |i| node :"#{i}" }
  
  primes.each_cons(2) do |gr|
    route Hash[*gr]
    c = blues[rand blues.size]
    node :"#{gr[1]}", fillcolor:c, fontcolor:'white'
  end

  save :number, :png
end
{% endhighlight %}

出力は次のようになりました。

<a href="{{ site.url }}/assets/images/2012/number2.png" rel="lightbox" title="Numbers"><img src="{{ site.url }}/assets/images/2012/number2.png" alt="numbers noshadow" /></a>
（クリックで拡大します）

素数列が300の数字から抽出されて、一列に並びました。

## フィボナッチ数を取り出す

次に、一旦素数列を元に戻して、フィボナッチ数を抽出してみます。フィボナッチ数を生成するコードはなんでもいいですが、ここではEnumeratorを使って作ってみました。

{% highlight ruby %}
class Fib
  def self.create
    Enumerator.new do |y|
      a, b = 1, 1
      loop do
        y << a
        a, b = b, a+b
      end
    end
  end
end

max = 300
fibs = Fib.create.take_while { |i| i <= max*20  }

fibs # => [1, 1, 2, 3, 5, 8, 13, 21, 34, 55, 89, 144, 233, 377, 610, 987, 1597, 2584, 4181]
{% endhighlight %}

300までだとちょっと数が寂しいので、ここでは6000までのフィボナッチ数を抽出しています。

ノードの色を赤系として、フィボナッチ数を抽出します。

{% highlight ruby %}
max = 300
fibs = Fib.create.take_while { |i| i <= max*20  }

reds = color_pick(/(red|pink|violet)\D*$/)

label = 'Fibonacci Numbers upto 6000'

Graph do
  global layout:'neato', label:label, fontsize:54, size:15
  nodes shape:'circle', style:'filled'

  (1..max).each { |i| node :"#{i}" }
  
  fibs.each_cons(2) do |gr|
    route Hash[*gr]
    c = reds[rand reds.size]
    node :"#{gr[1]}", fillcolor:c, fontcolor:'white'
  end

  save :number, :png
end
{% endhighlight %}

出力は次のようになりました。

<a href="{{ site.url }}/assets/images/2012/number3.png" rel="lightbox" title="Numbers"><img src="{{ site.url }}/assets/images/2012/number3.png" alt="numbers noshadow" /></a>
（クリックで拡大します）

いいですね。

## 素数とフィボナッチ数の出会い

さて最後に素数とフィボナッチ数を重ねてみます。つまり先の２つの数列を同時に描画します。2つの数列にどんな出会いがあるのでしょうか。

{% highlight ruby %}
label = 'Fibonacci Numbers upto 6000'

Graph do
  global layout:'neato', label:label, fontsize:54, size:15
  nodes shape:'circle', style:'filled'

  (1..max).each { |i| node :"#{i}" }
  
  primes.each_cons(2) do |gr|
    route Hash[*gr]
    c = blues[rand blues.size]
    node :"#{gr[1]}", fillcolor:c, fontcolor:'white'
  end
  
  fibs.each_cons(2) do |gr|
    route Hash[*gr]
    c = reds[rand reds.size]
    node :"#{gr[1]}", fillcolor:c, fontcolor:'white'
  end

  save :number, :png
end
{% endhighlight %}

結果は次のとおりです！

<a href="{{ site.url }}/assets/images/2012/number4.png" rel="lightbox" title="Numbers"><img src="{{ site.url }}/assets/images/2012/number4.png" alt="numbers noshadow" /></a>
（クリックで拡大します）

雰囲気が大分変わりました。数列はループを描いています。ちょっとリンクを追ってみます。

`5`で別れた２つの数列は`13`でまたすぐ出会います。それから素数列は下側に小さめのループを描く一方で、フィボナッチ数列は`21`,`34`,`55`と直線的に進んで、両者は`89`でまた出会います。それから素数列はまた長い旅に出て右上に大きめのループを描く一方で、フィボナッチ数列は`144`の一つだけ進みます。そして両者は再び`233`で出会うのです...

ロマンチックです。美しいです。

## 更に先の出会いへ
ここまで来ると彼らが次にどこで出会うのかが気になります...

`max = 5000`として描画してみます。

結果は次のとおりです。

<a href="{{ site.url }}/assets/images/2012/number5.png" rel="lightbox" title="Numbers"><img src="{{ site.url }}/assets/images/2012/number5.png" alt="numbers noshadow" /></a>
（クリックで拡大します）

なんかどこかで見たような...不思議なかたち...

アダムとイヴは実は素数とフィボナッチ数だったとか！

それはさておき、３つ目のループの交点が見えますか？それが答えです！

（交点の拡大図）
<a href="{{ site.url }}/assets/images/2012/number6.png" rel="lightbox" title="Numbers"><img src="{{ site.url }}/assets/images/2012/number6.png" alt="numbers noshadow" /></a>
（クリックで拡大します）

さらに`max = 30000`としてみます。

出力は次のようになりました。図では確認できませんが、次の出会いは`28657`でやって来ます。

<a href="{{ site.url }}/assets/images/2012/number7.png" rel="lightbox" title="Numbers"><img src="{{ site.url }}/assets/images/2012/number7.png" alt="numbers noshadow" /></a>
（クリックで拡大します）

（交点の拡大図）
<a href="{{ site.url }}/assets/images/2012/number8.png" rel="lightbox" title="Numbers"><img src="{{ site.url }}/assets/images/2012/number8.png" alt="numbers noshadow" /></a>
（クリックで拡大します）


数字の神秘をGvizで表現してみました。


----

<script src="https://gist.github.com/3844917.js?file=numbers.rb"></script>

[Gviz sample: Meet Primes with Fibonaccies — Gist](https://gist.github.com/3844917 'Gviz sample: Meet Primes with Fibonaccies — Gist')


----

関連記事：

[Yet Another Ruby Graphviz Interfaceを作ったからみんなで大量のグラフを作って遊ぼうよ！](http://melborne.github.com/2012/09/25/ruby-plus-graphviz-should-eql-gviz/ 'Yet Another Ruby Graphviz Interfaceを作ったからみんなで大量のグラフを作って遊ぼうよ！')

[Ruby Graphvizラッパー「Gviz」でアメリカ合衆国をデータビジュアライズしよう！](http://melborne.github.com/2012/09/27/usstates-map-data-vasualization-with-gviz/ 'Ruby Graphvizラッパー「Gviz」でアメリカ合衆国をデータビジュアライズしよう！')

[東京の地下鉄をGviz（Ruby Graphviz Wrapper）で描く](http://melborne.github.com/2012/10/02/draw-metro-map-with-gviz/ '東京の地下鉄をGviz（Ruby Graphviz Wrapper）で描く')

----

（追記：2012-10-7）max=30000の出力を追加しました。

----

{{ 4101215235 | amazon_medium_image }}
{{ 4101215235 | amazon_link }} by {{ 4101215235 | amazon_authors }}

