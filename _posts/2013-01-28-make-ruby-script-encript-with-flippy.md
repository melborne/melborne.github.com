---
layout: post
title: "RubyのコードをFlipして暗号化する？"
tagline: "¿ʎddᴉlℲ ɥʇᴉʍ ʇdʎɹɔuƎ ʇdᴉɹɔS ʎqnᴚ ɐ əʞɐW"
description: ""
category: 
tags: 
date: 2013-01-28
published: true
---
{% include JB/setup %}



前の記事で「twitter→ɹəʇʇɪʍʇのように英数字を180度回転して表示する」スクリプトをRubyで書いたのですが、実装が今ひとつでしたので、スクリプト自身に変換テーブルを持たせたシンプルな設計に書き直しました。Flippyという名前も付けました。

Gem化もしたので、`gem install flippy`で使うことができます。

> [flippy | RubyGems.org | your community gem host](https://rubygems.org/gems/flippy 'flippy | RubyGems.org | your community gem host')
>
> [melborne/flippy · GitHub](https://github.com/melborne/flippy 'melborne/flippy · GitHub')

##Flippyモジュールの使い方
<Del>FlippyモジュールはStringクラスにincludeするなどして使います。</Del>（flippyをrequireすればStringにincludeされるよう仕様を変更しました）。その場合、Stringに`#flip`および`#unflip`メソッドを追加します。`flip`は文字列を180度反転したような文字列をマッピングし、`unflip`はそれを元に戻します。

{% highlight ruby %}
require 'flippy'
String.send(:include, Flippy)

flipped = "Ruby is a fantastic language!!".flip # => "¡¡əɓɐnɓuɐl ɔᴉʇsɐʇuɐɟ ɐ sᴉ ʎqnᴚ"

flipped.unflip # => "Ruby is a fantastic language!!"

flipped = "Please call me at (03)1234-5678".flip # => "8L95-ᔭεƧ⇂(ε0) ʇɐ əɯ llɐɔ əsɐəlԀ"

flipped.unflip # => "Please call me at (03)1234-5678"
{% endhighlight %}

改行にも対応しているので、プログラムコードを反転させることもできます。コードを文字列として書いて、flipして出力します。
{% highlight ruby %}
require './flippy'

code =<<CODE
# encoding: UTF-8
class Employee
  attr_accessor :name, :title, :department
  def initialize(name, title, department)
    @name = name
    @title = title
    @department = department
  end
  
  def profile
    "%s is %s at %s dept." % [name, title, department]
  end
end

charlie = Employee.new('Charlie', :programmer, :Game)

puts charlie.profile
CODE

puts flipped = code.flip
{% endhighlight %}

結果は次の通り。

{% highlight text %}
                                                      
                                  əlᴉɟoɹd˙əᴉlɹɐɥɔ sʇnd
                                                      
 (əɯɐ⅁: ‘ɹəɯɯɐɹɓoɹd: ‘'əᴉlɹɐɥƆ')ʍəu˙əəʎoldɯƎ = əᴉlɹɐɥɔ
                                                      
                                                   puə
                                                 puə  
[ʇuəɯʇɹɐdəp ‘əlʇᴉʇ ‘əɯɐu] % "˙ʇdəp s% ʇɐ s% sᴉ s%"    
                                         əlᴉɟoɹd ɟəp  
                                                      
                                                 puə  
                          ʇuəɯʇɹɐdəp = ʇuəɯʇɹɐdəp@    
                                    əlʇᴉʇ = əlʇᴉʇ@    
                                      əɯɐu = əɯɐu@    
             (ʇuəɯʇɹɐdəp ‘əlʇᴉʇ ‘əɯɐu)əzᴉlɐᴉʇᴉuᴉ ɟəp  
            ʇuəɯʇɹɐdəp: ‘əlʇᴉʇ: ‘əɯɐu: ɹossəɔɔɐ‾ɹʇʇɐ  
                                        əəʎoldɯƎ ssɐlɔ
                                      8-Ⅎ⊥Ո :ɓuᴉpoɔuə #
{% endhighlight %}

文字列は反転すると同時に右寄せされます。

今度は`unflip`でこの文字列を元に戻します。併せてその文字列をevalして正しく元に戻っているか確認します。

{% highlight ruby %}
flipped = code.flip

puts unflipped = flipped.unflip

puts "evaluate".center(20, '-')
puts eval unflipped
{% endhighlight %}

出力です。

{% highlight ruby %}
# encoding: UTF-8                                      
 class Employee                                        
   attr_accessor :name, :title, :department            
   def initialize(name, title, department)             
     @name = name                                      
     @title = title                                    
     @department = department                          
   end                                                 
                                                       
   def profile                                         
     "%s is %s at %s dept." % [name, title, department]
   end                                                 
 end                                                   
                                                       
 charlie = Employee.new('Charlie', :programmer, :Game) 
                                                       
 puts charlie.profile                                  
                                                        
------evaluate------
Charlie is programmer at Game dept.

{% endhighlight %}
いいですね！

変換テーブルは`Flippy.table`で見ることができます。
{% highlight ruby %}
puts Flippy.table
{% endhighlight %}

出力です。
{% highlight ruby %}
A(U+0041) => ᗄ(U+15c4)
B(U+0042) => ᗺ(U+15fa)
C(U+0043) => Ɔ(U+0186)
D(U+0044) => ᗡ(U+15e1)
E(U+0045) => Ǝ(U+018e)
F(U+0046) => Ⅎ(U+2132)
G(U+0047) => ⅁(U+2141)
H(U+0048) => H(U+0048)
I(U+0049) => I(U+0049)
J(U+004a) => ᒋ(U+148b)
K(U+004b) => 丬(U+4e2c)
L(U+004c) => ⅂(U+2142)
M(U+004d) => W(U+0057)
N(U+004e) => N(U+004e)
O(U+004f) => O(U+004f)
P(U+0050) => Ԁ(U+0500)
Q(U+0051) => Ό(U+038c)
R(U+0052) => ᴚ(U+1d1a)
S(U+0053) => S(U+0053)
T(U+0054) => ⊥(U+22a5)
U(U+0055) => Ո(U+0548)
V(U+0056) => Λ(U+039b)
W(U+0057) => M(U+004d)
X(U+0058) => X(U+0058)
Y(U+0059) => ⅄(U+2144)
Z(U+005a) => Z(U+005a)
a(U+0061) => ɐ(U+0250)
b(U+0062) => q(U+0071)
c(U+0063) => ɔ(U+0254)
d(U+0064) => p(U+0070)
e(U+0065) => ə(U+0259)
f(U+0066) => ɟ(U+025f)
g(U+0067) => ɓ(U+0253)
h(U+0068) => ɥ(U+0265)
i(U+0069) => ᴉ(U+1d09)
j(U+006a) => ɾ(U+027e)
k(U+006b) => ʞ(U+029e)
l(U+006c) => l(U+006c)
m(U+006d) => ɯ(U+026f)
n(U+006e) => u(U+0075)
o(U+006f) => o(U+006f)
p(U+0070) => d(U+0064)
q(U+0071) => b(U+0062)
r(U+0072) => ɹ(U+0279)
s(U+0073) => s(U+0073)
t(U+0074) => ʇ(U+0287)
u(U+0075) => n(U+006e)
v(U+0076) => ʌ(U+028c)
w(U+0077) => ʍ(U+028d)
x(U+0078) => x(U+0078)
y(U+0079) => ʎ(U+028e)
z(U+007a) => z(U+007a)
0(U+0030) => 0(U+0030)
1(U+0031) => ⇂(U+21c2)
2(U+0032) => Ƨ(U+01a7)
3(U+0033) => ε(U+03b5)
4(U+0034) => ᔭ(U+152d)
5(U+0035) => 5(U+0035)
6(U+0036) => 9(U+0039)
7(U+0037) => L(U+004c)
8(U+0038) => 8(U+0038)
9(U+0039) => 6(U+0036)
.(U+002e) => ˙(U+02d9)
,(U+002c) => ‘(U+2018)
-(U+002d) => -(U+002d)
:(U+003a) => :(U+003a)
;(U+003b) => ؛(U+061b)
!(U+0021) => ¡(U+00a1)
?(U+003f) => ¿(U+00bf)
&(U+0026) => ⅋(U+214b)
((U+0028) => )(U+0029)
)(U+0029) => ((U+0028)
<(U+003c) => >(U+003e)
>(U+003e) => <(U+003c)
[(U+005b) => ](U+005d)
](U+005d) => [(U+005b)
_(U+005f) => ‾(U+203e)
‾(U+203e) => _(U+005f)
{(U+007b) => }(U+007d)
}(U+007d) => {(U+007b)
∴(U+2234) => ∵(U+2235)
∵(U+2235) => ∴(U+2234)
{% endhighlight %}


これでRubyのコードを機械知れず安全に暗号化および復号化できるようになりましたね！？

対面に座った上司からのコードレビューもこれで簡単になりますね！？

## flippyコマンド
flippyコマンドも用意しました。

{% highlight bash %}
% flippy Hello, world! 
¡plɹoʍ ‘olləH
{% endhighlight %}

`-u`オプションで反転文字を基に戻します。
{% highlight bash %}
% flippy -u ¡plɹoʍ ‘olləH
Hello, world!
{% endhighlight %}


{% highlight bash %}
% flippy -t
A(U+0041) => ᗄ(U+15c4)
B(U+0042) => ᗺ(U+15fa)
C(U+0043) => Ɔ(U+0186)
D(U+0044) => ᗡ(U+15e1)
E(U+0045) => Ǝ(U+018e)
F(U+0046) => Ⅎ(U+2132)
G(U+0047) => ⅁(U+2141)
H(U+0048) => H(U+0048)
I(U+0049) => I(U+0049)
J(U+004a) => ᒋ(U+148b)
K(U+004b) => 丬(U+4e2c)
L(U+004c) => ⅂(U+2142)
M(U+004d) => W(U+0057)
N(U+004e) => N(U+004e)
O(U+004f) => O(U+004f)
P(U+0050) => Ԁ(U+0500)
Q(U+0051) => Ό(U+038c)
R(U+0052) => ᴚ(U+1d1a)
S(U+0053) => S(U+0053)
T(U+0054) => ⊥(U+22a5)
U(U+0055) => Ո(U+0548)
V(U+0056) => Λ(U+039b)
W(U+0057) => M(U+004d)
X(U+0058) => X(U+0058)
          .
          .
          .
{% endhighlight %}

以上です。

¡ʎqnᴚ ɥʇᴉʍ ɓuᴉʞɔɐH ʎddɐH

{% gist 4653455 %}

---

関連記事：

> {% hatebu http://melborne.github.com/2013/01/28/make-ruby-script-encript-with-flippy/ "RubyのコードをFlipして暗号化する？" %}
>
> {% hatebu http://melborne.github.com/2013/02/04/add-kernel-stnd-to-flippy-gem/ "flippy gemにKernel#stndを追加しましたので、お知らせします。" %}
>
> {% hatebu http://melborne.github.com/2013/02/19/flippy-console-now-added/ "flippy consoleで上下反転文字の不思議な感覚を味わってみませんか？" %}

---

電子書籍でRuby始めてみませんか？

> [M'ELBORNE BOOKS]({{ site.url }}/books/ 'M'ELBORNE BOOKS')


(追記：2013-01-29) FlippyのGem化に合わせて内容を加筆・修正しました。
(追記：2013-03-18) FlippyのUpdateに合わせて内容を修正しました。

