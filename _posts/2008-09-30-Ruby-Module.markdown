---
layout: post
title: RubyのModuleクラスはすべてのモジュールの母であり同時にすべてのクラスの父である！
date: 2008-09-30
comments: true
categories:
---

Moduleクラスはすべてのモジュールの生成クラスである。だからModuleクラスに定義されたinstanceメソッドmは、すべてのモジュールで定義されたモジュールメソッドself.mになる。
{% highlight ruby %}
  class Module
    def m
      'm'
    end
  end
  Module.new.m # => "m"
  Kernel.m # => "m"
  Enumerable.m # => "m"
  Math.m # => "m"
{% endhighlight %}
またModuleクラスはClassクラスのスーパークラスでもある。だからModuleクラスに定義されたinstanceメソッドmは、Classクラスで定義されたinstanceメソッドmになる。
{% highlight ruby %}
  Class.new.m # => "m"
{% endhighlight %}
ここで、Classクラスはすべてのクラスの生成クラスである。だからClassクラスのinstanceメソッドとなったmは、すべてのクラスのクラスメソッドself.mになる。
{% highlight ruby %}
  Object.m # => "m"
  Array.m # => "m"
  class MyClass
  end
  MyClass.m # => "m"
{% endhighlight %}
この中には当然Moduleクラスも含まれているから、Classクラスのinstanceメソッドmは、Moduleクラスのクラスメソッドself.mにもなる。
{% highlight ruby %}
  Module.m # => "m"
{% endhighlight %}
ところが、ModuleクラスはClassクラスのスーパークラスだから、Moduleクラスのクラスメソッドになったself.mは、Classクラスのクラスメソッドself.mにもなる。
{% highlight ruby %}
  Class.m # => "m"
{% endhighlight %}

整理しよう。

Moduleクラスが１つのinstanceメソッドmを持つと、それがすべてのモジュールのモジュールメソッドself.mとなり、Classクラスのinstanceメソッドmとなり、ModuleクラスおよびClassクラスを含む、すべてのクラスのクラスメソッドself.mとなる。

Moduleクラスはモジュールの生成クラスである。だから、Classクラスがすべてのクラスを生み出すように、Moduleクラスはすべてのモジュールを生み出す。そして生み出されたすべてのモジュールは、Moduleクラスの特性に依存する。

そう、Classクラスがすべてのクラスの母であるなら…

Moduleクラスはすべてのモジュールの母だ！

加えてModuleクラスはClassクラスのスーパークラスである。だからModuleクラスに定義されたすべてのメソッドはClassクラスで使える。すべてのクラスはその生成クラスであるClassクラスの影響を受けるので、結果すべてのクラスはModuleクラスの影響を受けることになる。つまり、ModuleクラスはClassクラスによるクラス生成において、それを支援する極めて重要な役割を担っている。

要するにModuleクラスは、すべてのクラスの母であるClassクラスを支える…

すべてのクラスの父なんだ！

そうModuleクラスは、一方で各モジュールの母として彼らを生み出し、他方で各クラスの父としてClassクラスを支えるという、父と母の２つの顔を持った実体だったんだ！


関連記事：[RubyのObjectクラスは過去を再定義するタイムマシンだ！]({{ site.url }}/2008/09/27/Ruby-Object/)
