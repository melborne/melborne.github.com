---
layout: post
title: "Rubyの力で僕のパパを貧乏父さんから金持ち父さんにしてよ！"
description: ""
category: 
tags: [ruby]
date: 2012-05-19
published: true
---
{% include JB/setup %}

    まさし君の家はお金持ちでした
    まさし君はちょっと意地悪だったけど
    クラスでビデオゲームを持っているのが彼だけだったので
    授業が終わるとみんなまさし君の家に行ってゲームをしました
    
    週末になるとまさし君は家族で湖畔の別荘にいって
    釣りをしたりバーベキューをしたりしていて
    僕らをたまにその別荘に誘ってくれました
    そんなときには決まってまさし君のお父さんが
    魚の釣り方とかボートの漕ぎ方とかを
    優しく僕らに教えてくれました
    
    別荘からの帰り道でいつも僕らはこうつぶやいていたのでした
    
    「まさし君のパパが僕のパパだったらいいのに..」
    

幸か不幸か現実世界ではそんなことは起きませんでした。

果たして、Rubyの世界ではどうでしょうか？早々試してみましょう。

まずは僕の現実から。
{% highlight ruby %}
class PoorDad
  private
  def money
    10000
  end
end

class Me < PoorDad
  def give_me_money
    money * 0.01
  end
end

Me.new.give_me_money # => 100.0
{% endhighlight %}

次に、まさし君の現実を。
{% highlight ruby %}
class RichDad
  private
  def money
    10000 * FaceBook.stock_value
  end
end

class FaceBook
  def self.stock_value
    38
  end
end

class Masashi < RichDad
  def give_me_money
    money * 0.01
  end
end

Masashi.new.give_me_money # => 3800.0
{% endhighlight %}
さすが、まさし君のパパです。


さあ、本題です。まさし君のパパを僕のパパに！
{% highlight ruby %}
class Me < RichDad
  def give_me_money
    money * 0.01
  end
end

Me.new.give_me_money # => 
# ~> -:38:in `<main>': superclass mismatch for class Me (TypeError)
{% endhighlight %}
嗚呼、Rubyにもそれはできないのですね..

それではあまりに僕らが可哀想じゃありませんか..
少しの間だけでも金持ち父さんの子供になってみたい..


...


____

そんなわけで..

そんな子供たちの夢を叶えるべく、親クラスを一時的に差し替えるSurrogateDad(代理パパ)モジュールを書いてみましたよ！

{% gist 2730356 surrogate_dad.rb %}

次のように使います。
{% highlight ruby %}
include SurrogateDad

surrogate(Me, RichDad) do
  Me.superclass # => RichDad
  Me.class_eval do
    def give_me_money
      money * 0.01
    end
  end
  Me.new.give_me_money # => 3800.0
end

Me.new.give_me_money # => 100.0
{% endhighlight %}
surrogateメソッドの第１引数に子クラスを、第２引数に差し替える親クラスを渡します。そうすると、そのブロック内では一時的に親クラスが差し替えられます。子クラスのメソッドはここで定義し直す必要があります。残念ながら{% fn_ref 1 %}。ブロックを出ると元の親クラスに戻ります。

つかの間、Rubyの世界で子供たちの夢が叶いました。

[replace superclass temporally in Ruby — Gist](https://gist.github.com/2730356 'replace superclass temporally in Ruby — Gist')

なお、SurrogateDadモジュールは[fakefsモジュール](https://github.com/defunkt/fakefs 'defunkt/fakefs')を参考にしました。


{{ 4480863303 | amazon_medium_image }}
{{ 4480863303 | amazon_link }} by {{ 4480863303 | amazon_authors }}



{% footnotes %}
  {% fn いろいろと試みたのですが僕にはできませんでした.. %}
{% endfootnotes %}

