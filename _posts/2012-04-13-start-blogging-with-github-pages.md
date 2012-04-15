---
layout: post
title: はてダからGithub Pagesへ
tagline: マネージャのための実践移行ガイド
description: "Jekyllbootstrapを使ったブログの構築手順"
date: 2012-04-14
category: 
tags: [jekyll, github]
published: false
---
{% include JB/setup %}

最近、[GitHub Pages](http://pages.github.com/ 'GitHub Pages')が熱いです。Github Pagesは[GitHub](https://github.com/ 'GitHub')が提供するコンテンツHostingサービスです。Jekyllはそこで利用できるRuby製のサイトジェネレーターです。

`Github Pages`はコンテンツHostingサービスとして、以下の様な特徴を持っています。

1. Githubユーザは、自身のBlogサイトに適した`User Pages`と、特定Projectの紹介サイトに適した`Project Pages`を無料で構築できる。
1. `User Pages`では、Gitを使って`username.github.com`のmasterブランチにコンテンツをpushするだけで、http://username.github.com を公開できる。
1. `Project Pages`では、Projectに対しAutomatic Page Generatorを通してThemeを選ぶだけで、http://username.github.com/project_name/ を公開できる。((もちろん手作業でもできます))
1. [Jekyll](https://github.com/mojombo/jekyll 'mojombo/jekyll')というRuby製静的サイトジェネレーターがサポートされており、[Markdown記法](http://blog.2310.net/archives/6 'blog::2310 » Markdown文法の全訳')や[Liquid](http://liquidmarkup.org/ 'Liquid Templating language')というテンプレート言語で書かれたコンテンツをpushすれば、サーバー側でHTMLファイルを自動生成してくれる。


このサイトはGithub PagesとJekyllを利用して構築しました。僕が取った構築の手順をここに書き残しておきます。

##Jekyllの使い方
`gem install Jekyll`でJekyllをinstallすると、jekyllコマンドが使えるようになります。
[Jekyll-Bootstrap](http://jekyllbootstrap.com/ 'Blogging with Jekyll Tutorial | Jekyll-Bootstrap')
`Jekyll`は次のような特徴を持った、静的サイトジェネレーターです。

1. Jekyllの定めるProject構成でサイトコンテンツを用意

##Github + Jekyllでの問題点
一見、いい事ずくめのGithub Pagesですが問題点もあります。
###その１
[Jekyll](https://github.com/mojombo/jekyll 'mojombo/jekyll')


JekyllにはWordPressなどのようにThemeが用意されていない。
Pluginが使えない
生成に時間が掛かる

##はてなダイアリのデータを移管する

##layout
##style
##Hatena Star
##Comment system
##liquid plugins
###gist
###footnote
###amazon
###youtube

##Google Analitics
##mobile style

