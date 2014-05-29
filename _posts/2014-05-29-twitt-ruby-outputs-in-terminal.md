---
layout: post
title: "Rubyスクリプトをターミナルからオシャレにツイートする方法"
description: ""
category: 
tags: 
date: 2014-05-29
published: true
---
{% include JB/setup %}


１.「[rcodetools](https://rubygems.org/gems/rcodetools "rcodetools")」と「[t](https://rubygems.org/gems/t "t")」を`gem install`でインストールする。


２. おもむろにターミナルで次のように打ち込む。

    % echo "require 'emot'; ~:'beer smile' #=>" | xmpfilter | xargs -0 t update

３. ツイートを見る

<blockquote class="twitter-tweet" lang="en"><p>require &#39;emot&#39;; ~:&#39;beer smile&#39; # =&gt; &quot;🍺 😄&quot;</p>&mdash; kyoendo (@merborne) <a href="https://twitter.com/merborne/statuses/471989515934916608">May 29, 2014</a></blockquote>
<script async src="//platform.twitter.com/widgets.js" charset="utf-8"></script>

---

関連記事：

[GitHubで使える絵文字Emojiが何か分からないとき😖（Mac向け）]({{ BASE_PATH }}/2014/05/19/emoji-cheat-sheet-on-terminal/ "GitHubで使える絵文字Emojiが何か分からないとき😖（Mac向け）")
