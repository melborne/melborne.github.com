---
layout: post
title: "WebSocketで実現する未来型チャットシステム?!"
description: ""
category: 
tags: 
date: 2013-12-09
published: true
---
{% include JB/setup %}

Herokuで[Pusher](http://pusher.com/ "Pusher | HTML5 WebSocket Powered Realtime Messaging Service")を使わずにWebSocketが利用できるということを知ったので[ここ](https://devcenter.heroku.com/articles/ruby-websockets "Using WebSockets on Heroku with Ruby | Heroku Dev Center")を参考に面白いものできないかと弄ってたらなんか不思議なチャットシステム？が出来上がったので暇で誰か知らない人と匿名でチャットというかタイピングのやりとりというか邪魔し合いというかまあ恐らく未体験な人と人との繋がりの類を経験したい方居られましたら是非とも来て見て触ってみてできたら感想などをTwitterとかでつぶやいてくれたら大変にうれしく思います。VimperatorとかのExtensionをOFFにして。

> [Typewr](http://typewr.herokuapp.com/ "Typewr")


ソースはこちら。

> [melborne/typewr](https://github.com/melborne/typewr "melborne/typewr")

併せて、Server-sent Eventsを使った姉妹品もどうぞよろしく。

> [つぶやきで合奏したいだと？そんなやつは一昨日（おとつい）きやがれ！](http://melborne.github.io/2013/12/06/come-join-ototwe/ "つぶやきで合奏したいだと？そんなやつは一昨日（おとつい）きやがれ！")


---

<p style='color:red'>=== Ruby関連電子書籍100円で好評発売中！ ===</p>

[M'ELBORNE BOOKS]({{ BASE_PATH }}/books/ "M'ELBORNE BOOKS")

<a href="{{ BASE_PATH }}/books/">
  <img src="/assets/images/2012/ruby_parallel_cover.png" alt="ruby_parallel" style="width:200px" />
</a>
<a href="{{ BASE_PATH }}/books/">
  <img src="/assets/images/2012/rack_cover.png" alt="rack" style="width:200px" />
</a>
<a href="{{ BASE_PATH }}/books/">
  <img src="/assets/images/2012/js_oop_cover.png" alt="js_oop" style="width:200px" />
</a>


