---
layout: post
title: RubyでRepeated Substringを解く-CodeEval
date: 2012-02-14
comments: true
categories:
tags: [ruby, codeeval]
---

##RubyでRepeated Substringを解く-CodeEval
(追記：2013-1-16) tyama@cTouch(うつにーと)さんのコメントを受けてコードを修正したところ無事100でパスしました。next if substr.match(/^ +$/)を追加.

バグ入りで80点^ ^;

入出力情報少なすぎてバグ特定できない..まあいっか。str.gsub(substr).to_aという技を閃いた。

文字列中に繰り返し現れる最長の部分文字列。
{% gist 1697463 repeated_substr.rb %}


##RubyでSpiral Printingを解く-CodeEval
もっと賢いやり方があると思う。座標系を回転させるとか。でもまあ一応パスということで..

EnumeratorでSpiralSequenceを作って。

2次元配列の要素をスパイラルな順序で出力。
{% gist 1697463 spiral_printing.rb %}
