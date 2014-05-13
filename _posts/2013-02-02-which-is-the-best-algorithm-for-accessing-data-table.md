---
layout: post
title: "RubyでASCII文字変換表にアクセスするとき、あなたはどうしてますか？"
description: ""
category: 
tags: 
date: 2013-02-02
published: true
---
{% include JB/setup %}


##─　問題　─

ASCII文字群を格納した配列Ａと、各ASCII文字に対応した上下反転文字群を格納した配列Ｂがある。

{% highlight ruby %}
# encoding: UTF-8
A = ["A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z", "a", "b", "c", "d", "e", "f", "g", "h", "i", "j", "k", "l", "m", "n", "o", "p", "q", "r", "s", "t", "u", "v", "w", "x", "y", "z", "0", "1", "2", "3", "4", "5", "6", "7", "8", "9", ".", ",", "-", ":", ";", "!", "?", "&", "(", ")", "<", ">", "[", "]", "_", "‾", "{", "}", "∴", "∵", " "]

B = ["ᗄ", "ᗺ", "Ɔ", "ᗡ", "Ǝ", "Ⅎ", "⅁", "H", "I", "ᒋ", "丬", "⅂", "W", "N", "O", "Ԁ", "Ό", "ᴚ", "S", "⊥", "Ո", "Λ", "M", "X", "⅄", "Z", "ɐ", "q", "ɔ", "p", "ə", "ɟ", "ɓ", "ɥ", "ᴉ", "ɾ", "ʞ", "l", "ɯ", "u", "o", "d", "b", "ɹ", "s", "ʇ", "n", "ʌ", "ʍ", "x", "ʎ", "z", "0", "⇂", "Ƨ", "ε", "ᔭ", "5", "9", "L", "8", "6", "˙", "‘", "-", ":", "؛", "¡", "¿", "⅋", ")", "(", ">", "<", "]", "[", "‾", "_", "}", "{", "∵", "∴", " "]
{% endhighlight %}

ＡおよびＢを使って、ASCII文字を対応する上下反転文字に変換するメソッド`flip`、およびその上下反転文字を元のASCII文字に戻すメソッド`unflip`を定義せよ。


<br />

##─　僕のやり方１　─
`Array#index`でＡにおける文字の位置を求め、`Array#at`でＢにおける対応位置の文字を取る。

####flip.rb
{% highlight ruby %}
def flip(chr)
  B.at A.index(chr)
end

def unflip(chr)
  A.at B.index(chr)
end

_B = A.map { |chr| flip chr }
_A = _B.map { |chr| unflip chr }

B == _B # => true
A == _A # => true

flipped = "Ruby is fun!".chars.map { |chr| flip chr }.join.reverse # => "¡unɟ sᴉ ʎqnᴚ"
flipped.chars.map { |chr| unflip chr }.join.reverse # => "Ruby is fun!"
{% endhighlight %}

<br />

##─　僕のやり方２　─
`Array#zip`で対応文字のペアを作り、`Array#assoc`で検索する。unflipでは`Array#rassoc`を使う。

{% highlight ruby %}
T = A.zip(B) # => [["A", "ᗄ"], ["B", "ᗺ"], ["C", "Ɔ"], ["D", "ᗡ"], ["E", "Ǝ"], ["F", "Ⅎ"], ["G", "⅁"], ["H", "H"], ["I", "I"], ["J", "ᒋ"], ["K", "丬"], ["L", "⅂"], ["M", "W"], ["N", "N"], ["O", "O"], ["P", "Ԁ"], ["Q", "Ό"], ["R", "ᴚ"], ["S", "S"], ["T", "⊥"], ["U", "Ո"], ["V", "Λ"], ["W", "M"], ["X", "X"], ["Y", "⅄"], ["Z", "Z"], ["a", "ɐ"], ["b", "q"], ["c", "ɔ"], ["d", "p"], ["e", "ə"], ["f", "ɟ"], ["g", "ɓ"], ["h", "ɥ"], ["i", "ᴉ"], ["j", "ɾ"], ["k", "ʞ"], ["l", "l"], ["m", "ɯ"], ["n", "u"], ["o", "o"], ["p", "d"], ["q", "b"], ["r", "ɹ"], ["s", "s"], ["t", "ʇ"], ["u", "n"], ["v", "ʌ"], ["w", "ʍ"], ["x", "x"], ["y", "ʎ"], ["z", "z"], ["0", "0"], ["1", "⇂"], ["2", "Ƨ"], ["3", "ε"], ["4", "ᔭ"], ["5", "5"], ["6", "9"], ["7", "L"], ["8", "8"], ["9", "6"], [".", "˙"], [",", "‘"], ["-", "-"], [":", ":"], [";", "؛"], ["!", "¡"], ["?", "¿"], ["&", "⅋"], ["(", ")"], [")", "("], ["<", ">"], [">", "<"], ["[", "]"], ["]", "["], ["_", "‾"], ["‾", "_"], ["{", "}"], ["}", "{"], ["∴", "∵"], ["∵", "∴"], [" ", " "]]

def flip(chr)
  T.assoc(chr)[1]
end

def unflip(chr)
  T.rassoc(chr)[0]
end

_B = A.map { |chr| flip chr }
_A = _B.map { |chr| unflip chr }

B == _B # => true
A == _A # => true

flipped = "Ruby is fun!".chars.map { |chr| flip chr }.join.reverse # => "¡unɟ sᴉ ʎqnᴚ"
flipped.chars.map { |chr| unflip chr }.join.reverse # => "Ruby is fun!"
{% endhighlight %}

<br />

##─　僕のやり方３　─
`Array#zip`で対応文字のペアを作り、`Enumerable#find`（または#detect）で検索する。

{% highlight ruby %}
T = A.zip(B)

def flip(chr)
  T.find { |a,b| a == chr }[1]
end

def unflip(chr)
  T.find { |a,b| b == chr }[0]
end


_B = A.map { |chr| flip chr }
_A = _B.map { |chr| unflip chr }

B == _B # => true
A == _A # => true

flipped = "Ruby is fun!".chars.map { |chr| flip chr }.join.reverse # => "¡unɟ sᴉ ʎqnᴚ"
flipped.chars.map { |chr| unflip chr }.join.reverse # => "Ruby is fun!"
{% endhighlight %}

<br />

##─　僕のやり方４　─
`Hash.[]`で対応文字のハッシュを作り、`Hash#[]`で検索する。unflipは`Hash#invert`でデータを反転してから検索する。

{% highlight ruby %}
T = A.zip(B)
H = Hash[ T ] # => {"A"=>"ᗄ", "B"=>"ᗺ", "C"=>"Ɔ", "D"=>"ᗡ", "E"=>"Ǝ", "F"=>"Ⅎ", "G"=>"⅁", "H"=>"H", "I"=>"I", "J"=>"ᒋ", "K"=>"丬", "L"=>"⅂", "M"=>"W", "N"=>"N", "O"=>"O", "P"=>"Ԁ", "Q"=>"Ό", "R"=>"ᴚ", "S"=>"S", "T"=>"⊥", "U"=>"Ո", "V"=>"Λ", "W"=>"M", "X"=>"X", "Y"=>"⅄", "Z"=>"Z", "a"=>"ɐ", "b"=>"q", "c"=>"ɔ", "d"=>"p", "e"=>"ə", "f"=>"ɟ", "g"=>"ɓ", "h"=>"ɥ", "i"=>"ᴉ", "j"=>"ɾ", "k"=>"ʞ", "l"=>"l", "m"=>"ɯ", "n"=>"u", "o"=>"o", "p"=>"d", "q"=>"b", "r"=>"ɹ", "s"=>"s", "t"=>"ʇ", "u"=>"n", "v"=>"ʌ", "w"=>"ʍ", "x"=>"x", "y"=>"ʎ", "z"=>"z", "0"=>"0", "1"=>"⇂", "2"=>"Ƨ", "3"=>"ε", "4"=>"ᔭ", "5"=>"5", "6"=>"9", "7"=>"L", "8"=>"8", "9"=>"6", "."=>"˙", ","=>"‘", "-"=>"-", ":"=>":", ";"=>"؛", "!"=>"¡", "?"=>"¿", "&"=>"⅋", "("=>")", ")"=>"(", "<"=>">", ">"=>"<", "["=>"]", "]"=>"[", "_"=>"‾", "‾"=>"_", "{"=>"}", "}"=>"{", "∴"=>"∵", "∵"=>"∴", " "=>" "}

def flip(chr)
  H[chr]
end

def unflip(chr)
  H.invert[chr]
end

_B = A.map { |chr| flip chr }
_A = _B.map { |chr| unflip chr }

B == _B # => true
A == _A # => true

flipped = "Ruby is fun!".chars.map { |chr| flip chr }.join.reverse # => "¡unɟ sᴉ ʎqnᴚ"
flipped.chars.map { |chr| unflip chr }.join.reverse # => "Ruby is fun!"
{% endhighlight %}

<br />

##─　僕のやり方５　─
`Hash.[]`で対応文字のハッシュを作り、`Hash#[]`で検索する。unflipでは`Hash#key`を使う。

{% highlight ruby %}
T = A.zip(B)
H = Hash[ T ]

def flip(chr)
  H[chr]
end

def unflip(chr)
  H.key(chr)
end

_B = A.map { |chr| flip chr }
_A = _B.map { |chr| unflip chr }

B == _B # => true
A == _A # => true

flipped = "Ruby is fun!".chars.map { |chr| flip chr }.join.reverse # => "¡unɟ sᴉ ʎqnᴚ"
flipped.chars.map { |chr| unflip chr }.join.reverse # => "Ruby is fun!"
{% endhighlight %}

<br />


##どのやり方を選ぶべきか
さて、ここまでデータにアクセスする５種類の方法を見てきましたが、どの方法を採用したらよいか迷います。あなたはどれですか？

可読性に大差はないので、ここでは速度を比較しその結果で選ぶことにします。

ベンチマークを取ります。

####flip_benchmark.rb
{% highlight ruby %}
require "benchmark"
require "benchmark/ips"
require_relative 'flip'


Lorem = "Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.".chars

def echo(chr)
  chr
end

Benchmark.ips do |x|
  x.report('index'){ Lorem.each { |chr| unflip_i flip_i(chr)  } }
  x.report('assoc'){ Lorem.each { |chr| unflip_a flip_a(chr)  } }
  x.report('find') { Lorem.each { |chr| unflip_f flip_f(chr)  } }
  x.report('hash') { Lorem.each { |chr| unflip_h flip_h(chr)  } }
  x.report('hash_key') { Lorem.each { |chr| unflip_hkey flip_h(chr)  } }
  x.report('echo') { Lorem.each { |chr| echo echo(chr)  } }
end
{% endhighlight %}
文字群を反転し元に戻す処理を単位時間当たりの実行回数（ips:iteration per second）で比較します（要`gem install benchmark_suite`）。各メソッドのコストを見るため、文字をそのまま返すメソッド`echo`を追加しています。


さあ、結果は如何に。順位を予想してみて下さい。

・・・

<br />
<br />

{% highlight text %}
% ruby flip_benchmark.rb     
Calculating -------------------------------------
               index        17 i/100ms
               assoc        17 i/100ms
                find         8 i/100ms
                hash         3 i/100ms
            hash_key        26 i/100ms
                echo       358 i/100ms
-------------------------------------------------
               index      178.4 (±2.8%) i/s -        901 in   5.053797s
               assoc      173.5 (±1.7%) i/s -        867 in   4.999209s
                find       83.8 (±1.2%) i/s -        424 in   5.058501s
                hash       35.7 (±2.8%) i/s -        180 in   5.040406s
            hash_key      265.1 (±1.1%) i/s -       1326 in   5.002699s
                echo     3615.9 (±0.7%) i/s -      18258 in   5.049681s
{% endhighlight %}

結果は、`echo >> hash_key > index > assoc > find > hash`という順になりました。hash_keyが最速、hashが最遅です。

え？hashが最遅？！まさか。


hashのコードをもう一度見てみます。
{% highlight ruby %}
def flip_h(chr)
  H[chr]
end

def unflip_h(chr)
  H.invert[chr]
end
{% endhighlight %}

やーこれはいかん。

この実装だと#unflipが呼ばれる度にHash#invertが実行されてしまいます。invertの実行がコストになるのは想像がつきます。直します。

{% highlight ruby %}
H = Hash[ T ]
Hi = H.invert

def flip_h(chr)
  H[chr]
end

def unflip_h(chr)
  Hi[chr]
end
{% endhighlight %}


さあ今度はどうですか。


{% highlight text %}
% ruby flip_benchmark.rb     
Calculating -------------------------------------
               index        18 i/100ms
               assoc        17 i/100ms
                find         8 i/100ms
                hash       226 i/100ms
            hash_key        26 i/100ms
                echo       371 i/100ms
-------------------------------------------------
               index      182.0 (±1.6%) i/s -        918 in   5.046047s
               assoc      178.4 (±0.6%) i/s -        901 in   5.051709s
                find       84.5 (±1.2%) i/s -        424 in   5.017970s
                hash     2242.5 (±1.9%) i/s -      11300 in   5.040986s
            hash_key      266.3 (±1.5%) i/s -       1352 in   5.078433s
                echo     3725.7 (±2.0%) i/s -      18921 in   5.080765s
{% endhighlight %}

hash速っ！

ここでは２つのハッシュの初期生成コストを考慮していませんが、これだけhashが爆速なら「hash最高！即採用！」ということでよろしいのじゃないでしょうか。

まあ実際、この問題の答えとしてはなんでもいいんでしょうけどね...

関連記事：

[RubyのコードをFlipして暗号化する？]({{ site.url }}/2013/01/28/make-ruby-script-encript-with-flippy/ 'RubyのコードをFlipして暗号化する？')

---

電子書籍でRuby始めてみませんか？

> [M'ELBORNE BOOKS]({{ site.url }}/books/ 'M'ELBORNE BOOKS')


