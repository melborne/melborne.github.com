---
layout: post
title: "earthquake.gemで絵文字ツイート"
description: ""
category: 
tags: 
date: 2014-05-30
published: true
---
{% include JB/setup %}

「[earthquake.gem](https://github.com/jugyo/earthquake "jugyo/earthquake")」には「[emoji.rb](https://gist.github.com/jugyo/2551072 "emoji.rb")」プラグインがあるので簡単に絵文字ツイートができます。`gem install named_emoji`した上でearthquake上で

    :plugin_install https://gist.github.com/jugyo/2551072

すればセットアップが完了します。

    そろそろ帰って :beer: するか

などと打てば:beer:のところが🍺に変わってツイートされます。また

    :emojis

で絵文字の一覧が表示できます。タブ補完が使えるので文頭以外で`:be`などとしてTABすれば該当候補がリストアップされます。

使える絵文字は500個くらいはあると思いますが、それじゃ足りないという人はこれをForkした僕の「[emoji.rb](https://gist.github.com/melborne/ac7a3613ad5c77387b8c "emoji.rb")」を使います。870個くらいの絵文字が使えるようになります。

こちらは`emot`というGemに依存していますので、`gem install emot`した上で、

    :plugin_install https://gist.github.com/melborne/ac7a3613ad5c77387b8c

してください（earthquake.gemはver1.0.2~が必要）。

<del>`.earthquake/plugin`にファイルを配置してください（:plugin_installによるインストールはversion 1.0.1では上手くいきません。現在このfixを[PR](https://github.com/jugyo/earthquake/pull/172)中です）。</del>

(追記：2014-5-31) @jugyoさんが速攻で上記PRをマージしたver1.0.2をリリースしてくれました。Thanks!

---

関連記事：

> [GitHubで使える絵文字Emojiが何か分からないとき😖（Mac向け）]({{ BASE_PATH }}/2014/05/19/emoji-cheat-sheet-on-terminal/ "GitHubで使える絵文字Emojiが何か分からないとき😖（Mac向け）")
