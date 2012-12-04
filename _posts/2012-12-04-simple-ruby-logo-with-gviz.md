---
layout: post
title: "GraphvizでRubyのロゴは描けますか？"
description: ""
category: 
tags: 
date: 2012-12-04
published: true
---
{% include JB/setup %}
ええ、まあなんとか。

ここではGraphvizのRubyラッパー「[Gviz](https://rubygems.org/gems/gviz 'gviz | RubyGems.org | your community gem host')」を使います。

まずはgraph.ruに`route`を使ってノードとエッジの繋がりを書きます。

{% highlight ruby %}
route :a1 => [:a2, :b1, :b2], :a2 => [:a3, :b2, :b3], :a3 => [:b3, :b4]
route :b1 => :b2, :b2 => :b3, :b3 => :b4
route [:b1, :b2, :b3, :b4] => :c

save :ruby
{% endhighlight %}

`gviz`コマンドでグラフを生成して、ファイルをオープンします。

{% highlight bash %}
% gviz
% open ruby.dot
{% endhighlight %}

![rubylogo noshadow]({{ site.url }}/assets/images/2012/rubylogo1.png)


`rank`を使ってノードの概略の配置を決めます。

{% highlight ruby %}
route :a1 => [:a2, :b1, :b2], :a2 => [:a3, :b2, :b3], :a3 => [:b3, :b4]
route :b1 => :b2, :b2 => :b3, :b3 => :b4
route [:b1, :b2, :b3, :b4] => :c

+ rank :same, :a1, :a2, :a3
+ rank :same, :b1, :b2, :b3, :b4

save :ruby
{% endhighlight %}

再度`gviz`します。

![rubylogo noshadow]({{ site.url }}/assets/images/2012/rubylogo2.png)

ノードのshapeをpointとし、エッジの矢印を消します。

{% highlight ruby %}
route :a1 => [:a2, :b1, :b2], :a2 => [:a3, :b2, :b3], :a3 => [:b3, :b4]
route :b1 => :b2, :b2 => :b3, :b3 => :b4
route [:b1, :b2, :b3, :b4] => :c

rank :same, :a1, :a2, :a3
rank :same, :b1, :b2, :b3, :b4

+ nodes shape:'point'
+ edges arrowhead:'none'

save :ruby
{% endhighlight %}

再度`gviz`します。

![rubylogo noshadow]({{ site.url }}/assets/images/2012/rubylogo3.png)


エッジ最小長さを規定して形を調整します。

{% highlight ruby %}
route :a1 => [:a2, :b1, :b2], :a2 => [:a3, :b2, :b3], :a3 => [:b3, :b4]
route :b1 => :b2, :b2 => :b3, :b3 => :b4
route [:b1, :b2, :b3, :b4] => :c

rank :same, :a1, :a2, :a3
rank :same, :b1, :b2, :b3, :b4

nodes shape:'point'
edges arrowhead:'none'

+ [:b1_b2, :b2_b3, :b3_b4].each { |e| edge e, minlen:4 }
+ edge '*_c', minlen:3

save :ruby
{% endhighlight %}


![rubylogo noshadow]({{ site.url }}/assets/images/2012/rubylogo4.png)


色と線の太さを調整します。

{% highlight ruby %}
route :a1 => [:a2, :b1, :b2], :a2 => [:a3, :b2, :b3], :a3 => [:b3, :b4]
route :b1 => :b2, :b2 => :b3, :b3 => :b4
route [:b1, :b2, :b3, :b4] => :c

rank :same, :a1, :a2, :a3
rank :same, :b1, :b2, :b3, :b4

+ color = '#7A2121'
+ nodes shape:'point', color:color
+ edges arrowhead:'none', color:color, penwidth:6

[:b1_b2, :b2_b3, :b3_b4].each { |e| edge e, minlen:4 }
edge '*_c', minlen:3

save :ruby
{% endhighlight %}

![rubylogo noshadow]({{ site.url }}/assets/images/2012/rubylogo5.png)


Rubyの文字も入れましょう。

{% highlight ruby %}
route :a1 => [:a2, :b1, :b2], :a2 => [:a3, :b2, :b3], :a3 => [:b3, :b4]
route :b1 => :b2, :b2 => :b3, :b3 => :b4
route [:b1, :b2, :b3, :b4] => :c

rank :same, :a1, :a2, :a3
+ rank :same, :b1, :b2, :b3, :b4, :Ruby

color = '#7A2121'
nodes shape:'point', color:color
edges arrowhead:'none', color:color, penwidth:6

[:b1_b2, :b2_b3, :b3_b4].each { |e| edge e, minlen:4 }
edge '*_c', minlen:3

+ node :Ruby, shape:'none', fontsize:100

save :ruby
{% endhighlight %}


![rubylogo noshadow]({{ site.url }}/assets/images/2012/rubylogo6.png)

ちょっとロゴの形が変わっちゃいましたね。調整します。

{% highlight ruby %}
route :a1 => [:a2, :b1, :b2], :a2 => [:a3, :b2, :b3], :a3 => [:b3, :b4]
route :b1 => :b2, :b2 => :b3, :b3 => :b4
route [:b1, :b2, :b3, :b4] => :c

rank :same, :a1, :a2, :a3
rank :same, :b1, :b2, :b3, :b4, :Ruby

color = '#7A2121'
nodes shape:'point', color:color
+ edges arrowhead:'none', color:color, penwidth:9

+ [:b1_b2, :b2_b3, :b3_b4].each { |e| edge e, minlen:7 }
+ edge '*_c', minlen:4

node :Ruby, shape:'none', fontsize:100

save :ruby
{% endhighlight %}

![rubylogo noshadow]({{ site.url }}/assets/images/2012/rubylogo7.png)

完成です！

って、やっぱり今ひとつでしたね...

---

{{ 4839943338 | amazon_medium_image }}
{{ 4839943338 | amazon_link }} by {{ 4839943338 | amazon_authors }}



