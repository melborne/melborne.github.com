---
layout: post
title: "Rubyでパイプライン？"
description: ""
category: 
tags: 
date: 2014-03-05
published: true
---
{% include JB/setup %}

[AngularJS](http://angularjs.org/ "AngularJS — Superheroic JavaScript MVW Framework")というものを眺めていたらその中にビューテンプレートなどで使える[フィルター](http://js.studio-kingdom.com/angularjs/guide/filter "フィルターについて | AngularJS 1.2 日本語リファレンス | js STUDIO")という概念がでてきて、あーこれLiquidにもあったけどUNIXのパイプラインみたいで面白いなあRubyでできないかなあ、ということでちょっと試してみましたという内容の投稿です。

まあ、メソッドチェーンでいいよ、って話で終わりなんですが。

AngulraJSのFilterというのはビューテンプレートの中で、

    {{ "{{ 12 | currency "}} }}

のようにすると、`12`が`currency`フィルタを通って`$12.00`が出力されるといった代物です。

    {{ "{{ expression | filter1 | filter2 | filter3 "}} }}

のように複数のフィルタを順次適用することもできます。まさにパイプですね。

## Rubyでパイプ？

でこんな感じのものをRubyで書いてみました。

{% gist 9363948 filter.rb %}

そうすると、こんな風に書けるようになります。

{% highlight ruby %}
require "./filter"
using CoreExt

puts 'hello' | :upcase

# >> HELLO

puts 123 | :next

# >> 124
{% endhighlight %}

もちろんチェーンもできます。

{% highlight ruby %}
puts 'Mississippi' | :upcase | :squeeze | :chars | :reverse

# >> ["I", "P", "I", "S", "I", "S", "I", "M"]

puts 123 | :next | :even?

# >> true
{% endhighlight %}


`Filter.add`を使って新たなフィルターを追加できます。

{% highlight ruby %}
Filter.add :currency do |int|
  raise ArgumentError unless int.is_a?(Numeric)
  "$%.2f" % int
end

puts 123.45 * 3 | :currency

# >> $370.35

Filter.add :titleize do |str|
  str.scan(/\w+/).map(&:capitalize)*' '
end

puts 'ruby on rails' | :titleize

# >> Ruby On Rails
{% endhighlight %}

でも引数取れないんですorz..


