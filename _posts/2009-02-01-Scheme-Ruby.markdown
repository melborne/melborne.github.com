---
layout: post
title: SchemeとRubyでデータ抽象を学ぼう
date: 2009-02-01
comments: true
categories:
tags: [ruby, scheme]
---


[前回](/2009/01/31/notitle/)に引き続き「{{ '489471163X' | amazon_link }}」を使って
今度はSchemeとRubyにおける
データ抽象の違いを見ていこうと思います
なおSchemeのコードは本書からの抜粋で
説明は自分の要約です

##有理数演算手続き
有理数に対する演算(例えばadd_rat)を考えるとき
分子と分母の数値を個別で取り扱う手続きを考えるよりも
分子と分母を対とした一つの有理数を対象に
手続きを考えられたら楽である

Schemeでは合成データを使って有理数を表現し
この抽象データに対しての演算手続きを表現することで
データ抽象を実現する

Schemeで有理数に対する算術演算
add_rat, sub_rat, mul_rat, div_rat, equal_rat?を考える
有理数に対する演算式は次の通りである

![Alt expression]({{ site.url }}/assets/images/2009-02-01-Scheme-Ruby.png)

整数nと整数dを取って
分子がn分母がdの有理数を返す手続きをmake_ratとし
make_ratで作られた有理数の分子を返す手続きをnumer
分母を返す手続きをdenomとした場合
Schemeによる上の演算表現は以下のようになる
{% highlight scheme %}
 (define (add_rat x y)
        (make_rat (+ (* (numer x) (denom y))
                                (* (numer y) (denom x)))
                           (* (denom x) (denom y))))
 
 (define (sub_rat x y)
        (make_rat (- (* (numer x) (denom y))
                               (* (numer y) (denom x)))
                           (* (denom x) (denom y))))
 
 (define (mul_rat x y)
       (make_rat (* (numer x) (numer y))
                          (* (denom x) (denom y))))
 
 (define (div_rat x y)
       (make_rat (* (numer x) (denom y))
                          (* (denom x) (numer y))))
 
 (define (equal_rat? x y)
       (= (* (numer x) (denom y))
            (* (numer y) (denom x))))
{% endhighlight %}

これらの演算をRubyで表現してみる
{% highlight ruby %}
 def add_rat(x, y)
   make_rat numer(x) * denom(y) + numer(y) * denom(x), 
            denom(x) * denom(y)
 end
 
 def sub_rat(x, y)
   make_rat numer(x) * denom(y) - numer(y) * denom(x),
            denom(x) * denom(y)
 end
 
 def mul_rat(x, y)
   make_rat numer(x) * numer(y),
            denom(x) * denom(y)
 end
 
 def div_rat(x, y)
   make_rat numer(x) * denom(y),
            denom(x) * numer(y)
 end
 
 def equal_rat?(x, y)
   numer(x) * denom(y) == numer(y) * denom(x)
 end
{% endhighlight %}

##有理数のデータ表現
Schemeに戻ろう
次に有理数を表現するために
手続きconsで構成される対を使う
consは2つの引数を取り
これらを部分として含む合成データオブジェクトを返す
合成データオブジェクトの部分は手続きcarとcdrで取り出せる
{% highlight scheme %}
 (define x (cons 1 2))
 (car x)
 1
 (cdr x)
 2
{% endhighlight %}

これらを使って有理数を表現する
{% highlight scheme %}
 (define (make_rat n d) (cons n d))
 (define (numer x) (car x))
 (define (denom x) (cdr x))
{% endhighlight %}
また結果を表示する手続きを加える
{% highlight scheme %}
 (define (print_rat x)
 	 (newline)
 	(display (numer x))
 	(display "/")
 	(display (denom x)))
{% endhighlight %}
これで有理数演算ができるようになった
{% highlight scheme %}
 (define one_half (make_rat 1 2))
 
 (print_rat one_half)
 1/2
 (define one_third (make_rat 1 3))
 
 (print_rat (add_rat one_half one_third))
 5/6
 (print_rat (mul_rat one_half one_third))
 1/6
 (print_rat (add_rat one_third one_third))
 6/9
{% endhighlight %}
なお最後の例を見るとわかるが
先の手続きは簡約まではしない
最大公約数gcdを使ってこれを改善する
{% highlight scheme %}
(define (make_rat n d)
 	(let ((g (gcd n d)))
 	 (cons (/ n g) (/ d g))))
{% endhighlight %}

さてRubyでも有理数を表現してみる
Rubyでは配列を使うのがよさそうだ
{% highlight ruby %}
 reqire 'rational'
 def make_rat(n, d)
   g = n.gcd(d)
   [n/g, d/g]
 end
 
 def numer(x)
   x[0]
 end
 
 def denom(x)
   x[1]
 end
 
 def print_rat(x)
   puts "#{numer x}/#{denom x}"
 end
{% endhighlight %}
gcdを使うのにrationalライブラリをrequireする
演算結果は以下の通り
{% highlight ruby %}
 def one_half
   make_rat 1, 2
 end
 print_rat one_half
 
 def one_third
   make_rat 1, 3
 end
 print_rat one_third
 
 print_rat add_rat(one_half, one_third)
 
 print_rat mul_rat(one_half, one_third)
 
 print_rat add_rat(one_third, one_third)
 # >> 1/2
 # >> 1/3
 # >> 5/6
 # >> 1/6
 # >> 2/3
{% endhighlight %}

##クラスによるデータ抽象
でもこれは実にRubyっぽくない
Rubyではデータ抽象にクラスを使うのがよさそうだ
有理数クラスRatを定義してみる
{% highlight ruby %}
 require "rational"
 class Rat
   attr_reader :numer, :denom
   def initialize(n, d)
     g = n.gcd d
     @numer, @denom = n/g, d/g
   end
   
   def +(other)
    Rat.new(self.numer * self.denom + other.numer * other.denom,
             self.denom * other.denom)
   end
   
   def -(other)
    Rat.new(self.numer * other.denom - other.numer * self.denom,
             self.denom * other.denom)
   end
   
   def *(other)
     Rat.new(self.numer * other.numer,
             self.denom * other.denom)
   end
   
   def /(other)
     Rat.new(self.numer * other.denom,
             self.denom * other.numer)
   end
   
   def ==(other)
     self.numer * other.denom == other.numer * self.denom
   end
   
   def to_s
     "#{self.numer}/#{self.denom}"
   end
 end
 
 one_half = Rat.new(1, 2) # => #<Rat:0x140dc @numer=1, @denom=2>
 one_third = Rat.new(1, 3) # =>#<Rat:0x13ce0 @numer=1, @denom=3>
 
 one_third.denom # => 3
 
 one_half.to_s # => "1/2"
 (one_third + one_third).to_s # => "2/3"
 (one_half * one_third).to_s # => "1/6"
 (one_half / one_third).to_s # => "3/2"
 one_half == one_third # => false
{% endhighlight %}
newで渡した引数を分子分母とする
有理数クラスのインスタンスを生成する
分子分母にはnumer、denomメソッドでアクセスできる
各算術演算は整数と同じ記号を使え
算術の結果は有理数クラスのインスタンスで返される

もちろんRubyには標準でRationalクラスがある
{% highlight ruby %}
 one_half = Rational(1, 2)
 one_third = Rational(1, 3)
 one_half * one_third # => Rational(1, 6)
 one_half /one_third # => Rational(3, 2)
{% endhighlight %}

{{ '489471163X' | amazon_medium_image }}
{{ '489471163X' | amazon_link }}

(追記:2009/2/5)　タイトルを「SchemeでRubyのデータ抽象を学ぼう」から「SchemeとRubyでデータ抽象を学ぼう」に変えました
