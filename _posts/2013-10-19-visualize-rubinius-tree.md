---
layout: post
title: "Rubiniusユニバースも視覚化してみる"
description: ""
category: 
tags: 
date: 2013-10-19
published: true
---
{% include JB/setup %}

前の記事でRubyのクラスツリーをGraphvizを使って視覚化した。

> [RubyユニバースをGraphvizで視覚化する]({{ BASE_PATH }}/2013/10/18/visualize-ruby-tree-with-graphviz/ "RubyユニバースをGraphvizで視覚化する")

そうしたら今度はRubiniusでどうなるのかも見てみたくなったので以下の辺りを参考にRubiniusをインストールしてやってみることにした。

> [Ruby - Rubinius 2.0.0-dev をインストールする with rbenv - Qiita [キータ]](http://qiita.com/taiki45/items/b90002c72352ab382183 "Ruby - Rubinius 2.0.0-dev をインストールする with rbenv - Qiita [キータ]")
> 
> [Installing Rubinius 2.0.0-dev with rbenv](https://gist.github.com/amateurhuman/2005745 "Installing Rubinius 2.0.0-dev with rbenv")

例外クラスとモジュールを除いたRubyのクラスツリーをRubiniusで書いてみる。

どういうわけか`gviz`コマンドが使えるようにならないのでrubyで実行できるよう修正する。前回のコードをGraphのブロックで囲えばいい(必要色数が増えたのでcolorschemeをpurd6からpurd7に変えている）。

{% highlight ruby %}
 # ruby_tree.rb
 require 'gviz'
 
 classes = ObjectSpace.each_object(Class)
                      .reject { |k| "#{k}".match /Gem|Thor|Gviz/ }
 
+Graph do
   global layout:'fdp'
   nodes style:'filled', colorscheme:'purd7'
 
   classes.each do |klass|
     tree, mods = klass.ancestors.group_by { |anc| anc.is_a? Class }
                       .map { |_, k| k.reverse }
     next if tree.include?(Exception) && tree[-1] != Exception
     tree = tree.map.with_index { |k, i| [k, i] }
     tree.each_cons(2) do |(a, ai), (b, bi)|
       a_id, b_id = [a, b].map(&:to_id)
       route a_id => b_id
       node a_id, label:a, color:7-ai, fillcolor:7-ai
       node b_id, label:b, color:7-bi, fillcolor:7-bi
     end
   end
 
   save :ruby_tree, :png
+end
{% endhighlight %}


Rubyを切り替えてヴァージョンを確認して実行してみる。

{% highlight bash %}
% rbenv local rbx-2.0.0
% ruby -v
rubinius 2.1.1n292 (2.1.0 9f9da9ed 2013-10-19 JI) [x86_64-darwin12.5.0]
% ruby ruby_tree.rb
{% endhighlight %}

うわっ。

<br/>


{% lightbox  2013/10/ruby_tree8.png, ruby_tree, alt noshadow %}
（クリックで拡大）

クラスの数がなんかぜんぜん違う。一部を拡大して見てみる。

{% lightbox  2013/10/ruby_tree9.png, ruby_tree, alt noshadow %}
（クリックで拡大）

おびただしい数のRubinius関連クラスが見える。これらはRubyの組み込みクラスを補完するクラス群なのだろう。

> 参考：[My first impression of Rubinius internals - Pat Shaughnessy](http://patshaughnessy.net/2012/1/25/my-first-impression-of-rubinius-internals "My first impression of Rubinius internals - Pat Shaughnessy")

Rubinius関連クラス群を除外して描画してみる。

{% highlight ruby %}
 require 'gviz'
 
 classes = ObjectSpace.each_object(Class)
+                     .reject { |k| "#{k}".match /Gem|Thor|Gviz|Rubinius/ }
 
 Graph do
   global layout:'fdp'
   nodes style:'filled', colorscheme:'purd6'
 
   classes.each do |klass|
     tree, mods = klass.ancestors.group_by { |anc| anc.is_a? Class }
                       .map { |_, k| k.reverse }
     next if tree.include?(Exception) && tree[-1] != Exception
     tree = tree.map.with_index { |k, i| [k, i] }
     tree.each_cons(2) do |(a, ai), (b, bi)|
       a_id, b_id = [a, b].map(&:to_id)
       route a_id => b_id
       node a_id, label:a, color:6-ai, fillcolor:6-ai
       node b_id, label:b, color:6-bi, fillcolor:6-bi
     end
   end
 
   save :ruby_tree, :png
 end
{% endhighlight %}

{% lightbox  2013/10/ruby_tree10.png, ruby_tree, alt noshadow %}
（クリックで拡大）

大分スッキリした。これでCRubyにおけるクラスツリーに近づいてきた。対応するCRubyのグラフを貼って見比べてみる。

<br/>

{% lightbox  2013/10/ruby_tree4.png, ruby_tree, alt noshadow %}
（クリックで拡大）

RubiniusにはCRubyにはないクラスが依然含まれていて`Continuation`（継続）なんてものも見える。Rubiniusは単一実装で1.8系と1.9系をカバーするようだからそうなんだろう（インストール時に--enable-versionという設定項目がある）。

> 参考：[Inside the Rubinius 2.0 Preview Release - Rubinius](http://rubini.us/2011/06/07/inside-rubinius-20-preview/ "Inside the Rubinius 2.0 Preview Release - Rubinius")

---

関連記事：

[Rubiniusユニバースも視覚化してみる]({{ BASE_PATH }}/2013/10/19/visualize-rubinius-tree/ "Rubiniusユニバースも視覚化してみる")

[JRubyユニバースも視覚化してみる]({{ BASE_PATH }}/2013/10/20/visualize-jruby-tree/ "JRubyユニバースも視覚化してみる")

[Rubyのソースディレクトリも視覚化してみる]({{ BASE_PATH }}/2013/10/21/visualize-ruby-files-with-graphviz/ "Rubyのソースディレクトリも視覚化してみる")

[Yet Another Ruby Graphviz Interfaceを作ったからみんなで大量のグラフを作って遊ぼうよ！]({{ BASE_PATH }}/2012/09/25/ruby-plus-graphviz-should-eql-gviz/ "Yet Another Ruby Graphviz Interfaceを作ったからみんなで大量のグラフを作って遊ぼうよ！")


