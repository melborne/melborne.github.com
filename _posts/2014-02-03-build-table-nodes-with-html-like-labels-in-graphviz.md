---
layout: post
title: "Graphvizで表そして気になる都知事選2014のゆくえ"
description: ""
category: 
tags: 
date: 2014-02-03
published: true
---
{% include JB/setup %}


(追記：2014-3-3) Gvizについてのまとめ頁を作りました。

> [Gvizの目次 - Rubyの世界からGraphvizの世界にこんにちは！]({{ BASE_PATH }}/2014/02/27/gviz-posts/ "Gvizの目次 - Rubyの世界からGraphvizの世界にこんにちは！")

---

GraphvizのRubyラッパーである[gviz](https://rubygems.org/gems/gviz "gviz")に対して、@otahiさんからPull Requestを頂きました。

> [Enable HTML like label in attributes by otahi · Pull Request #1 · melborne/Gviz](https://github.com/melborne/Gviz/pull/1 "Enable HTML like label in attributes by otahi · Pull Request #1 · melborne/Gviz")

GraphvizのラベルにHTML風の記法が使えるなんて、知らなかったよ！

@otahiさんに感謝しつつ早々本体に取り込ませて頂き、その対応版v0.3.3をリリースしました。

> [gviz \| RubyGems.org \| your community gem host](https://rubygems.org/gems/gviz "gviz \| RubyGems.org \| your community gem host")

## 表型ノード

HTML風ラベル（HTML-like Labels）は、`<TABLE>`タグを使って表のようなノードを作ることが主たる用途になります。

> [Node Shapes \| Graphviz - Graph Visualization Software](http://www.graphviz.org/content/node-shapes#html "Node Shapes \| Graphviz - Graph Visualization Software")

実はごく簡単な表型ノードは、`Record`形(またはMrecord)で`{}`と`|`を使った特殊な記法でラベルを書くことで実現できます。

{% highlight ruby %}
#graph.ru
node :table, shape:"Mrecord", label:"{Ruby | {String|Array|Hash}}"

save :record
{% endhighlight %}

{% highlight bash %}
% gviz build
{% endhighlight %}

![Alt title noshadow]({{ BASE_PATH }}/assets/images/2014/02/html_label1.png)

しかしこの記法ではリッチな表を作ることはできません。

## サンプル

そこでHTML風記法の出番です。

ヒアドキュメントを使ってこんな風に書けば...

{% gist 8767581 graph.ru %}

こんなノードが作れます。

![Alt title noshadow]({{ BASE_PATH }}/assets/images/2014/02/html_label2.png)


こんな風に書けば...

{% gist 8767581 graph2.ru %}

こんなグラフが作れます（[出典](http://www.graphviz.org/content/node-shapes#html)）。

![Alt title noshadow]({{ BASE_PATH }}/assets/images/2014/02/html_label3.png)

こんな風に書けば...

{% gist 8767581 election.rb %}

{% highlight bash %}
% ruby election.rb
{% endhighlight %}


> [2014年東京都知事選挙 - Wikipedia](http://ja.wikipedia.org/wiki/2014%E5%B9%B4%E6%9D%B1%E4%BA%AC%E9%83%BD%E7%9F%A5%E4%BA%8B%E9%81%B8%E6%8C%99 "2014年東京都知事選挙 - Wikipedia")

こんなグラフが作れます。

{% lightbox  2014/02/html_label4.png, election, alt noshadow %}
（クリックで拡大）

誰が勝つんですかねぇ。

---

> [gviz \| RubyGems.org \| your community gem host](https://rubygems.org/gems/gviz "gviz \| RubyGems.org \| your community gem host")
> 
> [melborne/Gviz](https://github.com/melborne/Gviz "melborne/Gviz")

