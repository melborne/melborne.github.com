---
layout: post
title: '第３弾！知って得する12のRubyのトリビアな記法'
tagline: '12 Trivia Notations you should know in Ruby'
description: ""
category: 
tags: [ruby, tips]
date: 2012-04-26
published: true
---
{% include JB/setup %}

なぜかトリビア人気が再燃しているよ。

{% hatebu http://melborne.github.com/2011/06/22/21-Ruby-21-Trivia-Notations-you-should-know-in-Ruby/ 知って得する21のRubyのトリビアな記法 %}

{% hatebu http://melborne.github.com/2012/02/08/2-12-Ruby-12-Trivia-Notations-you-should-know-in-Ruby/ 第２弾！知って得する12のRubyのトリビアな記法 %}


これでみんながトリビア好きだということが分かったので、何とか絞り出して第３弾を書いたよ。ここでは第１弾、第２弾で使ったテクニックも使ってるから、知らないテクニックがあったら先に見てもらえるいいかもね。

_____

##1. Enumerable#each_with_object
Enumerable#mapではブロックの代わりに&付きのシンボルを渡す技が知られているよ。
{% highlight ruby %}
langs = ["ruby", "python", "lisp", "haskell"]
langs.map(&:capitalize) # => ["Ruby", "Python", "Lisp", "Haskell"]
{% endhighlight %}

だけど、この技は引数をとるようなメソッドには使えないという問題があるよ。で、これに不満があって、引数をとれるmappというメソッドを前に書いたんだ。
{% highlight ruby %}
module Enumerable
  def mapp(op=nil, *args, &blk)
    op ? map { |e| op.intern.to_proc[e, *args]} : map(&blk)
  end
end

langs = ["ruby", "python", "lisp", "haskell"]
langs.mapp(:+, 'ist') # => ["Rubyist", "Pythonist", "Lispist", "Haskellist"]
[1, 2, 3].mapp(:+, 10) # => [11, 12, 13]
(1..5).mapp(:**, 2) # => [1, 4, 9, 16, 25]
[[1,2,3,4], [5,6,7,8], [9,10,11,12]].mapp(:last, 2) # => [[3, 4], [7, 8], [11, 12]]
{% endhighlight %}
[RubyのEnumerable#mapをもっと便利にしたいよ](http://melborne.github.com/2012/02/11/Ruby-Enumerable-map/ 'RubyのEnumerable#mapをもっと便利にしたいよ')

でも、同等のことは`each_with_object`でできるんだね。最近、知ったんだ。
{% highlight ruby %}
langs.each_with_object('ist').tap{|_|p _.to_a}.map(&:+) # => ["rubyist", "pythonist", "lispist", "haskellist"]

# >> [["ruby", "ist"], ["python", "ist"], ["lisp", "ist"], ["haskell", "ist"]]

[1, 2, 3].each_with_object(10).map(&:+) # => [11, 12, 13]
(1..5).each_with_object(2).map(&:**) # => [1, 4, 9, 16, 25]
[[1,2,3,4], [5,6,7,8], [9,10,11,12]].each_with_object(2).map(&:last) # => [[3, 4], [7, 8], [11, 12]]
{% endhighlight %}
tapで取ったeach_with_objectの返り値を見れば、挙動が理解できるよね。

けど、each_with_objectという名前はちょっと長いよねー。

`with`としてみようか。

{% highlight ruby %}
Enumerable.send(:alias_method, :with, :each_with_object)

langs = ["ruby", "python", "lisp", "haskell"]
langs.with('ist').map(&:+) # => ["rubyist", "pythonist", "lispist", "haskellist"]

[1, 2, 3].with(10).map(&:+) # => [11, 12, 13]
(1..5).with(2).map(&:**) # => [1, 4, 9, 16, 25]
[[1,2,3,4], [5,6,7,8], [9,10,11,12]].with(2).map(&:last) # => [[3, 4], [7, 8], [11, 12]]
{% endhighlight %}
なんかよくない？

##2. Float::INFINITY
任意の数列を作りたい、けど、その大きさは事前に決めたくない、ってときあるよね。ここで思いつくのは`Enumerator`だよ。

{% highlight ruby %}
sequence = Enumerator.new { |y| i=1; loop { y << i; i+=1 } }

sequence.take(10) # => [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]
100.times.map { sequence.next } # => [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32, 33, 34, 35, 36, 37, 38, 39, 40, 41, 42, 43, 44, 45, 46, 47, 48, 49, 50, 51, 52, 53, 54, 55, 56, 57, 58, 59, 60, 61, 62, 63, 64, 65, 66, 67, 68, 69, 70, 71, 72, 73, 74, 75, 76, 77, 78, 79, 80, 81, 82, 83, 84, 85, 86, 87, 88, 89, 90, 91, 92, 93, 94, 95, 96, 97, 98, 99, 100]
{% endhighlight %}

でも`Enumerator`を使わなくても、似たようなことは無限大定数の`Float::INFINITY`でできるんだ。
{% highlight ruby %}
sequence = 1..Float::INFINITY
sequence.take(10) # => [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]
seq = sequence.to_enum
100.times.map { seq.next } # => [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32, 33, 34, 35, 36, 37, 38, 39, 40, 41, 42, 43, 44, 45, 46, 47, 48, 49, 50, 51, 52, 53, 54, 55, 56, 57, 58, 59, 60, 61, 62, 63, 64, 65, 66, 67, 68, 69, 70, 71, 72, 73, 74, 75, 76, 77, 78, 79, 80, 81, 82, 83, 84, 85, 86, 87, 88, 89, 90, 91, 92, 93, 94, 95, 96, 97, 98, 99, 100]
{% endhighlight %}

Infinityはゼロ除算で取れるから、次のように書いてもいいよ。
{% highlight ruby %}
(1..1.0/0).take(10) # => [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]

1.step(1.0/0, 1.5).take(20) # => [1.0, 2.5, 4.0, 5.5, 7.0, 8.5, 10.0, 11.5, 13.0, 14.5, 16.0, 17.5, 19.0, 20.5, 22.0, 23.5, 25.0, 26.5, 28.0, 29.5]
{% endhighlight %}

##3. Enumerable#grep
caseにおける同値判定は再定義可能な`===`でされるよね。
{% highlight ruby %}
temp = 85
status =
  case temp
  when 1..40;   :low
  when 80..100; :Danger
  else :ok
  end
status # => :Danger

class Trivia
end
t = Trivia.new

klass =
  case t
  when String; 'no good'
  when Array;  'no no'
  when Trivia; 'Yes! Trivia!'
  end
klass # => "Yes! Trivia!"

even = ->n{ n.even? }

number = 31415926535_8979323846_2643383279_5028841971_6939937510_5820974944_5923078164_0628620899_8628034825_3421170679
res =
  case number
  when even; "#{number} must be 'EVEN'"
  else "#{number} must be 'SOMETHING ELSE'"
  end
res # => "31415926535897932384626433832795028841971693993751058209749445923078164062862089986280348253421170679 must be 'SOMETHING ELSE'"
{% endhighlight %}

それぞれ`Range#===`、`Module#===`、`Proc#===`による判定で比較をしているよ。

実は`Enumerable#grep`におけるパターンマッチも===で判定されるんだよ。
{% highlight ruby %}
numbers = 5.step(80, 5).to_a # => [5, 10, 15, 20, 25, 30, 35, 40, 45, 50, 55, 60, 65, 70, 75, 80]
numbers.grep(20..50) # => [20, 25, 30, 35, 40, 45, 50]

t1, t2, t3, t4, t5 = 'trivia', Trivia.new, [:trivia], {trivia:1}, Trivia.new

[t1, t2, t3, t4, t5].grep(Trivia) # => [#<Trivia:0x000001008613b0>, #<Trivia:0x000001008610e0>]

lacky = ->n{ "#{n}"[-1]=='7' }
numbers = (1..1000).step(3)

numbers.grep(lacky) # => [7, 37, 67, 97, 127, 157, 187, 217, 247, 277, 307, 337, 367, 397, 427, 457, 487, 517, 547, 577, 607, 637, 667, 697, 727, 757, 787, 817, 847, 877, 907, 937, 967, 997]
{% endhighlight %}

##4. String#gsub
文字列の中に現れる部分文字列の繰り返し回数を数えたい、というときがあるよ。普通、`String#scan`を使うと思うんだ。
{% highlight ruby %}
DATA.read.scan(/hello/i).count # => 48

__END__
You say "Yes", I say "No".
You say "Stop" and I say "Go, go, go".
Oh no.
You say "Goodbye" and I say "Hello, hello, hello".
I don't know why you say "Goodbye", I say "Hello, hello, hello".
I don't know why you say goodbye, I say hello.
I say "High", you say "Low".
You say "Why?" And I say "I don't know".
Oh no.
You say "Goodbye" and I say "Hello, hello, hello".
I don't know why you say "Goodbye", I say "Hello, hello, hello".
(Hello, goodbye, hello, goodbye. Hello, goodbye.)
I don't know why you say "Goodbye", I say "Hello".
(Hello, goodbye, hello, goodbye. Hello, goodbye. Hello, goodbye.)
Why, why, why, why, why, why, do you
Say "Goodbye, goodbye, bye, bye".
Oh no.
You say "Goodbye" and I say "Hello, hello, hello".
I don't know why you say "Goodbye", I say "Hello, hello, hello".
I don't know why you say "Goodbye", I say "Hello".
You say "Yes", I say "No".
(I say "Yes", but I may mean "No").
You say "Stop", I say "Go, go, go".
(I can stay still it's time to go).
Oh, oh no.
You say "Goodbye" and I say "Hello, hello, hello".
I don't know why you say "Goodbye", I say "Hello, hello, hello".
I don't know why you say "Goodbye", I say "Hello, hello, hello".
I don't know why you say "Goodbye", I say "Hello-wow, oh. Hello".
Hela, heba, helloa. Hela, heba, helloa. Hela, heba, helloa.
Hela, heba, helloa. (Hela.) Hela, heba, helloa. Hela, heba, helloa.
Hela, heba, helloa. Hela, heba, helloa. Hela, heba, helloa.
{% endhighlight %}
いい歌詞だよねー。

でも`String#gsub`はブロックを渡さないとEnumeratorを返すから、同じことができるよ。
{% highlight ruby %}
DATA.read.gsub(/hello/i).count # => 48

__END__
You say "Yes", I say "No".
You say "Stop" and I say "Go, go, go".
Oh no.
You say "Goodbye" and I say "Hello, hello, hello".
....
{% endhighlight %}

##5. 変数のnil初期化 
多数の変数を`nil`で初期化したいときってある？そんなときはこうするのかな？
{% highlight ruby %}
a, b, c, d, e, f, g, h, i, k = [nil] * 10

[a, b, c, d, e, f, g, h, i, k].map.to_a # => [nil, nil, nil, nil, nil, nil, nil, nil, nil, nil]
{% endhighlight %}

でも、多重代入で対応する値がない場合はnilが入るから、これは次で足りるんだ。
{% highlight ruby %}
a, b, c, d, e, f, g, h, i, k = nil

[a, b, c, d, e, f, g, h, i, k].map.to_a # => [nil, nil, nil, nil, nil, nil, nil, nil, nil, nil]
{% endhighlight %}

##6. クラスメソッド定義 
クラスやモジュールのメソッドを定義するときは、普通次のようにするよね。
{% highlight ruby %}
class Calc
  class << self
    def >>(exp)
      eval exp
    end
  end
end

Calc >> '1 + 2' # => 3
Calc >> '10 ** 2' # => 100
{% endhighlight %}

外側のクラス定義を`Class.new`や`Module.new`で行えば、次のような書き方もできるんだよ。
{% highlight ruby %}
class << Calc = Class.new
  def >>(exp)
    eval exp
  end
end

Calc >> '123 / 4.0' # => 30.75
Calc >> '2 * Math::PI' # => 6.283185307179586
{% endhighlight %}

このネタは大したことないけど、`Calc.>>`ってメソッド名、良くない？irb風で。


##7. true, false, nil
Rubyが取り扱うデータはすべてオブジェクトで、Rubyの世界では数字も、クラスも、そして`true`, `false`, `nil`もすべてオブジェクトってこと、知ってるよね。だから当然、これらはメソッドを持っていて、後からメソッドを追加することもできるんだ。
{% highlight ruby %}
def true.true?
  'Beleive me. you are true.'
end

def false.true?
  'I said, you are false!'
end

my_point, your_point = 87, 35
border = 60
my_result = my_point > border
your_result = your_point > border

my_result # => true
my_result.true? # => "Beleive me. you are true."
your_result # => false
your_result.true? # => "I said, you are false!"
{% endhighlight %}

`nil`にもメソッド定義してみるよ。`===`メソッドを定義してcaseで使おう。
{% highlight ruby %}
def nil.===(other)
  other.nil? || other.empty?
end

def proceed(obj)
  Array(obj).join.split(//).join('*')
end

full = "I'm full."
empty = ""
_nil_ = nil

objects = [full, empty, _nil_, %w(I am full), [], {:hello => 'world'}, {}]

for obj in objects
  case obj
  when nil
    puts "Stop it! `#{obj.inspect}` is empty or nil."
  else
    puts proceed obj
  end
end
# >> I*'*m* *f*u*l*l*.
# >> Stop it! `""` is empty or nil.
# >> Stop it! `nil` is empty or nil.
# >> I*a*m*f*u*l*l
# >> Stop it! `[]` is empty or nil.
# >> h*e*l*l*o*w*o*r*l*d
# >> Stop it! `{}` is empty or nil.
{% endhighlight %}
ちょっと凝り過ぎちゃったね。

##8. Rubyのキーワード 
Rubyのキーワードは予約語じゃないから、それが明示的な文脈で使われる限り、メソッド名などにも使えるんだ。ここでは`case`, `if`, `for`をTriviaクラスに定義してみるよ。
{% highlight ruby %}
class Trivia
  def case(klass)
    case self
    when klass; 'You are my sunshine.'
    else 'No, you are Alien for me'
    end
  end

  def if(bool, arg)
    if bool
      yield arg
    else
      arg.reverse
    end
  end
  
  def for(list)
    list.map { |e| yield e }
  end
end

t = Trivia.new

t.case(Trivia) # => "You are my sunshine."
t.case(Array) # => "No, you are Alien for me"

t.if(true, 'my name is charlie') { |str| str.upcase } # => "MY NAME IS CHARLIE"
t.if(false, 'my name is charlie') { |str| str.upcase } # => "eilrahc si eman ym"

t.for([*1..10]) { |i| i**2 } # => [1, 4, 9, 16, 25, 36, 49, 64, 81, 100]
{% endhighlight %}

##9. YAMLタグ指定
ユーザデータなどのプログラムに書き込みたくないデータをRubyで扱うには、`yamlライブラリ`が便利だよね。
{% highlight ruby %}
require "yaml"

langs = YAML.load(DATA)
puts langs.map { |lang| "My favorite language is " + lang }

# >> My favorite language is Ruby
# >> My favorite language is Lisp
# >> My favorite language is C++

__END__
---
- Ruby
- Lisp
- C++
{% endhighlight %}
ここで`!ruby/`ではじまるタグを使えば、その文字列に対するクラス指定ができるけど、`!ruby/object:<クラス名>`というタグを使えば、独自クラスの指定もできるんだ。LanguageクラスのオブジェクトとしてYAMLデータを読みだしてみるよ。

{% highlight ruby %}
require "yaml"
class Language
  attr_accessor :name, :born, :designer
  def profile
    [name, born, designer] * '-'
  end
end

members = YAML.load(DATA)

puts members.map { |member| member.profile }

# >> Ruby-1993-Yukihiro Matsumoto
# >> Lisp-1958-Joh McCarthy
# >> C++-1983-Bjarne Stroustrup

__END__
--- 
- !ruby/object:Language
  name: Ruby
  born: 1993
  designer: Yukihiro Matsumoto
- !ruby/object:Language
  name: Lisp
  born: 1958
  designer: Joh McCarthy
- !ruby/object:Language
  name: C++
  born: 1983
  designer: Bjarne Stroustrup
{% endhighlight %}

##10. 単項演算子 ~ (チルダ)
単項演算子`~`は実はメソッドだけど、これはどこで定義されているか知ってる？そう、`Fixnum`と`Bignum`でNOT演算をするために用意されてるんだ。
{% highlight ruby %}
~1 # => -2
~2 # => -3
~3 # => -4
~7 # => -8

1.to_s(2) # => "1"
2.to_s(2) # => "10"
3.to_s(2) # => "11"
7.to_s(2) # => "111"

(~1).to_s(2) # => "-10"
(~2).to_s(2) # => "-11"
(~3).to_s(2) # => "-100"
(~7).to_s(2) # => "-1000"
{% endhighlight %}

それからもう一つ、`Regexp`にも定義されているよ。これはgetsからの入力を受ける変数`$_`とのパターンマッチをするためのものなんだ。
{% highlight ruby %}
$_ = 'Ruby is a dynamic, open source programming language with a focus on simplicity and productivity.'

pos = ~ /\w{8,}/
puts "8+long-word `#{$&}` appeared at #{pos}"

# >> 8+long-word `programming` appeared at 31
{% endhighlight %}

単項演算子がユニークなのは、レシーバーがメソッドの後ろに来る、ってことだよ。こんなユニークで使い勝手のいいメソッドはどんどん定義するべきだよね。結合強度も強いからメソッドチェーン上も問題ないし。
{% highlight ruby %}
class String
  def ~
    reverse
  end
end

class Symbol
  def ~
    swapcase
  end
end

class Array
  def ~
    reverse
  end
end

class Hash
  def ~
    invert
  end
end

~'よるなくたにし なんてしつけいい' # => "いいけつしてんな しにたくなるよ"

s = 'godtoh'
~s.swapcase # => "HOTDOG"

~:Hello # => :hELLO

~[1,2,3,4] # => [4, 3, 2, 1]

~{ruby: 1, lisp: 2} # => {1=>:ruby, 2=>:lisp}
{% endhighlight %}

まあ確かに、`~(にょろ)`だけじゃ、メソッドの意図がわかりづらいけどね。

##11. マルチバイトメソッド
1.9からメソッド名などにマルチバイト文字を使えるようになったけど、あまり活用事例を見ないよね。それじゃRubyが可哀想なので、ここで例を示して布教するよ。
{% highlight ruby %}
class String
  def ©(name='anonymous')
    self + " - Copyright © #{name} #{Time.now.year} All rights reserved. -"
  end

  def 
    self + ' - Designed by Apple in California -'
  end
end

'this is my work'.©(:Charlie) # => "this is my work - Copyright © Charlie 2012 All rights reserved. -"

poetry = <<EOS
Ruby is not a Gem
Gem is not a Jam
Jam is not a Jelly
Jam is about Traffic
Gem is about Library
Ruby is about Language!
EOS

puts poetry.©

# >> Ruby is not a Gem
# >> Gem is not a Jam
# >> Jam is not a Jelly
# >> Jam is about Traffic
# >> Gem is about Library
# >> Ruby is about Language!
# >>  - Copyright © anonymous 2012 All rights reserved. -

'hello, apple'. # => "hello, apple - Designed by Apple in California -"
{% endhighlight %}
``はMacのkeyboardだと`~$k`(Option+Shift+k)を押します。

`Numeric`には通貨メソッドを追加してみるよ。ここでは`def_method`というメソッド定義メソッドを作って、クラスをオープンする手間を省いてるよ。
{% highlight ruby %}
def def_method(name, klass=self.class, &body)
  blk = block_given? ? body : ->{ "#{name}: not implemented yet." }
  klass.class_eval { define_method("#{name}", blk) }
end

currencies = %w(¥ € £ $).zip [:JPY, :EUR, :GBP, :USD]
currencies.each do |cur, sym|
  def_method(cur, Numeric) do
    int, dec = Exchange(self, sym).to_s.split('.')
    dec = dec ? ".#{dec[/.{1,2}/]}" : ''
    cur + int.reverse.scan(/.{1,3}/).join(',').reverse + dec
  end
end

def Exchange(num, _for_)
  num * {USD:1.0, JPY:81.3, EUR:0.76, GBP:0.62}[_for_]
end

123.45.¥ # => "¥10,036.48"
1000000.¥ # => "¥81,300,000.0"
123.€ # => "€93.48"
1000000.€ # => "€760,000.0"
123.45.£ # => "£76.53"
1000000.£ # => "£620,000.0"
{% endhighlight %}

まあ入力が難だけど..


##12. 秘伝メソッド
上で見たようにRubyではキーワードや記号文字をメソッド名に使えるけど、使えないものもあるよ。例えば、`.`, `,`, `@`, `=`, `(`, `#`, `$` なんかはメソッド名には使えないよね。
{% highlight ruby %}
def .
end
# ~> -:1: syntax error, unexpected '.'

def ,
end
# ~> -:1: syntax error, unexpected ','

def @
end
# ~> -:1: syntax error, unexpected $undefined

def =
end
# ~> -:1: syntax error, unexpected '='

def (
end
# ~> -:2: syntax error, unexpected keyword_end

def #
end
# ~> -:4: syntax error, unexpected $end

def $
end
# ~> -:1: syntax error, unexpected $undefined
{% endhighlight %}

と、普通思うよ。けど、実はこれらも`define_method`を使えば、定義できるんだよ。先のdef_methodを使ってこれらのメソッドを定義してみるよ。
{% highlight ruby %}
def def_method(name, klass=self.class, &body)
  blk = block_given? ? body : ->{ "#{name}: not implemented yet." }
  klass.class_eval { define_method("#{name}", blk) }
end

class Trivia
  
end

methods = [".", ",", "@", "=", "(", "#", "$"]
methods.each { |meth| def_method meth, Trivia }

Trivia.public_instance_methods(false) # => [:".", :",", :"@", :"=", :"(", :"#", :"$"]
{% endhighlight %}

ね？

ただ、これらのメソッドにはひとつだけ問題があるんだ..

それは...

呼び出しができないんだよ ^ ^;

{% highlight ruby %}

t = Trivia.new

t.. # => 
t., # => 
t.@ # => 
t.= # => 
t.( # => 
t.# # => 
t.$ # => 

# ~> -:42: syntax error, unexpected ')'
# ~> ...1335430361_15646_549583 = (t..);$stderr.puts("!XMP1335430361...
# ~> ...                               ^
# ~> -:43: syntax error, unexpected ','
# ~> ..._1335430361_15646_549583 = (t.,);$stderr.puts("!XMP133543036...
# ~> ...                               ^
# ~> -:44: syntax error, unexpected $undefined
# ~> ..._1335430361_15646_549583 = (t.@);$stderr.puts("!XMP133543036...
# ~> ...                               ^
# ~> -:45: syntax error, unexpected '='
# ~> ..._1335430361_15646_549583 = (t.=);$stderr.puts("!XMP133543036...
# ~> ...                               ^
# ~> -:48: syntax error, unexpected $undefined
# ~> ..._1335430361_15646_549583 = (t.$);$stderr.puts("!XMP133543036...
# ~> ...                               ^
# ~> -:65: syntax error, unexpected $end, expecting ')'
{% endhighlight %}

ただ、`Object#send`や`Method#call`を使って呼び出す、という手段はあるんだ。
{% highlight ruby %}
t = Trivia.new

t.send '.' # => ".: not implemented yet."
t.method(',').call # => ",: not implemented yet."

def_method('@', Trivia) do |num|
  "#{self.class}".center(num, '@')
end

def_method('(', Trivia) do |str|
  "( #{str} )"
end

t.send '@', 12 # => "@@@Trivia@@@"
t.send '(', 'I love Ruby'  # => "( I love Ruby )"
{% endhighlight %}
つまり、これらの記号文字メソッドは、通常の方法じゃ定義も呼び出しもできないけど、通常でない特殊な方法を使えば定義も呼び出しもできる、特殊なメソッド群って言えると思うんだ。だから僕はこれらのメソッド群を、特殊な方法で隠されたメソッド、つまり`秘伝(hidden)`メソッドと名付けるよ。使い道は...なさそうだけど...


今回は以上で終わりだよ。



{{ 4873113946 | amazon_medium_image }}
{{ 4873113946 | amazon_link }}


(追記:2012-06-12) 文体を変えました ^ ^;

