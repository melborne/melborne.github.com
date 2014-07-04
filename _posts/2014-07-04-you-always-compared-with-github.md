---
layout: post
title: "GitHubの彼と自分を比べて何になるの？"
tagline: "gh-diffの紹介〜翻訳プロジェクトのために"
description: ""
category: 
tags: 
date: 2014-07-04
published: true
---
{% include JB/setup %}

過去の自分と今の自分を比べてみてそこに何か変化があったとき、人は生きていることを実感します。UNIXを作った人達は自分たちが生きているということをコンピュータスクリーン上で実感したくて、「[diff](http://ja.wikipedia.org/wiki/Diff "diff - Wikipedia")」というツールを作りました。`diff`があれば簡単に一年前の自分と今の自分を比べられるのです。

{% highlight diff %}
% diff -u me_in_last_summer.txt me.txt

--- me_in_last_summer.txt	2013-07-03 18:17:21.000000000 +0900
+++ me.txt	2014-07-03 18:17:21.000000000 +0900
@@ -1,3 +1,4 @@
 My name is Charlie.
 I can do a handstand.
-I hate carrots.
+I love carrots.
+I speak Japanese a little.

{% endhighlight %}

diffが吐き出す列をみて、あるときは成長を喜び、あるときは無為に過ごした１年を後悔したものです。

しかし時が過ぎ、自分の過去とだけ向き合う平穏な時代は終わりました。人々が常時繋がったソーシャルネットワークの時代が到来したのです。`diff`は昔と何も変わりませんが、時代の変化によりその使われ方が変化しました。人々は自分の成長を確認するために`diff`を使うことを止め、ソーシャルネットワークの向こう側にいる他人との比較にこれを利用するようになったのです。

{% highlight diff %}
% diff -u me.txt inet/linus.txt

--- me.txt	2015-07-03 22:17:21.000000000 +0900
+++ inet/linus.txt	2015-07-03 22:18:21.000000000 +0900
@@ -1,4 +1,4 @@
-My name is Charlie.
-I am single.
-I created let_it_fall.
-I am anus or git.
+My name is Linus
+I am married.
+I created Linux.
+I created Git.
{% endhighlight %}

diffが吐き出す列をみて、あるときは勝ち誇り、あるときは辛すぎる現実に目を背けるのです。

それでも私たちはこの過酷な時代を生き抜いていかなければならないのです...diffという武器を持って..。

---

そんなわけで...。

GitHub上のファイルとローカルのファイルを簡単に比較できる「gh-diff」というツールを作りましたので紹介させてください（どんなわけ）😅

> [gh-diff](https://rubygems.org/gems/gh-diff "gh-diff")
> 
> [melborne/gh-diff](https://github.com/melborne/gh-diff "melborne/gh-diff")

恐らく用途は限定的ですが、git管理下にない、またはGitHub上のプロジェクトとは別管理のファイル群と、GitHub上のファイル群とのdiffを取ることができます。後述するように、`gh-diff`は原文を組み込んだ翻訳ドキュメントと、オリジナルドキュメントを比較するのに便利なように作られています。

## 作った経緯

最近、@goshujinさんがホストの「[jekyllrb-ja](https://github.com/jekyllrb-ja/jekyllrb-ja.github.io "jekyllrb-ja/jekyllrb-ja.github.io")」という[Jekyll](http://jekyllrb.com/ "Jekyll")の日本語ドキュメント作成プロジェクトに関わっています。このプロジェクトでは、本家のドキュメントのアップデートにどうやって追随していくかということが現在進行形で問題になっています。その過程でこの問題の一部を解決するためのツールとして、@goshujinさんがRakeタスク（togglate）を作り、僕がそれを改良したThorタスク（jekyllja.thor）を作りました。`gh-diff`はjekyllja.thorを汎用化、Gem化したものとして生まれました。


## 使い方

ライブラリに付属する「[README.ja.md](https://github.com/melborne/gh-diff/blob/master/README.ja.md "gh-diff/README.ja.md")」を転載して説明に代えます。

---

gh-diffには`gh-diff`というターミナルコマンドが付いています。


{% highlight bash %}
% gh-diff
Commands:
  gh-diff diff LOCAL_FILE [REMOTE_FILE]  # Compare FILE(s) between local and remote repository. LOCAL_FILE can be DIRECTORY.
  gh-diff dir_diff DIRECTORY  # Print added and removed files in remote repository
  gh-diff get FILE            # Get FILE content from github repository
  gh-diff help [COMMAND]      # Describe available commands or one specific command

Options:
  -g, [--repo=REPO]          # target repository
  -r, [--revision=REVISION]  # target revision
                             # Default: master
  -p, [--dir=DIR]            # target file directory
      [--username=USERNAME]  # github username
      [--password=PASSWORD]  # github password
      [--token=TOKEN]        # github API access token
{% endhighlight %}

'melborne/tildoc'レポジトリの`README.md`を比較するには、こうします。

{% highlight bash %}
% gh-diff diff README.md --repo=melborne/tildoc
Diff found on README.md <-> README.md [6147df8:master]
{% endhighlight %}

`--name_only`オプションをfalseにセットすれば、その差分がプリントアウトされます。

{% highlight bash %}
% gh-diff diff README.md --repo=melborne/tildoc --no-name_only
Base revision: 6147df8378545a4807a2ed73c9e55f8d7204c14c[refs/heads/master]
--- README.md
+++ README.md


 Add String#~ for removing leading margins of heredocs.

-Added this line to local.
-
 ## Installation

 Add this line to your application's Gemfile:
{% endhighlight %}

差分の結果を保存する場合は、`--save`オプションをdiffコマンドに追加します。

### 翻訳などのプロジェクトのために

<!--original
### For Translation-like project
-->

HTMLコメントタグを使って原文が挿入された翻訳ファイルがあり、この原文とリモートのオリジナルとを比較したい場合には、`commentout`オプションが役立つでしょう。


    % gh-diff diff README.ja.md README.md --commentout


これは、`README.ja.md`からコメントテキストを抽出し、リモートの`README.md`と比較します。

より詳細は`gh-diff help diff`を見てください。

### 環境変数ENVにおけるオプション

これらのオプションは、接頭辞`GH_`を使って環境変数にプリセットできます。

    % export GH_USERNAME=melborne
    % export GH_PASSWORD=xxxxxxxx
    % export GH_TOKEN=1234abcd5678efgh


また、プロジェクトルートの`.env`ファイルに設定することもできます。

    #.env
    REPO=jekyll/jekyll
    DIR=site


`.env`の環境変数は、`GH_`で始まるグローバル環境変数を上書きします。

GitHub APIにはアクセス制限があります。ベーシック認証（usernameとpassword）または[個人用のAPIトークン](https://github.com/blog/1509-personal-api-tokens "Personal API tokens")でこれを引き上げることができるので、それらを設定するとよいでしょう。

---

## 簡単なチュートリアル

簡単なチュートリアルを通して、`gh-diff`の使い方を説明します。以下では、GitHubで管理されている`melborne/tildoc`の`README.md`を取得し、この翻訳版`README.ja.md`を作成します。`gem install gh-diff`でgh-diffを取得して作業を開始します。

### 環境変数の設定

任意のディレクトリを用意し(ex. tildoc-ja)、オプション入力の手間を避けるため、そのルートに`.env`ファイルを用意してオプションをプリセットします。

{% highlight bash %}
REPO=melborne/tildoc
TOKEN=xxxxxxxxx
{% endhighlight %}

### README.mdの取得

`gh-diff get`コマンドを使って、GitHubから`README.md`を取得し、ローカルに保存します。デフォルトで最新の`master`のものを取得します。

{% highlight bash %}
tildoc-ja% gh-diff get README.md --ref
Base revision: 6147df8378545a4807a2ed73c9e55f8d7204c14c[refs/heads/master]
# Tildoc

Add String#~ for removing leading margins of heredocs.

## Installation

Add this line to your application's Gemfile:

    gem 'tildoc'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install tildoc

## Usage
  .
  .
  .
{% endhighlight %}

`--ref`オプションは、ファイルの先頭行にリファレンス情報を追加します。`--ref`オプションを外してこれをファイルに保存します。

{% highlight bash %}
tildoc-ja% gh-diff get README.md > README.md
{% endhighlight %}

### 取得ファイルとの差分

この時点でローカルに保存したREADME.mdに少し変更を加え、リモートと比較してみます。ローカルのREADME.mdに次の二行を追加します。

{% highlight text %}
# Tildoc

Add String#~ for removing leading margins of heredocs.

+Tilde + Heredoc = Tildoc 😃
+
## Installation

Add this line to your application's Gemfile:
{% endhighlight %}

`gh-diff diff`コマンドでリモートとの差分を取ります。ファイル名が同じ時は一つ省略できます。

{% highlight bash %}
tildoc-ja% gh-diff diff README.md

Diff found on README.md <-> README.md [6147df8:master]
{% endhighlight %}

違いがある旨が出力されました。ここでファイル名に代えてディレクトリを渡すと、その直下のファイル群が比較の対象となります。

差分をプリントしたいときは、`--no-name_only`オプションを付けます。

{% highlight diff %}
tildoc-ja% gh-diff diff README.md --no-name_only

Base revision: 6147df8378545a4807a2ed73c9e55f8d7204c14c[refs/heads/master]
--- README.md
+++ README.md


 Add String#~ for removing leading margins of heredocs.

-Tilde + Heredoc = Tildoc 😃
-
 ## Installation

 Add this line to your application's Gemfile:
{% endhighlight %}

差分を保存したいときは`--save`オプションを付けます。デフォルトでルートに`diff`ディレクトリを作りそこに`README.diff`というファイル名で保存します。

{% highlight bash %}
tildoc-ja% gh-diff diff README.md --save
Diff saved at 'diff/./README.diff'
tildoc-ja% tree
.
├── README.md
└── diff
    └── README.diff

1 directory, 2 files
{% endhighlight %}

ちょっと表記がおかしいですが、差分が保存されました。

### 翻訳ドキュメントの作成

取得したREADME.mdに基いて、翻訳ドキュメント`README.ja.md`を作ります。ここでは、`gh-diff`にも組み込まれている「[togglate](https://rubygems.org/gems/togglate "togglate")」というツールを使います。次のようにします。

{% highlight bash %}
tildoc-ja% togglate create README.md --translate=to:ja --no-embed-code > README.ja.md
{% endhighlight %}

`togglate`の自動翻訳機能を使って（translateオプション）、日本語ドキュメントを自動生成し`README.ja.md`に保存します。togglateは原文を各センテンス毎にHTMLコメントタグで挿入します。生成されたファイルは次のようになります。

{% highlight text %}
＃のTildoc

<!--original
# Tildoc
-->

ヒアドキュメントのリーディング·マージンを除去するための文字列＃〜を追加します。

<!--original
Add String#~ for removing leading margins of heredocs.
-->

チルダヒアドキュメント= Tildoc😃

<!--original
Tilde + Heredoc = Tildoc 😃
-->

任職

<!--original
## Installation
-->

アプリケーションのGemfileに次の行を追加します。

<!--original
Add this line to your application's Gemfile:
-->

宝石 &#39;tildoc&#39;

<!--original
    gem 'tildoc'

-->

してから実行します。

<!--original
And then execute:
-->

パッケージ

<!--original
    $ bundle

-->

またはそれを自分でインストールします。

<!--original
Or install it yourself as:
-->

$逸品tildocをインストールする

<!--original
    $ gem install tildoc

-->
   .
   .
   .
{% endhighlight %}

訳が微妙ですが、これで訳が完成したとします。

### 翻訳ドキュメント内原文とGitHub上のREADME.mdを比較

時が流れて、どうやらGitHub上のREADME.mdがアップデートされたようです。`README.ja.md`に挿入した原文と、アップデートされたGitHub上のREADME.mdを比較することで、翻訳ドキュメントをこれに追随させます。

`commentout`オプションで、`README.ja.md`内のHTMLコメントタグから原文を抽出し、これをGitHubのREADME.mdと比較します。

{% highlight diff %}
tildoc-ja% gh-diff diff README.ja.md README.md --commentout --no-name_only
Base revision: 6147df8378545a4807a2ed73c9e55f8d7204c14c[refs/heads/master]
--- README.ja.md
+++ README.md


 Add String#~ for removing leading margins of heredocs.

-Tilde + Heredoc = Tildoc 😃
-
 ## Installation

 Add this line to your application's Gemfile:

 puts ATool.help
 ```
+
+## Contributing
+
+1. Fork it ( https://github.com/[my-github-username]/tildoc/fork )
+2. Create your feature branch (`git checkout -b my-new-feature`)
+3. Commit your changes (`git commit -am 'Add some feature'`)
+4. Push to the branch (`git push origin my-new-feature`)
+5. Create a new Pull Request
{% endhighlight %}

`Contributing`の項が追加されているのがわかります。

なお、最初に取得した`README.md`との比較をしたい場合は、`--revision=6147df`として対象リビジョンを指定します。これは最初に保存した`README.diff`に記録されているのでそれを参照します。

この差分を`README.ja.md`に取り込んで対応する訳文を追加すれば、オリジナルに追随できたことになります。

以上です。

翻訳プロジェクトなどで活かしてもらえると、うれしいです。


> [gh-diff](https://rubygems.org/gems/gh-diff "gh-diff")
> 
> [melborne/gh-diff](https://github.com/melborne/gh-diff "melborne/gh-diff")


---

関連記事：

> [Sinatraが、Jekyllが、オープンソース翻訳プロジェクトが、今静かに動き出している](http://melborne.github.io/2014/04/03/togglate-handle-liquid-tags/ "Sinatraが、Jekyllが、オープンソース翻訳プロジェクトが、今静かに動き出している")
> 
> [素晴らしいオープンソースプロジェクトにおける翻訳者たちの憂鬱とその緩和](http://melborne.github.io/2014/04/01/togglate-now-have-reverse-action/ "素晴らしいオープンソースプロジェクトにおける翻訳者たちの憂鬱とその緩和")
> 
> [英語圏のオープンソースプロジェクトにおける翻訳ドキュメントの問題点とその解決のための一方策（仕切り直し版）](http://melborne.github.io/2014/02/17/update-togglate-for-renewed-proposal-to-translation/ "英語圏のオープンソースプロジェクトにおける翻訳ドキュメントの問題点とその解決のための一方策（仕切り直し版）")

---

(追記：2014-7-4) コメントのご指摘を受けて、`Diff`を`diff`に直しました。

