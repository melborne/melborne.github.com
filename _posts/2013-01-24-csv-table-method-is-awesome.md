---
layout: post
title: "Ruby標準添付ライブラリcsvのCSV.tableメソッドが最強な件について"
description: ""
category: 
tags: 
date: 2013-01-24
published: true
---
{% include JB/setup %}


##─　問題１　─

> `data.csv`ファイルには、５人のプレイヤー（Alice, Bob, Jimmy, Kent, Ross）が二種類のゲーム（gameA, gameB）をプレイした結果が次のような形で格納されている。各ゲームの平均点を求めよ。

### data.csv
{% highlight text %}
player,gameA,gameB
Alice,84.0,79.5
Bob,20.0,56.5
Jimmy,80.0,31.0
Kent,90.5,15.5
Ross,68.0,33.0
{% endhighlight %}


##─　僕の通った道　─

###1. File.readしてtransposeする

{% highlight ruby %}
data = File.read('data.csv')

headers, *scores = data.lines.map { |line| line.chomp.split(',') }
scores # => [["Alice", "84.0", "79.5"], ["Bob", "20.0", "56.5"], ["Jimmy", "80.0", "31.0"], ["Kent", "90.5", "15.5"], ["Ross", "68.0", "33.0"]]

_, *ab = scores.transpose # => [["Alice", "Bob", "Jimmy", "Kent", "Ross"], ["84.0", "20.0", "80.0", "90.5", "68.0"], ["79.5", "56.5", "31.0", "15.5", "33.0"]]

avgA, avgB = ab.map { |e| e.map(&:to_f).inject(:+) / e.size } # => [68.5, 43.1]
{% endhighlight %}
まあ、悪くはないですけど、String#linesして#splitしてってのはどうですかね。空白あっても困るし。正規表現ですか？Array#transposeはなかなかいいアイディアですけどね。

###2. csvライブラリでreadする
CSVファイルって言ってるんですから、素直に標準添付ライブラリcsvを使えばいいんですよ。

{% highlight ruby %}
require "csv"

headers, *scores = CSV.read('data.csv')

headers # => ["player", "gameA", "gameB"]
scores # => [["Alice", "84.0", "79.5"], ["Bob", "20.0", "56.5"], ["Jimmy", "80.0", "31.0"], ["Kent", "90.5", "15.5"], ["Ross", "68.0", "33.0"]]

_, *ab = scores.transpose # => [["Alice", "Bob", "Jimmy", "Kent", "Ross"], ["84.0", "20.0", "80.0", "90.5", "68.0"], ["79.5", "56.5", "31.0", "15.5", "33.0"]]

avgA, avgB = ab.map { |e| e.map(&:to_f).inject(:+) / e.size } # => [68.5, 43.1]
{% endhighlight %}
ワンステップ少なくなりましたね。それにしても、あなた、多重代入好きですねぇ。

###3. csvライブラリで.tableする
でもね、このライブラリにはすごい必殺技があるんですよ。ヒヒィ。

{% highlight ruby %}
table = CSV.table('data.csv')

table.headers # => [:player, :gamea, :gameb]

avgA, avgB = [:gamea, :gameb].map { |e| table[e].inject(:+) / table.size } # => [68.5, 43.1]
{% endhighlight %}
えっ？何が起きたの？

transposeは？to_fは？どこに逝ったの？誰がやったの？

##CSV.tableって何？

先の`CSV.read`は二次元配列を返しますよ。

{% highlight ruby %}
csv = CSV.read('data.csv') # => [["player", "gameA", "gameB"], ["Alice", "84.0", "79.5"], ["Bob", "20.0", "56.5"], ["Jimmy", "80.0", "31.0"], ["Kent", "90.5", "15.5"], ["Ross", "68.0", "33.0"]]

csv.class # => Array
csv.first # => ["player", "gameA", "gameB"]
csv[1] # => ["Alice", "84.0", "79.5"]
csv[2] # => ["Bob", "20.0", "56.5"]
{% endhighlight %}

でも、`CSV.table`はCSV::Tableというテーブル向けクラスのインスタンスを返すんですよ。ヘッダー要素には#headersでアクセスできますし。
{% highlight ruby %}
table = CSV.table('data.csv') # => #<CSV::Table mode:col_or_row row_count:6>
table.class # => CSV::Table

table.headers # => [:player, :gamea, :gameb]
{% endhighlight %}

で、テーブルの各レコードは、CSV::Rowクラスのインスタンスでラップされとるんですな。

{% highlight ruby %}
table.first # => #<CSV::Row player:"Alice" gamea:84.0 gameb:79.5>
table[1] # => #<CSV::Row player:"Bob" gamea:20.0 gameb:56.5>
table[2] # => #<CSV::Row player:"Jimmy" gamea:80.0 gameb:31.0>
{% endhighlight %}

CSV::Tableのインスタンスは、テーブルのアクセス方向を指定するモード（:row, :column, :col_or_rowの何れか）を持ってて、デフォルトでこれは`:col_or_row`（ミックスモード）にセットされますですよ。

それでTable#\[ \]メソッドに渡される引数に応じて、そのアクセス方向がよしなに判断されるってわけです。
{% highlight ruby %}
table[1] # => #<CSV::Row player:"Bob" gamea:20.0 gameb:56.5>
table[2] # => #<CSV::Row player:"Jimmy" gamea:80.0 gameb:31.0>

table[:player] # => ["Alice", "Bob", "Jimmy", "Kent", "Ross"]
table[:gamea] # => [84.0, 20.0, 80.0, 90.5, 68.0]
table[:gameb] # => [79.5, 56.5, 31.0, 15.5, 33.0]
{% endhighlight %}
ほら、特定フィールドのヘッダーを渡せば、そのフィールドの配列が返るだとか！

しかも、ヘッダー値は文字列から自動的にシンボルに変換されているの、わかるでしょう？数値の値も自動でFloatになっているのわかるでしょう？

CSV.table、最強！って、誰が言っても怒りませんよ。もう。

##CSVインスタンスの生成オプション
CSVのインスタンスを生成するときに複数のオプションを渡すことができるんです。実は、CSV.tableはそのオプションの幾つかを自動設定するものなのでした。

CSV.readにオプションを渡して、CSV.tableに対抗しますか。

{% highlight ruby %}
csv = CSV.read('data.csv', headers:true, converters: :numeric, header_converters: :symbol) # => #<CSV::Table mode:col_or_row row_count:6>
csv.class # => CSV::Table

csv.first # => #<CSV::Row player:"Alice" gamea:84.0 gameb:79.5>
csv[1] # => #<CSV::Row player:"Bob" gamea:20.0 gameb:56.5>
csv[2] # => #<CSV::Row player:"Jimmy" gamea:80.0 gameb:31.0>
csv[:player] # => ["Alice", "Bob", "Jimmy", "Kent", "Ross"]
csv[:gamea] # => [84.0, 20.0, 80.0, 90.5, 68.0]
csv[:gameb] # => [79.5, 56.5, 31.0, 15.5, 33.0]
{% endhighlight %}

なあ〜るほど、なあ〜るほど。


##─　問題２　─

> `data2.csv`ファイルには、５人のプレイヤー（Alice, Bob, Jimmy, Kent, Ross）が二種類のゲーム（gameA, gameB）をそれぞれ３回ずつプレイした結果が次のような形で格納されている。**各プレイヤー毎**の各ゲームの平均点を求めよ。

{% highlight text %}
player,gameA,gameB
Alice,84.0,79.5
Bob,20.0,56.5
Jimmy,80.0,31.0
Kent,90.5,15.5
Ross,68.0,33.0
Alice,24.0,15.5
Bob,60.0,16.5
Jimmy,85.0,42.0
Kent,55.5,15.5
Ross,22.0,33.5
Alice,64.5,39.5
Bob,25.0,50.5
Jimmy,60.0,61.0
Kent,70.5,25.0
Ross,48.0,36.5
{% endhighlight %}

次のような出力で。

{% highlight text %}
player  gamea  gameb
Alice   57.50  44.83
Bob     35.00  41.17
Jimmy   75.00  44.67
Kent    72.17  18.67
Ross    46.00  34.33
{% endhighlight %}

なんか、昨日の問題に近づいて来ましたけど。

> [Rubyで点数を集計するとき、あなたはどうしてますか？](http://melborne.github.com/2013/01/23/get-statistics-with-ruby/ 'Rubyで点数を集計するとき、あなたはどうしてますか？')


##─　僕の通った道その２　─

###Enumerable#group_byを使う

{% highlight ruby %}
table = CSV.table('data2.csv') # => #<CSV::Table mode:col_or_row row_count:16>

scores_by_player = table.group_by(&:first) # => {[:player, "Alice"]=>[#<CSV::Row player:"Alice" gamea:84.0 gameb:79.5>, #<CSV::Row player:"Alice" gamea:24.0 gameb:15.5>, #<CSV::Row player:"Alice" gamea:64.5 gameb:39.5>], [:player, "Bob"]=>[#<CSV::Row player:"Bob" gamea:20.0 gameb:56.5>, #<CSV::Row player:"Bob" gamea:60.0 gameb:16.5>, #<CSV::Row player:"Bob" gamea:25.0 gameb:50.5>], [:player, "Jimmy"]=>[#<CSV::Row player:"Jimmy" gamea:80.0 gameb:31.0>, #<CSV::Row player:"Jimmy" gamea:85.0 gameb:42.0>, #<CSV::Row player:"Jimmy" gamea:60.0 gameb:61.0>], [:player, "Kent"]=>[#<CSV::Row player:"Kent" gamea:90.5 gameb:15.5>, #<CSV::Row player:"Kent" gamea:55.5 gameb:15.5>, #<CSV::Row player:"Kent" gamea:70.5 gameb:25.0>], [:player, "Ross"]=>[#<CSV::Row player:"Ross" gamea:68.0 gameb:33.0>, #<CSV::Row player:"Ross" gamea:22.0 gameb:33.5>, #<CSV::Row player:"Ross" gamea:48.0 gameb:36.5>]}

stat = scores_by_player.map do |(_, player), rows|
  avgA = rows.map { |r| r[:gamea] }.inject(:+) / rows.size
  avgB = rows.map { |r| r[:gameb] }.inject(:+) / rows.size
  [player, avgA, avgB]
end

stat # => [["Alice", 57.5, 44.833333333333336], ["Bob", 35.0, 41.166666666666664], ["Jimmy", 75.0, 44.666666666666664], ["Kent", 72.16666666666667, 18.666666666666668], ["Ross", 46.0, 34.333333333333336]]

puts "%s\t%s\t%s" % table.headers
puts stat.map { |d| "%s\t%.02f\t%.02f" % d }

# >> player  gamea  gameb
# >> Alice   57.50  44.83
# >> Bob     35.00  41.17
# >> Jimmy   75.00  44.67
# >> Kent    72.17  18.67
# >> Ross    46.00  34.33
{% endhighlight %}
概ねいい感じですか。でも、CSV::Tableのミックスモードのパワーが使えなくなっちゃった。mapして各rowから対象データを一つづつ取ってこなくちゃならないなんて。group_byがいかんですよ、これは。

###group_byをハックする
なら、group_byをオーバーライドってことになりますな。

{% highlight ruby %}
class CSV::Table
  def group_by(&blk)
    Hash[ super.map { |k, v| [k, CSV::Table.new(v)] } ]
  end
end
{% endhighlight %}

さて。
{% highlight ruby %}
table = CSV.table('data2.csv') # => #<CSV::Table mode:col_or_row row_count:16>

scores_by_player = table.group_by(&:first) # => {[:player, "Alice"]=>#<CSV::Table mode:col_or_row row_count:4>, [:player, "Bob"]=>#<CSV::Table mode:col_or_row row_count:4>, [:player, "Jimmy"]=>#<CSV::Table mode:col_or_row row_count:4>, [:player, "Kent"]=>#<CSV::Table mode:col_or_row row_count:4>, [:player, "Ross"]=>#<CSV::Table mode:col_or_row row_count:4>}

stat = scores_by_player.map do |(_, player), t|
  avgA, avgB = [:gamea, :gameb].map { |e| t[e].inject(:+) / t.size }
  [player, avgA, avgB]
end

stat # => [["Alice", 57.5, 44.833333333333336], ["Bob", 35.0, 41.166666666666664], ["Jimmy", 75.0, 44.666666666666664], ["Kent", 72.16666666666667, 18.666666666666668], ["Ross", 46.0, 34.333333333333336]]

puts "%s\t%s\t%s" % table.headers
puts stat.map { |d| "%s\t%.02f\t%.02f" % d }

# >> player  gamea  gameb
# >> Alice   57.50  44.83
# >> Bob     35.00  41.17
# >> Jimmy   75.00  44.67
# >> Kent    72.17  18.67
# >> Ross    46.00  34.33
{% endhighlight %}

いいんじゃないですかね！

##CSV.new
ちなみに昨日の問題のような、スペース区切りの文字列データはどうですか？CSV.newしますか。col_sepオプション渡して。

昨日の問題です。

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

## 僕の答え

{% highlight ruby %}
require "csv"
class CSV
  def group_by(&blk)
    Hash[ super.map { |k, v| [k, CSV::Table.new(v)] } ]
  end
end

csv = CSV.new(data, col_sep:' ', headers:true, converters: :numeric, header_converters: :symbol) # => <#CSV io_type:StringIO encoding:UTF-8 lineno:0 col_sep:" " row_sep:"\n" quote_char:"\"" headers:true>

scores_by_player = csv.group_by(&:first) # => {[:player, "Ross"]=>#<CSV::Table mode:col_or_row row_count:4>, [:player, "Bob"]=>#<CSV::Table mode:col_or_row row_count:3>, [:player, "Kent"]=>#<CSV::Table mode:col_or_row row_count:4>, [:player, "Alice"]=>#<CSV::Table mode:col_or_row row_count:4>, [:player, "Jimmy"]=>#<CSV::Table mode:col_or_row row_count:4>}

stat = scores_by_player.map do |(_, player), t|
  ab = [:gamea, :gameb].map { |e| t[e].inject(:+) }
  [player, *ab, ab.inject(:+)]
end

stat # => [["Ross", 145, 125, 270], ["Bob", 90, 91, 181], ["Kent", 190, 91, 281], ["Alice", 230, 203, 433], ["Jimmy", 124, 206, 330]]

puts "%s\t%s\t%s\ttotal" % csv.headers
puts stat.sort_by{ |s| -s.last }.map { |line| "%s\t%d\t%d\t%d" % line }

# >> player	gamea	gameb	total
# >> Alice	230	203	433
# >> Jimmy	124	206	330
# >> Kent	190	91	281
# >> Ross	145	125	270
# >> Bob	90	91	181
{% endhighlight %}

ほほぅ。

---
<br  />


本日知った`CSV.table`の感動を冷めやらぬ前に皆様にお届けしましたm(__)m


---

> [library csv](http://doc.ruby-lang.org/ja/1.9.3/library/csv.html 'library csv')


---

電子書籍でRuby始めてみませんか？

> [M'ELBORNE BOOKS]({{ site.url }}/books/ 'M'ELBORNE BOOKS')


---

(追記：2013-01-25)コード中のtypoを直しました。
