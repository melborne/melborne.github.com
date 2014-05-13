---
layout: post
title: "Togglateを使ってRuby Quizを作ったよ！"
description: ""
category: 
tags: 
date: 2014-02-19
published: true
---
{% include JB/setup %}

翻訳ドキュメント作成支援ツール「`togglate`」というものを作ったのですが、これはWeb単語帳とか問題集とかの、一部を見せたり隠したりするページを作るのにも使えるのです。


それで早速「**Ruby Quiz**」なるものを作ってみたので、時間が許す人は挑戦してください。まあどれもRubyの基礎的な他愛のない問題なので、時間の無駄になるかもしれませんが。「答え」をクリックすると答えと簡単な解説が表示されます。

問題の作り方は下のほうに書きましたので、問題づくりに興味のある方はどうぞ。

## Ruby Quiz

Rubyバージョンは2.1。

---

<p>問１．xの値は何か。</p>

<pre lang="ruby"><code>x = [1,2,3].push *[4,*[5,*[6,7]]]
</code></pre>

<!--original
答え：[1, 2, 3, 4, 5, 6, 7]
解説：*(splat)により配列が展開されて、Array#pushには複数の引数として渡される。
-->

<p>問２．xの値は何か。</p>

<pre lang="ruby"><code>x = [1,2,3] * ([4, 5] * &#39;6&#39;)
</code></pre>

<!--original
答え："146524653"
解説：Array#*にStringオブジェクトを渡すと#joinとして機能する。
-->

<p>問３．xの値は何か。</p>

<pre lang="ruby"><code>x = (&#39;a&#39;..&#39;c&#39;).size == (&#39;c&#39;..&#39;f&#39;).size
</code></pre>

<!--original
答え：true
解説：('a'..'c').sizeはnilになる。
-->

<p>問４．xの値は何か。</p>

<pre lang="ruby"><code>x = 3
x = *x..x**2
</code></pre>

<!--original
答え：[3, 4, 5, 6, 7, 8, 9]
解説：範囲式..は式を取れる。
-->

<p>問５．xの値は何か。</p>

<pre lang="ruby"><code>a = (a=[1,2,3]).push a
x = a[3][3][3][0]
</code></pre>

<!--original
答え：1
解説：配列aの第4要素の値は再帰的にaになる。
-->

<p>問６．xの値は何か。</p>

<pre lang="ruby"><code>a = (a=[1,2,3]).push *a
x = a[3][3][3][0]
</code></pre>

<!--original
答え：0
解説：配列aの第4要素の値は1であり、それ以降はFixnum#[]が呼ばれる。
-->

<p>問７．xの値は何か。</p>

<pre lang="ruby"><code>x = !:false.!
</code></pre>

<!--original
答え：true
解説：:falseはfalse,nil以外の値でtrueと評価される。
-->

<p>問８．xの値は何か。</p>

<pre lang="ruby"><code>x = :-&gt;:+, :======:===
</code></pre>

<!--original
答え：[true, true]
解説：Symbol#>, Symbol#===でシンボル値を比較している。
-->

<p>問９．xの値は何か。</p>

<pre lang="ruby"><code>x = send(def d(n); n * 2 end, 3)
</code></pre>

<!--original
答え：6
解説：メソッド定義はメソッド名をシンボルで返す。
-->

<p>問１０．xの値は何か。</p>

<pre lang="ruby"><code>x = &quot;R&quot; &lt;&lt; 117 &lt;&lt; 98 &lt;&lt; 121
</code></pre>

<!--original
答え："Ruby"
解説：String#<<は引数が整数ならそのASCII文字を追加する。
-->

<script src="http://code.jquery.com/jquery-1.11.0.min.js"></script>

<script>
$(function() {
  $("*").contents().filter(function() {
    return this.nodeType==8 && this.nodeValue.match(/^original/);
  }).each(function(i, e) {
    var tooltips = e.nodeValue.replace(/^original *[\n\r]|[\n\r]$/g, '');
    var link = "<span><a href='#' onclick='javascript:return false;' class='toggleLink'>" + "答え" + "</a></span>";
    $(this).prev().next().append(link);
    $(this).prev().next().after("<pre style='display:none'>"+ tooltips + "</pre>");
  });

  $('.toggleLink').click(
    function() {
      if ($(this).text()=="答え") {
       $(this).parent().parent().next('pre').slideDown(200);
       $(this).text("隠す");
      } else {
        $(this).parent().parent().next('pre').slideUp(200);
        $(this).text("答え");
      };
    });
});
</script>

全問正解しましたか？ええ、もちろんそうでしょうとも！

<br/>

## Togglateを使った問題の作り方


まず、`ruby_quiz_original.md`として以下のようなファイルを用意します。各問は前に4スペース空けます（コメントブロックで囲まれないようにするため）。

{% highlight text %}

    問１．xの値は何か。

```ruby
x = [1,2,3].push *[4,*[5,*[6,7]]]
```

答え：[1, 2, 3, 4, 5, 6, 7]
解説：*(splat)により配列が展開されて、Array#pushには複数の引数として渡される。

    問２．xの値は何か。

```ruby
x = [1,2,3] * ([4, 5] * '6')
```

答え："146524653"
解説：Array#*にStringオブジェクトを渡すと#joinとして機能する。

（以下省略）

{% endhighlight %}

`gem install togglate`でtogglateをインストールすると、`togglate`コマンドが使えるようになります。

`togglate create`サブコマンドにいくつかのオプションを適用して、結果の出力を`ruby_quiz.md`に格納します。

     % togglate create ruby_quiz_original.md -m=toggle -c --toggle-link-text '答え' '隠す' > ruby_quiz.md

`-c`オプション(--code-block)はコードブロックをコメントで囲まないようにします。次のような`ruby_quiz.md`ファイルが得られます。

{% highlight text %}

    問１．xの値は何か。

```ruby
x = [1,2,3].push *[4,*[5,*[6,7]]]
```

[translation here]

<!--original
答え：[1, 2, 3, 4, 5, 6, 7]
解説：*(splat)により配列が展開されて、Array#pushには複数の引数として渡される。
-->

    問２．xの値は何か。

```ruby
x = [1,2,3] * ([4, 5] * '6')
```

[translation here]

<!--original
答え："146524653"
解説：Array#*にStringオブジェクトを渡すと#joinとして機能する。
-->

（中略）

 <script src="http://code.jquery.com/jquery-1.11.0.min.js"></script>
 <script>
 $(function() {
   $("*").contents().filter(function() {
     return this.nodeType==8 && this.nodeValue.match(/^original/);
   }).each(function(i, e) {
     var tooltips = e.nodeValue.replace(/^original *[\n\r]|[\n\r]$/g, '');
     var link = "<span><a href='#' onclick='javascript:return false;' class='toggleLink'>" + "答え" + "</a></span>";
     $(this).prev().append(link);
     $(this).prev().after("<pre style='display:none'>"+ tooltips + "</pre>");
   });
 
   $('.toggleLink').click(
     function() {
       if ($(this).text()=="答え") {
        $(this).parent().parent().next('pre').slideDown(200);
        $(this).text("隠す");
       } else {
         $(this).parent().parent().next('pre').slideUp(200);
         $(this).text("答え");
       };
     });
 });
 </script>
{% endhighlight %}

答えのブロックがコメントで囲まれ、末尾にそれをトグルするコードが追加されます。

このファイルに対して、各問いの前のスペースと、`[translation here]`の文字を削除します。

{% highlight text %}

問１．xの値は何か。

```ruby
x = [1,2,3].push *[4,*[5,*[6,7]]]
```

<!--original
答え：[1, 2, 3, 4, 5, 6, 7]
解説：*(splat)により配列が展開されて、Array#pushには複数の引数として渡される。
-->

問２．xの値は何か。

```ruby
x = [1,2,3] * ([4, 5] * '6')
```

<!--original
答え："146524653"
解説：Array#*にStringオブジェクトを渡すと#joinとして機能する。
-->

（以下省略）
{% endhighlight %}

`gem install github-markdown`して、`gfm`コマンドを使ってこのMarkdownファイルをHTMLに変換します（gfmコマンドはパスを通す必要があります）。

    % gfm ruby_quiz.md > ruby_quiz.html

以上で先のRuby Quizが出来上がります。


> [togglate \| RubyGems.org \| your community gem host](https://rubygems.org/gems/togglate "togglate \| RubyGems.org \| your community gem host")
> 
> [melborne/togglate](https://github.com/melborne/togglate "melborne/togglate")


関連記事： [英語圏のオープンソースプロジェクトにおける翻訳ドキュメントの問題点とその解決のための一方策（仕切り直し版）](http://melborne.github.io/2014/02/17/update-togglate-for-renewed-proposal-to-translation/ "英語圏のオープンソースプロジェクトにおける翻訳ドキュメントの問題点とその解決のための一方策（仕切り直し版）")

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


