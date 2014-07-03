---
layout: post
title: "Rubyのメソッド引数は奥が深い(その２)または別のフィボナッチ"
description: ""
category: 
tags: 
date: 2014-07-02
published: true
---
{% include JB/setup %}

## ─ 問題 ─

n番目のフィボナッチ数を返すメソッド`fib`を定義しなさい。但し、メソッドの実装は一文字とする。

解答例は下。

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

##─ 解答例 ─

{% highlight ruby %}
def fib(n, m=n==0||n==1 ? n : fib(n-1)+fib(n-2))
  m
end

(1..20).map { |n| fib n } # => [1, 1, 2, 3, 5, 8, 13, 21, 34, 55, 89, 144, 233, 377, 610, 987, 1597, 2584, 4181, 6765]
{% endhighlight %}


詐欺です、スンマセンm(__)m

---

(追記：2014-7-3) メモ化高速バージョンを追加しました。

###メモ化高速バージョン

{% highlight ruby %}
def fib(n, m={0=>0,1=>1}.tap{|s|s.default_proc=->h,k{h[k]=h[k-1]+h[k-2]}}[n])
  m
end

fib(1000) # => 43466557686937456435688527675040625802564660517371780402481729089536555417949051890403879840079255169295922593080322634775209689623239873322471161642996440906533187938298969649928516003704476137795166849228875
{% endhighlight %}

---

関連記事：

[Rubyのメソッド引数は奥が深い]({{ BASE_PATH }}/2014/04/04/rubys-arguments-are-so-deep/ "Rubyのメソッド引数は奥が深い")

[RubyのHashの秘密 その２]({{ BASE_PATH }}/2014/06/12/fib-in-hash-default/ "RubyのHashの秘密 その２")



