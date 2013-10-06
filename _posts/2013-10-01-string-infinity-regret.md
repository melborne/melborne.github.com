---
layout: post
title: "RubyのStringにもInfinityを！- 反省回 -"
description: ""
category: 
tags: 
date: 2013-10-01
published: true
---
{% include JB/setup %}

Float::INFINITYのような無限文字列を表現する`String::INFINITY`なるものがほしいとの想いから、前回次のような記事を書いたのです。

> [RubyのStringにもInfinityを！](http://melborne.github.io/2013/09/30/string-infinity-discovered/ "RubyのStringにもInfinityを！")

時を同じくして@ne_sachirou殿も別の解法を用意していました。

> [Range 'a' .. String::INFINITY (Ruby) - c4se記：さっちゃんですよ☆](http://c4se.hatenablog.com/entry/2013/10/01/010305 "Range 'a' .. String::INFINITY (Ruby) - c4se記：さっちゃんですよ☆")

読み比べて頂ければ明白ですが、ここには「**人間の素直さの差**」というものが如実に現れているんですね（力の差は置いておいてね）。

自分の解法は`('b'..'a')`というのはbad value rangeにより`ArgumentError`になるという誤解から出発したのです。それでArgumentErrorを拾うなどという横道に逸れました。ところがこれは`nil`なのです。@ne_sachirou殿の実装の肝は`String::INFINITY=''`なのですが、これはRangeに対する信用に基づくものです。

今日一日反省したいと思います。

反省の一環として、@ne_sachirou殿のコードに少し手を入れさせて頂きましたのでgistしておきます。

{% gist 6772610 %}

Ruby2.0において、`('a'..'zz').size`は`nil`とはビックリです。重量の問題なのでしょうか。

> [instance method Range#size](http://doc.ruby-lang.org/ja/2.0.0/method/Range/i/size.html "instance method Range#size")


ところでこの`#unittest`メソッドは便利ですね。是非使わせてください。


