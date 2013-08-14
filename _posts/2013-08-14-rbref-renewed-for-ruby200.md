---
layout: post
title: "更にもう一つの「るりま」の入り口 ─ Rbref"
tagline: "Yet Another 'Rurima' Interface"
description: ""
category: 
tags: 
date: 2013-08-14
published: true
---
{% include JB/setup %}

###- Q1 -

> Rubyのメソッド調べるのにいつも「[るりま](http://doc.ruby-lang.org/ja/2.0.0/doc/index.html "オブジェクト指向スクリプト言語 Ruby リファレンスマニュアル")」開くんだけど、なんかいつもどこから辿って行ったらいいか迷うんだよね、オレ。階層が深いってか、全体構造が見えないってか。なんかこうもっとサクッと目的のメソッドに到達したいんだよ。

###- A1 -

> コマンドラインツールなら標準添付の「ri」とか、日本語対応の「[ReFe](http://doc.ruby-lang.org/ja/2.0.0/doc/ReFe.html "ReFe")」とかを使って下さい。Webツールなら「[るりまサーチ](http://doc.ruby-lang.org/ja/search/ "最速Rubyリファレンスマニュアル検索！ | るりまサーチ")」があります。

###- Q2 -

> いやいや。あんたらみたいにメソッド名がちゃんと頭に入ってんなら苦労しないっすよ。どっちかっていうと、「文字列の前に文字列追加するやつなかったけ？」とか「２つの配列をインデックスの組の配列に組み替えるやつ、何て言ったっけ？」みたいな。こないだなんか、エラーの「rise」に結局たどり着けずじまい。オレが求めてるのはもっとオレ向け、要は素人向けのやつってことですよ。

###- A2 -

> 「[Ruby Reference Index](http://rbref.heroku.com/ "Ruby Reference Index")」を使って下さい。Rubyの組み込みクラスの全メソッドが一覧できます。

![Alt title]({{ site.url }}/assets/images/2013/08/rbref.png)

###- Q3 -

> あ、これっいいね。上にクラスやモジュールや標準ライブラリの一覧があって。クラス名クリックすると、ページが下がってその対応全メソッドがダーッと見れると。んーいいよ、このローテク感がオレ向きだな。で、解説読みたきゃメソッド名クリックすれば、るりまに飛ぶと。これならメソッド名が曖昧でも使えるかもな。
>
>
> ところで、クラス名やメソッド名のリンクの一部が緑色なんだけど。

###- A3 -

> Ruby2.0.0のページでは1.9.3から追加されたクラスやメソッドを、1.9.3のページでは1.8.6から追加されたそれらを表わしています。

###- Q4 -

> へぇ〜。オレ的には「lazy」とか「used」ってのが気になるねー。そういえば、一部リンク切れてんだけど。「Module#prepend」とか。

###- A4 -

> 次の３つの可能性があります。
>
> （１）そのクラスでMix-inされたモジュールで定義されているメソッド
>
> （２）るりまの対応する解説の不存在
>
> （３）単なるプログラムのバグ

###- Q5 -

> ところで、なんでサイトはRubyのレッド系じゃないの？ブルーってRubyっぽくないんだけど。

###- A5 -

> 暑いからです。

<br />
<br />

RbrefをRuby2.0.0にやっと対応しましたm(__)m

> [Ruby Reference Index](http://rbref.heroku.com/ "Ruby Reference Index")
> 
> [melborne/rbref](https://github.com/melborne/rbref 'melborne/rbref')

<br />

---

{{ 4774158798 | amazon_medium_image }}
{{ 4774158798 | amazon_link }} by {{ 4774158798 | amazon_authors }}

