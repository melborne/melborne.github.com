---
layout: post
title: RubyでCash Registerを解く-CodeEval
date: 2012-01-27
comments: true
categories:
---

##RubyでCash Registerを解く-CodeEval
ループで繰り返し引いて
丸め誤差の問題でちょっと..
整数化してやったほうがいいの？

お釣りをコインとお札で
{% gist 1662022 cash_register.rb %}


Double Squaresを残してModerate終了
できそうもない..
##RubyでPrime Numbersを解く-CodeEval
Enumeratorをtake_whileして

指定数までの素数列
{% gist 1662022 prime_less.rb %}

##RubyでReverse and Addを解く-CodeEval
回文になるまでループして

数字をひっくり返して足すことを繰り返して
回文になる回数
{% gist 1662022 reverse_add.rb %}

##RubyでJolly Jumpersを解く-CodeEval
Array#each_consを使って

並びの数字の差が3 2 1となってるものを
Jolly Jumperというらしい
{% gist 1662022 jolly_jumpers.rb %}


##RubyでArray Absurdityを解く-CodeEval
余計な条件がよくわからない..

数字列中の重複を見つける
{% gist 1662022 array_absurdity.rb %}


##RubyでEmail Validationを解く-CodeEval
本気じゃないよね？
適当なところで

メールアドレスの正規表現
{% gist 1662022 email_regex.rb %}

##RubyでNumber Pairsを解く-CodeEval
Array#combinationを使って

数字列から合計が指定数になる数字のペアを見つける
{% gist 1662022 number_pairs.rb %}


##RubyでTrailing Stringを解く-CodeEval
ワンライナーで:)

文字列中のサブ文字列を見つける
{% gist 1662022 sameend.rb %}


##RubyでDecimal To Binaryを解く-CodeEval

10進数を2進数に
{% gist 1662022 dec2bin.rb %}


##RubyでSum of integersを解く-CodeEval
ループで全組合せを作ってArray#max

数字の並びにおける連続する数字群の最大値
{% gist 1662022 largest_sum.rb %}


##RubyでNumber of Onesを解く-CodeEval
String#countで

数字の２進表現の1ビットの数
{% gist 1662022 num_of_ones.rb %}

##RubyでEndiannessを解く-CodeEval
Array#packを使って

システムのエンディアン
{% gist 1662022 endian.rb %}


##RubyでRemove Charactersを解く-CodeEval
String#deleteで

文字列から指定文字を除く
{% gist 1662022 remove_chars.rb %}


##RubyでFirst Non-Repeated Characterを解く-CodeEval
Enumerable#detectで

文字列中の繰り返さない最初の文字
{% gist 1662022 nrc.rb %}

##RubyでLowest Common Ancestorを解く-CodeEval
いやいやもっと簡単な方法があるはずだ

バイナリーツリーの共通の親を見つける
{% gist 1662022 lca.rb %}

##RubyでMth to last elementを解く-CodeEval

アルファベットの並びにおける位置
{% gist 1662022 m2last.rb %}


##RubyでStack Implementationを解く-CodeEval
どうすりゃいいのか

スタックを実装する
{% gist 1662022 stack.rb %}

##RubyでPangramsを解く-CodeEval
Array#-を使って

文字列がパングラムか判定する
{% gist 1662022 pangrams.rb %}


##RubyでDetecting Cyclesを解く-CodeEval
ループを使って
綺麗にかけない..

文字の並び中の繰り返しを見つける
{% gist 1662022 cycle_detection.rb %}


##RubyでLongest Linesを解く-CodeEval
ワンライナーで:)

先頭行の数だけ後続行から最長文字列を選ぶ
{% gist 1662022 longestlines.rb %}
