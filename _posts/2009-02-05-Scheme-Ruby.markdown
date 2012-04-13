---
layout: post
title: SchemeとRubyでリストの操作を学ぼう
date: 2009-02-05
comments: true
categories:
---


引き続き「{{ '489471163X' | amazon_link }}」を使って
今度はSchemeとRubyでのリストの操作を見ていこうと思います
なおSchemeのコードは本書からの抜粋で
説明は自分の要約です

##リスト要素の参照
Schemeにはデータオブジェクトの並びを表現する
リストというデータ構造がある
リストはlist手続きで作ることができるが
これはconsを入れ子にしたものと等価である
{% highlight scheme %}
 list 1 2 3 4
 (1 2 3 4)
 
 (cons 1 (cons 2 (cons 3 (cons 4 nil))))
 (1 2 3 4)
{% endhighlight %}
だからconsを順にcdrダウンしていけば
リストの各要素にアクセスできる
これを使って
リストのn番目の要素を返す手続きlist_refを定義する
リストは0番から始まる
{% highlight scheme %}
 (define (list_ref items n)
 	(if (= n 0)
 		(car items)
 		(list_ref (cdr items) (- n 1))))
 
 (define squares (list 1 4 9 16 25))
 
 (list_ref squares 3)
 16
{% endhighlight %}
再帰を使ってリストをcdrダウンしていき
nが0になったところでその第一要素をcarで返す

Rubyでも同様のことをやってみる
まずconsを定義しこれを使ってリストを定義する
consの定義にはRubyのArrayクラスを使うのがよさそうだ
{% highlight ruby %}
 def cons(a, b=nil)
   [a, b]
 end
 
 def car(items)
   case items
   when Array
     items[0]
   else
     raise "bad argument type"
   end
 end
 
 def cdr(items)
   case items
   when Array
     items[1]
   else
     raise "bad argument type"
   end
 end
 
 def list(*i)
   if i.empty?
     nil
   else
     cons i.shift, list(*i)
   end
 end
 
 odds = list 1, 3, 5, 7 # => [1, [3, [5, [7, nil]]]]
{% endhighlight %}

consに基づいてリストが定義できれば
schemeと同じアルゴリズムで
list_refが定義できるはずだ
{% highlight ruby %}
 def list_ref(items, n)
   if n == 0
     car items
   else
     list_ref(cdr(items), n-1)
   end
 end
 
 list_ref(odds, 3) # => 7
{% endhighlight %}

##リストの長さ
schemeに戻って
リストの長さ(要素数)を返す手続きlengthを定義する
{% highlight scheme %}
 (define (length items)
 	(if (null? items)
 		0
 		(+ 1 (length (cdr items)))))
 		
 (define odds (list 1 3 5 7 9))		
 (length odds)
 5
{% endhighlight %}
cdrダウンするたびに1カウントして
第二要素がnilになったところで終了する

Rubyでもlengthを定義しよう
{% highlight ruby %}
 def length(items)
   if items.nil?
     0
   else
     1 + length(cdr items)
   end
 end
 
 length(odds) # => 4
{% endhighlight %}

##リストの結合
次に2つのリストを結合する手続きappendを定義する
{% highlight scheme %}
 (define (append list1 list2)
 	(if (null? list1)
 		list2
 		(cons (car list1) (append (cdr list1) list2))))
 
 (append squares odds)
 (1 4 9 16 25 1 3 5 7 9)
{% endhighlight %}
list1をcdrダウンしていくたびに
list1をcarして新たなpairをconsする
list1が空に達したらlist2を繋ぐ

Rubyでもappendを定義しよう
{% highlight ruby %}
 def append(list1, list2)
   if list1.nil?
     list2
   else
     cons car(list1), append(cdr(list1), list2)
   end
 end
 
 squares = list 1, 4, 9, 16, 25
 append(odds, squares) # => [1, [3, [5, [7, [1, [4, [9, [16, [25, nil]]]]]]]]]
{% endhighlight %}

##リスト要素に手続きを作用させる
今度はリストの各要素に
任意の手続きを作用させたリストを返す手続きmapを定義する
{% highlight scheme %}
 (define (map proc items)
 	(if (null? items)
 		`()
 		(cons (proc (car items))
 			(map proc (cdr items)))))
{% endhighlight %}
map手続きにはリストと共に手続きprocを渡し
リストをcdrダウンしていくたびに
リストの第一要素にprocを作用させた結果を
consして新たな要素を作る

mapに渡す演算を変えることによって
多様な結果が得られる
{% highlight scheme %}
 (map abs (list -10 2.5 -11.6 17))
 (10 2.5 11.6 17)
 
 (map (lambda (x) (* x x))
 		(list 1 2 3 4))
 (1 4 9 16)
{% endhighlight %}
これを使って新たな演算を定義してもいい
{% highlight scheme %}
 (define (scale_list items)
 	(map (lambda (x) (* x x))
 		 items))
 (square_list (list 1 2 3 4))
 (1 4 9 16)
{% endhighlight %}

次にRubyでもmapを定義しよう
{% highlight ruby %}
 def map(proc, items)
   if items.nil?
     nil
   else
     cons proc.call(car items), map(proc, cdr(items))
   end
 end
 
 map(lambda { |x| x.abs }, list(-10, 2.5, -11.6, 17)) # => [10, [2.5, [11.6, [17, nil]]]]
 
 def scale_list(items)
   map(lambda { |x| x**2 }, items)
 end
 
 scale_list odds # => [1, [9, [25, [49, nil]]]]
{% endhighlight %}

##treeに対する演算
並びはその要素自身が並びである階層構造を許す
{% highlight scheme %}
 (cons (list 1 2) (list 3 4))
 ((1 2) 3 4)
{% endhighlight %}
これは再帰的に枝分かれしていくtreeの構造を表現する
ここで先のlength手続きを適用した場合
先端の葉の部分までは数え上げてくれない
{% highlight scheme %}
 (define tree (cons (list 1 2) (list 3 4)))
 
 (length tree)
 3
{% endhighlight %}

葉を数える手続きcount_leavesを定義しよう
{% highlight scheme %}
 (define (count_leaves tree)
 	(cond ((null? tree) 0)
 		  {% fn_ref 1 %} 1)
 		  (else (+ (count_leaves (car tree))
 				   (count_leaves (cdr tree))))))
 
 (count_leaves tree)
 4
 
 ;length手続き
 (define (length items)
 	(if (null? items)
 		0
 		(+ 1 (length (cdr items)))))
{% endhighlight %}
length手続きと比べると分かるが
treeをcdrダウンするときに
1を足す代わりにtreeをcarダウンして
葉に至ったら1を足すようにする
これは要素がpairでないことで判定できる

Rubyでもcount_leavesを定義しよう
その前にpair?メソッドを定義する
{% highlight ruby %}
 def pair?(items)
   case items
   when Array
     true
   else
     false
   end
 end
 
 def count_leaves(x)
   case 
   when x.nil? then 0
   when !pair?(x) then 1
   else
     count_leaves(car x) + count_leaves(cdr x)
   end
 end
 
 count_leaves(x) # => 7
{% endhighlight %}
うまくいった

schemeに戻ってcount_leaves同様に
先のscale_listもtreeに対応させよう
{% highlight scheme %}
 (define (scale_tree tree factor)
 	(cond {% fn_ref 2 %}
 		  {% fn_ref 3 %} (* tree factor))
 		  (else (cons (scale_tree (car tree) factor)
 					  (scale_tree (cdr tree) factor)))))
 					
 (scale_tree (list 1 (list 2 (list 3 4) 5) (list 6 7))
 			   10)
 (10 (20 (30 40) 50) (60 70))
 
 ;scale_list手続き
 (define (scale_list items factor)
 	(if (null? items)
 		`()
 		(cons (* (car items) factor)
 			  (scale_list (cdr items) factor))))
{% endhighlight %}
scale_listとの違いはcdrダウンするときに
listの第一要素とfactorを直ぐに掛けず
carダウンして葉に至ったところでfactorを作用させる点である

Rubyでも同じようにやってみよう
{% highlight ruby %}
 def scale_tree(tree, factor)
   case 
   when tree.nil? then nil
   when !pair?(tree) then tree * factor
   else
     cons scale_tree(car(tree), factor), scale_tree(cdr(tree), factor)
   end
 end
 l = list(1, (list 2, (list 3, 4), 5), (list 6, 7)) # => [1, [[2, [[3, [4, nil]], [5, nil]]], [[6, [7, nil]], nil]]]
 scale_tree l, 10 # => [10, [[20, [[30, [40, nil]], [50, nil]]], [[60, [70, nil]], nil]]]
{% endhighlight %}

##Listクラスを定義する
Rubyではリストをオブジェクトしたバージョンも書いてみる
Arrayクラスを継承してListクラスを定義する
{% highlight ruby %}
 class List < Array
   def list_ref(n)
     self[n]
   end
   
   def append(list)
     self + list
   end
   
   def last_pair
     self[-1]
   end
   
   def scale_list(n)
     self.inject([]) { |arr, e| arr << e * n  }
   end
   
   def map
     self.inject([]) { |arr, e| arr << yield(e) }
   end
   
   def count_leaves
     self.inject(0) do |len, e|
       case e
       when List
         len + e.count_leaves
       else
         len + 1
       end
     end
   end
   
   def map_tree
     self.inject([]) do |arr, e|
       case e
       when List
         arr << e.map_tree{ |x| yield(x) }
       else
         arr << yield(e)
       end
     end
   end
 end
 
 odds = List[1, 3, 5, 7] # => [1, 3, 5, 7]
 
 odds.list_ref(2) # => 5
 
 odds.length # => 4
 
 squares = List[1, 4, 9, 16, 25]
 
 odds + squares # => [1, 3, 5, 7, 1, 4, 9, 16, 25]
 odds.append(squares) # => [1, 3, 5, 7, 1, 4, 9, 16, 25]
 
 odds.last_pair # => 7
 odds.scale_list(5) # => [5, 15, 25, 35]
 
 odds.map { |e| e**2 } # => [1, 9, 25, 49]
 
 tree = List[1, List[2, List[3, 4], 5], List[6, 7]] # => [1, [2, [3, 4], 5], [6, 7]]
 
 tree.count_leaves # => 7
 tree.map_tree { |x| x**2 } # => [1, [4, [9, 16], 25], [36, 49]]
{% endhighlight %}
injectを使うのはちょっとずるっぽいけど
まあいいか

{{ '489471163X' | amazon_large_image }}

{{ '489471163X' | amazon_link }}

{{ '489471163X' | amazon_authors }}
{% footnotes %}
   {% fn not (pair? tree %}
   {% fn null? tree) `( %}
   {% fn not (pair? tree %}
{% endfootnotes %}
