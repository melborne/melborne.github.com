---
layout: post
title: "RubyのHashの秘密"
description: ""
category: 
tags: 
date: 2014-06-11
published: true
---
{% include JB/setup %}

巷では個人情報保護の機運が高まっているからぼくもひとつそのための仕組みを考えてみたよ。ぼくのやり方はRubyのHashを使うんだ。

まずはHashに`HashSecret`というモジュールを挿すよ。
{% highlight ruby %}
Hash.include HashSecret
{% endhighlight %}

このHashは普通のHashのように使えるんだけど、そこに機密情報をセットするための`Hash#secret=`というメソッドを追加するんだ。

{% highlight ruby %}
h = {}
h[:name] = 'Charlie'
h[:job] = 'Programmer'

h # => {:name=>"Charlie", :job=>"Programmer"}

h.secret = 'My-password123' # 機密情報をセット！
{% endhighlight %}

で、ここからがミソなんだけれども、セットされた機密情報はHashを走査しても見えないんだ。

{% highlight ruby %}
h.secret = 'My-password123' # 機密情報をセット！

h # => {:name=>"Charlie", :job=>"Programmer"}

h.each { |kv| p kv }
# >> [:name, "Charlie"]
# >> [:job, "Programmer"]
{% endhighlight %}

でも、`secret`キーを使えばアクセスできる。

{% highlight ruby %}
h[:secret] # => "My-password123"
{% endhighlight %}


複数の機密情報を扱いたい場合は、`Hash#secret=`に配列やハッシュをセットすればいいんだ。

{% highlight ruby %}
# 配列で機密情報を管理！
h.secret = []
h[:secret] << 'My-password123'
h[:secret] << 'charlie@secret.com'

h # => {:name=>"Charlie", :job=>"Programmer"}

h[:secret] # => ["My-password123", "charlie@secret.com"]

# ハッシュで機密情報を管理！
h.secret = {}
h[:secret][:credit] = '123-456-789-012'
h[:secret][:email] = 'charlie@secret.com'

h # => {:name=>"Charlie", :job=>"Programmer"}

h[:secret][:credit] # => "123-456-789-012"
h[:secret][:email] # => "charlie@secret.com"

h # => {:name=>"Charlie", :job=>"Programmer"}
{% endhighlight %}

ねっ？

でも、多分これだと、こう言う人がきっといるよね。

> 「HashSecret使ってんの分かったら、`secret`キーでアクセスされちゃうじゃん。バカなの？」

そんなときは`secret`キーに別の値をセットして隠蔽すればいいんだよ。

{% highlight ruby %}
h[:secret] = 'Nothing here'

h[:secret] # => "Nothing here"

h # => {:name=>"Charlie", :job=>"Programmer", :secret=>"Nothing here"}
{% endhighlight %}

今度は、こういう声が聞こえてくるよ。

> 「それでどうやって機密情報にアクセスすんの？お前、あほなの？」

まあ、落ち着いて。

まずは、ヨガで言うところの「シッダアーサナ（達人座）」のポーズを取って目を閉じ静かに深く呼吸する。

![Alt title noshadow](http://yoga-pose.info/img/zai/tatsujinza.jpg)

> 出典：[達人座（シッダ・アーサナ） - ヨガのポーズ大全集](http://yoga-pose.info/zai/tatsujinza.htm "達人座（シッダ・アーサナ） - ヨガのポーズ大全集")

で、心の中が「無」になったら、そこに浮かんだ「言葉」を読むんだ。

ぼくの言葉はこうだった。

> :sekai_no_owari

さあ、試してみるよ！

{% highlight ruby %}
h[:sekai_no_owari] # => {:credit=>"123-456-789-012", :email=>"charlie@secret.com"}
{% endhighlight %}

ほら、読めた！


...


つまらないネタ思いついちゃったので...。

まだ？（はてな）な人いるかもしれないから、`HashSecret`の実装は下の方に置いておきますm(__)m


<br/>
<br/>
<br/>
<br/>
<br/>
<br/>
<br/>
<br/>
<br/>
<br/>
<br/>
<br/>
<br/>
<br/>
<br/>
<br/>
<br/>
<br/>
<br/>
<br/>
<br/>
<br/>
<br/>
<br/>

{% highlight ruby %}
module HashSecret
  def secret=(val)
    self.default=(val)
  end
end
{% endhighlight %}

`Hash#default=`の別名かよ！


{% highlight ruby %}
h[:foo] # => {:credit=>"123-456-789-012", :email=>"charlie@secret.com"}
h[:bar] # => {:credit=>"123-456-789-012", :email=>"charlie@secret.com"}
h[:blah_blah_blah] # => {:credit=>"123-456-789-012", :email=>"charlie@secret.com"}
h["秘密のコード教えて"] # => {:credit=>"123-456-789-012", :email=>"charlie@secret.com"}
{% endhighlight %}

機密情報のブロードキャストみたいな。

