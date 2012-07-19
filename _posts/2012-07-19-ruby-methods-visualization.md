---
layout: post
title: "Rubyのクラスの太った人たち"
tagline: "Ruby Methods Visualization with Wordle"
description: ""
category: 
tags: [ruby, method, wordle, Visualization]
date: 2012-07-19
published: true
---
{% include JB/setup %}

前回の記事「[Ruby、君のオブジェクトはなんて呼び出せばいいの？](http://melborne.github.com/2012/07/16/ruby-methods-analysis/ 'Ruby、君のオブジェクトはなんて呼び出せばいいの？')」で、Rubyには大量のメソッドがあることが分かりました。今回はその補足として、各クラスごとのメソッド数を数えてグラフ化してみます。

## インスタンスメソッドを数える
まずは、インスタンスメソッドを数えましょう。グラフ化の対象は、10以上のメソッドを持つクラスです。最初にクラスごとのメソッド数をリストアップします。

{% highlight ruby %}
klasses = ObjectSpace.each_object(Module)

def live(methods)
  methods.reject { |m| "#{m}".start_with? '_deprecated' }
end

methods = klasses.map do |k|
  [k, live(k.methods(false)).size, live(k.instance_methods(false)).size]
end

# List of Instance Methods
ims = methods.map { |k, cm, im| [k, im] }.reject { |k, m| m < 10 }.sort_by { |k, m| -m }

puts ims.map { |kim| kim.join(" => ") }.join(", ")
{% endhighlight %}

結果は次のようになりました。
{% highlight ruby %}
String => 109, Pathname => 92, Array => 88, IO => 70, Time => 54, Hash => 53, ARGF.class => 51, Kernel => 48, Enumerable => 47, Module => 43, Float => 42, File::Stat => 42, Numeric => 41, Complex => 37, Bignum => 36, Fixnum => 34, Thread => 25, Rational => 25, Integer => 24, Symbol => 24, MatchData => 19, Range => 18, Proc => 17, Regexp => 16, Struct => 16, Method => 16, Process::Status => 15, Encoding::Converter => 14, NilClass => 12, Enumerator => 12, UnboundMethod => 12, File => 11, Dir => 11

{% endhighlight %}
なるほど、`String`のインスタンスメソッドは100を超えてるんですね！あれ、なんで`Pathname`がいるのかな...理由は分かりませんが、メソッド多いですねー。そして、`Array`, `IO`, `Time`, `Hash`と続きます。

さあ、次にこれをGoogle Chart APIでグラフ化します。
{% highlight ruby %}

x, data = ims.transpose
y = 0.step(110, 10).to_a

puts Gchart.bar(:data => data,
             :max_value => 110,
             :axis_with_labels => 't,y,x',
             :axis_labels => [y, x.reverse, y],
             :size => '390x760',
             :bar_width_and_spacing => 17,
             :title => 'Instance Methods',
             :bg => 'efefdd',
             :orientation => 'horizontal',
             )

#>> http://chart.apis.google.com/chart?chxl=0:|0|10|20|30|40|50|60|70|80|90|100|110|1:|Dir|File|UnboundMethod|Enumerator|NilClass|Encoding%3A%3AConverter|Process%3A%3AStatus|Method|Struct|Regexp|Proc|Range|MatchData|Symbol|Integer|Rational|Thread|Fixnum|Bignum|Complex|Numeric|File%3A%3AStat|Float|Module|Enumerable|Kernel|ARGF.class|Hash|Time|IO|Array|Pathname|String|2:|0|10|20|30|40|50|60|70|80|90|100|110&chxt=t,y,x&chbh=17&chf=bg,s,efefdd&chd=s:9zxnedcbaYXXXUUTOONNKKJJJJIHGGGGG&chtt=Instance+Methods&cht=bhs&chs=390x760&chxr=0,109,110

{% endhighlight %}

前回同様、[Google Chart API](https://developers.google.com/chart/ 'Google Chart Tools — Google Developers')を使って、次のグラフが得られました。

![instance methods noshadow](http://chart.apis.google.com/chart?chxl=0:|0|10|20|30|40|50|60|70|80|90|100|110|1:|Dir|File|UnboundMethod|Enumerator|NilClass|Encoding%3A%3AConverter|Process%3A%3AStatus|Method|Struct|Regexp|Proc|Range|MatchData|Symbol|Integer|Rational|Thread|Fixnum|Bignum|Complex|Numeric|File%3A%3AStat|Float|Module|Enumerable|Kernel|ARGF.class|Hash|Time|IO|Array|Pathname|String|2:|0|10|20|30|40|50|60|70|80|90|100|110&chxt=t,y,x&chbh=17&chf=bg,s,efefdd&chd=s:9zxnedcbaYXXXUUTOONNKKJJJJIHGGGGG&chtt=Instance+Methods&cht=bhs&chs=390x760&chxr=0,109,110)

個人的には、Symbolのメソッド数が少ないな、という印象です。


## クラスメソッドを数える
次に、クラスメソッドを数えましょう。グラフ化の対象は、5以上のメソッドを持つクラスです。最初にクラスごとのメソッド数をリストアップします。

{% highlight ruby %}
# List of Class Methods
cms = methods.map { |k, cm, im| [k, cm] }.reject { |k, m| m < 5 }.sort_by { |k, m| -m }

puts cms.map { |kcm| kcm.join(" => ") }.join(", ")
{% endhighlight %}

結果は次のようになりました。
{% highlight ruby %}
Gem => 89, Kernel => 59, File => 57, Process => 39, FileTest => 26, Math => 26, Dir => 16, Process::Sys => 15, IO => 15, Thread => 13, Encoding => 11, Process::UID => 9, Process::GID => 9, GC::Profiler => 7, GC => 7, Time => 7, RubyVM::InstructionSequence => 7, ObjectSpace => 6, Regexp => 6
{% endhighlight %}
`Gem`は組み込みライブラリではないので、除外すべきだったのかもしれませんが、まあ兎に角、ダントツ１位です^ ^; `Kernel`はそのメソッドがモジュール関数になっているので多いのですね。従って、実質１位は`File`と言っていいんじゃないでしょうか。


さあ、次にこれをGoogle Chart APIでグラフ化します。
{% highlight ruby %}
x, data = cms.transpose
y = 0.step(90, 10).to_a

puts Gchart.bar(:data => data,
             :max_value => 90,
             :axis_with_labels => 't,y,x',
             :axis_labels => [y, x.reverse, y],
             :size => '600x500',
             :bar_width_and_spacing => 18,
             :title => 'Class Methods',
             :bg => 'efefdd',
             :orientation => 'horizontal',
             )

#>> http://chart.apis.google.com/chart?chxl=0:|0|10|20|30|40|50|60|70|80|90|1:|Regexp|ObjectSpace|RubyVM%3A%3AInstructionSequence|Time|GC|GC%3A%3AProfiler|Process%3A%3AGID|Process%3A%3AUID|Encoding|Thread|IO|Process%3A%3ASys|Dir|Math|FileTest|Process|File|Kernel|Gem|2:|0|10|20|30|40|50|60|70|80|90&chxt=t,y,x&chbh=18&chf=bg,s,efefdd&chd=s:9onaRRLKKIHGGEEEEEE&chtt=Class+Methods&cht=bhs&chs=600x500&chxr=0,89,90

{% endhighlight %}

結果は次の通り。

![class methods noshadow](http://chart.apis.google.com/chart?chxl=0:|0|10|20|30|40|50|60|70|80|90|1:|Regexp|ObjectSpace|RubyVM%3A%3AInstructionSequence|Time|GC|GC%3A%3AProfiler|Process%3A%3AGID|Process%3A%3AUID|Encoding|Thread|IO|Process%3A%3ASys|Dir|Math|FileTest|Process|File|Kernel|Gem|2:|0|10|20|30|40|50|60|70|80|90&chxt=t,y,x&chbh=18&chf=bg,s,efefdd&chd=s:9onaRRLKKIHGGEEEEEE&chtt=Class+Methods&cht=bhs&chs=600x500&chxr=0,89,90)

５以下のメソッドを削ってますが、ロングテールといった感じでしょうか。まあ、あまり感想はありません..

## Wordleによるビジュアライゼーション
さて、実は今回はここからが本題です。

クラスごとにメソッドをグラフ化しても面白みがないことが分かったので、以前に紹介した[Wordle - Beautiful Word Clouds](http://www.wordle.net/ 'Wordle - Beautiful Word Clouds')を使って、Rubyのクラスごとのメソッド数をビジュアライズしてみたいと思います。Wordleはテキスト中の単語をその出現頻度から重み付けしてサイズを決定し、グラフィカルに配置して表示するツール／サービスです。このブログでも以前に２回ほど紹介しました。

> [Rubyで英文小説をWordleしようよ](http://melborne.github.com/2011/12/12/Ruby-Wordle/ 'Rubyで英文小説をWordleしようよ')
> 
> [Wordleでビジネスカードを作ろう!](http://melborne.github.com/2011/12/18/Wordle/ 'Wordleでビジネスカードを作ろう!')
> 

Wordleではテキストを渡して画像を生成させるのが基本ですが、単語とその重み付けの情報を渡して画像を生成する方法も提供されています。今回はこれを使って、Rubyにおける各クラス名をそのメソッド数で重み付けして画像を生成してみたいと思います。

まずは重み付けの情報を作ります。インスタンスメソッドから。
{% highlight ruby %}
# Instance methods for Wordle
puts ims.map { |k, m| "#{k}:#{m}" }
{% endhighlight %}

次のようなデータが得られます。
{% highlight ruby %}
String:109
Pathname:92
Array:88
IO:70
Time:54
Hash:53
ARGF.class:51
Kernel:48
Enumerable:47
Module:43
Float:42
File::Stat:42
Numeric:41
Complex:37
Bignum:36
Fixnum:34
Thread:25
Rational:25
Integer:24
Symbol:24
MatchData:19
Range:18
Proc:17
Regexp:16
Struct:16
Method:16
Process::Status:15
Encoding::Converter:14
NilClass:12
Enumerator:12
UnboundMethod:12
File:11
Dir:11
{% endhighlight %}

クラスメソッドも同様にします。
{% highlight ruby %}
# Class methods for Wordle
puts cms.map { |k, m| "#{k}:#{m}" }
{% endhighlight %}

出力です。
{% highlight ruby %}
Gem:89
Kernel:59
File:57
Process:39
FileTest:26
Math:26
Dir:16
Process::Sys:15
IO:15
Thread:13
Encoding:11
Process::UID:9
Process::GID:9
GC::Profiler:7
GC:7
Time:7
RubyVM::InstructionSequence:7
ObjectSpace:6
Regexp:6
{% endhighlight %}

Wordleの`Advanced`タブを開いて、`Paste weighted words or phrases here:`に出力データを貼り付けます。そしてGoボタンを押せば自動でWordle画像が生成されます。後は、Randomizeボタンを押すなり、そのFont, Layout, Colorを変更するなりして、お好みを作り上げます。


こうして生成された画像が以下になります。

Ruby Classes emphasized with Number of Instance Methods

![instance methods noshadow]({{ site.url }}/assets/images/ruby_instance_methods.png)

Ruby Classes emphasized with Number of Class Methods

![Alt title noshadow noshadow]({{ site.url }}/assets/images/ruby_class_methods.png)

Cool！なかなかカッコイイでしょ？

時間が許すなら、みなさんもこのブログのデータをコピーして、Wordleしてみてください。楽しめると思います。

というわけで、Ruby大学におきましては、Stringクラスの生徒(Class Mates)たちと、新人先生Gem君が太ってるってことが分かりましたよ！


[Ruby Methods Analysis — Gist](https://gist.github.com/3121898#file_methods_by_class.rb 'Ruby Methods Analysis — Gist')

----

<a href="http://www.wordle.net/show/wrdl/5511105/Ruby_Instance_Methods" title="Wordle: Ruby Instance Methods"><img src="http://www.wordle.net/thumb/wrdl/5511105/Ruby_Instance_Methods" alt="Wordle: Ruby Instance Methods noshadow" style="padding:4px;border:1px solid #ddd"></a>

<a href="http://www.wordle.net/show/wrdl/5511131/Ruby_Class_Methods" title="Wordle: Ruby Class Methods"><img src="http://www.wordle.net/thumb/wrdl/5511131/Ruby_Class_Methods" alt="Wordle: Ruby Class Methods noshadow" style="padding:4px;border:1px solid #ddd"></a>


----

{{ 4750329665 | amazon_medium_image }}
{{ 4750329665 | amazon_link }} by {{ 4750329665 | amazon_authors }}

