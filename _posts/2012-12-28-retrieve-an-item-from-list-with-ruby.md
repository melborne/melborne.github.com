---
layout: post
title: "Rubyで配列から要素を１つ取り出す良い方法はありませんか？"
description: ""
category: 
tags: 
date: 2012-12-28
published: true
---
{% include JB/setup %}

##─　問題　─

> 次のファイルリストから`gemspec`ファイルだけを抜き出し、それをgemspec変数で、残りをfiles変数でアクセスできるようにする簡単な方法を示しなさい。但し、gemspecのファイル名はプロジェクトによって変わりうることを考慮しなさい。

{% highlight ruby %}
files = ['Gemfile', 'LICENSE.txt', 'README.md', 'Rakefile', 'bin', 'lib', 'maliq.gemspec', 'pkg', 'spec']
{% endhighlight %}

<br />

<br />

##─　僕の通った道　─

### Array#deleteを使ってみる

{% highlight ruby %}
files = ['Gemfile', 'LICENSE.txt', 'README.md', 'Rakefile', 'bin', 'lib', 'maliq.gemspec', 'pkg', 'spec']

gemspec = files.delete('maliq.gemspec')
gemspec # => "maliq.gemspec"
files # => ["Gemfile", "LICENSE.txt", "README.md", "Rakefile", "bin", "lib", "pkg", "spec"]
{% endhighlight %}

gemspecのファイル名が固定ならこれで終わりだけど、もちろんこれは問の但し書き条件を満たしていないよ。だから`Array#delete`が、
{% highlight ruby %}
gemspec = files.delete('*.gemspec')
gemspec = files.delete(/\.gemspec$/)
{% endhighlight %}
みたいにワイルドカードを取れたり、正規表現を取れたりできればよかったんだけど、残念ながらdeleteの引数は`==`同値判定っきりなんだよ。

### Array#delete_ifまたはreject!

deleteが駄目だってんなら、次は`Array#delete_if`または`Array#reject!`だよね。

{% highlight ruby %}
files = ['Gemfile', 'LICENSE.txt', 'README.md', 'Rakefile', 'bin', 'lib', 'maliq.gemspec', 'pkg', 'spec']

gemspec = files.delete_if { |f| f.match(/\.gemspec$/) }
gemspec # => ["Gemfile", "LICENSE.txt", "README.md", "Rakefile", "bin", "lib", "pkg", "spec"]
files # => ["Gemfile", "LICENSE.txt", "README.md", "Rakefile", "bin", "lib", "pkg", "spec"]

gemspec = files.reject! { |f| f.match(/\.gemspec$/) }
gemspec # => ["Gemfile", "LICENSE.txt", "README.md", "Rakefile", "bin", "lib", "pkg", "spec"]
files # => ["Gemfile", "LICENSE.txt", "README.md", "Rakefile", "bin", "lib", "pkg", "spec"]
{% endhighlight %}

ところが残念なことに、delete_ifは常にselfを返すんだよ。つまりヒットしたgemspecファイルを完全に捨て去っちゃうんだよ。

ところで、delete_ifとreject!ではヒットしないときの返り値が違うって知ってた？前者はselfが後者はnilが返るんだって。
{% highlight ruby %}
files = ['Gemfile', 'LICENSE.txt', 'README.md', 'Rakefile', 'bin', 'lib', 'maliq.gemspec', 'pkg', 'spec']

gemspec = files.delete_if { |f| f.match(/\.rb$/) }
gemspec # => ["Gemfile", "LICENSE.txt", "README.md", "Rakefile", "bin", "lib", "maliq.gemspec", "pkg", "spec"]
gemspec = files.reject! { |f| f.match(/\.rb$/) }
gemspec # => nil
{% endhighlight %}

nilが返るならその整合性としてヒットしたときはそれを返してくれてもと思うのは僕だけかな？

### Enumerable#detectまたはfind

次は`Enumerable#detect`を試してみるよ。

{% highlight ruby %}
files = ['Gemfile', 'LICENSE.txt', 'README.md', 'Rakefile', 'bin', 'lib', 'maliq.gemspec', 'pkg', 'spec']

gemspec = files.detect { |f| f.match(/\.gemspec$/) } # => "maliq.gemspec"
gemspec # => "maliq.gemspec"
files # => ["Gemfile", "LICENSE.txt", "README.md", "Rakefile", "bin", "lib", "maliq.gemspec", "pkg", "spec"]
{% endhighlight %}

filesにgemspecファイルが残っちゃうから、これはもちろん駄目だよね。


### Enumerable#partition

次に辿り着いたのは`Enumerable#partition`だよ。partitionはブロック指定条件で集合を２つのグループに分けてくれるメソッドだよ。

{% highlight ruby %}
files = ['Gemfile', 'LICENSE.txt', 'README.md', 'Rakefile', 'bin', 'lib', 'maliq.gemspec', 'pkg', 'spec']

gemspec, files = files.partition { |f| f.match(/\.gemspec$/) }
gemspec # => ["maliq.gemspec"]
files # => ["Gemfile", "LICENSE.txt", "README.md", "Rakefile", "bin", "lib", "pkg", "spec"]
{% endhighlight %}

惜しい！gemspec変数には配列が入るから最終的には次のようにする必要があるよ。

{% highlight ruby %}
gemspecs, files = files.partition { |f| f.match(/\.gemspec$/) }
gemspec = gemspecs.first
gemspec # => "maliq.gemspec"
files # => ["Gemfile", "LICENSE.txt", "README.md", "Rakefile", "bin", "lib", "pkg", "spec"]
{% endhighlight %}

なんかスマートじゃないよね。

### Enumerable#partition + 括弧付き多重代入

で、Rubyの多重代入をちょっと工夫してみたんだよ。カッコを付けてね。

{% highlight ruby %}
files = ['Gemfile', 'LICENSE.txt', 'README.md', 'Rakefile', 'bin', 'lib', 'maliq.gemspec', 'pkg', 'spec']

(gemspec, *_), files = files.partition { |f| f.match(/\.gemspec$/) }
gemspec # => "maliq.gemspec"
files # => ["Gemfile", "LICENSE.txt", "README.md", "Rakefile", "bin", "lib", "pkg", "spec"]
{% endhighlight %}

括弧を使うと、partitionの返り値の第一配列が展開されてその先頭要素をgemspecに上手く取れるんだ。

どう、カッコイイ？それとも分かりづらい？

これが僕の回答だけど、もっとスマートなやり方があったら教えてね。


---

{{ 'B006OFA654' | amazon_medium_image }}
{{ 'B006OFA654' | amazon_link }}


