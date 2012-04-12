---
layout: post
title: RubyでもErlangの[H|T]したいよ!
date: 2011-08-15
comments: true
categories:
---


「プログラミングErlang」(Joe Armstrong著/榊原一矢訳)
という本でちょっとErlangの世界を覗いているよ

{{ '4274067149' | amazon_large_image }}

{{ '4274067149' | amazon_link }}

{{ '4274067149' | amazon_authors }}

Erlangのような関数型言語はリスト処理に優れていて
便利な構文がいろいろとあるんだね
例えばリストの先頭に別の要素を結合したものを
 | を使って簡単に作れるんだ
{% highlight erl %}
1> Langs = [haskell, erlang, lisp].
[haskell,erlang,lisp]
2> NewLangs = [ruby | Langs].
[ruby,haskell,erlang,lisp]
{% endhighlight %}
[ruby | Langs] のところが
リストへの要素の追加になってるよ
ちなみにErlangでは変数は大文字で始まって
アトム{% fn_ref 1 %}は引用符なしで書けるんだ
また式の終りには英語のようにピリオドを付けるよ

一方でリストから先頭要素を分離したものを作るには
次のようにするよ
{% highlight erl %}
3> [H|T] = Newlangs. 
[ruby,haskell,erlang,lisp]
4> H.
ruby
5> T.
[haskell,erlang,lisp]
6> 
{% endhighlight %}
変数Hにリストの先頭要素がバインドされて
変数Tにリストの残りがバインドされる

この何がうれしいかって言うと
これでリストの再帰的な処理が
すごく簡単に書けるんだよ
試しにリストの要素を足し合わせる
sum関数を定義してみるね
{% highlight erl %}
sum([], N) -> N;
sum([H|T], N) -> sum(T, H+N).
sum([1,2,3,4,5], 0).
=> 15
{% endhighlight %}
リストが空のときは第２引数Nを返す
そうでないときは先頭要素HをNに足して
残りのリストTでsum関数を再帰する
簡潔でカッコイイよねー

リストの要素に関数を適用する
map関数も書いてみるよ
{% highlight erl %}
map([], _) -> [];
map([H|T], F) -> [F(H)|map(T,F)].
map([1,2,3,4,5], fun(X)->X*X end).
=> [1,4,9,16,25]
{% endhighlight %}
リストが空のときは空リストを返す
そうでないときは先頭要素Hに関数Fを適用し
一方で残りのリストTでmap関数を再帰し
これらを結合してできるリストを返す
つまりここでは[H|T]を使って
リストの分離と結合をしてる
素敵だねー
ちなみにfun(X)->X*X end は
Rubyのlambdaにそっくりだよね

###Rubyでやってみる
で
これを見てRubyでも | で
リストの結合や分離ができたら
カッコイイと思ったんだ

じゃあ少しやってみるね
Object#| を定義するといろいろと問題がありそうなので
ここではFixnum String Symbolに対象を絞って実装するよ
{% highlight ruby %}
[String, Symbol].each do |klass|
  klass.module_eval do
    def |(other)
      [self] + other
    end
  end
end
class Fixnum
  alias :__OR__ :|
  def |(other)
    case other
    when Array; [self] + other
    else __OR__(other)
    end
  end
end
list = [2,3,4]
'a' | list # => ["a", 2, 3, 4]
:a | list # => [:a, 2, 3, 4]
1 | list # => [1, 2, 3, 4]
1 | 3 # => 3
{% endhighlight %}
これでリストの結合ができた
どうかな？

次にリストの分離だけれど
Array#| を再定義して引数にIntegerが渡されたら
先頭要素を分離するというのを考えたんだけど
なんかスマートじゃないんだ

で
ここでハタと気が付いたんだけど
Rubyには既にカッコイイ分離方法があったんだよ
{% highlight ruby %}
list = [1, 2, 3, 4, 5]
a, *b = list
a # => 1
b # => [2, 3, 4, 5]
{% endhighlight %}
Rubyの多重代入はリストの分離に使えるんだ

さて
Rubyでも再帰を使ってsumとmapを定義してみよう
Rubyはオブジェクト指向だから
Arrayのメソッドとしてこれらを定義するよ
まずは先の定義を使わない例を示すよ
{% highlight ruby %}
class Array
  alias :head :first
  def tail
    drop 1
  end
  def sum(acc=0)
    return acc if empty?
    tail.sum(head+acc)
  end
  def mappy(&blk)
    return [] if empty?
    [blk[head]] + tail.mappy(&blk)
  end
end
[*1..10].sum # => 55
[*1..5].mappy { |i| i * i } # => [1, 4, 9, 16, 25]
%w(ruby erlang haskell lisp).mappy { |n| n.capitalize } # => ["Ruby", "Erlang", "Haskell", "Lisp"]
{% endhighlight %}
ここではリストの先頭を返すheadメソッドと
残りを返すtailメソッドを別途定義しているよ

次に
先に定義した | と多重代入を使った
ヴァージョンを示すよ
{% highlight ruby %}
class Array
  def sum(acc=0)
    return acc if empty?
    head, *tail = self
    tail.sum(head+acc)
  end
  def mappy(&blk)
    return [] if empty?
    head, *tail = self
    blk[head] | tail.mappy(&blk)
  end
end
[*1..10].sum # => 55
[*1..5].mappy { |i| i * i } # => [1, 4, 9, 16, 25]
%w(ruby erlang haskell lisp).mappy { |n| n.capitalize } # => ["Ruby", "Erlang", "Haskell", "Lisp"]
{% endhighlight %}
できたよ!

って
変数名にheadとtailを使ったからか
なんか見た目に違いがなくて
あんまり面白くなかったね..

でもRubyの多重代入が
リストのheadとtailの分離に使えることに
気づけたから僕自身は良しとするよ

(追記:2010-8-16)RubyのArray#sumをErlangのsumに合わせて末尾再帰版に修正しました
{% footnotes %}
   {% fn Rubyのシンボルのようなもの %}
{% endfootnotes %}
