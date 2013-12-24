---
layout: post
title: "「Macのターミナルで雪が降る」をカラー化した。翻訳した。"
description: ""
category: 
tags: 
date: 2013-12-13
published: true
---
{% include JB/setup %}

[こちらの記事](http://d.hatena.ne.jp/RyoAnna/20131211/1386769871 "Macのターミナルで雪が降る ～ 最後のホワイトクリスマス - #RyoAnnaBlog")でターミナルで雪を降らせるRubyスクリプトを知る。

> [Let it Snow in the Terminal of Mac OS X with This Command](http://osxdaily.com/2013/12/06/snow-terminal-mac-os-x-command/ "Let it Snow in the Terminal of Mac OS X with This Command")

そのスクリプト。

    ruby -e 'C=`stty size`.scan(/\d+/)[1].to_i;S=["2743".to_i(16)].pack("U*");a={};puts "\033[2J";loop{a[rand(C)]=0;a.each{|x,o|;a[x]+=1;print "\033[#{o};#{x}H \033[#{a[x]};#{x}H#{S} \033[0;0H"};$stdout.flush;sleep 0.1}'


感動した。

カラー化した。

    ruby -e 'C=`stty size`.scan(/\d+/)[1].to_i;S=["2743".to_i(16)].pack("U*");a={};puts "\033[2J";loop{a[rand(C)]=0;a.each{|x,o|;a[x]+=1;print "\033[#{o};#{x}H \033[#{[*31..37].sample}m \033[#{a[x]};#{x}H#{S} \033[0;0H \033[0m"};$stdout.flush;sleep 0.1}'


![snow noshadow](http://gifzo.net/7WE3pRFQzH.gif)
Hosted by [Gifzo](http://gifzo.net/ "Gifzo - 宇宙一簡単なスクリーンキャスト共有")

雪じゃない。

翻訳もした。

{% gist 7928434 %}


