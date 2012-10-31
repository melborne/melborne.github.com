---
layout: post
title: "TapがRubyの新たな制御構造の世界を開く"
description: ""
category: 
tags: 
date: 2012-10-29
published: true
---
{% include JB/setup %}

`Object#tap`はそのブロックの評価結果を捨てるという風変わりなメソッドです。これは主としてメソッドチェーンにおける途中経過を覗き見るために使われます。

{% highlight ruby %}
"charlie".upcase.tap{ |s| p s }   # => "CHARLIE"
         .reverse.tap{ |s| p s }  # => "EILRAHC"
         .gsub(/[aeiou]/i,'*')    # => "**LR*HC"
{% endhighlight %}

## tapの副作用を使う
もっとも、その**評価結果を捨てる**というユニークな特徴をうまく使えば、もっと面白いことができます。

例えば、ある変数の値を取得した上でその変数の値をリセットしたい場合を考えます。通常は次のように実装するのでしょう。
{% highlight ruby %}
@name = 'Charlie'

def reset_name
   name = @name
   @name = nil
   name
end

reset_name # => "Charlie"
@name # => nil
{% endhighlight %}
ローカル変数を用意するのが少しまどろっこしく感じられます。

しかし`tap`を使えばより簡潔に書くことができます。

{% highlight ruby %}
@name = 'Charlie'
def reset_name
   @name.tap { @name = nil }
end

reset_name # => "Charlie"
@name # => nil
{% endhighlight %}

「[Rubyのtapはメソッドチェーンだけのものじゃない!](http://melborne.github.com/2011/12/15/Ruby-tap/ 'Rubyのtapはメソッドチェーンだけのものじゃない!')」より

## tapの返り値を使う

`tap`を`break`と組み合わせると、更に面白いことができます。

配列要素の平均値を求める例を示します。通常以下のようにします。
{% highlight ruby %}
scores = [56, 87, 49, 75, 90, 63, 65]
scores.inject(:+) / scores.size # => 69
{% endhighlight %}

これは`tap`と`break`を使って一行にすることができます。

{% highlight ruby %}
avg = [56, 87, 49, 75, 90, 63, 65].tap { |sco| break sco.inject(:+) / sco.size } # => 69
{% endhighlight %}
つまりtapのブロックでbreakするとその結果を返り値にできるのです。

「[Object#doメソッドというのはありですか？](http://melborne.github.com/2012/06/13/objectdo/ 'Object#doメソッドというのはありですか？')」より

## tapを存在演算子として使う
さらに`tap`はCoffeeScriptの存在演算子のようにも使うことができます。

例を示します。ここでは各学生の数学の結果を出力したいとします。
{% highlight ruby %}
Student = Struct.new(:name, :age, :scores)
charlie = Student['Charlie', 14]
liz = Student['Liz', 14]

charlie.scores = { math:35, english:78, music:60 }

students = [charlie, liz]

students.each do |st|
  math = st.scores[:math]
  puts "#{st.name}'s math is #{math}"
end

# >> Charlie's math is 35
# >> NoMethodError: undefined method `[]' for nil:NilClass
{% endhighlight %}
この例で`liz`はまだ試験を受けていないので`scores`の値はnilであり、その結果`scores[:math]`の呼び出しはエラーになってしまいます。

次にtapを使ったエラー回避策を示します。

{% highlight ruby %}
students.each do |st|
  math = st.scores.tap{ |s| break s[:math] if s }
  puts "#{st.name}'s math is #{math}"
end

# >> Charlie's math is 35
# >> Liz's math is 
{% endhighlight %}
scoresがあるときはbreakでブロックの結果が返され、scoresがnilのときはtapの挙動通りブロックの結果は無視されてsocoresつまりnilが返ります。

「[Rubyに存在演算子は存在するの？](http://melborne.github.com/2012/10/29/existential-operator-in-ruby/ 'Rubyに存在演算子は存在するの？')」より

## tapを制御構造として使う

上記の使い方を更に一歩進めると、tapは制御構造としても機能するようになります。

まずは偶数判定をするeven?メソッドをtapで定義してみます。

{% highlight ruby %}
def even?(n)
  n.tap { |i| break false if (i%2)!=0 }
   .tap { |i| break true if i }
end

(1..10).map { |i| even? i } # => [false, true, false, true, false, true, false, true, false, true]
{% endhighlight %}
tapを２つ繋いで処理を振り分けています。一見、２つ目のtapにおけるif修飾子は要らないように思われますが、これは必須です。なぜならtapにおけるbreakはフォールスルーの如くに機能するからです。つまり奇数が渡された場合も２つ目のブロックは評価されます。

次に、FizzBuzzをやってみます。

{% highlight ruby %}
def fizzbuzz(n)
  n.tap { |s| break :Fizz if (n%3)==0 }
   .tap { |s| break :Buzz if (n%5)==0 }
   .tap { |s| break :FizzBuzz if (n%15)==0 }
end

(1..100).each { |i| printf "%s ", fizzbuzz(i) }

# >> 1 2 Fizz 4 Buzz Fizz 7 8 Fizz Buzz 11 Fizz 13 14 FizzBuzz 16 17 Fizz 19 Buzz Fizz 22 23 Fizz Buzz 26 Fizz 28 29 FizzBuzz 31 32 Fizz 34 Buzz Fizz 37 38 Fizz Buzz 41 Fizz 43 44 FizzBuzz 46 47 Fizz 49 Buzz Fizz 52 53 Fizz Buzz 56 Fizz 58 59 FizzBuzz 61 62 Fizz 64 Buzz Fizz 67 68 Fizz Buzz 71 Fizz 73 74 FizzBuzz 76 77 Fizz 79 Buzz Fizz 82 83 Fizz Buzz 86 Fizz 88 89 FizzBuzz 91 92 Fizz 94 Buzz Fizz 97 98 Fizz Buzz 
{% endhighlight %}

ここでは各ブロックにおいてその引数を使わずに、メソッド引数を直接使っています。先のフォールスルーの理屈によりFizzBuzzのブロックが最後に来ているのが特徴的です。

ブロック引数を使った例も示しておきます。この場合、後続のブロックにはSymbolも渡るのでその判定が必要になります。
{% highlight ruby %}
def fizzbuzz(n)
  n.tap { |i| break :FizzBuzz if (i%15)==0 }
   .tap { |i| break :Fizz if i.is_a?(Integer) && (i%3)==0 }
   .tap { |i| break :Buzz if i.is_a?(Integer) && (i%5)==0 }
end

(1..100).each { |i| printf "%s ", fizzbuzz(i) }

# >> 1 2 Fizz 4 Buzz Fizz 7 8 Fizz Buzz 11 Fizz 13 14 FizzBuzz 16 17 Fizz 19 Buzz Fizz 22 23 Fizz Buzz 26 Fizz 28 29 FizzBuzz 31 32 Fizz 34 Buzz Fizz 37 38 Fizz Buzz 41 Fizz 43 44 FizzBuzz 46 47 Fizz 49 Buzz Fizz 52 53 Fizz Buzz 56 Fizz 58 59 FizzBuzz 61 62 Fizz 64 Buzz Fizz 67 68 Fizz Buzz 71 Fizz 73 74 FizzBuzz 76 77 Fizz 79 Buzz Fizz 82 83 Fizz Buzz 86 Fizz 88 89 FizzBuzz 91 92 Fizz 94 Buzz Fizz 97 98 Fizz Buzz 
{% endhighlight %}

ブロック内で`return`を使うことで、フォールスルーを避ける事もできます。

まあ実用性はなさそうですが、面白いので紹介してみました。


`tap`の新しい使い道、あなたも探してみませんか？

----

{{ 4806906557 | amazon_medium_image }}
{{ 4806906557 | amazon_link }} by {{ 4806906557 | amazon_authors }}

