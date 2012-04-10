---
layout: post
title: 10のチェスクイズでRubyの配列組み換えメソッドを覚えよう! - 10 Chess Quizzes to know Recombination Methods of Ruby Array
date: 2012-01-13
comments: true
categories:
---


Rubyには与えられた配列を別の配列のかたちに
組み換えるようなメソッドがいくつかあるよ
それらはすごく便利だけど
リファレンスでは別々に説明されてるから
まとまった知識としてはちょっと記憶しづらいよね

1つのテーマに沿って
それらのメソッドが解説されていたら
もう少し理解が進む気がするんだ

そんなわけで..

3x3のミニチェスボードをテーマとして
Rubyの配列メソッドを使って簡単に解ける
チェスクイズを10問作ってみたよ

最初に問題をまとめて書いて
解答例は下の方に置くから
時間のある人は解答例を見ないで
挑戦してみてね:)

さあ始めるよ
###----------------------------- 問   題 -----------------------------
###Q1. [0, 1, 2]の配列を基に、座標[0, 0]から始まる3x3のチェスボードの座標リストboardを作りなさい
{% highlight ruby %}
出力例: board # => [[0, 0], [0, 1], [0, 2], [1, 0], [1, 1], [1, 2], [2, 0], [2, 1], [2, 2]]
{% endhighlight %}

###Q2. 今度は[:a, :b, :c]と[1, 2, 3]の配列を基に、x座標が:a、y座標が1から始まる3x3のチェスボードの座標リストexcel_boardを作りなさい
{% highlight ruby %}
出力例: excel_board # => [[:a, 1], [:a, 2], [:a, 3], [:b, 1], [:b, 2], [:b, 3], [:c, 1], [:c, 2], [:c, 3]]
{% endhighlight %}

###Q3. Q1のboardを基に、その列ごとに分けられた座標リストboard_by_colを作りなさい
{% highlight ruby %}
出力例: board_by_col # => [[[0, 0], [0, 1], [0, 2]], [[1, 0], [1, 1], [1, 2]], [[2, 0], [2, 1], [2, 2]]]
{% endhighlight %}

###Q4. Q1のboardを基に、その行ごとに分けられた座標リストboard_by_rowを作りなさい
{% highlight ruby %}
出力例: board_by_row # => [[[0, 0], [1, 0], [2, 0]], [[0, 1], [1, 1], [2, 1]], [[0, 2], [1, 2], [2, 2]]]
{% endhighlight %}

###Q5. 今度はQ3のboard_by_colを基にboard_by_rowを作りなさい

###Q6. Q3のboard_by_colを基に、その各列を一旦3つの変数col1, col2, col3に格納し、それらを使ってboard_by_rowを作りなさい
{% highlight ruby %}
出力例: 
col1 # => [[0, 0], [0, 1], [0, 2]]
col2 # => [[1, 0], [1, 1], [1, 2]]
col3 # => [[2, 0], [2, 1], [2, 2]]
board_by_row # => [[[0, 0], [1, 0], [2, 0]], [[0, 1], [1, 1], [2, 1]], [[0, 2], [1, 2], [2, 2]]]
{% endhighlight %}

###Q7. Q1のboard上に2つのコマを配置するすべての組合せの座標リストpiece_combinationsを作りなさい
{% highlight ruby %}
出力例: piece_combinations # => [[[0, 0], [0, 1]], [[0, 0], [0, 2]], [[0, 0], [1, 0]], [[0, 0], [1, 1]], [[0, 0], [1, 2]], [[0, 0], [2, 0]], [[0, 0], [2, 1]], [[0, 0], [2, 2]], [[0, 1], [0, 2]], [[0, 1], [1, 0]], [[0, 1], [1, 1]], [[0, 1], [1, 2]], [[0, 1], [2, 0]], [[0, 1], [2, 1]], [[0, 1], [2, 2]], [[0, 2], [1, 0]], [[0, 2], [1, 1]], [[0, 2], [1, 2]], [[0, 2], [2, 0]], [[0, 2], [2, 1]], [[0, 2], [2, 2]], [[1, 0], [1, 1]], [[1, 0], [1, 2]], [[1, 0], [2, 0]], [[1, 0], [2, 1]], [[1, 0], [2, 2]], [[1, 1], [1, 2]], [[1, 1], [2, 0]], [[1, 1], [2, 1]], [[1, 1], [2, 2]], [[1, 2], [2, 0]], [[1, 2], [2, 1]], [[1, 2], [2, 2]], [[2, 0], [2, 1]], [[2, 0], [2, 2]], [[2, 1], [2, 2]]]
{% endhighlight %}

###Q8. 盤上の3つのコマ:rook, :bishop, :queenから2つを順番に取るとき、その取り方の組合せリストcapturesを作りなさい
{% highlight ruby %}
出力例: captures # => [[:rook, :bishop], [:rook, :queen], [:bishop, :rook], [:bishop, :queen], [:queen, :rook], [:queen, :bishop]]
{% endhighlight %}

###Q9. Q8のcapturesを基に、:bishopを含む組合せのリストbishopsと、:bishopを含まない組合せのリストremainsを作りなさい
{% highlight ruby %}
出力例:
bishops # => [[:rook, :bishop], [:bishop, :rook], [:bishop, :queen], [:queen, :bishop]]
remains # => [[:rook, :queen], [:queen, :rook]]
{% endhighlight %}

###Q10. 盤上の3つのコマ:rook, :bishop, :queenの何れかを移動させる機会が2回があるとき、動かすコマの組合せリストmovesを作りなさい
{% highlight ruby %}
出力例: moves # => [[:rook, :rook], [:rook, :bishop], [:rook, :queen], [:bishop, :bishop], [:bishop, :queen], [:queen, :queen]]
{% endhighlight %}

以上で問題は終わりだよ

下に配列の組み換えメソッド群を使った
解答例を書くよ





###----------------------------- 解 答 例 -----------------------------
###Q1. [0, 1, 2]の配列を基に、座標[0, 0]から始まる3x3のチェスボードの座標リストboardを作りなさい
###A1. Array#repeated_permutationを使う
{% highlight ruby %}
  board = [0, 1, 2].repeated_permutation(2).to_a # => [[0, 0], [0, 1], [0, 2], [1, 0], [1, 1], [1, 2], [2, 0], [2, 1], [2, 2]]
{% endhighlight %}
遠い昔に数学の順列・組合せで3P2とか6C2とか習ったと思うけど、permutationというのはそのP、つまり順列のことだよ。3P2は3個のものから2個を取るときに、その順序も意味を持つ取り方の組合せになるよ。でrepeated_はさらに同じものを繰り返しとることを許す組合せなんだ。repeated_permutation自体はEnumeratorを返すから最後にto_aして配列化するよ。

###Q2. 今度は[:a, :b, :c]と[1, 2, 3]の配列を基に、x座標が:a、y座標が1から始まる3x3のチェスボードの座標リストexcel_boardを作りなさい
###A2. Array#productを使う
{% highlight ruby %}
  [:a, :b, :c].product([1, 2, 3]) # => [[:a, 1], [:a, 2], [:a, 3], [:b, 1], [:b, 2], [:b, 3], [:c, 1], [:c, 2], [:c, 3]]
{% endhighlight %}
Array#productは集合同士の掛け算をするよ。こういうのをデカルト積(cartesian product)というらしいよ。productは2以上の配列を引数に取れるから、それで3以上の配列のデカルト積を作ることができるよ。ちなみにQ1はこのproductを使っても求めることができるよね([0,1,2].product([0,1,2]))。repeated_permutationと異なって、productは配列を返すよ。

###Q3. Q1のboardを基に、その列ごとに分けられた座標リストboard_by_colを作りなさい
###A3. Enumerable#group_byを使う
{% highlight ruby %}
  board_by_col = board.group_by(&:first).values # => [[[0, 0], [0, 1], [0, 2]], [[1, 0], [1, 1], [1, 2]], [[2, 0], [2, 1], [2, 2]]]
{% endhighlight %}
任意の集合をブロックに与えた条件(ここでは&:first)で分けるときはEnumerable#group_byが便利だよ。group_byの返り値は条件をキー、その該当グループを値とするHashになるから、最後にvaluesで値だけ取ってるよ。このメソッドは例えば、単語リストをその語長別に整理するような場合に重宝するんだ。

###Q4. Q1のboardを基に、その行ごとに分けられた座標リストboard_by_rowを作りなさい
###A4. Enumerable#group_byを使う
{% highlight ruby %}
  board_by_row = board.group_by(&:last).values # => [[[0, 0], [1, 0], [2, 0]], [[0, 1], [1, 1], [2, 1]], [[0, 2], [1, 2], [2, 2]]]
{% endhighlight %}

###Q5. 今度はQ3のboard_by_colを基にboard_by_rowを作りなさい
###A5. Array#transposeを使う
{% highlight ruby %}
  board_by_row = board_by_col.transpose # => [[[0, 0], [1, 0], [2, 0]], [[0, 1], [1, 1], [2, 1]], [[0, 2], [1, 2], [2, 2]]]
{% endhighlight %}
Array#transposeはまさに行と列を入れ換えるためのメソッドだよ。こういうのを行列の転置というそうだよ。

###Q6. Q3のboard_by_colを基に、その各列を一旦3つの変数col1, col2, col3に格納し、それらを使ってboard_by_rowを作りなさい
###A6. Array#zipを使う
{% highlight ruby %}
  col1, col2, col3 = board_by_col
  col1 # => [[0, 0], [0, 1], [0, 2]]
  col2 # => [[1, 0], [1, 1], [1, 2]]
  col3 # => [[2, 0], [2, 1], [2, 2]]
  col1.zip(col2, col3) # => [[[0, 0], [1, 0], [2, 0]], [[0, 1], [1, 1], [2, 1]], [[0, 2], [1, 2], 
{% endhighlight %}
transposeの親戚がArray#zipだよ。zipはジップロックのように複数の配列を1つにまとめるんだけど、Rubyのzipはただまとめるだけじゃなく、transposeと同じように縦方向にまとめるんだよ。あっ、ジッパーを上から下に閉めるようだからzipなのか!

###Q7. Q1のboard上に2つのコマを配置するすべての組合せの座標リストpiece_combinationsを作りなさい
###A7. Array#combinationを使う
{% highlight ruby %}
  piece_combinations = board.combination(2).to_a # => [[[0, 0], [0, 1]], [[0, 0], [0, 2]], [[0, 0], [1, 0]], [[0, 0], [1, 1]], [[0, 0], [1, 2]], [[0, 0], [2, 0]], [[0, 0], [2, 1]], [[0, 0], [2, 2]], [[0, 1], [0, 2]], [[0, 1], [1, 0]], [[0, 1], [1, 1]], [[0, 1], [1, 2]], [[0, 1], [2, 0]], [[0, 1], [2, 1]], [[0, 1], [2, 2]], [[0, 2], [1, 0]], [[0, 2], [1, 1]], [[0, 2], [1, 2]], [[0, 2], [2, 0]], [[0, 2], [2, 1]], [[0, 2], [2, 2]], [[1, 0], [1, 1]], [[1, 0], [1, 2]], [[1, 0], [2, 0]], [[1, 0], [2, 1]], [[1, 0], [2, 2]], [[1, 1], [1, 2]], [[1, 1], [2, 0]], [[1, 1], [2, 1]], [[1, 1], [2, 2]], [[1, 2], [2, 0]], [[1, 2], [2, 1]], [[1, 2], [2, 2]], [[2, 0], [2, 1]], [[2, 0], [2, 2]], [[2, 1], [2, 2]]]
{% endhighlight %}
順列・組合せの組合せを実現するメソッドがArray#combinationだよ。つまりQ7は9C2を聞いていて、その組み合わせ数は9!/2!(9-2)! = 36通りになるよね。

###Q8. 盤上の3つのコマ:rook, :bishop, :queenから2つを順番に取るとき、その取り方の組合せリストcapturesを作りなさい
###A8. Array#permutationを使う
{% highlight ruby %}
  captures = [:rook, :bishop, :queen].permutation(2).to_a # => [[:rook, :bishop], [:rook, :queen], [:bishop, :rook], [:bishop, :queen], [:queen, :rook], [:queen, :bishop]]
{% endhighlight %}
コマの取り方の順番にも意味があるから、これは順列の問題だよ。3P2 = 3!/(3-2)!で6通りの組合せができるよ。

###Q9. Q8のcapturesを基に、:bishopを含む組合せのリストbishopsと、:bishopを含まない組合せのリストremainsを作りなさい
###A9. Enumerable#partitionを使う
{% highlight ruby %}
  bishops, remains = captures.partition { |pieces| pieces.include? :bishop }
  bishops # => [[:rook, :bishop], [:bishop, :rook], [:bishop, :queen], [:queen, :bishop]]
  remains # => [[:rook, :queen], [:queen, :rook]]
{% endhighlight %}
配列をきっちり2つのグループに分けるときはEnumerable#partitionが使えるよ。配列の配列が返るから、これを多重代入で受ければいいんだ。もちろん先のEnumerable#group_byも使えるけど、ちょっと手数が増えるかな。

###Q10. 盤上の3つのコマ:rook, :bishop, :queenの何れかを移動させる機会が2回があるとき、動かすコマの組合せリストmovesを作りなさい
###A10. Array#repeated_combinationを使う
{% highlight ruby %}
  [:rook, :bishop, :queen].repeated_combination(2).to_a # => [[:rook, :rook], [:rook, :bishop], [:rook, :queen], [:bishop, :bishop], [:bishop, :queen], [:queen, :queen]]
{% endhighlight %}
同じコマを2度動かすこともあるから、combinationじゃなくrepeated_combinationを使うよ。

ここで出てきたメソッドは次のとおりだよ
>|
Array:
  combination, repeated_combination, permutation,
  repeated_permutation, product, transpose, zip
Enumerable:
  group_by, partition
|<

これらのメソッドが使えなければ
上の問題を解くのは結構厄介だと思うよ
頭の体操としてはやりがいがあるかも知れないけど..
(挑戦者待ってます..)

(追記:2012-1-15)解答に解説を追加しました。
{% gist 1613681 array_recombinations.rb %}
