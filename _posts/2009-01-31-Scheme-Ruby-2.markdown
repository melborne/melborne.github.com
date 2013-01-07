---
layout: post
title: SchemeとRubyで高階関数を学ぼう ~その2~
date: 2009-01-31
comments: true
categories:
tags: [ruby, scheme]
---


[前回]({{ site.url }}/2009/01/29/Scheme-Ruby/)に引き続き「{{ '489471163X' || amazon_link }}」を使って
SchemeとRubyで平方根の求め方と
手続きを出力とする高階手続きをまとめてみました
なおSchemeのコードは本書からの抜粋で
説明は自分の要約です

##Newton法を使って平方根を求める
平方根を求めるとき
通常次々と近似を求めていくNewton法を使う

xの平方根を求める場合任意の予測値yを選び
yとx/yの平均を取っていくことでより良い予測値yが得られる
これを繰り返し十分に良い予測値が得られたら処理を終える
この手続きはSchemeでは以下のように表現できる
{% highlight scheme %}
 (define (sqrt_iter guess x)
 	(if (good_enough? guess x)
 	     guess
 	     (sqrt_iter (improve guess x)
 			      x)))
{% endhighlight %}
予想値guessがgood_enough?になるまで
改善された予想値で処理が繰り返される(improve)

予想値guessを改善する手続きimproveは次のようになる
{% highlight scheme %}
 (define (improve guess x)
 	(average guess (/ x guess)))
 
 (define (average x y)
 	(/ (+ x y) 2))
{% endhighlight %}
任意の許容値を決めて手続きgood_enough?を定義する
ここでは予想値の二乗とxの差が0.001より小さくなるまでとする
{% highlight scheme %}
 (define (good_enough? guess x)
 	(< (abs (- (square guess) x)) 0.001))
 	
 (define (square x)
 	(* x x))
{% endhighlight %}
最後に最初の予想値を1として
平方根を求めるsqrt手続きを定義すれば
任意の数の平方根が得られる
{% highlight scheme %}
 (define (sqrt x)
 	(sqrt_iter 1.0 x))
 
 (sqrt 9)
 3.00009155413138
{% endhighlight %}

次に対応するRubyのコードを書いてみる
同様にNewton法により平方根を求める
{% highlight ruby %}
 def sqrt_iter(guess, x)
   if good_enough?(guess, x)
     guess
   else
     sqrt_iter(improve(guess, x), x)
   end
 end
{% endhighlight %}
improve、good_enough?メソッドは以下のようになる
{% highlight ruby %}
 def improve(guess, x)
   average(guess, x/guess)
 end
 
 def average(x, y)
   (x + y) / 2
 end
 
 def good_enough?(guess, x)
   (square(guess) - x).abs < 0.001
 end
 
 def square(x)
   x * x
 end
{% endhighlight %}
これで平方根を求める準備が整った
{% highlight ruby %}
 def sqrt(x)
   sqrt_iter(1.0, x)
 end
 
 sqrt 9 # => 3.00009155413138
{% endhighlight %}

Rubyはオブジェクト指向言語なので
これらのメソッドを特定のオブジェクトに
結びつけたほうがRubyっぽいかもしれない
ここではNumericクラスのインスタンスメソッドとして
これらの手続きを定義してみる
{% highlight ruby %}
 class Numeric
   def square
     self**2
   end
   
   def sqrt
     sqrt_iter(1.0)
   end
   
   private
   def sqrt_iter(guess)
     if good_enough?(guess, self)
       guess
     else
       sqrt_iter(improve(guess))
     end
   end
   
   def improve(guess)
     average(guess, self/guess)
   end
   
   def average(x, y)
     (x + y) / 2
   end
   
   def good_enough?(guess, x)
     (guess.square - x).abs < 0.001
   end
 end
 
 2.sqrt # => 1.41421568627451
 2.square # => 4
{% endhighlight %}
sqrt,square以外のメソッドが
外から呼び出せるのは適当でないから
それらのメソッドはprivateとした

##不動点探索を使って平方根を求める
平方根は不動点探索を使っても求めることができる
xがf(x)=xを満たすとき、xを関数fの不動点(fixed point)という
予想値からはじめて関数fを繰り返し適用することで
不動点を見つけることができる

Schemeで表現すると以下のようになる
手続きfixed_pointは入力として
関数fと最初の予想値first_guessを取る
{% highlight scheme %}
(define tolerance 0.00001)
 
 (define (fixed_point f first_guess)
 	(define (close_enough? v1 v2)
 		(< (abs (- v1 v2)) tolerance))
 	(define (try guess)
 		(let ((next (f guess)))
 			(if (close_enough? guess next)
 			     next
 			    (try next))))
 	(try first_guess))
{% endhighlight %}
補助手続きとしてclose_enough?,tryを定義し抽象化する
これを用いて例えば
方程式 \\(y=\sin y + \cos y\\) の解が得られる
{% highlight scheme %}
 (fixed_point (lambda (y) (+ (sin y) (cos y)))
 		 1.0)
 1.25873159629712
{% endhighlight %}

平方根の計算は不動点探索の問題に置き換えられる
つまりxの平方根の計算は y^2 = x なるyを探すことだから
これはy=x/yと書けy -> x/yの不動点を探しているのと等価である
先のfixed_point手続きを使って平方根を求めてみよう
{% highlight scheme %}
 (define (sqrt x)
 	(fixed_point (lambda (y) (average y (/ x y)))
 		1.0))
 		
 (sqrt 3)
 1.73205080756888
{% endhighlight %}
なおfixed_pointに渡す関数fをx/yとすると
うまく収束しないのでここでは
yとx/yの平均を使っている
これを平均緩和法(average damping)という

同様のことをRubyでやってみる
まずfixed_pointメソッドを定義する
{% highlight ruby %}
 Tolerance = 0.00001
 def fixed_point(f, first_guess)
   def close_enough?(v1, v2)
     (v1 - v2).abs < Tolerance
   end
   try = lambda do |guess|
     _next = f.call(guess)
     if close_enough?(guess, _next)
       _next
     else
       try.call(_next)
     end
   end
   try.call(first_guess)
 end
 
 fixed_point(lambda{ |y| Math.sin(y) + Math.cos(y) }, 1.0) # =>  1.25873159629712
{% endhighlight %}
Rubyではローカル変数はメソッドを透過できないので
tryをメソッドではなくブロックで定義し
引数として渡される関数fが参照できるようにした

平方根を求めよう
{% highlight ruby %}
 def sqrt(x)
   fixed_point(lambda { |y| average(y, x/y) }, 1.0)
 end
 
 sqrt 3 # => 1.73205080756888
{% endhighlight %}
fixed_pointをMathモジュールとしたほうが
Rubyっぽいかもしれない
{% highlight ruby %}
 module Math
   def self.fixed_point(first_guess)
     @first_guess = first_guess
     _next = yield(first_guess)
     if close_enough?(first_guess, _next)
       _next
     else
       self.fixed_point(_next){ yield(@first_guess) }
     end
   end
 
   private
   Tolerance = 0.00001
   def self.close_enough?(v1, v2)
     (v1 - v2).abs < Tolerance
   end
 end
 
 Math.fixed_point(1.0){ |y| Math.sin(y) + Math.cos(y) } # => 1.25873159629712
 
 class Numeric
   def sqrt
     Math.fixed_point(1.0) { |y| average(y, self/y) }
   end
 end
 
 3.sqrt # => 1.73205080756888
{% endhighlight %}

##手続きを返す高階手続き
平方根を求めるのに先の例では平均緩和法を使った
今度は手続きを返すSchemeの高階手続きを使って
これを一般化する

次の手続きaverage_dampは引数として手続きfをとり
手続きを返す高階手続きである
{% highlight scheme %}
 (define (average_damp f)
	(lambda (x) (average x (f x))))
{% endhighlight %}
例えばこれに x を x^2 とする手続きsquareを渡すと
x と x^2 の平均を値とする手続きを返す
だから例えばこの返された手続きに10を作用させると
10と100の平均が得られる
{% highlight scheme %}
(average_damp square) 10)
55
{% endhighlight %}
これを用いて先の手続きsqrtを書き換える
{% highlight scheme %}
 (define (sqrt x)
	(fixed_point (average_damp (lambda (y) (/ x y)))
				 1.0))
 (sqrt 3)
 1.73205080756888
;先のコード
(define (sqrt x)
	(fixed_point (lambda (y) (average y (/ x y)))
		1.0))
{% endhighlight %}

同様の高階手続きをRubyでもやってみる
average_dampメソッドは以下のようになる
{% highlight ruby %}
 def average_damp(f)
   lambda { |x| average(x, f.call(x)) }
 end
 
 def sqrt(x)
   fixed_point(average_damp(lambda { |y| x/y }), 1.0)
 end
 
 sqrt 3 # => 1.73205080756888
{% endhighlight %}
average_dampはProcオブジェクトを返す

ブロックを使えば
もう少しRubyらしくなる
{% highlight ruby %}
 def average_damp
   lambda { |x| average(x, yield(x)) }
 end
 
 def sqrt(x)
   fixed_point(average_damp{ |y| x/y }, 1.0)
 end
 
 sqrt 3 # => 1.73205080756888
{% endhighlight %}
さらにsqrtをNumericクラスのインスタンスメソッドにしてみる
{% highlight ruby %}
 class Numeric
   def sqrt
     Math.fixed_point(1.0) { |y| average_damp{ |x| self/x }.call(y) }
   end
   
   private
   def average_damp
     lambda { |x| average(x, yield(x)) }
   end
 end
 
 3.sqrt # => 1.73205080756888
{% endhighlight %}

(追記:2009/2/1）タイトルを「RubyでSchemeの高階関数を学ぼう~その2~」から「SchemeでRubyの高階関数を学ぼう~その2~」に変えました
(追記:2009/2/5)　タイトルを「SchemeでRubyの高階関数を学ぼう~その2~」から「SchemeとRubyで高階関数を学ぼう~その2~」に変えました
