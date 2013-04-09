---
layout: post
title: SchemeとRubyで高階関数を学ぼう
date: 2009-01-29
comments: true
categories:
tags: [ruby, scheme]
---


<script type="text/javascript" src="http://cdn.mathjax.org/mathjax/latest/MathJax.js?config=TeX-AMS-MML_HTMLorMML"></script>


「{{ '489471163X' | amazon_link }}」という本を図書館で借りた
プログラマー必読の名著で
Amazonによればこれ1冊でコンピュータのすべてがわかるらしい
主著者はLISPの一方言であるSchemeという言語を作った人で
本書もSchemeで書かれている
Ruby以外知らない自分には新鮮で大変勉強になる

最初の方に高階手続きによる抽象という章がある
高階手続きというのは手続きを扱う手続き
つまり手続きの引数として手続きを取ったり
手続きを値として返す手続きのことだ

Rubyにもそういう表現力があるので
同じことをRubyでもできるか試してみよう

##高階手続き
最初に以下の似たような3つの手続きを考える

1. aからbまでの整数の和を計算する(sum_integers)
1. 与えられた範囲の整数の三乗の和を計算する(sum_cubes)
1. 級数の項の並びの和を計算する(pi_sum)

これらをSchemeで表現すると通常次のようになる
{% highlight scheme %}
 (define (sum_integers a b)
	(if (> a b)
	     0
	     (+ a (sum_integers (+ a 1) b))))
		
 (define (sum_cubes a b)
	(if (> a b)
	     0
	     (+ (sum_cubes (+ a 1) b))))
		
 (define (pi_sum a b)
	(if (> a b)
	     0
	     (+ (/ 1.0 (* a (+ a 2))) (pi_sum (+ a 4) b))))
{% endhighlight %}
defineの後に手続き名と引数をカッコで括って置き
続けて手続きの実体を置く

Rubyでは以下のように表現される
{% highlight ruby %}
 def sum_integers(a, b)
   if a > b
     0
   else
     a + sum_integers(a+1, b)
   end
 end
 def sum_cubes(a, b)
   if a > b
     0
   else
     cube(a) + sum_cubes(a+1, b)
   end
 end
 def pi_sum(a, b)
   if a > b
     0
   else
     1.0/(a*(a+2)) + pi_sum(a+4, b)
   end
 end
{% endhighlight %}

見ての通り3つの手続きの実体は共通のパターンを持っている
加算するaの関数とaの次の値を計算する関数が違うだけだ
これらをterm, nextと記号化し
3つの手続きで共通する総和sumという概念を表現する
Schemeでは以下のようになる
{% highlight scheme %}
 (define (sum term a next b)
	(if (> a b)
	     0
	     (+ (term a)
		   (sum term (next a) next b))))
{% endhighlight %}
手続きsumにはtermとnextがその引数として加わる
その取り扱いに特別なものはない
Schemeではこのような手続きを引数として取る手続きが
自然な形で書ける

sum手続きを使って先の3つの手続きを完成させるには
以下のように手続きを加える
{% highlight scheme %}
 (define (inc n) (+ n 1))					
 (define (sum_cubes a b)
	(sum cube a inc b))
 (sum_cubes 1 10)
 3025
 (define (identity x) x)
 (define (sum_integers a b)
	(sum identity a inc b))
	
 (sum_integers 1 10)
 55
 (define (pi_sum a b)
	(define (pi_term x)
		(/ 1.0 (* x (+ x 2))))
	(define (pi_next x)
		(+ x 4))
	(sum pi_term a pi_next b))
	
 (* 8 (pi_sum 1 1000))
 3.139592655589783
{% endhighlight %}
sum_cubesとsum_integersのためにincを定義し
pi_sumのためにpi_termとpi_nextを定義している
pi_term,pi_nextは汎用性が低いからpi_sumの中で定義している
それぞれに固有の手続きをsumのtermとnextに渡すことで
共通のsum手続きを用いて3つの異なる演算が実現できる

これをRubyで表現してみよう
まずはsumメソッドから
{% highlight ruby %}
 def sum(term, a, _next, b)
   if a > b
     0
   else
     term.call(a) + sum(term, _next.call(a), _next, b)
   end
 end
{% endhighlight %}
Schemeと異なりRubyでは手続きはオブジェクトではない
だけど手続きをオブジェクトにすることはできる
この手続きオブジェクトの起動にはcallが必要だ

このsumメソッドを使って先の3つの手続きを完成させよう
{% highlight ruby %}
 def cube(n)
   n**3
 end
 def inc(n)
   n + 1
 end
 def sum_cubes(a, b)
   sum(method(:cube), a, method(:inc), b)
 end
 sum_cubes(1, 10) # => 3025
 def identity(n)
   n
 end
 def sum_integers(a, b)
   sum(method(:identity), a, method(:inc), b)
 end
 sum_integers(1, 10) # => 55
 def pi_sum(a, b)
   def pi_term(x)
     1.0/(x*(x+2))
   end
   def pi_next(x)
     x + 4
   end
   sum(method(:pi_term), a, method(:pi_next), b)
 end
 8 * pi_sum(1, 1000) # => 3.13959265558978
{% endhighlight %}
Rubyではメソッドをオブジェクト化するのに
Object#methodメソッドを使いメソッド名をシンボルで渡す
pi_sumメソッドのように
メソッド定義の中にメソッド定義をした場合
Rubyでは外側のメソッドの呼び出し時に
内側のメソッドが定義される

##lambda
Schemeに戻ろう
先の高階手続きにおいてその引数として使うためだけに
pi_termやpi_nextの手続きを定義するのは煩わしい
このような場合lambdaが使える
lambdaを使ったpi_sum手続きは以下のようになる
{% highlight scheme %}
 (define (pi_sum a b)
	(sum (lambda (x) (/ 1.0 (* x (+ x 2))))
	a
	(lambda (x) (+ x 4))
	b))
;元のpi_sum手続き
 (define (pi_sum a b)
	(define (pi_term x)
		(/ 1.0 (* x (+ x 2))))
	(define (pi_next x)
		(+ x 4))
	(sum pi_term a pi_next b))
{% endhighlight %}
元のpi_sum手続きにおける
sumの引数pi_term, pi_nextに直接
手続きを埋め込んでいるのがわかる

Rubyもlambdaを持っているので
同様のことができる
{% highlight ruby %}
 def pi_sum(a, b)
   sum(lambda { |x| 1.0/(x*(x+2)) }, a, lambda { |x| x + 4 }, b)
 end
 #元のpi_sumメソッド
 def pi_sum(a, b)
   def pi_term(x)
     1.0/(x*(x+2))
   end
   def pi_next(x)
     x + 4
   end
   sum(method(:pi_term), a, method(:pi_next), b)
 end
{% endhighlight %}
Rubyでは手続きはブロックで表現する

メソッドに渡す手続きが一つなら
Rubyではブロックが使える
ブロックの起動はyieldを呼ぶ
{% highlight ruby %}
 def sum(a, _next, b)
   if a > b
     0
   else
     yield(a) + sum(_next.call(a), _next, b){ |a| yield a }
   end
 end
 inc = lambda { |i| i + 1 }
 pi_next = lambda { |i| i + 4 }
 sum(1, inc, 10){ |i| i } # => 55
 sum(1, inc, 10){ |i| i**3 } # => 3025
 8 * sum(1, pi_next, 1000){ |i| 1.0/(i*(i+2)) } # => 3.13959265558978
{% endhighlight %}

##let
Schemeではlambdaは局所変数を作り出すためにも使われる
{% math %}
f(x,y) = x(1 + xy)^2 + y(1 - y) + (1 + xy)(1 - y)
{% endmath %}

という関数を計算したい場合
これは以下のように書ける
{% math %}
a = 1 + xy\\
b = 1 - y\\
f(x,y) = xa^2 + yb + ab
{% endmath %}

手続きfにおいてこの途中のa,bも束縛しておきたい
そのようなときは補助手続きを定義する
{% highlight scheme %}
 (define (f x y)
	(define (f_helper a b)
		(+ (* x (square a))
		     (* y b)
		     (* a b)))
	(f_helper (+ 1 (* x y))
			 (- 1 y)))
{% endhighlight %}
もちろんlambdaが使える
{% highlight scheme %}
 (define (f x y)
	((lambda (a b)
		(+ (* x (square a))
		     (* y b)
		     (* a b)))
	 (+ 1 (* x y))
	 (- 1 y)))
{% endhighlight %}
更にletというものが使える
letを使えば最初にa,bを定義できる
{% highlight scheme %}
(define (f x y)
	(let ((a (+ 1 (* x y)))
		(b (- 1 y)))
	  (+ (* x (square a))
	       (* y b)
	       (* a b))))
{% endhighlight %}
これら3つのRubyの等価コードは以下のようになる
{% highlight ruby %}
 def f(x, y)
   def f_helper(a, b, x, y)
     x*a**2 + y*b + a*b
   end
   f_helper(1+(x*y), 1-y, x, y)
 end
 def f(x, y)
   f_helper = lambda do |a,b|
     x*a**2 + y*b + a*b
   end
   a = 1+(x*y)
   b = 1-y
   f_helper.call(a, b)
 end
 def f(x, y)
   a = 1+(x*y)
   b = 1-y
   x*a**2 + y*b + a*b
 end
{% endhighlight %}
一番上のコードにおいて
Rubyではローカル変数はメソッドを透過できないので
明示的に引数で受け渡す必要がある

関連記事：[Rubyのブロックはメソッドに対するメソッドのMix-inだ！]({{ site.url }}/2008/08/09/Ruby-Mix-in/)

{{ '489471163X' | amazon_large_image }}

{{ '489471163X' | amazon_link }}

{{ '489471163X' | amazon_authors }}
(追記:2009/2/1）タイトルを「RubyでSchemeの高階関数を学ぼう」から「SchemeでRubyの高階関数を学ぼう」に変えました
(追記:2009/2/5)　タイトルを「SchemeでRubyの高階関数を学ぼう」から「SchemeとRubyで高階関数を学ぼう」に変えました
