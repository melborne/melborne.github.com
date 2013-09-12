---
layout: post
title: "Rubyのオブジェクトを数えましょう♫"
description: ""
category: 
tags: 
date: 2013-09-06
published: true
---
{% include JB/setup %}


<span style="color:#E50086">メグ</span>「ねえ、最近なんか世の中景気が良さそうだから、あたしも株やってみようと思うんだけど。」

<span style="color:#6BBF3F">るびお</span>「...。」

<span style="color:#E50086">メグ</span>「それで、折角だからデータベース作って興味ある会社のデータを管理しようと思うの。」

<span style="color:#6BBF3F">るびお</span>「...。」

<span style="color:#E50086">メグ</span>「ジュエリーショップとかドーナツ屋さんとかに興味あるんだけど...。」

<span style="color:#6BBF3F">るびお</span>「はい、はい。作れってことね、オレが。こんな感じじゃない。」

{% highlight ruby %}
Stock = Struct.new(:name, :market, :ticker, :sector, :website, :desc) do
  def to_s
    format = <<-EOS
    %s (%s:%s)
      sec: %s
      url: %s
      des: %s
    ----------
    EOS
    format % values
  end
end

require "csv"

stocks = CSV.parse(DATA.read).map { |data| Stock.new *data.map(&:strip) }

puts stocks

__END__
Tiffany & Co., NYSE, TIF, Jewelry Retailers, www.tiffany.com
Krispy Kreme Doughnuts, NYSE, KKD, Food Retail, www.krispykreme.com
Apple Inc, NASDAQ, AAPL, Computer, www.apple.com
The Coca-Cola Company, NYSE, KO, Beverages, www.coca-colacompany.com
Google Inc, NASDAQ, GOOG, Search Engines, www.google.com
{% endhighlight %}

<span style="color:#6BBF3F">るびお</span>「はい、プリントアウト。」

{% highlight bash %}
    Tiffany & Co. (NYSE:TIF)
      sec: Jewelry Retailers
      url: www.tiffany.com
      des: 
    ----------
    Krispy Kreme Doughnuts (NYSE:KKD)
      sec: Food Retail
      url: www.krispykreme.com
      des: 
    ----------
    Apple Inc (NASDAQ:AAPL)
      sec: Computer
      url: www.apple.com
      des: 
    ----------
    The Coca-Cola Company (NYSE:KO)
      sec: Beverages
      url: www.coca-colacompany.com
      des: 
    ----------
    Google Inc (NASDAQ:GOOG)
      sec: Search Engines
      url: www.google.com
      des: 
    ----------
{% endhighlight %}

<span style="color:#E50086">メグ</span>「るびお君素敵！でも、よく見ると生成したStockオブジェクトたちを`stocks`ってローカル変数で管理してるけど、ちょっとそれってダサくない？これらは`Stockクラス`から生成されるんだから、Stockクラスが管理するのが自然だと思うんだけど。」

<span style="color:#6BBF3F">るびお</span>「...。わかったよ。じゃあ、クラス変数かクラスインスタンス変数を使って管理すればいいよ。ほら。」

{% highlight ruby %}
Stock = Struct.new(:name, :market, :ticker, :sector, :website, :desc) do
  def initialize(*args)
    super
+   self.class.stocks << self
  end
  
  def to_s
    format = <<-EOS
    %s (%s:%s)
      sec: %s
      url: %s
      des: %s
    ----------
    EOS
    format % values
  end
  
+ def self.stocks
+   @stocks ||= []
+ end
end

require "csv"

CSV.parse(DATA.read).each { |data| Stock.new *data.map(&:strip) }

+puts Stock.stocks

__END__
Tiffany & Co., NYSE, TIF, Jewelry Retailers, www.tiffany.com
Krispy Kreme Doughnuts, NYSE, KKD, Food Retail, www.krispykreme.com
Apple Inc, NASDAQ, AAPL, Computer, www.apple.com
The Coca-Cola Company, NYSE, KO, Beverages, www.coca-colacompany.com
Google Inc, NASDAQ, GOOG, Search Engines, www.google.com
{% endhighlight %}


<span style="color:#E50086">メグ</span>「るびお君素敵！でも、こういうことってよくやるわよね。だったらモジュールに切り出して汎用的に使えるようにしてくれたらうれしいんだけど...。」


<span style="color:#6BBF3F">るびお</span>「相変わらず、リクエスト多いよね。じゃあ、やってみるよ。`Class.new`をオーバーライドすればいいのかな...。ほら。」


{% highlight ruby %}
+ module ObjectTrapper
+   def new(*args, &blk)
+     obj = allocate
+     obj.send(:initialize, *args, &blk)
+     objects << obj
+     obj
+   end
+   
+   def objects
+     @objects ||= []
+   end
+ end

Stock = Struct.new(:name, :market, :ticker, :sector, :website, :desc) do
+ extend ObjectTrapper
  
  def to_s
    format = <<-EOS
    %s (%s:%s)
      sec: %s
      url: %s
      des: %s
    ----------
    EOS
    format % values
  end
end

require "csv"

CSV.parse(DATA.read).each { |data| Stock.new *data.map(&:strip) }

p Stock.objects
{% endhighlight %}

<span style="color:#E50086">メグ</span>「るびお君素敵！Class.newの機能が、`allocate`でオブジェクトを生成して、`initialize`で初期化して、そのオブジェクトを返すことだから、それをシミュレートしつつも、そのオブジェクトを`objects`に格納できるようにしたのね！」

<span style="color:#6BBF3F">るびお</span>「えへん。まあ、大したことじゃないよ。じゃあ実行してみるよ。ほら。」

{% highlight ruby %}
# >> []
{% endhighlight %}

<span style="color:#6BBF3F">るびお</span>「げっ！おかしいな。クラスのときは上手くいってたのに、Structはダメなのか...。なんかObjectTrapperのnewが呼ばれてないみたいだ...。{% fn_ref 1 %}」


<span style="color:#E50086">メグ</span>「るびお君の嘘つき！だめじゃないのよ。」


<span style="color:#6BBF3F">るびお</span>「...。」

<span style="color:#E50086">メグ</span>「もう。こういうときはどうすればいいか、前に教えたよね？後ろがダメなら前に刺すのよ！」

> 参照：[分別のあるRubyモンキーパッチャーになるために]({{ site.url }}/2013/08/30/monkey-patching-for-prudent-rubyists/ "分別のあるRubyモンキーパッチャーになるために")

{% highlight ruby %}
Stock = Struct.new(:name, :market, :ticker, :sector, :website, :desc) do
+ class << self
+   prepend ObjectTrapper
+ end
  
  def to_s
    format = <<-EOS
    %s (%s:%s)
      sec: %s
      url: %s
      des: %s
    ----------
    EOS
    format % values
  end
end

require "csv"

CSV.parse(DATA.read).each { |data| Stock.new(*data.map(&:strip)) }

puts Stock.objects

# >>     Tiffany & Co. (NYSE:TIF)
# >>       sec: Jewelry Retailers
# >>       url: www.tiffany.com
# >>       des: 
# >>     ----------
# >>     Krispy Kreme Doughnuts (NYSE:KKD)
# >>       sec: Food Retail
# >>       url: www.krispykreme.com
# >>       des: 
# >>     ----------
# >>     Apple Inc (NASDAQ:AAPL)
# >>       sec: Computer
# >>       url: www.apple.com
# >>       des: 
# >>     ----------
# >>     The Coca-Cola Company (NYSE:KO)
# >>       sec: Beverages
# >>       url: www.coca-colacompany.com
# >>       des: 
# >>     ----------
# >>     Google Inc (NASDAQ:GOOG)
# >>       sec: Search Engines
# >>       url: www.google.com
# >>       des: 
# >>     ----------
{% endhighlight %}

<span style="color:#6BBF3F">るびお</span>「ほ、ほんとだ...。ま、まあ、ちょっと不手際あったけど、オレのお陰で目的達成できただろ？感謝してる？」

<span style="color:#E50086">メグ</span>「...。あなた相変わらずね。でもね、あたしね、しびれ切らしちゃったから、自分でも作ってみたの。ほら。」

{% highlight ruby %}
module ObjectTrapper
+ def objects
+   ObjectSpace.each_object(self).to_a
+ end
end

Stock = Struct.new(:name, :market, :ticker, :sector, :website, :desc) do
+ extend ObjectTrapper

  def to_s
    format = <<-EOS
    %s (%s:%s)
      sec: %s
      url: %s
      des: %s
    ----------
    EOS
    format % values
  end
end

require "csv"

CSV.parse(DATA.read).each { |data| Stock.new(*data.map(&:strip)) }

puts Stock.objects

# >>     Google Inc (NASDAQ:GOOG)
# >>       sec: Search Engines
# >>       url: www.google.com
# >>       des: 
# >>     ----------
# >>     Tiffany & Co. (NYSE:TIF)
# >>       sec: Jewelry Retailers
# >>       url: www.tiffany.com
# >>       des: 
# >>     ----------
# >>     Krispy Kreme Doughnuts (NYSE:KKD)
# >>       sec: Food Retail
# >>       url: www.krispykreme.com
# >>       des: 
# >>     ----------
# >>     The Coca-Cola Company (NYSE:KO)
# >>       sec: Beverages
# >>       url: www.coca-colacompany.com
# >>       des: 
# >>     ----------
# >>     Apple Inc (NASDAQ:AAPL)
# >>       sec: Computer
# >>       url: www.apple.com
# >>       des: 
# >>     ----------

__END__
Apple Inc, NASDAQ, AAPL, Computer, www.apple.com
The Coca-Cola Company, NYSE, KO, Beverages, www.coca-colacompany.com
Krispy Kreme Doughnuts, NYSE, KKD, Food Retail, www.krispykreme.com
Tiffany & Co., NYSE, TIF, Jewelry Retailers, www.tiffany.com
Google Inc, NASDAQ, GOOG, Search Engines, www.google.com
{% endhighlight %}

<span style="color:#6BBF3F">るびお</span>「ObjectSpace...。」


<br />

---

(追記：2013-09-12) 一部コードを修正しました(initializeの削除)。

---


<p style='color:red'>=== Ruby関連電子書籍100円で好評発売中！ ===</p>

[M'ELBORNE BOOKS]({{ BASE_PATH }}/books/ "M'ELBORNE BOOKS")

<a href="{{ BASE_PATH }}/books/">
  <img src="/assets/images/2013/03/ruby_trivia_cover.png" alt="ruby_trivia" style="width:200px" />
</a>
<a href="{{ BASE_PATH }}/books/">
  <img src="/assets/images/2012/ruby_parallel_cover.png" alt="ruby_parallel" style="width:200px" />
</a>
<a href="{{ BASE_PATH }}/books/">
  <img src="/assets/images/2012/rack_cover.png" alt="rack" style="width:200px" />
</a>


---

{% footnotes %}
{% fn どなたか理由を教えて下さい！ %}
{% endfootnotes %}

