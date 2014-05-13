---
layout: post
title: "英語圏のオープンソースプロジェクトにおける翻訳ドキュメントの問題点とその解決のための一方策（仕切り直し版）"
description: ""
category: 
tags: 
date: 2014-02-17
published: true
---
{% include JB/setup %}

(追記：2014-2-26) 自動翻訳機能を追加しました。

> [翻訳ドキュメント作成支援ツールTogglateで翻訳要らず？]({{ BASE_PATH }}/2014/02/25/togglate-meets-mymemory/ "翻訳ドキュメント作成支援ツールTogglateで翻訳要らず？")

---

少し前にオープンソースプロジェクトにおける翻訳ドキュメントの作成における問題点とその解決案について記事を書いたんだけど、要は翻訳ドキュメント内に原文をそのセンテンスごとに埋め込んで、原文と訳文の対応付けを保証しつつこれをトグル表示させることで原文が翻訳ドキュメントの表示上の邪魔にならないようにするといったもので、そのときに併せてこれをスクリプトで実現した`togglate`というツールも作ってそのツールとgithub向けmarkdownのパーサーである`github-markdown`を使ってmarkdownによるオリジナルドキュメントからhtmlによる翻訳ドキュメントを生成するプロセスについても解説したんだ。

> [英語圏のオープンソースプロジェクトにおける翻訳ドキュメントの問題点とその解決のための一方策]({{ BASE_PATH }}/2014/02/11/problem-and-proposal-for-tranlated-documents/ "英語圏のオープンソースプロジェクトにおける翻訳ドキュメントの問題点とその解決のための一方策")


それでそのときのtogglateのデフォルトの仕様としては原文をセンテンスごとに特別なコードブロック`` ```original``, `` ``` ``で囲み、そのブロックをトグル表示させるJavaScriptのコードをmarkdownに埋め込むものとなっていたんだけれど、これに対して`togglate`のissueの方に`Pro Git`の日本語訳をされている@harupongさんから、原文をコードブロックで囲むこともJavaScriptコードを埋め込むことも本家プロジェクト側では受け入れ難いだろうから原文をコードブロックではなくHTMLコメントタグで囲みJavaScriptコードを埋め込まないオプションがあったほうがいいという提案をもらって、提案を頂けただけでも嬉しかったんだけどその提案がまた正にその通りでまあ辛うじてオプションでできなくはなかったんだけど基本設計としてコードブロックどうなのよと思い至ったので、togglateの仕様を見直して上記点を反映させたversion0.03を公開したのでここであらためて紹介しますので今後ともどうぞよろしくお願いします。

> [togglate \| RubyGems.org \| your community gem host](https://rubygems.org/gems/togglate "togglate \| RubyGems.org \| your community gem host")
> 
> [melborne/togglate](https://github.com/melborne/togglate "melborne/togglate")

なお@harupongさんらによるPro Git日本語版電子書籍は以下より入手可能です。ほんと素晴らしい仕事です。

> [Pro Git 日本語版電子書籍公開サイト](http://progit-ja.github.io/ "Pro Git 日本語版電子書籍公開サイト")

## togglateの仕様

togglateはRubyによるスクリプトですがターミナルで実行できる`togglate create`コマンドを持っています。`togglate create`コマンドにオリジナルドキュメントを渡すと、オリジナルドキュメント内の原文をセンテンスごとにHTMLコメント化し、文末にこれを表示させるためのJavaScriptのコードを埋め込んだものを出力します。表示方法としてはマウスオーバーツールチップによる方法(hover)とトグルによる方法(toggle)が`--method`オプションで選べます。JavaScriptのコードは`--no-embed-code`オプションで埋め込まない選択ができます。また原文におけるコードブロックをHTMLコメント化しないオプション`--no-code-block`も選べます。`togglate help create`を参照してください。

    % togglate help create
    Usage:
      togglate create FILE
    
    Options:
      -m, [--method=METHOD]                   # Select a display method: 'hover' or 'toggle'
                                              # Default: hover
      -e, [--embed-code]                      # Enable code embeding to false
                                              # Default: true
          [--toggle-link-text=one two three]
                                              # Default: ["*", "hide"]
      -c, [--code-block]                      # Enable code blocks not to be wrapped
    
    Create a base file for translation from a original file

## チュートリアル

翻訳ドキュメントの作成プロセスを、簡単な例で試してみます。

### 準備

ここではこの目的のために作成した[togglate](https://rubygems.org/gems/togglate "togglate")というツールと、Github社謹製[github-markdown(gfm)](https://rubygems.org/gems/github-markdown "github-markdown")というツールを使います。

`github-markdown`は、Github向けMarkdown(GFM)ファイルをHTMLファイルに変換するツールです（ [GitHub Flavored Markdown](https://help.github.com/articles/github-flavored-markdown "GitHub Flavored Markdown · GitHub Help")）。

翻訳ドキュメントの生成プロセスを図にすると以下のようになります。

![togglate noshadow]({{ BASE_PATH }}/assets/images/2014/02/togglate1.png)

`togglate`、`github-markdown`ともにgem化されているので、インストールは簡単です。

    % gem install togglate
    % gem install github-markdown

これにより`togglate`というコマンドと`gfm`というコマンドが使えるようになりますが、`gfm`は以下のようにして手動でパスを通す必要があります。

    % ln -s .rbenv/versions/2.1.0/lib/ruby/gems/2.1.0/gems/github-markdown-0.6.4/bin/gfm /usr/local/bin


### オリジナルドキュメント

次のような英語で書かれたmarkdownファイル(README.md)があると仮定します。

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

### 翻訳ベースドキュメントの生成

`togglate create`コマンドで、`README.md`から翻訳のベースとなるドキュメント(README.ja.md)を生成します。

    % togglate create README.md > README.ja.md

これにより次のような`README.ja.md`が生成されます。


{% highlight text %}
[translation here]

<!--original
## AwesomeTool
-->

[translation here]

<!--original
AwesomeTools is a DSL for quickly creating awesome tools in Ruby.
-->

[translation here]

<!--original
```ruby
# mytool.rb
require 'awesome_tool'

awesome 'nhk' do |name|
  'You are awesome, #{name}!'
end
```
-->

[translation here]

<!--original
install the gem:
-->

[translation here]

<!--original
    gem install awesome_tool
-->

[translation here]

<!--original
And run with:
-->

[translation here]

<!--original
    awesome nhk 'charlie'
-->

[translation here]

<!--original
Turn on the TV, select NHK.
You will see `You are awesome, charlie!` message on the screen.
-->

<script src="http://code.jquery.com/jquery-1.11.0.min.js"></script>
<script>
$(function() {
  $("*").contents().filter(function() {
    return this.nodeType==8 && this.nodeValue.match(/^original/);
  }).each(function(i, e) {
    var tooltips = e.nodeValue.replace(/^original *[\n\r]|[\n\r]$/g, '');
    $(this).prev().attr('title', tooltips);
  });
});
</script>
{% endhighlight %}

ポイントは次の２点です。

> 1. 原文の各センテンスをHTMLコメントタグである`<!--original`と`-->`で囲み、直前に`[translation here]`というマークを挿入
> 2. ドキュメント末尾にこの原文のコメントブロックを、その直前のDOM（訳文が書かれる場所）上でツールチップ表示させるためのJavaScriptコードを挿入

なお、version0.0.3以前ではデフォルトでコードブロックをタグで囲まない仕様となっていましたが、すべてを囲む仕様に変更しました。コードブロックを囲まないようにしたいときは`--no-code-block`オプションを付けてください。

また、原文をツールチップ表示ではなく、トグル表示させたいときは`--method=toggle`オプションを指定します。

### 翻訳作業

`[translation here]`のマークの箇所に、その直下の原文に対応する訳文を入れます。訳が不要な箇所は原文のコメントブロックを削除します。

{% highlight text %}
## AwesomeTool

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

Gemをインストールします。

<!--original
install the gem:
-->

    gem install awesome_tool

そして、実行します。

<!--original
And run with:
-->

    awesome nhk 'charlie'

テレビを付けて、NHKを選曲します。
`You are awesome, charlie!`というメッセージをスクリーン上で確認できるでしょう。

<!--original
Turn on the TV, select NHK.
You will see `You are awesome, charlie!` message on the screen.
-->

\ コードは省略
{% endhighlight %}

### HTML変換

`gfm`コマンドを使って翻訳が済んだ`README.ja.md`からHTMLファイル(README.ja.html)を生成します。

    % gfm README.ja.md > README.ja.html

次の`README.ja.html`ファイルが生成されます。

{% highlight text %}
<h2>AwesomeTool</h2>

<p>AwesomeToolは、Rubyで手早くすごいツールを作るためのDSLです。</p>

<!--original
AwesomeTools is a DSL for quickly creating awesome tools in Ruby.
-->

<pre lang="ruby"><code># mytool.rb
require &#39;awesome_tool&#39;

awesome &#39;nhk&#39; do |name|
  &#39;You are awesome, #{name}!&#39;
end
</code></pre>

<p>Gemをインストールします。</p>

<!--original
install the gem:
-->

<pre><code>gem install awesome_tool
</code></pre>

<p>そして、実行します。</p>

<!--original
And run with:
-->

<pre><code>awesome nhk &#39;charlie&#39;
</code></pre>

<p>テレビを付けて、NHKを選曲します。<br>
<code>You are awesome, charlie!</code>というメッセージをスクリーン上で確認できるでしょう。</p>

<!--original
Turn on the TV, select NHK.
You will see `You are awesome, charlie!` message on the screen.
-->

<!-- コードは省略 -->
{% endhighlight %}

これをブラウザで表示すると次のように見えます。各訳文の上にマウスカーソルを置いてみてください。原文が表示されます。

----

<h2>AwesomeTool</h2>

<p>AwesomeToolは、Rubyで手早くすごいツールを作るためのDSLです。</p>

<!--original
AwesomeTools is a DSL for quickly creating awesome tools in Ruby.
-->

<pre lang="ruby"><code># mytool.rb
require &#39;awesome_tool&#39;

awesome &#39;nhk&#39; do |name|
  &#39;You are awesome, #{name}!&#39;
end
</code></pre>

<p>Gemをインストールします。</p>

<!--original
install the gem:
-->

<pre><code>gem install awesome_tool
</code></pre>

<p>そして、実行します。</p>

<!--original
And run with:
-->

<pre><code>awesome nhk &#39;charlie&#39;
</code></pre>

<p>テレビを付けて、NHKを選曲します。<br>
<code>You are awesome, charlie!</code>というメッセージをスクリーン上で確認できるでしょう。</p>

<!--original
Turn on the TV, select NHK.
You will see `You are awesome, charlie!` message on the screen.
-->

<script src="http://code.jquery.com/jquery-1.11.0.min.js"></script>

<script>
$(function() {
  $("*").contents().filter(function() {
    return this.nodeType==8 && this.nodeValue.match(/^original/);
  }).each(function(i, e) {
    var tips = e.nodeValue.replace(/^original *[\n\r]|[\n\r]$/g, '');
    $(this).prev().next().attr('title', tips);
  });
});
</script>
---

### オリジナルドキュメントと翻訳ドキュメントの差分

`diff`を使って、オリジナルドキュメントと翻訳ドキュメントの差分を取ってみます。

    % diff -u README.md README.ja.md

出力です。

{% highlight diff %}
--- README.md	2014-02-16 10:20:08.000000000 +0900
+++ README.ja.md	2014-02-16 10:39:13.000000000 +0900
@@ -1,6 +1,10 @@
 ## AwesomeTool
 
+AwesomeToolは、Rubyで手早くすごいツールを作るためのDSLです。
+
+<!--original
 AwesomeTools is a DSL for quickly creating awesome tools in Ruby.
+-->
 
 ```ruby
 # mytool.rb
@@ -11,13 +15,39 @@
 end
 ```
 
+Gemをインストールします。
+
+<!--original
 install the gem:
+-->
 
     gem install awesome_tool
 
+そして、実行します。
+
+<!--original
 And run with:
+-->
 
     awesome nhk 'charlie'
 
+テレビを付けて、NHKを選曲します。
+`You are awesome, charlie!`というメッセージをスクリーン上で確認できるでしょう。
+
+<!--original
 Turn on the TV, select NHK.
 You will see `You are awesome, charlie!` message on the screen.
+-->
+
[コードの差分は省略]
{% endhighlight %}

オリジナルに対し追加操作だけが行われたことが分かります。

### オリジナルドキュメントの更新

AwesomeToolのAPIが変わりオリジナルドキュメントが次のように更新されたとします。

{% highlight diff %}
diff --git a/README.md b/README.md
index 6872e9a..0481f7e 100644
--- a/README.md
+++ b/README.md
@@ -9,6 +9,10 @@ require 'awesome_tool'
 awesome 'nhk' do |name|
   'You are awesome, #{name}!'
 end
+
+awesome do |name|
+  call :nhk
+end
 ```
 
 install the gem:
@@ -21,3 +25,9 @@ And run with:
 
 Turn on the TV, select NHK.
 You will see `You are awesome, charlie!` message on the screen.
+
+Alternatively, you can say:
+
+    awesome 'charlie'
+
+Look at the sky, you will see the message with clouds.
{% endhighlight %}

コードの一部改変と機能説明の追記が行われました。


### 翻訳ドキュメントの更新

翻訳ドキュメントがオリジナルに追随しているかみるために、更新後のオリジナルと翻訳ドキュメントの差分を取ります。

    % diff -u README.md README.ja.md

出力です。

{% highlight diff %}
--- README.md	2014-02-17 18:51:38.000000000 +0900
+++ README.ja.md	2014-02-16 10:39:13.000000000 +0900
@@ -1,6 +1,10 @@
 ## AwesomeTool
 
+AwesomeToolは、Rubyで手早くすごいツールを作るためのDSLです。
+
+<!--original
 AwesomeTools is a DSL for quickly creating awesome tools in Ruby.
+-->
 
 ```ruby
 # mytool.rb
@@ -9,25 +13,41 @@
 awesome 'nhk' do |name|
   'You are awesome, #{name}!'
 end
-
-awesome do |name|
-  call :nhk
-end
 ```
 
+Gemをインストールします。
+
+<!--original
 install the gem:
+-->
 
     gem install awesome_tool
 
+そして、実行します。
+
+<!--original
 And run with:
+-->
 
     awesome nhk 'charlie'
 
+テレビを付けて、NHKを選曲します。
+`You are awesome, charlie!`というメッセージをスクリーン上で確認できるでしょう。
+
+<!--original
 Turn on the TV, select NHK.
 You will see `You are awesome, charlie!` message on the screen.
+-->
 
-Alternatively, you can say:
-
-    awesome 'charlie'
-
-Look at the sky, you will see the message with clouds.
[コードの差分は省略]
{% endhighlight %}

追随していない部分があることが分かりました（赤字部分）。

それらの箇所を翻訳ドキュメント側にコピーし、対応訳を書きます。結果をdiffで確認します。

{% highlight diff %}
--- README.md	2014-02-17 18:51:38.000000000 +0900
+++ README.ja.md	2014-02-17 19:02:00.000000000 +0900
@@ -1,6 +1,10 @@
 ## AwesomeTool
 
+AwesomeToolは、Rubyで手早くすごいツールを作るためのDSLです。
+
+<!--original
 AwesomeTools is a DSL for quickly creating awesome tools in Ruby.
+-->
 
 ```ruby
 # mytool.rb
@@ -15,19 +19,50 @@
 end
 ```
 
+Gemをインストールします。
+
+<!--original
 install the gem:
+-->
 
     gem install awesome_tool
 
+そして、実行します。
+
+<!--original
 And run with:
+-->
 
     awesome nhk 'charlie'
 
+テレビを付けて、NHKを選曲します。
+`You are awesome, charlie!`というメッセージをスクリーン上で確認できるでしょう。
+
+<!--original
 Turn on the TV, select NHK.
 You will see `You are awesome, charlie!` message on the screen.
+-->
 
+代わりに、次のように言ってもいいです。
+<!--original
 Alternatively, you can say:
+-->
 
     awesome 'charlie'
 
+空を見上げれば、雲で作られた先のメッセージが見えるでしょう。
+<!--original
 Look at the sky, you will see the message with clouds.
+-->
+
[コードの差分は省略]
{% endhighlight %}

赤字が消え、翻訳ドキュメントがオリジナルに追随していることが分かります。

更新後の翻訳ドキュメントをWebに表示してみます。

---

<h2>AwesomeTool</h2>

<p>AwesomeToolは、Rubyで手早くすごいツールを作るためのDSLです。</p>

<!--original
AwesomeTools is a DSL for quickly creating awesome tools in Ruby.
-->

<pre lang="ruby"><code># mytool.rb
require &#39;awesome_tool&#39;

awesome &#39;nhk&#39; do |name|
  &#39;You are awesome, #{name}!&#39;
end

awesome do |name|
  call :nhk
end
</code></pre>

<p>Gemをインストールします。</p>

<!--original
install the gem:
-->

<pre><code>gem install awesome_tool
</code></pre>

<p>そして、実行します。</p>

<!--original
And run with:
-->

<pre><code>awesome nhk &#39;charlie&#39;
</code></pre>

<p>テレビを付けて、NHKを選曲します。<br>
<code>You are awesome, charlie!</code>というメッセージをスクリーン上で確認できるでしょう。</p>

<!--original
Turn on the TV, select NHK.
You will see `You are awesome, charlie!` message on the screen.
-->

<p>代わりに、次のように言ってもいいです。</p>

<!--original
Alternatively, you can say:
-->

<pre><code>awesome &#39;charlie&#39;
</code></pre>

<p>空を見上げれば、雲で作られた先のメッセージが見えるでしょう。</p>

<!--original
Look at the sky, you will see the message with clouds.
-->

---

### トグルによる原文の表示

トグルで原文を表示する例も示しておきます。`--method`オプションに`toggle`を渡します。

    % toggle create -m=toggle README.md > README.ja.md
    % gfm README.ja.md > README.ja.html


`README.ja.html`をブラウザで表示すると次のように見えます。文末のアスタリスク*をクリックしてみてください。原文がトグル表示されます。

<h2>AwesomeTool</h2>

<p>AwesomeToolは、Rubyで手早くすごいツールを作るためのDSLです。</p>

<!--toggle_original
AwesomeTools is a DSL for quickly creating awesome tools in Ruby.
-->

<pre lang="ruby"><code># mytool.rb
require &#39;awesome_tool&#39;

awesome &#39;nhk&#39; do |name|
  &#39;You are awesome, #{name}!&#39;
end

awesome do |name|
  call :nhk
end
</code></pre>

<p>Gemをインストールします。</p>

<!--toggle_original
install the gem:
-->

<pre><code>gem install awesome_tool
</code></pre>

<p>そして、実行します。</p>

<!--toggle_original
And run with:
-->

<pre><code>awesome nhk &#39;charlie&#39;
</code></pre>

<p>テレビを付けて、NHKを選曲します。<br>
<code>You are awesome, charlie!</code>というメッセージをスクリーン上で確認できるでしょう。</p>

<!--toggle_original
Turn on the TV, select NHK.
You will see `You are awesome, charlie!` message on the screen.
-->

<p>代わりに、次のように言ってもいいです。</p>

<!--toggle_original
Alternatively, you can say:
-->

<pre><code>awesome &#39;charlie&#39;
</code></pre>

<p>空を見上げれば、雲で作られた先のメッセージが見えるでしょう。</p>

<!--toggle_original
Look at the sky, you will see the message with clouds.
-->


<script>
$(function() {
  $("*").contents().filter(function() {
    return this.nodeType==8 && this.nodeValue.match(/^toggle_original/);
  }).each(function(i, e) {
    var tooltips = e.nodeValue.replace(/^toggle_original *[\n\r]|[\n\r]$/g, '');
    var link = "<span><a href='#' onclick='javascript:return false;' class='toggleLink'>" + "*" + "</a></span>";
    $(this).prev().next().append(link);
    $(this).prev().next().after("<pre style='display:none'>"+ tooltips + "</pre>");
  });

  $('.toggleLink').click(
    function() {
      if ($(this).text()=="*") {
       $(this).parent().parent().next('pre').slideDown(200);
       $(this).text("hide");
      } else {
        $(this).parent().parent().next('pre').slideUp(200);
        $(this).text("*");
      };
    });
});
</script>

---

トグルのためのリンクを変更する場合は、`--toggle-link-text`オプションに２つの文字列を渡します。

    % togglate create README.md --toggle-link-text 'show' 'close' > README.ja.md


説明は以上です。何かご意見・ご要望ありましたら、このブログのコメントまたはgithubのissueに頂けると助かります。

> [melborne/togglate](https://github.com/melborne/togglate "melborne/togglate")

---

<p style='color:red'>=== Ruby関連電子書籍100円〜で好評発売中！ ===</p>

[M'ELBORNE BOOKS]({{ BASE_PATH }}/books/ "M'ELBORNE BOOKS")

<a href="{{ BASE_PATH }}/books/">
  <img src="/assets/images/books/rack_cover.png" alt="rack" style="width:200px" />
</a>
<a href="{{ BASE_PATH }}/books/">
  <img src="/assets/images/books/ruby_pack8.png" alt="pack8" style="width:200px" />
</a>
<a href="{{ BASE_PATH }}/books/">
  <img src="/assets/images/books/ruby_parallel_cover.png" alt="ruby_parallel" style="width:200px" />
</a>

