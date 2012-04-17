---
layout: post
title: sleep sortに対抗してrunning sortだ！
tagline: Ruby版｜失敗に終わる編
date: 2011-06-28
comments: true
categories:
---


少し前にsleep sortという
ソートアルゴリズムが発見されたよね

[常識を覆すソートアルゴリズム！その名も"sleep sort"！](http://d.hatena.ne.jp/gfx/20110519/1305810786)

これをRubyのThreadを使って実現すると
だいたい次のようになるんだよ
{% highlight ruby %}
class Array
  def sleep_sort
    mem = []
    map do |i|
      Thread.new(i) do |n|
        sleep n
        mem << n
      end
    end.each(&:join)
    mem
  end
end
a = (1..10).sort_by { rand } # => [1, 2, 10, 6, 4, 5, 9, 7, 8, 3]
a.sleep_sort # => [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]
{% endhighlight %}

美しいよね
これほどシンプルで安定なソートの方法が今さら発見されるなんて
アルゴリズムの世界はほんとうに奥深いね

先のsleep sortの実装では整数のソートしかできないけれど
ちょっと改良すれば文字のソートにも対応できるんだよ
{% highlight ruby %}
class Array
  def sleep_sort
    mem = []
    map do |i|
      Thread.new(i) do |n|
        sleep n.ord         # ここを改良
        mem << n
      end
    end.each(&:join)
    mem
  end
end
a = (1..10).sort_by { rand }
a.sleep_sort
s = ('a'..'g').sort_by { rand }
s.sleep_sort
{% endhighlight %}

実行してみるよ...

...


...


...


...


{% highlight ruby %}
a.sleep_sort # => [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]
s.sleep_sort # => ["a", "b", "c", "d", "e", "f", "g"]
{% endhighlight %}

ね？

...

sleep sortの唯一の小さな欠点は実行時間だね
それはソート対象の最大整数値と線形の関係にあるんだ

でもその問題も以下のようにすれば低減できる
{% highlight ruby %}
class Array
  def sleep_sort
    mem = []
    map do |i|
      Thread.new(i) do |n|
        sleep Math.log(n.ord)        # ここを改良
        mem << n
      end
    end.each(&:join)
    mem
  end
end
t = Time.now
a = (1..10).sort_by { rand } # => [7, 9, 1, 2, 10, 6, 3, 5, 8, 4]
a.sleep_sort # => [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]
Time.now - t # => 2.304315
t = Time.now
s = ('a'..'g').sort_by { rand } # => ["a", "d", "b", "f", "g", "e", "c"]
s.sleep_sort # => ["a", "b", "c", "d", "e", "f", "g"]
Time.now - t # => 4.635888
{% endhighlight %}
sleepにそのままの数値を渡すんじゃなくて
その対数を渡すことによって
最大値との関係は指数の逆数になる

つまりこの例では20倍の高速化！
{% highlight ruby %}
n = 'g'.ord # => 103
Math.log(n) #=> 4.634728988229636
{% endhighlight %}

もうこれで
来るRuby2.0のEnumerable#sortの実装は決まりだね！

と言いたいところだけれど
Rubyはもっと早くならなきゃいけないんだよ
これじゃまたRubyのボトルネックが増えてしまうよ


そんなわけで...

僕もsleep sortに対抗して
running sortというソートアルゴリズムを考えてみたよ!

running sortは各スレッドを
ソートアイテムの整数値に応じてsleepさせるのではなくて
その整数値に応じてより多く走らせるアルゴリズムだよ
実装の一例を示すね
{% highlight ruby %}
class Array
  def running_sort
    ths, mem = [], []
    each_index do |i|
      ths << Thread.new(i, self.dup) do |n, _self; res|
        (n+1).times { res = _self.delete_min }
        mem << res
      end
    end
    ths.each(&:join)
    mem
  end
  def delete_min
    min_idx = find_index { |item| item == self.min }
    delete_at(min_idx)
  end
end
a = (1..10).sort_by { rand } # => [5, 8, 10, 1, 3, 4, 7, 6, 9, 2]
a.running_sort # => [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]
b = [4,2,9,34,8,98,3,2,64]
b.running_sort # => [2, 2, 3, 4, 8, 9, 34, 64, 98]
s = ('a'..'g').sort_by { rand } # => ["g", "c", "d", "f", "a", "b", "e"]
s.running_sort # => ["a", "b", "c", "d", "e", "f", "g"]
{% endhighlight %}
sleep sortのようなソート対象アイテムの制限もないし
実行時間も早いよ{% fn_ref 1 %}

アルゴリズムを簡単に説明すると次のようになるよ

1. 各スレッドにidを付けると共にソート対象の配列selfのコピーを渡す
1. 各スレッドではselfからid番目に小さい値を取り出して、スレッド間での共有メモリmemに入れる{% fn_ref 2 %}
1. id番目に小さい値の取り出しは最小値をid回取り出す操作を繰り返すことにより行い、これによってid値に応じてスレッドの仕事量が変わる

新しいソートアルゴリズムの発見だよ！
これで僕の名前も歴史に刻まれることになるよ！

と
言いたいところだけれど...

ご想像のとおり
スレッド間の処理時間のバラつきにより
これはうまく機能しないんだよ...
{% highlight ruby %}
a = (1..100).sort_by { rand } # => [86, 34, 23, 12, 25, 87, 80, 7, 77, 73, 51, 15, 3, 100, 24, 69, 33, 66, 44, 94, 58, 31, 26, 82, 81, 42, 18, 74, 19, 32, 17, 59, 75, 29, 46, 62, 41, 68, 91, 36, 98, 49, 97, 9, 95, 37, 79, 1, 61, 10, 78, 27, 65, 30, 6, 90, 48, 22, 55, 60, 93, 83, 8, 54, 40, 4, 47, 70, 56, 14, 45, 21, 20, 67, 63, 64, 76, 13, 52, 2, 16, 96, 50, 84, 89, 92, 39, 35, 85, 88, 28, 99, 38, 71, 72, 5, 11, 53, 57, 43]
r1 = a.running_sort # => [1, 2, 3, 4, 5, 7, 8, 11, 12, 14, 16, 18, 6, 9, 13, 17, 20, 21, 22, 23, 24, 25, 26, 27, 29, 30, 31, 33, 34, 36, 37, 39, 41, 43, 45, 47, 49, 51, 53, 55, 57, 59, 61, 63, 65, 67, 70, 72, 76, 77, 81, 85, 89, 94, 10, 15, 19, 32, 35, 38, 40, 42, 46, 48, 52, 56, 60, 64, 68, 69, 73, 74, 79, 80, 83, 84, 87, 88, 91, 92, 93, 96, 97, 28, 44, 50, 54, 62, 71, 78, 82, 86, 90, 98, 99, 100, 58, 75, 95, 66]
s = ('a'..'z').sort_by { rand } # => ["x", "p", "h", "z", "d", "e", "r", "u", "y", "m", "a", "b", "g", "v", "c", "o", "w", "l", "q", "i", "n", "k", "s", "f", "t", "j"]
r2 = s.running_sort # => ["a", "b", "c", "d", "e", "f", "g", "h", "i", "j", "k", "l", "m", "n", "p", "q", "r", "s", "t", "u", "v", "w", "x", "y", "z", "o"]
r1 == a.sort # => false
r2 == s.sort # => false
{% endhighlight %}
いい線いってるんだけどなー...
ファジーソートとかってカテゴリないかな..

関連記事：[Rubyでソート・アルゴリズムを表現しよう!]({{ site.url }}/2010/10/12/Ruby/)
{% footnotes %}
   {% fn 対sleep sort比 %}
   {% fn Array#minを使うのはちょっとルール違反だけど大目にね %}
{% endfootnotes %}
