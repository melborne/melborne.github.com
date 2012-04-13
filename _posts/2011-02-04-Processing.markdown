---
layout: post
title: Processingアプレットをはてダに貼り付けよう！
date: 2011-02-04
comments: true
categories:
---


<div class="hatena-widget">
<script src="http://gmodules.com/ig/ifr?url=http://dl.dropbox.com/u/58702/clock2.xml&synd=open&w=200&h=200&title=&border=%23ffffff%7C0px%2C0px+solid+%23ffffff&output=js"></script>
</div>

[Processing](http://processing.org/)はJavaをベースにした
オープンソースのグラフィック専用言語です
マルチプラットフォームの統合開発環境(IDE)が用意されており
それをインストールするだけで誰でも簡単に
グラフィカルなプログラミングを始めることができます

IDEにはエクスポート機能があって
作ったプログラムをアプレット化して
簡単にWebサーバにアップし公開できます

でもWebサーバを用意するのは簡単ではありません
できれば手軽にはてダに貼り付けたい

そんなわけで...

その手順を以下に書いておきます
なおここではDropbox{% fn_ref 1 %}とGoogleのアカウントが必要です
Dropboxのアカウントをお持ちでない方は
是非とも次のリンクから！

[](http://db.tt/KEbzDMO)

上に貼り付けた
clockアプレット(clock.pde)を例に手順を説明します
1. clock.pdeをexportしてclock.jarを生成する
1. clock.jarを~/Dropbox/public/に移動しそのpublic linkを取得する
1. ~/Dropbox/public/にiGoogle登録用のclock.xmlを作りそのpublic linkを取得する
1. iGoogleにアプレットを登録する
1. はてダにclock.xmlへのリンクを貼る

##1. clock.pdeをexportしてclock.jarを生成する
ProcessingのIDEにおいてclock.pdeを作った後
その最右にあるメニューボタンを押すとappletフォルダ内に
clock.jarその他のファイルが自動生成されます
##2. clock.jarを~/Dropbox/public/に移動しそのpublic linkを取得する
生成されたclock.jarをDropbox/publicフォルダに移動します
DropboxのWebサイトに行き
そのファイルのpublic linkを取得します
linkはマウスカーソルをファイルに当てて
右側に現れる矢印から選択できます
##3. ~/Dropbox/public/にiGoogle登録用のclock.xmlを作りそのpublic linkを取得する
以下の内容でDropbox/publicフォルダにxmlファイルを作ります
{% highlight xml %}
<?xml version="1.0" encoding="UTF-8" ?> 
<Module>
  <ModulePrefs title="Clock" height="200" /> 
  <Content type="html">
     <![CDATA[ 
     <applet archive= "http://dl.dropbox.com/u/58702/clock.jar"
             code="clock.class" width="200" height="200" ></applet>
     ]]>
  </Content>
</Module>
{% endhighlight %}

appletタグのarchiveに先のpublic linkを指定します
codeをファイル名.classとします
width heightをclock.pdeでのものと一致させます
DropboxのWebサイトに行き
このファイルのpublic linkを取得します

##4. iGoogleにアプレットを登録する
iGoogleのサイトに行き
先のclock.xmlをgadgetとして登録します
右上の「コンテンツを追加」で開いたページ左下の
「フィードやガジェットを追加」を押します
先ほどのpublic linkを貼り付けて「追加」を押します
確認メッセージをOKしてから
iGoogleのホームに戻り
gadgetが登録されたことを確認します

##5. はてダにclock.xmlへのリンクを貼る
はてなダイアリーで記事を投稿する際に
以下のxmlを本文のところに貼り付けます
{% highlight xml %}
<div class="hatena-widget">
  <script src="http://gmodules.com/ig/ifr?url=http://dl.dropbox.com/u/58702/clock.xml&synd=open&w=200&h=200&title=&border=%23ffffff%7C0px%2C0px+solid+%23ffffff&output=js"></script>
</div>
{% endhighlight %}

urlには先ほどのclock.xmlのpublic linkを指定します
w hをclock.pdeのwidth heightに合わせます
以上です!

なお自分の環境ではpdeを編集して再エクスポートした場合
変更がうまく反映できませんでした
内容を別ファイルにコピーして
別名で上記行程を繰り返し対応しました

この記事は以下のサイトを大いに参考にしています
ありがとうございます！
[](http://mtl.recruit.co.jp/blog/2007/09/flash.html)
[](http://d.hatena.ne.jp/t_yano/20080706/1215370412)

{% gist 802419 clock.pde %}

{% footnotes %}
   {% fn ファイルサーバとして使います %}
{% endfootnotes %}
