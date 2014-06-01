---
layout: post
title: "earthquake.gemのプラグイン管理"
description: ""
category: 
tags: 
date: 2014-06-01
published: true
---
{% include JB/setup %}

ターミナルに張り付いている人の10人に8人は使ってると言われている「[earthquake.gem](https://github.com/jugyo/earthquake "jugyo/earthquake")」ですが、その魅力はプラグインによる拡張にあります。既に沢山のプラグインがgistで公開されていますから、その中から好きなモノを選んで`:plugin_install`を実行すれば簡単に機能拡張ができます。

> [plugins](https://github.com/jugyo/earthquake/wiki "plugins")

    :plugin_install https://gist.github.com/melborne/ac7a3613ad5c77387b8c

## プラグインの管理

使っているプラグインが増えてくるとその管理も大変ですが、milligrammeさんの「[manage_plugins](https://gist.github.com/milligramme/5253047 "earthquake.gem pluginを管理する")」というプラグインを使えば管理が楽になります。

    :manage_plugins  # インストールされているpluginの一覧を表示する

    :manage_plugins off emoji.rb  # emoji.rbプラグインを無効にする

    :manage_plugins on emoji.rb   # emoji.rbプラグインを有効にする

## manage_pluginsのFork版

manage_pluginsにはエラーが吐かれるなど一部に問題があったので、これを[fork](https://gist.github.com/melborne/ef108e0270b871cfaeef "manage_plugins.rb")して修正＆機能追加版を作りました。変更点は次の通りです。

> 1. 問題点修正＆リファクタリング
> 2. プラグイン指定時にその名前だけでも受け付けるよう変更
> 3. プラグインを削除する`rm`サブコマンドの追加

    :manage_plugins  # インストールされているpluginの一覧を表示する

    :manage_plugins off emoji  # emoji.rbプラグインを無効にする

    :manage_plugins on emoji   # emoji.rbプラグインを有効にする

    :manage_plugins rm emoji   # emoji.rbプラグインを削除する

インストールは次のようにします（earthquake ver 1.0.2以上が必要）。

    :plugin_install https://gist.github.com/melborne/ef108e0270b871cfaeef


これで、一層快適なearthquake.gemライフが送れますね😃


