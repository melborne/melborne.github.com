---
layout: post
title: "マトリョーシカはRackだけのものじゃない、あなたのRubyにもマトリョーシカを！"
description: ""
category: 
tags: [rack]
date: 2012-08-10
published: true
---
{% include JB/setup %}


前３回([１回](http://melborne.github.com/2012/08/02/build-your-own-web-framework-with-rack/ 'エラーメッセージから学ぶRack - 最初の一歩')[２回](http://melborne.github.com/2012/08/06/use-rack-middleware/ 'エラーメッセージから学ぶRack - Middlewareの魔法')[３回](http://melborne.github.com/2012/08/08/learn-rack-with-lack/ 'Rackをminifyした僅か100行のLackで学ぶRackの中身'))の投稿を通して、僕は「**Rackは棚ではなく、マトリョーシカである**」ということを悟りました。つまりRackにおいて、Webアプリは一または複数のmiddlewareに多層的にラップされ、１つの#call呼び出しに対して内側から外側に向けて順に#callの実行を伝搬させるのだと知りました。そして僕はこのような呼び出し伝搬を「**マトリョーシカ呼び出し**」と名付けました。

**マトリョーシカ呼び出し**は、僕に惑星からの巨大エネルギー放出を連想させます。

> 巨大な惑星の外縁に与えた小さな力が、それを構成する各層の外側から内側に順に伝搬していき、そのコアに到達する。コアに到達した小さな力はそこで小さな爆発を誘引し、今度は内側から外側に向けてその各層において連鎖的な爆発を順に誘引し、最後には巨大な爆発エネルギーを惑星外に放出するのです。

僕はすっかりこの**マトリョーシカ呼び出し**の虜になりました。そしてマトリョーシカ呼び出しが、Rackだけではなく、Rubyで広く利用されればいいと願いました。

> Rubyの世界がマトリョーシカ呼び出しで埋まればいいのに..

そんなわけで...

Rubyにおいてマトリョーシカの生成を支援する`Matryoshka`クラスを書きました^ ^;

<script src="https://gist.github.com/3312632.js?file=matryoshka.rb"></script>


## 使い方
Rackの使い方を知っていれば、Matryoshkaの使い方は簡単です。MatryoshkaではRackのWebアプリに相当するものを`core`と呼び、middlewareに相当するものを`figure`または`doll`と呼びます。つまり`core`は#callを持ったオブジェクト、`figure`は#callを持ち、#initializeの引数にcoreを取るクラスです。

### 文字列操作の例
次の例は、"Hello, World"の文字列をMatoryoshkaを使って、Reverse, Upcaseする例です。

{% highlight ruby %}
require "./matryoshka"

core = ->env{ "Hello, World".tap { |s| p s } }

class Reverse
  def initialize(core)
    @core = core
  end

  def call(env)
    res = @core.call(env)
    res.reverse.tap { |s| p s }
  end
end

class Upcase
  def initialize(core)
    @core = core
  end
  
  def call(env)
    res = @core.call(env)
    res.upcase.tap { |s| p s }
  end
end

mat = Matryoshka.new(core)
mat.set Reverse, Upcase

mat.call # => "DLROW ,OLLEH"

# >> "Hello, World"
# >> "dlroW ,olleH"
# >> "DLROW ,OLLEH"
{% endhighlight %}

手順は次の通りです。

> 1. coreおよびfigureを用意する。
> 1. coreを引数にMatryoshkaオブジェクトを生成する。
> 1. Matryoshka#setでfigureをセットする（Rackのuseに相当）。
> 1. Matryoshka#callで処理を実行する（Rackのrunに相当）。

ここではtapで途中経過を出力するようにしています。Rackとの相違点は、figureの呼び出し順位が逆という点です。つまりMatryoshkaでは先に#setにセットしたものの#callが先に実行されます。

### Matryoshka.figure

Matryoshkaには、figureというfigureの生成を支援するクラスメソッドがあります。これを使って先の例を書き換えると次のようになります。

{% highlight ruby %}
require "./matryoshka"

core = ->env{ "Hello, World".tap { |s| p s } }

M8a.figure('Reverse', :reverse)

M8a.figure('Upcase', :upcase)

mat = M8a.new(core)
mat.set Reverse, Upcase

mat.call # => "DLROW ,OLLEH"

# >> "Hello, World"
# >> "dlroW ,olleH"
# >> "DLROW ,OLLEH"
{% endhighlight %}

シンプルになりましたね！ここではMatryoshkaの別名M8aを使っています。

### FizzBuzzの例

ではFizzBuzzブーム再来に便乗して、MatryoshkaでFizzBuzzしてみます。

{% highlight ruby %}
require "./matryoshka"

mod_zero = ->base,n{ n.is_a?(Integer) && (n%base).zero? }

M8a.doll(:Fizz) do |n, e|
  mod_zero[3, n] ? :Fizz : n
end

M8a.doll(:Buzz) do |n, e|
  mod_zero[5, n] ? :Buzz : n
end

M8a.doll(:FizzBuzz) do |n, e|
  mod_zero[15, n] ? :FizzBuzz : n
end

m = M8a.new(->e{ e })
m.set FizzBuzz, Fizz, Buzz

(1..100).each do |n|
  print m.call(n), " "
end

# >> 1 2 Fizz 4 Buzz Fizz 7 8 Fizz Buzz 11 Fizz 13 14 FizzBuzz 16 17 Fizz 19 Buzz Fizz 22 23 Fizz Buzz 26 Fizz 28 29 FizzBuzz 31 32 Fizz 34 Buzz Fizz 37 38 Fizz Buzz 41 Fizz 43 44 FizzBuzz 46 47 Fizz 49 Buzz Fizz 52 53 Fizz Buzz 56 Fizz 58 59 FizzBuzz 61 62 Fizz 64 Buzz Fizz 67 68 Fizz Buzz 71 Fizz 73 74 FizzBuzz 76 77 Fizz 79 Buzz Fizz 82 83 Fizz Buzz 86 Fizz 88 89 FizzBuzz 91 92 Fizz 94 Buzz Fizz 97 98 Fizz Buzz 
{% endhighlight %}

ここではfigureの別名`doll`を使っています。dollを使ってFizz, Buzz, FizzBuzzクラスを定義しています。doll(figure)はブロックを取ることができ、ここに#callメソッドの手続きを書きます。ブロック引数には、前のfigureまたはcoreの#callのレスポンス（n）と#callの引数として渡される環境変数env（e）が渡されます。

ここでのcoreは`->e{ e }`です。これはcallの引数をそのまま返します。Matryoshkaオブジェクトの#callつまり一番外側のcallには1〜100を順番に渡していきます。

## 配列操作の例

次に、配列の値に対する演算をやってみます。

{% highlight ruby %}
require "./matryoshka"

M8a.figure(:Square) do |res, env|
  res.map { |i| i ** 2 }.tap { |s| print s, " :Square\n" }
end

M8a.figure(:Plus10) do |res, env|
  res.map { |i| i + 10 }.tap { |s| print s, " :Plus10\n" }
end

M8a.figure(:Div2) do |res, env|
  res.map { |i| i / 2 }.tap { |s| print s, " :Div2\n" }
end

core = ->env{ [*1..10].tap { |s| print s, " :Core\n" } }

mat2 = M8a.new(core)
mat2.set Square, Plus10, Square, Div2, Plus10
mat2.call

# >> [1, 2, 3, 4, 5, 6, 7, 8, 9, 10] :Core
# >> [1, 4, 9, 16, 25, 36, 49, 64, 81, 100] :Square
# >> [11, 14, 19, 26, 35, 46, 59, 74, 91, 110] :Plus10
# >> [121, 196, 361, 676, 1225, 2116, 3481, 5476, 8281, 12100] :Square
# >> [60, 98, 180, 338, 612, 1058, 1740, 2738, 4140, 6050] :Div2
# >> [70, 108, 190, 348, 622, 1068, 1750, 2748, 4150, 6060] :Plus10
{% endhighlight %}

この例では生成した演算figureを複数回使っています。各figureは使い回しができるアダプタブルなものということです。

サンプルは以上です。

で、何が面白いの？

ええ、それが僕にもさっぱりわからないのです...m(__)m

----

関連記事：

[エラーメッセージから学ぶRack - 最初の一歩](http://melborne.github.com/2012/08/02/build-your-own-web-framework-with-rack/ 'エラーメッセージから学ぶRack - 最初の一歩')

[エラーメッセージから学ぶRack - Middlewareの魔法](http://melborne.github.com/2012/08/06/use-rack-middleware/ 'エラーメッセージから学ぶRack - Middlewareの魔法')

[Rackをminifyした僅か100行のLackで学ぶRackの中身](http://melborne.github.com/2012/08/08/learn-rack-with-lack/ 'Rackをminifyした僅か100行のLackで学ぶRackの中身')


---

![Rack Ebook]({{ site.url }}/assets/images/2012/rack_cover.png)

<a href="http://gum.co/ZqRt" class="gumroad-button">電子書籍「エラーメッセージから学ぶRack」EPUB版 </a><script type="text/javascript" src="https://gumroad.com/js/gumroad-button.js"></script><script type="text/javascript" src="https://gumroad.com/js/gumroad.js"></script>

このリンクはGumroadにおける商品購入リンクになっています。クリックすると、オーバーレイ・ウインドウが立ち上がって、この場でクレジットカード決済による購入が可能です。購入にはクレジット情報およびメールアドレスの入力が必要になります。購入すると、入力したメールアドレスにコンテンツのDLリンクが送られてきます。

詳細は以下を参照して下さい。

> [電子書籍「エラーメッセージから学ぶRack」EPUB版をGumroadから出版しました！](http://melborne.github.com/2012/12/24/learning-rack-on-ebook/ '電子書籍「エラーメッセージから学ぶRack」EPUB版をGumroadから出版しました！')

購入ご検討のほどよろしくお願いしますm(__)m

----

{{ 4834011887 | amazon_medium_image }}
{{ 4834011887 | amazon_link }} by {{ 4834011887 | amazon_authors }}

