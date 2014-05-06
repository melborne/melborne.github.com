---
layout: post
title: "Macのターミナルでマトリックス?"
description: ""
category: 
tags: 
date: 2014-05-07
published: true
---
{% include JB/setup %}

## matrix コマンド

好評（？）につき「[let_it_fall](https://rubygems.org/gems/let_it_fall "let_it_fall")」をアップデートして、Macのターミナルでマトリックスもできるようにしてみました（version 0.1.0~）。まあ、ちょっと出来損ないですけど ;-(

    $ lat_it_fall matrix

![matrix noshadow](http://gifzo.net/YN0nVcXwJJ.gif)
[YN0nVcXwJJ.gif - Gifzo](http://gifzo.net/YN0nVcXwJJ "YN0nVcXwJJ.gif - Gifzo")


`matrix`に任意のコマンドを渡すとその絵でマトリックスします。ものによっては色の指定もできます。

    $ lat_it_fall matrix kanji -c=34

![matrix noshadow](http://gifzo.net/Xb823CepFK.gif)
[Xb823CepFK.gif - Gifzo](http://gifzo.net/Xb823CepFK "Xb823CepFK.gif - Gifzo")


## 絵の切り替え

基本コマンドの方も少し改良しまして、動作中に「`リターンキー`」を押すごとに、落ちる絵を切り替えられるようにしました。

    $ lat_it_fall poo

![poo noshadow](http://gifzo.net/BEgvpqr47nj.gif)
[BEgvpqr47nj.gif - Gifzo](http://gifzo.net/BEgvpqr47nj "BEgvpqr47nj.gif - Gifzo")

現時点でコマンドは60（！）くらいあって、たぶんrubygemsで最多コマンド数を誇るんじゃないでしょうかw

辛いことがあったときに、どうぞ。


> [let_it_fall | RubyGems.org | your community gem host](https://rubygems.org/gems/let_it_fall "let_it_fall | RubyGems.org | your community gem host")
>
> [melborne/let_it_fall](https://github.com/melborne/let_it_fall "melborne/let_it_fall")


---

関連記事：

> [Macのターミナルで〇〇が降る]({{ BASE_PATH }}/2014/05/01/let-it-fall-in-the-mac-terminal/ "Macのターミナルで〇〇が降る")


