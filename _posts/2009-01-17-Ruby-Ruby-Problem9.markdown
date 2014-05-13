---
layout: post
title: Rubyでピタゴラスを求める
tagline: Rubyでオイラープロジェクトを解こう！Problem9
date: 2009-01-17
comments: true
categories:
---


<script type="text/javascript" src="http://cdn.mathjax.org/mathjax/latest/MathJax.js?config=TeX-AMS-MML_HTMLorMML"></script>

##Rubyでピタゴラスを求める ～Rubyでオイラープロジェクトを解こう！Problem9
[Problem 9 - Project Eulerより](http://projecteuler.net/index.php?section=problems&id=9)
 
____
A Pythagorean triplet is a set of three natural numbers, \\(a < b < c\\), for which,
{% math %}
a^2 + b^2 = c^2
{% endmath %}
For example, 
{% math %}
3^2 + 4^2 = 9 + 16 = 25 = 5^2
{% endmath %}
There exists exactly one Pythagorean triplet for which \\(a + b + c = 1000\\).
Find the product abc.
____
ピタゴラス数とは、次の関係にある3つの自然数の組\\(a < b < c\\)をいう。
{% math %}
a^2 + b^2 = c^2
{% endmath %}
例：
{% math %}
3^2 + 4^2 = 9 + 16 = 25 = 5^2
{% endmath %}
\\(a + b + c = 1000\\) となるピタゴラス数がただ一つある。abcの積を求めよ。
 ____

a < b < c の条件を維持しながら
 a + b + c = 1000 なるピタゴラス数を
順番に探していく
{% highlight ruby %}
def sum_of_pythagoras(sum)
  a = 1; b, c = a+1, a+2
  limit = sum
  loop do
    if pythagoras?(a, b, c) and (a + b + c) == sum
      return a, b, c
    end
    c += 1
    if c > limit
      b += 1; c = b + 1
    end
    if b > limit/2
      a += 1; b = a + 1; c = b + 1
    end
    return nil if a > limit/3
  end
end
def pythagoras?(a, b, c)
  return true if (a ** 2 + b ** 2) == c ** 2
  false
end
t =  Time.now
a, b, c = sum_of_pythagoras(1000)
"#{a} * #{b} * #{c} = #{a*b*c}" # => "200 * 375 * 425 = 31875000"
Time.now - t # => 70.728619
{% endhighlight %}
ちょっと時間が掛かる
(a + b + c) == sum を先に評価するようにしたら…
{% highlight ruby %}
def sum_of_pythagoras(sum)
  a = 1; b, c = a+1, a+2
  limit = sum
  loop do
    if (a + b + c) == sum and pythagoras?(a, b, c)
      return a, b, c
    end
    c += 1
    if c > limit
      b += 1; c = b + 1
    end
    if b > limit/2
      a += 1; b = a + 1; c = b + 1
    end
    return nil if a > limit/3
  end
end
def pythagoras?(a, b, c)
  return true if (a ** 2 + b ** 2) == c ** 2
  false
end
t =  Time.now
a, b, c = sum_of_pythagoras(1000)
"#{a} * #{b} * #{c} = #{a*b*c}" # => "200 * 375 * 425 = 31875000"
Time.now - t # => 34.074137
{% endhighlight %}
時間が半分になった

##Rubyで数字をスライスする ～Rubyでオイラープロジェクトを解こう！Problem8
[Problem 8 - Project Eulerより](http://projecteuler.net/index.php?section=problems&id=8)
 
> Find the greatest product of five consecutive digits in the 1000-digit number.
>
> 以下の1000桁の数字における連続した5つの数の積の最大値を求めよ。
>
> 7316717653133062491922511967442657474235534919493496983520312774506326239578318016984801869478851843858615607891129494954595017379583319528532088055111254069874715852386305071569329096329522744304355766896648950445244523161731856403098711121722383113622298934233803081353362766142828064444866452387493035890729629049156044077239071381051585930796086670172427121883998797908792274921901699720888093776657273330010533678812202354218097512545405947522435258490771167055601360483958644670632441572215539753697817977846174064955149290862569321978468622482839722413756570560574902614079729686524145351004748216637048440319989000889524345065854122758866688116427171479924442928230863465674813919123162824586178664583591245665294765456828489128831426076900422421902267105562632111110937054421750694165896040807198403850962455444362981230987879927244284909188845801561660979191338754992005240636899125607176060588611646710940507754100225698315520005593572972571636269561882670428252483600823257530420752963450


数字の各桁を配列の要素として取り込み
そこから順に5桁を切り出してその積を求めます
{% highlight ruby %}
number = <<DATA
 7316717653133062491922511967442657474235534919493496983520312774506326239578318016984801869478851843858615607891129494954595017379583319528532088055111254069874715852386305071569329096329522744304355766896648950445244523161731856403098711121722383113622298934233803081353362766142828064444866452387493035890729629049156044077239071381051585930796086670172427121883998797908792274921901699720888093776657273330010533678812202354218097512545405947522435258490771167055601360483958644670632441572215539753697817977846174064955149290862569321978468622482839722413756570560574902614079729686524145351004748216637048440319989000889524345065854122758866688116427171479924442928230863465674813919123162824586178664583591245665294765456828489128831426076900422421902267105562632111110937054421750694165896040807198403850962455444362981230987879927244284909188845801561660979191338754992005240636899125607176060588611646710940507754100225698315520005593572972571636269561882670428252483600823257530420752963450
DATA
 def greatest_five(number)
   seq = number.split("").map { |s| s.to_i  }
   candidate = 0
  (seq.length-4).times do |n|
     multi = seq.slice(n, 5).inject(:*)
     candidate = multi if multi > candidate
   end
   candidate
 end
 greatest_five(number) # => 40824
{% endhighlight %}

(comment)
>a + b + c = n<br>を<br>c = n - (a + b)<br>と変形して、<br>a² + b² = c² <br>に代入して、さらに変形すると<br>b = (2 * a * n - n²) / (2 * a - 2 *n)<br>  = n - n² / (2 * (n - a))<br>となります。<br>この式の a に 1 から順に整数を代入していって、b が整数になる場合を求め<br>ると、かなり速く答えが出せます。<br><br><br>def pythagorean_triples (n)<br>  return([]) if n.odd?<br><br>  ans = Array.new<br>  1.step(n) do |a|<br>    b = n - 0.5 * (n ** 2) / (n - a.to_f)<br>    case<br>    when (a > b)<br>      return(ans)<br>    when (b.to_i == b)<br>      ans.push([a, b.to_i, Math.sqrt(a ** 2 + b ** 2).to_i])<br>    end<br>  end<br>end<br><br>p pythagorean_triples(1000)
>>通りすがりさん<br>圧倒的に速いですね。なるほど。
