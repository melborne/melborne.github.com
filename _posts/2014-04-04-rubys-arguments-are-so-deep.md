---
layout: post
title: "Rubyのメソッド引数は奥が深い"
description: ""
category: 
tags: 
date: 2014-04-04
published: true
---
{% include JB/setup %}

Rubyのメソッド引数は、デフォルト値がセットできたり、可変長引数にできたり、キーワード引数を渡せたり、多彩なわけですが。今日、[tco](https://github.com/pazdera/tco "pazdera/tco")というターミナル出力に色を付けるライブラリのソースを眺めていたら、面白い引数の使い方に出会って。ちょっとこれ問題にしてみようかと。もしかしたら常識かもしれません。



##─ 問題１ ─

配列を取り最初の３つの要素だけを返すメソッド`first_three`を定義しなさい。具体的には、以下の挙動になる。

{% highlight ruby %}
first_three 1 # => [1, nil, nil]
first_three [1] # => [1, nil, nil]
first_three [1, 2] # => [1, 2, nil]
first_three [1, 2, 3, 4, 5] # => [1, 2, 3]
{% endhighlight %}

<br/>

##─ 問題２ ─

二次元配列`values`を取り、奇数番目（先頭を０番として）の各要素の真ん中の値の合計値を返すメソッド`sum_of_odd_mid`を定義しなさい。

{% highlight ruby %}
values = [[1,2,3],[4,5,6],[7,8,9],[10,11,12],[13,14,15],[16,17,18]]

sum_of_odd_mid(values) # => 33
{% endhighlight %}


少し下に解答例を置いておきます。

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

##─ 解答例１ ─

{% highlight ruby %}
def first_three((a, b, c))
  [a, b, c]
end

first_three 1 # => [1, nil, nil]
first_three [1] # => [1, nil, nil]
first_three [1, 2] # => [1, 2, nil]
first_three [1, 2, 3, 4, 5] # => [1, 2, 3]
{% endhighlight %}

<br/>

##─ 解答例２ ─


{% highlight ruby %}
values = [[1,2,3],[4,5,6],[7,8,9],[10,11,12],[13,14,15],[16,17,18]]

def sum_of_odd_mid((_,(_,v1,_),_,(_,v2,_),_,(_,v3,_)))
  v1 + v2 + v3
end

sum_of_odd_mid(values) # => 33
{% endhighlight %}

<br/>

何れの例でも、引数定義において括弧を使って配列展開しています。ブロック引数での配列展開はよくやりますが、メソッド引数でもできるんですね。ちなみにtcoライブラリでは次のような使い方をしていました。

{% highlight ruby %}
module Tco

  def self.decorate(string, (fg, bg, bright, underline))
    @colouring.decorate string, [fg, bg, bright, underline]
  end

end
{% endhighlight %}


やあ、Rubyのメソッド引数は奥が深い。

---

<p style='color:red'>=== Ruby関連電子書籍100円〜で好評発売中！ ===</p>

[M'ELBORNE BOOKS]({{ BASE_PATH }}/books/ "M'ELBORNE BOOKS")

<a href="{{ BASE_PATH }}/books/">
  <img src="/assets/images/books/rack_cover.png" alt="rack" style="width:200px" />
</a>
<a href="{{ BASE_PATH }}/books/">
  <img src="/assets/images/books/ruby_pack8.png" alt="pack8" style="width:200px" />
</a>
<a href="{{ BASE_PATH }}/books/">
  <img src="/assets/images/books/ruby_parallel_cover.png" alt="ruby_parallel" style="width:200px" />
</a>
