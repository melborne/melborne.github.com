---
layout: post
title: "怠惰で短気で傲慢な君に贈るRubyの遅延評価"
tagline: "Enumerable#lazyと#memoの紹介"
description: ""
category: 
tags: 
date: 2012-07-06
published: true
---
{% include JB/setup %}

Ruby2.0では`lazy`というメソッドがEnumerableモジュールに追加されるらしいよ。

[yhara/enumerable-lazy · GitHub](https://github.com/yhara/enumerable-lazy/ 'yhara/enumerable-lazy · GitHub')

`lazy`はリストに対する遅延評価を実現するメソッドなんだけど、それで意味がわからないって言うなら、それは、**怠惰で短気で傲慢な君のためのメソッド**だってことだから、喜んでほしいよ。

君のような**怠惰で短気で傲慢な人**っていうのは、よく次のようなことを言うんだよ。

    君　「おい、雑誌持って来い！」
    部下「どの雑誌ですか？」
    君　「全部だよ！」
    部下「全部って、日本で発行されてる雑誌全部ですか？」
    君　「全部ったら、全部だよ、バカが」

        ...

    部下「全部持って来ました。ぜぇ、ぜぇ..。全部で、えっと..」
    君　「冊数なんて、どうでもいんだよ！じゃあ、そこからＡＫＢの記事、全部切り出せ！」
    部下「全部ですか... はっ、はい、分かりました...（まじか..）」

        ...

    部下「はい、切り出しました。全部で、えっと..」
    君　「数なんて、どうでもいいって言ってんだろ、バカが。次は、タイトルのケツに４８くっ付けて、体よくしろ」
    部下「はぁ。わっ、わかりました..」

        ...

    部下「ぜぇ、ぜぇ、ぜぇ...。終わりました...。ぜぇ、ぜぇ、ぜぇ...」
    君　「おっせーなあ。とりあえず５，６個見せろや」
    部下「はい、どうぞ...」

        ...

    君　「あーこれでいいや、用は足りたよ。後は捨てとけ」

    部下「... （殺してやる）」

さすがに君のような人にはみんな付き合いきれないよね。で、当然にRubyもそうだったんだけど、世の中変わったんだね。2.0からは、そんな君のワガママにもRubyは答えてくれるようになるんだ。

{% highlight ruby %}
require "enumerable/lazy"

all_magazine = 'ZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZ'

('A'..all_magazine).lazy.select { |w| w.match 'AKB' }
                        .map { |w| w.sub('AKB', '*\048*') }
                        .take(50).to_a

# => ["*AKB48*", "A*AKB48*", "*AKB48*A", "*AKB48*B", "*AKB48*C", "*AKB48*D", "*AKB48*E", "*AKB48*F", "*AKB48*G", "*AKB48*H", "*AKB48*I", "*AKB48*J", "*AKB48*K", "*AKB48*L", "*AKB48*M", "*AKB48*N", "*AKB48*O", "*AKB48*P", "*AKB48*Q", "*AKB48*R", "*AKB48*S", "*AKB48*T", "*AKB48*U", "*AKB48*V", "*AKB48*W", "*AKB48*X", "*AKB48*Y", "*AKB48*Z", "B*AKB48*", "C*AKB48*", "D*AKB48*", "E*AKB48*", "F*AKB48*", "G*AKB48*", "H*AKB48*", "I*AKB48*", "J*AKB48*", "K*AKB48*", "L*AKB48*", "M*AKB48*", "N*AKB48*", "O*AKB48*", "P*AKB48*", "Q*AKB48*", "R*AKB48*", "S*AKB48*", "T*AKB48*", "U*AKB48*", "V*AKB48*", "W*AKB48*"]
{% endhighlight %}

Ruby1.9で試すなら、`gem install enumerable-lazy`して、`require "Enumerable/lazy"`する必要があるよ。

ここで`lazy`はEnumeratorのサブクラスであるLazyクラスのオブジェクトを返すよ。LazyクラスにはEnumeratorでラップしたselectやmapメソッドが定義してあって、それらが代わりに呼ばれるようになるんだ。lazyしないとselectは直ちにrangeオブジェクトに対する評価を始めるから答えが帰ってこないという事態になるけど、lazyで定義されたselectが呼ばれた場合には、それはEnumeratorでラップされていてその評価を先送りにできるんだよ。

サンプルにあった例も置いておくね。

{% highlight ruby %}
require 'prime'

(1..1.0/0).lazy.map { |n| n**2+1 }
          .select { |n| n.prime? }
          .take(100).to_a
          
# => [2, 5, 17, 37, 101, 197, 257, 401, 577, 677, 1297, 1601, 2917, 3137, 4357, 5477, 7057, 8101, 8837, 12101, 13457, 14401, 15377, 15877, 16901, 17957, 21317, 22501, 24337, 25601, 28901, 30977, 32401, 33857, 41617, 42437, 44101, 50177, 52901, 55697, 57601, 62501, 65537, 67601, 69697, 72901, 78401, 80657, 90001, 93637, 98597, 106277, 115601, 122501, 147457, 148997, 156817, 160001, 164837, 176401, 184901, 190097, 193601, 197137, 215297, 217157, 220901, 224677, 240101, 246017, 287297, 295937, 309137, 324901, 331777, 341057, 352837, 401957, 404497, 414737, 417317, 427717, 454277, 462401, 470597, 476101, 484417, 490001, 495617, 509797, 512657, 547601, 562501, 577601, 583697, 608401, 614657, 665857, 682277, 739601]
{% endhighlight %}

{% highlight ruby %}
require 'date'

date_range = Date.new(2011)..Date.new(9999)
puts date_range.lazy.select { |d| d.day == 13 and d.friday? }.take(10).to_a  
# >> 2011-05-13
# >> 2012-01-13
# >> 2012-04-13
# >> 2012-07-13
# >> 2013-09-13
# >> 2013-12-13
# >> 2014-06-13
# >> 2015-02-13
# >> 2015-03-13
# >> 2015-11-13
{% endhighlight %}

最初に細かいこと考えなくていいから、君のような**怠惰で短気で傲慢な人**にとっては、最高のツールだろ？

##Enumerable#memo
で、これを参考にして簡易版のlazyというか、お手軽に遅延評価するためのメソッド`Enumerable#memo`を考えてみたんだよ！まあ、どこかにもうありそうだけどね...

実装は次のとおりだよ。

{% highlight ruby %}
module Enumerable
  def memo
    Enumerator.new { |y| each { |e| yield(y, e) } }
  end
end
{% endhighlight %}

`memo`はブロックを取るんだけど、ブロックの処理の結果をその第１引数に畳み込むイメージで使うんだ。`memo`を使うと、先の例は次のように書けるよ。
{% highlight ruby %}
all_magazine = 'ZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZ'

('A'..all_magazine).memo { |m, w| m << w if w.match 'AKB' }
                   .memo { |m, w| m << w.sub('AKB', '*\048*') }.take(50)
                   
# => ["*AKB48*", "A*AKB48*", "*AKB48*A", "*AKB48*B", "*AKB48*C", "*AKB48*D", "*AKB48*E", "*AKB48*F", "*AKB48*G", "*AKB48*H", "*AKB48*I", "*AKB48*J", "*AKB48*K", "*AKB48*L", "*AKB48*M", "*AKB48*N", "*AKB48*O", "*AKB48*P", "*AKB48*Q", "*AKB48*R", "*AKB48*S", "*AKB48*T", "*AKB48*U", "*AKB48*V", "*AKB48*W", "*AKB48*X", "*AKB48*Y", "*AKB48*Z", "B*AKB48*", "C*AKB48*", "D*AKB48*", "E*AKB48*", "F*AKB48*", "G*AKB48*", "H*AKB48*", "I*AKB48*", "J*AKB48*", "K*AKB48*", "L*AKB48*", "M*AKB48*", "N*AKB48*", "O*AKB48*", "P*AKB48*", "Q*AKB48*", "R*AKB48*", "S*AKB48*", "T*AKB48*", "U*AKB48*", "V*AKB48*", "W*AKB48*"]
{% endhighlight %}

つまり、ブロックの中でifを使えばselectになって、unlessを使えばrejectになって、条件分岐がなければmapになる、ってことだね。だからmemoを使ってselect, reject, mapを定義するなら次のようになるよ。

{% highlight ruby %}
module Enumerable
  def sel
    memo { |y, e| y << e if yield(e) }
  end

  def rej
    memo { |y, e| y << e unless yield(e) }
  end

  def mp
    memo { |y, e| y << yield(e) }
  end

  def memo
    Enumerator.new { |y| each { |e| yield(y, e) } }
  end
end
{% endhighlight %}

残りの２つの例でmemoを使ったものも示すよ。

{% highlight ruby %}
require 'prime'

(1..1.0/0).memo {|m, n| m << n**2+1 }
          .memo {|m, n| m << n if n.prime? }.take(100)
          
# => [2, 5, 17, 37, 101, 197, 257, 401, 577, 677, 1297, 1601, 2917, 3137, 4357, 5477, 7057, 8101, 8837, 12101, 13457, 14401, 15377, 15877, 16901, 17957, 21317, 22501, 24337, 25601, 28901, 30977, 32401, 33857, 41617, 42437, 44101, 50177, 52901, 55697, 57601, 62501, 65537, 67601, 69697, 72901, 78401, 80657, 90001, 93637, 98597, 106277, 115601, 122501, 147457, 148997, 156817, 160001, 164837, 176401, 184901, 190097, 193601, 197137, 215297, 217157, 220901, 224677, 240101, 246017, 287297, 295937, 309137, 324901, 331777, 341057, 352837, 401957, 404497, 414737, 417317, 427717, 454277, 462401, 470597, 476101, 484417, 490001, 495617, 509797, 512657, 547601, 562501, 577601, 583697, 608401, 614657, 665857, 682277, 739601]
{% endhighlight %}

{% highlight ruby %}
require 'date'

date_range = Date.new(2011)..Date.new(9999)
puts date_range.memo { |m, d| m << d if d.day == 13 and d.friday? }.take(10)

# >> 2011-05-13
# >> 2012-01-13
# >> 2012-04-13
# >> 2012-07-13
# >> 2013-09-13
# >> 2013-12-13
# >> 2014-06-13
# >> 2015-02-13
# >> 2015-03-13
# >> 2015-11-13
{% endhighlight %}

ちょっと手軽に遅延評価できる感じで、いいよね？

----

参考資料：

[Route 477 - 「Enumerable#lazy」＠松江RubyKaigi03 ](http://route477.net/d/?date=20110718#p02 'Route 477 - 「Enumerable#lazy」＠松江RubyKaigi03 ')

[enumerabler.rb: Enumerable の遅延評価版メソッドライブラリ - まめめも](http://d.hatena.ne.jp/ku-ma-me/20091111/p2 'enumerabler.rb: Enumerable の遅延評価版メソッドライブラリ - まめめも')

----
{{ 4806713864 | amazon_medium_image }}
{{ 4806713864 | amazon_link }} by {{ 4806713864 | amazon_authors }}





