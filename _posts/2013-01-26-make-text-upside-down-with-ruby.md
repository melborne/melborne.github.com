---
layout: post
title: "「twitter→ɹəʇʇɪʍʇのように英数字を180度回転して表示する方法」をRubyでやってみた"
description: ""
category: 
tags: 
date: 2013-01-26
published: true
---
{% include JB/setup %}

(追記：2013-01-28) コードを全面的に書き直しました。

[RubyのコードをFlipして暗号化する？]({{ site.url }}/2013/01/28/make-ruby-script-encript-with-flippy/ 'RubyのコードをFlipして暗号化する？')

---

Twitterでよく見かける上下反転文字はこうやって作るのですね。

> [twitter→ɹəʇʇɪʍʇのように英数字を180度回転して表示する方法｜Colorless Green Ideas](http://id.fnshr.info/2013/01/25/upsidedowntext/ 'twitter→ɹəʇʇɪʍʇのように英数字を180度回転して表示する方法｜Colorless Green Ideas')

こちらのサイトでその対応表を公開してくれています。ありがたい。

こんな面白いもの見せられて、黙っている訳にはいきませんよね...

そんなわけで...

先のサイトから対応表を引いてきて上下反転文字を作るスクリプトをRubyで書きました^ ^;

##使い方

[ここ](https://gist.github.com/4642105)から`scraper.rb`、`textupdown.rb`、`textupdown`を拾ってきて、同じディレクトリでtextupdownコマンドを文字列を伴って実行します。

{% highlight bash %}
% ./textupdown twitter
Ꮧəʇʇɪʍʇ

% ./textupdown The quick brown fox jumps over the lazy dog
бop ʎzɐꞁ əɥʇ ɹəᏙo sdաnſ xoɟ uʍoɹq ʞɔᴉnb əɥ⏊
{% endhighlight %}

コードポイントを得たいときは、`-c`を付けます。
{% highlight bash %}
% ./textupdown -c twitter
U+13D7
U+0259
U+0287
U+0287
U+0131
U+028D
U+0287
{% endhighlight %}


Rubyで使うときはつぎのようにします。
{% highlight ruby %}
require './textupdown'

t = TextUpDown.new
t.text('twitter') # => "Ꮧəʇʇıʍʇ"
t.code('twitter') # => ["U+13D7", "U+0259", "U+0287", "U+0287", "U+0131", "U+028D", "U+0287"]
{% endhighlight %}

TextUpDown#textで反転文字列が、TextUpDown#codeでそのコードポイントが返ります。対応文字が複数ある場合はその中から毎回ランダムで決定します。

最初の実行で先のサイトからデータを引いてきて、`textupdown.yaml`というファイルに保存し、次回以降はそのファイルを参照します。

作りがいい加減です。ブラッシュアップしてくれる人、お願いしますm(__)m

[Termtter](https://rubygems.org/gems/termtter 'termtter \| RubyGems.org \| your community gem host')ユーザ向けpluginも作りました。Termtterで逆さ文字ツイートしましょう！

{% gist 4642105 %}

---

(追記：2013-01-27) コードの変更に伴い内容を追記しました。
(追記：2013-01-27) Termtter pluginを追加しました。

---

{{ 'B007G6MKY0' | amazon_medium_image }}
{{ 'B007G6MKY0' | amazon_link }}

