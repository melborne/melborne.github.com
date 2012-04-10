---
layout: post
title: RubyのObjectクラスは過去を再定義するタイムマシンだ！
date: 2008-09-27
comments: true
categories:
---


Objectクラスはすべてのクラスのスーパークラスである
だからObjectクラスに定義されたinstanceメソッドoは
すべてのクラスで定義されたinstanceメソッドoになる
{% highlight ruby %}
  class Object
    def o
      'o'
    end
  end
  class MyClass
  end
  Object.new.o # => "o"
  Array.new.o # => "o"
  Hash.new.o # => "o"
  MyClass.new.o # => "o"
{% endhighlight %}
ClassクラスもObjectクラスのサブクラスだから
このinstanceメソッドoは
当然Classクラスのinstanceメソッドoにもなる
{% highlight ruby %}
  Class.new.o # => "o"
{% endhighlight %}

一方Classクラスはすべてのクラスの生成クラスである
だからClassクラスのinstanceメソッドとなったoは
すべてのクラスのクラスメソッドself.oになる
{% highlight ruby %}
  Array.o # => "o"
  Hash.o # => "o"
  MyClass.o # => "o"
{% endhighlight %}
この中には当然Objectクラスが含まれているから
Classクラスのinstanceメソッドoは
Objectクラスのクラスメソッドself.oにもなる
{% highlight ruby %}
  Object.o # => "o"
{% endhighlight %}

ところがObjectクラスはClassクラスのスーパークラスだから
Objectクラスのクラスメソッドになったself.oは
Classクラスのクラスメソッドself.oにもなる
{% highlight ruby %}
  Class.o # => "o"
{% endhighlight %}

整理しよう
Objectクラスが１つのinstanceメソッドoを持つと
それがClassクラスを含むすべてのクラスのinstanceメソッドoとなり
Objectを含むすべてのクラスのクラスメソッドself.oとなり
Classクラスのクラスメソッドself.oとなる
こうしてRuby空間に存在するすべてのクラスには
instanceメソッドoとクラスメソッドself.oが生まれることとなる

ClassクラスはObjectクラスを含むすべてのクラスの母である
従ってすべてのクラスはClassクラスの特性に依存する
一方でClassクラスはその子であるObjectクラスの弟子である
従ってClassクラスはObjectクラスの特性を受け継ぐ

このような多層的循環構造によって
Objectクラスが変わると
Classクラスが変わり
その変化はすべてのクラスを変える
つまりObjectクラスへのオペレーションは
過去の事実(Classクラス)を再定義し
延いては今の世界(すべてのクラス)を再構築する！

そうRubyのObjectクラスは…

時空を超えて過去を再定義し
世界を再構築するタイムマシンだったんだ！

ところでObjectクラスにはKernelモジュールがincludeされている
モジュールに定義されたinstanceメソッドは
それをincludeしたクラスのものになるから
Kernelモジュールのinstanceメソッドは
Objectクラスのものになる

つまりKernelモジュールはObjectクラスに
過去を変えるためのメソッドを補給する
Kernelモジュールから補給されたメソッドは
Objectクラスに定義されたメソッドとして
同様に過去を再定義し今の世界を再構築する

そうRubyのKernelモジュールは…

タイムマシン補助燃料タンクだったんだ！

関連記事：[Rubyのクラスはオブジェクトの母、モジュールはベビーシッター - hp12c](http://d.hatena.ne.jp/keyesberry/20080816/p1)

2008-9-29追記：Kernelモジュールのところを追加しました。