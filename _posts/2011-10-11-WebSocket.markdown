---
layout: post
title: プログラミング言語が好き？
tagline: WebSocketのデモ
date: 2011-10-11
comments: true
categories:
---


少し前にRubyでWebSocketする記事を書いたよ

[irbから学ぶRubyの並列処理 ~ forkからWebSocketまで]({{ site.url }}/2011/09/29/irb-Ruby-fork-WebSocket/)

折角WebSocketの概要を理解したんだから
簡単なデモを作ってみんなに見てもらいたいと思ったんだよ

それで次のようなものが出来上がったよ

[Love Languages?](http://lovelang.heroku.com/)

![image](http://img.f.hatena.ne.jp/images/fotolife/k/keyesberry/20111011/20111011180850.png)


僕の独断で選んだ12の言語から
自分の好きな言語を選んで投票するデモだよ
円グラフはWebSocketによりリアルタイムで更新されるから
君が見ているときに誰かが投票していれば
その様子がわかるようになっているよ
誰もそこにいなければiPhoneからでも投票して
PCの画面を見てみれば変化がわかると思うよ

デモでは好きな言語に好きなだけ投票できるから
言語の人気度は測れないけど
その言語に対する熱愛度が測れるかもしれないよ
このブログに辿り着く人はRuby好きが多いだろうから
結果が相当偏りそうだけどね..

適当に遊んでもらえるとうれしいよ

WebSocketの実装には[Pusher](http://pusher.com/)というサービスを使ってるんだけど
その使い方は別の記事にできればと思うよ
とりあえずコードは[github](https://github.com/melborne/LoveLang)に置いておくね

(追記:2011-10-14) 諸般の事情{% fn_ref 1 %}によりコードは一旦非公開とします。すいません
(追記:2011-10-12) 諸般の事情{% fn_ref 2 %}によりデモは停止中です。ごめんなさい。
(追記:2011-10-19) デモは再開しています。またいつメンテに入るかわかりませんが...
(追記:2011-10-24) サンプルコードを再掲しました。
{% footnotes %}
   {% fn scriptクリックが絶えないので.. %}
   {% fn 熱愛度が激しすぎて.. %}
{% endfootnotes %}
