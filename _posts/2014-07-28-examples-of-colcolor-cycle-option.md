---
layout: post
title: "カラム指向ターミナルカラーライブラリ「colcolor」にcyclicオプションを付けました！"
description: ""
category: 
tags: 
date: 2014-07-28
published: true
---
{% include JB/setup %}

先日、カラム指向ターミナルカラーライブラリ「colcolor」というのを公開しまして。

> [Yet Another Terminal Color for Ruby: Colcolorの紹介]({{ BASE_PATH }}/2014/07/14/yet-another-terminal-color-for-ruby/ "Yet Another Terminal Color for Ruby: Colcolorの紹介")
>
> [colcolor](https://rubygems.org/gems/colcolor "colcolor")

colcolorはStringクラスに`colco`というメソッドを挿します。colcoでは引数として複数の色名を受け取って単語区切りで文字を彩色します。こんな感じです。

{% highlight ruby %}
require "colcolor"

DATA.each_line.with_index do |line, i|
  puts line.colco(:green, :yellow, :blue, :blue)
  puts "-".colco(:red) * line.size if i.zero?
end

__END__
lang year designer
Ruby 1993 Yukihiro Matsumoto
Lisp 1958 John McCarthy
C++ 1983 Bjarne Stroustrup
{% endhighlight %}

ターミナル出力です。

![colcolor noshadow]({{ BASE_PATH }}/assets/images/2014/07/colcolor_cycle1.png)

## cyclicオプション

で、この度`cyclic`オプションをcolcoに渡せるようにしたので、紹介します。

colcolorでは渡した色数が単語数に対して不足するとき、残りの単語は色付けされないのですが、このcyclicオプションを`true`にセットすると、与えられた色を残りの単語に対しても繰り返し適用するようになります。こんな感じです。

{% highlight ruby %}
require "colcolor"

text =<<-EOS
A dynamic, open source programming language
with a focus on simplicity and productivity.
It has an elegant syntax that is natural to
read and easy to write.
EOS

puts text.colco(:red, :green, :blue, :yellow, cyclic:true)
{% endhighlight %}

ターミナル出力です。

![colcolor noshadow]({{ BASE_PATH }}/assets/images/2014/07/colcolor_cycle2.png)

赤、緑、青、黄が単語に対して繰り返し適用されている様子がわかります。

`regexp`オプションと組み合わせると、少し面白いこともできます。regexpに`/./`を渡して色区切りを文字ベースにしてみます。

{% highlight ruby %}
require "colcolor"

text =<<-EOS
A dynamic, open source programming language
with a focus on simplicity and productivity.
It has an elegant syntax that is natural to
read and easy to write.
EOS

puts text.colco(:red, :green, :blue, :yellow, cyclic:true, regexp:/./)
{% endhighlight %}

ターミナル出力です。

![colcolor noshadow]({{ BASE_PATH }}/assets/images/2014/07/colcolor_cycle3.png)

こんなこともできます。

{% highlight ruby %}
require "colcolor"

line = " " * 50

colors = %i(bg_red bg_yellow)

10.times do
  puts line.colco(*colors.rotate!, cyclic:true, regexp:/../)
end
{% endhighlight %}

ターミナル出力です。

![colcolor noshadow]({{ BASE_PATH }}/assets/images/2014/07/colcolor_cycle4.png)

`colcolor`をどうぞよろしく！

> [Yet Another Terminal Color for Ruby: Colcolorの紹介]({{ BASE_PATH }}/2014/07/14/yet-another-terminal-color-for-ruby/ "Yet Another Terminal Color for Ruby: Colcolorの紹介")
>
> [colcolor](https://rubygems.org/gems/colcolor "colcolor")
>
>[melborne/colcolor](https://github.com/melborne/colcolor "melborne/colcolor")

---

(追記：2014-7-30) オプション名を"cycle"から"cyclic"に変更しました（version 0.0.5）。
