---
layout: post
title: "RubyのメソッドArray#same?は要りませんか？"
description: ""
category: 
tags: 
date: 2012-10-30
published: true
---
{% include JB/setup %}

複数の要素（オブジェクト）の同値性を特定の条件の下で比較したい、ということがたまにあります。

例えば、名前をキーとした住所録のデータベースを考えます。
{% highlight ruby %}
ADDRESS = { Charlie:'228 Park Ave. NY', Liz:'1419 Westwood Blvd. CA', Scott:'50 Hasler Rd. WA' }

def ADDRESS.find_by_name(name)
  self[name]
end

ADDRESS.find_by_name(:Liz) # => "1419 Westwood Blvd. CA"
{% endhighlight %}

ここで、`find_by_name`に渡す名前にそのuniqnessが保証される範囲で柔軟性を持たせる、つまり:lizでも'Liz'でも'LIZ'でも受け付けるよう対応するとします。こんな感じでしょうか。

{% highlight ruby %}
def ADDRESS.find_by_name(name)
  self[name.capitalize.intern]
end

[:Liz, :liz, 'Liz', 'LIZ'].each do |name|
  puts ADDRESS.find_by_name(name)
end
# >> 1419 Westwood Blvd. CA
# >> 1419 Westwood Blvd. CA
# >> 1419 Westwood Blvd. CA
# >> 1419 Westwood Blvd. CA
{% endhighlight %}

しかしながらデータベース側のキー値のフォーマットの一貫性が保証されていない場合、これは当然にうまく機能しません{% fn_ref 1 %}。
{% highlight ruby %}
ADDRESS = { 'charlie' => '228 Park Ave. NY', Liz:'1419 Westwood Blvd. CA', Scott:'50 Hasler Rd. WA' }

def ADDRESS.find_by_name(name)
  self[name.capitalize.intern]
end

['charlie', 'Charlie', :Charlie, :charlie].each do |name|
  puts ADDRESS.find_by_name(name)
end
# >> 
# >> 
# >> 
# >> 
{% endhighlight %}

このような場合に、比較する要素を同じ条件にしてその同値性を比較したという欲求が生まれます。

次のように対応するのでしょうか。

{% highlight ruby %}
ADDRESS = { 'charlie' => '228 Park Ave. NY', Liz:'1419 Westwood Blvd. CA', Scott:'50 Hasler Rd. WA' }

def ADDRESS.find_by_name(name)
  res = self.detect do |kname, _|
    kname, name = [kname, name].map { |n| n.downcase.intern }
    kname == name
  end
  res ? res.last : nil 
end

[:Liz, :liz, 'Liz', 'LIZ'].each do |name|
  puts ADDRESS.find_by_name(name)
end

# >> 1419 Westwood Blvd. CA
# >> 1419 Westwood Blvd. CA
# >> 1419 Westwood Blvd. CA
# >> 1419 Westwood Blvd. CA

['charlie', 'Charlie', :Charlie, :charlie].each do |name|
  puts ADDRESS.find_by_name(name)
end

# >> 228 Park Ave. NY
# >> 228 Park Ave. NY
# >> 228 Park Ave. NY
# >> 228 Park Ave. NY
{% endhighlight %}

うまくいきましたが、２つの要素を変換した結果を一旦変数に入れて、それらの同一性を比較するという処理が何かまどろっこしいですよね。

## Array#same?

そんなわけで...

Array#same?というのを考えました:-)

{% highlight ruby %}
class Array
  def same?(&blk)
    self.uniq(&blk).size==1
  end
end
{% endhighlight %}

`same?`を使うと先のコードは次のように簡潔になります。

{% highlight ruby %}
def ADDRESS.find_by_name(name)
  res = self.detect do |kname, _|
    [kname, name].same? { |n| n.downcase.intern }
  end
  res ? res.last : nil 
end

[:Liz, :liz, 'Liz', 'LIZ'].each do |name|
  puts ADDRESS.find_by_name(name)
end

# >> 1419 Westwood Blvd. CA
# >> 1419 Westwood Blvd. CA
# >> 1419 Westwood Blvd. CA
# >> 1419 Westwood Blvd. CA
{% endhighlight %}

`res ? res.last : nil`もまどろっこしいという人は、「[前回](http://melborne.github.com/2012/10/29/rubys-new-control-structure-by-tap-and-break/ 'TapがRubyの新たな制御構造の世界を開く')」紹介した`tap+break`でさらに..

{% highlight ruby %}
def ADDRESS.find_by_name(name)
  self.detect do |kname, _|
    [kname, name].same? { |n| n.downcase.intern }
  end.tap { |s| break s.last if s }
end

[:Liz, :liz, 'Liz', 'LIZ'].each do |name|
  puts ADDRESS.find_by_name(name)
end
# >> 1419 Westwood Blvd. CA
# >> 1419 Westwood Blvd. CA
# >> 1419 Westwood Blvd. CA
# >> 1419 Westwood Blvd. CA
{% endhighlight %}

`Array#same?`なんかあってもよさそうですけど、需要ないんですかね？

以上、Arrayの小ネタでした...


(追記：2012-10-31) タイトルを変更しました。

----

{{ 4895728315 | amazon_medium_image }}
{{ 4895728315 | amazon_link }} by {{ 4895728315 | amazon_authors }}

{% footnotes %}
{% fn まあそんな設計に問題があるんですが.. %}
{% endfootnotes %}
