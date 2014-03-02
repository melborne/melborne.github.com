---
layout: post
title: "「単語が目に飛び込んできてすごい速度で文章を..」ってやつをRubyで..を改良すると..."
description: ""
category: 
tags: 
date: 2014-03-01
published: true
---
{% include JB/setup %}

動体視力が鍛えられるようになります。

    ruby -e 'trap(:INT){print"\e[?25h\e[0;0H";exit(0)};x,y=[`tput lines`,`tput cols`].map{|n|n.to_i/2};print"\e[?25l";ARGF.read.scan(/\w+/).unshift(*%w(3 2 1 0 Go!)).cycle{|w|c=w.size/2;w=w.dup;cw=w[c];w[c]="\e[#{rand 31..37}m#{cw}\e[0m";print"\e[2J\e[#{x+rand(-x/2..x/2)};#{y-c+rand(-y/2..y/2)}H",w;sleep(0.3)}' TEXT

![spritz noshadow](http://gifzo.net/rmey2H2yKF.gif)

Hosted by [Gifzo](http://gifzo.net/ "Gifzo - 宇宙一簡単なスクリーンキャスト共有")

###TEXT

    Ruby is a dynamic, open source programming language with a focus on simplicity and productivity. It has an elegant syntax that is natural to read and easy to write.
    
    Ruby is a language of careful balance. Its creator, Yukihiro “Matz” Matsumoto, blended parts of his favorite languages (Perl, Smalltalk, Eiffel, Ada, and Lisp) to form a new language that balanced functional programming with imperative programming.
    
    He has often said that he is “trying to make Ruby natural, not simple,” in a way that mirrors life.

---

[「単語が目に飛び込んできてすごい速度で文章を..」ってやつをRubyでやると...]({{ BASE_PATH }}/2014/03/01/spritz-with-ruby-oneliner/ "「単語が目に飛び込んできてすごい速度で文章を..」ってやつをRubyでやると...")

 [単語が目に飛び込んできてすごい速度で文章を読めるようになる「Spritz」 - GIGAZINE](http://gigazine.net/news/20140228-spritz/ "単語が目に飛び込んできてすごい速度で文章を読めるようになる「Spritz」 - GIGAZINE")

---

(追記：2014-3-2) 画像を大きいものに差し替えました。

