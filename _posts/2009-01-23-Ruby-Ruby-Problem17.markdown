---
layout: post
title: Rubyで英数字を作って文字数を数える
tagline: Rubyでオイラープロジェクトを解こう！Problem17
date: 2009-01-23
comments: true
categories:
---


[Problem 17 - Project Eulerより](http://projecteuler.net/index.php?section=problems&id=17)
 
> If the numbers 1 to 5 are written out in words: one, two, three, four, five, then there are 3 + 3 + 5 + 4 + 4 = 19 letters used in total.
>
> If all the numbers from 1 to 1000 (one thousand) inclusive were written out in words, how many letters would be used?
>
> NOTE: Do not count spaces or hyphens. For example, 342 (three hundred and forty-two) contains 23 letters and 115 (one hundred and fifteen) contains 20 letters. The use of "and" when writing out numbers is in compliance with British usage.
>
> 1から5の数は英単語で one, two, three, four, five と書かれるが、これには全部で3 + 3 + 5 + 4 + 4 = 19 の文字が使われている。
>
> 1から1000(one thousand)までの全ての数を英単語で書いた場合、何文字が使われるか。
>
> 注記：スペースとハイフンは数えない。例えば、342 (three hundred and forty-two) は23文字、115 (one hundred and fifteen)は20文字からなる。数字を書くときの"and"の使用は英国式に従う。
>


方針：

1. 1から1000までの数字を英単語に変換するnum_to_wordメソッドを作る
1. 入力範囲の数字の文字数の合計をカウントするcount_lettersメソッドを作る

{% highlight ruby %}
 WORDS = {0 => "", 1 => "one", 2 => "two", 3 => "three", 4 => "four", 5 => "five", 6 => "six", 7 => "seven", 8 => "eight", 9 => "nine", 10 => "ten", 11 => "eleven", 12 => "twelve", 13 => "thirteen", 14 => "fourteen", 15 => "fifteen", 16 => "sixteen", 17 => "seventeen", 18 => "eighteen", 19 => "nineteen", 20 => "twenty", 30 => "thirty", 40 => "forty", 50 => "fifty", 60 => "sixty", 70 => "seventy", 80 => "eighty", 90 => "ninety"}
 def count_letters(range)
   ans = 0
   range.each do |n|
     word = num_to_word(n)
     ans += word.gsub(/[-\s]/, "").length
   end
   ans
 end
 def num_to_word(n)
   word = ""
   hund, ten = n.divmod(100)
  
   case hund
   when 1..9
     if ten.zero?
       word << "#{WORDS[hund]} hundred"
     else
       word << "#{WORDS[hund]} hundred and "
     end
   when 10
     word << "one thousand"
   end
   case ten
   when 10..19
     word << WORDS[ten]
   when 1..9, 20..99
     ten, one = ten.divmod(10)
     if one.zero?
       word << "#{WORDS[ten*10]}"
     elsif ten.zero?
       word << "#{WORDS[one]}"
     else
       word << "#{WORDS[ten*10]}-#{WORDS[one]}"
     end
   end
   word
 end
 count_letters(1..1000) # => 21124
{% endhighlight %}
