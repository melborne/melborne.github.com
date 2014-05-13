---
layout: post
title: SchemeとRubyで接続インタフェースを学ぼう
date: 2009-02-06
comments: true
categories:
tags: [ruby, scheme]
---


引き続き「{{ '489471163X' | amazon_link }}」を使って
SchemeとRubyでリストの接続インタフェース{% fn_ref 1 %}
としての使用について見ていこうと思います
なおSchemeのコードは本書からの抜粋で
説明は自分の要約です

##リストの接続インタフェースとしての使用
いま構造的に大きく異なった2つの手続きをみていく
１つは引数としてtreeを取り
それが奇数である葉の二乗の和を計算する手続きであり
１つは整数n以下のkに対して
偶数のフィボナッチ数のリストを作る手続きである

前者の手続きはSchemeで以下のように表現できる
{% highlight scheme %}
(define (sum_odd_squares tree)
       (cond ((null? tree) 0)
                  ((not (pair? tree))
                       (if (odd? tree) (square tree) 0))
                  (else (+ (sum_odd_squares (car tree))
                                 (sum_odd_squares (cdr tree))))))
 
 (define tree (list 1 (list 2 (list 3 4) 5 (list 6 7))))
 (sum_odd_squares tree)
 84
{% endhighlight %}
treeをcarダウンおよびcdrダウンしていき
その葉が奇数であるときにその二乗を取り加算する

一方後者の手続きは以下のようになる
{% highlight scheme %}
(define (even_fibs n)
       (define (next k)
             (if (> k n)
                 `()
             (let ((f (fib k)))
                  (if (even? f)
                       (cons f (next (+ k 1)))
                       (next (+ k 1))))))
        (next 0))
 
 (even_fibs 20)
 (0 2 8 34 144 610 2584)
{% endhighlight %}
k番目のフィボナッチ数を求める手続きをfib(k)とし
その結果が偶数であるときにconsで
選択されたフィボナッチ数の列を構築していく

##手続きの部品化
これらの手続きは構造的には大きく異なっているが
それらの計算のより抽象的なレベルでは類似性がある

つまり

- 葉を数え上げる <-> 整数をnまで数え上げる(enumarate)
- 奇数のものを選ぶ <-> 偶数のものを選ぶ(filter)
- 選ばれたものを二乗する <-> 各整数のフィボナッチ数を計算する(map)
- 結果を足し合わせていく <-> 結果をconsしていく(accumurate)

これら各手続きを抽象化された部品として構築し
リストをこれらの接続インタフェースとして使用することによって
プログラマはあたかも信号処理技術者のように
信号処理に必要な標準化部品を選び
これらを接続することによって複雑さを制御できるようになる

このことをこれから示そう
まず最初の標準化部品としてmap手続きを書こう
{% highlight scheme %}
 (define (map proc items)
        (if (null? items)
             `()
         (cons (proc (car items))
                    (map proc (cdr items)))))
{% endhighlight %}
これはリストの二乗計算にも
フィボナッチ数演算にも使え
結果はリストで返される
{% highlight scheme %}
 (map square (list 1 2 3 4 5))
 (1 4 9 16 25)
 
 (map fib (list 0 1 2 3 4 5 6 7 8))
 (0 1 1 2 3 5 8 13 21)
{% endhighlight %}

次に条件を満たした要素だけを選び出す
filter手続きを書こう
{% highlight scheme %}
(define (filter predicate sequence)
        (cond ((null? sequence) `())
                 ((predicate (car sequence))
                          (cons (car sequence)
                                  (filter predicate (cdr sequence))))
                  (else (filter predicate (cdr sequence)))))
 
 (p (filter odd? (list 1 2 3 4 5)))
 (1 3 5)
 (p (filter even? (list 1 2 3 4 5)))
 (2 4)
{% endhighlight %}
predicateの条件を満たした要素だけの
新たなリストをconsで作成していく

結果を順次継ぎ足していく
accumurate手続きは以下のようになる
{% highlight scheme %}
 (define (accumulate op initial sequence)
         (if (null? sequence)
               initial
              (op (car sequence)
                     (accumulate op initial (cdr sequence)))))
 
 (accumulate + 0 (list 1 2 3 4 5))
 15
 (accumulate * 1 (list 1 2 3 4 5))
 120
 (accumulate cons `() (list 1 2 3 4 5))
 (1 2 3 4 5)
{% endhighlight %}
引数opに目的の演算を渡すことによって
それに沿った継ぎ足しが行われる

enumarate手続きは各異なるものが必要だ
木の葉を数え上げるenumarate_treeを最初に定義しよう
{% highlight scheme %}
(define (enumerate_tree tree)
        (cond ((null? tree) `())
                 ((not (pair? tree)) (list tree))
                 (else (append (enumerate_tree (car tree))
                                          (enumerate_tree (cdr tree))))))
 
 (enumerate_tree (list 1 (list 2 (list 3 4)) 5))
 (1 2 3 4 5)
{% endhighlight %}

整数をnまで数え上げるenumarate_intervalは以下のようになる
{% highlight scheme %}
 (define (enumerate_interval low high)
         (if (> low high)
              `()
              (cons low (enumerate_interval (+ low 1) high))))
 
 (enumerate_interval 2 7)
 (2 3 4 5 6 7)
{% endhighlight %}

##部品の接続
これで標準化部品が揃ったので
これらを使って
最初のsum_odd_squaresとeven_fibを
定義し直そう
{% highlight scheme %}
  (define (sum_odd_squares tree)
        (accumulate +
             0
             (map square
                      (filter odd?
                            (enumerate_tree tree)))))
  
  (define tree (list 1 (list 2 (list 3 4) 5 (list 6 7))))
  
  (sum_odd_squares tree)
  84
  
  (define (even_fibs n)
       (accumulate cons
            `()
             (filter even?
                    (map fib
                           (enumerate_interval 0 n)))))
  (even_fibs 20)
  (0 2 8 34 144 610 2584)
{% endhighlight %}

このような標準化部品のライブラリがあれば
例えば個人レコードから最高収入のプログラマの給料を抽出する
といった処理のプログラムを簡単に書くことができる
{% highlight scheme %}
 (define (salary_of_highest_paid_programmer records)
         (accumulate max
                  0
                  (map salary
                          (filter programmer? records))))
{% endhighlight %}

##Rubyでの実装
最初に検討される2つの手続き
sum_odd_squaresとeven_fibsをRubyで書いてみる
なおconsおよびlistの定義は前回を参照のこと{% fn_ref 8 %}
{% highlight ruby %}
 def sum_odd_squares(tree)
   case
   when tree.nil? then 0
   when !pair?(tree)
     if tree.odd?
       square(tree)
     else
       0
     end
   else
     sum_odd_squares(car tree) + sum_odd_squares(cdr tree)
   end
 end
 
 tree = list 1, (list 2, (list 3, 4), 5, (list 6, 7))
 sum_odd_squares tree # => 84
 
 def fib(n)
   case
   when n == 0 then 0
   when n == 1 then 1
   else
     fib(n-1) + fib(n-2)
   end
 end
 
 def even_fibs(n)
   _next = lambda do |k|
     if k > n
       nil
     else
       f = fib(k)
       if f.even?
         cons f, _next.call(k+1)
       else
         _next.call(k+1)
       end
     end
   end
   _next.call 0
 end
 
 p even_fibs 20 # => "0 2 8 34 144 610 2584"
{% endhighlight %}

Rubyではmapメソッドは以下のようになる
{% highlight ruby %}
 def map(proc, items)
   if items.nil?
     nil
   else
     cons send(proc, car(items)), map(proc, cdr(items))
   end
 end
 
 tree = list 1, 2, 3, 4, 5
 p map(:square, tree) # => "1 4 9 16 25"
{% endhighlight %}
procへの手続きの引き渡しはシンボルで行い
これをsendメソッドに渡すことによって呼び出す

filterメソッドは以下のようになる
{% highlight ruby %}
 def filter(predicate, sequence)
   case
   when sequence.nil? then nil
   when (car sequence).send(predicate)
     cons car(sequence), filter(predicate, cdr(sequence))
   else
     filter(predicate, cdr(sequence))
   end
 end
 
 p filter(:odd?, list(1, 2, 3, 4, 5)) # => "1 3 5"
{% endhighlight %}

accumurateメソッドは以下のようになる
{% highlight ruby %}
 def accumulate(op, initial, sequence)
   if sequence.nil?
     initial
   else
     car(sequence).send(op, (accumulate(op, initial, cdr(sequence))))
   end
 end
 
 class Integer
   def cons(other=nil)
     [self, other]
   end
 end
 
 accumulate(:+, 0, list(1, 2, 3, 4, 5)) # => 15
 accumulate(:*, 1, list(1, 2, 3, 4, 5)) # => 120
 p accumulate(:cons, nil, list(1, 2, 3, 4, 5)) # => "1 2 3 4 5"
{% endhighlight %}
ここではcons手続きを
 +や*メソッドと同様に扱えるようにするため
Integerクラスのインスタンスメソッドとして定義している

次にenumarate_treeとenumarate_intervalをそれぞれ定義する
{% highlight ruby %}
 def append(list1, list2)
   if list1.nil?
     list2
   else
     cons car(list1), append(cdr(list1), list2)
   end
 end
 
 def enumarate_tree(tree)
   case
   when tree.nil? then nil
   when !pair?(tree) then list tree
   else
     append enumarate_tree(car tree), enumarate_tree(cdr tree)
   end
 end
 
 p enumarate_tree list 1, (list 2, list(3, 4), 5) # => "1 2 3 4 5"
 
 def enumerate_interval(low, high)
   if low > high
     nil
   else
     cons low, enumerate_interval(low+1, high)
   end
 end
 
 p enumerate_interval 2, 7 # => "2 3 4 5 6 7"
{% endhighlight %}

これで標準化部品が揃ったので
これらを使って先のsum_odd_squaresとeven_fibsを書いてみる
{% highlight ruby %}
 def sum_odd_squares(tree)
   accumulate(:+, 0, map(:square, filter(:odd?, enumarate_tree(tree))))
 end
 
 tree = list 1, (list 2, (list 3, 4), 5, (list 6, 7))
 sum_odd_squares tree # => 84
 
 def even_fibs(n)
   accumulate(:cons, nil, filter(:even?, map(:fib, (enumerate_interval(0, n)))))
 end
 
 p even_fibs 20 # => "0 2 8 34 144 610 2584"
{% endhighlight %}

##RubyでArrayオブジェクトを接続インタフェースとした実装
Rubyには上記の各手続きを規定したEnumerableモジュールがあり
リストの実装に適したArrayクラスで利用できるようになっているので
これを継承した例を最後にかいてみる
{% highlight ruby %}
 class List < Array
 end
 
 tree = List[1, 2, 3, 4, 5] # => [1, 2, 3, 4, 5]
 
 tree.map { |e| e * e } # => [1, 4, 9, 16, 25]
 
 tree.select { |e| e.odd? } # => [1, 3, 5]
 
 tree.inject(:+) # => 15
 tree.inject(:*) # => 120
 tree.inject([]) { |arr, e| arr << e } # => [1, 2, 3, 4, 5]
 
 tree = List[1, List[2, List[3, 4], 5, List[6, 7]]] # => [1, [2, [3, 4], 5, [6, 7]]]
 tree.flatten # => [1, 2, 3, 4, 5, 6, 7]
 
 class List
   def sum_odd_squares
     self.flatten.select { |e| e.odd? }.map { |e| e * e  }.inject(:+)
   end
 end
 
 tree.sum_odd_squares # => 84
 
 def even_fibs(n)
   0.upto(n).map { |e| fib(e) }.select { |e| e.even? }.inject([]) { |arr, e| arr << e }
 end
 
 def fib(n)
   case
   when n == 0 then 0
   when n == 1 then 1
   else
     fib(n-1) + fib(n-2)
   end
 end
 
 even_fibs 20 # => [0, 2, 8, 34, 144, 610, 2584]
{% endhighlight %}
Schemeにおける接続インタフェースでは処理の流れは
括弧でカスケードされて右から左へいくのに対し
Rubyのオブジェクトを使った接続インタフェースでは
左から右へ順次流れていくので
より構造の把握がしやすい

{{ '489471163X' | amazon_large_image }}

{{ '489471163X' | amazon_link }}

{{ '489471163X' | amazon_authors }}

{% footnotes %}
   {% fn conventional interface:訳書では公認インタフェースとなっています %}
   {% fn pはdef p(x); x.join(" ").chop endで定義している %}
{% endfootnotes %}
