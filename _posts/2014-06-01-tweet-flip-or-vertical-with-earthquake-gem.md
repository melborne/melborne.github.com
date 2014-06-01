---
layout: post
title: "earthquake.gemで逆さ書きツイートとか縦書きツイートとか"
description: ""
category: 
tags: 
date: 2014-06-01
published: true
---
{% include JB/setup %}

昔作った「[flippy gem](https://rubygems.org/gems/flippy "flippy")」を元に、「[earthquake.gem](https://github.com/jugyo/earthquake "jugyo/earthquake")」用の[flip.rb](https://gist.github.com/melborne/31f81cc17084a0aea7d7 "flip.rb")というプラグインを書きました。

`gem install flippy`した上で

    :plugin_install https://gist.github.com/melborne/31f81cc17084a0aea7d7

とすれば`:flip`コマンドが使えるようになります。

オプション無しで逆さ書き、`-r`オプション付きでそれをさらにリバース、`-v`オプション付きで縦書きを出力します。


    :flip twitter # => "ɹəʇʇᴉʍʇ"
   
    :flip -r twitter # => "ʇʍᴉʇʇəɹ"
   
    :flip -v FOO\\BAR++ by vertical # => "B F"
                                         "A O"
                                         "R O by vertical"

縦書きの区切りは`\\`か全角空白で、例のように`++`以降は横書きに戻ります。

まあ逆さ・縦書きブームなんてものはとっくに過ぎ去りましたが、そんなことは気にせずにツイートしてくださいね :)


