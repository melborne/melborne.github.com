---
layout: post
title: "Procを制する者がRubyを制す（嘘）"
description: ""
category: 
tags: 
date: 2014-04-28
published: true
---
{% include JB/setup %}

RubyのProcの説明は巷に溢れているから今更感があるけどここ数回Procを使ったネタを書いていたらProcがかわいくなっちゃってもっとみんなにもProcのこと知ってもらいたいという欲求が生まれてきたからProcについての基本的なことを僕なりのやり方でここに書くよ。長いよ。

---

## Rubyの関数（メソッド）

Rubyにおいて関数（メソッド）はファーストクラス（オブジェクト）ではありません。つまり文字列や数字や配列などの他のオブジェクトとは異なって、Rubyではそれを直接変数に代入したり、他の関数に渡したりすることはできません。

{% highlight ruby %}
def square(n)
  n * n
end

sq = square # squareメソッドを変数sqに代入してみる

# ~> -:1:in `square': wrong number of arguments (0 for 1) (ArgumentError)
# ~> 	from -:5:in `<main>'
{% endhighlight %}

Rubyではメソッドの呼び出しには括弧を省略できるので、代入時にsquareと書いた時点でこれが引数なしのメソッド呼び出しだと評価されてしまうのです。

事情は引数渡しのときもおなじです。

{% highlight ruby %}
def square(n)
  n * n
end

def print_func(arg, fun)
  puts fun(arg)
end

print_func(4, square) # squareメソッドを引数として渡してみる

# ~> -:1:in `square': wrong number of arguments (0 for 1) (ArgumentError)
# ~> 	from -:9:in `<main>'
{% endhighlight %}

でも、がっかりする必要はありません。Rubyにはこれをファーストクラス化する手段、つまりメソッドをオブジェクトとしてラップする手段が代わりにあります。それがMethodオブジェクトです。

`Object#method`にメソッド名を渡せばMethodオブジェクトが生成できます。

{% highlight ruby %}
def square(n)
  n * n
end

sq = method(:square) # squareメソッドをオブジェクト化して変数sqに代入

sq # => #<Method: Object#square>
{% endhighlight %}

しかし注意点があります。これを通常のメソッドのように呼ぶことはできないのです。

{% highlight ruby %}
sq = method(:square)

sq(3) # 括弧で引数を渡して呼んでみる

# ~> -:7:in `<main>': undefined method `sq' for main:Object (NoMethodError)
{% endhighlight %}

このオブジェクトにラップされたメソッドを実行するつまりその評価を開始させるにはMethod#callを呼ぶ必要があります。メソッドに引数がある場合はcallにそれを渡します。

{% highlight ruby %}
def square(n)
  n * n
end

sq = method(:square)

sq.call(3) # => 9

def print_func(arg, fun)
  puts fun.call(arg)
end

print_func(4, sq)

# >> 16
{% endhighlight %}

このことを、「メソッドをMethodオブジェクトでラップすると、それがcallされるまで**評価を遅延できる**」と見ることもできます。

`#call`にはメソッド呼び出しの括弧に似た見た目の複数のエイリアスがあります。

{% highlight ruby %}
sq = method(:square)

sq[3] # => 9

sq.(3) # => 9
{% endhighlight %}

## Rubyのブロック

さて、Rubyにはご存知「ブロック」という構文があります。ブロックはdo ... endまたは{ ... }で囲まれた手続きの塊です。先にRubyではメソッド引数にメソッドを直接渡すことはできないと書きましたが、このブロックをメソッドに付することは特別にできるようになっています。

{% highlight ruby %}
def print_func(arg, &fun)
  puts fun.call(arg)
end

print_func(4) { |n| n * n }

# >> 16
{% endhighlight %}

メソッド定義における`&`に注目してください。仮引数（ここではfun）に&を前置すると、メソッドはこの仮引数を介してブロックを受け取れるようになります。

しかしRubyでは`yield`というキーワードを使った次のような書き方が許容されていて、こちらのほうが広く使われています。しかしその意味は同じです。

{% highlight ruby %}
def print_func(arg)
  puts yield(arg)
end

print_func(4) { |n| n * n }

# >> 16
{% endhighlight %}

つまり`& + call == yield`です。

## Procオブジェクト

Rubyのブロックは、メソッド同様、ファーストクラスではありません。従ってメソッドに付する以外にそれが独立してRuby空間内に存在することはできないのです。しかし、メソッドがMethodオブジェクトによってファーストクラス化できるのと同様、Rubyではブロックもファーストクラス化することができます。それがProcオブジェクト（手続きオブジェクト）です。

ブロックをProcオブジェクトにするには`lambda`, `proc`, `Proc.new`, `->`の何れかを使います。何でこんなにあるのかわかりませんが。

{% highlight ruby %}
lambda { |n| n * n } # => #<Proc:0x007f89a1852960@-:13 (lambda)>

proc { |n| n * n } # => #<Proc:0x007f89a18526b8@-:14>

Proc.new { |n| n * n } # => #<Proc:0x007f89a1852438@-:15>

->n{ n * n } # => #<Proc:0x007f89a1852190@-:16 (lambda)>
{% endhighlight %}

挙動に若干の違いがありますがそれは瑣末な問題です。`->`だけ引数の引き渡し方が異なります。よく使われるのは`lambda`ですが個人的には簡潔な`->`をよく使います。

このようにブロックをProcオブジェクトでラップすれば、Methodオブジェクトの場合と同じように変数に代入したり、メソッドに引数として渡したりすることができるようになります。そして`#call`メソッドを呼ぶことでそのブロックが実行される点もMethodオブジェクトと同じです。

{% highlight ruby %}
square = ->n{ n * n }

square.call(3) # => 9

def print_func(arg, fun)
  puts fun.call(arg)
end

print_func(4, square) 

# >> 16
{% endhighlight %}

Procオブジェクトは、Methodオブジェクトと異なり、それ自体には名前がないのでこれを**無名関数**と呼んでもいいでしょう。Procオブジェクトをメソッドの引数に直接引き渡すことで、無名であることがよりはっきりします。

{% highlight ruby %}
def print_func(arg, fun)
  puts fun.call(arg)
end

print_func(4, ->n{ n * n }) 

# >> 16
{% endhighlight %}

## &（アンパサンド）の謎

さて、ここでこの例を先のメソッドにブロックを付する例と比較してみます。

{% highlight ruby %}
def print_func(arg, &fun)
  puts fun.call(arg)
end

print_func(4) { |n| n * n }

# >> 16
{% endhighlight %}

メソッド定義における違いに注目してください。違いはメソッド引数における`&`だけです。そしてこの差異から、「メソッドに付けられたブロックは、&仮引数に渡されるとここでProcオブジェクトに変換されているのではないか」という推測が生まれます。確かめて見ましょう。

{% highlight ruby %}
def print_func(arg, &fun)
+ puts fun.class
end

print_func(4) { |n| n * n }

# >> Proc
{% endhighlight %}

ビンゴでした。つまりこの２つの式は等価で、`&`はブロックをProcオブジェクトに変換するMagic word（呪文）だったのです。

では、ブロック以外のものをこの呪文にかけたらどうなるでしょうか。試しに数字の`3`を渡してみます。

{% highlight ruby %}
def print_func(arg, &fun)
  puts fun.call(arg)
end

print_func(4, &3)

# ~> -:22:in `<main>': wrong argument type Fixnum (expected Proc) (TypeError)
{% endhighlight %}

引数としてProcが期待されているとのエラーメッセージが吐かれました。しかしこれで終わらないのがRubyです。Rubyは&に渡されたものがブロックであろうと何であろうと、そのProcオブジェクトへの変換をまずは試みる、つまりそのオブジェクトを`to_proc`してみるのです。

Fixnum#to_procを定義して、結果を見てみます。

{% highlight ruby %}
class Fixnum
  def to_proc
    ->n{ self ** n }
  end
end

def print_func(arg, &fun)
  puts fun.call(arg)
end

print_func(4, &3)

# >> 81
{% endhighlight %}

Fixnum#to_procに累乗演算をラップしたProcオブジェクトを返すようにしたところ、見事にそれが呼ばれて81という出力が得られました。

因みにMethodオブジェクトには`to_proc`メソッドが定義されている（文字通りMethodオブジェクトをProcオブジェクトに変換するメソッド）ので、&にMethodオブジェクトを渡すこともできます。

{% highlight ruby %}
def square(n)
  n * n
end

sq = method(:square)

def print_func(arg, &fun)
  puts fun.call(arg)
end

print_func(4, &sq)

# >> 16
{% endhighlight %}

## Symbol#to_proc

Rubyではメソッドにブロックを付する代わりに、`& + Symbolオブジェクト`を引数として渡すテクニックが広く使われています。

{% highlight ruby %}
%w(charlie liz george).map(&:capitalize) # => ["Charlie", "Liz", "George"]

require "prime"

(1..50).select(&:prime?) # => [2, 3, 5, 7, 11, 13, 17, 19, 23, 29, 31, 37, 41, 43, 47]
{% endhighlight %}

これらは次のショートカットです。

{% highlight ruby %}
%w(charlie liz george).map { |name| name.capitalize } # => ["Charlie", "Liz", "George"]

(1..50).select { |i| i.prime? } # => [2, 3, 5, 7, 11, 13, 17, 19, 23, 29, 31, 37, 41, 43, 47]
{% endhighlight %}

なぜこのようなことができるのでしょうか。ここまでの説明が正しいのなら、次のような推測ができるはずです。

> 1. &にSymbolオブジェクトが渡されたので、RubyはこれをProcオブジェクトに変換することを試みる。そのためにSymbol#to_procを呼ぶ。
> 
> 2. そしてSymbol#to_procは、ブロック引数に順次渡されるオブジェクト（ここでは'charlie'などのStringオブジェクト）に対し、&に渡されたSymbolオブジェクト（ここでは:capitalize）をメソッドとして呼ぶような実装がなされている。


では、確かめてみましょう。pryのshow-sourceを叩いてCRubyの実装を見てみます。

{% highlight bash %}
pry(main)> show-source Symbol#to_proc

From: string.c (C Method):
Owner: Symbol
Visibility: public
Number of lines: 29

static VALUE
sym_to_proc(VALUE sym)
{
    static VALUE sym_proc_cache = Qfalse;
    enum {SYM_PROC_CACHE_SIZE = 67};
    VALUE proc;
    long id, index;
    VALUE *aryp;

    if (!sym_proc_cache) {
        sym_proc_cache = rb_ary_tmp_new(SYM_PROC_CACHE_SIZE * 2);
        rb_gc_register_mark_object(sym_proc_cache);
        rb_ary_store(sym_proc_cache, SYM_PROC_CACHE_SIZE*2 - 1, Qnil);
    }

    id = SYM2ID(sym);
    index = (id % SYM_PROC_CACHE_SIZE) << 1;

    aryp = RARRAY_PTR(sym_proc_cache);
    if (aryp[index] == sym) {
        return aryp[index + 1];
    }
    else {
        proc = rb_proc_new(sym_call, (VALUE)id);
        aryp[index] = sym;
        aryp[index + 1] = proc;
        return proc;
    }
}
{% endhighlight %}

えー、残念ながら僕はCは読めないので、こういうときはRubiniusに頼ります。

> [rubinius/kernel/common/symbol.rb at master · rubinius/rubinius](https://github.com/rubinius/rubinius/blob/master/kernel/common/symbol.rb "rubinius/kernel/common/symbol.rb at master · rubinius/rubinius")

{% highlight ruby %}
class Symbol

  def to_proc
    sym = self
    Proc.new do |*args, &b|
      raise ArgumentError, "no receiver given" if args.empty?
      args.shift.__send__(sym, *args, &b)
    end
  end
end
{% endhighlight %}

Procの第１引数をオブジェクトとし、`self`をメソッドとして呼んでいるのが分かります{% fn_ref 1 %}。


ではこのコードをもう少し簡単にして`String#to_proc`を定義し、それが機能するかみてみます。

{% highlight ruby %}
class String
  def to_proc
    ->obj{ obj.send(self) }
  end
end

%w(charlie liz george).map(&'capitalize') # => ["Charlie", "Liz", "George"]

require "prime"

(1..50).select(&'prime?') # => [2, 3, 5, 7, 11, 13, 17, 19, 23, 29, 31, 37, 41, 43, 47]
{% endhighlight %}

いいですね。

Symbol#to_procを明示的に呼び出すことは普通ありませんが、このユニークなメソッドを使って次のようなこともできます。

{% highlight ruby %}
:**.to_proc[2, 8] # => 256

:+.to_proc['ruby', 'ist'] # => "rubyist"

:grep.to_proc[['hello', 'world', 'ruby'], /ll/] # => ["hello"]
{% endhighlight %}

## Procの特徴その１: クロージャ

Procオブジェクトはクロージャという性質を持っています。その点がメソッドと異なります。つまりそれは手続きブロックをその環境とともに閉じ込めます。言い換えればメソッドではその中の世界と外の世界は断絶していますが、Procオブジェクトでは中の世界は外の世界の影響を受けます。

次の例を見てください。

{% highlight ruby %}
class X
  n = 2
  %w(a b c).each do |name|
    define_method(name) do
      n += 1
    end
  end
end
{% endhighlight %}

クラスXにおいてeachイテレータとdefine_methodを使ってインスタンスメソッドa, b, cを定義しています。何れのメソッドもnを１インクリメントする実装です。一方でeachの外側にはローカル変数nが定義され2が代入されています。これを実行すると以下のような結果になります。

{% highlight ruby %}
x = X.new
x.a # => 3
x.b # => 4
x.c # => 5
x.a # => 6
x.b # => 7

x2 = X.new
x2.a # => 8
x2.b # => 9
x2.c # => 10
{% endhighlight %}

ローカル変数nがすべてのメソッド（さらには生成されたすべてのオブジェクト）で共有されていることが分かります。次にこれらメソッド定義の後でnに別の値を代入した例を見てみます。

{% highlight ruby %}
class X
  n = 2
  %w(a b c).each do |name|
    define_method(name) do
      n += 1
    end
  end
  n = 10
end

x = X.new
x.a # => 11
x.b # => 12
x.c # => 13
x.a # => 14
x.b # => 15

x2 = X.new
x2.a # => 16
x2.b # => 17
x2.c # => 18
{% endhighlight %}

変化がありました。つまりこれらメソッドはその周囲環境（コンテキスト）によって影響を受けるということです。ここでの例でメソッド内の変数nはeachとdefine_methodにおける二重のブロックを超えてその周囲の影響を受けていることになります。

## Procの特徴その２: カリー化

Procオブジェクトはカリー化することができます。カリー化というのは、複数の引数を取るようなProcオブジェクトがある場合に、それをその一部の引数だけを受けとれるようなものに変えることを言います。そしてカリー化されたProcオブジェクトに一部の引数だけを渡すことを部分適用と言います。例を見たほうがいいでしょう。

まずは、文字列に３種類の接尾語`ist`, `er`, `ian`を付ける３つのメソッドを考えます。こんな感じでしょうか。

{% highlight ruby %}
def join_ist(body)
  body + 'ist'
end

def join_er(body)
  body + 'er'
end

def join_ian(body)
  body + 'ian'
end
{% endhighlight %}

これはDRY原則に反しますから共通の機能を一つのメソッドに括りだします。

{% highlight ruby %}
def join(suffix, body)
  body + suffix
end

def join_ist(body)
  join('ist', body)
end

def join_er(body)
  join('er', body)
end

def join_ian(body)
  join('ian', body)
end
{% endhighlight %}

これを複数の文字に適用してみましょう。各メソッドをMethodオブジェクト化してmapに渡します。

{% highlight ruby %}
%w(real social ruby).map(&method(:join_ist)) # => ["realist", "socialist", "rubyist"]
%w(sell climb haskell).map(&method(:join_er)) # => ["seller", "climber", "haskeller"]
%w(music physic Janis).map(&method(:join_ian)) # => ["musician", "physician", "Janisian"]
{% endhighlight %}

おなじことをProcのカリー化を使って書いてみます。カリー化には`Proc#curry`を呼びます。

{% highlight ruby %}
join = ->suffix,body{ body + suffix }.curry #Procオブジェクトをカリー化する

# カリー化されたProcオブジェクトに一部の引数を部分適用する。
# これにより残りの引数を受けるProcオブジェクトが生成される。
join['ist'] # => #<Proc:0x007fdf011ce1b0 (lambda)>

%w(real social ruby).map(&join['ist']) # => ["realist", "socialist", "rubyist"]
%w(sell climb haskell).map(&join['er']) # => ["seller", "climber", "haskeller"]
%w(music physic Janis).map(&join['ian']) # => ["musician", "physician", "Janisian"]
{% endhighlight %}

カリー化を使うとすべての引数を同時に渡す必要がなくなり自由度が高まります。

## Procの特徴その３: Proc#===

Proc#callのエイリアスとして`Proc#===`が定義されています。これによってcase式のwhen節にProcオブジェクトが渡されると、そこで比較オブジェクトを引数に取ってブロックが評価されることになります。例を見てみます。

{% highlight ruby %}
is_escape = ->chr{ chr.ord == 27 }
is_back = ->chr{ [127, 8].include?(chr.ord) }

chr = 27

case chr
when is_escape then puts :escape
when is_back   then puts :back
else puts :unknown
end

# >> escape
{% endhighlight %}

Proc#===の導入によりより複雑な評価式をwhen節で使えるようになりました。しかもProcに明示的に引数を引き渡す必要がないので見た目がエレガントです。

---

Procオブジェクトに関する僕からの説明は以上です。この記事があなたのProcオブジェクトの理解の助けになれば幸いです。

---

関連記事：

> [落ちていくRubyistのためのMethopオブジェクト]({{ BASE_PATH }}/2014/04/20/extend-ampersand-magic-with-methop/ "落ちていくRubyistのためのMethopオブジェクト")
>
> [RubyにおけるYet Another関数合成]({{ BASE_PATH }}/2014/04/26/yet-another-proc-composer-in-ruby/ "RubyにおけるYet Another関数合成")
>
> [RubyのSymbol#to_procを考えた人になってみる]({{ BASE_PATH }}/2008/09/17/Ruby-Symbol-to_proc/ "RubyのSymbol#to_procを考えた人になってみる")

---

(追記：2014-4-29) 一部記述を修正しました。

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


{% footnotes %}
{% fn ちなみにこのコードではselfを直接ブロック内に渡していませんがその理由がRubiniusのソースには書いてあります。 %}
{% endfootnotes %}

