---
layout: post
title: "Rubyにおけるスコープのおはなし"
description: ""
category: 
tags: 
date: 2013-09-24
published: true
---
{% include JB/setup %}


今ここで「首相は誰？」と言ったら、答えは「安倍晋三」になります。ジュネーブの国際会議で「首相は誰？」と言ったら、答えは「不定」になります。しかし世界統一国家なるものが存在しうるなら、そこでの答えは「バラク・オバマ」になります。

つまり「首相」という語は環境依存です。

「首相」における環境依存性を排除する一つの方法は、それに名前空間、つまり対象限定子を付けることです。「**日本の**首相は誰？」「**世界統一国家の**首相は誰？」と言えば、どんな環境にあろうとも「首相」という語が指す対象は一意です{% fn_ref 1 %}。


##Rubyの定数

Rubyにも名前空間の機能があるので、環境依存性を排除した首相を実装できます。

{% highlight ruby %}
class Japan
  PrimeMinister = 'Shinzo Abe'
end

class UK
  PrimeMinister = 'David Camelon'
end

class Germany
  PrimeMinister = 'Angela Merkel'
end

class USA
  President = 'Barack Obama'
end

# The United Countries of the World
PrimeMinister = USA::President

Japan::PrimeMinister   # => "Shinzo Abe"
UK::PrimeMinister      # => "David Camelon"
Germany::PrimeMinister # => "Angela Merkel"
PrimeMinister          # => "Barack Obama"
{% endhighlight %}

Rubyではスコープ演算子`::`が自然言語における「の」の役割を担います。

あなたが地球外生命体を信じているなら、こうしたほうが確実です。

{% highlight ruby %}
module Earth
  class Japan
    PrimeMinister = 'Shinzo Abe'
  end

  class UK
    PrimeMinister = 'David Camelon'
  end

  class Germany
    PrimeMinister = 'Angela Merkel'
  end

  class USA
    President = 'Barack Obama'
  end

  # The United Countries of the World
  PrimeMinister = USA::President
end

Earth::Japan::PrimeMinister   # => "Shinzo Abe"
Earth::UK::PrimeMinister      # => "David Camelon"
Earth::Germany::PrimeMinister # => "Angela Merkel"
Earth::PrimeMinister          # => "Barack Obama"
{% endhighlight %}

もちろん、日本国内ではいちいち「日本の」と限定する必要はありません。

{% highlight ruby %}
class Japan
  PrimeMinister = 'Shinzo Abe'
  def self.people_saying
    "消費税上げないで、#{PrimeMinister}さん！"
  end
end

Japan.people_saying # => "消費税上げないで、Shinzo Abeさん！"
{% endhighlight %}


##Rubyの変数

ここで、あなたが経験豊富なRubyistで政治に明るい人なら、先のコードを見て次のようなツッコミを入れるでしょう。

    首相は定数じゃなくて、変数だから！特に日本じゃね！

では、変数版「首相」を定義して日本の外から呼んでみましょう。

{% highlight ruby %}
class Japan
  prime_minister = 'Shinzo Abe'
end

Japan::prime_minister   # => 

# ~> -:5:in `<main>': undefined method `prime_minister' for Japan:Class (NoMethodError)
{% endhighlight %}

そう、Rubyでは自然言語における名前空間の場合とは異なり、変数`prime_minister`はJapanオブジェクトの外からは参照できないのです。

では、内側からはどうでしょう。

{% highlight ruby %}
class Japan
  prime_minister = 'Shinzo Abe'
  def self.people_saying
    "消費税上げないで、#{prime_minister}さん！"
  end
end

Japan.people_saying # => 

# ~> -:4:in `people_saying': undefined local variable or method `prime_minister' for Japan:Class (NameError)
{% endhighlight %}

同様に、これもダメなのです。

つまりRubyの変数は、オブジェクトの壁やメソッドの壁を超えては参照できず、それが定義された場所でしか通用しない極めてローカルなものなのです。言うなれば変数は「方言」や「ギャル語」と同じです。

##インスタンス変数

周知のとおり我が国では「ギャル語」を国の公用語にしようとする運動が盛んです。かつてRubyの世界でも同種の運動があり、その結果として、変数の頭に対象拡張子`@`を付するという条件付きで、その有効範囲を拡張できるような仕組みが導入されました。

任意のオブジェクトの中で`@`を前置した変数は、そのオブジェクトの中ならどこからでも参照・変更できるようになります。つまり対象拡張子`@`はオブジェクトを差しているのです。

`@`を使って、Japanオブジェクトにおけるメソッド`people_saying`の壁を乗り越えます。

{% highlight ruby %}
class Japan
  @prime_minister = 'Shinzo Abe'

  def self.people_saying
    "消費税上げないで、#{@prime_minister}さん！"
  end
end

Japan.people_saying # => "消費税上げないで、Shinzo Abeさん！"
{% endhighlight %}

とは言え、Japanオブジェクトの外から直接これを参照することまでは原則許容されません。その必要がある場合はゲッターを介した間接参照を使います。

{% highlight ruby %}
class Japan
  @prime_minister = 'Shinzo Abe'
  def self.prime_minister
    @prime_minister
  end

  # または
  # class << self
  #   attr_reader :prime_minister
  # end

end

Japan.prime_minister # => "Shinzo Abe"
{% endhighlight %}

##グローバル変数

実はRubyの世界ではもっと過激な運動がありました。それは言わば、「ギャル語」を世界の共通語にする運動です。そして世界規模のこの運動にRubyの設計者は最終的には抗うことができず、対象拡張子`$`を付するならグローバルな参照を許す、という妥協案を提示しました。

対象拡張子`$`を前置した変数は、当然に任意のオブジェクト内におけるメソッドの壁を乗り越えます。

{% highlight ruby %}
class Japan
  $prime_minister = 'Shinzo Abe'
  def self.people_saying
    "消費税上げないで、#{$prime_minister}さん！"
  end

end

Japan.people_saying # => "消費税上げないで、Shinzo Abeさん！"
{% endhighlight %}

そしてオブジェクトの壁も乗り越えます。

{% highlight ruby %}
class Japan
  $prime_minister = 'Shinzo Abe'
  def self.people_saying
    "消費税上げないで、#{$prime_minister}さん！"
  end

end

class Greece
  def self.people_saying
    "More Jobs! Mr. #{$prime_minister}"
  end
end

Greece.people_saying # => "More Jobs! Mr. Shinzo Abe"

$prime_minister # => "Shinzo Abe"

$prime_minister = "Antonis Samaras"

Greece.people_saying # => "More Jobs! Mr. Antonis Samaras"
Japan.people_saying # => "消費税上げないで、Antonis Samarasさん！"
{% endhighlight %}

対象拡張子`$`はグローバルを差しています。それがどこで定義されようと、どこからでも参照および変更が可能です。つまりグローバル変数は名前空間という社会秩序を破壊します。

もっとも、Rubyにおけるグローバル変数は厳密に言えばグローバルではありません。私のプログラムで`$fav = 'programming'`としても、あなたのプログラムにおける`$fav`変数は`'money'`のままです。更に言えば、私の別のプログラムにおける`$fav`も`'blogging'`のままです。つまりプログラムにおけるグローバルとは、その起動プロセスを指しています。誰かがプログラミングにおいて真のグローバルを求めたとき、世界は完全に崩壊します。

ちなみにグローバル変数の記号`$`はドル（Dollar）であり、これは将来世界共通通貨ドルが生まれることを予言しています。

##クラス変数

地球人皆友達（グローバル変数）は余りに過激で、ひとり言語（インスタンス変数）は寂しすぎます。「せめて家族だけでも」というのは、携帯家族割が当り前の世にあって傾聴に値する意見です。

任意のクラスの中で対象拡張子`@@`を前置した変数は、そのクラスおよびそこから生成されるオブジェクト（インスタンス）の中ならどこからでも参照可能です。

{% highlight ruby %}
class JapanPref
  @@prime_minister = 'Shinzo Abe'
  def self.prime_minister
    @@prime_minister
  end

  attr_reader :name
  def initialize(name)
    @name = name
  end

  def pm
    @@prime_minister
  end

  def pm=(name)
    @@prime_minister = name
  end
end

JapanPref.prime_minister # => "Shinzo Abe"

tokyo = JapanPref.new(:tokyo)
tokyo.name # => :tokyo
tokyo.pm # => "Shinzo Abe"

okinawa = JapanPref.new(:okinawa)
okinawa.name # => :okinawa
okinawa.pm # => "Shinzo Abe"
{% endhighlight %}


ここでokinawaオブジェクトにおけるpmに私、'Charlie'をセットしてみましょう。

{% highlight ruby %}
okinawa.pm = 'Charlie'

JapanPref.prime_minister # => "Charlie"
tokyo.pm # => "Charlie"
{% endhighlight %}

瞬時に日本全国でその意見が共有されました。

更にクラス変数は、そのクラス系譜、つまり継承クラス群およびそのインスタンスでも有効です。

{% highlight ruby %}
class JapanCity < JapanPref
  @@prime_minister = 'Charlie II'
  attr_reader :name
  def initialize(name)
    super
  end

end

sapporo = JapanCity.new(:sapporo)
sapporo.name # => :sapporo
sapporo.pm # => "Charlie II"

matsue = JapanCity.new(:matsue)
matsue.pm = 'Matz'

sapporo.pm # => "Matz"
JapanCity.prime_minister # => "Matz"
JapanPref.prime_minister # => "Matz"
okinawa.pm # => "Matz"
{% endhighlight %}

松江市の策略でMatzが総理になることに何ら異論はありませんが、クラス変数の有効範囲はちょっと広すぎる感がありますね（'Charlie'を外されてスネてるわけではありません...）。Objectクラスのクラス変数はほぼグローバル変数と等価になります。


Rubyにおけるスコープのおはなしは以上です。さようなら。

{% footnotes %}
{% fn ここでは時制の問題は議論しません %}
{% endfootnotes %}
