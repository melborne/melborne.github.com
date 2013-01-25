---
layout: post
title: "Rubyで点数を集計するとき、あなたはどうしてますか？"
description: ""
category: 
tags: 
date: 2013-01-23
published: true
---
{% include JB/setup %}


##─　問題　─

> ５人のプレイヤー（Alice, Bob, Jimmy, Kent, Ross）が二種類のゲーム（gameA, gameB）をそれぞれ３回ずつプレイした結果のデータ**data**がある。

{% highlight ruby %}
data =<<EOS
player gameA gameB
Bob    20    56
Ross   68    33
Bob    78    55
Kent   90    15
Alice  84    79
Ross   10    15
Jimmy  80    31
Bob    12    36
Kent   88    43
Kent   12    33
Alice  90    32
Ross   67    77
Alice  56    92
Jimmy  33    88
Jimmy  11    87
EOS
{% endhighlight %}

> 結果を集計し以下の標準出力を得よ（totalで降順）。

{% highlight bash %}
% ruby game_score.rb
player  gameA gameB total
Alice   230   203   433
Jimmy   124   206   330
Kent    190   91    281
Ross    145   125   270
Bob     110   147   257
{% endhighlight %}

<br />

<br />

簡単そうで意外と手こずったので...

##─　僕のやり方　─

###Step1. ヘッダーとスコアを分離し配列で管理する
まあ普通に。
{% highlight ruby %}
headers, *scores = data.lines.map(&:split)
headers # => ["player", "gameA", "gameB"]
scores # => [["Bob", "20", "56"], ["Ross", "68", "33"], ["Bob", "78", "55"], ["Kent", "90", "15"], ["Alice", "84", "79"], ["Ross", "10", "15"], ["Jimmy", "80", "31"], ["Bob", "12", "36"], ["Kent", "88", "43"], ["Kent", "12", "33"], ["Alice", "90", "32"], ["Ross", "67", "77"], ["Alice", "56", "92"], ["Jimmy", "33", "88"], ["Jimmy", "11", "87"]]
{% endhighlight %}

###Step2. プレイヤー毎に集計する
Enumerable#group_byを使う。
{% highlight ruby %}
scores_by_player = scores.group_by(&:first) # => {"Bob"=>[["Bob", "20", "56"], ["Bob", "78", "55"], ["Bob", "12", "36"]], "Ross"=>[["Ross", "68", "33"], ["Ross", "10", "15"], ["Ross", "67", "77"]], "Kent"=>[["Kent", "90", "15"], ["Kent", "88", "43"], ["Kent", "12", "33"]], "Alice"=>[["Alice", "84", "79"], ["Alice", "90", "32"], ["Alice", "56", "92"]], "Jimmy"=>[["Jimmy", "80", "31"], ["Jimmy", "33", "88"], ["Jimmy", "11", "87"]]}
{% endhighlight %}

###Step3. プレイヤー毎のデータを計算する
Array#transposeがいいんじゃないかと。
{% highlight ruby %}
stat = scores_by_player.map do |player, values|
  ab = values.transpose[1..-1].map { |e| e.map(&:to_i).inject(:+) }
  [player, *ab, ab.inject(:+)]
end

stat # => [["Bob", 110, 147, 257], ["Ross", 145, 125, 270], ["Kent", 190, 91, 281], ["Alice", 230, 203, 433], ["Jimmy", 124, 206, 330]]
{% endhighlight %}

###Step4. 結果を標準出力する
{% highlight ruby %}
puts "%s\t%s\t%s\ttotal" % headers
puts stat.sort_by{ |s| -s.last }.map { |line| "%s\t%d\t%d\t%d" % line }

# >> player gameA gameB total
# >> Alice  230   203   433
# >> Jimmy  124   206   330
# >> Kent   190   91    281
# >> Ross   145   125   270
# >> Bob    110   147   257
{% endhighlight %}

あなたはどうしてますか？

---

(追記：2013-01-25) csvライブラリを使った別解を書きました。

[Ruby標準添付ライブラリcsvのCSV.tableメソッドが最強な件について](http://melborne.github.com/2013/01/24/csv-table-method-is-awesome/ 'Ruby標準添付ライブラリcsvのCSV.tableメソッドが最強な件について')

---

{% gist 4604530 game_scores.rb %}


---

{{ 4274067750 | amazon_medium_image }}
{{ 4274067750 | amazon_link }} by {{ 4274067750 | amazon_authors }}

