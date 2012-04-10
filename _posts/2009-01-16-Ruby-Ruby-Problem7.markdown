---
layout: post
title: Rubyでエラトステネス ～Rubyでオイラープロジェクトを解こう！Problem7
date: 2009-01-16
comments: true
categories:
---

##Rubyでエラトステネス ～Rubyでオイラープロジェクトを解こう！Problem7
[Problem 7 - Project Eulerより](http://projecteuler.net/index.php?section=problems&id=7)
> 
> By listing the first six prime numbers: 2, 3, 5, 7, 11, and 13, we can see that the 6th prime is 13.
> What is the 10001st prime number?
> 最初の6つの素数2、3、5、7、11、および13を並べれば、6番目が13であることがわかる。
> では10001番目の素数は何か。


[Rubyで素因数を求める](/2009/01/13/Ruby/)で書いた
next_primeメソッドとprime?メソッドをそのまま使おう
{% highlight ruby %}
 def nth_prime(nth)
   prime = 1
   n = 1
   until n > nth
     prime = next_prime(prime)
     n += 1
   end
   prime
 end
 def next_prime(prime)
   _next = prime + 1
   loop do
     return _next if prime?(_next)
     _next += 1
   end
 end
 def prime?(n)
   2.upto(n-1) do |i|
     return false if n.modulo(i).zero?
   end
   true
 end
 t = Time.now
 nth_prime 10001 # => 104743
 Time.now - t # => 263.424058
{% endhighlight %}
ちょっと時間が掛かる…

数字を小さくしてプロファイルを見る
>|
ruby -r profile p7.rb 
  %   cumulative   self              self     total
 time   seconds   seconds    calls  ms/call  ms/call  name
 63.80   172.72    172.72     1000   172.72   267.66  Integer#upto
 17.90   221.19     48.47  3711627     0.01     0.01  Fixnum#modulo
 17.42   268.34     47.15  3711627     0.01     0.01  Fixnum#zero?
  0.06   268.51      0.17     8918     0.02     0.02  Fixnum#+
  0.03   268.59      0.08     7918     0.01     0.01  Fixnum#-
  0.01   268.63      0.04     1000     0.04   267.71  Object#prime?
  0.00   268.63      0.00        2     0.00     0.00  IO#set_encoding
  0.00   268.63      0.00     1001     0.00     0.00  Fixnum#>
  0.00   268.63      0.00        2     0.00     0.00  Time#now
  0.00   268.63      0.00        2     0.00     0.00  Time#initialize
  0.00   268.63      0.00        3     0.00     0.00  Module#method_added
  0.00   268.63      0.00        1     0.00   580.00  Object#nth_prime
  0.00   268.63      0.00        1     0.00     0.00  Time#-
  0.00   270.74      0.00        1     0.00 270740.00  #toplevel
|<
ボトルネックはやはりprime?メソッドだ…

素数の判定法に
エラトステネスのふるいというのがある

[エラトステネスの篩](http://ja.wikipedia.org/wiki/%E3%82%A8%E3%83%A9%E3%83%88%E3%82%B9%E3%83%86%E3%83%8D%E3%82%B9%E3%81%AE%E7%AF%A9) - Wikipediaより
>|
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
|<

これを利用して上のコードを少し改良してみる
nth_primeメソッドにおいて
得られた素数をprime_listに持たせ
prime?に渡すようにしよう
{% highlight ruby %}
 def nth_prime(nth)
   prime_list = [2]
   n = 2
   until n > nth
     prime_list << next_prime(prime_list)
     n += 1
   end
   prime_list.last
 end
 def next_prime(prime_list)
   _next = prime_list.last + 1
   loop do
     return _next if prime?(_next, prime_list)
     _next += 1
   end
 end
 def prime?(n, prime_list)
   prime_list.each { |i| return false if n != i and (n % i).zero? }
   return true if n < (prime_list.last ** 2)
   2.upto(n-1) do |i|
     return false if n.modulo(i).zero?
   end
   true
 end
 t = Time.now
 nth_prime 10001 # => 104743
 Time.now - t # => 21.216265
{% endhighlight %}
いくらかよくなったかな
##Rubyでサムオブスクエアスクエアオブサム ～Rubyでオイラープロジェクトを解こう！Problem6
[Problem 6 - Project Eulerより](http://projecteuler.net/index.php?section=problems&id=6)
> 
> The sum of the squares of the first ten natural numbers is,
> [tex:1^2 + 2^2 + ... + 10^2 = 385]
> The square of the sum of the first ten natural numbers is,
> [tex:(1 + 2 + ... + 10)^2 = 55^2 = 3025]
> Hence the difference between the sum of the squares of the first ten natural numbers and the square of the sum is 3025 - 385 = 2640.
> Find the difference between the sum of the squares of the first one hundred natural numbers and the square of the sum.
> 最初の10個の自然数を二乗したものの合計は、
> [tex:1^2 + 2^2 + ... + 10^2 = 385]
> 最初の10個の自然数の合計を二乗したものは、
> [tex:(1 + 2 + ... + 10)^2 = 55^2 = 3025]
> よってこれらの差は、3025 - 385 = 2640である。
> 最初の100個の自然数を二乗したものの合計と、それら自然数の合計を二乗したものとの差を求めよ。


{% highlight ruby %}
 def sum_of_squares(limit)
   sum = 0
   1.upto(limit) do |n|
     sum += n ** 2
   end
   sum
 end
 def square_of_sum(limit)
   (1..limit).to_a.inject(:+) ** 2
 end
 limit = 100
 (sum_of_squares(limit) - square_of_sum(limit)).abs # => 25164150
{% endhighlight %}
