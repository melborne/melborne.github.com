---
layout: post
title: "Rubyで配列にアイテムを追加した新たな配列を返す、きっと良くない方法"
description: ""
category: 
tags: [ruby, coerce] 
published: true
---
{% include JB/setup %}

## 配列の最後にアイテムを追加する
Rubyで配列の最後にアイテムを追加するときは通常、`Array#<<`, `Array#push`を使いますよね。

{% highlight ruby %}
list = [1,2]
list << 3 # => [1, 2, 3]
list.push(4) # => [1, 2, 3, 4]
list # => [1, 2, 3, 4]
{% endhighlight %}

これは元の配列を改変する破壊的代入です。しかし、元の配列を破壊せずにアイテムを追加した新たな配列を得たい、というときもあります。その場合は、`Array#+`を使います。

{% highlight ruby %}
list = [1,2]
list2 = list + [3] # => [1, 2, 3]
list # => [1, 2]
{% endhighlight %}

でも追加要素を`[]`で括らなければいけないのが、ちょっとイケてないですよね。できれば、次のように関数型言語風に結合したい。

{% highlight ruby %}
list = [1,2]
list2 = list + 3 # => [1, 2, 3]
list3 = list2 + :a # => [1, 2, 3, :a]
list # => [1, 2]
{% endhighlight %}


これはもちろん、`Array#+`を再定義することで可能になりますが、次のような方法でも実現できます。

{% highlight ruby %}
class Object
  def method_missing(name, *arg, &blk)
    return [self] if name == :to_ary
    super
  end
end

list = [1,2]
list2 = list + 3 # => [1, 2, 3]
list3 = list2 + :a # => [1, 2, 3, :a]
list # => [1, 2]
{% endhighlight %}

`Array#+`はその引数にArrayオブジェクト以外を渡すと、そのオブジェクトの`to_ary`メソッドを呼び出します。ほとんどのオブジェクトはto_aryメソッドを持っていないので、結果として`Object#method_missing`が呼ばれて、`[self]`が実行されることになり、これで配列との結合ができるようになります。

もう少し凝って、`[self]`の前に`self.to_a`を呼ぶようにすると、HashやStructのオブジェクトを配列展開して結合させることもできます。

{% highlight ruby %}
class Object
  def method_missing(name, *arg, &blk)
    case name
    when :to_ary then self.to_a
    when :to_a   then [self]
    else super
    end
  end
end

list = [1,2]
list + {:a => 1} # => [1, 2, [:a, 1]]

Person = Struct.new(:name, :age)
charlie = Person['Charlie', 12]
list + charlie # => [1, 2, "Charlie", 12]

m = "2012June23".match(/(\d+)(\D+)(\d+)/)
list + m # => [1, 2, "2012June23", "2012", "June", "23"]
{% endhighlight %}

これらの方法の利点は、配列に対してどのように結合されるかの決定権を、そのオブジェクトに留保できる点にあります。オブジェクトがその決定権を行使したい場合は`to_ary`を定義すればいいです。

{% highlight ruby %}
class Person
  def initialize(name, age, job)
    @name, @age, @job = name, age, job
  end

  def to_ary
    ["#@name/#@age/#@job"]
  end
end

p1 = Person.new('Charlie', 12, :programmer)
p2 = Person.new('Bob', 29, :teacher)
[] + p1 + p2 # => ["Charlie/12/programmer", "Bob/29/teacher"]
{% endhighlight %}

`Array#+`を再定義するとその決定権が奪われてしまいます。

でも、Object#method_missingを弄るなんて、明らかに筋が悪すぎますよね..


先に行きます...

## 配列の先頭にアイテムを追加する

配列の「先頭に」アイテムを追加した新たな配列を返したい、ってときもありますよね。普通、こうします。
{% highlight ruby %}
list = [2,3]
list2 = [1] + list # => [1, 2, 3]
list # => [2, 3]
{% endhighlight %}

やっぱり、`[]`が、イケてない。できればこうしたい。
{% highlight ruby %}
list = [2,3]
1 + list # => [1, 2, 3]
2.0 + list # => [2.0, 2, 3]
{% endhighlight %}


でも実際には、次のようなエラーが返ります。
{% highlight ruby %}
# ~> -:14:in `+': Array can't be coerced into Fixnum (TypeError)
{% endhighlight %}

Fixnum#+に渡されたArrayは型変換できない、と言っています。で、Arrayに次のようなcoerceメソッドを定義します。

{% highlight ruby %}
class Array
  def coerce(other)
    [Array(other), self]
  end
end
{% endhighlight %}

すると..

{% highlight ruby %}
list = [2,3]
1 + list # => [1, 2, 3]
2.0 + list # => [2.0, 2, 3]
{% endhighlight %}

coerceでother（ここでは数値）をKernel.Arrayで型変換しています。こうすれば、Array#+が呼ばれてlistとの結合が可能になるのです。へぇ〜という感じですが、残念ながらこの手法は、coerceが適用できる数値クラス（Numericのサブクラス）にしか使えません（泣）
{% highlight ruby %}
list = ['world', 'of', 'ruby']
'hello' + list # => 
# ~> -:9:in `+': can't convert Array into String (TypeError)
{% endhighlight %}

とりあえずモンキーパッチでStringに対応します..
{% highlight ruby %}
class String
  alias :__plust__ :+
  def +(other)
    return [self] + other if other.is_a?(Array)
    super
  end
end

list = ['world', 'of', 'ruby']
'hello' + list # => ["hello", "world", "of", "ruby"]
{% endhighlight %}

そしてまた、`Object#method_missing`にご登場いただいて、`+`を未定義のオブジェクトにも対応します（懲りてない^ ^;）...
{% highlight ruby %}
class Object
  def method_missing(name, *args, &blk)
    case name
    when :to_ary then [self]
    when :+ then self.to_ary + args.first
    else super
    end
  end
end

list = [1, 2]
:abc + list # => [:abc, 1, 2]

p1 = Person.new('Charlie', 12, :programmer)
p2 = Person.new('Bob', 29, :teacher)
[p1, p2].inject([]) { |m, x| m + x } # => ["Charlie/12/programmer", "Bob/29/teacher"]
[p1, p2].inject([]) { |m, x| x + m } # => ["Bob/29/teacher", "Charlie/12/programmer"]
{% endhighlight %}


「素直に`[]`付けろよ」というブコメが聞こえてきたので、そろそろこの投稿を終了させて頂きます m(__)m

----
coerceの活用は、{{ 4873113946 | amazon_link }}の「7.1.6 演算子の定義」の説明を参考にしました。


