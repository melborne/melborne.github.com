---
layout: post
title: Termtterでmoreしようよ
date: 2010-02-08
comments: true
categories:
---

##Termtterでmoreしようよ
[前回](http://d.hatena.ne.jp/keyesberry/20100208/p1) Termtterのlistコマンドとsearchコマンドを改良して
{% highlight ruby %}
> list #2
> search #2
{% endhighlight %}
のように次頁以降をリストできるようにした

でも#数字って打ち辛いよね

そこでredoコマンドを参考にして
moreコマンドを実装してみた

listまたはsearchコマンドを実行した後
{% highlight ruby %}
> more
{% endhighlight %}
とすればその続き{% fn_ref 1 %}をリストできる
moreを繰り返せば
席を外している間に流れてしまったTimelineを
どこまでも遡れるんだ

これはなかなか便利！

さらに[TermtterならGoogle検索だってできる - hp12c](http://d.hatena.ne.jp/keyesberry/20100207/p1) 
で追加したgoogle検索にもmoreを対応させたよ(追記:2010/2/9)

{% gist 297408 default_replace.rb %}

##TermtterでコマンドのDefault挙動を変更する
以前の投稿でTermtterのsearchなどのDefaultの挙動を
直接Termtterのコードを書き換えることで行った

[Termtterでuriを開こう！ - uri-openの紹介と改良 - hp12c](http://d.hatena.ne.jp/keyesberry/20100125/p1)
[Termtterで検索しよう! - hp12c](http://d.hatena.ne.jp/keyesberry/20100203/p2)

だけどこの方法はよくない
トラブル回避のために元のコードをどこかに保存しなきゃいけないし
Termtterのversion upで変更は消えてしまう

幸いTermtterは基本コマンドまでもが
pluginで作られているので
同名のコマンドのpluginを用意すれば
基本コマンドの上書きが可能になる

そこで自分は基本コマンドの変更versionを
default_replaceというpluginファイルにまとめて
これをpluginの最後で読み込むようにした

変更点は以下の通り
- searchコマンドで search ruby #2 などと次頁以降の結果を表示
- hashtag addしたときqueryなしでsearchするとそのhashtagをqueryとして検索
- search wordのハイライト表示をunderlineに変更
- listコマンドで list #2 などとして次頁以降を表示
- uri-openコマンドで some あるいは some 10 などとして5あるいは10のuriのみを開く

[gist: 297408 - Termtter plugins- GitHub](http://gist.github.com/297408)
{% footnotes %}
   {% fn 時系列ではそれ以前 %}
{% endfootnotes %}
