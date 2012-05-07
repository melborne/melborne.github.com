---
layout: post
title: "一生涯はてな記法しますか？それともMarkdownしますか？"
description: ""
category: 
tags: [ruby, gem, blog] 
date: 2012-05-05
published: true
---
{% include JB/setup %}

## はてなダイアリー
はてなダイアリーでは`はてな記法`という、HTMLの簡略記法が使えます。この記法を利用することで簡単に整形された日記を書くことができます。私も６年間はてなダイアリーと、はてな記法のお世話になりました。

しかしはてな記法は、はてな独自の簡略記法なので他では使えません。従って一つの不安がよぎります。

    この先もし10年、20年とブログを書き続けるとしたら、それははてな記法でいいのかと。

はてなダイアリーには別の不満もあります。次のようなものです。

> 1. HTML整形後の文章をローカル環境で確認できない。
> 1. 記事に変更が生じてWeb上で直接編集した場合に、ローカルデータと内容が不一致となり、その管理が煩雑となる{% fn_ref 1 %}。
> 1. あんなにサンプルがあるのに、イケてるデザインが見当たらない{% fn_ref 2 %}。
> 1. 基本的にサイトが重い。

## Github Pages + Jekyll
そんな理由から私は[GitHub Pages](http://pages.github.com/ 'GitHub Pages')と[Jekyll](https://github.com/mojombo/jekyll 'mojombo/jekyll')を利用して、自分でブログを構築することにしたのです。この利点は次のようなものです。

> 1. HTML簡略記法のDe-Facto Standardとなっている[Markdown記法](http://blog.2310.net/archives/6 'Markdown文法の全訳')が使える。
> 1. テンプレート言語[Liquid](https://github.com/shopify/liquid/wiki/liquid-for-designers 'Liquid for Designers · Shopify/liquid Wiki')を使って、syntax highlight, amazonその他のタグの埋め込みができる。
> 1. HTML整形後の文章をローカル環境で確認できる。
> 1. githubにおいてgitによるsourceおよびblog dataの一元管理ができる。
> 1. [Jekyll-Bootstrap](http://jekyllbootstrap.com/ 'Jekyll-Bootstrap')などをベースに、自由なデザインでサイトを構築できる。
> 1. Jekyllは静的サイトを構築するためサイトが軽い。

## 過去データの変換
しかしここで一つの問題が浮上します。それは過去にはてなで投稿した記事の取り扱いです。記事は自分の資産です。できれば同時に移管したい。自分がその一番の読者ですし。しかしそれらは当然に、はてな記法で書かれていてMarkdownへの変換が必要です。記事の数は300を超えるので手作業は現実的ではありません。

そこでRubyで適当なscriptを書いてみました。完全とは言いがたいですが、自分の記事に関してはエラーなくmarkdownへ変換できました。こうして無事、はてなにおけるすべての記事をここGithub Pagesに移管することができたのです。

現状Jekyllでは、一つの記事更新のためにすべてのファイルを変換しなければならないなどの問題もありますが、その使い勝手にはかなり満足しています。アフィリエイトもできますしね : )


## hateda2mdの紹介
で、このscriptをもう少しまともな形に作りなおして`hateda2md`としてgem化しました。良かったら試してみてください。果たしてこんな所に需要があるかは分かりませんけど。

[hateda2md | RubyGems.org](https://rubygems.org/gems/hateda2md 'hateda2md | RubyGems.org | your community gem host')

[melborne/hateda2md](https://github.com/melborne/hateda2md 'melborne/hateda2md')

###Hateda2mdとは

`Hateda2md`は、はてな記法で書かれたXMLファイルから、Jekyll用のMarkdownファイルを生成するコンバータです。定義済みフィルタを使って、または自身でフィルタを定義して変換を行うことができます。

###インストール

    $ gem install hateda2md

###使い方

はてなダイアリーのブログエクスポート機能を使って、`はてなの日記データ形式`でdownloadをおこない、username.xmlファイルを取得します。そしてこのファイルを次のようにしてhateda2mdで処理します。

{% highlight ruby %}
require "Hateda2md"

mdb = HateDa::MdBuilder.new('hatena-diary.xml')

# 定義済みフィルタをセットする
mdb.set :title
mdb.set :subtitle
mdb.set :link
mdb.set :amazon

# 変換を実行する
mdb.run

# 変換後のデータを各エントリーに対応した複数のMarkdownファイルに保存する
mdb.save_to_files
{% endhighlight %}

本処理により`md`ディレクトリ以下に、（各エントリではなく）各日記に対応した複数のmarkdownファイルが生成されます。そのファイル名は各日記の日付とタイトルで構成されます。ASCII以外の文字はファイル名のタイトル部分から除去されます。

すべての定義済みフィルタをセットするには、`MdBuilder#pre_defined_filters`または`HateDa::Converter.pre_defined_filters`メソッドを呼びます。

{% highlight ruby %}
# すべての定義済みフィルタを呼ぶ
filters = mdb.pre_defined_filters
# => [:title, :subtitle, :subsubtitle, :order_list, :unorder_list, :blockquote, :pre, :super_pre, :footnote, :br, :link, :hatebu, :amazon, :youtube, :image, :gist]

# すべての定義済みフィルタをセットする
filters.each { |f| mdb.set f }

mdb.run
mdb.save_to_files
{% endhighlight %}

定義済みフィルタのうち、:super_pre, :footnote, :hatebu, :amazon, :youtube, :gistの各フィルタは、liquid tagへの変換を行うので、対応するRuby script pluginが必要となります。

[melborne.github.com/_plugins at source · melborne/melborne.github.com · GitHub](https://github.com/melborne/melborne.github.com/tree/source/_plugins 'melborne.github.com/_plugins at source · melborne/melborne.github.com · GitHub')

ただ、:hatebu, :youtube, :gistの各フィルタに関しては、その第２引数にfalseを渡すことで、liquid tagに代えてhtmlコードを生成させることもできます。

また、`MdBuilder#filter`メソッドを使って、独自フィルタを定義することができます。次のようにします。

{% highlight ruby %}
# はてな記法によるwikipediaタグをliquid tagに変換するフィルタを定義する
mdb.filter(/\[wikipedia:(.*?)\]/) do |md|
  "{ % wikipedia #{md[1]} % }"
end
{% endhighlight %}
フィルタ定義のやり方はhateda2mdが依存している[gsub-filter](https://github.com/melborne/gsub-filter 'melborne/gsub-filter')のreadmeと、HateDa::Converterで定義しているfilterの内容を参照してください。

また、`MdBuilder#run`に引数を渡すことで、特定のエントリだけを変換することができます。

{% highlight ruby %}
# 20番目のエントリだけを変換
mdb.run(20)

# 100番から最後のエントリを変換
mdb.run(100..-1)

# 10番から20件を変換
mdb.run(10,20)
{% endhighlight %}

Enjoy your Blog life!


{{ 4839914982 | amazon_medium_image }}
{{ 4839914982 | amazon_link }} by {{ 4839914982 | amazon_authors }}


(追記:2012-05-06) hateda2mdのversion upに応じて記述を直しました。

(追記:2012-05-07) hateda2mdの説明を一分追加しました。

{% footnotes %}
   {% fn 自己管理の問題でもありますが.. %}
   {% fn 自分の好みのという意味です.. %}
{% endfootnotes %}

