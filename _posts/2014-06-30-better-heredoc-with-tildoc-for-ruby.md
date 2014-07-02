---
layout: post
title: "チリドッグでRubyのヒアドキュメントを良くしよう！"
tagline: "Introduce Tildoc gem for better heredocs"
description: ""
category: 
tags: 
date: 2014-06-30
published: true
---
{% include JB/setup %}

プロジェクト本体でヒアドキュメントを使うことはそんなに多くはないんですが、これがテストでは意外と使われるということがわかってきまして。そうすると、どうしてもこの醜さには耐え難いものがあるんです。

{% highlight ruby %}
describe ATool::CLI do
  before do
    @expected = <<-EOS
Hello, Ruby!
I'm Here with Dog!
Where are You?
    EOS
  end
...
end
{% endhighlight %}

Pythonistaでなくともこの飛び出ちゃった感じはちょっとねぇ。

で、随分以前に先頭空白を除去するコードを`String#~`に割り当てるという荒業を考えまして。

{% highlight ruby %}
class String
  def ~
    margin = scan(/^ +/).map(&:size).min
    gsub(/^ {#{margin}}/, '')
  end
end
{% endhighlight %}

> [チルダがRubyのヒアドキュメントをもっと良くする](http://melborne.github.io/2012/04/27/ruby-heredoc-without-leading-whitespace/ "チルダがRubyのヒアドキュメントをもっと良くする")

このコードを`spec_helper`当たりに差しておくと、ヒアドキュメントの`<<`の前に`~`（チルダ）を入れるだけで、平和がやって来ます。

{% highlight ruby %}
describe ATool::CLI do
  before(:all) do
    @expected = ~<<-EOS
      Hello, Ruby!
      I'm Here with Dog!
      Where are You?
    EOS
  end
...
end
{% endhighlight %}

で、毎回、先の記事を開いてコードをhelperにコピペするという作業をしていたのですが、それも骨が折れます。

そんなわけで...。

またチンピラGemを一つ増やしました。

> [tildoc](https://rubygems.org/gems/tildoc "tildoc")
> 
> [melborne/tildoc](https://github.com/melborne/tildoc "melborne/tildoc")

`tilde + heredoc = tildoc`です😅

<br/>

{% highlight ruby %}
#gemspec
  spec.add_development_dependency "tildoc"
{% endhighlight %}

とか

{% highlight ruby %}
#Gemfile
group :development, :test do
  gem "tildoc"
end
{% endhighlight %}

とすれば幸せになれるかもしれません。ActiveSupportの`String#strip_heredoc`やHomebrewの`String#undent`と等価なものですが、`EOS`（開始ラベル）の後ろにこれらメソッド名書くのどうなのと思っている人に。

そういえばこれ前に、Featureリスエストも出してみたんですけど、やっぱり採用には至りませんでした...。

> [Feature #6801: String#~ for a here document - ruby-trunk - Ruby Issue Tracking System](https://bugs.ruby-lang.org/issues/6801#change-28490 "Feature #6801: String#~ for a here document - ruby-trunk - Ruby Issue Tracking System")


