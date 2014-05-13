---
layout: post
title: "縦書きツイートの時代が来たようなので、わたし、RubyでTermtterで「縦つい。」します"
description: ""
category: 
tags: 
date: 2013-03-18
published: true
---
{% include JB/setup %}

少し前に、"ɹəʇʇɪʍʇ"のような反転文字ツイートが粋だと聞いたわたしは、この流行に乗り遅れまいと直ぐに「[flippy](https://rubygems.org/gems/flippy "flippy")」という反転文字を出力するツールをRubyで作りました。そして、愛用の[termtter](https://rubygems.org/gems/termtter "termtter")から時々、"¡ʎqnᴚ ɥʇᴉʍ ɓuᴉʞɔɐH ʎddɐH"などとタイムラインに流して一人悦に入っていたのでした。

> {% hatebu http://melborne.github.com/2013/01/26/make-text-upside-down-with-ruby/ "「twitter→ɹəʇʇɪʍʇのように英数字を180度回転して表示する方法」をRubyでやってみた" %}
> 
> {% hatebu http://melborne.github.com/2013/01/28/make-ruby-script-encript-with-flippy/ "RubyのコードをFlipして暗号化する？" %}

ところが気がつくと反転文字の流行はとうに終わっていて、今度は「縦書きツイート」が流行の兆しを見せているようなのです。

> [一発で縦書きツイートを作成できる「縦つい。」 : ライフハッカー［日本版］](http://www.lifehacker.jp/2013/03/130316tategaki-twitter.html "一発で縦書きツイートを作成できる「縦つい。」 : ライフハッカー［日本版］")

Ruby使いたる者、流行に乗り遅れるわけにはいきませんよね。「縦つい。」が必要なら「縦つい。」するツールをRubyで作ればいいのです。


<br />


そんなわけで...

<br />

flippyに縦書きを実現する`Flippy#vertical`を追加しましたので、お知らせいたします :-)

> [flippy \| RubyGems.org \| your community gem host](https://rubygems.org/gems/flippy "flippy \| RubyGems.org \| your community gem host")
> 
> [melborne/flippy · GitHub](https://github.com/melborne/flippy "melborne/flippy · GitHub")

##Flippyモジュールでの使い方
`gem i flippy`してflippyをrequireすると、StringにFlippyモジュールがincludeされますので、文字列に対して`vertical`メソッドを呼んで下さい。

{% highlight ruby %}
require "flippy"

str = <<EOS
春はあけぼの、
夏は夜。
秋は夕暮れ、
冬はウィンター。
EOS

puts str.vertical
# >> 冬　秋　夏　春　
# >> は　は　は　は　
# >> ウ　夕　夜。あ　
# >> ィ　暮　　　け　
# >> ン　れ、　　ぼ　
# >> タ　　　　　の、
# >> ｜。　　　　　　
{% endhighlight %}

##flippyコマンドでの使い方

flippyコマンドに`-v`（または--vertical）オプションを追加しました。`flippy -v [string]`のように使います。文字列中の全角または半角スペースが改行として解釈されます。

{% highlight bash %}
% flippy -v 春はあけぼの、　夏は夜。　秋は夕暮れ、　冬はウィンター。
冬　秋　夏　春　
は　は　は　は　
ウ　夕　夜。あ　
ィ　暮　　　け　
ン　れ、　　ぼ　
タ　　　　　の、
｜。
{% endhighlight %}

これをお使いのTwitterクライアントにコピペすれば「縦つい。」できます。

##文字列中の"++"の扱い
version 0.1.0で、文字列中の`++`以降の文字列を横書きとする仕様を導入しました。

{% highlight bash %}
% flippy -v "つまづいたって　いいじゃ　ないか　にんげんだ　もの++ みつを #mitsuo"
も　に　な　い　つ
の　ん　い　い　ま
　　げ　か　じ　づ
　　ん　　　ゃ　い
　　だ　　　　　た
　　　　　　　　っ
　　　　　　　　て みつを #mitsuo
{% endhighlight %}

`++`が複数あるときは最後のもの以降が対象になります。すべての++をエスケープしたいときは文末に++を入れて下さい。


なお、flippyの他の使い方については、以下の記事を参考にしてください。

> {% hatebu http://melborne.github.com/2013/01/28/make-ruby-script-encript-with-flippy/ "RubyのコードをFlipして暗号化する？" %}
>
> {% hatebu http://melborne.github.com/2013/02/04/add-kernel-stnd-to-flippy-gem/ "flippy gemにKernel#stndを追加しましたので、お知らせします。" %}
>
> {% hatebu http://melborne.github.com/2013/02/19/flippy-console-now-added/ "flippy consoleで上下反転文字の不思議な感覚を味わってみませんか？" %}

## Flippy#verticalの実装について

基本的に複数行からなる文字列を二次元配列に入れて転置してjoin-reverseして終わりです。RubyにはArray#transposeというステキなメソッドがあるので転置は一発です。

ただ、前処理がちょっと面倒です。１つは向きの変換が必要な文字群の処理で、これはString#trを使って互換文字に置き換えます。

それから句読点の処理です。「縦つい。」では句読点は直前文字の右側に配置されているのでこれに倣いました。つまり各行の右側は空行になっていて句読点がある場合はここに配置されます。<Del>この処理のため、各行を複製し一方を句読点を除いた行、他方を句読点のみの行に置換する処理をしています。ただし行の先頭文字が句読点の場合はこの限りではないので、先頭文字は対象外とします。</Del>（文中の句読点後の空白を除くよう実装を変更しました）

Flippy#verticalの該当コードをここに貼っておきます。<Del>ちなみに今回の実装での個人的Tipsは`Array.new(size,val).tap{ Array#[nth]=val }`です。</Del>（String#fillを使う実装に変更しました。thanks to @no6vさん）

{% gist 5180832 flippy_vertical.rb %}

## Termtter用プラグイン

[termtter](https://rubygems.org/gems/termtter "termtter")をお使いの方は`~/.termtter/plugin`以下に以下のコードを配置すれば`ut`コマンドで使えるようになります。プラグインには縦書き以外の変なツイート用コードが含まれていますので、予めご了承下さい。

{% gist 5180832 ugly_update.rb %}


また、@no6vさん作[earthquake](https://github.com/jugyo/earthquake "jugyo/earthquake · GitHub")用pluginもありますので、eqrthquakeをお使いの方はこちら。

> [vertical.rb](https://gist.github.com/no6v/5187616 "vertical.rb")


<br />

 下　思　で　¬　ど　

 さ　う　の　f　う　

 い　存　縦　l　ぞ　

 ね。分　書　i　み　

 　　楽　き　p　な　

 　　し　を、p　さ　

 　　ん　　　y　ん、

 　　で、　　∟　　　


<br />

---

(追記：2013-03-19) 実装の変更に伴い記述を変更しました。earthquake.gem用pluginについて追記しました。

(追記：2013-03-20) 文字列中の"//"の扱いについて追記しました。
(追記：2013-03-23) Flippy#verticalにおけるデリミタの変更に伴い記述を直しました。

---

<p style='color:red'>=== Ruby関連電子書籍100円で好評発売中！ ===</p>

[M'ELBORNE BOOKS]({{ site.url }}/books/ "M'ELBORNE BOOKS")

<a href="{{ BASE_PATH }}/books/">
  <img src="/assets/images/2012/start_ruby.jpg" alt="start_ruby" style="width:200px" />
</a>
<a href="{{ BASE_PATH }}/books/">
  <img src="/assets/images/2013/02/ruby_object_cover.png" alt="ruby_object" style="width:200px" />
</a>
<a href="{{ BASE_PATH }}/books/">
  <img src="/assets/images/2013/03/ruby_trivia_cover.png" alt="trivia" style="width:200px" />
</a>

