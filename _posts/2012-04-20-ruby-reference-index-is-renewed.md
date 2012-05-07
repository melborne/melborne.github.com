---
layout: post
title: これからRubyのメソッドを全部覚えようとする人たちへ
tagline: Ruby Reference Indexの紹介
description: ""
category: 
tags: [ruby, manual]
date: 2012-04-20
published: true
---
{% include JB/setup %}

##Ruby技術者認定試験制度
Rubyには[Ruby技術者認定試験制度](http://www.ruby.or.jp/ja/certification/examination/ 'Rubyアソシエーション: Ruby技術者認定試験制度')という認定資格制度があります。この制度では、現在、Rubyのスキルレベルに応じた二種類の資格試験が用意されています。初級者向けのRuby Association Certified Ruby Programmer `Silver`と、中級者向けのRuby Association Certified Ruby Programmer `Gold`です。

![silver gold noshadow]({{ site.url }}/assets/images/silver_gold.jpg)

そしてこの度万全の準備が整い、上級者向けのRuby Association Certified Ruby Programmer `Sapphire`が開始されることになりました。

![sapphire noshadow]({{ site.url }}/assets/images/sapphire.jpg)

Sapphire資格を有することにより、あなたはRubyアソビエーションにより公式に`Rubyist`として認定されることになります。これはプログラマ採用企業に対する大きなアピールポイントになります。なお、本件に関連して本年５月１日以降、`Rubyist`と称して無資格で業としてプログラムを行う行為は、司法による処罰の対象になりますので注意が必要です{% fn_ref 1 %}。

##Sapphire試験の問題レベル
Sapphire試験は難易度がかなり高く、熟練Rubyプログラマでも相当の事前準備が必要になります。認定Rubyistの麻酔運転氏によれば、次のような問題が想定されているそうです。あなたはいくつ答えられますか(Rubyのversionは1.9.3)。

> 1. Arrayクラスのinstance methodの数よりもStringクラスのinstance methodの数のほうが多い。
> 1. sort_byはEnumerableに定義されたメソッドであるが、sort_by!はArrayに定義されたメソッドである。
> 1. 小文字ではじまる組み込みクラスが存在する。
> 1. File::Statクラスの42あるインスタンスメソッドの半数は末尾が?で終わる。
> 1. selectメソッドはArray, Hash, IO, File, Kernel, Enumerable, Structに存在する。
> 1. Symbol#lengthは1.9系で追加されたメソッドである。
> 1. ARGFオブジェクトのクラスはARGF.classである。
> 1. Stringおよびstringというメソッドが存在する。
> 1. tell, store, begin, end, real, imag, end_with?, friday?というメソッドが存在する。
> 1. Process, Process::GID, Process::Sys, Process::UIDはモジュールだが, Process::Statusはクラスである。

合格ボーダーは正答率９割です。これは強敵です(解答は末尾に){% fn_ref 2 %}。

##試験対策
しかし心配する必要はありません。あなたにはリニューアルされた、[Ruby Reference Index(Rbref)](http://rbref.heroku.com/ 'Ruby Reference Index')があります!

![Alt Rbref]({{ site.url }}/assets/images/rbref.png)

##Rbrefの特徴

> 1. Rubyのすべてのメソッドをクラス・モジュール別に一覧表示。
> 1. クラス、モジュール、例外クラス、標準添付ライブラリ、主要トッピックの直リンク、関連サイトの見出し表示。
> 1. 1.8.7, 1.9.2, 1.9.3 の各ヴァージョンに対応。
> 1. 各メソッドはRuby Reference Manual(るりま)の該当解説に直リンク。
> 1. 1.9系で追加されたメソッドを別色表示。
> 1. 各クラスの継承関係・Mix-inモジュールを表示。
> 1. アクティブユーザ`1`でトラフィック問題なし。

##今回の変更点

> 1. るりまのリンク先を[doc.okkez.net](http://doc.okkez.net/)から[doc.ruby-lang.org](http://doc.ruby-lang.org/ja/)に変更。
> 1. version 1.9.3に対応。
> 1. 暑くなるこれからの季節に合わせてアイス系カラーの採用。
> 1. バグ修正。

##リンク切れについて
一部のメソッドでリンク切れが生じています。考えられる原因は次の何れかです。

> 1. そのクラスでMix-inされたモジュールで定義されているメソッド。
> 1. るりまの対応する解説の不存在。
> 1. 単なるプログラムのバグ。

何卒ご理解の程よろしくお願い致します。

[melborne/rbref](https://github.com/melborne/rbref 'melborne/rbref')

{{ 4774150010 | amazon_medium_image }}
{{ 4774150010 | amazon_link }}

{% footnotes %}
   {% fn くれぐれもRubyアソシエーションに問い合わせぬように。%}
   {% fn すべて正解です。%}
{% endfootnotes %}
