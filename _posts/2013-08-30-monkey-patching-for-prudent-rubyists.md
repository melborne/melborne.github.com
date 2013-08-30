---
layout: post
title: "分別のあるRubyモンキーパッチャーになるために"
tagline: "I wanna be a prudent ruby-monkey-patcher"
description: ""
category: 
tags: 
date: 2013-08-30
published: true
---
{% include JB/setup %}


Rubyのクラスはオープンです。つまりRubyのユーザが既存のクラスを開いて自由に実装を弄ることができるのです。組み込みクラスとてその例外ではありません。

既存のクラスを開いてメソッドを追加したり再定義したりすることを、業界用語で「モンキーパッチ」といいます。モンキーパッチという語には明らかに批判的・軽蔑的ニュアンスが含まれていますが、多くのRubyistはそれにひるむこと無く良くモンキーパッチします。何しろドアはいつも開いてるんですからねぇ。

##るびおのモンキーパッチ

モンキーパッチャー「るびお」は、製作中のライブラリで多次元配列の要素に頻繁にアクセスする必要が生じました。これには通常、`Array#[]`または`#at`を使って次のようにアクセスします。

{% highlight ruby %}
irb> arr = [[1, 2, 3], [4, 5, 6], [7, 8, 9]]
irb> arr[1][2]
=> 6
irb> arr.at(1).at(2)
=> 6
{% endhighlight %}

３次元配列ならさらに以下のようにします。

{% highlight ruby %}
irb> arr2 = [
      [[1,2,3],[4,5,6],[7,8,9]],
      [[10,11,12],[13,14,15],[16,17,18]],
      [[19,20,21],[22,23,24],[25,26,27]]
      ]
irb> arr2[1][2][0]
=> 16
irb> arr2.at(1).at(2).at(0)
=> 16
{% endhighlight %}

４次元配列なら...。

るびおはこれを面倒と感じました。

そこでこの問題を解消するために、`Array#at`をモンキーパッチして、多次元のインデックスを一度に受け取れるように改良することにしました。

{% highlight ruby %}
irb> arr = [[1,2,3], [4,5,6], [7,8,9]]
irb> arr.at(1,2)
=> 6

irb> arr2 = [
      [[1,2,3],[4,5,6],[7,8,9]],
      [[10,11,12],[13,14,15],[16,17,18]],
      [[19,20,21],[22,23,24],[25,26,27]]
      ]
irb> arr2.at(1,2,0)
=> 16
{% endhighlight %}

##モンキーパッチ ─ その１

取り敢えずのコードができたので、対象のライブラリにおいてArrayをオープンして`#at`をオーバーライドしてみました。

{% highlight ruby %}
class Array
  alias :__at__ :at
  def at(*indices)
    idx = indices.shift
    if indices.empty?
      __at__(idx)
    else
      __at__(idx).at(*indices)
    end
  end
  private :__at__
end

if __FILE__ == $0
  [1,2,3].at(1) # => 2

  [[1,2,3], [4,5,6], [7,8,9]].at(1, 2) # => 6
  arr = [
    [[1,2,3],[4,5,6],[7,8,9]],
    [[10,11,12],[13,14,15],[16,17,18]],
    [[19,20,21],[22,23,24],[25,26,27]]
    ]

  arr.at(1,2,0) # => 16
end
{% endhighlight %}

オリジナルの#atをaliasを使って#\_\_at\_\_に退避させ、再定義の#atにおいて間接的に呼べるようにしました。#atの実装では、引数が１つならオリジナルの#atの結果を返すようにし、そうでない場合は、引数がなくなるまで再帰的に#atを呼ぶようにしました。さらに#\_\_at\_\_をprivate指定してライブラリのユーザが呼べないようにも配慮しました。

##モンキーパッチ ─ その２

ここでるびおは何かの本に、「モンキーパッチするなら、その意図がより明瞭になるようメソッドをモジュールに定義してincludeするのが儀礼上良い。」といったようなことが書いてあったことを思い出しました。これに従い、ArrayExtensionモジュールに#atを定義しincludeするようにしてみました。

{% highlight ruby %}
module ArrayExtension
  alias :__at__ :at
  def at(*indices)
    idx = indices.shift
    if indices.empty?
      __at__(idx)
    else
      __at__(idx).at(*indices)
    end
  end
  private :__at__
end

Array.send(:include, ArrayExtension)
{% endhighlight %}

しかしこれを実行してみると、以下のエラーが出力されてしまいました。

{% highlight ruby %}
core_ext.rb:2:in `<module:ArrayExtension>': undefined method `at' for module `ArrayExtension' (NameError)
        from core_ext.rb:1:in `<main>'
{% endhighlight %}

当然といえば当然です。ArrayExtensionモジュールにはオリジナルの#atメソッドなんて存在しないのですからね。また仮にオリジナルの#atに頼らないで新たな#atを実装したとしても、これはうまくいきません。includeはArrayの後ろ（継承上位）にこのモジュールを差し込むので、結局、それはオリジナルの#atで上書きされてしまうからです。

この手法は、Arrayに未定義のメソッドを追加する場合にしか使えなさそうです。


るびおが結果に落胆していると、そこに天から一条の光が差し込みました。そしてその光の中から次のような声が聞こえて来たのです。

<br />

---

<span style="color:#E50086">メグ</span>「るびお君、やっぱりまだまだね。後ろがだめなら、前に刺せばいいのよ。あんたまさか未だに`1.9.3`なんてことないわよね。」

<span style="color:#6BBF3F">るびお</span>「げっ！メグっ...」

> 参照：[Rubyのメソッドを数えましょう♫]({{ site.url }}/2013/08/27/count-methods-of-ruby/ "Rubyのメソッドを数えましょう♫")

---

##モンキーパッチ ─ その３

天の声（？）に従い、るびおはモジュールをクラスの前に差す方法を模索しました。そしてRuby2.0の中に見つけたのです。

`Module#prepend`を。

るびおは#atの実装を調整し、ArrayにArrayExtensionをprependしました。

{% highlight ruby %}
module ArrayExtension
  def at(*indices)
    idx = indices.shift
    if indices.empty?
      super(idx)
    else
      super(idx).at(*indices)
    end
  end
end

Array.send(:prepend, ArrayExtension)
{% endhighlight %}

ArrayExtension#atはオリジナルのArray#atの前（継承下位）に位置します。そのため、その実装においてArray#atを`super`で呼び出すことができます。オリジナルをaliasで退避させる必要がないのです。

<br />


るびおは暫し目的を達成した充実感に浸っていました。するとそこにまた、天から一条の光が差し込み、あの声が再び聞こえて来たのです。


<br />

---

<span style="color:#E50086">メグ</span>「るびお君、あんたそれでライブラリ利用者への配慮はOKだなんて思ってるの？あんたの実装怪しいから変なエラーでも吐くんじゃないの？」

{% highlight ruby %}
module ArrayExtension
  def at(*indices)
    idx = indices.shift
    if indices.empty?
      super(idx)
    else
      super(idx).at(*indices)
    end
  end
end

Array.send(:prepend, ArrayExtension)


if __FILE__ == $0
  [1,2,3].at(1, 2) # => 
# ~> -:7:in `at': undefined method `at' for 2:Fixnum (NoMethodError)
# ~> 	from -:16:in `<main>'
end
{% endhighlight %}

<span style="color:#E50086">メグ</span>「やっぱり。`undefined method 'at' for 2:Fixnum (NoMethodError)`って、意味不明じゃない。だからそんなダメ実装の拡張はあんただけのものにしときなさいよ。」

<span style="color:#6BBF3F">るびお</span>「ぐっ...」

---


##モンキーパッチ ─ その４


再び天の声（？）に従い、るびおはモジュールによる影響を限定する方法を模索しました。そして再びRuby2.0の中に見つけたのです。

`Module#refine + main.using（Refinements）`を。


るびおは#atの実装を`Module#refine(Array)`でラップし、そのArrayExtensionモジュールをこの拡張を使うファイルのトップレベルで`using`しました。

{% highlight ruby %}
module ArrayExtension
  refine Array do
    def at(*indices)
      idx = indices.shift
      if indices.empty?
        super(idx)
      else
        super(idx).at(*indices)
      end
    end
  end
end

using ArrayExtension

if __FILE__ == $0
  [[1,2,3], [4,5,6], [7,8,9]].at(1, 2) # => 6

  arr = [
    [[1,2,3],[4,5,6],[7,8,9]],
    [[10,11,12],[13,14,15],[16,17,18]],
    [[19,20,21],[22,23,24],[25,26,27]]
    ]

  arr.at(1,2,0) # => 16

  [1, 2, 3].at(1, 2) # => 
# ~> -:8:in `at': undefined method `at' for 2:Fixnum (NoMethodError)
# ~> 	from -:31:in `<main>'
end
{% endhighlight %}

これによりArrayExtensionモジュールで定義した#atは、その影響範囲において２つの制約を受けることになります。つまり`refine(Array)`によって、ArrayExtensionがincludeされるクラスに拘らず#atはArrayのみのメソッドになり、また明示的に`using`をしていないファイルではArrayExtension#atは呼び出せないようになるのです（言い換えればusingをしたファイルをrequireやloadしてもその効果は無効です）。


るびおは先のコードを含む`core_ext.rb`をrequireしたユーザのファイルuser_code.rbを用意してRefinementsの効果を試してみました。

{% highlight ruby %}
require "core_ext"
 # !> Refinements are experimental, and the behavior may change in future versions of Ruby!
[1,2,3].at(1) # => 2

[1,2,3].at(1, 2) # => 
# ~> -:5:in `at': wrong number of arguments (2 for 1) (ArgumentError)
# ~> 	from -:5:in `<main>'
{% endhighlight %}

Array#atの適切なエラーメッセージが吐かれ、ArrayExtension#atの拡張は適用されていないことが確認できました。

るびおは更に、ArrayExtensionにrefineの制約を受けないメソッド（#everywhere）を追加し、ユーザコード側でArrayExtensionをincludeし、それだけが呼び出せるか試してみました。

{% highlight ruby %}
#core_ext.rb
module ArrayExtension
  refine Array do
    def at(*indices)
      idx = indices.shift
      if indices.empty?
        super(idx)
      else
        super(idx).at(*indices)
      end
    end
  end

  def everywhere
    :this_return_everywhere
  end
end

using ArrayExtension
{% endhighlight %}

{% highlight ruby %}
#user_code.rb
require "./core_ext"
 # !> Refinements are experimental, and the behavior may change in future versions of Ruby!
include ArrayExtension

everywhere # => :this_return_everywhere

[1,2,3].at(1) # => 2

[1,2,3].at(1, 2) # => 
# ~> -:10:in `at': wrong number of arguments (2 for 1) (ArgumentError)
# ~> 	from -:10:in `<main>'
{% endhighlight %}

こうしてるびおはまた一歩、分別のあるRubyistの道を進むことができたとの満足感に浸っているのでした。するとそこに三度、天から一条の光が差し(ry



---

<span style="color:#E50086">メグ</span>「るびお君、あなたまた大事なこといい忘れてるわよ。Rubyの吐くメッセージちゃんと見てるの？それともこんな簡単な英語も読めないの？まったく。あたしが訳してあげるわ。」

{% highlight ruby %}
 # !> Refinements are experimental, and the behavior may change in future versions of Ruby!
 （意訳：あんたらこの実装信じたら、将来痛い目見るよ。）
{% endhighlight %}

<span style="color:#6BBF3F">るびお</span>「...」


---


参考： [instance method Module#refine](http://doc.ruby-lang.org/ja/2.0.0/method/Module/i/refine.html "instance method Module#refine")


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

