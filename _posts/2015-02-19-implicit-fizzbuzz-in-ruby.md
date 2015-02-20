---
layout: post
title: "Rubyによる暗黙のFizzBuzzの世界"
description: ""
category: 
tags: 
date: 2015-02-19
published: true
---
{% include JB/setup %}

[Rubyによる不適切なFizzBuzzの世界 - Qiita](http://qiita.com/supermomonga/items/b8faf7441ada9c310282 "Rubyによる不適切なFizzBuzzの世界 - Qiita")が、FizzBuzzerを刺激するから...。


## 1. FizzBuzz with to_proc

{% highlight ruby %}
class FizzBuzz
  def self.to_proc
    ->n{ 
      case 0
      when n % 15 then :FizzBuzz
      when n % 3  then :Fizz
      when n % 5  then :Buzz
      else n
      end
    }
  end
end

puts (1..100).map(&FizzBuzz) # => [1, 2, :Fizz, 4, :Buzz, :Fizz, 7, 8, :Fizz, :Buzz, 11, :Fizz, 13, 14, :FizzBuzz, 16, 17, :Fizz, 19, :Buzz, :Fizz, 22, 23, :Fizz, :Buzz, 26, :Fizz, 28, 29, :FizzBuzz, 31, 32, :Fizz, 34, :Buzz, :Fizz, 37, 38, :Fizz, :Buzz, 41, :Fizz, 43, 44, :FizzBuzz, 46, 47, :Fizz, 49, :Buzz, :Fizz, 52, 53, :Fizz, :Buzz, 56, :Fizz, 58, 59, :FizzBuzz, 61, 62, :Fizz, 64, :Buzz, :Fizz, 67, 68, :Fizz, :Buzz, 71, :Fizz, 73, 74, :FizzBuzz, 76, 77, :Fizz, 79, :Buzz, :Fizz, 82, 83, :Fizz, :Buzz, 86, :Fizz, 88, 89, :FizzBuzz, 91, 92, :Fizz, 94, :Buzz, :Fizz, 97, 98, :Fizz, :Buzz]
{% endhighlight %}

## 2. FizzBuzz with coerce

{% highlight ruby %}
module Base
  def div_by(base, n)
    !n.is_a?(Fixnum) || (n % base).zero? ? self : n
  end

  def coerce(n)
    [self, n]
  end
end

class FizzBuzz
  extend Base
  class << self
    def |(n)
      div_by(15, n)
    end
  end
end

class Fizz
  extend Base
  class << self
    def |(n)
      div_by(3, n)
    end
  end
end

class Buzz
  extend Base
  class << self
    def |(n)
      div_by(5, n)
    end
  end
end

puts (1..100).map { |n| n | FizzBuzz | Fizz | Buzz  } # => [1, 2, Fizz, 4, Buzz, Fizz, 7, 8, Fizz, Buzz, 11, Fizz, 13, 14, FizzBuzz, 16, 17, Fizz, 19, Buzz, Fizz, 22, 23, Fizz, Buzz, 26, Fizz, 28, 29, FizzBuzz, 31, 32, Fizz, 34, Buzz, Fizz, 37, 38, Fizz, Buzz, 41, Fizz, 43, 44, FizzBuzz, 46, 47, Fizz, 49, Buzz, Fizz, 52, 53, Fizz, Buzz, 56, Fizz, 58, 59, FizzBuzz, 61, 62, Fizz, 64, Buzz, Fizz, 67, 68, Fizz, Buzz, 71, Fizz, 73, 74, FizzBuzz, 76, 77, Fizz, 79, Buzz, Fizz, 82, 83, Fizz, Buzz, 86, Fizz, 88, 89, FizzBuzz, 91, 92, Fizz, 94, Buzz, Fizz, 97, 98, Fizz, Buzz]
{% endhighlight %}

ちょっと挙動がユニークだけど...

変態度が足りませんでしたm(__)m


(追記：2015-02-20)　親切な解説を追加しました。

## FizzBuzz with to_procの親切な解説

Rubyではメソッドに引数を渡すとき、`&`を前置するとそれをProcオブジェクトと理解しメソッドの実体に渡します。

{% highlight ruby %}
def do_proc(&proc)
  proc.call
end

# または、
def do_proc
  yield
end

proc = ->{ 'hey!' }

do_proc(&proc) # => "hey!"
{% endhighlight %}

`&`を前置してProcオブジェクト以外のものを渡してみます。

{% highlight ruby %}
def do_proc(&proc)
  proc.call
end

proc = 'hey!'

do_proc(&proc) # => 
# ~> -:12:in `<main>': wrong argument type String (expected Proc) (TypeError)
{% endhighlight %}

Procが期待されているとのエラーが吐かれました。

しかしRubyではそれを単に拒絶するのではなく、まずは渡されたオブジェクトがProcオブジェクトになり得るかを試す、つまりそのオブジェクトの`to_proc`メソッドを暗黙的にコールするのです。

'hey!'オブジェクトにto_procを定義して再度試してみます。

{% highlight ruby %}
proc = 'hey!'

def proc.to_proc
  ->{ self }
end

do_proc(&proc) # => "hey!"
{% endhighlight %}

うまくいきました。

FizzBuzz with to_procではRubyのこの仕組みを利用しています。

`FizzBuzz.to_proc`の中身は、@supermomongaさんによる`case 0`を使わせてもらいました。エレガントです。解説は次の記事を参照して下さい。

[Rubyによる不適切なFizzBuzzの世界 - Qiita](http://qiita.com/supermomonga/items/b8faf7441ada9c310282 "Rubyによる不適切なFizzBuzzの世界 - Qiita")


## FizzBuzz with coerceの親切な解説

Rubyにおいて演算子の多くはメソッド呼び出しです。

つまりこれらは、

{% highlight ruby %}
1 + 2 # => 3
3 - 4 # => -1
5 * 6 # => 30
7 / 8 # => 0
{% endhighlight %}

以下のシンタックスシュガーです。

{% highlight ruby %}
1.+(2) # => 3
3.-(4) # => -1
5.*(6) # => 30
7./(8) # => 0
{% endhighlight %}

次のコードは、Rubyにおけるビット二項演算で論理和を求めるものですが、

{% highlight ruby %}
1 | 0 # => 1
0 | 1 # => 1
1 | 1 # => 1
0 | 0 # => 0
{% endhighlight %}

これは`Fixnum#|`として実装されています。

FizzBuzz with coerceではこの`Fixnum#|`を呼んでいます。

{% highlight ruby %}
puts (1..100).map { |n| n | FizzBuzz | Fizz | Buzz  }
{% endhighlight %}

mapのブロックの中で、最初にnとFizzBuzzクラスオブジェクトの論理和を求めています。

通常、`Fixnum#|`はその引数としてFixnumを期待しますが、それ以外のオブジェクトを渡すとどうなるかやってみます。

{% highlight ruby %}
class FizzBuzz

end

3 | FizzBuzz # => 
# ~> -:22:in `|': Class can't be coerced into Fixnum (TypeError)
# ~> 	from -:22:in `<main>'
{% endhighlight %}

クラスはFixnumにcoerce（強制型変換）できないとのエラーが吐かれました。

これでRubyがFizzBuzzクラスオブジェクトをFixnumに型変換、つまり`FizzBuzz.coerce`を暗黙的にコールしていることが分かりました。

これを実装してみます。

{% highlight ruby %}
class FizzBuzz
  def self.coerce(n)
    return n, 4
  end
end

3 | FizzBuzz # => 7
{% endhighlight %}

coerceでは、呼び出し元のオブジェクトを引数に取って、演算子の２つのオペランドが返るようにします。これにより`Fixnum#|`はこれらの値で実行されることになります。

ここでcoerceの最初の返り値に別のオブジェクトを渡すと、`Fixnum#|`の代わりにそのオブジェクトの`|`メソッドが呼ばれる、つまり`a_object#|`が実行されるようになります。

`FizzBuzz.|`を定義して、やってみます。

{% highlight ruby %}
class FizzBuzz
  def self.|(n)
    "#{n} received!"
  end

  def self.coerce(n)
    return self, n
  end
end

3 | FizzBuzz # => "3 received!"
{% endhighlight %}

FizzBuzz with coerceではこのテクニックを使って、`Fixnum#|`の代わりに`FizzBuzz.|`が呼ばれるようにしています。

さて、次にFizzBuzz with coerceにおける`FizzBuzz.|`の実装を見てみます。

{% highlight ruby %}
class FizzBuzz
  def self.|(n)
    !n.is_a?(Fixnum) || (n%15).zero? ? self : n
  end

  def self.coerce(n)
    return self, n
  end
end

3 | FizzBuzz # => 3
5 | FizzBuzz # => 5
15 | FizzBuzz # => FizzBuzz
{% endhighlight %}

nが１５で割り切れる場合はFizzBuzzクラスが、それ以外の場合はnが返ります。そしてFizzBuzz with coerceではこの値は次の段、つまりFizzとの演算に渡されます。

{% highlight ruby %}
3 | Fizz # => Fizz
5 | Fizz # => 5
FizzBuzz | Fizz # => FizzBuzz
{% endhighlight %}

Fizzクラスの実装は除算の基数が３である以外はFizzBuzzと同じです。よって、上の２つの場合は、FizzBuzzクラスと同様に動作し、nが３で割り切れる場合はFizzクラスが、それ以外の場合はnが返ることになります。

一方、FizzBuzzとFizzの演算では、FizzBuzzクラスの`|`メソッドが再度呼ばれることになります（ここがユニークなところです）。そしてその結果としてFizzBuzzクラスが返り、次の段に渡されることになります。

Buzzクラスでもこれと同様のことが起こり、一旦途中でFizzBuzz系クラスに変換されると、それがフォールスルーして最後まで維持されることになります。


