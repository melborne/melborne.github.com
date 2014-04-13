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

`render_codehighlighter`と`add_code_tags`メソッドをオーバーライドするよう`highlight.rb`を次のように修正します。各メソッドではembedされるコードにおける`pre`タグに言語を指定した`class`属性を追加します。

{% highlight ruby %}
module Jekyll
  module Tags
    class HighlightBlock < Liquid::Block
      def render_codehighlighter(context, code)
        #The div is required because RDiscount blows ass
        <<-HTML
  <div>
    <pre class='#{@lang}'><code class='#{@lang}'>#{h(code).strip}</code></pre>
  </div>
        HTML
      end

      def add_code_tags(code, lang)
        # Add nested <code> tags to code blocks
        code = code.sub(/<pre>/,'<pre class="' + lang + '"><code class="' + lang + '">')
        code = code.sub(/<\/pre>/,"</code></pre>")
      end

    end
  end
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
            Source: /Users/keyes/Dropbox/playground/myblog
       Destination: /Users/keyes/Dropbox/playground/myblog/_site
      Generating... done.
    Server address: http://0.0.0.0:4000
  Server running... press ctrl-c to stop.
{% endhighlight %}


出力です。

![jekyll noshadow]({{ BASE_PATH }}/assets/images/2014/04/jekyll_code02.png)

いいようですね！

---

(追記：2014-04-13) @igaiga555さんのアイデアに従って、「highlight.rbを編集」の項を修正しました。

> [Twitter / igaiga555: @merborne わー！わざわざ記事まで書いていただいてあ ...](https://twitter.com/igaiga555/status/455155507544604672 "Twitter / igaiga555: @merborne わー！わざわざ記事まで書いていただいてあ ...")
> 
> [jekyll highlight](https://gist.github.com/igaiga/10564659 "jekyll highlight")

