---
layout: post
title: "flippy gemにKernel#stndを追加しましたので、お知らせします。"
description: ""
category: 
tags: 
date: 2013-02-04
published: true
---
{% include JB/setup %}

flippy gemに`Kernel#stnd`を追加しましたので、お知らせします。versionは0.0.3です。


> [flippy \| RubyGems.org \| your community gem host](https://rubygems.org/gems/flippy 'flippy \| RubyGems.org \| your community gem host')


##Kernel#stndの使い方

{% highlight ruby %}
require "flippy"

stnd "flippy is really fun!"

stnd [:flippy, 'fun', [1, 2, 3]], Kernel

# >> ¡unɟ ʎllɐəɹ sᴉ ʎddᴉlɟ
# >> ʎddᴉlɟ
# >> unɟ
# >> ⇂
# >> Ƨ
# >> ε
# >> ləuɹə丬
{% endhighlight %}

以上です。


