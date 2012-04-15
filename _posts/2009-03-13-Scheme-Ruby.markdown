---
layout: post
title: SchemeとRubyで記号微分を学ぼう
date: 2009-03-13
comments: true
categories:
tags: [ruby, scheme]
---


引き続き「{{ '489471163X' | amazon_link }}」を使って、今度はSchemeとRubyでの記号データの扱い方を見ていこうと思います。なおSchemeのコードは本書からの抜粋で、説明は自分の要約です。

Schemeではクオート(｀)を使ってデータオブジェクトを記号として表現できる。
{% highlight scheme %}
 (list `a `b)
 (a b)
{% endhighlight %}
クオートを使えばa, bは値を指す変数ではなく、記号として解釈される。

この能力を使って、代数式の記号微分を実行する手続きを作る。この手続きは引数として記号を含んだ代数式と変数を取り、代数式のこの変数に関する微分を返す。例えば `ax^2 + bx + c` と `x` なら `2ax + b` が返る

ここでは2つの引数を持った加算と乗算と累乗からなる式を扱う。この微分の規則は次の通りである。
 
![Alt differenciation]({{ site.url }}/assets/images/2009-03-13-Scheme-Ruby.png)

この規則をSchemeで表現すれば以下の通りである。
{% highlight scheme %}
 (define (deriv exp var)
    (cond ((number? exp) 0)
         ((variable? exp)
          (if (same_variable? exp var) 1 0))
         ((sum? exp)
          (make_sum (deriv (addend exp) var)
                  (deriv (augend exp) var)))
         ((product? exp)
          (make_sum
             (make_product (multiplier exp)
                        (deriv (multiplicand exp) var))
             (make_product (deriv (multiplier exp) var)
                        (multiplicand exp))))
         ((exponentiation? exp)
          (make_product
             (make_product (exponent exp)
                        (make_exponentiation (base exp)
                                        (- (exponent exp) 1)))
             (deriv (base exp) var)))
         (else
          (error "unknown expression type -- DERIV" exp))))
{% endhighlight %}

このコードはまだ未定義の以下のサブ手続きを含んでいる。

> (variable? e)  ｅは変数か
> (same_variable? v1 v2)  v1, v2は同じ変数か
> (sum? e)  eは和か
> (addend e)  eの加数
> (augend e)  eの被加数
> (make_sum a1 a2)  a1, a2の和を構成
> (product? e)  eは積か
> (multiplier e)  eの乗数
> (multiplicand e)  eの被乗数
> (make_product m1 m2)  m1, m2の積を構成
> (exponentiation? e)  eは累乗か
> (base e)  eの基数
> (exponent e)  eの指数
> (make_exponentiation e1 e2)  e1, e2の累乗を構成


次にこれらの手続きを実装しよう。
{% highlight scheme %}
 (define (variable? x) (symbol? x))
 
 (define (same_variable? v1 v2)
    (and (variable? v1) (variable? v2) (eq? v1 v2)))
 
 (define (make_sum a1 a2) (list `+ a1 a2))
 
 (define (=number? exp num)
    (and (number? exp) (= exp num)))
 
 (define (make_product m1 m2) (list `* m1 m2))
 
 (define (sum? x)
    (and (pair? x) (eq? (car x) `+)))
    
 (define (addend s) (cadr s))
 
 (define (augend s) (caddr s))
 
 (define (product? x)
    (and (pair? x) (eq? (car x) `*)))
    
 (define (multiplier p) (cadr p))
 
 (define (multiplicand p) (caddr p))
 
 (define (exponentiation? x)
    (and (pair? x) (eq? (car x) `**)))
    
 (define (base e) (cadr e))
 
 (define (exponent e) (caddr e))
 
 (define (make_exponentiation e1 e2) (list `** e1 e2))
{% endhighlight %}

実装が済んだら早速試してみよう。
{% highlight scheme %}
 (deriv `(+ x 3) `x)
 (deriv `(* x y) `x)
 (deriv `(* (* x y) (+ x 3)) `x)
 (deriv `(+ (* a (** x 2)) (* b x)) `x)
 
 (+ 1 0)
 (+ (* x 0) (* 1 y))
 (+ (* (* x y) (+ 1 0)) (* (+ (* x 0) (* 1 y)) (+ x 3)))
 (+ (+ (* a (* (* 2 (** x 1)) 1)) (* 0 (** x 2))) (+ (* b 1) (* 0 x)))
{% endhighlight %}
正しい答えが出た。でも簡約されていない。

基のderiv手続きに変更を加えることなく、make_sum, make_product, make_exponentiationを変更することで簡約を実現しよう。

make_sumには両方のオペランドが数値ならそれらを足し、一方が0なら他方のオペランドを返す条件を加える。
{% highlight scheme %}
(define (make_sum a1 a2)
    (cond ((=number? a1 0) a2)
         ((=number? a2 0) a1)
         ((and (number? a1) (number? a2)) (+ a1 a2))
          (else (list `+ a1 a2))))
 
 (define (=number? exp num)
    (and (number? exp) (= exp num)))
{% endhighlight %}
サブ手続き`=number?`は数が等しいか見る。

make_productでは両方のオペランドが数値ならそれらを掛け、一方が0なら0を、1なら他のオペランドを返す条件を加える。
{% highlight scheme %}
 (define (make_product m1 m2)
    (cond ((or (=number? m1 0) (=number? m2 0)) 0)
         ((=number? m1 1) m2)
         ((=number? m2 1) m1)
         ((and (number? m1) (number? m2)) (* m1 m2))
         (else (list `* m1 m2))))
{% endhighlight %}

make_exponentiationでは、指数が0なら1を1なら基数を返す条件を加える。
{% highlight scheme %}
 (define (make_exponentiation e1 e2)
    (cond ((=number? e2 0) 1)
         ((=number? e2 1) e1)
         (else (list `** e1 e2))))
{% endhighlight %}

これらの変更により簡約された結果が得られる。
{% highlight scheme %}
 (deriv `(+ x 3) `x)
 (deriv `(* x y) `x)
 (deriv `(* (* x y) (+ x 3)) `x)
 (deriv `(+ (* a (** x 2)) (* b x)) `x)
 
 1
 y
 (+ (* x y) (* y (+ x 3)))
 (+ (* a (* 2 x)) b)
{% endhighlight %}

##Rubyによる記号微分
同じことをRubyでも挑戦してみよう。Rubyでは記号を表現するためにシンボル(Symbol)と文字列(String)が使えそうだ。

まずはderivメソッドを書く。
{% highlight ruby %}
 def deriv(exp, var)
   case exp
   when Numeric
     0
   when Symbol, String
     same_variable?(exp, var) ? 1 : 0
   when Sum
     make_sum deriv(addend(exp), var), deriv(augend(exp), var)
   when Product
     m1 = make_product multiplier(exp), deriv(multiplicand(exp), var)
     m2 = make_product deriv(multiplier(exp), var), multiplicand(exp)
     make_sum(m1, m2)
   when Exponentiation
     e1 = make_product(exponent(exp), make_exponentiation(base(exp), exponent(exp)-1))
     e2 = deriv(base(exp), var)
     make_product(e1, e2)
   else
     raise "unknown expression type -- DERIV #{exp.inspect}"
   end
 end
{% endhighlight %}

記号をシンボルまたは文字列で表現したので、引数expが和であるか積であるか累乗であるかを判断するために、それぞれに別のクラスSum、Product、Exponentiationを定義するのがよさそうだ。
{% highlight ruby %}
 class Sum
   def self.===(x)
     pair?(x) and car(x).equal? :+
   end
 end
 
 class Product
   def self.===(x)
     pair?(x) and car(x).equal? :*
   end
 end
 
 class Exponentiation
   def self.===(x)
     pair?(x) and car(x).equal? :**
   end
 end
{% endhighlight %}
case文での判断は===メソッドでなされるので、それぞれに専用メソッドを定義する。

他のメソッドはSchemeと同様に定義すればいい。
{% highlight ruby %}
 def same_variable?(exp, var)
   exp == var ? true : false
 end
 
 def make_sum(a1, a2)
   if eql_number?(a1, 0)
     a2
   elsif eql_number?(a2, 0)
     a1
   elsif Numeric === a1 and Numeric === a2
     a1 + a2
   else
     list :+, a1, a2
   end
 end
 
 def eql_number?(exp, num)
   Numeric === exp and exp == num
 end
 
 def make_product(m1, m2)
   if eql_number?(m1, 0) or eql_number?(m2, 0)
     0
   elsif m1 == 1
     m2
   elsif m2 == 1
     m1
   elsif Numeric === m1 and Numeric === m2
     m1 * m2
   else
     list :*, m1, m2
   end
 end
 
 def addend(s)
   cadr s
 end
 
 def augend(s)
   caddr s
 end
 
 def multiplier(p)
   cadr p
 end
 
 def multiplicand(p)
   caddr p
 end
 
 def base(e)
   cadr e
 end
 
 def exponent(e)
   caddr e
 end
 
 def make_exponentiation(e1, e2)
   if e2 == 0
     1
   elsif e2 == 1
     e1
   else
     list :**, e1, e2
   end
 end
{% endhighlight %}

リストは以前実装したlistメソッドを使って作る。このリストはSchemeのリスト同様consの入れ子になっている。リストをキレイに出力するlist_pメソッドも定義した。
準備が整ったので実行してみよう
{% highlight ruby %}
 list_p deriv list(:+, :x, 3), :x
 list_p deriv list(:*, :x, :y), :x
 list_p deriv list(:*, list(:*, :x, :y), list(:+, :x, 3)), :x
 list_p deriv list(:+, list(:*, :a, list(:**, :x, 2)), list(:*, :b, :x)), :x
 
 # >> 1
 # >> y
 # >> (+ (* x y) (* y (+ x 3)))
 # >> (+ (* a (* 2 x)) b)
{% endhighlight %}

コードを以下に置きました。
http://gist.github.com/64646
