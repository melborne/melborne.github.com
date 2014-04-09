---
layout: post
title: "togglateをHTMLタグに暫定対応しましたのお知らせ"
description: ""
category: 
tags: 
date: 2014-04-09
published: true
---
{% include JB/setup %}

翻訳作成を支援する「[togglate](https://rubygems.org/gems/togglate "togglate")」のversion0.1.5をリリースしました。

togglateはMarkdownで書かれたオリジナルテキストから原文をそのセンテンスごとに抜き出して、翻訳のベースとなるテキストにhtmlのコメントでラップして埋め込むものです。

MarkdownテキストにはHTMLタグをそのまま記述できますが、togglateではこれを上手くラップできませんでした。本バージョンにより「**暫定的**」ですがこれに対応しました。

「**暫定的**」というのは、「最外郭のタグ以外がインデントされた」HTMLブロックのみが対象という意味です。つまり、

{% highlight html %}
<div>
  <table>
    <tr><th>Header</th></tr>
  
    <tr><td>Data</td></tr>
  </table>
</div>
{% endhighlight %}

は上手くラップされますが、

{% highlight html %}
<div>
<table>
  <tr><th>Header</th></tr>

  <tr><td>Data</td></tr>
</table>
</div>
{% endhighlight %}

は正しくラップされません。このような場合はHTMLタグを調整してからtogglateを使用するなどしてください。

完全対応のためにはtogglateのパース方式を大きく変更する必要があるので、その実装についてはいまのところ未定です。ご了承くださいm(__)m

