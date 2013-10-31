---
layout: post
title: "あなたはファイルシステムに美を見るか？"
tagline: 'DirFriendアップデートのお知らせ'
description: ""
category: 
tags: 
date: 2013-10-31
published: true
---
{% include JB/setup %}


「**美**」はどこにでも存在します。しかし私たちは日々忙しく対象に対する観察眼を失っていて、容易にはそれを発見することができないのです。

あなたが日頃向き合っているコンピュータの中には「ファイルシステム」があります。ファイルシステムは、あなたが作ったデータやプログラムを格納するファイル群にヒエラルキーを与え全体構造の中に組み込みます。個々のファイルはディレクトリノードによって木々の枝のように細かく枝分かれし、同じ構造をもって更に深く広く成長していきます。つまりファイルシステムは無機質な再帰的構造を生成します。

一方で、私たちは特定のディレクトリ構造やファイル群に名前を付することによって、そこに人間的な意味付けをすることができます。名前は個々のファイルに役割を与え命を吹き込みます。関連するファイルには関連する名前が与えられ、それらが相互作用することが期待されます。つまりファイルシステムは有機的・意味的構造を生成します。

そしてこのような一見排他的な二面性が一つのシステムの中に同居することよって、そこに「**美**」というものが見えてくるのです...。

<br/>


なんてね :-)

---

さて。

ディレクトリ構造をGraphvizで視覚化するためのツール「DirFriend」をバージョンアップしましたのでお知らせします（ver0.1.1）。


> [dir_friend | RubyGems.org | your community gem host](https://rubygems.org/gems/dir_friend "dir_friend | RubyGems.org | your community gem host")

DirFriend自体の説明については前回の記事を参照してください。

> [あなたのプロジェクトを美しく視覚化する]({{ BASE_PATH }}/2013/10/28/visualize-your-directory/ "あなたのプロジェクトを美しく視覚化する")

## 追加された機能

DirFriendに含まれる`dir_friend dot`コマンドは、対象ディレクトリの構造を視覚表現するDOTファイルを生成します。dotコマンドはGraphvizの属性に係る色々なオプションを取ることができ、それによって多彩なグラフを描画できます。

でも、Graphvizの属性値って大量すぎて...。

「コマンド実行の度に一々設定するのめんどくね？」

...です...よね...。

<br/>

---

という訳で...。

version0.1.1では、設定ファイルにお気に入りのテーマをセットしておいて、呼べるようにしました（誰得）。


任意のディレクトリ構造を作って試してみます。

{% highlight bash %}
% bundle gem tinytool -bt
      create  tinytool/Gemfile
      create  tinytool/Rakefile
      create  tinytool/LICENSE.txt
      create  tinytool/README.md
      create  tinytool/.gitignore
      create  tinytool/tinytool.gemspec
      create  tinytool/lib/tinytool.rb
      create  tinytool/lib/tinytool/version.rb
      create  tinytool/bin/tinytool
      create  tinytool/.rspec
      create  tinytool/spec/spec_helper.rb
      create  tinytool/spec/tinytool_spec.rb
      create  tinytool/.travis.yml
Initializating git repo in /tinytool
{% endhighlight %}

tinytoolディレクトリに対し`dot`サブコマンドを適用します。

{% highlight bash %}
% dir_friend dot tinytool
'config.yaml' created in /Users/keyes/.dirfriend.
You can set a theme for dot from pre-defined or created by you!
'a.dot' created in the current directory.
{% endhighlight %}

カレントディレクトリに`a.dot`というファイルが生成され、MacであればGraphvizが立ち上がって以下のようなグラフが表示されます(thanks to @rosylilly)。

{% lightbox  2013/10/theme_tree1.png, title, alt noshadow %}
（クリックで拡大）


この挙動は以前のバージョンと同じですが、最初の起動でターミナルの出力にあるようにホームディレクトリ以下に、`.dirfriend/config.yaml`というテーマ設定ファイルが生成されます。

そして次回起動時からはこの設定ファイルを読み込んで、DOTファイルを生成するようになります。

もう一度`dot`コマンドを実行してみます。

{% highlight bash %}
% dir_friend dot tinytool
'a.dot' created in the current directory.
{% endhighlight %}

config.yamlの内容に従って、生成されるDOTは以下のようになります。

{% lightbox  2013/10/theme_tree2.png, title, alt noshadow %}
（クリックで拡大）

任意のオプションを追加することで設定の一部を上書きすることもできます。

{% highlight bash %}
% dir_friend dot tinytool -c oranges -e color:red,arrowhead:odot
{% endhighlight %}

{% lightbox  2013/10/theme_tree3.png, title, alt noshadow %}
（クリックで拡大）

## config.yamlについて

`config.yaml`の内容を見てみます。

{% highlight yaml %}
# This is a template for `dir_friend dot` subcommand.
# 
# You can set a theme to default by giving
# one of the theme names or a hash settings directly
#
# ex.
#   default: :pop
#
#   default:
#     colorscheme: reds
#     style: fdp
#
# Themes can be called with '--theme' or '-t' option of `dot` subcommand.
#
# ex. `dir_friend dot path/ -t pop

default: tree

tree:
  global:
    rankdir: LR
    splines: ortho
  dir_shape: diamond

blueegg:
  colorscheme: blues
  edges:
    color: lightblue
  nodes:
    shape: egg

inline:
  layout: osage
  colorscheme: greens
  nodes:
    shape: box
  edges:
    color: gold

closeup:
  layout: neato
  colorscheme: purd
  nodes:
    shape: polygon

flower:
  layout: circo
  colorscheme: rdylgn
  nodes:
    shape: doublecircle

rigid:
  layout: sfdp
  colorscheme: greys
  nodes:
    shape: doubleoctagon

star:
  layout: dot
  colorscheme: set310
  global:
    bgcolor: midnightblue
    splines: curved
  edges:
    color: snow
    arrowhead: none
  nodes:
    shape: star
{% endhighlight %}

コメントに続いて`default: tree`とあり、その下に任意の名前を冠した複数のテーマ（tree, blueegg, inline...）が事前定義されています。各テーマはdefaultにセットすることで呼ぶことができます（ここではtreeがセットされています）。default値を空にするとここで最初に示したグラフが出力されます。

各テーマ内ではハッシュ形式で属性値を定義します。既定のテーマはあまり練られていません。必要に応じて、適宜修正するかオリジナルを定義してください。

また、`dot`コマンドは--theme(または-t)オプションを取ることができ、ここにテーマ名をセットして呼ぶこともできます。

## Themes

さあ、やっと楽しい時間がやってまいりました。既定のテーマを順番に呼び出して出力を見てみます。

### tree

上にも示しましたが改めて。設定はこうです。

{% highlight yaml %}
tree:
  global:
    rankdir: LR
    splines: ortho
  dir_shape: diamond
{% endhighlight %}

実行します。

{% highlight bash %}
% dir_friend dot tinytool -t tree
{% endhighlight %}

出力です。

{% lightbox  2013/10/theme_tree2.png, title, alt noshadow %}
（クリックで拡大）


### blueegg

設定。

{% highlight yaml %}

blueegg:
  colorscheme: blues
  edges:
    color: lightblue
  nodes:
    shape: egg
{% endhighlight %}

実行。

{% highlight bash %}
% dir_friend dot tinytool -t blueegg
{% endhighlight %}

出力。

{% lightbox  2013/10/theme_tree4.png, title, alt noshadow %}
（クリックで拡大）


### inline

設定。

{% highlight yaml %}
inline:
  layout: osage
  colorscheme: greens
  nodes:
    shape: box
  edges:
    color: gold
{% endhighlight %}

実行。

{% highlight bash %}
% dir_friend dot tinytool -t inline
{% endhighlight %}

出力。

{% lightbox  2013/10/theme_tree5.png, title, alt noshadow %}
（クリックで拡大）

### closeup

設定。

{% highlight yaml %}
closeup:
  layout: neato
  colorscheme: purd
  nodes:
    shape: polygon

{% endhighlight %}

実行。

{% highlight bash %}
% dir_friend dot tinytool -t closeup
{% endhighlight %}

出力。

{% lightbox  2013/10/theme_tree6.png, title, alt noshadow %}
（クリックで拡大）


ファイル数が少ないのでclose up（密集）感が少ないので、もっと大きいプロジェクトでやってみます。

{% highlight bash %}
 dir_friend dot sinatra-1.4.4 -t closeup
{% endhighlight %}

{% lightbox  2013/10/theme_tree10.png, title, alt noshadow %}
（クリックで拡大）

ノードの重なりが気になる場合はoverlapをfalseにすればいいですね。

{% highlight bash %}
% dir_friend dot sinatra-1.4.4 -t closeup -g overlap:false
{% endhighlight %}

{% lightbox  2013/10/theme_tree11.png, title, alt noshadow %}
（クリックで拡大）

### flower

設定。

{% highlight yaml %}
flower:
  layout: circo
  colorscheme: rdylgn
  nodes:
    shape: doublecircle

{% endhighlight %}

実行。

{% highlight bash %}
% dir_friend dot tinytool -t flower
{% endhighlight %}

出力。

{% lightbox  2013/10/theme_tree7.png, title, alt noshadow %}
（クリックで拡大）

ちょっと花ぽくないですか。

### rigid

設定。

{% highlight yaml %}
rigid:
  layout: sfdp
  colorscheme: greys
  nodes:
    shape: doubleoctagon

{% endhighlight %}

実行。

{% highlight bash %}
% dir_friend dot tinytool -t rigid
{% endhighlight %}

出力。

{% lightbox  2013/10/theme_tree8.png, title, alt noshadow %}
（クリックで拡大）


### star

最後に`star`です。これは強烈ですよ...。

設定。
{% highlight yaml %}
star:
  layout: dot
  colorscheme: set310
  global:
    bgcolor: midnightblue
    splines: curved
  edges:
    color: snow
    arrowhead: none
  nodes:
    shape: star
{% endhighlight %}

実行。

{% highlight bash %}
% dir_friend dot tinytool -t star
{% endhighlight %}

出力です。

{% lightbox  2013/10/theme_tree9.png, title, alt noshadow %}
（クリックで拡大）


何これ？

---

まあ、世の中にディレクトリ構造を視覚化するだけでウキウキできる人が、どれくらいいるのかはわかりませんが、そういう人は是非とも`DirFriend`で楽しんでください。


Enjoy!


---

<p style='color:red'>=== Ruby関連電子書籍100円で好評発売中！ ===</p>

[M'ELBORNE BOOKS]({{ BASE_PATH }}/books/ "M'ELBORNE BOOKS")

<a href="{{ BASE_PATH }}/books/">
  <img src="/assets/images/2013/02/ruby_object_cover.png" alt="ruby_object" style="width:200px" />
</a>
<a href="{{ BASE_PATH }}/books/">
  <img src="/assets/images/2013/04/ruby_tutorial_cover.png" alt="ruby_tutorial" style="width:200px" />
</a>
<a href="{{ BASE_PATH }}/books/">
  <img src="/assets/images/2013/03/ruby_trivia_cover.png" alt="ruby_trivia" style="width:200px" />
</a>


