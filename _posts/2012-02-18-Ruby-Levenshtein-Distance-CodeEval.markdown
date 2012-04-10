---
layout: post
title: RubyでLevenshtein Distanceを解く-CodeEval
date: 2012-02-18
comments: true
categories: [ruby, codeeval]
---


できません..
アルゴリズム的にはできてるんだけど{% fn_ref 1 %}
答えを得るのに1時間とかorz..
5秒で答えなきゃいけないのに
あとグローバル変数を使ってしまった

どうも高速化は苦手です
そこに注力する気がなかなか起きない..

レーベンシュタイン距離が1の語同士をfriendとして
与えられた辞書におけるhelloの語から始まる
friendの輪に含まれるすべての語の数を答える
{% gist 1697463 levenshtein_distance.rb %}

{% footnotes %}
   {% fn 'causes'の解答が一致した %}
{% endfootnotes %}
