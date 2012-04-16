---
layout: post
title: RubyでExcel列名変換問題を解いて上司に対抗しよう!
date: 2011-12-29
comments: true
categories:
tags: [ruby]
---

社内でFizzBuzz問題のコンテストをしたらあまり出来がよくなかったという記事があって、以前その問題をRubyで解いた投稿をしたよ。

[RubyでFizzBuzz問題を解いて上司に対抗しよう!]({{ site.url }}/2011/10/09/Ruby-FizzBuzz/)

[FizzBuzz問題を使って社内プログラミングコンテストを開催してみた - ITは芸術だ](http://d.hatena.ne.jp/JunichiIto/20111007/1317976730#20111007f1)

で、その元記事の人によれば第２回目の社内プログラミングコンテストが開催されたらしいんだ。

[Excel列名変換問題で第２回社内プログラミングコンテストを開催してみた(前編) - ITは芸術だ](http://d.hatena.ne.jp/JunichiIto/20111102/1320253815)

今度はFizzBuzz問題よりも難易度の高いExcel列名変換問題が2題出題されたよ。詳細は元記事をみて欲しいけど、簡単に言うとExcelのアルファベットの列名を数字に変換するものと、その逆変換をするものだよ。例えば「AA」は27に「XFD」は16384になるよ。

少し前の投稿で僕はRubyでは何でも作れて、ロシアンルーレットのためのメソッドまで予め用意されているって紹介したよ{% fn_ref 1 %}。

[RubyのRSpecでリボルバーを作ってロシアンルーレットしようよ!]({{ site.url }}/2011/12/18/Ruby-RSpec/)

だから当然にRubyにはExcelのためのメソッドもあって、それらを使えば先の問題は簡単に解けちゃうんだよ:)
{% highlight ruby %}
def alpha2num(alphabets)
 [*'A'..alphabets].size
end
def num2alpha(number)
 alpha = 'A'
 (number-1).times { alpha.succ! }
 alpha
end
alphabets = %w(A B Z AA AB AZ BB AAA IV ZZZ XFD)
numbers = alphabets.map { |alpha| alpha2num alpha }
  # => [1, 2, 26, 27, 28, 52, 54, 703, 256, 18278, 16384]
numbers.map { |num| num2alpha num }
  # => ["A", "B", "Z", "AA", "AB", "AZ", "BB", "AAA", "IV", "ZZZ", "XFD"]
{% endhighlight %}

つまりRubyではアルファベットは順位が決まった比較可能なオブジェクトで、「Z」の次は「AA」で「ZZ」の次は「AAA」になるよう設計されているんだ。ちょっと速度上の問題はあるかもしれないけどね。

でもなんかこれで解けたっていうのはずるっぽい感じがするから、僕も上司に恥をかかされないように勉強中のrspecを使ってまじめに解いたから、ここに貼っておくよ。

<script src="https://gist.github.com/1534213.js"> </script>
{% footnotes %}
   {% fn Array#rotate! #shuffle #cycleのことです^ ^; %}
{% endfootnotes %}

