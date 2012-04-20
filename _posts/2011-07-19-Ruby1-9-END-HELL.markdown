---
layout: post
title: Ruby1.9でもEND HELLを解消したい！
date: 2011-07-19
comments: true
categories:
tags: [ruby, gem]
---

RubyKaigi2011において現行Rubyの構文上の欠点である、END HELLを解消するEnd Rubyがあんどうやすし氏(id:technohippy)により提唱されました。

[parse.yの歩き方](http://www.ustream.tv/recorded/16077046)

END HELLとは要するに以下のような醜いendの連なりのことです。
{% highlight ruby %}
module MyModule
  class MyClass
    def my_method
      10.times do
        if rand < 0.5
          p :small
        else
          p :large
        end
      end 
    end      <- ここ
  end
end
{% endhighlight %}

氏はLispのcddddrに倣ってRubyへのennnnndキーワードの導入を提唱します。ennnnndを使えば先のコードは次のように書けます。
{% highlight ruby %}
module MyModule
  class MyClass
    def my_method
      10.times do
        if rand < 0.5
          p :small
        else
          p :large
        ennnnnd
{% endhighlight %}
変態ですね！

Rubyコミッターらによる実装も完了したようなので、Ruby2.0で正式採用となるのも間違いなさそうです..

[http://d.hatena.ne.jp/ku-ma-me/20110718/p1](http://d.hatena.ne.jp/ku-ma-me/20110718/p1)

そこで気がはやい人のためにRuby1.9でもennnnndを可能とする、`ennnd`ライブラリを作りました:)

以下のように使います。まずはあなたのコードを用意します。
{% highlight ruby %}
# mycode.rb
module MyModule
  class MyClass
    def my_method
      10.times do
        if rand < 0.5
          p :small
        else
          p :large
        ennnnnd
{% endhighlight %}

ennndライブラリとあなたのコードをrequireして、実行する実行コードを用意します。
{% highlight ruby %}
#req.rb 
require './ennnd'
require 'mycode'
MyModule::MyClass.new.my_method
{% endhighlight %}
つまりennndキーワードを含むあなたのコードをライブラリとして読み込みます。

これを現行Rubyで実行します。
{% highlight sh %}
% ruby req.rb 
:small
:small
:large
:small
:small
:large
:small
:large
:small
:small
{% endhighlight %}

やっぱりRubyは楽しいですね！

関連記事：[Sinatraに別構文があってもいいじゃないか！]({{ site.url }}/2011/06/05/Sinatra/)

{% gist 1091353 ennnd.rb %}

