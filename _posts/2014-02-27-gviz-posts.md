---
layout: post
title: "Gvizの目次 - Rubyの世界からGraphvizの世界にこんにちは！"
description: ""
category: 
tags: 'graphviz'
date: 2014-02-27
published: true
---
{% include JB/setup %}

このブログにはGvizに関する大量の記述があるのだけれどもまともにタグ付けされてないサイト検索もできないと非常にアクセスビリティの悪い有り様でまあ本来なら気合を入れてひとつその全体解説たる記事を書き下ろしてここに公開！と宣言してついでにEPUBにまとめて一攫千金と相成りたいところ如何せん筆がぁ筆がぁっつって一向に気持ちがそちら方面に向かわずにおるわけで。

そこで代わりといってはなんですが「**Gvizの目次 - Rubyの世界からGraphvizの世界にこんにちは！**」と題して過去の記事をここにまとめて一覧できるように致しましたのでGvizをご利用頂いていていままで右往左往させられていた方あるいは使い方がわからん何が描けるのかわからん全く意味がわからんという方あるいは将来においてGvizに興味を持たれる可能性のある方居られましたら是非ともこのページを基点として各ページに飛んで頂きたくお願い申し上げます。

っていってそれじゃあまりにあまりお前のゆーざふれんどり精神あるいはおもてなしの心どこいったという精神内紛が勃発惹起されてしまったので仕方なく前置きくらいは書いておくかと書き始めてみたら筆がぁ筆がぁって走りだしてそれなりに長い記事になりましたが最後までお付き合いのほどよろしくね。

## Graphvizって何？

[Graphviz](http://www.graphviz.org/ "Graphviz \| Graphviz - Graph Visualization Software")はAT&T研究所が開発したオープンソースのグラフ描画ツールパッケージです。ここでいうグラフはExcelでいうところのグラフではなくグラフ理論でいうところのグラフです。ノードという玉とエッジという線を繋いだ体のもので、依然「**?**」な人はフローチャートや家系図をイメージしてください。Excelのグラフは数字を比較可能にビジュアライズします。一方で、Graphvizのグラフは「物事の関係性」をビジュアライズします。

Graphvizは、[**DOT言語**](http://ja.wikipedia.org/wiki/DOT%E8%A8%80%E8%AA%9E "DOT言語 - Wikipedia")という専用言語で記述された物事の関係性を読み込んで、これを描画出力します。png, jpeg, bmp, pdf, svgなど[多様な画像フォーマット](http://www.graphviz.org/content/output-formats "Output Formats \| Graphviz - Graph Visualization Software")への変換機能を持っています。プラットフォームに合ったものを[ここから](http://www.graphviz.org/Download..php "Download. \| Graphviz - Graph Visualization Software")ダウンロードして、エディタで以下のようなファイルを書きます。

{% highlight text %}
/* sample.dot */
digraph G {
  GrandpaA -> Papa;
  GrandmaA -> Papa;
  GrandpaB -> Mama;
  GrandmaB -> Mama;
  Papa -> You;
  Mama -> You;
}
{% endhighlight %}

ファイルを開くと、

    % open sample.dot

Graphvizソフトが立ち上がって、次のような出力が得られます。

![Alt title noshadow]({{ BASE_PATH }}/assets/images/2014/02/graphviz01.png)

任意の画像フォーマットへの変換は[コマンドラインツール](http://www.graphviz.org/content/command-line-invocation "Command-line Invocation \| Graphviz - Graph Visualization Software")でも、Graphvizソフトのexport機能を使ってもできます。

Graphvizの最大の特徴は、例のように関係性を記述すればその配置はGraphviz側でよしなにやってくれることです。一方でそれがGraphvizの最大の弱点にもなっています。個々のノードの配置を望み通りにコントロールするのは困難です。しかし手段がないわけではありません。

### ノードの配置その１

Graphvizはその大枠としてのレイアウトの指定ができます。デフォルトは`dot`ですが、`fdp`, `neato`, `circo`, `osage`などその名前からは配置が全く想像できないwレイアウトが使えます。

layoutに`neato`を指定してみます。

{% highlight text %}
digraph G {
  layout=neato;  /* レイアウトの指定 */
  GrandpaA -> Papa;
  GrandmaA -> Papa;
  GrandpaB -> Mama;
  GrandmaB -> Mama;
  Papa -> You;
  Mama -> You;
}
{% endhighlight %}

出力は以下のように変わります。

![Alt title noshadow]({{ BASE_PATH }}/assets/images/2014/02/graphviz02.png)


### ノードの配置その２

`rankdir`属性でレイアウトの向きというのを変えることができます。

左から右（LR）を指定してみます。

{% highlight text %}
digraph G {
  rankdir=LR; // 左から右へ
  GrandpaA -> Papa;
  GrandmaA -> Papa;
  GrandpaB -> Mama;
  GrandmaB -> Mama;
  Papa -> You;
  Mama -> You;
}
{% endhighlight %}

出力です。

![Alt title noshadow]({{ BASE_PATH }}/assets/images/2014/02/graphviz03.png)

### ノードの配置その３

`rank`属性でレイアウトにおけるノードの並び順位を指定できます。

{% highlight text %}
digraph G {
  GrandpaA -> Papa;
  GrandmaA -> Papa;
  GrandpaB -> Mama;
  GrandmaB -> Mama;
  Papa -> You;
  Mama -> You;
  { rank=same; Papa; GrandmaA } // これらを同じランクに
  { rank=same; Mama; GrandmaB }
  { rank=min; You } // 最小ランクに
}
{% endhighlight %}

出力です。

![Alt title noshadow]({{ BASE_PATH }}/assets/images/2014/02/graphviz04.png)

### ノードの配置その４

究極の配置手段として絶対位置指定`pos`属性があります。これは`fdp`, `neato`などのレイアウトで有効になります。

{% highlight text %}
digraph G {
  layout=neato;
  GrandpaA -> Papa;
  GrandmaA -> Papa;
  GrandpaB -> Mama;
  GrandmaB -> Mama;
  Papa -> You;
  Mama -> You;
  You [pos="0,0!"];
  Papa [pos="100,100!"];
  Mama [pos="0,-100!"];
  GrandmaA [pos="100,0!"];
  GrandmaB [pos="-100,0!"];
  GrandpaB [pos="100,-100!"];
  GrandpaA [pos="-100,100!"];
}
{% endhighlight %}

出力です。

![Alt title noshadow]({{ BASE_PATH }}/assets/images/2014/02/graphviz05.png)

### 属性指定

Graphvizのもう一つの大きな特徴は、多様な属性指定ができることです。グラフ全体、ノード、エッジなどに対して細かい属性指定が可能です。

先のグラフにいろいろと属性を指定してみます。

{% highlight text %}
digraph G {
  bgcolor="cornsilk";
  node [shape=egg];
  GrandpaA -> Papa [style=dotted];
  GrandmaA -> Papa [arrowhead="odiamond"];
  GrandpaB -> Mama;
  GrandmaB -> Mama [color="red"];
  Papa -> You;
  Mama -> You;
  You [shape=doublecircle, style=filled, fillcolor="orange"];
  Papa [shape=house, style="filled", color="purple", fontcolor="white", label="パパ"];
  Mama [shape=invhouse, style="filled", color="pink", label="ママ"];
}
{% endhighlight %}

出力です。

![Alt title noshadow]({{ BASE_PATH }}/assets/images/2014/02/graphviz06.png)

### 色

上で見たようにGraphvizではノード、エッジ、背景に自由に色を付けられます。簡単にかつ美しい色付けをしたい場合は`colorscheme`属性が便利です。

{% highlight text  %}
digraph G {
  node [style=filled, colorscheme=rdpu3];
  GrandpaA -> Papa;
  GrandmaA -> Papa;
  GrandpaB -> Mama;
  GrandmaB -> Mama;
  Papa -> You;
  Mama -> You;
  You [style=filled, fillcolor=1];
  Papa [style=filled, fillcolor=2];
  Mama [style=filled, fillcolor=2];
  GrandmaA [style=filled, fillcolor=3];
  GrandmaB [style=filled, fillcolor=3];
  GrandpaB [style=filled, fillcolor=3];
  GrandpaA [style=filled, fillcolor=3];
}
{% endhighlight %}

出力です。

![Alt title noshadow]({{ BASE_PATH }}/assets/images/2014/02/graphviz07.png)

### 文献

使えるレイアウト、属性、色などの情報は本家サイトのドキュメントを見るのが早いです。

> [Documentation \| Graphviz - Graph Visualization Software](http://www.graphviz.org/Documentation.php "Documentation \| Graphviz - Graph Visualization Software")

まとまった資料としては以下のPDF（英語版）があります。2006年版ということでちょっと古いです。

> [dotguide.pdf](http://www.graphviz.org/Documentation/dotguide.pdf "dotguide.pdf")

さらに古い2003年版を対象にしたものですが、日本語版を作られた方がいます。

> [dotguide.pdf](http://www.cbrc.jp/%7Etominaga/translations/graphviz/dotguide.pdf "dotguide.pdf")
>
> [日本語訳の文章: GSL, plotutils, etc.](http://www.cbrc.jp/%7Etominaga/translations/index.html#dot "日本語訳の文章: GSL, plotutils, etc.")


## Gvizって何？

GvizはDOT言語を使わずにRubyのコード（DSL）を書くことでGraphvizによるグラフ描画を可能にするライブラリ＆コマンドラインツールです。つまりRubyのコードをDOT言語によるコードに変換するコンバータです。DOT言語は制御構造を持っていないので、ノード数の多い複雑なグラフやプログラムに読み込めるデータに基づくグラフを描画する場合には、Gvizを使ったほうが圧倒的に早く仕事を終わらせられます。

> [Gvizのサイト](http://melborne.github.io/Gviz/ "Gviz")

Rubyによる同種のプログラムは多数存在します。古くからあって最も人気のあるものは「[ruby-graphviz](https://rubygems.org/gems/ruby-graphviz "ruby-graphviz \| RubyGems.org \| your community gem host")」です。比較的新しくて人気のあるものにRyan Davisの「[graph](https://rubygems.org/gems/graph "graph \| RubyGems.org \| your community gem host")」があります。Gvizはgraphにインスパイアされて作りました。私見ですがruby-graphvizはRuby成分が少なくgraphはtoo much DSLなので、Gvizは「**ほどよいDSL**」のインタフェースを目指しました。最新バージョンは0.3.4、Rubyは2.0.0以上が必要です。


## Gvizの使い方

２種類の使い方、つまりプログラムからの使い方とコマンドラインインタフェース（CLI）を通しての使い方があります。まずは`gem install gviz`します。

### プログラムから

この記事の最初のサンプルをrubyで書いてみます。

{% highlight ruby %}
# sample.rb
require 'gviz'

gv = Gviz.new

gv.add %i(GrandpaA GrandmaA) => :Papa
gv.add %i(GrandpaB GrandmaB) => :Mama
gv.add %i(Papa Mama) => :You

gv.save :sample, :png
{% endhighlight %}

`add`メソッド（またはroute）にHashを渡してノード同士のつなぎを指定します。各ノード名はSymbolの必要があります。渡されるHashのキー、バリュとしてこのように配列を指定できます。ここではaddを3回呼んでいますが、すべてのつなぎを一つのaddに渡しても構いません。

`save`メソッドの第１引数に出力ファイル名を、第２引数に画像フォーマットを渡します。第２引数を省略した場合はdotファイルだけが出力されます。

このファイルを実行すれば、

    % ruby sample.rb
    % open sample.dot #または sample.png

次の出力が得られます。

![Alt title noshadow]({{ BASE_PATH }}/assets/images/2014/02/graphviz01.png)

Gvizは`Graph`というトップレベルのショートカット関数を持っているので、上のコードは次のようにDSLを使ってより簡潔に記述できます。

{% highlight ruby %}
# sample.rb
require 'gviz'

Graph do
  add %i(GrandpaA GrandmaA) => :Papa
  add %i(GrandpaB GrandmaB) => :Mama
  add %i(Papa Mama) => :You
  
  save :sample, :png
end
{% endhighlight %}

### CLIから

Gvizをインストールするとターミナルで`gviz`コマンドが使えるようになります。

{% highlight bash %}
% gviz
Gviz is a tool for generating graphviz dot data with simple Ruby's syntax.
It works with a graph spec file (defaulting to load 'graph.ru').

Example of graph.ru:

  route :main => [:init, :parse, :cleanup, :printf]
  route :init => :make, :parse => :execute
  route :execute => [:make, :compare, :printf]

  save(:sample, :png)

Commands:
  gviz build [FILE]    # Build a graphviz dot data based on a file
  gviz help [COMMAND]  # Describe available commands or one specific command
  gviz man [NAME]      # Show available attributes, constants, colors for graphviz
  gviz version         # Show Gviz version
{% endhighlight %}

`graph.ru`という名前で次のように記述します。

{% highlight ruby %}
#graph.ru
add %i(GrandpaA GrandmaA) => :Papa
add %i(GrandpaB GrandmaB) => :Mama
add %i(Papa Mama) => :You

save :sample, :png
{% endhighlight %}

ファイルのディレクトリで`gviz build`コマンドを実行します。

    % gviz build
    % open sample.png

省略しますが同様の結果が得られます。

先の属性を指定した例も示します。

{% highlight ruby %}
#graph.ru
global bgcolor:"cornsilk"
nodes shape:"egg"

add %i(GrandpaA GrandmaA) => :Papa
add %i(GrandpaB GrandmaB) => :Mama
add %i(Papa Mama) => :You

node :You, shape:"doublecircle", style:"filled", fillcolor:"orange"
node :Papa, shape:"house", style:"filled", color:"purple", fontcolor:"white", label:"パパ"
node :Mama, shape:"invhouse", style:"filled", color:"pink", label:"ママ"
edge :GrandpaA_Papa, style:"dotted"
edge :GrandmaA_Papa, arrowhead:"odiamond"
edge :GrandmaB_Mama, color:"red"

save :sample
{% endhighlight %}

`global`メソッドでグラフ全体の属性を指定します。`nodes`メソッドでノード全体の、またここでは出てきませんが`edges`メソッドでエッジ全体の属性を指定します。

各ノード、エッジの属性指定はそれぞれ`node`, `edge`メソッドを使います。第１引数はidでありlabel属性がなければラベルとしても使われます。idはSymbolでなければならず、エッジのidはノードのidを`_`（アンダーバー）で結んだものになります。ここでは使われていませんが、`Object#to_id`を使って任意のオブジェクトからidを生成することができます。

![Alt title noshadow]({{ BASE_PATH }}/assets/images/2014/02/graphviz06.png)

### Rubyの図

Rubyらしい図も書いてみます。

{% highlight ruby %}
klasses = [Class, String, Symbol, Array, Hash, Fixnum, Bignum]

nodes shape:'box3d', colorscheme:'blues8', style:'filled'

klasses.each do |klass|
  klass.ancestors.reverse.each_cons(2).with_index(1) do |ab, i|
    a, b = ab.map { |n| :"#{n}" }
    route a => b
    node b, fillcolor:i%9
    edge [a, b] * '_', color:'maroon'
  end
end

save :ruby, :png
{% endhighlight %}

Module#ancestorsを使ってRubyのメソッド探索ルートをグラフ化します。普通にRubyのコードが書けます。

出力です。

![Alt title noshadow]({{ BASE_PATH }}/assets/images/2014/02/graphviz09.png)

いいですね。

---

Gvizの他の機能やどんなグラフや図が描けるのかについては、以下の記事一覧から辿って該当記事を読んでください。

## ブログ記事一覧

このブログにおいてGvizに関連する記事は以下になります（時系列昇順）。現時点で28件ありますが今後も新しい記事が書かれた際はここに追加します。

1. [Yet Another Ruby Graphviz Interfaceを作ったからみんなで大量のグラフを作って遊ぼうよ！]({{ BASE_PATH }}/2012/09/25/ruby-plus-graphviz-should-eql-gviz/ "Yet Another Ruby Graphviz Interfaceを作ったからみんなで大量のグラフを作って遊ぼうよ！")

2. [Ruby Graphvizラッパー「Gviz」でアメリカ合衆国をデータビジュアライズしよう！]({{ BASE_PATH }}/2012/09/27/usstates-map-data-vasualization-with-gviz/ "Ruby Graphvizラッパー「Gviz」でアメリカ合衆国をデータビジュアライズしよう！")

3. [東京の地下鉄をGviz（Ruby Graphviz Wrapper）で描く]({{ BASE_PATH }}/2012/10/02/draw-metro-map-with-gviz/ "東京の地下鉄をGviz（Ruby Graphviz Wrapper）で描く")

4. [東京の地下鉄の路線サインをGviz（Ruby Graphviz Wrapper）で描く]({{ BASE_PATH }}/2012/10/03/draw-metro-logos-with-gviz/ "東京の地下鉄の路線サインをGviz（Ruby Graphviz Wrapper）で描く")

5. [プログラミング言語にも案内サインシステムを！]({{ BASE_PATH }}/2012/10/03/draws-color-sign-of-programming-languages-with-gviz/ "プログラミング言語にも案内サインシステムを！")

6. [素数とフィボナッチ数の出会いをGviz（Ruby Graphviz Wrapper）で描く]({{ BASE_PATH }}/2012/10/07/meet-prime-with-fibonacci/ "素数とフィボナッチ数の出会いをGviz（Ruby Graphviz Wrapper）で描く")

7. [GvizでAKB48をビジュアライズするよ！]({{ BASE_PATH }}/2012/10/16/add-gviz-command-to-gviz-gem/ "GvizでAKB48をビジュアライズするよ！")

8. [GvizでGraphvizのノードの形とかエッジの形とか使える色の名前とかの属性情報をゲットするよ！]({{ BASE_PATH }}/2012/10/20/get-graphviz-attributes-from-gviz/ "GvizでGraphvizのノードの形とかエッジの形とか使える色の名前とかの属性情報をゲットするよ！")

9. [Rubyライブラリ「Colorable」とGvizを使ってGraphvizで綺麗なリングを描く]({{ BASE_PATH }}/2012/11/07/play-gviz-with-colorable/ "Rubyライブラリ「Colorable」とGvizを使ってGraphvizで綺麗なリングを描く")

10. [GraphvizでRubyのロゴは描けますか？]({{ BASE_PATH }}/2012/12/04/simple-ruby-logo-with-gviz/ "GraphvizでRubyのロゴは描けますか？")

11. [Graphvizで作る、私たちの国「日本」の本当の姿かたち]({{ BASE_PATH }}/2013/03/22/map-of-japan/ "Graphvizで作る、私たちの国「日本」の本当の姿かたち")

12. [Graphvizで作る、私たちの国「日本」の今度こそ本当の姿かたち]({{ BASE_PATH }}/2013/03/25/map-of-japan-2/ "Graphvizで作る、私たちの国「日本」の今度こそ本当の姿かたち")

13. [これもまた、Graphvizなんです。]({{ BASE_PATH }}/2013/03/25/this-is-another-world-of-graphviz/ "これもまた、Graphvizなんです。")

14. [スペースインベーダー、Graphviz侵略ス]({{ BASE_PATH }}/2013/03/28/space-invader-invade-graphviz-kingdom/ "スペースインベーダー、Graphviz侵略ス")

15. [Graphvizレイアウトサンプル]({{ BASE_PATH }}/2013/04/02/graphviz-layouts/ "Graphvizレイアウトサンプル")

16. [Graphvizで作る国旗の類似度世界地図]({{ BASE_PATH }}/2013/04/23/map-of-national-flags-with-graphviz/ "Graphvizで作る国旗の類似度世界地図")

17. [ピクミンがGraphvizにやって来た！]({{ BASE_PATH }}/2013/08/09/now-pikmin-come-to-graphviz/ "ピクミンがGraphvizにやって来た！")

18. [RubyユニバースをGraphvizで視覚化する]({{ BASE_PATH }}/2013/10/18/visualize-ruby-tree-with-graphviz/ "RubyユニバースをGraphvizで視覚化する")

19. [Rubiniusユニバースも視覚化してみる]({{ BASE_PATH }}/2013/10/19/visualize-rubinius-tree/ "Rubiniusユニバースも視覚化してみる")

20. [JRubyユニバースも視覚化してみる]({{ BASE_PATH }}/2013/10/20/visualize-jruby-tree/ "JRubyユニバースも視覚化してみる")

21. [Rubyのソースディレクトリも視覚化してみる]({{ BASE_PATH }}/2013/10/21/visualize-ruby-files-with-graphviz/ "Rubyのソースディレクトリも視覚化してみる")

22. [あなたのプロジェクトを美しく視覚化する]({{ BASE_PATH }}/2013/10/28/visualize-your-directory/ "あなたのプロジェクトを美しく視覚化する")

23. [あなたはファイルシステムに美を見るか？]({{ BASE_PATH }}/2013/10/31/there-is-a-beauty-in-your-computer/ "あなたはファイルシステムに美を見るか？")

24. [Graphvizがドローイングソフトになってしまった件について]({{ BASE_PATH }}/2014/01/08/graphviz-is-a-tool-for-drawing/ "Graphvizがドローイングソフトになってしまった件について")

25. [Rubyでサインカーブを描いて癒やされる]({{ BASE_PATH }}/2014/01/09/discover-beauty-of-sine-curves-through-graphviz/ "Rubyでサインカーブを描いて癒やされる")

26. [Rack以外でRackしたいRubyistのためのMatreska]({{ BASE_PATH }}/2014/01/14/matreska-is-rack-for-every-rubyist/ "Rack以外でRackしたいRubyistのためのMatreska")

27. [Graphvizで表そして気になる都知事選2014のゆくえ]({{ BASE_PATH }}/2014/02/03/build-table-nodes-with-html-like-labels-in-graphviz/ "Graphvizで表そして気になる都知事選2014のゆくえ")

28. [Gviz（Graphviz ruby wrapper）でクラスタエッジとか無向グラフとか]({{ BASE_PATH }}/2014/02/26/edges-between-clusters-now-enabled-with-gviz/ "Gviz（Graphviz ruby wrapper）でクラスタエッジとか無向グラフとか")

## 各記事の概要説明

記事の検索性を上げるためその概要も書いておきます。あらためて、なんというかGraphvizの本来の使い方とかけ離れた使い方ばかりで...。あまり参考にならないかもしれません。

### 1. [Yet Another Ruby Graphviz Interfaceを作ったからみんなで大量のグラフを作って遊ぼうよ！]({{ BASE_PATH }}/2012/09/25/ruby-plus-graphviz-should-eql-gviz/ "Yet Another Ruby Graphviz Interfaceを作ったからみんなで大量のグラフを作って遊ぼうよ！")

この記事ではGvizを公開したこと、その基本機能の説明およびサンプルとして次のような日本地図を描きました。

![pref4 noshadow]({{ site.url }}/assets/images/pref4.png)

### 2. [Ruby Graphvizラッパー「Gviz」でアメリカ合衆国をデータビジュアライズしよう！]({{ BASE_PATH }}/2012/09/27/usstates-map-data-vasualization-with-gviz/ "Ruby Graphvizラッパー「Gviz」でアメリカ合衆国をデータビジュアライズしよう！")

この記事ではアメリカ合衆国の各州の統合年、面積および人口を、ノードの色、大きさおよび多角形の辺の数を使ってビジュアライズしました。

![usa noshadow]({{ site.url }}/assets/images/usa6.png)

### 3. [東京の地下鉄をGviz（Ruby Graphviz Wrapper）で描く]({{ BASE_PATH }}/2012/10/02/draw-metro-map-with-gviz/ "東京の地下鉄をGviz（Ruby Graphviz Wrapper）で描く")

この記事では、[『駅データ．ｊｐ』](http://www.ekidata.jp/index.html)が提供する路線情報を使って、東京の地下鉄路線図をビジュアライズしました。ここでは駅の緯度・経度情報から正しい位置に駅ノードを配置しています。

![usa noshadow]({{ site.url }}/assets/images/2012/metro6.png)

### 4. [東京の地下鉄の路線サインをGviz（Ruby Graphviz Wrapper）で描く]({{ BASE_PATH }}/2012/10/03/draw-metro-logos-with-gviz/ "東京の地下鉄の路線サインをGviz（Ruby Graphviz Wrapper）で描く")

この記事では、東京の地下鉄の路線サインを描画しました。

![usa noshadow]({{ site.url }}/assets/images/2012/metrologo.png)

### 5. [プログラミング言語にも案内サインシステムを！]({{ BASE_PATH }}/2012/10/03/draws-color-sign-of-programming-languages-with-gviz/ "プログラミング言語にも案内サインシステムを！")

この記事では、地下鉄の路線サインにヒントを得て、プログラミング言語のサインを作ってみました。

![usa noshadow]({{ site.url }}/assets/images/2012/langlogo.png)

![usa noshadow]({{ site.url }}/assets/images/2012/langlogo2.png)

### 6. [素数とフィボナッチ数の出会いをGviz（Ruby Graphviz Wrapper）で描く]({{ BASE_PATH }}/2012/10/07/meet-prime-with-fibonacci/ "素数とフィボナッチ数の出会いをGviz（Ruby Graphviz Wrapper）で描く")

この記事では、Rubyで素数とフィボナッチ数を出力してそれが交わる様子をグラフ化してみました。

![usa noshadow]({{ site.url }}/assets/images/2012/number4.png)

### 7. [GvizでAKB48をビジュアライズするよ！]({{ BASE_PATH }}/2012/10/16/add-gviz-command-to-gviz-gem/ "GvizでAKB48をビジュアライズするよ！")

この記事では、Gvizに追加された（１）Gvizコマンド、（２）multiple edge指定、（３）Object#idの機能の紹介と、AKB48のメンバー名をグラフ化した例を載せました。

![usa noshadow]({{ site.url }}/assets/images/2012/akb5.png)


### 8. [GvizでGraphvizのノードの形とかエッジの形とか使える色の名前とかの属性情報をゲットするよ！]({{ BASE_PATH }}/2012/10/20/get-graphviz-attributes-from-gviz/ "GvizでGraphvizのノードの形とかエッジの形とか使える色の名前とかの属性情報をゲットするよ！")

この記事では、Gvizに追加された（１）`gviz man`コマンド、（２）Graphvizの属性情報定数の紹介と、属性情報定数を使った属性情報サンプルのグラフ化をしました。

![usa noshadow]({{ site.url }}/assets/images/2012/attr3.png)

### 9. [Rubyライブラリ「Colorable」とGvizを使ってGraphvizで綺麗なリングを描く]({{ BASE_PATH }}/2012/11/07/play-gviz-with-colorable/ "Rubyライブラリ「Colorable」とGvizを使ってGraphvizで綺麗なリングを描く")

この記事では、Rubyで色を扱うライブラリ「[colorable](https://rubygems.org/gems/colorable "colorable \| RubyGems.org \| your community gem host")」の紹介と、これをGvizと組合せて作ったカラーリングについて書きました。

![usa noshadow]({{ site.url }}/assets/images/2012/color4.png)

### 10. [GraphvizでRubyのロゴは描けますか？]({{ BASE_PATH }}/2012/12/04/simple-ruby-logo-with-gviz/ "GraphvizでRubyのロゴは描けますか？")

この記事では、Gvizで簡単にRubyのロゴが描けるか挑戦しました。

![usa noshadow]({{ site.url }}/assets/images/2012/rubylogo7.png)

イマイチでした。

### 11. [Graphvizで作る、私たちの国「日本」の本当の姿かたち]({{ BASE_PATH }}/2013/03/22/map-of-japan/ "Graphvizで作る、私たちの国「日本」の本当の姿かたち")

この記事では、@antlaboさんが公開されている[隣接市区町村のCSVデータ](http://d.hatena.ne.jp/antlabo/20121029/1351520444 "wikipediaの隣接市区町村の記載をデータベース化したものをcsvで公開 - 蟻の実験工房（別館ラボ）")を使って、日本地図の描画に挑戦しました。

![usa noshadow]({{ site.url }}/assets/images/2013/03/jpmap_color.png)

ええ、これが私たちの住む**日本**です。

### 12. [Graphvizで作る、私たちの国「日本」の今度こそ本当の姿かたち]({{ BASE_PATH }}/2013/03/25/map-of-japan-2/ "Graphvizで作る、私たちの国「日本」の今度こそ本当の姿かたち")

この記事では、先の記事を見て@antlaboさんが全国市町村の位置情報データを公開してくれたので、これに基いて日本地図の描画にリベンジした様子を書いています。

![usa noshadow]({{ site.url }}/assets/images/2013/03/japanmap_color.png)

### 13. [これもまた、Graphvizなんです。]({{ BASE_PATH }}/2013/03/25/this-is-another-world-of-graphviz/ "これもまた、Graphvizなんです。")

この記事は、`osage`というレイアウトを使ってカラーサンプルを描画しています。


![usa noshadow]({{ site.url }}/assets/images/2013/03/tile1.png)


### 14. [スペースインベーダー、Graphviz侵略ス]({{ BASE_PATH }}/2013/03/28/space-invader-invade-graphviz-kingdom/ "スペースインベーダー、Graphviz侵略ス")

この記事は、`osage`レイアウトを使ってスペースインベーダーの描画に挑戦した様子を書いています。

![usa noshadow]({{ site.url }}/assets/images/2013/03/invader5.png)

ええ、これもGraphvizで書いてるんです。

### 15. [Graphvizレイアウトサンプル]({{ BASE_PATH }}/2013/04/02/graphviz-layouts/ "Graphvizレイアウトサンプル")

この記事では、名前からはその形が皆目検討がつかないというGraphvizのレイアウトのサンプルを描画しています。

![usa noshadow]({{ site.url }}/assets/images/2013/04/neato.png)
![usa noshadow]({{ site.url }}/assets/images/2013/04/tree_fdp.png)
![usa noshadow]({{ site.url }}/assets/images/2013/04/tree_circo.png)


### 16. [Graphvizで作る国旗の類似度世界地図]({{ BASE_PATH }}/2013/04/23/map-of-national-flags-with-graphviz/ "Graphvizで作る国旗の類似度世界地図")

この記事では、これまた@antlaboさんが公開されている国旗の類似度データを使って、グラフ上で類似度の分布が現れるかに挑戦しています。

![usa noshadow]({{ site.url }}/assets/images/2013/04/flag2.png)

### 17. [ピクミンがGraphvizにやって来た！]({{ BASE_PATH }}/2013/08/09/now-pikmin-come-to-graphviz/ "ピクミンがGraphvizにやって来た！")

この記事では、Gvizコマンドの仕様の変更（Thorの利用）の紹介とピクミンの描画に挑戦しています。ピクミンはpng画像データから画素情報を抽出し、間引きを行って各画素をノードとしてGraphvizによる画像化をしています。

<img src="/assets/images/2013/08/gv_red_pikmin.png" alt="noshadow" style="width:100px" />
<img src="/assets/images/2013/08/gv_blue_pikmin.png" alt="noshadow" style="width:100px" />
<img src="/assets/images/2013/08/gv_yellow_pikmin.png" alt="noshadow" style="width:100px" />
<img src="/assets/images/2013/08/gv_rock_pikmin.png" alt="noshadow" style="width:100px" />
<img src="/assets/images/2013/08/gv_pink_pikmin.png" alt="noshadow" style="width:100px" />

### 18. [RubyユニバースをGraphvizで視覚化する]({{ BASE_PATH }}/2013/10/18/visualize-ruby-tree-with-graphviz/ "RubyユニバースをGraphvizで視覚化する")

この記事では、Rubyのクラス階層をグラフ化しています。

![usa noshadow]({{ site.url }}/assets/images/2013/10/ruby_tree7.png)

### 19. [Rubiniusユニバースも視覚化してみる]({{ BASE_PATH }}/2013/10/19/visualize-rubinius-tree/ "Rubiniusユニバースも視覚化してみる")

この記事では、今度はRubiniusのクラス階層をグラフ化しています。

![usa noshadow]({{ site.url }}/assets/images/2013/10/ruby_tree8.png)

### 20. [JRubyユニバースも視覚化してみる]({{ BASE_PATH }}/2013/10/20/visualize-jruby-tree/ "JRubyユニバースも視覚化してみる")

この記事では、更にJRubyのクラス階層をグラフ化しています。

![usa noshadow]({{ site.url }}/assets/images/2013/10/ruby_tree11.png)

### 21. [Rubyのソースディレクトリも視覚化してみる]({{ BASE_PATH }}/2013/10/21/visualize-ruby-files-with-graphviz/ "Rubyのソースディレクトリも視覚化してみる")

この記事では、Rubyのソースディレクトリのグラフ化に挑戦しています。

![usa noshadow]({{ site.url }}/assets/images/2013/10/ruby_dir10.png)

### 22. [あなたのプロジェクトを美しく視覚化する]({{ BASE_PATH }}/2013/10/28/visualize-your-directory/ "あなたのプロジェクトを美しく視覚化する")

この記事ではディレクトリ構造を簡単にビジュアライズする「[dir_friend](https://rubygems.org/gems/dir_friend "dir_friend \| RubyGems.org \| your community gem host")」というツールの紹介をしています。dir_friendは内部でGvizを使っています。

![usa noshadow]({{ site.url }}/assets/images/2013/10/prj_tree2.png)

### 23. [あなたはファイルシステムに美を見るか？]({{ BASE_PATH }}/2013/10/31/there-is-a-beauty-in-your-computer/ "あなたはファイルシステムに美を見るか？")

この記事では、dir_friendでテーマを設定できる機能紹介をしています。

![usa noshadow]({{ site.url }}/assets/images/2013/10/theme_tree3.png)

### 24. [Graphvizがドローイングソフトになってしまった件について]({{ BASE_PATH }}/2014/01/08/graphviz-is-a-tool-for-drawing/ "Graphvizがドローイングソフトになってしまった件について")

この記事では、Gvizに追加されたDrawライクなメソッド群の紹介およびそのサンプルについて書いています。

![usa noshadow]({{ site.url }}/assets/images/2014/01/gviz_draw2.png)
![usa noshadow]({{ site.url }}/assets/images/2014/01/gviz_draw3.png)
![usa noshadow]({{ site.url }}/assets/images/2014/01/gviz_batman.png)

### 25. [Rubyでサインカーブを描いて癒やされる]({{ BASE_PATH }}/2014/01/09/discover-beauty-of-sine-curves-through-graphviz/ "Rubyでサインカーブを描いて癒やされる")

この記事ではGvizのDraw系メソッドを使ってサインカーブのいろいろなバラエティを描画しています。

![usa noshadow]({{ site.url }}/assets/images/2014/01/sine3.png)
![usa noshadow]({{ site.url }}/assets/images/2014/01/sine5.png)

### 26. [Rack以外でRackしたいRubyistのためのMatreska]({{ BASE_PATH }}/2014/01/14/matreska-is-rack-for-every-rubyist/ "Rack以外でRackしたいRubyistのためのMatreska")

この記事では、アダプタブルなマルチフィルターバンドラー「[matreska](https://rubygems.org/gems/matreska "matreska \| RubyGems.org \| your community gem host")」の紹介と、これとGvizを組合せてアニメーションGIFを作る例を紹介しています。

![usa noshadow]({{ site.url }}/assets/images/2014/01/anpan.gif)

### 27. [Graphvizで表そして気になる都知事選2014のゆくえ]({{ BASE_PATH }}/2014/02/03/build-table-nodes-with-html-like-labels-in-graphviz/ "Graphvizで表そして気になる都知事選2014のゆくえ")

この記事では、@otahiさんからのPull Requestから実現したHTML風ラベルの機能紹介と、そのサンプルについて書いています。

![usa noshadow]({{ site.url }}/assets/images/2014/02/html_label2.png)
![usa noshadow]({{ site.url }}/assets/images/2014/02/html_label4.png)

### 28. [Gviz（Graphviz ruby wrapper）でクラスタエッジとか無向グラフとか]({{ BASE_PATH }}/2014/02/26/edges-between-clusters-now-enabled-with-gviz/ "Gviz（Graphviz ruby wrapper）でクラスタエッジとか無向グラフとか")

この記事では、@k1LoWさんからのリクエストで実現したsubgraph（cluster）同士の連結および無向グラフの機能についての紹介をしています。

![usa noshadow]({{ site.url }}/assets/images/2014/02/gviz_subgraph03.png)

---

以上、「Gvizの目次 - Rubyの世界からGraphvizの世界にこんにちは！」でした。ふぅ。

---

<p style='color:red'>=== Ruby関連電子書籍100円〜で好評発売中！ ===</p>

[M'ELBORNE BOOKS]({{ BASE_PATH }}/books/ "M'ELBORNE BOOKS")

<a href="{{ BASE_PATH }}/books/">
  <img src="/assets/images/books/rack_cover.png" alt="rack" style="width:200px" />
</a>
<a href="{{ BASE_PATH }}/books/">
  <img src="/assets/images/books/ruby_pack8.png" alt="pack8" style="width:200px" />
</a>
<a href="{{ BASE_PATH }}/books/">
  <img src="/assets/images/books/ruby_parallel_cover.png" alt="ruby_parallel" style="width:200px" />
</a>
