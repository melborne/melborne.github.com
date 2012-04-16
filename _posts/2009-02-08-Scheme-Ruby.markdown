---
layout: post
title: SchemeとRubyで写像の入れ子を学ぼう
date: 2009-02-08
comments: true
categories:
tags: [ruby, scheme]
---


引き続き「{{ '489471163X' | amazon_link }}」を使って
SchemeとRubyで写像の入れ子を見ていきます
なおSchemeのコードは本書からの抜粋で
説明は自分の要約です

##整数の和の素数列
1からnの範囲において j < i なる2つの整数 i, j の和が
素数になるものを見つける例を通して写像の入れ子を学ぼう

nが6の場合のペアは以下のようになる

> i      2  3  4  4  5  6  6
> j      1  2  1  3  2  1  5
> i+j    3  5  5  7  7  7  11

戦略としてはn以下の正の整数のすべてのペア(i, j)を生成し
その合計が素数であるものを選択し
選択されたペアからそれに合計を加えたセット(i, j, i+j)を作る
{% highlight scheme %}
 (accumulate append
    `()
    (map (lambda (i)
       (map (lambda (j) (list i j))
            (enumerate_interval 1 (- i 1))))
          (enumerate_interval 1 n)))
{% endhighlight %}
enumerate_interval 1 nで1からnの各整数iを生成し
これを次の段のmap手続きに渡すmap手続きに作用させる
次段のmapでは受け取った整数iに対し
enumerate_interval 1 (- i 1)で1からi-1の整数jを生成し
リストi jを生成する
これをaccumulate手続きに渡したappendで
順次並べていけば目的の対のセットができ上がる

次にその和が素数であるものを見つける手続きprime_sum?と
結果のセットを作る手続きmake_pair_sumを書く
{% highlight scheme %}
 (define (prime_sum? pair)
    (prime? (+ (car pair) (cadr pair))))
 
    
 (define (make_pair_sum pair)
    (list (car pair) (cadr pair) (+ (car pair) (cadr pair))))
{% endhighlight %}
これらを繋いで目的の手続きprime_sum_pairsが得られる
{% highlight scheme %}
(define (prime_sum_pairs n)
    (map make_pair_sum
       (filter prime_sum?
          (flatmap
             (lambda (i)
                (map (lambda (j) (list i j))
                   (enumerate_interval 1 (- i 1))))
             (enumerate_interval 1 n)))))
 
 (prime_sum_pairs 6)
 ((2 1 3) (3 2 5) (4 1 5) (4 3 7) (5 2 7) (6 1 7) (6 5 11))
{% endhighlight %}

なおここではmapとappendによるaccumulateの手続きを
flatmap手続きとして抽象化している
{% highlight scheme %}
 (define (flatmap proc seq)
    (accumulate append `() (map proc seq)))
{% endhighlight %}

##Ruby版素数列
同じことをRubyでもやってみる
{% highlight ruby %}
 def flatmap(proc, seq)
   accumulate(:append, nil, map(proc, seq))
 end
 
 def prime_sum?(pair)
   prime?(car(pair) + car(cdr(pair)))
 end
 
 def make_pair_sum(pair)
   a, b = car(pair), car(cdr(pair))
   list a, b, a+b
 end
 
 def prime_sum_pairs(n)
   mapping = lambda { |i| map(lambda { |j| list i, j }, enumerate_interval(1, i-1)) }
   seq = enumerate_interval(1, n)
   list = filter(method(:prime_sum?), flatmap(mapping, seq))
   map(method(:make_pair_sum), list)
 end
 
 def _p(x)
   x.join(" ").chop
 end
 
 _p prime_sum_pairs 6 # => "2 1 3  3 2 5  4 1 5  4 3 7  5 2 7  6 1 7  6 5 11 "
{% endhighlight %}

##Arrayクラス版素数列
Arrayクラスの各種メソッドを使えば
もう少しRubyらしくなる
{% highlight ruby %}
 def pairs(n)
   (1..n).map { |i| (1...i).map { |j| [i, j] } }.flatten(1)
 end
 pairs 6 # => [[2, 1], [3, 1], [3, 2], [4, 1], [4, 2], [4, 3], [5, 1], [5, 2], [5, 3], [5, 4], [6, 1], [6, 2], [6, 3], [6, 4], [6, 5]]
 
 def prime_sum?(pair)
   prime? pair.inject(:+)
 end
 
 def make_list(pair)
   pair << pair.inject(:+)
 end
 
 def prime_sum_pairs(n)
   pairs(n).inject([]) { |arr, pair| prime_sum?(pair) ? arr << make_list(pair) : arr}
 end
 
 prime_sum_pairs 6 # => [[2, 1, 3], [3, 2, 5], [4, 1, 5], [4, 3, 7], [5, 2, 7], [6, 1, 7], [6, 5, 11]]
{% endhighlight %}

##集合Sの順列
Schemeに戻って
先のflatmap手続きを使って
集合Sのすべての順列を求めてみよう
{% highlight scheme %}
(define (permutations s)
    (if (null? s)
       (list `())
       (flatmap (lambda (x)
                (map (lambda (p) (cons x p))
                    (permutations (remove x s))))
              s)))
 
 (permutations (list 1 2 3))
 ((1 2 3) (1 3 2) (2 1 3) (2 3 1) (3 1 2) (3 2 1))
{% endhighlight %}
内側のmap手続きで
外側のflatmapから渡された要素xを除く集合に対し
すべての組の順列を求めることを再帰的に繰り返す

要素xを除く手続きは以下のようになる
{% highlight scheme %}
 (define (remove item seq)
    (filter (lambda (x) (not (= x item)))
       seq))
{% endhighlight %}

##Ruby版順列
Rubyでもpermutationsを書いてみる
{% highlight ruby %}
 def permutations(s)
   mapping = lambda { |x| map(lambda { |p| cons x, p }, permutations(remove x, s)) }
   if s.nil?
     list nil
   else
     flatmap(mapping, s)
   end
 end
 
 def remove(item, seq)
   filter(lambda { |x| x != item }, seq)
 end
 
 _p permutations(list 1, 2, 3) # => "1 2 3  1 3 2  2 1 3  2 3 1  3 1 2  3 2 1 "
{% endhighlight %}

RubyのArrayクラスにはpermutationというメソッドが既にある
{% highlight ruby %}
 List[1, 2, 3].permutation.to_a # => [[1, 2, 3], [1, 3, 2], [2, 1, 3], [2, 3, 1], [3, 1, 2], [3, 2, 1]]
{% endhighlight %}

{{ '489471163X' | amazon_large_image }}

{{ '489471163X' | amazon_link }}

{{ '489471163X' | amazon_authors }}
