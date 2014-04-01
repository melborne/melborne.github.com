---
layout: post
title: "素晴らしいオープンソースプロジェクトにおける翻訳者たちの憂鬱とその緩和"
tagline: "Introduce Togglate commentout command"
description: ""
category: 
tags: 
date: 2014-04-01
published: true
---
{% include JB/setup %}

素晴らしいプロジェクトには素晴らしいドキュメントが付き物です。この素晴らしいプロジェクトの素晴らしいドキュメントを、我らが素晴らしい母国語で読めたらなんと素晴らしいことかと願う開発者は少なくないでしょう。そしてそこにはその願いを叶える素晴らしい翻訳者たちが多数いるのです。なんと素晴らしい！

素晴らしいプロジェクトには素晴らしいコントリビューターが多数いて素晴らしい新機能が次々と追加されます。そしてその機能の追加の度に素晴らしいドキュメントにはそれらの素晴らしい機能の解説が次々と追加されていくことになります。なるほど素晴らしい！

しかしこれがドキュメントの素晴らしい翻訳者たちを苦しめるのです。ほぅ素晴らしい！

彼らを苦しめる最大の要因は、オリジナルと翻訳ドキュメントとの対応関係が保証されていないことに起因します。オリジナルが複数回改訂されたとき、現在の翻訳ドキュメントがどのオリジナルに対応するのか、神もGitも誰も知らないのです。へぇ素晴らしい！

こんな状況から翻訳者たちをなんとか救いたい...私にできることはないのか...。


そんな想いから素晴らしい翻訳者たちのために、この素晴らしい私が、この素晴らしい翻訳ドキュメント作成支援ツール「[togglate](https://rubygems.org/gems/togglate "togglate")」を作ったのです。いやっ素晴らしい！


そうではなく。

これは自己中心な私が自分勝手に自分の用に供するために作ったのですよ！おまっ素晴らしい！

...。

それで本題ですが、今回togglateに`commentout`というコマンドを追加したので紹介したいのです。

## togglateとは

「[togglate](https://rubygems.org/gems/togglate "togglate")」は、翻訳ドキュメント内に原文をそのセンテンスごとにコメントとして埋め込んで、翻訳ドキュメントを作るためのベースとなるものを出力するミニツールです。togglateの基本的な使い方については以下に書いています。

>[英語圏のオープンソースプロジェクトにおける翻訳ドキュメントの問題点とその解決のための一方策](http://melborne.github.io/2014/02/11/problem-and-proposal-for-tranlated-documents/ "英語圏のオープンソースプロジェクトにおける翻訳ドキュメントの問題点とその解決のための一方策")
>
> [英語圏のオープンソースプロジェクトにおける翻訳ドキュメントの問題点とその解決のための一方策（仕切り直し版）](http://melborne.github.io/2014/02/17/update-togglate-for-renewed-proposal-to-translation/ "英語圏のオープンソースプロジェクトにおける翻訳ドキュメントの問題点とその解決のための一方策（仕切り直し版）")
> 
> [翻訳ドキュメント作成支援ツールTogglateで翻訳要らず？](http://melborne.github.io/2014/02/25/togglate-meets-mymemory/ "翻訳ドキュメント作成支援ツールTogglateで翻訳要らず？")

このツールは「オープンソースプロジェクトなどの翻訳ドキュメントに原文を埋め込んだらどうか」という提案を含んでいます。理由はこうです。原文を埋め込むことにより、

> 1. 翻訳ドキュメントの利用者が簡単に原文を確認できるようになる。
>
> 2. オリジナルがアップデートされたとき、翻訳ドキュメントがそれに追随しているかの判断が容易になる。

ここで、２の点についてはアップデートされたオリジナルと翻訳ドキュメントの差分(diff)を取ることで変更箇所がわかるということでした。しかしオリジナルがアップデートされていなくても（訳文があるので）差分が出力されてしまい、オリジナルにおける変更点を把握しづらいという問題がありました。

そこで、この問題を解消するため、togglateに翻訳ドキュメントからコメント化された原文を抽出する`commentout`コマンドを用意したのです(version 0.1.2)。


## commentoutコマンドの使い方

`commentout`コマンドは`togglate create`コマンドで翻訳ドキュメントに埋め込まれたコメントを抽出し、元の原文を復元します。具体的には、`original`(default)の名前が付いたコメントタグ`<!--original .. -->`に囲まれた文章を抽出します。ヘルプを見ます。


    % togglate help commentout
    Usage:
      togglate commentout FILE
    
    Options:
      -r, [--remains]  # Output remaining text after extraction of comments
      -t, [--tag=TAG]  # Specify comment tag name
                       # Default: original
    
    Extract commented contents from a FILE

今、`togglate create`コマンドで生成され、翻訳文を追加された次のようなドキュメントがあるとします。このドキュメントには、すべての原文がそのセンテンスごとに埋め込まれています。

#### README.ja.md
{% highlight text %}
## AwesomeTool

<!--original
## AwesomeTool
-->

AwesomeToolは、Rubyで手早くすごいツールを作るためのDSLです。

<!--original
AwesomeTools is a DSL for quickly creating awesome tools in Ruby.
-->


```ruby
# mytool.rb
require 'awesome_tool'

awesome 'nhk' do |name|
  'You are awesome, #{name}!'
end
```

<!--original
```ruby
# mytool.rb
require 'awesome_tool'

awesome 'nhk' do |name|
  'You are awesome, #{name}!'
end
```
-->

Gemをインストールします。

<!--original
install the gem:
-->

    gem install awesome_tool

<!--original
    gem install awesome_tool
-->

そして、実行します。

<!--original
And run with:
-->

    awesome nhk 'charlie'

<!--original
    awesome nhk 'charlie'
-->

テレビを付けて、NHKを選曲します。
`You are awesome, charlie!`というメッセージをスクリーン上で確認できるでしょう。

<!--original
Turn on the TV, select NHK.
You will see `You are awesome, charlie!` message on the screen.
-->

{% endhighlight %}

このドキュメントに対し`commentout`コマンドを実行します。

    % togglate commentout README.ja.md

以下の出力が得られます。

{% highlight text %}
## AwesomeTool

AwesomeTools is a DSL for quickly creating awesome tools in Ruby.

```ruby
# mytool.rb
require 'awesome_tool'

awesome 'nhk' do |name|
  'You are awesome, #{name}!'
end
```

install the gem:

    gem install awesome_tool

And run with:

    awesome nhk 'charlie'

Turn on the TV, select NHK.
You will see `You are awesome, charlie!` message on the screen.

{% endhighlight %}

これはオリジナルのREADME.mdとほぼ同じものになります。従って、オリジナルがアップデートされた場合は、この出力とオリジナルの差分を見れば変更点が分かります。アップデートされたREADME.mdとの差分は`diff`を使って以下の方法により抽出できます。


    % diff -u README.md <(togglate commentout README.ja.md)

出力です。

{% highlight diff %}
--- README.md   2014-03-31 21:05:20.000000000 +0900
+++ /dev/fd/11  2014-03-31 21:09:13.000000000 +0900
@@ -7,11 +7,7 @@
 require 'awesome_tool'

 awesome 'nhk' do |name|
-  'You are AWESOME, #{name}!!!'
-end
-
-awesome do |name|
-  call :nhk
+  'You are awesome, #{name}!'
 end
 ```

@@ -25,9 +21,3 @@

 Turn on the TV, select NHK.
 You will see `You are awesome, charlie!` message on the screen.
-
-Alternatively, you can say:
-
-    awesome 'charlie'
-
-Look at the sky, you will see the message with clouds.
{% endhighlight %}


### --remainsオプション

`commentout`コマンドには`--remains`オプションというのがあります。これは抽出されたコメントを出力する代わりに、コメント抽出後のドキュメントを出力します。つまり訳文のみのドキュメントを出力します。

    % togglate commentout --remains README.ja.md

以下のような出力になります。

{% highlight text %}
## AwesomeTool

AwesomeToolは、Rubyで手早くすごいツールを作るためのDSLです。


```ruby
# mytool.rb
require 'awesome_tool'

awesome 'nhk' do |name|
  'You are awesome, #{name}!'
end
```

Gemをインストールします。

    gem install awesome_tool

そして、実行します。

    awesome nhk 'charlie'

テレビを付けて、NHKを選曲します。
`You are awesome, charlie!`というメッセージをスクリーン上で確認できるでしょう。
{% endhighlight %}

これはコメント原文を見ながら訳文を作成し、後からコメント原文を除去した訳文を作るといった場合に使えるかもしれません。

`commentout`コマンドの説明は以上です。なお、このコマンドで原文を復元するためには、`togglate create`で埋め込まれたコメント原文を、そのまま残すようにして翻訳を行う点に留意が必要です。


---

> [togglate | RubyGems.org | your community gem host](https://rubygems.org/gems/togglate "togglate | RubyGems.org | your community gem host")
> 
> [melborne/togglate](https://github.com/melborne/togglate "melborne/togglate")

