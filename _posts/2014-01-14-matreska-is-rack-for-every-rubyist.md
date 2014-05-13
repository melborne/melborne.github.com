---
layout: post
title: "Rack以外でRackしたいRubyistのためのMatreska"
description: ""
category:
tags:
date: 2014-01-14
published: true
---
{% include JB/setup %}

１年半くらい前にRackの構造を調べたときに「Rackは棚ではなく、マトリョーシカである」ということを理解しまして、次のような記事を書いたのです。

> [マトリョーシカはRackだけのものじゃない、あなたのRubyにもマトリョーシカを！](http://melborne.github.io/2012/08/10/build-a-matryoshka-with-ruby/ "マトリョーシカはRackだけのものじゃない、あなたのRubyにもマトリョーシカを！")

で、そのときに書いたコードを手直しして「なんでもGem化プロジェクト{% fn_ref 1 %}」に則ってこの度Gem化しましたので、お知らせいたします。まあ、また小石（tiny gem）を一つ増やしただけですが。

> [matreska \| RubyGems.org \| your community gem host](https://rubygems.org/gems/matreska "matreska \| RubyGems.org \| your community gem host")
>
> [melborne/matreska](https://github.com/melborne/matreska "melborne/matreska")

## Matreskaとは

`Matreska`は分かりやすくいえば、「Rackでmiddlewareを連鎖的にcallする仕組みを汎用化したもの」です。つまり「アダプタブルなマルチフィルターのバンドラー（結束具）」ですw。Rackにおけるappに相当するものをMatreskaでは`core`（芯ですね）といい、middlewareに相当するものを`doll`または`figure`といいます。マトリョーシカの正しいスペルは`Matryoshka`ですが、同名のGemが既に存在していたためそのロシア語らしき`matrëška`から命名しました。

![Alt title noshadow]({{ BASE_PATH }}/assets/images/2014/01/matreska2.png)

正直何に使えるのか作った本人もまだ良くわかってませんが、基本的には次の二通りの使い方ができます。

> 1. 一つの入力に対してアダプタブルなフィルタにより多段的な処理を施す。
>
> 2. 通過させる各フィルタにおいて副産物を生成する。

コードは60行ほどなのでここに貼っておきます。

{% gist 8429579 matreska.rb %}

## 使い方のサンプル

### 演算フィルタ

いくつかの例を見てみます。まずはcoreに対しいくつかの演算を施すdollを使った簡単な例を示します。

{% gist 8429579 example1.rb %}

最初に`Matreska.build`でMatreskaインスタンスを生成してcoreをセットします。`core`はRackにおけるappと同じようなcallメソッドに応答するオブジェクトです。ここではcoreは実行時（callの呼び出し）に渡される値をそのまま返すものとして実装しています。

`doll`はRackにおけるmiddlewareと同じようにcoreを引数に取りcallメソッドを持ったクラスです。`Matreska.doll`（または.figure）はこのdollを簡単に生成するためのショートカットツールです。ブロックの第１引数でcoreまたは前段のdollをcallした結果を取ることができます。そして、`Matreska#set`でdollをMatreskaインスタンスにセットし、`Matreska#call`することで、coreに複数のdollフィルタを適用した結果が得られます。

Rackを知っていれば理解は簡単だと思いますが、注意点はdollにおけるcall呼び出しの順序がRackとは逆である点です。Matreskaでは先にセットされたdollのcallが先に呼ばれる仕様になっています。

### 多言語翻訳

次の例は、各翻訳用dollで入力ワードを多言語翻訳する例です。

{% gist 8429579 example2.rb %}

翻訳の結果を各dollにおける副作用として得ています。例ではcallメソッドを持たないArrayをcoreとしていますが、このような場合MatreskaではこのオブジェクトをProcでラップしてcallできるようにします。

### コマ送り画像の生成

もう少しマシな例を。`Gviz`とコラボさせてアニメーションGIFの元画像を作る例を示します。Gvizでは`Gviz#save`でdotファイルを生成できるので、線画を書き足しつつこれを各dollクラスで実行するようにします。

{% gist 8429579 example3.rb %}

生成したdotファイルからpngを生成し、`RMagick`を使ってアニメーションGIFにします。

{% gist 8429579 animetize.rb %}

出力です。

![Alt title noshadow]({{ BASE_PATH }}/assets/images/2014/01/anpan.gif)


ちょっと邪悪な顔つきのア◯パ◯マ◯です:-)

### Rackとして？

MatreskaはRackと同じような基本構造を持っているのでその代わりに使うこともできてしまいます。簡単なサーバーアダプタを書いてやってみます。ThinとWEBRickのハンドラーはRackからそのまま拝借します。

{% gist 8429579 server.rb %}

出力を赤くするmiddlewareをセットしています。

![Alt title noshadow]({{ BASE_PATH }}/assets/images/2014/01/matreska1.png)

何の意味があるかわかりませんが、一応動くということで。

---

そんなわけで、Rackのmiddlewareの仕組みを使って何の役に立つかわからない`Matreska`というGemを書いたので紹介しましたm(__)m


---

<p style='color:red'>=== Ruby関連電子書籍100円〜で好評発売中！ ===</p>

[M'ELBORNE BOOKS]({{ BASE_PATH }}/books/ "M'ELBORNE BOOKS")

<a href="{{ BASE_PATH }}/books/">
  <img src="/assets/images/books/rack_cover.png" alt="rack" style="width:200px" />
</a>
<a href="{{ BASE_PATH }}/books/">
  <img src="/assets/images/books/ruby_pack8.png" alt="pack8" style="width:200px" />
</a>
<a href="{{ BASE_PATH }}/books/">
  <img src="/assets/images/books/ruby_parallel_cover.png" alt="ruby_parallel" style="width:200px" />
</a>


{% footnotes %}
{% fn 書いたコードはできるだけGem化しようという僕個人の今年の行動指針です %}
{% endfootnotes %}
