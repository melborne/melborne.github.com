---
layout: post
title: "Rubyではじめてのコードゴルフ"
description: ""
category: 
tags: 
date: 2013-04-08
published: true
---
{% include JB/setup %}

##─問題─

次の文章における最長単語を出力する最短のコードを書きなさい（文章はコードに含まれていること）。

    Lorem ipsum dolor sit amet consectetur adipisicing elit sed do eiusmod tempor incididunt ut labore et dolore magna aliqua Ut enim ad minim veniam quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur Excepteur sint occaecat cupidatat non proident sunt in culpa qui officia deserunt mollit anim id est laborum

<br />


##─僕の答え─

僕のコードの実行結果です。

{% highlight bash %}
% ruby longest_word.rb
"reprehenderit"
% wc longest_word.rb
       1      71     459 longest_word.rb
{% endhighlight %}

最長単語は「**reprehenderit**」で、ファイルバイト数は459でした。

少し下に実装を貼っておきますね。

<br />
<br />
<br />
<br />
<br />
<br />
<br />
<br />
<br />
<br />
<br />
<br />
<br />
<br />
<br />
<br />
<br />
<br />
<br />
<br />
<br />
<br />
<br />
<br />
<br />
<br />
<br />
<br />
<br />
<br />
<br />

{% highlight ruby %}
p %w(Lorem ipsum dolor sit amet consectetur adipisicing elit sed do eiusmod tempor incididunt ut labore et dolore magna aliqua Ut enim ad minim veniam quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur Excepteur sint occaecat cupidatat non proident sunt in culpa qui officia deserunt mollit anim id est laborum).max_by &:size
{% endhighlight %}

ちょっとズルいですかね〜。


