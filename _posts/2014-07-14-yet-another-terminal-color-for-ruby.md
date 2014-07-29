---
layout: post
title: "Yet Another Terminal Color for Ruby: Colcolorの紹介"
description: ""
category: 
tags: 
date: 2014-07-14
published: true
---
{% include JB/setup %}

巷にはターミナル文字のカラー化を楽にするライブラリが溢れています。僕も以前にその幾つかを紹介した記事を書きました。

> [RubyでANSIカラーシーケンスを学ぼう！]({{ BASE_PATH }}/2010/11/07/Ruby-ANSI/ "RubyでANSIカラーシーケンスを学ぼう！")

にも拘わらずみんな、人の作ったライブラリが自分のテイストに合わないのか、自分用に、しかし他と似たようなものをまた作って、このリストを更に長くしていくという傾向があるようです。[RubyGems.org](https://rubygems.org/search?utf8=%E2%9C%93&query=color "RubyGems.org")で`color`を検索してみてください。僕が言っていることが冗談ではないということが分かるでしょう。

これだけ大量のカラー化ライブラリがあるとどれを選ぶべきか皆目わからず、人気どころを２、３試してみてそれらが合わなかったら、他を探すより自分で作ったほうが早い、となるのも頷けます。


え〜、それで、ちょっと言いづらいのですが...。

ご多分に漏れず...。

<br/>

「Colcolor」というgemを作りましたよ！> まじか。

> [colcolor](https://rubygems.org/gems/colcolor "colcolor")
> 
> [melborne/colcolor](https://github.com/melborne/colcolor "melborne/colcolor")

## Colcolorの特徴

殆どのカラーライブラリは、Stringにカラー用のメソッドを挿して、そのメソッドで文字列の前後にエスケープシーケンスを挿入します。

{% highlight ruby %}
"Charlie".red # => "\e[31mChalie\e[0m"
{% endhighlight %}

`colcolor`もその点は他のライブラリと同じで、Stringに`colco`というインスタンスメソッドを追加します。

{% highlight ruby %}
"Charlie".colco(:red) # => "\e[31mChalie\e[0m"
{% endhighlight %}

`colcolor`が特徴的なのは、他のライブラリが行指向のものであるのに対して、列（カラム）指向である点です。つまり一行におけるホワイトスペースで区切られたカラムを認識し、それ毎に異なるカラーを適用できるのです。

{% highlight ruby %}
"Charlie 21 programmer".colco(:red, :yellow, :cyan) # => "\e[31mCharlie\e[0m \e[33m21\e[0m \e[36mprogrammer\e[0m"
{% endhighlight %}

例えば、タブ区切りのリストにおいて、そのカラムごとに色を変えたい場合は、次のように簡単にできます。

{% highlight ruby %}
require "colcolor"

list = <<-EOS
Charlie\t21\tprogrammer
Bill\t43\tdoctor
Liz\t18\tstudent
EOS

list.each_line do |line|
  puts line.colco(:green, :yellow, :blue)
end
{% endhighlight %}

出力です。

![Alt title noshadow]({{ BASE_PATH }}/assets/images/2014/07/colco1.png)

背景色を作りたいときは、`:bg_green`などとします。

## 複数属性の適用

一つのカラムに対して、前景色と背景色など複数の属性を適用したい場合は、アンダースコア（`_`）で属性をつなぎます。

{% highlight ruby %}
list.each_line do |line|
  puts line.colco(:green, :red_yellow, :blue_underline)
end
{% endhighlight %}

最初の色が前景色、２つ目以降が背景色になります。出力です。

![Alt title noshadow]({{ BASE_PATH }}/assets/images/2014/07/colco2.png)

緑背景に赤文字を点滅させたいときは、`:red_green_blink`などとします。

## カスタムカラムパターン

デフォルトではホワイトスペースをカラムの区切りと認識して各色を適用しますが、`regexp`オプションでこれをカスタマイズできます。

例えば、リストにスペースで区切られた名前と苗字が含まれていて、そこは連続した背景色にしたい場合、次のようにします。

{% highlight ruby %}
list = <<-EOS
Charlie Brown\t21\tprogrammer
Bill Clinton\t43\tdoctor
Liz Taylor\t18\tstudent
EOS

# 不適切な例:

list.each_line do |line|
  puts line.colco(:bg_green, :bg_green, :yellow, :blue_underline)
end

puts

# regexpオプションを使った例:

re = /^.*?(?=\t)|\S+/ # 最初のタブの前、または空白以外にマッチ

list.each_line do |line|
  puts line.colco(:bg_green, :yellow, :blue_underline, regexp:re)
end
{% endhighlight %}

出力です。


![Alt title noshadow]({{ BASE_PATH }}/assets/images/2014/07/colco3.png)


良かったら試してみてください。


以上、Yet Another Terminal Color for Rubyのお話でしたm(__)m

---

> [colcolor](https://rubygems.org/gems/colcolor "colcolor")
> 
> [melborne/colcolor](https://github.com/melborne/colcolor "melborne/colcolor")

---

(追記：2014-7-28) 

`colcolor`にcycleオプションを付けました。

> [カラム指向ターミナルカラーライブラリ「colcolor」にcycleオプションを付けました！]({{ BASE_PATH }}/2014/07/28/examples-of-colcolor-cycle-option/ "カラム指向ターミナルカラーライブラリ「colcolor」にcycleオプションを付けました！")

