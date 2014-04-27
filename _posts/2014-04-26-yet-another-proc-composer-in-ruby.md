---
layout: post
title: "RubyにおけるYet Another関数合成"
description: ""
category: 
tags: 
date: 2014-04-26
published: true
---
{% include JB/setup %}

Rubyにおける本格的な関数合成については、既に@yuroyoroさんの[lambda_driver.gem](https://rubygems.org/gems/lambda_driver "lambda_driver") があるので、僕の出番はありませんが。まあいつもの様にふざけたものなら出せますよ、ということで...。

## ProcCompressor

こういった実装です。

{% gist 11316775 proc_compressor.rb %}

## 使い方

使い方はこうです。

最初に圧縮するProcの数を決めてインスタンスを生成し、これに`ProcCompressor#<<`でProcオブジェクトを順次圧縮していきます。

{% highlight ruby %}
pc = ProcCompressor.new(2)

pc << ->n{ n * 2 } << ->n{ n + 5 }
{% endhighlight %}

で、最後に値を同じく`#<<`を使って投げれば、結果が得られます。

{% highlight ruby %}
pc << 3 # => 11
{% endhighlight %}

Procのセットも結果の取得も、同じ`#<<`メソッドで達成できるところがアピールポイントです（何の価値があるかわかりませんが）。同じ入口に計算要素をどんどんpushしていくと最後に結果がpopするというイメージです。これはinjectでProcを畳み込んで、`Proc#curry`に引数を渡すことでこれが駆動するようにして実現しています。

`#to_proc`も定義してあるので、&引数として渡すこともできます。

{% highlight ruby %}
pc = ProcCompressor.new(2)

pc << ->n{ n * 2 } << ->n{ n + 5 }

[1, 2, 3, 4, 5].map(&pc) # => [7, 9, 11, 13, 15]


pc = ProcCompressor.new(3)

pc << :to_s.to_proc << ->s{ s + 'ist' } << :upcase.to_proc

[:ruby, :violin, :novel].map(&pc) # => ["RUBYIST", "VIOLINIST", "NOVELIST"]


pc = ProcCompressor.new(1)

between5to10 = ->n{ n.between? 5, 10 }

pc << between5to10

[*1..15].select(&pc) # => [5, 6, 7, 8, 9, 10]
{% endhighlight %}


ちょっとユニークでしょ？

---

参考記事：

> [Rubyで関数合成とかしたいので lambda_driver.gem というのを作った - ( ꒪⌓꒪) ゆるよろ日記](http://yuroyoro.hatenablog.com/entry/2013/03/27/190640 "Rubyで関数合成とかしたいので lambda_driver.gem というのを作った - ( ꒪⌓꒪) ゆるよろ日記")

関連記事：

> [落ちていくRubyistのためのMethopオブジェクト](http://melborne.github.io/2014/04/20/extend-ampersand-magic-with-methop/ "落ちていくRubyistのためのMethopオブジェクト")

---

(追記：2014-4-27) 説明とコードを少し追加しました。

---

<p style='color:red'>=== Ruby関連電子書籍100円〜で好評発売中！ ===</p>

[M'ELBORNE BOOKS]({{ BASE_PATH }}/books/ "M'ELBORNE BOOKS")

<a href="{{ BASE_PATH }}/books/">
  <img src="/assets/images/books/ruby_pack8.png" alt="pack8" style="width:200px" />
</a>
<a href="{{ BASE_PATH }}/books/">
  <img src="/assets/images/books/rack_cover.png" alt="rack" style="width:200px" />
</a>
<a href="{{ BASE_PATH }}/books/">
  <img src="/assets/images/books/ruby_parallel_cover.png" alt="ruby_parallel" style="width:200px" />
</a>

