---
layout: post
title: RubyでString Searchingを解く-CodeEval
date: 2012-02-03
comments: true
categories:
---

##RubyでString Searchingを解く-CodeEval
正規表現で半ば強引に。

文字列に対する部分文字列の一致を見る。但し部分文字列中の*は0以上の文字にマッチ。
{% gist 1697463 substring.rb %}

##RubyでString Permutationsを解く-CodeEval
Array#permutationを使って。

単語文字の全順列。
{% gist 1697463 str_perm.rb %}


##RubyでPrefix expressionsを解く-CodeEval
ほんとは構文解析して解くことが期待されてるんだろうけど、正規表現で行けたので..

いわゆるポーランド記法の電卓。
{% gist 1697463 prefix.rb %}


##RubyでLongest Common Subsequenceを解く-CodeEval
StringScannerを使って再帰的に。どこかにバグがあるようで50点^ ^;

２つのアルファベット列に共通する最長の並び。並びは連続していなくてもいい。
{% gist 1697463 lcs.rb %}


Hardになって急に難しくなってる..
