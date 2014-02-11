---
layout: post
title: "Problem and proposal for a format of english based opensource documents"
title: "英語圏のオープンソースプロジェクトにおける翻訳ドキュメントの問題点とその解決のための一方策"
description: ""
category: 
tags: 
date: 2014-02-11
published: true
---
{% include JB/setup %}


オープンソースプロジェクトの大半は英語ベースです。素晴らしいプロジェクトには大概、素晴らしいドキュメントが付属しており、そのドキュメントを読むことがそのプロジェクトに係る技術を理解する第一歩になります。しかし、英語を母国語としない私たちにとって、英語のドキュメントを通して技術を理解することには一定の困難と苦痛が伴います。

このような背景からいくつかのプロジェクトでは、多言語によるドキュメントをそのプロジェクトの一部として含んでいるものがあります。また、それとは別に有志により翻訳が別リソースとして公開されているケースもあります。このような翻訳ドキュメントの存在が非英語圏の技術者の役に立つことは言うまでもなく、そのプロジェクトの普及のためにも有益であるに違いありません。

## 翻訳ドキュメントの問題点

しかし、その一方で、翻訳ドキュメントには次のような問題が内在しています。

> 1. プロジェクトのコントリビュータは、通常、翻訳ドキュメントの内容を理解できないので、その管理および質の担保は、その翻訳者らに依存することになる。
> 2. 翻訳ドキュメントの利用者において、翻訳上のミスや不適切さなどから原文を確認したいことがあるが、そのために原文の対応箇所を探さなければならない。
> 3. オリジナルドキュメント（原文）に変更が生じている場合、翻訳ドキュメントにおける追随の程度を把握するのに手数を要する。

実際、私がSinatraにおける日本語READMEをアップデートしたときにこれらの問題が顕在化しました。

> [英語圏のオープンソースプロジェクトに貢献する最も簡単な方法またはsinatra/README.jp.mdまたは彼はなぜ私を愛するようになったか](http://melborne.github.io/2014/01/23/contribute-to-english-based-opensource-project-or-sinatra-japanese-readme/ "英語圏のオープンソースプロジェクトに貢献する最も簡単な方法またはsinatra/README.jp.mdまたは彼はなぜ私を愛するようになったか")

## 解決のための一方策

これらの問題は、要するに原文と訳文の対応関係が保証されていないことに起因します。そこで、以下のような対応策を考えてみました。なお、ここでの前提として、オリジナルドキュメントおよび翻訳ドキュメントはMarkdown記法で書かれ、HTML形式に変換されて読まれるものとしています。

> 1. 原文のすべてを翻訳ドキュメントに含める。
> 2. 訳文は原文のセンテンスごとにそれに付随して書く。
> 3. 原文をセンテンスごとに特別なタグで囲み、このブロックを表示・非表示切り替え可能にする。
> 4. 原文の変更に伴う翻訳ドキュメントの更新を行う場合は、その対応原文センテンスも併せて更新する。

このようにして、翻訳ドキュメント内に原文を埋め込むことで次のような効果が期待できます。

> 1. 原文と訳文のセンテンスごとの対応関係が明確になり、メンテナンス性が上がる。
> 2. オリジナルドキュメントと翻訳ドキュメント内の原文との差分を見ることで、翻訳文が読めなくても、翻訳ドキュメントがオリジナルの更新に追随しているかがわかる。
> 3. 翻訳ドキュメントの利用者が容易に原文を確認できる一方で、その原文は非表示にできるので邪魔にならない。

## チュートリアル

上記方針に従った翻訳ドキュメントの作成プロセスを、簡単な例で試してみます。

### 準備

ここではこの目的のために作成した[togglate](https://rubygems.org/gems/togglate "togglate")というツールと、Github社謹製[github-markdown(gfm)](https://rubygems.org/gems/github-markdown "github-markdown")というツールを使います。

`github-markdown`は、Github向けMarkdown(GFM)ファイルをHTMLファイルに変換するツールです（ [GitHub Flavored Markdown](https://help.github.com/articles/github-flavored-markdown "GitHub Flavored Markdown · GitHub Help")）。

`togglate`はオリジナルドキュメントから翻訳ドキュメントのベースとなるドキュメントを生成するツールです。このツールは、センテンスごとに特別のタグで囲まれた原文をコピーし、これをトグルするためのコードを挿入します。デフォルトでgithub-markdownに合わせた仕様になっています。

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
```original
## AwesomeTool
```

[translation here]
```original
AwesomeTools is a DSL for quickly creating awesome tools in Ruby.
```

```ruby
# mytool.rb
require 'awesome_tool'

awesome 'nhk' do |name|
  'You are awesome, #{name}!'
end
```

[translation here]
```original
install the gem:
```

    gem install awesome_tool

[translation here]
```original
And run with:
```

    awesome nhk 'charlie'

[translation here]
```original
Turn on the TV, select NHK.
You will see `You are awesome, charlie!` message on the screen.
```


<script src="http://code.jquery.com/jquery-1.11.0.min.js"></script>
<script>
function createToggleLinks(target, showText, hideText) {
var link = "<span><a href='#' onclick='javascript:return false;' class='toggleLink'>" + showText + "</a></span>";
target.hide().prev().append(link);
$('.toggleLink').click(
  function() {
    if ($(this).text()==showText) {
     $(this).parent().parent().next(target).slideDown(200);
     $(this).text(hideText);
    } else {
      $(this).parent().parent().next(target).slideUp(200);
      $(this).text(showText);
    };
  });
}
var element = $("pre[lang='original']");
createToggleLinks(element, "*", "hide");
</script>
{% endhighlight %}

ポイントは次の3点です。

> 1. 原文の各センテンスを`` ```original``, `` ``` ``で囲み、直前に`[translation here]`というマークを挿入
> 2. コードブロックは原文のまま挿入
> 3. 末尾に原文ブロックをトグルするJavaScriptコードを挿入

### 翻訳作業

`[translation here]`のマークの箇所に、その直下の原文に対応する訳文を入れます。訳が不要な箇所はoriginalブロックを削除します{% fn_ref 1 %}。

{% highlight text %}
## AwesomeTool

AwesomeToolは、Rubyで手早くすごいツールを作るためのDSLです。
```original
AwesomeTools is a DSL for quickly creating awesome tools in Ruby.
```

```ruby
# mytool.rb
require 'awesome_tool'

awesome 'nhk' do |name|
  'You are awesome, #{name}!'
end
```

Gemをインストールします。
```original
install the gem:
```

    gem install awesome_tool

そして、実行します。
```original
And run with:
```

    awesome nhk 'charlie'

テレビを付けて、NHKを選曲します。
`You are awesome, charlie!`というメッセージをスクリーン上で確認できるでしょう。
```original
Turn on the TV, select NHK.
You will see `You are awesome, charlie!` message on the screen.
```

\ コードは省略
{% endhighlight %}


### HTML変換

`gfm`コマンドを使って翻訳が済んだ`README.ja.md`からHTMLファイル(README.ja.html)を生成します。

    % gfm README.ja.md > README.ja.html

次の`README.ja.html`ファイルが生成されます。

{% highlight text %}
<h2>AwesomeTool</h2>

<p>AwesomeToolは、Rubyで手早くすごいツールを作るためのDSLです。</p>

<pre lang="original"><code>AwesomeTools is a DSL for quickly creating awesome tools in Ruby.
</code></pre>

<pre lang="ruby"><code># mytool.rb
require &#39;awesome_tool&#39;

awesome &#39;nhk&#39; do |name|
  &#39;You are awesome, #{name}!&#39;
end
</code></pre>

<p>Gemをインストールします。</p>

<pre lang="original"><code>install the gem:
</code></pre>

<pre><code>gem install awesome_tool
</code></pre>

<p>そして、実行します。</p>

<pre lang="original"><code>And run with:
</code></pre>

<pre><code>awesome nhk &#39;charlie&#39;
</code></pre>

<p>テレビを付けて、NHKを選曲します。<br>
<code>You are awesome, charlie!</code>というメッセージをスクリーン上で確認できるでしょう。</p>

<pre lang="original"><code>Turn on the TV, select NHK.
You will see `You are awesome, charlie!` message on the screen.
</code></pre>

{% endhighlight %}

これをブラウザで表示すると次のように見えます。文末のアスタリスク`*`をクリックしてみてください。原文が表示されます。

----

<h2>AwesomeTool</h2>

<p>AwesomeToolは、Rubyで手早くすごいツールを作るためのDSLです。</p>

<pre lang="original"><code>AwesomeTools is a DSL for quickly creating awesome tools in Ruby.
</code></pre>

<pre lang="ruby"><code># mytool.rb
require &#39;awesome_tool&#39;

awesome &#39;nhk&#39; do |name|
  &#39;You are awesome, #{name}!&#39;
end
</code></pre>

<p>Gemをインストールします。</p>

<pre lang="original"><code>install the gem:
</code></pre>

<pre><code>gem install awesome_tool
</code></pre>

<p>そして、実行します。</p>

<pre lang="original"><code>And run with:
</code></pre>

<pre><code>awesome nhk &#39;charlie&#39;
</code></pre>

<p>テレビを付けて、NHKを選曲します。<br>
<code>You are awesome, charlie!</code>というメッセージをスクリーン上で確認できるでしょう。</p>

<pre lang="original"><code>Turn on the TV, select NHK.
You will see `You are awesome, charlie!` message on the screen.
</code></pre>


---

### オリジナルドキュメントと翻訳ドキュメントの差分

`diff`を使って、オリジナルドキュメントと翻訳ドキュメントの差分を取ってみます。

    % diff -u README.md README.ja.md

出力です。

{% highlight diff %}
--- README.md	2014-02-10 21:14:49.000000000 +0900
+++ README.ja.md	2014-02-11 08:41:18.000000000 +0900
@@ -1,6 +1,9 @@
 ## AwesomeTool
 
+AwesomeToolは、Rubyで手早くすごいツールを作るためのDSLです。
+```original
 AwesomeTools is a DSL for quickly creating awesome tools in Ruby.
+```
 
 ```ruby
 # mytool.rb
@@ -11,14 +14,44 @@
 end
 ```
 
+Gemをインストールします。
+```original
 install the gem:
+```
 
     gem install awesome_tool
 
+そして、実行します。
+```original
 And run with:
+```
 
     awesome nhk 'charlie'
 
+テレビを付けて、NHKを選曲します。
+`You are awesome, charlie!`というメッセージをスクリーン上で確認できるでしょう。
+```original
 Turn on the TV, select NHK.
 You will see `You are awesome, charlie!` message on the screen.
+```
+
 
+<script src="http://code.jquery.com/jquery-1.11.0.min.js"></script>
+<script>
+function createToggleLinks(target, showText, hideText) {
[コードの差分は省略]
{% endhighlight %}

オリジナルに対し追加操作だけが行われたことが分かります。

### オリジナルドキュメントの更新

AwesomeToolのAPIが変わりオリジナルドキュメントが次のように更新されたとします。

{% highlight diff %}
diff --git a/README.md b/README.md
index 07da30d..2a60341 100644
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
--- README.md	2014-02-11 08:52:01.000000000 +0900
+++ README.ja.md	2014-02-11 08:41:18.000000000 +0900
@@ -1,6 +1,9 @@
 ## AwesomeTool
 
+AwesomeToolは、Rubyで手早くすごいツールを作るためのDSLです。
+```original
 AwesomeTools is a DSL for quickly creating awesome tools in Ruby.
+```
 
 ```ruby
 # mytool.rb
@@ -9,25 +12,46 @@
 awesome 'nhk' do |name|
   'You are awesome, #{name}!'
 end
-
-awesome do |name|
-  call :nhk
-end
 ```
 
+Gemをインストールします。
+```original
 install the gem:
+```
 
     gem install awesome_tool
 
+そして、実行します。
+```original
 And run with:
+```
 
     awesome nhk 'charlie'
 
+テレビを付けて、NHKを選曲します。
+`You are awesome, charlie!`というメッセージをスクリーン上で確認できるでしょう。
+```original
 Turn on the TV, select NHK.
 You will see `You are awesome, charlie!` message on the screen.
+```
 
-Alternatively, you can say:
-
-    awesome 'charlie'
 
-Look at the sky, you will see the message with clouds.
+<script src="http://code.jquery.com/jquery-1.11.0.min.js"></script>
+<script>
+function createToggleLinks(target, showText, hideText) {
[コードの差分は省略]
{% endhighlight %}

追随していない部分があることが分かりました（赤字部分）。

それらの箇所を翻訳ドキュメント側にコピーし、対応訳を書きます。結果をdiffで確認します。

{% highlight diff %}
--- README.md	2014-02-11 09:09:44.000000000 +0900
+++ README.ja.md	2014-02-11 09:09:13.000000000 +0900
@@ -1,6 +1,9 @@
 ## AwesomeTool
 
+AwesomeToolは、Rubyで手早くすごいツールを作るためのDSLです。
+```original
 AwesomeTools is a DSL for quickly creating awesome tools in Ruby.
+```
 
 ```ruby
 # mytool.rb
@@ -15,19 +18,55 @@
 end
 ```
 
+Gemをインストールします。
+```original
 install the gem:
+```
 
     gem install awesome_tool
 
+そして、実行します。
+```original
 And run with:
+```
 
     awesome nhk 'charlie'
 
+テレビを付けて、NHKを選曲します。
+`You are awesome, charlie!`というメッセージをスクリーン上で確認できるでしょう。
+```original
 Turn on the TV, select NHK.
 You will see `You are awesome, charlie!` message on the screen.
+```
 
+代わりに、次のように言ってもいいです。
+```original
 Alternatively, you can say:
+```
 
     awesome 'charlie'
 
+空を見上げれば、雲で作られた先のメッセージが見えるでしょう。
+```original
 Look at the sky, you will see the message with clouds.
+```
+
+<script src="http://code.jquery.com/jquery-1.11.0.min.js"></script>
+<script>
+function createToggleLinks(target, showText, hideText) {
[コードの差分は省略]
{% endhighlight %}

赤字が消え、翻訳ドキュメントがオリジナルに追随していることが分かります。

更新後の翻訳ドキュメントをWebに表示してみます。

---

<h2>AwesomeTool</h2>

<p>AwesomeToolは、Rubyで手早くすごいツールを作るためのDSLです。</p>

<pre lang="original"><code>AwesomeTools is a DSL for quickly creating awesome tools in Ruby.
</code></pre>

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

<pre lang="original"><code>install the gem:
</code></pre>

<pre><code>gem install awesome_tool
</code></pre>

<p>そして、実行します。</p>

<pre lang="original"><code>And run with:
</code></pre>

<pre><code>awesome nhk &#39;charlie&#39;
</code></pre>

<p>テレビを付けて、NHKを選曲します。<br>
<code>You are awesome, charlie!</code>というメッセージをスクリーン上で確認できるでしょう。</p>

<pre lang="original"><code>Turn on the TV, select NHK.
You will see `You are awesome, charlie!` message on the screen.
</code></pre>

<p>代わりに、次のように言ってもいいです。</p>

<pre lang="original"><code>Alternatively, you can say:
</code></pre>

<pre><code>awesome &#39;charlie&#39;
</code></pre>

<p>空を見上げれば、雲で作られた先のメッセージが見えるでしょう。</p>

<pre lang="original"><code>Look at the sky, you will see the message with clouds.
</code></pre>

<script src="http://code.jquery.com/jquery-1.11.0.min.js"></script>

<script>
function createToggleLinks(target, showText, hideText) {
var link = "<span><a href='#' onclick='javascript:return false;' class='toggleLink'>" + showText + "</a></span>";
target.hide().prev().append(link);
$('.toggleLink').click(
  function() {
    if ($(this).text()==showText) {
     $(this).parent().parent().next(target).slideDown(200);
     $(this).text(hideText);
    } else {
      $(this).parent().parent().next(target).slideUp(200);
      $(this).text(showText);
    };
  });
}
var element = $("pre[lang='original']");
createToggleLinks(element, "*", "hide");
</script>
---


と、まあこんなものを考えたんですけど、どうでしょうか。

> [melborne/togglate](https://github.com/melborne/togglate "melborne/togglate")

---

{% footnotes %}
{% fn 削除しないで残したほうがいいのかもしれません。 %}
{% endfootnotes %}

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


