---
layout: post
title: "つぶやきで合奏したいだと？そんなやつは一昨日（おとつい）きやがれ！"
description: ""
category: 
tags: 
date: 2013-12-06
published: true
---
{% include JB/setup %}


[FuniSaya Advent Calendar 2013](http://www.adventar.org/calendars/95)６日目です。昨日は[あるる 日下部](http://www.adventar.org/users/1306 "あるる 日下部 - Adventar")さんの[海底都市 冬コミ](http://arlerlyeh.blog.fc2.com/blog-entry-12.html)でした。

---

音楽を作る才能には恵まれなかったので楽器を作ることにしました。「おとつい（OtoTwe）」という楽器です。

> [OtoTwe : http://ototwe.herokuapp.com/](http://ototwe.herokuapp.com/ "OtoTwe")

## OtoTweの楽しみ方

1. コンピュータにヘッドホンを繋いで耳に当てる。

2. 「[OtoTwe](http://ototwe.herokuapp.com/ "OtoTwe")」をChromeかFirefoxかSafariで開く。

3. いつも使っているTwitterクライアントを起動する（iPhoneとかのもので構いません）。

4. Twitterクライアントで「これが俺の叫びだ！ #ototwe #C3」などと打ち込む。

5. OtoTweにおける`Audiences`の数を横目で確認しつつ{% fn_ref 1 %}、つぶやきをツイートする。

6. OtoTweから流れる音に耳を傾ける（表示されるつぶやきを見ながら）。

または

1. 上記1, 2に同じ。

2. 誰かが上記3〜5に従いツイートするのを辛抱強く待つ。

3. 上記６に同じ。

または

1. 適当な楽曲の適当な小節を選ぶ。

2. 選んだ小節内の音数に相応する暇な友人を見つける。

3. 小節内の各音を各友人に割り当てる。

4. 楽曲のテンポに基づき各友人のツイート時間を決定する。

5. 全員の時計を合わせて指定時間でのツイートを依頼する。

6. 今まで築いてきた友人との信頼関係を信じつつOtoTweの前で時間が来るのを待つ。

※期待通りの結果が得られないことがあります。

## ツイートの作法

1. OtoTweで音を鳴らすには、ツイートに二種類のハッシュタグを入れる必要があります。１つはOtoTweを指定する`#ototwe`タグです。もう一つは音高を指定するタグです。

2. 音高を指定するタグは、A〜Gの大文字アルファベットと数字の組で表現します。「#A4」は440Hzのラの音を出力します。半音は間に`b`を挟んで「#Eb2」のように半音下げて表現します（シャープは使えません）。

3. 出力できる音域はG1〜C4です。

4. 音の種類としてはピアノかホルンの音がランダムで出力されます。たまにMusicBox(?)の音も出ます。音の種類を指定したい場合は、音高タグの数字の後にp(ピアノ)かh(ホルン)を付けます（ex. #C3p #A3h）。m(MusicBox)も有効ですが、音域はC3〜C4の幹音に限られています。

5. 「#C3Eb3G3」などと複数の音を一度に渡すと、和音や連音が気まぐれで再生されます（実装が悪いためです）。

6. ハッシュタグ以外のツイートの内容は音に影響しませんが、スクリーンネームと共にOtoTwe上で5秒程度晒されます。


## OtoTweのしくみ

![ototwe noshadow]({{ BASE_PATH }}/assets/images/2013/12/ototwe1.png)

OtoTweはHTML5における[Server-sent events](https://developer.mozilla.org/ja/docs/Server-sent_events "Server-sent events \| MDN")というしくみを使っています。Server-sent eventsでは、サーバーとクライアントのコネクションは維持され、これによりクライアントからのリクエストを待たずに任意のタイミングでサーバー側からデータを投げられるようになります。OtoTweではTwitterのStreaming APIからデータが送られてきたタイミングで全クライアントに向けてデータをブロードキャストしています。

音の再生はWeb Audio APIを使ってmp3またはoggファイルを読みだして再生しています。もっとスムーズな再生を実現するにはここを工夫する必要があるんでしょうね（JavaScriptむずかしぃ...）。音は初めてのGarageBandでシコシコと作りました。

<br/>

ソースは以下にあります。

> [melborne/ototwe](https://github.com/melborne/ototwe "melborne/ototwe")

どれくらいのコネクションを捌けるのか全くわかりませんけど、固まってたらゴメンナサイ！



そんなわけで...

つぶやきで合奏したい人は「[OtoTwe](http://ototwe.herokuapp.com/ "OtoTwe")」に来てくださいね :-)


---

[FuniSaya Advent Calendar 2013](http://www.adventar.org/calendars/95) 明日は[りひにー](http://www.adventar.org/users/974 "りひにー - Adventar")さんです！

{% footnotes %}
{% fn 離席したユーザの更新に著しい遅延があります.. %}
{% endfootnotes %}
