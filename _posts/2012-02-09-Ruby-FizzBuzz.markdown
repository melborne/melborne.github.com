---
layout: post
title: RubyでFizzBuzz問題に終止符を打つ!
date: 2012-02-09
comments: true
categories:
tags: [ruby, fizzbuzz]
---

FizzBuzz問題はプログラマーが最初に出会う問題だよ。FizzBuzzの解法はプログラマーの数ほどあると言われているよ。でもいつまでもFizzBuzz問題に関わってたら、本当に解決しなければならない問題を解決できないよ。

だから僕がFizzBuzz問題に終止符を打つよ!

つまり決定版というべきFizzBuzzオブジェクトが一つあれば、もうみんながFizzBuzz問題に頭を悩ませなくても済むはずなんだ。

さあ!
{% highlight ruby %}
class FB
  module Core
    def fb
      ->base,n{ (n%base).zero? }.curry
    end
  end
  {FB:15, F:3, B:5}.each do |name, base|
    k = Class.new do
      extend Core
      define_singleton_method(:===) do |n|
        fb[base, n]
      end
    end
    const_set(name, k)
  end
  extend Core
end
def fizzbuzz(n)
  case n
  when FB::FB; :FizzBuzz
  when FB::F; :Fizz
  when FB::B; :Buzz
  else n
  end
end
(1..100).map { |i| fizzbuzz i } # => [1, 2, :Fizz, 4, :Buzz, :Fizz, 7, 8, :Fizz, :Buzz, 11, :Fizz, 13, 14, :FizzBuzz, 16, 17, :Fizz, 19, :Buzz, :Fizz, 22, 23, :Fizz, :Buzz, 26, :Fizz, 28, 29, :FizzBuzz, 31, 32, :Fizz, 34, :Buzz, :Fizz, 37, 38, :Fizz, :Buzz, 41, :Fizz, 43, 44, :FizzBuzz, 46, 47, :Fizz, 49, :Buzz, :Fizz, 52, 53, :Fizz, :Buzz, 56, :Fizz, 58, 59, :FizzBuzz, 61, 62, :Fizz, 64, :Buzz, :Fizz, 67, 68, :Fizz, :Buzz, 71, :Fizz, 73, 74, :FizzBuzz, 76, 77, :Fizz, 79, :Buzz, :Fizz, 82, 83, :Fizz, :Buzz, 86, :Fizz, 88, 89, :FizzBuzz, 91, 92, :Fizz, 94, :Buzz, :Fizz, 97, 98, :Fizz, :Buzz]
{% endhighlight %}

FB::FBクラスはfizzbuzzを、FB::Fクラスはfizzを、FB::Bクラスはbuzzをそれぞれ判定するクラスオブジェクトだよ。各クラスは===クラスメソッドでfizzbuzzの判定をするから、case式における比較判定にそのまま使えるんだ。

またFBクラスのfbクラスメソッドは、次のように使えるよ。
{% highlight ruby %}
fizzbuzz = FB.fb[15]
fizz = FB.fb[3]
fizzbuzz[15] # => true
fizzbuzz[16] # => false
fizz[6] # => true
fizz[7] # => false
{% endhighlight %}

また一つFizzBuzzを増やしただけだった..

ゴメンナサイm(__)m

