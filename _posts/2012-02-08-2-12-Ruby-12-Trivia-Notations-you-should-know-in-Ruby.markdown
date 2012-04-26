---
layout: post
title: 第2弾!知って得する12のRubyのトリビアな記法
tagline: 12 Trivia Notations you should know in Ruby
date: 2012-02-08
comments: true
categories:
tags: [ruby, tips]
---

半年くらい前にちょっとトリビアだけど、知っていると意外と便利なRubyの記法を21個紹介したよ。

[知って得する21のRubyのトリビアな記法 ~ 21 Trivia Notations you should know in Ruby]({{ site.url }}/2011/06/22/21-Ruby-21-Trivia-Notations-you-should-know-in-Ruby/)

今回はその第2弾だよ!

ちょっと数が少ないけど、知らないものがあったらへーとかほーとか、得したとか言ってもらえるとうれしいよ。

##1.Enumerator#with_index
任意のリストを標準出力するときに連番を同時に振るとしたら、普通はEnumerable#each_with_indexを使うよね。
{% highlight ruby %}
names = Module.constants.take(10)
names.each_with_index { |name, i| puts "%d: %s" % [i+1, name] } # => [:Object, :Module, :Class, :Kernel, :NilClass, :NIL, :Data, :TrueClass, :TRUE, :FalseClass]
# >> 1: Object
# >> 2: Module
# >> 3: Class
# >> 4: Kernel
# >> 5: NilClass
# >> 6: NIL
# >> 7: Data
# >> 8: TrueClass
# >> 9: TRUE
# >> 10: FalseClass
{% endhighlight %}


でも'i+1'ってのがイマイチ..って人いる？そんな人にはEnumerator#with_indexがあるよ。
{% highlight ruby %}
names = Module.constants.take(10)
names.each.with_index(1) { |name, i| puts "%d: %s" % [i, name] } # => [:Object, :Module, :Class, :Kernel, :NilClass, :NIL, :Data, :TrueClass, :TRUE, :FalseClass]
# >> 1: Object
# >> 2: Module
# >> 3: Class
# >> 4: Kernel
# >> 5: NilClass
# >> 6: NIL
# >> 7: Data
# >> 8: TrueClass
# >> 9: TRUE
# >> 10: FalseClass
{% endhighlight %}

with_indexはindexのoffsetを引数に取れるよ。comparableなオブジェクトが取れたらもっとよかったのにね。

##2.Integer#times
timesは処理を特定回数だけ繰り返したいときに使うよね。
{% highlight ruby %}
you_said = 'てぶくろ'
6.times { puts you_said.reverse! } # => 6
# >> ろくぶて
# >> てぶくろ
# >> ろくぶて
# >> てぶくろ
# >> ろくぶて
# >> てぶくろ
{% endhighlight %}


timesはブロックを渡さないとEnumeratorを返すよ。だから複数のオブジェクトを生成するようなことにも使えるんだよ。20個のRGBカラーサンプルを作ってみるよ。
{% highlight ruby %}
20.times.map { [rand(256), rand(256), rand(256)] } # => [[45, 190, 194], [94, 43, 125], [6, 104, 181], [144, 92, 114], [34, 161, 214], [96, 69, 241], [216, 246, 133], [6, 237, 131], [194, 95, 214], [177, 252, 202], [184, 149, 142], [184, 166, 45], [41, 108, 115], [176, 100, 138], [124, 213, 89], [173, 123, 34], [137, 31, 47], [54, 92, 186], [118, 239, 217], [150, 184, 240]]
{% endhighlight %}

##3.String#succ / Integer#succ
ExcelのAから始まる横のラベルを作りたいんだけどどうする？って問題が最近あったよ。RubyにはString#succまたはnextがあるからこれは簡単だよ。
{% highlight ruby %}
col = '@'
60.times.map { col = col.succ } # => ["A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z", "AA", "AB", "AC", "AD", "AE", "AF", "AG", "AH", "AI", "AJ", "AK", "AL", "AM", "AN", "AO", "AP", "AQ", "AR", "AS", "AT", "AU", "AV", "AW", "AX", "AY", "AZ", "BA", "BB", "BC", "BD", "BE", "BF", "BG", "BH"]
{% endhighlight %}

##4.Comparable.between?
値が一定範囲内にあるかどうかで処理を切り分けたいことってあるよね？たぶん普通はこうするよ。
{% highlight ruby %}
pos = 48
status =
  if 0 <= pos && pos <= 50
    :you_are_in
  else
    :you_are_out
  end
status # => :you_are_in
{% endhighlight %}
でCoffeeScriptを見て悔しがるんだよね。でも安心していいよ、Rubyにはbetween?があるんだから。
{% highlight ruby %}
pos = 48
status =
  if pos.between?(0, 50)
    :you_are_in
  else
    :you_are_out
  end
status # => :you_are_in

pos = 'D'
grade =
  if pos.between?('A', 'C')
    :you_are_good!
  else
    :try_again!
  end
grade # => :try_again!
{% endhighlight %}


もっとも僕はcase派ですが..
{% highlight ruby %}
pos = 48
status =
  case pos
  when 0..50
    :you_are_in
  else
    :you_are_out
  end
status # => :you_are_in
{% endhighlight %}

##5.Array#uniq
配列の全要素が同じかどうかを調べたいときはどうする？そんなときはArray#uniqが使えるよ。
{% highlight ruby %}
[1, 1, 1, 1, 1, 1, 1, 1, 1, 1].uniq.size==1 # => true
[1, 1, 1, 1, 1, 1, 1, 2, 1, 1].uniq.size==1 # => false
%w(street retest setter tester).uniq { |w| w.chars.sort }.size==1 # => true
{% endhighlight %}

##6.BasicObject#instance_eval
instance_evalはオブジェクトの生成をDSL風にするときに良く使われているよね。
{% highlight ruby %}
class Person
  def initialize(&blk)
    instance_eval(&blk)
  end
  def name(name)
    @name = name
  end
  def age(age)
    @age = age
  end
  def job(job)
    @job = job
  end
  def profile
    [@name, @age, @job] * '-'
  end
end
t = Person.new do
  name 'Charlie'
  age  13
  job  :programmer
end
t.profile # => "Charlie-13-programmer"
{% endhighlight %}
でも、このコンテキストを一時的に切り替えるって機能はDSL以外でも便利に使えるんだ。例えばテストの結果の平均値を求めてみるよ。普通はこう書くよね。
{% highlight ruby %}
scores = [56, 87, 49, 75, 90, 63, 65]
scores.inject(:+) / scores.size # => 69
{% endhighlight %}
短いコードで変数scoresが3回も..

instance_evalを使うと、scoreを消すことができるんだ。
{% highlight ruby %}
[56, 87, 49, 75, 90, 63, 65].instance_eval { inject(:+) / size } # => 69
{% endhighlight %}


さらに標準偏差sdを求めるよ。まず普通に。
{% highlight ruby %}
scores = [56, 87, 49, 75, 90, 63, 65]
avg = scores.inject(:+) / scores.size
sigmas = scores.map { |n| (avg - n)**2 }
sd = Math.sqrt(sigmas.inject(:+) / scores.size) # => 14.247806848775006
{% endhighlight %}
instance_evalで
{% highlight ruby %}
scores = [56, 87, 49, 75, 90, 63, 65]
sd = scores.instance_eval do
  avg = inject(:+) / size
  sigmas = map { |n| (avg - n)**2 }
  Math.sqrt(sigmas.inject(:+) / size)
end
sd # => 14.247806848775006
{% endhighlight %}
中間的な変数をブロック内に閉じ込められるし、ブロックで式がまとまって見やすくない？

##7.Array#first/last
Array#first/lastは個数の引数を取れるよ。
{% highlight ruby %}
[*1..100].instance_eval { first(5) + last(5) } # => [1, 2, 3, 4, 5, 96, 97, 98, 99, 100]
{% endhighlight %}

##8.正規表現:名前付き参照
正規表現中で()を使うと部分マッチを捕捉できるよね。で、それに名前を付けたいときは?\<pattern\>を使えばいいよ。
{% highlight ruby %}
langs = "python lisp ruby haskell erlang scala"
m = langs.match(/(?<lang>\w+)/) # => #<MatchData "python" lang:"python">
m['lang'] # => "python"
{% endhighlight %}

で、正規表現リテラルを左辺にした場合はこれをローカル変数として持ち出せるんだよ。
{% highlight ruby %}
langs = "python lisp ruby haskell erlang scala"
if /(?<most_fun_lang>r\w+)/ =~ langs
  printf "you should learn %s!", most_fun_lang
end
# >> you should learn ruby!
{% endhighlight %}
って、正規表現てトリビアだらけだからこんなこと言ってもしょうがないか..

##9.正規表現:POSIXブラケット
Ruby1.9では\wは日本語にマッチしなくなったよね。だから1.9で日本語にもマッチさせたいときはPOSIXブラケットでwordを使うといいかもね。
{% highlight ruby %}
need_japanese = "this-日本語*is*_really_/\\変わってる!"
need_japanese.scan(/\w+/) # => ["this", "is", "_really_"]
need_japanese.scan(/[[:word:]]+/) # => ["this", "日本語", "is", "_really_", "変わってる"]
{% endhighlight %}

##10.String#match
もう一つ正規表現を^ ^;
String#matchはMatchDataオブジェクトを返すから次のように使えるよね。
{% highlight ruby %}
date = "2012february14"
m = date.match(/\D+/)
mon, day, year = m.to_s.capitalize, m.post_match, m.pre_match
"#{mon} #{day}, #{year}" # => "February 14, 2012"
{% endhighlight %}

でもmatchはブロックを取れるので、次のようにしてもいいよ。
{% highlight ruby %}
date = "2012february14"
mon, day, year = date.match(/\D+/) { |m| [m.to_s.capitalize, m.post_match, m.pre_match] }
"#{mon} #{day}, #{year}" # => "February 14, 2012"
{% endhighlight %}

##11.String#unpack
数字列を決まった長さ基準で区切りたいときはどうする？正規表現を使うのかな。
{% highlight ruby %}
a_day = '20120214'
a_day.match(/(.{4})(.{2})(.{2})/).captures # => ["2012", "02", "14"]
{% endhighlight %}
String#unpackを使うともっと簡単かもね。{% fn_ref 1 %}
{% highlight ruby %}
a_day = '20120214'
a_day.unpack('A4A2A2') # => ["2012", "02", "14"]
{% endhighlight %}

##12.DATA.rewind
DATAは\_\_END\_\_以降をFileとしたオブジェクトだよ。だからrewindクラスメソッドが使えるんだけど、これは\_\_END\_\_の最初の行に戻るんじゃなくてファイルのトップに戻るんだよ。だからこれを使えば、なんちゃってQuineができるんだ。
{% highlight ruby %}
#!/usr/bin/env ruby
require "g"
def evaluate(str)
  op = %w(\+ \* \/)
  digit = /-*\d+/
  if m = str.match(/(#{op})\s+(#{digit})\s+(#{digit})/)
    op, a, b = m.captures
    inner = a.to_i.send(op, b.to_i)
    str = m.pre_match + inner.to_s + m.post_match
    evaluate(str)
  else
    str
  end
end
g evaluate("+ * 3 4 5")
DATA.rewind
puts DATA.to_a
__END__
{% endhighlight %}
このコードを実行すると、evaluateの結果がgrowl出力されると共に、このコード自身が標準出力されるよ。

今回はこれで終わりだよ

ほんとは21個溜めてから出したかったんだけど、今朝Peter Cooperさんのビデオを見てたら、同じトリビアが出てたから慌てて出してるんだよ^ ^;

[Ruby Trick Shots: A Video of 24 Ruby Tips and Tricks](http://rubyreloaded.com/trickshots/)


{{ 4873113946 | amazon_medium_image }}
{{ 4873113946 | amazon_link }}


(追記:2012-04-26) 第３弾を書きました。

[第３弾！知って得する12のRubyのトリビアな記法](http://melborne.github.com/2012/04/26/ruby-trivias-you-should-know/ '第３弾！知って得する12のRubyのトリビアな記法')

{% footnotes %}
   {% fn @no6vさんより https://twitter.com/no6v/statuses/104161174823780352 %}
{% endfootnotes %}
