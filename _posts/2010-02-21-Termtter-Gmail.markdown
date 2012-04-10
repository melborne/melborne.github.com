---
layout: post
title: TermtterならGmailだって
date: 2010-02-21
comments: true
categories:
---


朝起きてパソコンを起動して最初にすることは何ですか?

ええもうわかってますよ
Terminalを開いてtermtterコマンドを打って
『今起きた。』ってTweetするんですよね

そして次にBrowserでGmailを開いて
大したメールが来ていなことを確認して
またTermtterに戻って『昨日は飲みすぎた。』とか
『今日は寒い』とかってTweetするんですよね

そんな人のためにgmail pluginを作りました

{% highlight ruby %}
> gmail または gm
{% endhighlight %}
とすればusernameとpasswordを確認後
gmailから未読メールをフェッチしてきて
それらのsenderとsubjectをリストします
メールの未読状態は維持されます

.termtter/configにusernameとpasswordを
登録しておけばLoginは省略されます
{% highlight ruby %}
 config.plugins.gmail.username = 'username'
 config.plugins.gmail.password = 'password'
{% endhighlight %}

これで詰らないメールのために
いちいちBrowserを開く必要がなくなるので
Termtterに貼り付いていられますね

運悪く読まなきゃならないメールが来ていたら
{% highlight ruby %}
> gmail_open または gmo
{% endhighlight %}
としてgmailを立ち上げてください

Termtterってやっぱり便利ですね!

<del datetime="2010-05-17T18:22:31+09:00">Ruby1.8.7でのみ動作します
原因はわかりませんがRuby1.9ではSSLの認証に失敗してしまいます</del>
gmail_openコマンドにはuri_open pluginが必要です
ファイルは添付のgmail.rbです
termtterのpluginディレクトリにコピーして
plug gmailしてください
ライセンスはTermtterに準拠します

[gist: 297408 - Termtter plugins- GitHub](http://gist.github.com/297408)
(追記：2010/5/17)Ruby1.9に対応しました