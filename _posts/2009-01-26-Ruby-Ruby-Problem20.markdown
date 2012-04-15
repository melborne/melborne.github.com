---
layout: post
title: Rubyで階乗して桁を合計
tagline: Rubyでオイラープロジェクトを解こう！Problem20
date: 2009-01-26
comments: true
categories:
---

##Rubyで階乗して桁を合計 ～Rubyでオイラープロジェクトを解こう！Problem20
[Problem 20 - Project Eulerより](http://projecteuler.net/index.php?section=problems&id=20)
> 
> n! means n × (n - 1)×  ... × 3 × 2 × 1
> Find the sum of the digits in the number 100!
> n!は n × (n - 1)×  ... × 3 × 2 × 1を意味する。
> 100!における桁の合計を求めよ。


Integerクラスのインスタンスメソッドとして
!とsum_digitを定義してみた
{% highlight ruby %}
 class Integer
   def !
     (1..self).inject(:*)
   end
   def sum_digit
     n = self.abs
     sum = 0
     until n <= 0
       a, b = n.divmod(10)
       sum += b
       n = a  
     end
     sum
   end
 end
 100.!.sum_digit # => 6xx
{% endhighlight %}
##Rubyで20世紀の日曜日を求める ～Rubyでオイラープロジェクトを解こう！Problem19
[Problem 19 - Project Eulerより](http://projecteuler.net/index.php?section=problems&id=19)
> 
> You are given the following information, but you may prefer to do some research for yourself.
> 1 Jan 1900 was a Monday.
> Thirty days has September,
> April, June and November.
> All the rest have thirty-one,
> Saving February alone,
> Which has twenty-eight, rain or shine.
> And on leap years, twenty-nine.
> A leap year occurs on any year evenly divisible by 4, but not on a century unless it is divisible by 400.
> How many Sundays fell on the first of the month during the twentieth century (1 Jan 1901 to 31 Dec 2000)?
> 以下の情報が与えられているが、あなたは更なる調査を欲している。
> -1900年1月1日は月曜日である。
> -9月、4月、6月および11月は30日である。
> -2月を別にして残りは31日である。
> -2月は28日で、うるう年には29日である。
> -うるう年は、4で割り切れる年に起こるが、400で割れる年を除くと世紀の年には起こらない。
> 20世紀(1901年1月1日から2000年12月31日まで)における月の初日が日曜日である日はいくつあるか。


方針：
-入力日の曜日を返すwdayメソッドを作る
-sundays_on_first_of_monthメソッドで20世紀のすべての月の初日の曜日を当たる
{% highlight ruby %}
 MONTHS = %w(nil Jan Feb Mar Apr May Jun Jul Aug Sep Oct Nov Dec)
 MONTH_DAYS = (1..12).inject({}) { |h, m| [4,6,9,11].include?(m) ? h[m] = 30 : h[m] = 31; h}
 def wday(day, mon, year)
   days = 0
   mon = month_index(mon)
   (1900..year).each do |y|
     leap_year?(y) ? MONTH_DAYS[2] = 29 : MONTH_DAYS[2] = 28
     if y != year
       (1..12).each { |m| days += MONTH_DAYS[m] }
     else
       (1...mon).each { |m| days += MONTH_DAYS[m] }
       days += day
     end
   end
   days % 7 #return day of week: 0:sun, 1:mon..
 end
 def leap_year?(year)
   if (year%4).zero? && (year%100).nonzero? || (year%400).zero?
     true
   else
     false
   end
 end
 def sundays_on_first_of_month(start_date, end_date)
   st_day, st_mon, st_year = start_date
   end_day, end_mon, end_year = end_date
   st_mon, end_mon = month_index(st_mon), month_index(end_mon)
   count = 0
   (st_year..end_year).each do |y|
     cnt_blk = lambda { |m| count += 1 if wday(1, MONTHS[m], y).zero? } # count Sunday
     if y == st_year and y == end_year
       (st_mon..end_mon).each(&cnt_blk)
     elsif y == st_year
       (st_mon..12).each(&cnt_blk)
     elsif y == end_year
       (1..end_mon).each(&cnt_blk)
     else
       (1..12).each(&cnt_blk)
     end
   end
   count
 end
 def month_index(word) # from month word to month number
   MONTHS.find_index { |m| m =~ /#{word.slice(0..2)}/i }
 end
 wday(1, 'january', 1900) # => 1
 sundays_on_first_of_month([1, 'Jan', 1901],[31, 'Dec', 2000]) # => 1xx
{% endhighlight %}
答えはでたけど
効率悪そうです
