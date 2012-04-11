---
layout: post
title: RubyのGsubチェーンはイケてない? ~ GsubFilterの紹介
description: ""
category: 
tags: []
---
{% include JB/setup %}

任意のテキストに対して複数の置換を実行したい、ってときあるよね。そんなときRubyでは普通、String#subあるいは#gsubメソッドをチェーンするよ。

{% highlight ruby %}
def replace(text)
  text.gsub(/\w+/) { |m| m.capitalize }
      .sub(/ruby/i) { |m| "*#{m}*" } 
      .gsub(/a(.)/) { "a-#{$1}" }
end

text =<<EOS
ruby is a fantastic language!
I love ruby.
EOS

puts replace(text)

# >> *Ruby* Is A Fa-nta-stic La-ngua-ge!
# >> I Love Ruby.
{% endhighlight %}

でもこのやり方には次のような問題があるよ。

1. 置換の数が多くなると、コードが読みづらくなる。
2. 置換の条件がメソッドにハードコードされているので、後から条件を変えたり追加したりできない。

ちょうど今書いてるコードで単一のテキストに対して14もの置換が必要になったから、上の問題が気になったんだよ。


そんなわけで...

上記問題を解消するGsubFilterというクラスを書いてみたよ!


GsubFilterは次のように、複数のfilterを登録してからrunで置換を実行するよ。

{% highlight ruby %}
require "gsub_filter"

gs = GsubFilter.new("ruby is a fantastic language!\nI love ruby.")

# 各単語をキャピタライズする。
gs.filter(/\w+/) {|md| md.to_s.capitalize }

# 最初の'ruby'だけにアスタリスクを付ける。
gs.filter(/ruby/i, global:false) { |md| "*#{md.to_s}*" }

# MatchDataオブジェクトがブロックの第1引数として渡される。
gs.filter(/a(.)/) { |md| "a-#{md[1]}" }

# runメソッドでこれらのフィルタを実行する。
gs.run # => "*Ruby* Is A Fa-nta-stic La-ngua-ge!\nI Love Ruby."
{% endhighlight %}


GsubFilter#runは、他のテキストを先のフィルタのために取ることができるよ。

{% highlight ruby %}
gs.run("hello, world of ruby!") # => "Hello, World Of *Ruby*!"
{% endhighlight %}


GsubFilter#replaceを使えば各フィルタをあとから交換できるよ。

{% highlight ruby %}
gs.replace(1, /ruby/i) { |md| "###{md.to_s}##" }

gs.run # => "##Ruby## Is A Fa-nta-stic La-ngua-ge!\nI Love ##Ruby##."
{% endhighlight %}

またMatchDataオブジェクトはフィルタブロックの第2引数を通してストックできて、これはGsubFilter#stocksで後からアクセスできるんだ。

{% highlight ruby %}
gs.filter(/#(\w+)#/) { |md, stocks| stocks[:lang] << md[1]; "+#{md[1]}+" }

gs.run # => "#+Ruby+# Is A Fa-nta-stic La-ngua-ge!\nI Love #+Ruby+#."
gs.stocks # => {:lang=>["Ruby", "Ruby"]}
{% endhighlight %}


まあ需要があるとは思えないけどいままでgemを作ったことがなかったから、勉強を兼ねてこのクラスをgem化してみたよ! gem i gsub_filterでインストールできるから暇つぶしに遊んでくれたらうれしいよ。


https://rubygems.org/gems/gsub_filter

{% gist 2177656 %}
