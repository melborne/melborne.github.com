---
layout: post
title: RubyでSelf Describing Numbersを解く -CodeEval
date: 2012-01-25
comments: true
categories:
tags: [ruby, codeeval]
---

##RubyでSelf Describing Numbersを解く -CodeEval
String#countを使って。

各桁の数字がその桁の出現回数を表すとき、自己表現数(self describing number)という。
{% gist 1656338 self_describing_numbers.rb %}

##RubyでHappy Numbersを解く -CodeEval
再帰を使って。

各桁の二乗を足し続けて1になればHappy。
{% gist 1656338 happy_numbers.rb %}


##RubyでRightmost Charを解く -CodeEval
String#rindexで。

文字列中の指定文字の位置(最右)。
{% gist 1656338 rightmost.rb %}


##RubyでSet Intersectionを解く -CodeEval
Array#&で。

左右の数字列の重複。
{% gist 1656338 intersection.rb %}

##RubyでUnique Elementsを解く -CodeEval
Array#uniqで。

重複数字を除去。
{% gist 1656338 dupes.rb %}


##RubyでFile Sizeを解く -CodeEval
File.sizeで。

ファイルサイズ。
{% gist 1656338 filesize.rb %}


##RubyでOdd Numbersを解く -CodeEval
Enumerable#selectで。

1から99の中の奇数。
{% gist 1656338 oddnums.rb %}


##RubyでSum of Integers from Fileを解く -CodeEval
Enumerable#injectを使って。

各行の数字の合計。
{% gist 1656338 sumint.rb %}


##RubyでMultiplication Tablesを解く -CodeEval
printfで揃える。

九九のテーブルを作る。
{% gist 1656338 tables.rb %}


##RubyでFibonacci Seriesを解く -CodeEval
メモ化を使って。

n番目のフィボナッチ数。
{% gist 1656338 fibonacci.rb %}


(追記:2012-2-2)
id:rochefortさんによるメモ化。
{% highlight ruby %}
def fib(n)
  @cache ||= []
  @cache[n] ||= (n<2)? n : fib(n-2) + fib(n-1);
end
{% endhighlight %}
[Fibonacci Series - うんたらかんたら日記](http://d.hatena.ne.jp/rochefort/20120202/p1)
なるほどこちらのほうが見やすいです。

でこれにならって修正版。
{% highlight ruby %}
@mem = { -2 => -1, -1 => 1 }
fib = ->n { @mem[n] ||= fib[n-1] + fib[n-2] }
{% endhighlight %}


##RubyでSum of Digitsを解く -CodeEval
各桁の合計。
{% gist 1656338 sum_digits.rb %}


##RubyでLowercaseを解く -CodeEval
String#downcaseで。

全部小文字化。
{% gist 1656338 lowercase.rb %}


##RubyでBit Positionsを解く -CodeEval
Integer#to_s(2)で。

1つ目の数字のビットにおける2つの位置の一致を見る。
{% gist 1656338 position.rb %}


##RubyでMultiples of a Numberを解く -CodeEval
またまたEnumeratorを使って。

1つ目の数字より大きい2つ目の数字の最小の倍数。
{% gist 1656338 multiples.rb %}

##RubyでReverse wordsを解く -CodeEval
ふつうにArray#reverseを使って。

単語の語順を入れ換える。
{% gist 1656338 reverse_words.rb %}

