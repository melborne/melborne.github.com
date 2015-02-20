---
layout: post
title: "Ruby的FizzBuzz"
description: ""
category: 
tags: 
date: 2014-08-10
published: true
---
{% include JB/setup %}

[最終鬼畜FizzBuzz大全 - Qiita](http://qiita.com/tadsan/items/51d39ec7b49a8e8ee7fd "最終鬼畜FizzBuzz大全 - Qiita")に刺激を受けて、[Qiita](http://qiita.com/merborne/items/15b4bbdb2bf46d7ad0c0 "Ruby的FizzBuzz - Qiita")のほうにポストしてみたんだけど、こちらは解説付きで。

## Ruby的FizzBuzz - その１

<br/>

{% highlight ruby %}
class FB
  def FizzBuzz(n)
    (n%15)==0
  end

  def Fizz(n)
    (n%3)==0
  end

  def Buzz(n)
    (n%5)==0
  end

  def self.call(n)
    instance_methods(false).detect { |m| new.send(m, n) } || n
  end
end

(1..100).each { |i| printf "%s ", FB.call(i) }

# >> 1 2 Fizz 4 Buzz Fizz 7 8 Fizz Buzz 11 Fizz 13 14 FizzBuzz 16 17 Fizz 19 Buzz Fizz 22 23 Fizz Buzz 26 Fizz 28 29 FizzBuzz 31 32 Fizz 34 Buzz Fizz 37 38 Fizz Buzz 41 Fizz 43 44 FizzBuzz 46 47 Fizz 49 Buzz Fizz 52 53 Fizz Buzz 56 Fizz 58 59 FizzBuzz 61 62 Fizz 64 Buzz Fizz 67 68 Fizz Buzz 71 Fizz 73 74 FizzBuzz 76 77 Fizz 79 Buzz Fizz 82 83 Fizz Buzz 86 Fizz 88 89 FizzBuzz 91 92 Fizz 94 Buzz Fizz 97 98 Fizz Buzz 
{% endhighlight %}

### 解説

1. `FB.call`の`instance_methods(false)`は、FBクラスに定義されたインスタンスメソッド名つまり`:FizzBuzz`, `:Fizz`, `:Buzz`の配列をそれらが定義された並びで返します。
2. `detect`のブロックでは各メソッドが、callに渡された引数nを引数に呼び出されます。
3. 各メソッドでは引数がそれぞれの基数で割り切れるかが判定されますが、`detect`では最初にtrueを返したメソッド名が返ることになります。例えばnが15のときは何れのメソッドの返り値もtrueになりますが、最初に評価される`:FizzBuzz`が返ります。
4. 全メソッドの評価がfalseのときはdetectの返り値はnilになるので、`||`の右辺が実行され、結果引数nがそのまま返されることになります。

### アピールポイント

1. 文字列ではなくメソッド名に基いて出力の文字列を構成した点。
2. 分岐的制御構造を使っていない点。


## Ruby的FizzBuzz - その２

<br/>

{% highlight ruby %}
class FB
  def Fizz(n)
    (n%3)==0
  end

  def Buzz(n)
    (n%5)==0
  end

  def self.call(n)
    instance_methods(false).select { |m| new.send(m, n) }
                           .map(&:to_s).inject(:+) || n
  end
end

(1..100).each { |i| printf "%s ", FB.call(i) }

# >> 1 2 Fizz 4 Buzz Fizz 7 8 Fizz Buzz 11 Fizz 13 14 FizzBuzz 16 17 Fizz 19 Buzz Fizz 22 23 Fizz Buzz 26 Fizz 28 29 FizzBuzz 31 32 Fizz 34 Buzz Fizz 37 38 Fizz Buzz 41 Fizz 43 44 FizzBuzz 46 47 Fizz 49 Buzz Fizz 52 53 Fizz Buzz 56 Fizz 58 59 FizzBuzz 61 62 Fizz 64 Buzz Fizz 67 68 Fizz Buzz 71 Fizz 73 74 FizzBuzz 76 77 Fizz 79 Buzz Fizz 82 83 Fizz Buzz 86 Fizz 88 89 FizzBuzz 91 92 Fizz 94 Buzz Fizz 97 98 Fizz Buzz 
{% endhighlight %}


### 解説

1. その１の発展型です。
2. `FB.call`では、`detect`に代えて`select`を使い、trueを返すメソッドをすべて返すようにしています。例えば、nが15のときは`:Fizz`, `:Buzz`の両方が返ります。
3. 配列内のシンボル値を`to_s`した後、`inject(:+)`でそれらを連結します。nが3のときは要素が`:Fizz`だけなので`Fizz`が返りますが、15のときは`:Fizz`, `:Buzz`が連結されて`FizzBuzz`が返ります。
4. `Array#join`を使うという手もありましたが、空配列が`""`（空文字）になってしまうので、あとの処理が面倒なので避けました。


### アピールポイント

1. selectを使い、Fizz, Buzzの２つのメソッドだけで３種類の出力をできるようにした点。

<br/>

---

御社採用、ご検討のほど、よろしくお願い申し上げますm(__)m

