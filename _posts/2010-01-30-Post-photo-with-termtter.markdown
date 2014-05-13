---
layout: post
title: Termtterで写真を投稿しよう！ - twitpic plugin
date: 2010-01-30
comments: true
categories:
---

Termtterにはtwitpicというpluginが付属していて
これを使えば写真が投稿できる

twitpicはTwitterに連係されたサービスで
Twitterのアカウントがあれば無料で利用できる

twitpic pluginを使うために

{% highlight bash %}
> plug twitpic
{% endhighlight %}

して{% fn_ref 2 %}

{% highlight  bash %}
> twitpic this is me! /path/to/the/file.png
{% endhighlight %}
とすればtwitpicへ写真がポストされ
timelineもupdateされる{% fn_ref 3 %}

また
{% highlight  bash %}
> twitpic my desktop!
{% endhighlight %}
のようにfileパスを付けなければ
マウスカーソルがcaptureモードになるので

click&dragで範囲を決めればdesktopがcaptureされ
それが投稿画像になる

ただcaptureモードにはちょっとバグがあるので
うまくいかない場合は以下を追加する{% fn_ref 4 %}
{% highlight ruby %}
twitpic.rb
15d14
< require "fileutils"
28d26
<     FileUtils.mkdir_p(File.dirname(path)) unless File.exist?(File.dirname(path))
{% endhighlight %}

{% footnotes %}
   {% fn または.termtter/configでtwitpicを有効にする %}
   {% fn fileパスはフルパスで %}
   {% fn tmp directoryが存在しない場合 %}
{% endfootnotes %}

