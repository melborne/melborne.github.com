---
layout: post
title: "Rubyで不揃いのデータを集計する"
tagline: "Enumerable#chunkの紹介"
description: ""
category: 
tags: 
date: 2013-12-26
published: true
---
{% include JB/setup %}

##─　問題　─

ブログ記事に関する次のようなテキストデータがあって、Rubyを使って年別の記事数を集計したいとします。あなたならどうしますか？

    2013
        Dec 25 Blog Post22
        Nov 10 Blog Post21
        Aug 09 Blog Post20
        Feb 06 Blog Post19
        Jun 09 Blog Post18
        Mar 11 Blog Post17
        Jan 21 Blog Post16
        Jan 02 Blog Post15
    2012
        Nov 20 Blog Post14
        Oct 09 Blog Post13
        Oct 05 Blog Post12
        Sep 15 Blog Post11
        Sep 10 Blog Post10
        Feb 02 Blog Post9
    2011
        Dec 24 Blog Post8
        Dec 03 Blog Post7
        Nov 04 Blog Post6
        Oct 12 Blog Post5
        Aug 12 Blog Post4
        Aug 02 Blog Post3
        May 11 Blog Post2
        Mar 18 Blog Post1

<br/>


##─　僕のやり方　─

一見簡単そうで、でもよく考えるとちょっと厄介そうな問題ですよね。状態遷移を管理する必要がありそうな...。

<br/>
<br/>

でも安心してください、Rubyには`Enumerable#chunk`があります！

> [instance method Enumerable#chunk](http://docs.ruby-lang.org/ja/2.0.0/method/Enumerable/i/chunk.html 'instance method Enumerable#chunk')

<br/>

{% highlight ruby %}
lines = File.readlines('blog_entries.txt')
            .map(&:strip).reject(&:empty?)

chunks = lines.chunk { |line| line.match(/^\d{4}/).nil? }

chunks.to_a # => [[false, ["2013"]], [true, ["Dec 26 Blog Post23", "Dec 25 Blog Post22", "Nov 10 Blog Post21", "Aug 09 Blog Post20", "Feb 06 Blog Post19", "Jun 09 Blog Post18", "Mar 11 Blog Post17", "Jan 21 Blog Post16", "Jan 02 Blog Post15"]], [false, ["2012"]], [true, ["Nov 20 Blog Post14", "Oct 09 Blog Post13", "Oct 05 Blog Post12", "Sep 15 Blog Post11", "Sep 10 Blog Post10", "Feb 02 Blog Post9"]], [false, ["2011"]], [true, ["Dec 24 Blog Post8", "Dec 03 Blog Post7", "Nov 04 Blog Post6", "Oct 12 Blog Post5", "Aug 12 Blog Post4", "Aug 02 Blog Post3", "May 11 Blog Post2", "Mar 18 Blog Post1"]]]
{% endhighlight %}

chunkは各lineに対するブロックの評価結果が変化（遷移）する点を監視し、その点を区切りとしてlineを複数のチャンク（塊）に分けます。ここでは年のラベルにマッチする正規表現でチャンクを分けています。

こうなればあとは簡単ですね！

{% highlight ruby %}
chunks.each_slice(2) do |(_, year), (_, entries)|
  puts "%d => %d" % [year.first, entries.size]
end

# >> 2013 => 9
# >> 2012 => 6
# >> 2011 => 8
{% endhighlight %}


ちなみにブロック内におけるマッチ結果に対するnil評価（nil?）は必須です。chunkではブロックの返り値がnilになる場合はその行をチャンクの対象外にするからです（非マッチはnilを返します）。

{% highlight ruby %}
lines = File.readlines('blog_entries.txt')
            .map(&:strip).reject(&:empty?)

chunks = lines.chunk { |line| line.match(/^\d{4}/) }

chunks.to_a # => [[#<MatchData "2013">, ["2013"]], [#<MatchData "2012">, ["2012"]], [#<MatchData "2011">, ["2011"]]]
{% endhighlight %}

併せて各月の集計もしてみます。これはEnumerable#group_byで一発です。

{% highlight ruby %}
chunks.each_slice(2) do |(_, year), (_, entries)|
  puts "%d => %d" % [year.first, entries.size]
  months = entries.group_by { |gr| gr.match(/^[A-Z][a-z]{2}/).to_s }
  puts months.map { |mon, ents| " %s: %d" % [mon, ents.size] }
end

# >> 2013 => 9
# >>  Dec: 2
# >>  Nov: 1
# >>  Aug: 1
# >>  Feb: 1
# >>  Jun: 1
# >>  Mar: 1
# >>  Jan: 2
# >> 2012 => 6
# >>  Nov: 1
# >>  Oct: 2
# >>  Sep: 2
# >>  Feb: 1
# >> 2011 => 8
# >>  Dec: 2
# >>  Nov: 1
# >>  Oct: 1
# >>  Aug: 2
# >>  May: 1
# >>  Mar: 1
{% endhighlight %}

<br/>

## このブログの記事数を集計してみる

そんなわけで...

このブログのトップページをコピペして記事数を集計してみます。

{% highlight ruby %}
lines = File.readlines('hp12c_entries.txt')
            .map(&:strip).reject(&:empty?)

chunks = lines.chunk { |line| line.match(/^\d{4}/).nil? }

chunks.each_slice(2) do |(_, year), (_, entries)|
  puts "%d => %d" % [year.first, entries.size]
  months = entries.group_by { |gr| gr.match(/^[A-Z][a-z]{2}/).to_s }
  puts months.map { |mon, ents| " %s: %d" % [mon, ents.size] }
end

# >> 2013 => 75
# >>  Dec: 7
# >>  Nov: 4
# >>  Oct: 11
# >>  Sep: 8
# >>  Aug: 7
# >>  Jun: 1
# >>  May: 3
# >>  Apr: 8
# >>  Mar: 6
# >>  Feb: 11
# >>  Jan: 9
# >> 2012 => 83
# >>  Dec: 11
# >>  Nov: 2
# >>  Oct: 10
# >>  Sep: 7
# >>  Aug: 5
# >>  Jul: 5
# >>  Jun: 8
# >>  May: 5
# >>  Apr: 6
# >>  Mar: 1
# >>  Feb: 11
# >>  Jan: 12
# >> 2011 => 60
# >>  Dec: 13
# >>  Nov: 4
# >>  Oct: 5
# >>  Sep: 4
# >>  Aug: 6
# >>  Jul: 6
# >>  Jun: 7
# >>  May: 2
# >>  Feb: 6
# >>  Jan: 7
# >> 2010 => 39
# >>  Dec: 1
# >>  Nov: 6
# >>  Oct: 2
# >>  Jul: 2
# >>  Jun: 5
# >>  May: 1
# >>  Mar: 5
# >>  Feb: 13
# >>  Jan: 4
# >> 2009 => 56
# >>  Oct: 1
# >>  Sep: 1
# >>  Aug: 1
# >>  May: 2
# >>  Apr: 20
# >>  Mar: 5
# >>  Feb: 8
# >>  Jan: 18
# >> 2008 => 41
# >>  Oct: 3
# >>  Sep: 5
# >>  Aug: 5
# >>  Jul: 1
# >>  Jun: 1
# >>  Apr: 2
# >>  Mar: 11
# >>  Feb: 9
# >>  Jan: 4
# >> 2007 => 31
# >>  Dec: 2
# >>  Nov: 2
# >>  Oct: 2
# >>  Sep: 2
# >>  Aug: 2
# >>  Jun: 3
# >>  Apr: 3
# >>  Mar: 5
# >>  Feb: 3
# >>  Jan: 7
{% endhighlight %}

うん、今年もよく書いた。

みんなもチャンクしようぜ。チャンク！チャンク！

