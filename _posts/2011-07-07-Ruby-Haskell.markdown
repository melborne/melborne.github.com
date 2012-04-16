---
layout: post
title: RubyでHaskellの数列リストを真似てみよう！
date: 2011-07-07
comments: true
categories:
tags: [ruby, haskell]
---

HaskellのリストはRubyの配列と同じように、要素をカンマ区切りのカッコで区切って生成できるんだ。
{% highlight haskell %}
Hugs> [1, 2, 3]
[1,2,3]
Hugs> ['a', 'b', 'c']
"abc"
Hugs> ["one", "two", "three"]
["one","two","three"]
{% endhighlight %}

だけどHaskellのリストはRubyの配列よりもその記法に柔軟性があり、新しい集合を作るための演算式を書けるリスト内包表記や、数列を簡単に生成できる便利な記法があるんだよ。

数列を生成する記法は以下のような感じだよ。
{% highlight haskell %}
Hugs> [1..10]
[1,2,3,4,5,6,7,8,9,10]
Hugs> [21..31]
[21,22,23,24,25,26,27,28,29,30,31]
Hugs> ['a'..'m']
"abcdefghijklm"
{% endhighlight %}
Haskellでは文字列は文字のリストなので、最後の結果はaからmの文字列になるんだね。

Rubyで上の式をそのまま書くと、１つのRangeオブジェクトをもつ配列と解釈されちゃうんだけど、*(splat)展開を使うと同じことができるんだよ。
{% highlight ruby %}
[*1..10] #=> [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]
[*21..31] #=> [21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31]
[*'a'..'m'] #=> ["a", "b", "c", "d", "e", "f", "g", "h", "i", "j", "k", "l", "m"]
{% endhighlight %}
これは[以前の投稿]({{ site.url }}/2011/06/22/notitle/)でも紹介したよね。

でもHaskellの数列展開ではさらに次のようなこともできちゃうんだよ。
{% highlight haskell %}
Hugs> [1, 3..10]
[1,3,5,7,9]
Hugs> [0, 5..50]
[0,5,10,15,20,25,30,35,40,45,50]
Hugs> [1.1, 2.3..10]
[1.1,2.3,3.5,4.7,5.9,7.1,8.3,9.5]
Hugs> ['a', 'c'..'m']
"acegikm"
Hugs> ['A', 'I'..'z']
"AIQYaiqy"
{% endhighlight %}
すごいよね？いわゆる等差数列が簡単にできちゃった。

それだけじゃないんだ。等差数列の無限リストだってできちゃうんだよ！
{% highlight haskell %}
Hugs> take 20 [1, 9..]
[1,9,17,25,33,41,49,57,65,73,81,89,97,105,113,121,129,137,145,153]
Hugs> take 20 ['A', 'D'..]
"ADGJMPSVY\\_behknqtwz"
{% endhighlight %}
使うかどうかはわからないけど、なんかかっこいいよねZen-Codingみたいで！

そんなわけで..

Rubyでもこれと似たようなことをできるようにしてみるね。

Rubyでは[1, 3..10]も有効な構文なので、これをそのまま展開するのは都合が悪いよね。だからここではArray#to_aを拡張して数列展開するようにしてみるよ。
{% highlight ruby %}
class Array
  alias __to_a__ to_a
  def to_a
    if [Numeric, Range] === self
      n, range = self
      dist = range.begin - n
      res = Enumerator.new { |y| loop { y << n; n += dist } }
      return res.take_while { |i| i <= range.end }
    end
    __to_a__
  end
end
{% endhighlight %}
だいたいこんな感じでどうかな？

配列の要素が数字とRangeのセットの場合に特別な扱いをするよ。if節の条件式の実装はあとで見せるね。最初の数字とRangeの先頭との差distを取って、Enumeratorで等差数列を作るよ。そしてEnumerator#take_whileを使ってRangeの最後までの数列を返すようにする。

if節の条件で使ったArray#===の実装は次のような感じだよ。
{% highlight ruby %}
class Array
  alias __eq__ ===
  def ===(other)
    if self.size == other.size and any? { |item| item.instance_of? Class }
      other = other.to_enum
      return all? { |item| item === other.next }
    end
    __eq__(other)
  end
end
{% endhighlight %}

さあ実行してみるよ。
{% highlight ruby %}
[1,2,3,4].to_a # => [1, 2, 3, 4]
[1..10].to_a # => [1..10]
[1, 3..10].to_a # => [1, 3, 5, 7, 9]
[0, 5..50].to_a # => [0, 5, 10, 15, 20, 25, 30, 35, 40, 45, 50]
{% endhighlight %}
いい感じだね

でもFloatを渡すと..
{% highlight ruby %}
[1.1, 2.3..10].to_a # => [1.1, 2.3, 3.4999999999999996, 4.699999999999999, 5.899999999999999, 7.099999999999998, 8.299999999999997, 9.499999999999996]
{% endhighlight %}
浮動小数点演算における丸め誤差がでちゃうんだ。

bigdecimalというライブラリを使うと、丸め誤差の問題を回避できるようなんだけど、ここではFloat#to_iを改良してごまかしてみるね。
{% highlight ruby %}
class Float
  alias __to_i__ to_i
  def to_i(n=0)
    n > 0 ? (self##*n).__to_i__/10.0**n : __to_i__
  end
end
1.23456.to_i # => 1
1.23456.to_i(1) # => 1.2
1.23456.to_i(2) # => 1.23
1.23456.to_i(3) # => 1.234
{% endhighlight %}
Float#to_iが切り捨てする小数点桁数を引数として取れるようにする。

これを使ってArray#to_aを変更しよう。
{% highlight ruby %}
class Array
  alias __to_a__ to_a
  def to_a(decimal=1)　# 小数点2位以上は引数を渡す
    if [Numeric, Range] === self
      n, range = self
      dist = range.begin - n
      res = Enumerator.new { |y| loop { y << n; n += dist } }
      return res.take_while { |i| i <= range.end }
                .map { |i| i.to_i(decimal) rescue i }  # ここを追加
    end
    __to_a__
  end
end
[1, 3..10].to_a # => [1, 3, 5, 7, 9]
[0, 5..50].to_a # => [0, 5, 10, 15, 20, 25, 30, 35, 40, 45, 50]
[1.1, 2.3..10].to_a # => [1.1, 2.3, 3.4, 4.6, 5.8, 7.0, 8.2, 9.4]
[1.11, 2.32..10].to_a(2) # => [1.11, 2.31, 3.52, 4.73, 5.94, 7.15, 8.36, 9.57]
{% endhighlight %}
いい感じだね！

さあ次はアルファベットの等差数列だ。

ここでもArray#to_aはあまりいじりたくないので、Stringクラスで算術演算できるようにしてみよう。つまりString#+ が数字を受け取ったときはその文字コード分シフトした文字を返すようにする。またString#- を定義して文字を受け取ったときは、その文字コードの差を返すようにする。
{% highlight ruby %}
class String
  alias __plus__ +
  def +(other)
    if other.is_a? Integer
      return (self.ord + other).chr
    end
    __plus__(other)
  end
  def -(other)
    case other
    when String
      self.ord - other.ord
    when Integer
      (self.ord - other).chr
    else
      raise ArgumentError
    end
  end
end
'a' + 5 # => "f"
'f' - 'a' # => 5
'f' - 5 # => "a"
{% endhighlight %}
なんとなく汎用性がありそうだよね。

こうすればArray#to_aは条件判定のNumericをObjectに代えるだけでいい{% fn_ref 1 %}。
{% highlight ruby %}
class Array
  alias __to_a__ to_a
  def to_a(decimal=1)
    if [Object, Range] === self # NumericをObjectに変更
      n, range = self
      dist = range.begin - n
      res = Enumerator.new { |y| loop { y << n; n += dist } }
      return res.take_while { |i| i <= range.end }
                .map { |i| i.to_i(decimal) rescue i }
    end
    __to_a__
  end
end
['a', 'c'..'m'].to_a # => ["a", "c", "e", "g", "i", "k", "m"]
['A', 'I'..'z'].to_a # => ["A", "I", "Q", "Y", "a", "i", "q", "y"]
[1, 3..10].to_a # => [1, 3, 5, 7, 9]
[0, 5..50].to_a # => [0, 5, 10, 15, 20, 25, 30, 35, 40, 45, 50]
[1.1, 2.3..10].to_a # => [1.1, 2.3, 3.4, 4.6, 5.8, 7.0, 8.2, 9.4]
[1.11, 2.32..10].to_a(2) # => [1.11, 2.31, 3.52, 4.73, 5.94, 7.15, 8.36, 9.57]
{% endhighlight %}
うまくいったね。

さあ、最後は無限リストだ。Rubyでは[1, 3..]という記法は構文エラーになるので、Rangeの最後が-1(文字の場合は'-1')なら無限リストにするのはどうかな。

Array#to_aの変更は簡単だよ。
{% highlight ruby %}
class Array
  alias __to_a__ to_a
  def to_a(decimal=1)
    if [Object, Range] === self
      n, range = self
      dist = range.begin - n
      res = Enumerator.new { |y| loop { y << n; n += dist } }
      unless range.end.to_s.to_i < 0   # ここを追加
        return res.take_while { |i| i <= range.end }
                  .map { |i| i.to_i(decimal) rescue i }
      else
        return res                     # ここを追加
      end
    end
    __to_a__
  end
end
{% endhighlight %}
Array#to_aの内部ではEnumeratorを使っているのでEnumerable#take_whileしなければそのまま無限リストが返るよ。

さあ実行してみよう。
{% highlight ruby %}
[1, 9..-1].to_a.take 20 # => [1, 9, 17, 25, 33, 41, 49, 57, 65, 73, 81, 89, 97, 105, 113, 121, 129, 137, 145, 153]
['A', 'D'..'-1'].to_a.take 20 # => ["A", "D", "G", "J", "M", "P", "S", "V", "Y", "\\", "_", "b", "e", "h", "k", "n", "q", "t", "w", "z"]
{% endhighlight %}
うまくいったよ！

Haskellには敵わないけど、Rubyも柔軟だってことがこの投稿で伝わったらうれしいよ。

(追記：2011-7-9)
ああ、Rubyには偉大なるRange#stepがあったんだね。通りすがりさんありがとう！

だからわざわざ上のようなことをしなくても大体のことはできるんだよ。
{% highlight ruby %}
(1..10).to_a #=> [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]
(1..10).step(2).to_a #=> [1, 3, 5, 7, 9]
(1.1..10).step(1.2).to_a #=> [1.1, 2.3, 3.5, 4.699999999999999, 5.9, 7.1, 8.299999999999999, 9.5]
('a'..'m').step(2).to_a #=> ["a", "c", "e", "g", "i", "k", "m"]
('A'..'z').step('I'.ord-'A'.ord).to_a #=> ["A", "I", "Q", "Y", "a", "i", "q", "y"]
{% endhighlight %}

またNumeric#stepもあるから数字なら以下のように書いてもいいよね。
{% highlight ruby %}
1.step(10).to_a #=> [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]
1.step(10, 2).to_a #=> [1, 3, 5, 7, 9]
1.1.step(10, 1.2).to_a #=> [1.1, 2.3, 3.5, 4.699999999999999, 5.9, 7.1, 8.299999999999999, 9.5]
{% endhighlight %}

こうなるとString#stepもほしいよね。こんな感じかな？
{% highlight ruby %}
class String
  def step(last, nxt=self.next)
    x, dist = self.ord, nxt.ord-self.ord
    Enumerator.new { |y|
      until x > last.ord
        y << x.chr
        x += dist
      end
    }
  end
end
'a'.step('m', 'c').to_a # => ["a", "c", "e", "g", "i", "k", "m"]
'A'.step('z', 'I').to_a # => ["A", "I", "Q", "Y", "a", "i", "q", "y"]
'a'.step('m').to_a # => ["a", "b", "c", "d", "e", "f", "g", "h", "i", "j", "k", "l", "m"]
{% endhighlight %}

{% gist 1069573 haskell_sequence.rb %}

(comment)
>(1..4).to_a  # => [1, 2, 3, 4]<br><br>(1..10).step(2).to_a # => [1, 3, 5, 7, 9]<br><br>(0..50).step(5).to_a # => [0, 5, 10, 15, 20, 25, 30, 35, 40, 45, 50]<br><br>(1.1 .. 10).step(1.2).to_a # => [1.1, 2.3, 3.5, 4.7, 5.9, 7.1, 8.3, 9.5]
>>通りすがりさん<br>コメントどうもです。あーなんという... そうですRubyにはRange#stepがあったのですよね..


{% footnotes %}
   {% fn 手抜きですね^ ^; %}
{% endfootnotes %}
