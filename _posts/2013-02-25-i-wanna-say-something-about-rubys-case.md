---
layout: post
title: "Rubyのcaseを〇〇(言語名)のswitch文だと思っている人たちにぼくから一言ガツンと申し上げたい"
description: ""
category: 
tags: 
date: 2013-02-25
published: true
---
{% include JB/setup %}

「Rubyのcase」を一瞥し「あー要は〇〇(言語名)のswitchね」などと早合点し、その後もその真の価値を知ることなく一生を終えるプログラマが近年跡を絶たない。加えて、「今更条件分岐？RubyはOOPなんだからポリモフィズムじゃね？」とか「HashにProc突っ込んでcallするのがオレ流。」とかうそぶく人たちもまた増加の一途を辿っている。

そんな世の中にあって、ぼくは一言、できればガツンと一言申し上げたい。生まれも育ちもRubyなぼくから、是非ともそんな人たちに「Rubyのcase」について一言申し上げておきたい。





<br />


##─ 問題１ ─

> 名前`name`、レベル`level`、ポイント`point`の各属性を持った複数のCharacterオブジェクトcharlie, liz, benがある。

{% highlight ruby %}
class Character < Struct.new(:name, :level, :point)
  def to_s
    "%s:\tlv:%d\tpt:%d" % values
  end
end

charlie = Character.new('Charlie', 5, 0)
liz = Character.new('Liz', 3, 0)
ben = Character.new('Ben', 8, 0)

charas = [charlie, liz, ben]

puts charas

# >> Charlie:	lv:5	pt:0
# >> Liz:	lv:3	pt:0
# >> Ben:	lv:8	pt:0
{% endhighlight %}

> キャラクタのレベルに応じてポイントを加算する`bonus_point`メソッドを実装せよ。但し、キャラクタレベルがlow(1〜3)のときは10ポイント、mid(4〜7)のときは5ポイント、high(8または9)のときは3ポイント、それ以外のときは0ポイントをpointに加算するものとする。


##その０
さて、まずは`if-else`で実装してみますよ。

{% highlight ruby %}
def bonus_point(chara)
  if chara.level.between?(1, 3)
    chara.point += 10
  elsif chara.level.between?(4, 7)
    chara.point += 5
  elsif chara.level.between?(8, 9)
    chara.point += 3
  else
    0
  end
end

charas = charas.map { |chr| bonus_point(chr); chr }

puts charas

# >> Charlie:	lv:5	pt:5
# >> Liz:	lv:3	pt:10
# >> Ben:	lv:8	pt:3
{% endhighlight %}

各式のアライメントが取れないから、ちょっと見づらいですねぇ。

##その１
じゃあ、このままcaseに移管しますか。

{% highlight ruby %}
def bonus_point(chara)
  case
  when chara.level.between?(1, 3)
    chara.point += 10
  when chara.level.between?(4, 7)
    chara.point += 5
  when chara.level.between?(8, 9)
    chara.point += 3
  else
    0
  end
end

charas = charas.map { |chr| bonus_point(chr); chr }

puts charas

# >> Charlie:	lv:5	pt:5
# >> Liz:	lv:3	pt:10
# >> Ben:	lv:8	pt:3
{% endhighlight %}
アライメントが取れてちょっとマシになりましたか。

こうしてcaseはcase後の式を省略してif-else風にも書けるんですよ。

##その２
でも、こういうのあんまり見ませんねぇ。普通に行きましょうね。

{% highlight ruby %}
def bonus_point(chara)
  case chara.level
  when 1, 2, 3
    chara.point += 10
  when 4, 5, 6, 7
    chara.point += 5
  when 8, 9
    chara.point += 3
  else
    0
  end
end

charas = charas.map { |chr| bonus_point(chr); chr }

puts charas

# >> Charlie:	lv:5	pt:5
# >> Liz:	lv:3	pt:10
# >> Ben:	lv:8	pt:3
{% endhighlight %}

あー良くなりました。whenの後にカンマ区切りで複数の式置けるんですね。


##その３

でも、まあ普通、こうはしませんよね。こうですね。

{% highlight ruby %}
def bonus_point(chara)
  case chara.level
  when 1..3
    chara.point += 10
  when 4..7
    chara.point += 5
  when 8, 9
    chara.point += 3
  else
    0
  end
end

charas = charas.map { |chr| bonus_point(chr); chr }

puts charas

# >> Charlie:	lv:5	pt:5
# >> Liz:	lv:3	pt:10
# >> Ben:	lv:8	pt:3
{% endhighlight %}

ええ、Rangeです。でも、どうしてこういうことできるんですか？

それはね、caseの一致判定は`===`なんですよ。===は、これ、Rubyでは演算子じゃなくてメソッドなんですね。つまりオブジェクト毎に再定義可能なんです。

で、Range#===ってのが見事にRange#include?と同じ働きをするよう再定義されてるんです。マニュアル見てくださいね。だからwhenの後の式は概ねこんな感じですか。
{% highlight ruby %}
1..3.include?(chara.level)
{% endhighlight %}

これ聞いちゃうと、どんどん発想広がりますよね？

##その４

ただね、まだこういう手もあるんですよ。

{% highlight ruby %}
def bonus_point(chara)
  low, mid, high = [[1, 2, 3], [4, 5, 6, 7], [8, 9]]
  case chara.level
  when *low
    chara.point += 10
  when *mid
    chara.point += 5
  when *high
    chara.point += 3
  else
    0
  end
end

charas = charas.map { |chr| bonus_point(chr); chr }

puts charas

# >> Charlie:	lv:5	pt:5
# >> Liz:	lv:3	pt:10
# >> Ben:	lv:8	pt:3
{% endhighlight %}

そう、`*`を使って配列展開もできるんですよ。low, mid, highというラベル（変数）の導入で抽象度が一段上がった気もしますね。


##その５

さて、でもまだちょっとゴチャゴチャしてますよね。今度はこうしましょう。

{% highlight ruby %}
def bonus_point(chara)
  low, mid, high = [[1, 2, 3], [4, 5, 6, 7], [8, 9]]
  chara.point +=
    case chara.level
    when *low
      10
    when *mid
      5
    when *high
      3
    else
      0
    end
end

charas = charas.map { |chr| bonus_point(chr); chr }

puts charas

# >> Charlie:	lv:5	pt:5
# >> Liz:	lv:3	pt:10
# >> Ben:	lv:8	pt:3
{% endhighlight %}

スッキリしましたねぇ。そう、caseは「文」じゃなくて「式」、つまり評価の結果を返すんです。便利ですよね。

##その６

でも、今度はちょっとスカスカな感じもしますよ。こうしましょう。

{% highlight ruby %}
def bonus_point(chara)
  low, mid, high = [[1, 2, 3], [4, 5, 6, 7], [8, 9]]
  chara.point +=
    case chara.level
    when *low  then 10
    when *mid  then 5
    when *high then 3
    else 0
    end
end

charas = charas.map { |chr| bonus_point(chr); chr }

puts charas

# >> Charlie:	lv:5	pt:5
# >> Liz:	lv:3	pt:10
# >> Ben:	lv:8	pt:3
{% endhighlight %}

`then`を使えば式とその評価を一行にできますね。


##その７
もちろん、セミコロン`;`使ってもいいですよ。

{% highlight ruby %}
def bonus_point(chara)
  low, mid, high = [[1, 2, 3], [4, 5, 6, 7], [8, 9]]
  chara.point +=
    case chara.level
    when *low; 10
    when *mid;  5
    when *high; 3
    else 0
    end
end
{% endhighlight %}

##その８

代入のところで改行入るの嫌う人もいますよね。わたし気にしませんが。じゃこうしてください。

{% highlight ruby %}
def bonus_point(chara)
  low, mid, high = [[1, 2, 3], [4, 5, 6, 7], [8, 9]]
  chara.point += begin
    case chara.level
    when *low; 10
    when *mid;  5
    when *high; 3
    else 0
    end
  end
end
{% endhighlight %}

さて、概ねいいと思うんですけど、もう少し続けてみますよ。

##その９
lowとかの前に付いてる`*`ってのが少しcrypticっていう人もいるんじゃないですか。

じゃあ、そういう人はこれなんかはお好みですかね？

{% highlight ruby %}
def bonus_point(chara)
  is_low = ->lv{ (1..3).include? lv }
  is_mid = ->lv{ (4..7).include? lv }
  is_high = ->lv{ [8, 9].include? lv }
  chara.point +=
    case chara.level
    when is_low; 10
    when is_mid;  5
    when is_high; 3
    else 0
    end
end

charas = charas.map { |chr| bonus_point(chr); chr }

puts charas

# >> Charlie:	lv:5	pt:5
# >> Liz:	lv:3	pt:10
# >> Ben:	lv:8	pt:3
{% endhighlight %}

なんですか、これは。

あー、`->lv{ }`ってのはProcオブジェクトですね？で、こんなところにProc置けるんですか。つまりこれは、`Proc#===`ってのが定義されているって話ですか？マニュアル見てみますか？

ほほぅ。Proc#===は、`Proc#call`と同じと書いてありますですよ。すると、when節に来ると、is_lowにセットされたProcがchara.levelを引数にとって実行され真偽が判定される、ってことですね。上では、RangeとArray微妙に使い分けたりしてますが。

もうこうなると、一致判定飛び越えてるじゃないですか。なんでもありですよ、Procさん呼べば。ただ、when節ごとにProc#callするからちょっとコスト増えますね。まあ、気にしませんが。

##その１０

はっきり言って、Range判定で誰ももう文句ないんですが。

でもねぇ、is_lowはないでしょRubyで、is_lowは。これが変数に`?`使えないRubyの弱点ですねぇ。

ということで...


{% highlight ruby %}
def bonus_point(chara)
  chara.point +=
    case chara.level
    when low?; 10
    when mid?;  5
    when high?; 3
    else 0
    end
end

private
def low?
  ->lv{ (1..3).include? lv }
end

def mid?
  ->lv{ (4..7).include? lv }
end

def high?
  ->lv{ [8, 9].include? lv }
end

charas = charas.map { |chr| bonus_point(chr); chr }

puts charas

# >> Charlie:	lv:5	pt:5
# >> Liz:	lv:3	pt:10
# >> Ben:	lv:8	pt:3
{% endhighlight %}
判定式をメソッド化しました。Procを返す高階関数ですね。bonus_pointメソッドの中、綺麗になりましたね。


##その１１

最後は、仕上げですね。ＤＲＹ、ＤＲＹ、Don't Repeat Yourself.　繰り返してるのあなたじゃないですか！

{% highlight ruby %}
def bonus_point(chara)
  chara.point +=
    case chara.level
    when low?; 10
    when mid?;  5
    when high?; 3
    else 0
    end
end

private
def level_seed(range)
  ->lv{ range.include? lv }
end

def low?
  level_seed(1..3)
end

def mid?
  level_seed(4..7)
end

def high?
  level_seed(8..9)
end

charas = charas.map { |chr| bonus_point(chr); chr }

puts charas

# >> Charlie:	lv:5	pt:5
# >> Liz:	lv:3	pt:10
# >> Ben:	lv:8	pt:3
{% endhighlight %}

まあ、こんな感じです。

２問目いってみましょうか。


##─ 問題２ ─

> 仮想WebフレームワークRackのレスポンスは、３要素の配列、すなわちステータスコード(Fixnum), ヘッダ(Hash), レスポンスボディ(#eachに応答する)を要素とする配列で構成される。以下のレスポンスのうち、res1は有効、res2、res3は無効なレスポンスである。

    res1 = [200, {'Content-Type' => 'text/html'}, "Welcome to Rack".chars]
    res2 = ['404', {'Content-Type' => 'text/html'}, "Welcome to Rack".chars]
    res3 = [500, {'Content-Type' => 'text/html'}, "Welcome to Rack"]

> 有効なレスポンスかをチェックする`response_lint`メソッドを実装せよ。

##その１
えっ？これ、caseの問題ですか？

普通は`&&`でこうするんじゃないですか。

{% highlight ruby %}
res1 = [200, {'Content-Type' => 'text/html'}, "Welcome to Rack".chars]
res2 = ['404', {'Content-Type' => 'text/html'}, "Welcome to Rack".chars]
res3 = [500, {'Content-Type' => 'text/html'}, "Welcome to Rack"]


def response_lint(res)
  res[0].is_a?(Fixnum) && res[1].is_a?(Hash) && res[2].respond_to?(:each)
end

[res1, res2, res3].map { |res| response_lint res } # => [true, false, false]
{% endhighlight %}

まあ、エレガントとは言えないですけどねぇ。

##その２

えっ？やっぱり、caseでやるんですか？

どうですかね、こうですか？

{% highlight ruby %}
def response_lint(res)
  pattern = [Fixnum, Hash, Enumerable].to_enum
  res.each do |r|
    case r
    when pattern.next
    else
      return false
    end
  end
  true
end

[res1, res2, res3].map { |res| response_lint res } # => [true, false, false]
{% endhighlight %}

おー、考えましたねー。`#each`で順番にレスポンスの要素を見ていく。caseで順番にpatternのクラスと一致判定する。一致しないものがあったら、そこでreturnして`false`を返して終わり。最後まで行けば`true`。ですね？`to_enum`が渋いじゃないですかあ。まあ、無理せずに`with_index`でもいいんですよ。

ところで、クラスとそのオブジェクトの一致判定ってのはなんですかね。答えはどこですか？

そう、`Module#===`ですね。まあ`Class#===`って言ったほうがピンと来ますよね。マニュアルに`obj.kind_of?(self)`がtrueならtrueって書いてあります。`is_a?`はaliasですね。

##その３

まあ、頑張ってるんですけど、そんなに綺麗じゃないですよね。

これ、ラップできないですかね？一致判定クラスですよ。

{% highlight ruby %}
class Pattern < Array
  def ===(other)
    zip(other).all? { |a, b| a === b }
  end
end
{% endhighlight %}

何か良く見えてこないですけど、`Pattern#===`ってのを定義しているところを見ると、whenの横に置こうって算段ですか？

{% highlight ruby %}
class Pattern < Array
  def ===(other)
    zip(other).all? { |a, b| a === b }
  end
end

def response_lint(res)
  case res
  when Pattern[Fixnum, Hash, Enumerable] then true
  else false
  end
end

[res1, res2, res3].map { |res| response_lint res } # => [true, false, false]
{% endhighlight %}

おおっ！

めちゃ可読性高いじゃないですかあ。`Pattern[Fixnum, Hash, Enumerable]`ってのは、`Array.[]`つまり`Pattern.new()`ですね？で、when節に入るとこのPattern配列にresがzipされて、一つづつ`===`判定されると。パターンマッチング、くわっ！

これ、あなた考えたの？すごいじゃない...

<br />

...ですよね...まさかね...

...[ohm gem](https://rubygems.org/gems/ohm)から...盗んできたんですか...

`Array#zip` => `#all?`はオレのものだって？...

##その４
Patternは汎用クラスだからこれ、ワンクッション入れて抽象化してもいいですよね。

{% highlight ruby %}
class Pattern < Array
  def ===(other)
    zip(other).all? { |a, b| a === b }
  end
end

Response = Pattern[Fixnum, Hash, Enumerable]

def response_lint(res)
  case res
  when Response then true
  else false
  end
end

[res1, res2, res3].map { |res| response_lint res } # => [true, false, false]
{% endhighlight %}

Responseはクラスじゃないんですけど、クラスっぽく見えますね。


##その５

こうなると、さらに欲が出ますよ。ステータスコード、ちゃんと弾くようにしますか。

となると、ここはRackの出番ですね、ほら。

{% highlight ruby %}
require "rack"

Rack::Utils::HTTP_STATUS_CODES # => {100=>"Continue", 101=>"Switching Protocols", 102=>"Processing", 200=>"OK", 201=>"Created", 202=>"Accepted", 203=>"Non-Authoritative Information", 204=>"No Content", 205=>"Reset Content", 206=>"Partial Content", 207=>"Multi-Status", 208=>"Already Reported", 226=>"IM Used", 300=>"Multiple Choices", 301=>"Moved Permanently", 302=>"Found", 303=>"See Other", 304=>"Not Modified", 305=>"Use Proxy", 306=>"Reserved", 307=>"Temporary Redirect", 308=>"Permanent Redirect", 400=>"Bad Request", 401=>"Unauthorized", 402=>"Payment Required", 403=>"Forbidden", 404=>"Not Found", 405=>"Method Not Allowed", 406=>"Not Acceptable", 407=>"Proxy Authentication Required", 408=>"Request Timeout", 409=>"Conflict", 410=>"Gone", 411=>"Length Required", 412=>"Precondition Failed", 413=>"Request Entity Too Large", 414=>"Request-URI Too Long", 415=>"Unsupported Media Type", 416=>"Requested Range Not Satisfiable", 417=>"Expectation Failed", 422=>"Unprocessable Entity", 423=>"Locked", 424=>"Failed Dependency", 425=>"Reserved for WebDAV advanced collections expired proposal", 426=>"Upgrade Required", 427=>"Unassigned", 428=>"Precondition Required", 429=>"Too Many Requests", 430=>"Unassigned", 431=>"Request Header Fields Too Large", 500=>"Internal Server Error", 501=>"Not Implemented", 502=>"Bad Gateway", 503=>"Service Unavailable", 504=>"Gateway Timeout", 505=>"HTTP Version Not Supported", 506=>"Variant Also Negotiates (Experimental)", 507=>"Insufficient Storage", 508=>"Loop Detected", 509=>"Unassigned", 510=>"Not Extended", 511=>"Network Authentication Required"}
{% endhighlight %}

これで、`===`定義すりゃいいですな。ヒヒィ。

{% highlight ruby %}
require "rack"

HTTP_STATUS = Rack::Utils::HTTP_STATUS_CODES

def HTTP_STATUS.===(num)
  any? { |k, v| k == num }
end
{% endhighlight %}

引数の数値がkeyの何れかに一致すればOKという感じですね。

で、これをFixnumに代えてPatternにセットすると。テストサンプルも増やして...

{% highlight ruby %}
res1 = [200, {'Content-Type' => 'text/html'}, "Welcome to Rack".chars]
res2 = ['404', {'Content-Type' => 'text/html'}, "Welcome to Rack".chars]
res3 = [500, {'Content-Type' => 'text/html'}, "Welcome to Rack"]
res4 = [301, {'Content-Type' => 'text/html'}, "Welcome to Rack".chars]
res5 = [502, {'Content-Type' => 'text/html'}, "Welcome to Rack".chars]
res6 = [700, {'Content-Type' => 'text/html'}, "Welcome to Rack".chars]

Response = Pattern[HTTP_STATUS, Hash, Enumerable]

def response_lint(res)
  case res
  when Response then true
  else false
  end
end

[res1, res2, res3, res4, res5, res6].map { |res| response_lint res } # => [true, false, false, true, true, false]
{% endhighlight %}

いいんじゃないですかー。

caseの自由度がなせる技ですよ。まさに。


##その６

まあ、もういいんですけど、折角だからコードセクション毎にcaseするっての、どうですか。

{% highlight ruby %}
require "rack"

HTTP_STATUS = Rack::Utils::HTTP_STATUS_CODES.group_by { |k, v| k / 100 }

5.times do |n|
  st = HTTP_STATUS[n+1]
  def st.===(num)
    any? { |k, v| k == num }
  end
  Object.const_set("HTTP_STATUS_#{n+1}xx", st)
end

Response1xx = Pattern[HTTP_STATUS_1xx, Hash, Enumerable]
Response2xx = Pattern[HTTP_STATUS_2xx, Hash, Enumerable]
Response3xx = Pattern[HTTP_STATUS_3xx, Hash, Enumerable]
Response4xx = Pattern[HTTP_STATUS_4xx, Hash, Enumerable]
Response5xx = Pattern[HTTP_STATUS_5xx, Hash, Enumerable]
{% endhighlight %}

`group_by`でセクション分けてそれぞれ定数にセットします。で、各セクションには`===`を定義します。無理矢理感強いですか。

下準備ができたので、いってみますよ。

{% highlight ruby %}
res1 = [200, {'Content-Type' => 'text/html'}, "Welcome to Rack".chars]
res2 = ['404', {'Content-Type' => 'text/html'}, "Welcome to Rack".chars]
res3 = [500, {'Content-Type' => 'text/html'}, "Welcome to Rack"]
res4 = [301, {'Content-Type' => 'text/html'}, "Welcome to Rack".chars]
res5 = [502, {'Content-Type' => 'text/html'}, "Welcome to Rack".chars]
res6 = [700, {'Content-Type' => 'text/html'}, "Welcome to Rack".chars]

def response_lint(res)
  case res
  when Response1xx then :'1xx'
  when Response2xx then :'2xx'
  when Response3xx then :'3xx'
  when Response4xx then :'4xx'
  when Response5xx then :'5xx'
  else false
  end
end

[res1, res2, res3, res4, res5, res6].map { |res| response_lint res } # => [:"2xx", false, false, :"3xx", :"5xx", false]
{% endhighlight %}

いいんじゃないですかね！こんな感じです。

えっ？もっと先は無いのかって？

なら、`gem i case`してくださいよ、僕はもういっぱいですから。そうですよ、そのまんま[case gem](https://rubygems.org/gems/case "case | RubyGems.org | your community gem host")。Rubyでパターンマッチ頑張ってるって感じですよ...

<br />

そんなわけで...ご清聴ありがとうございました...


<br />

<br />
---

客観的に見て、ぼくはガツンと言ってやったと思う。「Rubyのcaseを〇〇(言語名)のswitch文だと思っている人たち」を前に、caseが持っている能力をひたすら羅列していった。この思い届けとばかりにガツンと言ってやった。それが彼らに届いたかどうかは、ぼくには分からない。しかしぼくがガツンと言ってやったことだけは確かだ。ぼくは今日Rubyのcaseについて一言申し上げたのだった。

---

それから、もう一言Rubyについて申し上げたいことがある。これは是非とも今日ここで言っておかなければならないことだ。ぼくがRubyを生んだ人やそれを育ててる人たちやそれを盛り上げている人たちに正対して、これを直接述べることができないとしても、これは今日言っておかなければいけない。そしてぼくは言う。

<br />

Ruby、20周年おめでとう


<br />
<br />


---

<p style='color:red'>=== Ruby関連電子書籍100円で好評発売中！ ===</p>

[M'ELBORNE BOOKS]({{ site.url }}/books/ "M'ELBORNE BOOKS")

<a href="{{ BASE_PATH }}/books/">
  <img src="/assets/images/2012/start_ruby.jpg" alt="start_ruby" style="width:200px" />
</a>
<a href="{{ BASE_PATH }}/books/">
  <img src="/assets/images/2013/02/ruby_object_cover.png" alt="ruby_object" style="width:200px" />
</a>
<a href="{{ BASE_PATH }}/books/">
  <img src="/assets/images/2012/rack_cover.png" alt="rack" style="width:200px" />
</a>


---

参考記事：

[ぼくがはてなブックマークの人に「ガツン」と申し上げたこと - カイ士伝](http://bloggingfrom.tv/wp/2012/06/01/7584)

