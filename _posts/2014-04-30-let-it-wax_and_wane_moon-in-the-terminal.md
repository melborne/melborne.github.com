---
layout: post
title: "Macのターミナルで月が..."
description: ""
category: 
tags: 
date: 2014-04-30
published: true
---
{% include JB/setup %}

満ちる。

    ruby -e 'trap(:INT){print"\e[?25h\e[0;0H";exit(0)};x,y=[`tput lines`,`tput cols`].map{|n|n.to_i/2};print"\e[?25l";(0x1F311..0x1F315).cycle{|w|print"\e[2J\e[#{x};#{y}H",w.chr("utf-8");sleep(0.3)}'

![moon noshadow](http://gifzo.net/daisOE631e.gif)

[daisOE631e.gif - Gifzo](http://gifzo.net/daisOE631e "daisOE631e.gif - Gifzo")

---

参考記事：

> [Macのターミナルで顔が変わると...]({{ BASE_PATH }}/2014/04/29/emoji-with-ruby-oneliner/ "Rubyのワンライナーで顔文字すると...")

> [Macのターミナルで顔が降る](http://melborne.github.io/2014/04/30/let-it-smile-in-the-terminal/ "Macのターミナルで顔が降る")

