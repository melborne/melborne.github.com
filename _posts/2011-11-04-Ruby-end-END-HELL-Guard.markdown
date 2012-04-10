---
layout: post
title: Rubyのendは美の観点から必要だ。END HELLは要リファクタへの警告である。メソッド分離、{ }、Guard、三項、ポリモーフィズムで回避せよ！
date: 2011-11-04
comments: true
categories:
---


Rubyのendは構文上の欠点だとされ
一部のRubyistから
END HELLと忌み嫌われている

その一方でRubyのendを愛し
endを綴り続けることで
悟りの境地に達したRubyistもいる
> 
>   Rubyistは一日に何度もendと書くことで、
>   何事にも終わりがあることを日々確認しているのである
>   by @nalsh{% fn_ref 1 %}


そしてこの私はというと
見習うべきRubyistの姿がそこにあるのに
defと打つと私のエディタが勝手にendと補完するので
物事の終わりも確認できず
醜いendの連なりだけを毎日目にする
という虚しい日々を送っている

結局未熟な私はendの悟りを開くことができず
かつて誤った道に足を踏み入れた

[Ruby1.9でもEND HELLを解消したい！](/2011/07/19/Ruby1-9-END-HELL/)

###endの必要性
しかし私は対称性という様式美の観点から
Rubyのendは重要な役割を果たしていることを知っている

開いたら閉じなければいけない
左足を下ろしたら右足も下ろさなければいけない
おもちゃを出したら片付けなければいけない

つまり対称性とは礼儀の作法である
つまりRubyのendはニッポンの心であり
私はRubyistがその文化の継承者であることを知っている{% fn_ref 2 %}

このように美の観点から論じると
endはその構造的文化的背景により
プログラミングには欠かせない
必須のエレメントであることが理解できるだろう

###問題の所在
しかしそうは言っても次のようなendの連なりには
若干の問題を感じざるを得ない
{% highlight ruby %}
module MyModule
  class MyClass
    def my_method
      10.times do
        if rand < 0.5
          p :small
        else
          p :large
        end
      end 
    end      <- ここ
  end
end
MyModule::MyClass.new.my_method # => 10
# >> :large
# >> :large
# >> :large
# >> :large
# >> :small
# >> :small
# >> :large
# >> :small
# >> :large
# >> :large
{% endhighlight %}

このようなendの連なりは
むしろその形式美を破壊し
その可読性を著しく阻害する

しかしこの問題の責務は
言語としてのRubyにあるのではなく
実のところあなたにあるのである
そう　あなたの書いたコードに問題があるのである
先のコードはリファクタリングが必要なのである

実はこれはRubyには意図されたことである
つまりRubyはあなたがEND HELLを量産すると
コードの美が破壊されるように設計されており
これによってあなたに
要リファクタリングの警告を発していたのである!

###許容end個数
さて先のコードに
リファクタリングが必要なことはわかった
リファクタリングに際しまずは
許容end個数すなわち美を破壊しないendの連なり個数
がいくつであるのかを知ることが重要である

一般に許容end個数は
end対語平均語長未満とされるから
以下のように求められるだろう
{% highlight ruby %}
heads = %w(class module def if unless case while until for begin do)
heads.map(&:size).inject(:+)/heads.size.to_f # => 4.181818181818182
{% endhighlight %}
つまりendの連なりは４つ
理想的には３つ以下である
詳細はJIS X 3017(8.7.2: キーワード)を参照されたい{% fn_ref 3 %}

###END HELLの回避方法
具体的なコードによってEND HELLの回避方法は変わるが
ここでは先のコードにおける
END HELLの回避方法をいくつか示すに留める
###その１: 三項条件演算子
if else end式に代えて?:三項条件演算子を使う
{% highlight ruby %}
module MyModule
  class MyClass
    def my_method
      10.times do
        p rand < 0.5 ? :small : :large
      end 
    end
  end
end
{% endhighlight %}
###その２: { }(curly braces:波括弧)
do endに代えて{ }を使う
{% highlight ruby %}
module MyModule
  class MyClass
    def my_method
      10.times { p rand < 0.5 ? :small : :large }
    end
  end
end
{% endhighlight %}
###その３:メソッド呼び出し
if else end式に代えてメソッド呼び出しを使う
{% highlight ruby %}
module MyModule
  class MyClass
    def my_method
      10.times { p [:small, :large][rand.round] }
    end
  end
end
{% endhighlight %}
###その４:メソッド分割
メソッドを分割する
{% highlight ruby %}
module MyModule
  class MyClass
    def my_method
      10.times { p small_or_large(0.5) }
    end
    
    private
    def small_or_large(weight)
      rand < weight ? :small : :large
    end
  end
end
{% endhighlight %}
###その５:ガード文
if else end式に代えてガード文を使う(ここではnext)
{% highlight ruby %}
module MyModule
  class MyClass
    def my_method
      10.times do
        next p :small if rand < 0.5
        p :large
      end 
    end
  end
end
{% endhighlight %}
###その６:ポリモーフィズム
if else end式に代えてポリモーフィズムを使う
{% highlight ruby %}
class Float
  def size
    [:small, :large][self.round]
  end
end
module MyModule
  class MyClass
    def my_method
      10.times {
        p rand.size
      } 
    end
  end
end
{% endhighlight %}
###その７:定数スコープ演算子
定数のスコープ演算子::を使う
{% highlight ruby %}
module MyModule; end
class MyModule::MyClass
  def my_method
    10.times {
      p rand.size
    } 
  end
end
{% endhighlight %}

以上まとめると
END HELLはRubyのせいではなく
あなたのせいであり
したがってあなたのコードをリファクタして
直ちにEND HELLを回避せよ！
{% footnotes %}
   {% fn https://twitter.com/#!/nalsh/statuses/105432772570656768 %}
   {% fn まったく訳がわからない %}
   {% fn http://www.webstore.jsa.or.jp/webstore/Com/FlowControl.jsp?lang=jp&bunsyoId=JIS+X+3017%3A2011&dantaiCd=JIS&status=1 %}
{% endfootnotes %}
