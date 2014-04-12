---
layout: post
title: "Jekyllのコードシンタックスハイライトで言語ごとに色を変える"
description: ""
category: 
tags: 
date: 2014-04-12
published: true
---
{% include JB/setup %}

Twitterで@igaiga555さんと、Jekyllのコードシンタックスハイライトで言語ごとに色を変えられないかという話をしました。

![jekyll noshadow]({{ BASE_PATH }}/assets/images/2014/04/jekyll_code01.png)

で、僕が指定した変更先がちょっと間違っていて、それを訂正すると共に改めてもう少しマシな方法を考えましたので、ここに書き残しておきます。

## ひな形を用意

ここでは`jekyll new`コマンドでひな形を作ります。

{% highlight bash %}
% jekyll new myblog
New jekyll site installed in /Users/keyes/Dropbox/playground/myblog.

% cd myblog
% tree
.
├── _config.yml
├── _layouts
│   ├── default.html
│   └── post.html
├── _posts
│   └── 2014-04-12-welcome-to-jekyll.markdown
├── css
│   ├── main.css
│   └── syntax.css
└── index.html
{% endhighlight %}

## highlight.rbを_pluginsにコピー

`_plugins`ディレクトリを作り、Jekyllのソースに組み込まれている`highlight.rb`をここにコピーします。

{% highlight bash %}
% mkdir _plugins
myblog% cp ~/.rbenv/versions/2.1.0/lib/ruby/gems/2.1.0/gems/jekyll-1.5.1/lib/jekyll/tags/highlight.rb _plugins
{% endhighlight %}

## highlight.rbを編集

`highlight.rb`の66〜79行の以下の2箇所における`pre`タグに言語を指定した`class`属性を追加します。

{% highlight ruby %}
      def render_codehighlighter(context, code)
        #The div is required because RDiscount blows ass
        <<-HTML
  <div>
+    <pre class='#{@lang}'><code class='#{@lang}'>#{h(code).strip}</code></pre>
  </div>
        HTML
      end

      def add_code_tags(code, lang)
        # Add nested <code> tags to code blocks
+        code = code.sub(/<pre>/,'<pre class="' + lang + '"><code class="' + lang + '">')
        code = code.sub(/<\/pre>/,"</code></pre>")
      end
{% endhighlight %}

## 言語ごとのCSSを設定

`main.css`において、言語ごとに`background-color`属性を指定します。

{% highlight css %}
.post pre.ruby, .post pre.ruby code {
  background-color: #ffe;
}

.post pre.bash, .post pre.bash code {
  background-color: #cfc;
}
{% endhighlight %}

## 確認

結果をテストするため、`2014-04-12-welcome-to-jekyll.markdown`にshell用のコードを追加します。

{% highlight text %}

Shell code

{{ "{% highlight bash "}} %}
% jekyll new myblog
New jekyll site installed in /Users/keyes/Dropbox/playground/myblog.

% cd myblog
% tree
.
├── _config.yml
├── _layouts
│   ├── default.html
│   └── post.html
├── _posts
│   └── 2014-04-12-welcome-to-jekyll.markdown
├── css
│   ├── main.css
│   └── syntax.css
└── index.html
{{ "{% endhighlight "}} %}
{% endhighlight %}

`jekyll serve`でサーバを起動します。

{% highlight bash %}
% jekyll serve
Configuration file: /Users/keyes/Dropbox/playground/myblog/_config.yml
/Users/keyes/Dropbox/playground/myblog/_plugins/highlight.rb:12: warning: already initialized constant Jekyll::Tags::HighlightBlock::SYNTAX
/Users/keyes/.rbenv/versions/2.1.0/lib/ruby/gems/2.1.0/gems/jekyll-1.5.1/lib/jekyll/tags/highlight.rb:12: warning: previous definition of SYNTAX was here
            Source: /Users/keyes/Dropbox/playground/myblog
       Destination: /Users/keyes/Dropbox/playground/myblog/_site
      Generating... done.
    Server address: http://0.0.0.0:4000
  Server running... press ctrl-c to stop.
{% endhighlight %}

同名のプラグインを２度呼んでいるのでwarningがでています。これを回避したい場合はコピーしたプラグイン側のモジュール名を変えればいいかと思います。

出力です。

![jekyll noshadow]({{ BASE_PATH }}/assets/images/2014/04/jekyll_code02.png)

いいようですね！


