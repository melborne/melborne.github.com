---
layout: post
title: "Macのターミナルで顔が降る"
description: ""
category: 
tags: 
date: 2014-04-30
published: true
---
{% include JB/setup %}

辛いことがあったときに、どうぞ。

    ruby -e 'C=`stty size`.scan(/\d+/)[1].to_i;S=[*0x1F600..0x1F640];a={};puts "\033[2J";loop{a[rand(C)]=0;a.each{|x,o|;a[x]+=1;print "\033[#{o};#{x}H \033[#{a[x]};#{x}H#{S.sample.chr("utf-8")} \033[0;0H"};$stdout.flush;sleep 0.2}'

![smiley rain noshadow](http://gifzo.net/1KtIS9iinH.gif)

> [1KtIS9iinH.gif - Gifzo](http://gifzo.net/1KtIS9iinH "1KtIS9iinH.gif - Gifzo")

---

参考記事：

> [Let it Snow in the Terminal of Mac OS X with This Command](http://osxdaily.com/2013/12/06/snow-terminal-mac-os-x-command/ "Let it Snow in the Terminal of Mac OS X with This Command")

> [「Macのターミナルで雪が降る」をカラー化した。翻訳した。]({{ BASE_PATH }}/2013/12/13/translate-let-it-snow-in-the-terminal/ "「Macのターミナルで雪が降る」をカラー化した。翻訳した。")

> [Macのターミナルで顔が変わると...]({{ BASE_PATH }}/2014/04/29/emoji-with-ruby-oneliner/ "Rubyのワンライナーで顔文字すると...")

---

(追記：2014-4-30) スクリプトの間違いを修正しました。

