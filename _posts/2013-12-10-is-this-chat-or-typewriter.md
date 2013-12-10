---
layout: post
title: "チャット？　タイプライター？　音？　何？"
description: ""
category: 
tags: 
date: 2013-12-10
published: true
---
{% include JB/setup %}

前の記事でチャットのようなタイプライターのようなリアルタイムWebアプリ「[Typewr](http://typewr.herokuapp.com/ "Typewr")」を紹介しました。

> [WebSocketで実現する未来型チャットシステム?!](http://melborne.github.io/2013/12/09/typewr-new-style-chat-with-websocket/ "WebSocketで実現する未来型チャットシステム?!")
>
> [Typewr](http://typewr.herokuapp.com/ "Typewr")


で、今回これにタイプ音を付けてみましたのでお知らせします。タイプライター経験者も未経験者も是非ともその感覚を味わってください。

一応、使い方と注意点を書いておきます。

## Typewrの使い方と注意点

1. ブラウザ上でタイプするとタイプ音とともに一つの表示領域に文字が入力されていきます。タイプした文字はそのページを開いている他のユーザの表示領域にも同じように表示されます。

2. 複数のユーザからの入力があると文字が混在して先の表示領域に入力されていきます。ユーザ毎に異なる文字色が使われるので、それによって辛うじてユーザ単位の入力が識別できます。

3. Vimperatorなどのキー入力を奪うExtensionを使っている場合は、これをOFFにする必要があります。

4. 文字を消すにはBackSpace（delete）キーを押します。BackSpaceを押し続けると他の人の入力を含めて文字が一つづつ消されていきます。

5. ChromeではBackSpaceは「戻る」に固定され、変更できません。自分の環境（Mac）では代わりに`Ctrl+h`が使えているのですが、使えない人もいるようです。解決策は今のところありません。

6. FireFoxでもBackSpaceは「戻る」ですが、設定でこれを無効にすることができます。設定方法は以下の記事が参考になります。

7. SafariではBackSpaceもCtrl+hも効いています。IEについてはわかりません。ごめんなさい。

> [Mozilla Re-Mix: Firefoxで[Backspace]キーを押したときの挙動を変更する方法。](http://mozilla-remix.seesaa.net/article/128191783.html "Mozilla Re-Mix: Firefoxで[Backspace]キーを押したときの挙動を変更する方法。")

以上です。

