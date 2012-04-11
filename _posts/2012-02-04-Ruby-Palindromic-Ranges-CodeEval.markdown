---
layout: post
title: RubyでPalindromic Rangesを解く-CodeEval
date: 2012-02-04
comments: true
categories:
---

##RubyでPalindromic Rangesを解く-CodeEval
またまたArray#permutationのお世話に..

与えられた2数を最小値と最大値とする数字の並びにおける並びの組を考える。回文数が偶数個の組の数を答える。
{% gist 1697463 int_palindrome.rb %}


##RubyでFollowing Integerを解く-CodeEval
Array#permutationを使って力技!

与えられた数の各桁の並び替えの組合せを、昇順に並べたとき与えられた数の次ぎに来る数を答える。但し各数には任意個数の0を挟める。
{% gist 1697463 next_number.rb %}


##RubyでUgly Numbersを解く-CodeEval
って、まだ解けてません\^\^;

下のコードだと一応解答は得られるんだけど5秒以上掛かるってことで0点です..

気にせず先に..

一桁の素数(2,3,5,7)で割れる数をUgly Numberという。D桁の数字の桁の間に+か-を挟むと3^D-1個の数字ができる。Ugly Numberの個数を求める。
{% gist 1697463 ugly_numbers.rb %}


##RubyでString Listを解く-CodeEval
Array#repeated_permutationで^　^;

文字列中の文字の全順列。
{% gist 1697463 string_list.rb %}

##RubyでMessage Decodingを解く-CodeEval
まず問題を解読するのが大変orz..

どう見てもエレガントな解法じゃない..

特にheaderのsequenceを作る方法がヒドイ。どなたかスマートな解法を教えて下さい。

文字列からなるheaderを使って01からなるmessageを解読する。headerの各文字はその位置にマッピングされた01からなるkeyに対応付けられている。messageは複数のkeyを含む複数のsegmentからできていて、各segmentの最初の3桁がそのsegment内のkeyの長さを表す。
{% gist 1697463 message_decoding.rb %}

