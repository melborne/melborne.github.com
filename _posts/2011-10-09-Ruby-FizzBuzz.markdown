---
layout: post
title: RubyでFizzBuzz問題を解いて上司に対抗しよう!
date: 2011-10-09
comments: true
categories:
tags: [ruby, fizzbuzz]
---

FizzBuzz問題は有名だから、少しプログラムをかじったことがあれば名前くらいは知ってるよね。それを会社の10人のプログラマにテストしてみたら、あまりできがよくなかったという話があるよ。

[FizzBuzz問題を使って社内プログラミングコンテストを開催してみた - ITは芸術だ](http://d.hatena.ne.jp/JunichiIto/20111007/1317976730#20111007f1)

確かにFizzBuzz問題は一見単純だから、誰でも簡単に解けると思われがちだけど、時間制限付きの抜き打ちテストというかたちでだされたら、頭が混乱して僕もどんな結果になるか心配だよ。

だから上司の嫌がらせで恥をかかされないように、いまからしっかりと予習しておくよ:)

##問題の分割
通常1つの問題は複数の小さな問題でできているんだ。だから与えられた問題を読んだとき最初にすべきことは、それを複数の小さな問題に切り分けることだよ。

早速FizzBuzz問題を小さな問題に切り分けてみよう。

僕はFizzBuzz問題は次のような、3つの小さな問題に切り分けられると思うんだ。

1. 1つの数を取ってFizzBuzzの結果を返す関数を作る問題
1. 1からxまでの数をその関数に適用する関数を作る問題
1. スクリプト引数xを2の関数に与えて結果をターミナルに出力する関数を作る問題

##小さな問題1
じゃあこれらの問題を順に解いていくよ。まずは最初の小さな関数(fizzbuzzとする)を作ろう。これは1を取ったら1、2を取ったら2、3を取ったら'Fizz'、5を取ったら'Buzz'、を返すような関数を作ればいいから簡単だよね。

あ、いい忘れたけど僕はRubyしか書けないからRubyで書くよ。例えばこんなのどうかな？
{% highlight ruby %}
def fizzbuzz(n)
  case
  when n%5==0 && n%3==0; 'FizzBuzz'
  when n%5==0; 'Buzz'
  when n%3==0; 'Fizz'
  else n
  end
end
fizzbuzz(1) # => 1
fizzbuzz(3) # => "Fizz"
fizzbuzz(4) # => 4
fizzbuzz(5) # => "Buzz"
fizzbuzz(10) # => "Buzz"
fizzbuzz(15) # => "FizzBuzz"
{% endhighlight %}

オーソドックスだけど個人的には、Fixnum#%が何回も出てくるのはイケてないと感じるよ。こうすればもう少し良くなるかな。
{% highlight ruby %}
def fizzbuzz(n)
  mod_zero = ->base{ n%base == 0 }
  case
  when mod_zero[3] && mod_zero[5]; 'FizzBuzz'
  when mod_zero[3]; 'Fizz'
  when mod_zero[5]; 'Buzz'
  else n
  end
end
fizzbuzz(1) # => 1
fizzbuzz(3) # => "Fizz"
fizzbuzz(4) # => 4
fizzbuzz(5) # => "Buzz"
fizzbuzz(10) # => "Buzz"
fizzbuzz(15) # => "FizzBuzz"
{% endhighlight %}

少し良くなったと思うけど、個人的にはwhenの順位を考慮しなきゃいけないってのが好きじゃないんだ。これはどうかな？
{% highlight ruby %}
def fizzbuzz(n)
  x = ""
  x << "Fizz" if n%3 == 0
  x << "Buzz" if n%5 == 0
  x.empty? ? n : x
end
fizzbuzz(1) # => 1
fizzbuzz(3) # => "Fizz"
fizzbuzz(4) # => 4
fizzbuzz(5) # => "Buzz"
fizzbuzz(10) # => "Buzz"
fizzbuzz(15) # => "FizzBuzz"
{% endhighlight %}
まあこれは趣味の問題かもね..

##小さな問題2
さて2つ目の小さな問題を解くよ。2つ目は「1からxまでの数をその関数に適用する関数を作る」だったね。RubyにはEnumeratorがあるから、これはばかみたいに簡単だよね。関数名をmap_uptoにしよう。
{% highlight ruby %}
def map_upto(max, f)
  (1..max).map { |n| f[n] }
end
map_upto(15, method(:fizzbuzz)) # => [1, 2, "Fizz", 4, "Buzz", "Fizz", 7, 8, "Fizz", "Buzz", 11, "Fizz", 13, 14, "FizzBuzz"]
{% endhighlight %}

##小さな問題3
次に3つ目の小さな問題を解くよ。3つ目は、「スクリプト引数xを2の関数に与えて結果をターミナルに出力する関数を作る」だったね。Rubyスクリプトに与えられた引数はARGVという配列に格納されるよね。またターミナルへの改行出力はputsだよね。だから次のようになるよ。関数名をconsoleとするよ。
{% highlight ruby %}
def console(f)
  raise "need an argument of integer" if ARGV[0].nil?
  max = ARGV[0].to_i
  f[max].each { |e| puts e }
end
{% endhighlight %}
ここでは引数がない場合のチェックしかしてないけど、厳密なチェックが必要ならここで書くことになるよ。

さあこれで完成だよ。コードをまとめて再掲するよ。
{% highlight ruby %}
def fizzbuzz(n)
  x = ""
  x << "Fizz" if n%3 == 0
  x << "Buzz" if n%5 == 0
  x.empty? ? n : x
end
def map_upto(max, f)
  (1..max).map { |n| f[n] }
end
def console(f)
  raise "need an argument of integer" if ARGV[0].nil?
  max = ARGV[0].to_i
  f[max].each { |e| puts e }
end
if __FILE__ == $0
  fizzbuzz_upto = ->max{ map_upto(max, method(:fizzbuzz)) }
  console fizzbuzz_upto
end
{% endhighlight %}
さあ実行してみよう。
{% highlight sh %}
$ ruby fizzbuzz.rb 15
1
2
Fizz
4
Buzz
Fizz
7
8
Fizz
Buzz
11
Fizz
13
14
FizzBuzz
{% endhighlight %}
うまくいったね!

問題を切り分けて、一つづつ解いていけば簡単だね。

経験あるプログラマはこれらを瞬時に頭の中でやってしまうから、ぼくらの気持ちがわからないんだね。次のようなコードをよく見るけど、個人的には問題の切り分けができてないから、良いコードとは思えないんだよ。
{% highlight ruby %}
max = ARGV[0].to_i
(1..max).each do |n|
  res =
    case 
    when n%3 == 0 && n%5 == 0; 'FizzBuzz'
    when n%3 == 0; 'Fizz'
    when n%5 == 0; 'Buzz'
    else n
    end
  puts res
end
{% endhighlight %}
テストしづらいし改変にも弱いからね。

先のコードならテストしやすいし改変にも強そうだよね。
{% highlight ruby %}
require "test/unit"
require "stringio"
require "./fizzbuzz"
class TestFizzBuzz < Test::Unit::TestCase
  def setup
    @ans = [1,2,'Fizz',4,'Buzz','Fizz',7,8,'Fizz','Buzz',11,'Fizz',13,14,'FizzBuzz']
  end
  def test_fizzbuzz
    (1..15).each { |n| assert_equal(@ans[n-1], fizzbuzz(n)) }
  end
  def test_map_upto
    assert_equal(@ans, map_upto(15, method(:fizzbuzz)))
  end
  def test_console
    begin
      $stdout = op = StringIO.new("", 'w')
      fizzbuzz_upto = ->max{ map_upto(max, method(:fizzbuzz)) }
      console(fizzbuzz_upto)
      out = str2fizzbuzz_list(op.string)
      assert_equal(@ans, out)
    ensure
      $stdout = STDOUT
    end
  end
  def str2fizzbuzz_list(str)
    str.split.map { |n| n =~ /(Fi|Bu)zz/ ? n : n.to_i }
  end
end
{% endhighlight %}

(追記:2011-10-15)関数の機能分離が不十分だったので修正しました。

関連記事:
[Yet Another Ruby FizzBuzz]({{ site.url }}/2010/03/18/Yet-Another-Ruby-FizzBuzz/)

[Yet Another Ruby FizzBuzz その2]({{ site.url }}/2010/03/24/Yet-Another-Ruby-FizzBuzz-2/)

[Yet Another Ruby FizzBuzz その3]({{ site.url }}/2010/03/24/Yet-Another-Ruby-FizzBuzz-3/)

[Yet Another Ruby FizzBuzz その4]({{ site.url }}/2010/03/24/Yet-Another-Ruby-FizzBuzz-4/)
