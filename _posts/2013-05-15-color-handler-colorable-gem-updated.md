---
layout: post
title: "Rubyで色を扱うライブラリ「Colorable」をアップデートしましたのでお知らせいたします"
description: ""
category: 
tags: 
date: 2013-05-15
published: true
---
{% include JB/setup %}

Rubyで色を扱う[Colorable gem](https://rubygems.org/gems/colorable "colorable")をアップデートして大幅に機能強化しましたので、改めて紹介します。versionは0.2.0です。

> [colorable \| RubyGems.org \| your community gem host](https://rubygems.org/gems/colorable "colorable \| RubyGems.org \| your community gem host")
> 
> [melborne/colorable · GitHub](https://github.com/melborne/colorable "melborne/colorable · GitHub")



## Colorableとは

Colorableは、Rubyで色を取り扱うためのライブラリで、次の機能を備えています。

    1. 色変換: X11カラー名, HEX, RGBおよびHSB値の間での出力フォーマットの変換ができます。
    2. 色合成: 算術演算子を使った色合成ができます。
    3. 色列挙: X11カラーにおける列挙操作ができます。
    4. 色モード: 各Colorオブジェクトは出力状態を表すモードを持っていて、その状態に応じてメソッドの挙動を変更できます。

## 使い方
上記各機能の使い方を順に説明します。

###Colorオブジェクトの生成
`gem install colorable`して以下のようにColorオブジェクトを生成します。

{% highlight ruby %}
require "colorable"
include Colorable

# X11カラーから
Color.new 'Alice Blue' # => #<Colorable::Color 'Alice Blue<rgb(240,248,255)/hsb(208,6,100)/#F0F8FF>'>

# HEX文字列から
Color.new '#F0F8FF' # => #<Colorable::Color 'Alice Blue<rgb(240,248,255)/hsb(208,6,100)/#F0F8FF>'>

# RGB値から
Color.new [240, 248, 255] # => #<Colorable::Color 'Alice Blue<rgb(240,248,255)/hsb(208,6,100)/#F0F8FF>'>

# HSB値から
Color.new HSB.new(208, 6, 100) # => #<Colorable::Color 'Alice Blue<rgb(240,248,255)/hsb(208,6,100)/#F0F8FF>'>
{% endhighlight %}

Rubyの標準クラスString, Symbol, Array, Fixnumに追加される`to_color`メソッドを使ったショートカットがあります。

{% highlight ruby %}
'Alice Blue'.to_color # => #<Colorable::Color 'Alice Blue<rgb(240,248,255)/hsb(208,6,100)/#F0F8FF>'>

:alice_blue.to_color # => #<Colorable::Color 'Alice Blue<rgb(240,248,255)/hsb(208,6,100)/#F0F8FF>'>

'#f0f8ff'.to_color # => #<Colorable::Color 'Alice Blue<rgb(240,248,255)/hsb(208,6,100)/#F0F8FF>'>

[240, 248, 255].to_color # => #<Colorable::Color 'Alice Blue<rgb(240,248,255)/hsb(208,6,100)/#F0F8FF>'>

0xf0f8ff.to_color # => #<Colorable::Color 'Alice Blue<rgb(240,248,255)/hsb(208,6,100)/#F0F8FF>'>
{% endhighlight %}


### 色変換 

Colorオブジェクトが備えるメソッドを使って、色の出力フォーマットを変換することができます。
{% highlight ruby %}
c = Color.new :alice_blue

c.name # => "Alice Blue"
c.rgb  # => [240, 248, 255]
c.hsb  # => [208, 6, 100]
c.hex  # => "#F0F8FF"
c.dark?     # => false
c.info # => {:name=>"Alice Blue", :rgb=>[240, 248, 255], :hsb=>[208, 6, 100], :hex=>"#F0F8FF", :mode=>:NAME, :dark=>false}

[240, 248, 255].to_color.hex # => "#F0F8FF"
[240, 248, 255].to_color.hsb # => [208, 6, 100]
{% endhighlight %}

### 色合成

算術演算子`+`, `-`, `*`, `/`を使って、２つの色の合成（加算合成、逆加算合成、乗算合成、スクリーン合成）ができます。

{% highlight ruby %}
red = Color.new :red
green = Color.new :green
blue = Color.new :blue

yellow = red + green
yellow.info # => {:name=>"Yellow", :rgb=>[255, 255, 0], :hsb=>[60, 100, 100], :hex=>"#FFFF00", :mode=>:NAME, :dark=>false}

red + blue # => #<Colorable::Color 'Fuchsia<rgb(255,0,255)/hsb(300,100,100)/#FF00FF>'>

green + blue # => #<Colorable::Color 'Aqua<rgb(0,255,255)/hsb(180,100,100)/#00FFFF>'>

red + green + blue # => #<Colorable::Color 'White<rgb(255,255,255)/hsb(0,0,100)/#FFFFFF>'>

red - green # => #<Colorable::Color 'Black<rgb(0,0,0)/hsb(0,0,0)/#000000>'>
red * green # => #<Colorable::Color 'Black<rgb(0,0,0)/hsb(0,0,0)/#000000>'>
red / green # => #<Colorable::Color 'Yellow<rgb(255,255,0)/hsb(60,100,100)/#FFFF00>'>
{% endhighlight %}

### 色列挙
`#next`, `#prev`などを使って、X11カラーにおける次の色や前の色を取得することができます。

{% highlight ruby %}
c = Color.new :alice_blue

c.next # => #<Colorable::Color 'Antique White<rgb(250,235,215)/hsb(35,14,98)/#FAEBD7>'>
c.next(10) # => #<Colorable::Color 'Blue Violet<rgb(138,43,226)/hsb(271,81,89)/#8A2BE2>'>

c.prev # => #<Colorable::Color 'Yellow Green<rgb(154,205,50)/hsb(79,76,80)/#9ACD32>'>
c.prev(10) # => #<Colorable::Color 'Teal<rgb(0,128,128)/hsb(180,100,50)/#008080>'>

c + 1 # => #<Colorable::Color 'Antique White<rgb(250,235,215)/hsb(35,14,98)/#FAEBD7>'>
c + 10 # => #<Colorable::Color 'Blue Violet<rgb(138,43,226)/hsb(271,81,89)/#8A2BE2>'>
c - 1 # => #<Colorable::Color 'Yellow Green<rgb(154,205,50)/hsb(79,76,80)/#9ACD32>'>
c - 10 # => #<Colorable::Color 'Teal<rgb(0,128,128)/hsb(180,100,50)/#008080>'>

10.times.map { c = c.next }.map(&:name) # => ["Antique White", "Aqua", "Aquamarine", "Azure", "Beige", "Bisque", "Black", "Blanched Almond", "Blue", "Blue Violet"]
{% endhighlight %}


### 色モード
各Colorオブジェクトは出力状態を表すモードを持っています。モードの初期状態は、Color.newに渡した引数の種類で決まります。モードの種類によって#to_s, #next, #+などの各メソッドの挙動が変わります。`#mode=`でモードを切り替えることができます。

{% highlight ruby %}
c = Color.new :alice_blue
c.mode # => :NAME
c.to_s # => "Alice Blue"
# 名前順における次のカラーを取得
c.next # => #<Colorable::Color 'Antique White<rgb(250,235,215)/hsb(35,14,98)/#FAEBD7>'>
# 名前順における次のカラーを取得
c + 1 # => #<Colorable::Color 'Antique White<rgb(250,235,215)/hsb(35,14,98)/#FAEBD7>'>

c.mode = :RGB
c.to_s # => "rgb(240,248,255)"
# RGB値順における次のカラーを取得
c.next # => #<Colorable::Color 'Honeydew<rgb(240,255,240)/hsb(120,6,100)/#F0FFF0>'>
# RGB値にそれぞれ15, -20, -74を加算
c + [15, -20, -74] # => #<Colorable::Color 'Moccasin<rgb(255,228,181)/hsb(39,29,100)/#FFE4B5>'>
# RGB値のそれぞれに20を加算
c - 20 # => #<Colorable::Color '<rgb(220,228,235)/hsb(208,6,92)/#DCE4EB>'>

c.mode = :HSB
c.to_s # => "hsb(208,6,100)"
# HSB値順における次のカラーを取得
c.next # => #<Colorable::Color 'Slate Gray<rgb(112,128,144)/hsb(210,22,56)/#708090>'>
# HSB値にそれぞれ152, 94, 0を加算
c + [152, 94, 0] # => #<Colorable::Color 'Red<rgb(255,0,0)/hsb(0,100,100)/#FF0000>'>

c.mode = :HEX
c.to_s # => "#F0F8FF"
# HEX値順における次のカラーを取得
c.next # => #<Colorable::Color 'Honeydew<rgb(240,255,240)/hsb(120,6,100)/#F0FFF0>'>
# HEX値順における4つ先のカラーを取得
c + 4 # => #<Colorable::Color '<rgb(244,252,3)/hsb(62,99,99)/#F4FC03>'>
{% endhighlight %}

### Colorsetオブジェクトの生成
ColorsetオブジェクトはX11カラーにおける並びの色を提供します。引数なしでオブジェクトを生成すると名前順のColorオブジェクトのリストが生成されます。並び順の異なるリストを生成したい場合は、orderオプションで指定します。

{% highlight ruby %}
cs = Colorset.new # => #<Colorable::Colorset 0/144 pos='Alice Blue<rgb(240,248,255)/hsb(208,6,100)>'>

# オプション付きで
cs = Colorset.new(order: :RGB) # => #<Colorable::Colorset 0/144 pos='Black<rgb(0,0,0)/hsb(0,0,0)>'>
cs = Colorset.new(order: :HSB, dir: :-) # => #<Colorable::Colorset 0/144 pos='Light Pink<rgb(255,182,193)/hsb(352,29,100)>'>
{% endhighlight %}

### Colorsetオブジェクトの操作
Colorsetオブジェクトは環状リストになっていて、#next, #prevでそのポインタを移動させることができます。#rewindでポインタを最初の位置に戻します。Enumerableモジュールの各種メソッドが利用できます。

{% highlight ruby %}
cs = Colorset.new
cs.size # => 144
cs.at # => #<Colorable::Color 'Alice Blue<rgb(240,248,255)/hsb(208,6,100)/#F0F8FF>'>
cs.at.to_s # => "Alice Blue"
cs.at(1).to_s # => "Antique White"
cs.at(2).to_s # => "Aqua"

# next(prev) methods moves cursor position
cs.next.to_s # => "Antique White"
cs.at.to_s # => "Antique White"
cs.next.to_s # => "Aqua"
cs.at.to_s # => "Aqua"
cs.rewind
cs.at.to_s # => "Alice Blue"

cs.map(&:to_s).take(10) # => ["Alice Blue", "Antique White", "Aqua", "Aquamarine", "Azure", "Beige", "Bisque", "Black", "Blanched Almond", "Blue"]

cs.sort_by(&:rgb).take(10).map(&:rgb) # => [[0, 0, 0], [0, 0, 128], [0, 0, 139], [0, 0, 205], [0, 0, 255], [0, 100, 0], [0, 128, 0], [0, 128, 128], [0, 139, 139], [0, 191, 255]]

cs.sort_by(&:hsb).take(10).map(&:hsb) # => [[0, 0, 0], [0, 0, 41], [0, 0, 50], [0, 0, 66], [0, 0, 75], [0, 0, 75], [0, 0, 83], [0, 0, 86], [0, 0, 96], [0, 0, 100]]
{% endhighlight %}


以上、Rubyで色を扱う[Colorable gem](https://rubygems.org/gems/colorable "colorable")の紹介でした。

---

関連記事：

> {% hatebu http://melborne.github.io/2012/11/07/play-gviz-with-colorable/ "Rubyライブラリ「Colorable」とGvizを使ってGraphvizで綺麗なリングを描く" %}

