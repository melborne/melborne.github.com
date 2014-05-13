---
layout: post
title: Rubyでアルファベット値を数える
tagline: Rubyでオイラープロジェクトを解こう！Problem22
date: 2009-01-28
comments: true
categories:
---


[Problem 22 - Project Eulerより](http://projecteuler.net/index.php?section=problems&id=22)
 
> Using names.txt (right click and 'Save Link/Target As...'), a 46K text file containing over five-thousand first names, begin by sorting it into alphabetical order. Then working out the alphabetical value for each name, multiply this value by its alphabetical position in the list to obtain a name score.
>
> For example, when the list is sorted into alphabetical order, COLIN, which is worth 3 + 15 + 12 + 9 + 14 = 53, is the 938th name in the list. So, COLIN would obtain a score of 938  53 = 49714.
>
> What is the total of all the name scores in the file?
>
> 5000以上の名前が入った46kのテキストファイルnames.txtをアルファベット順に並び替え、各名前のアルファベット値を求め、これをリストにおける位置で掛けて、名前のスコアを得よ。
>
> 例えば、リストをアルファベット順に並び替えたとき、COLINは値が3 + 15 + 12 + 9 + 14 = 53になり、リストにおける938番目である。よってCOLINは938×53=49714を得る。
>
> このファイルの全ての名前のスコアの合計はいくらか。


文字コードを使ってアルファベットの値を求める
{% highlight ruby %}
 sum = 0
 File.read('names.txt').gsub("\"","").split(",").sort.each_with_index do |name, i|
   sum += name.each_byte.inject(0) { |sum, byte| sum + (byte - 64) } * (i + 1)
 end
 sum # => 8xxxxxxxx
{% endhighlight %}
