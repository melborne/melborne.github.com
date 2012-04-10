---
layout: post
title: 内部DSLを使って、RubyのWebフレームワークを書こう！
date: 2011-06-07
comments: true
categories:
---


Sinatraのようなベース言語の構文を使って実現するDSLを
内部DSLといいます
前回僕が書いた[Chinatra](/2011/06/05/Chinatra/)は一見内部DSLにみえるけど
ベース言語とは異なる構文を使った外部DSLです

でも時代の風は内部DSLに向いています

[the 0.8 true language](http://www.rubyist.net/~matz/20091003.html)
[言語ワークベンチ](http://capsctrl.que.jp/kdmsnr/wiki/bliki/?LanguageWorkbench)

自分もRubyの構文のユルさとメタプログラミングを使って
Sinatraのような内部DSLを書いてみたい

そしてRubyistをマインドコントロールしたい..


そんなわけで...


Sinatraと別の構文を持った
Webフレームワーク「Shynatra」をRubyで書きました:-)

ShynatraはRubyで下記のような最小労力で
手早くウェブアプリケーションを作成するためのDSLです
{% highlight ruby %}
# myapp.rb
require "shynatra"
R/:hello./ {
  'Hello world!'
}
{% endhighlight %}
R はCRUDのRです
/:hello の部分はパス(/hello)になります
先頭のコロンはパラメータを表しているわけではありません
./ はパスの終端子です
気に入らなくても省略はできません
それでも気に入らない人は.| か ._ を使いましょう

Rubyに慣れていない方のために一言付け加えますが
これはよく使われる由緒正しきRubyの構文です..
解説はこちら{% fn_ref 1 %}

ルートパスの指定にはnilを使います
{% highlight ruby %}
R/nil./ {
  @message = message "Shynatra"
  haml :index
}
H/nil./ {
  def message(app)
    "Welcome to #{app}!"
  end
}
{% endhighlight %}
SinatraのHelpersに対応するのはHです
Hを使うときも無意味に/nil./ します

ええ
nilするんです

パスの区切りは_(アンダースコア)を使います
つまり/foo/barは以下のように指定します
{% highlight ruby %}
R/:foo_bar./ {
  "You are in: '/foo/bar'"
}
{% endhighlight %}
当然
パス名にアンダースコアを含めることはできません

名前付きパラメータは@を前置します
{% highlight ruby %}
R/:@name./ { 
  "Hello, " + params[:name]
}
{% endhighlight %}
この場合もコロンは必須です
忘れてはいけません

名前付きパラメータをルート以外で使いたいこともあるでしょう
そのときは6を使います
{% highlight ruby %}
R/:foo_6name./ {
  "You are in: '/foo/:name' with '#{params[:name]}'"
}
R/:foo_6bar_baz_6name./ {
  "You are in '/foo/:bar/baz/:name' with :bar => #{params[:bar]}, :name => #{params[:name]}"
}
{% endhighlight %}
ええ
数字の6です
冗談じゃなく

解説は以上です
CRUDのC U D も多分動くと思います
詳細はコードを見てくださいね

Rubyの内部DSLであなたも**natraしてみませんか？

関連記事：
1. [SinatraはDSLなんかじゃない、Ruby偽装を使ったマインドコントロールだ！](/2011/06/03/Sinatra-DSL-Ruby/)
1. [Sinatraに別構文があってもいいじゃないか！](/2011/06/05/Sinatra/)

{% gist 1008708 shynatra.rb %}

{% footnotes %}
   {% fn R./(Rクラスのクラスメソッド/)を引数付きで呼んでいる。引数には、:hello#/(シンボル:helloのインスタンスメソッド/)をブロック付きで呼んだ返り値が渡される %}
{% endfootnotes %}
