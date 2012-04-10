---
layout: post
title: Termtterで#nowplaying
date: 2010-02-22
comments: true
categories:
---


Twitterで#nowplayingというタグを付けて
今聞いてる曲とかをポストするのが流行ってますね

Termtterにはitunesというpluginが添付されていて
これを使えばiTunesで今聞いてる曲を簡単にポストできます
{% highlight ruby %}
> listening_now または ln
 => Listening now: Tequila sunrise (3:28) Eagles Hell Freezes Over #iTunes #listening
{% endhighlight %}

それで折角だから
これにLast.fmの該当曲へのlinkを付けました
{% highlight ruby %}
> ln
 => Listening now: A DAY FOR YOU (3:58) LOVE PSYCHEDELICO The Greatest Hits http://www.last.fm/music/LOVE+PSYCHEDELICO/_/A+DAY+FOR+YOU #iTunes #nowplaying
{% endhighlight %}

これで誰でもあなたの聞いてる曲にすぐアクセスできますね

Termtterってやっぱり便利ですね!

ファイルは添付のitunes2.rbです
termtterのpluginディレクトリにコピーして
plug itunes2してください

[gist: 297408 - Termtter plugins- GitHub](http://gist.github.com/297408)