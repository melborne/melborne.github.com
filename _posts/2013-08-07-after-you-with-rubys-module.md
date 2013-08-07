---
layout: post
title: "お先にどうぞ ─ Rubyのモジュールにおける譲る心をあなたにも知ってほしい"
description: ""
category: 
tags: 
date: 2013-08-07
published: true
---
{% include JB/setup %}

─問題─

Ruby2.0におけるモジュールに関し次の問に答えよ（各５点、制限時間５分）。

##問１

以下のコードにおける出力を答えよ。

{% highlight ruby %}
class A
  def initialize
    print :a
    super
  end

  def initialize
    print :A
    super
  end
end

A.new
{% endhighlight %}

<br />


##問２

以下のコードにおける出力を答えよ。

{% highlight ruby %}
module B
  def initialize
    print :B
    super
  end
end

class A
  include B

  def initialize
    print :A
    super
  end
end

A.new
{% endhighlight %}


<br />

##問３

以下のコードにおける出力を答えよ。

{% highlight ruby %}
module C
  def initialize
    print :C
    super
  end
end

module B
  def initialize
    print :B
    super
  end
end

class A
  include C
  include B

  def initialize
    print :A
    super
  end
end

A.new
{% endhighlight %}

<br />

##問４

以下のコードにおける出力を答えよ。

{% highlight ruby %}
module C
  def initialize
    print :C
    super
  end
end

module B
  def self.included(base)
    base.send :include, C
  end

  def initialize
    print :B
    super
  end
end

class A
  include B

  def initialize
    print :A
    super
  end
end

A.new
{% endhighlight %}

<br />

##問５

問４における状態から最小の改変で出力を`CAB`としたい。どうすればいいか。

<br />
<br />
<br />

─答え─

##問１

    正解： A

    解説： 前方のメソッドが後方のメソッドで上書きされるから。

<br />

##問２

    正解： AB

    解説： `include B`により継承順位が`A -> B`となり、A#initializeにおけるsuperでB#initializeが呼ばれるから。継承順位はA.ancestorsで確認できます。

<br />

##問３

    正解： ABC

    解説：includeの順位により継承順位が`A -> B -> C`となり、A#initializeにおけるsuperでB#initializeが呼ばれ、次いでB#initializeにおけるsuperでC#initializeが呼ばれるから。

<br />

##問４

    正解： ACB

    解説： クラスAにBがincludeされたときに、B.includedメソッドが呼び出されてAにCがincludeされることとなり、継承順位は`A -> C -> B`となるから。

<br />

##問５

    正解：B.included内の`include`を`prepend`に書き換える。

    解説： Module#prependはクラスAの前にモジュールCを差し込み、継承順位を`C -> A -> B`とします。


{% highlight ruby %}
module C
  def initialize
    print :C
    super
  end
end

module B
  def self.included(base)
    base.send :prepend, C
  end

  def initialize
    print :B
    super
  end
end

class A
  include B

  def initialize
    print :A
    super
  end
end

A.new
{% endhighlight %}


頭の整理ついでに問題にしてみました。

