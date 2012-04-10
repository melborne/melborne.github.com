---
layout: post
title: Enumerable#thread_withでRubyのスレッドを簡単に使おう！
date: 2011-06-29
comments: true
categories:
---


前回の投稿ではsleep sortと
それに対抗したrunning sortを紹介したよ

[sleep sortに対抗してrunning sortだ！（失敗に終わる編）](/2011/06/28/sleep-sort-running-sort/)

それらのアルゴリズムではRubyのThreadを使ったけど
Threadってなんか毎回書き方を忘れるよ
引数の受け渡し方とかjoinとか
もっと簡単にスレッディングしたいのにねぇ...

それでEnumerableなオブジェクトに対して
渡したブロックを並列処理してくれる
メソッドがあれば便利かなと考えたんだよ
それならスレッドの実装のことを忘れて
対象の処理のことだけ考えればいいからね

で
Enumerable#thread_withというメソッドを書いてみたよ{% fn_ref 1 %}
{% highlight ruby %}
module Enumerable
  def thread_with
    mem = []
    map do |*item|
      Thread.new(*item) do |*_item|
        mem << yield(*_item)
      end
    end.each(&:join)
    mem
  end
end
{% endhighlight %}
Enumerable#thread_withがあれば
sleep sortは簡単だよ
{% highlight ruby %}
a = (1..10).sort_by { rand } # => [9, 3, 10, 8, 4, 5, 7, 2, 6, 1]
a.thread_with { |i| sleep i } # => [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]
{% endhighlight %}

効率を良くしたければ
次のようにすればいいし
{% highlight ruby %}
a = (1..10).sort_by { rand } # => [9, 3, 10, 8, 4, 5, 7, 2, 6, 1]
a.thread_with { |i| sleep Math.log(i); i } # => [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]
{% endhighlight %}

もう少し真面目な例を挙げるね

複数のWebサイトに並列的にアクセスして
そこからimgタグを拾ってくる例を示すよ
ここではベンチマークを取って
スレッドを使わない例と比べているよ
{% highlight ruby %}
require "benchmark"
require "open-uri"
a = %w(www.nintendo.co.jp www.google.com www.yahoo.co.jp www.nikkei.com www.ruby-lang.org)
blk = ->item { open("http://#{item}").read.scan(/<img .*?>/) }
Benchmark.bmbm do |x|
  x.report { a.map(&blk)  }
  x.report { a.thread_with(&blk) }
end
# >> Rehearsal ------------------------------------
# >>    0.110000   0.040000   0.150000 (  1.112704)
# >>    0.020000   0.020000   0.040000 (  0.243304)
# >> --------------------------- total: 0.190000sec
# >> 
# >>        user     system      total        real
# >>    0.040000   0.010000   0.050000 (  0.756259)
# >>    0.020000   0.010000   0.030000 (  0.242218)
{% endhighlight %}
なんかThreadが身近になった感じがしない？

ただ先の実装には１つ問題があるよ
それはもとの配列の順位がthread_withの返り値として
保証されないことだよ{% fn_ref 2 %}
{% highlight ruby %}
a = (1..1000).map { |i| i**2 }
b = (1..1000).thread_with { |i| i**2 }
a == b # => false
{% endhighlight %}

でも以下のようにすれば一応もとの順位は保証できるんだ
{% highlight ruby %}
module Enumerable
  def thread_with(order=false)
    mem = []
    map.with_index do |*item, i|
      Thread.new(*item) do |*_item|
        mem << [i, yield(*_item)]
      end
    end.each(&:join)
    (order ? mem.sort : mem).map(&:last)
  end
end

a = (1..1000).map { |i| i**2 }
b = (1..1000).thread_with(true) { |i| i**2 }
a == b # => true
{% endhighlight %}
つまりthread_withが引数を取るようにして
trueを渡せば
最後にもとの配列の順位にソートしてくれる

まあ
たいしたネタじゃなかったね..
{% footnotes %}
   {% fn まあThreadの使い方そのまんまなんだけど.. %}
   {% fn まあそれがスレッドなんだけど %}
{% endfootnotes %}
