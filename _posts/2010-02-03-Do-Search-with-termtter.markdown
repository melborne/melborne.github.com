---
layout: post
title: Termtterで検索しよう!
date: 2010-02-03
comments: true
categories:
---

> 飛ぶ鳥落とす勢いの　Twitter！
> 猫も杓子もつぶやくよ　Twitter！
> 今起きた　もう寝ます
> はら減った　めし食った
> 
> 飛ぶ鳥落とす勢いの　Twitter！
> 自分も鳥だよ　Twitter！
> 渋谷なう　バイトなう
> カレーなう　ユニクロなう
> 
> 飛ぶ鳥落とす勢いの　Twitter！
> アキレス腱は検索だ　Twitter！
> オプションいっぱい　窓小さい
> 説明どこにも　見当たらない
> 
> 飛ぶ鳥落とす勢いの　[Termtter](http://termtter.org/)！
> Twitterの救世主　Termtter！
> ポストもサーチも　コマンドも
> コマンドラインで　一括処理
> 
> 飛ぶ鳥落とす勢いの　Termtter！
> 正しい発音　ターマッター？{% fn_ref 3 %}
> みんなで一緒に　ターマッター？
> みんなで一緒に　検索しよう！

AND検索をする
{% highlight ruby %}
> s ruby termtter
{% endhighlight %}

OR検索をする
{% highlight ruby %}
> s ruby OR termtter
{% endhighlight %}

topic検索をする
{% highlight ruby %}
> s #ruby
{% endhighlight %}

特定ユーザのpost内で検索する
{% highlight ruby %}
> s ruby from:yukihiro_matz from:yugui
{% endhighlight %}

特定ユーザのすべてのpostを見る
{% highlight ruby %}
> s from:jugyo　または list @jugyo
{% endhighlight %}

特定ユーザを除外して検索する
{% highlight ruby %}
> s ruby -from:merborne
{% endhighlight %}

特定ユーザへのreplyを見る
{% highlight ruby %}
> s to:merborne
{% endhighlight %}

自分へのreplyを見る
{% highlight ruby %}
> r
{% endhighlight %}

特定ユーザへの言及を見る
{% highlight ruby %}
> s @ujm OR @jugyo
{% endhighlight %}

使用clientを特定して検索する
{% highlight ruby %}
> s termtter source:termtter
{% endhighlight %}

自分がしたretweetを見る
{% highlight ruby %}
> retweeted_by_me
{% endhighlight %}

friendsがしたretweetを見る
{% highlight ruby %}
> retweeted_to_me
{% endhighlight %}

自分がretweetされたものを見る
{% highlight ruby %}
> retweets_of_me
{% endhighlight %}

特定postのretweet状況を知る
{% highlight ruby %}
> retweets ID
{% endhighlight %}

自分はさらにstandard_commands.rbに少し変更を加えて
以下のことができるようにしました

検索結果の件数を指定して検索する
{% highlight ruby %}
> ruby -30
{% endhighlight %}

検索結果の次頁以降を表示する
{% highlight ruby %}
> ruby #2
{% endhighlight %}

hashtagモードのとき検索queryがなければ
そのhashtagで検索する
{% highlight ruby %}
> hashtag add termtter
#termtter> s
{% endhighlight %}

.termtter/configで検索結果のhighlight色を指定できるようにする
{% highlight ruby %}
 config.search.colors = [:underline]
{% endhighlight %}

{% highlight ruby %}
standard_commands.rb
128d127
<   config.search.set_default(:colors, [:on_magenta, :white])
133,142d131
<       arg.gsub!(/\s*([-#])(\d+)/) do
<         case $1
<         when '-' then search_option[:rpp] = $2
<         when '#' then search_option[:page] = $2
<         end
<         ''
<       end
<       if arg.empty? && tags = public_storage[:hashtags]
<         arg = tags.to_a.join(" ") 
<       end
150c139
<     :help => ["search,s TEXT [-COUNT] [#PAGE]", "Search for Twitter"]
---
>     :help => ["search,s TEXT", "Search for Twitter"]
156,159c145
<       text.gsub(/(#{query})/i) do |q|
<         config.search.colors.each { |color| q = TermColor.colorize(q, color) }
<         q
<       end
---
>       text.gsub(/(#{query})/i, '<on_magenta><white>\1</white></on_magenta>')
{% endhighlight %}

{% footnotes %}
   {% fn Graph Animatize? %}
   {% fn defaultでファイル名はout0.png %}
   {% fn 発音には諸説あるそうです http://twitter.com/jugyo/status/8493182880 %}
{% endfootnotes %}
