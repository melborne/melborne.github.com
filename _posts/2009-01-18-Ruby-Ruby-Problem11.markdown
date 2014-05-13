---
layout: post
title: Rubyで縦横斜めの積を求める
tagline: Rubyでオイラープロジェクトを解こう！Problem11
date: 2009-01-18
comments: true
categories:
---

##Rubyで縦横斜めの積を求める ～Rubyでオイラープロジェクトを解こう！Problem11

[Problem 11 - Project Eulerより](http://projecteuler.net/index.php?section=problems&id=11)
 
> In the 20×20 grid below, four numbers along a diagonal line have been marked in red.
>
> <span style="font-size:x-small;">08 02 22 97 38 15 00 40 00 75 04 05 07 78 52 12 50 77 91 08</span>
>
> <span style="font-size:x-small;">49 49 99 40 17 81 18 57 60 87 17 40 98 43 69 48 04 56 62 00</span>
>
> <span style="font-size:x-small;">81 49 31 73 55 79 14 29 93 71 40 67 53 88 30 03 49 13 36 65</span>
>
> <span style="font-size:x-small;">52 70 95 23 04 60 11 42 69 24 68 56 01 32 56 71 37 02 36 91</span>
>
> <span style="font-size:x-small;">22 31 16 71 51 67 63 89 41 92 36 54 22 40 40 28 66 33 13 80</span>
>
> <span style="font-size:x-small;">24 47 32 60 99 03 45 02 44 75 33 53 78 36 84 20 35 17 12 50</span>
>
> <span style="font-size:x-small;">32 98 81 28 64 23 67 10 <span style="color:#FF0000;">26</span> 38 40 67 59 54 70 66 18 38 64 70</span>
>
> <span style="font-size:x-small;">67 26 20 68 02 62 12 20 95 <span style="color:#FF0000;">63</span> 94 39 63 08 40 91 66 49 94 21</span>
>
> <span style="font-size:x-small;">24 55 58 05 66 73 99 26 97 17 <span style="color:#FF0000;">78</span> 78 96 83 14 88 34 89 63 72</span>
>
> <span style="font-size:x-small;">21 36 23 09 75 00 76 44 20 45 35 <span style="color:#FF0000;">14</span> 00 61 33 97 34 31 33 95</span>
>
> <span style="font-size:x-small;">78 17 53 28 22 75 31 67 15 94 03 80 04 62 16 14 09 53 56 92</span>
>
> <span style="font-size:x-small;">16 39 05 42 96 35 31 47 55 58 88 24 00 17 54 24 36 29 85 57</span>
>
> <span style="font-size:x-small;">86 56 00 48 35 71 89 07 05 44 44 37 44 60 21 58 51 54 17 58</span>
>
> <span style="font-size:x-small;">19 80 81 68 05 94 47 69 28 73 92 13 86 52 17 77 04 89 55 40</span>
>
> <span style="font-size:x-small;">04 52 08 83 97 35 99 16 07 97 57 32 16 26 26 79 33 27 98 66</span>
>
> <span style="font-size:x-small;">88 36 68 87 57 62 20 72 03 46 33 67 46 55 12 32 63 93 53 69</span>
>
> <span style="font-size:x-small;">04 42 16 73 38 25 39 11 24 94 72 18 08 46 29 32 40 62 76 36</span>
>
> <span style="font-size:x-small;">20 69 36 41 72 30 23 88 34 62 99 69 82 67 59 85 74 04 36 16</span>
>
> <span style="font-size:x-small;">20 73 35 29 78 31 90 01 74 31 49 71 48 86 81 16 23 57 05 54</span>
>
> <span style="font-size:x-small;">01 70 54 71 83 51 54 69 16 92 33 48 61 43 52 01 89 19 67 48</span>
>
> The product of these numbers is 26×63×78×14 = 1788696.
>
> What is the greatest product of four adjacent numbers in any direction (up, down, left, right, or diagonally) in the 2020 grid?
>
> 上の20×20グリッドにおいて、対角線に沿う4つの数字が赤く印されている。
>
> これら数字の積は、26×63×78×14 = 1788696である。
>
> この20×20グリッドにおいて、その並びの方向(上下左右または対角)を問わず、4つ並んだ数字の積の最大値は何か。


[Rubyで数字をスライスする]({{ site.url }}/2009/01/17/Ruby/)と同じ戦略で
各列を配列に見立てそこから4つの数字をスライスする戦略を取る
上下および対角方向の並びに対しては
それらを左右方向に並び替えて処理する

つまり上下方向の並びに対しては
Array#transposeメソッドを使う
対角方向の並びに対しては
行方向の位置に応じて列をシフトしてからtransposeする
{% highlight ruby %}
number = <<DATA
08 02 22 97 38 15 00 40 00 75 04 05 07 78 52 12 50 77 91 08
49 49 99 40 17 81 18 57 60 87 17 40 98 43 69 48 04 56 62 00
81 49 31 73 55 79 14 29 93 71 40 67 53 88 30 03 49 13 36 65
52 70 95 23 04 60 11 42 69 24 68 56 01 32 56 71 37 02 36 91
22 31 16 71 51 67 63 89 41 92 36 54 22 40 40 28 66 33 13 80
24 47 32 60 99 03 45 02 44 75 33 53 78 36 84 20 35 17 12 50
32 98 81 28 64 23 67 10 26 38 40 67 59 54 70 66 18 38 64 70
67 26 20 68 02 62 12 20 95 63 94 39 63 08 40 91 66 49 94 21
24 55 58 05 66 73 99 26 97 17 78 78 96 83 14 88 34 89 63 72
21 36 23 09 75 00 76 44 20 45 35 14 00 61 33 97 34 31 33 95
78 17 53 28 22 75 31 67 15 94 03 80 04 62 16 14 09 53 56 92
16 39 05 42 96 35 31 47 55 58 88 24 00 17 54 24 36 29 85 57
86 56 00 48 35 71 89 07 05 44 44 37 44 60 21 58 51 54 17 58
19 80 81 68 05 94 47 69 28 73 92 13 86 52 17 77 04 89 55 40
04 52 08 83 97 35 99 16 07 97 57 32 16 26 26 79 33 27 98 66
88 36 68 87 57 62 20 72 03 46 33 67 46 55 12 32 63 93 53 69
04 42 16 73 38 25 39 11 24 94 72 18 08 46 29 32 40 62 76 36
20 69 36 41 72 30 23 88 34 62 99 69 82 67 59 85 74 04 36 16
20 73 35 29 78 31 90 01 74 31 49 71 48 86 81 16 23 57 05 54
01 70 54 71 83 51 54 69 16 92 33 48 61 43 52 01 89 19 67 48
DATA
 def greatest_four(number)
   horz = number.split("\n").map { |s| s.split("\s").map { |s| s.to_i } }
   vert = horz.transpose
   diag_r, diag_l = [], []
   horz.each_with_index do |line, i|
     line_r = [0, 0, 0, 0] + line.dup
     line_l = line.dup + [0, 0, 0, 0]
     (i % 4).times do |n|
       line_r.push(line_r.shift)
       line_l.unshift(line_l.pop)
     end
     diag_r << line_r
     diag_l << line_l
   end
   [product_max(horz), product_max(vert), product_max(diag_r.transpose), product_max(diag_l.transpose)].max
 end
 def product_max(seq)
   max = 0
   seq.each do |line|
     (line.length-3).times do |n|
       _product = line.slice(n, 4).inject(:*)
       max = _product if _product > max
     end
   end
   max
 end
 greatest_four(number) # => 70600674
{% endhighlight %}

##Rubyでサブプライム問題解決！ ～Rubyでオイラープロジェクトを解こう！Problem10

[Problem 10 - Project Eulerより](http://projecteuler.net/index.php?section=problems&id=10)
 
> The sum of the primes below 10 is 2 + 3 + 5 + 7 = 17.
>
> Find the sum of all the primes below two million.
>
> 10未満の素数の和は、2 + 3 + 5 + 7 = 17 である。
>
> 200万未満の素数すべての和を求めよ。


[Problem3]({{ site.url }}/2009/01/13/Problem3/)で既に素数を求めているので
それを使って解く
200万はちょっと大きいので
まずは2万を入れて…
{% highlight ruby %}
 def sum_prime(limit)
   sum = 0
   prime = 2
   loop do
     break if prime > limit
     sum += prime if prime?(prime)
     prime += 1
   end
   sum
 end
 def prime?(n)
   2.upto(n-1) do |i|
     return false if n.modulo(i).zero?
   end
   true
 end
 t = Time.now
 sum_prime(20_000) # =>21171191
 Time.now - t # => 73.649596
{% endhighlight %}
ぎゃ！
2万で73秒…
200万だと…

じゃあ…
エラトステネスのふるいでやってみよう

[エラトステネスの篩](http://ja.wikipedia.org/wiki/%E3%82%A8%E3%83%A9%E3%83%88%E3%82%B9%E3%83%86%E3%83%8D%E3%82%B9%E3%81%AE%E7%AF%A9) - Wikipediaより

    ステップ 1
    　整数を最初の素数である 2 から昇順で探索リストに羅列する。
    　2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20
    ステップ 2
    　リストの先頭の数を素数リストに記録する。
    　素数リスト：2
    　探索リスト：2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20
    ステップ 3
    　前のステップで素数リストに加えられた数の全ての倍数を、探索リストから削除する。
    　素数リスト：2
    　探索リスト：3 5 7 9 11 13 15 17 19
    ステップ 4
    　探索リストの最大値が素数リストの最大値の平方よりも小さい場合、素数リストおよび探索リストに残っている数が素数となる。探索リストの最大値が素数リストの最大値の平方よりも大きい場合、ステップ 2 に戻る。

各ステップをそのままコードにしてみた
{% highlight ruby %}
 def sum_prime(limit)
   candidates = (2..limit).to_a
   primes = []
   loop do
     primes << candidates.shift
     candidates.delete_if do |i|
       primes.any? { |e| (i % e).zero? }
     end
     return (primes + candidates).inject(:+) if candidates.max < (primes.max ** 2)
   end
 end
 t = Time.now
 sum_prime(20_000) # => 21171191
 Time.now - t # => 6.052391
{% endhighlight %}
6秒に短縮された
でも200万を入れると…
…
…
答えが出てこない！

あきらめるか…

と…
mathnライブラリに
Primeクラス発見！
これ使っちゃお
{% highlight ruby %}
 require "mathn"
 def sum_prime(limit)
   sum = 0
   Prime.each do |prime|
     return sum if prime > limit
     sum += prime
   end
 end
 t = Time.now
 sum_prime(2_000_000) # => 142913828922
 Time.now - t # => 26.524741
{% endhighlight %}
これで
サ<del datetime="2009-01-18T11:13:25+09:00">ブ</del>ムプライム問題
無事解決！
