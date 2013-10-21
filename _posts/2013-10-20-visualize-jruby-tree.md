---
layout: post
title: "JRubyユニバースも視覚化してみる"
description: ""
category: 
tags: 
date: 2013-10-20
published: true
---
{% include JB/setup %}


前の前の記事でCRubyのクラスツリーをGraphvizを使って視覚化した。

> [RubyユニバースをGraphvizで視覚化する]({{ BASE_PATH }}/2013/10/18/visualize-ruby-tree-with-graphviz/ "RubyユニバースをGraphvizで視覚化する")

前の記事でRubiniusのクラスツリーをGraphvizを使って視覚化した。

> [Rubiniusユニバースも視覚化してみる]({{ BASE_PATH }}/2013/10/19/visualize-rubinius-tree/ "Rubiniusユニバースも視覚化してみる")

そうしたら今度はJRubyでどうなるのかも見てみたくなったのでJRubyをインストールしてやってみることにした。

{% highlight bash %}
% rbenv install jruby-1.7.4
% rbenv local jruby-1.7.4
% ruby -v
jruby 1.7.4 (1.9.3p392) 2013-05-16 2390d3b on Java HotSpot(TM) 64-Bit Server VM 1.6.0_51-b11-456-11M4508 [darwin-x86_64]
% gem install gviz
{% endhighlight %}


例外クラスとモジュールを除いたRubyのクラスツリーをJRubyで書いてみる。

{% highlight ruby %}
 # ruby_tree.rb
 require 'gviz'
 
 classes = ObjectSpace.each_object(Class)
                      .reject { |k| "#{k}".match /Gem|Thor|Gviz/ }
 
 Graph do
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
 end
{% endhighlight %}


ファイルを実行して生成されたpngを開いてみる。

{% highlight bash %}
% ruby ruby_tree.rb
% open ruby_tree.png
{% endhighlight %}


<br/>


{% lightbox  2013/10/ruby_tree11.png, ruby_tree, alt noshadow %}
（クリックで拡大）

拡大すると`JavaProxy`というクラスからJavaの世界へつながるような構造が見える。


---

(追記：2013-10-21) Rubyのソースディレクトリも視覚化しました。

[Rubyのソースディレクトリも視覚化してみる]({{ BASE_PATH }}/2013/10/21/visualize-ruby-files-with-graphviz/ "Rubyのソースディレクトリも視覚化してみる")


---

関連記事：

[RubyユニバースをGraphvizで視覚化する]({{ BASE_PATH }}/2013/10/18/visualize-ruby-tree-with-graphviz/ "RubyユニバースをGraphvizで視覚化する")

[Rubiniusユニバースも視覚化してみる]({{ BASE_PATH }}/2013/10/19/visualize-rubinius-tree/ "Rubiniusユニバースも視覚化してみる")

[Yet Another Ruby Graphviz Interfaceを作ったからみんなで大量のグラフを作って遊ぼうよ！]({{ BASE_PATH }}/2012/09/25/ruby-plus-graphviz-should-eql-gviz/ "Yet Another Ruby Graphviz Interfaceを作ったからみんなで大量のグラフを作って遊ぼうよ！")

