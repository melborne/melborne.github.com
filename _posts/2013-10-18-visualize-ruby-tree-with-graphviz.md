---
layout: post
title: "RubyユニバースをGraphvizで視覚化する"
description: ""
category: 
tags: 
date: 2013-10-18
published: true
---
{% include JB/setup %}

今日Rubyのクラスツリーを手書きでグラフ化している記事を見かけた。

> [A diagram of the Ruby Core object model - Jerome's Adventures in Rubyland](http://jeromedalbert.com/a-diagram-of-the-ruby-core-object-model/?utm_source=rubyweekly&utm_medium=email "A diagram of the Ruby Core object model - Jerome's Adventures in Rubyland")

これを見てそういえばGraphvizのRubyによるラッパーを書いたのに未だRubyのクラスツリーをグラフ化していないことに気付いた。

> [melborne/Gviz](https://github.com/melborne/Gviz "melborne/Gviz")
> 
> [gviz | RubyGems.org | your community gem host](https://rubygems.org/gems/gviz "gviz | RubyGems.org | your community gem host")

そしてRubyをグラフ化するならやっぱりRuby自身に書いてもらうのが一番だと思った。彼女も20才になったことだし。


早々`gem install gviz`でgvizを入れて次のようなコードを書く。

{% highlight ruby %}
# ruby_tree.rb
classes = ObjectSpace.each_object(Class)
                     .reject { |k| "#{k}".match /Gem|Thor|Gviz/ }

classes.each do |klass|
  tree = klass.ancestors.select { |anc| anc.is_a? Class }.reverse
  tree.each_cons(2) do |a, b|
    a_id, b_id = [a, b].map(&:to_id)
    route a_id => b_id
    node a_id, label:a
    node b_id, label:b
  end
end

save :ruby_tree, :png
{% endhighlight %}

`gviz build`コマンドを叩いて、生成されたpngを開く。

{% highlight bash %}
% gviz build ruby_tree.rb
% open ruby_tree.png
{% endhighlight %}

<br/>

{% lightbox  2013/10/ruby_tree1.png, rubyTree, alt noshadow %}
（クリックで拡大）

収集がつかないので例外クラスを外してみる。

{% highlight ruby %}
classes = ObjectSpace.each_object(Class)
                     .reject { |k| "#{k}".match /Gem|Thor|Gviz/ }

classes.each do |klass|
  tree = klass.ancestors.select { |anc| anc.is_a? Class }.reverse
+ next if tree.include?(Exception) && tree[-1] != Exception
  tree.each_cons(2) do |a, b|
    a_id, b_id = [a, b].map(&:to_id)
    route a_id => b_id
    node a_id, label:a
    node b_id, label:b
  end
end

save :ruby_tree, :png
{% endhighlight %}

<br/>

{% lightbox  2013/10/ruby_tree2.png, rubyTree, alt noshadow %}
（クリックで拡大）

以前として収集がつかないのでレイアウトを変えてみる。

{% highlight ruby %}
 classes = ObjectSpace.each_object(Class)
                     .reject { |k| "#{k}".match /Gem|Thor|Gviz/ }

+global layout:'fdp'

 classes.each do |klass|
   tree = klass.ancestors.select { |anc| anc.is_a? Class }.reverse
   next if tree.include?(Exception) && tree[-1] != Exception
   tree.each_cons(2) do |a, b|
     a_id, b_id = [a, b].map(&:to_id)
     route a_id => b_id
     node a_id, label:a
     node b_id, label:b
   end
 end
 
 save :ruby_tree, :png
{% endhighlight %}

<br/>

{% lightbox  2013/10/ruby_tree3.png, rubyTree, alt noshadow %}
（クリックで拡大）

BasicObjectからDelegatorが伸びていることに感心を示しつつルート（BasicObject）からの距離に応じて異なる色での着色を考える。

{% highlight ruby %}
 classes = ObjectSpace.each_object(Class)
                      .reject { |k| "#{k}".match /Gem|Thor|Gviz/ }
 
 global layout:'fdp'
 nodes style:'filled', colorscheme:'purd6'
 
 classes.each do |klass|
   tree = klass.ancestors.select { |anc| anc.is_a? Class }.reverse
   next if tree.include?(Exception) && tree[-1] != Exception
+  tree = tree.map.with_index { |k, i| [k, i] }
   tree.each_cons(2) do |(a, ai), (b, bi)|
     a_id, b_id = [a, b].map(&:to_id)
     route a_id => b_id
+    node a_id, label:a, color:6-ai, fillcolor:6-ai
+    node b_id, label:b, color:6-bi, fillcolor:6-bi
   end
 end
 
 save :ruby_tree, :png
{% endhighlight %}


{% lightbox  2013/10/ruby_tree4.png, rubyTree, alt noshadow %}
（クリックで拡大）


ここまでくるとモジュールを挟みたくなる。

{% highlight ruby %}
 classes = ObjectSpace.each_object(Class)
                      .reject { |k| "#{k}".match /Gem|Thor|Gviz/ }
 
 global layout:'fdp'
 nodes style:'filled', colorscheme:'purd6'
 
 classes.each do |klass|
+  tree, mods = klass.ancestors.group_by { |anc| anc.is_a? Class }
+                    .map { |_, k| k.reverse }
   next if tree.include?(Exception) && tree[-1] != Exception
   tree = tree.map.with_index { |k, i| [k, i] }
   tree.each_cons(2) do |(a, ai), (b, bi)|
     a_id, b_id = [a, b].map(&:to_id)
     route a_id => b_id
     node a_id, label:a, color:6-ai, fillcolor:6-ai
     node b_id, label:b, color:6-bi, fillcolor:6-bi
   end
 
+  mods = [] unless mods
+  mods.each do |mod|
+    mod_id = mod.to_id
+    route mod_id => klass.to_id
+    node mod_id, label:mod, shape:'box'
+  end
 end
 
 save :ruby_tree, :png
{% endhighlight %}


{% lightbox  2013/10/ruby_tree5.png, rubyTree, alt noshadow %}
（クリックで拡大）

もうこうなったら例外クラスも入れてみる。

{% highlight ruby %}
classes = ObjectSpace.each_object(Class)
                     .reject { |k| "#{k}".match /Gem|Thor|Gviz/ }

global layout:'fdp'
nodes style:'filled', colorscheme:'purd6'
# edges color:'maroon'

classes.each do |klass|
  tree, mods = klass.ancestors.group_by { |anc| anc.is_a? Class }
                    .map { |_, k| k.reverse }
- next if tree.include?(Exception) && tree[-1] != Exception
  tree = tree.map.with_index { |k, i| [k, i] }
  tree.each_cons(2) do |(a, ai), (b, bi)|
    a_id, b_id = [a, b].map(&:to_id)
    route a_id => b_id
    node a_id, label:a, color:6-ai, fillcolor:6-ai
    node b_id, label:b, color:6-bi, fillcolor:6-bi
  end

  mods = [] unless mods
  mods.each do |mod|
    mod_id = mod.to_id
    route mod_id => klass.to_id
    node mod_id, label:mod, shape:'box'
  end

end

save :ruby_tree, :png
{% endhighlight %}

ギャッ！


{% lightbox  2013/10/ruby_tree6.png, rubyTree, alt noshadow %}
（クリックで拡大）

誰がこんな複雑な宇宙作ったんだ。

<br/>

モジュールは入れるべきではなかった。

{% highlight ruby %}
classes = ObjectSpace.each_object(Class)
                     .reject { |k| "#{k}".match /Gem|Thor|Gviz/ }

global layout:'fdp'
nodes style:'filled', colorscheme:'purd6'
# edges color:'maroon'

classes.each do |klass|
  tree, mods = klass.ancestors.group_by { |anc| anc.is_a? Class }
                    .map { |_, k| k.reverse }
  # next if tree.include?(Exception) && tree[-1] != Exception
  tree = tree.map.with_index { |k, i| [k, i] }
  tree.each_cons(2) do |(a, ai), (b, bi)|
    a_id, b_id = [a, b].map(&:to_id)
    route a_id => b_id
    node a_id, label:a, color:6-ai, fillcolor:6-ai
    node b_id, label:b, color:6-bi, fillcolor:6-bi
  end

- mods = [] unless mods
- mods.each do |mod|
-   mod_id = mod.to_id
-   route mod_id => klass.to_id
-   node mod_id, label:mod, shape:'box'
- end
end

save :ruby_tree, :png
{% endhighlight %}


{% lightbox  2013/10/ruby_tree7.png, rubyTree, alt noshadow %}
（クリックで拡大）

綺麗になったね、Ruby。


{% gist 7039236 %}


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

