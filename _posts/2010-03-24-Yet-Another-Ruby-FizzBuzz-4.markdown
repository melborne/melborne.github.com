---
layout: post
title: Yet Another Ruby FizzBuzz その4
date: 2010-03-24
comments: true
categories:
---

##Yet Another Ruby FizzBuzz その4
{% highlight ruby %}
class Fixnum
  def fizzbuzz
    w = {Fizz: 3, Buzz: 5}.select { |_, base| (self%base).zero? }
    w.empty? ? self : w.keys.join
  end
end
(1..100).each { |i| print "#{i.fizzbuzz} " }
{% endhighlight %}
Enumerable#injectのほうがいいかな
{% highlight ruby %}
class Fixnum
  def fizzbuzz
    w = {Fizz: 3, Buzz: 5}.inject("") { |mem, (word, base)| (self%base).zero? ? mem << word : mem }
    w.empty? ? self : w
  end
end
(1..100).each { |i| print "#{i.fizzbuzz} " }
{% endhighlight %}
##Yet Another Ruby FizzBuzz その3
{% highlight ruby %}
divisible_by = lambda { |base, num| (num % base).zero? }.curry
divisible_by_15 = divisible_by[15]
divisible_by_3 = divisible_by[3]
divisible_by_5 = divisible_by[5]
(1..100).each do |i|
  puts case i
       when divisible_by_15 then 'FizzBuzz'
       when divisible_by_3 then 'Fizz'
       when divisible_by_5 then 'Buzz'
       else i
       end
end
{% endhighlight %}
##Yet Another Ruby FizzBuzz その2
{% highlight ruby %}
class Fixnum
  def self.fizzbuzzize
    alias org_to_s to_s
    def to_s
      if    self%15 == 0 then "FizzBuzz"
      elsif self%3  == 0 then "Fizz"
      elsif self%5  == 0 then "Buzz"
      else self.org_to_s
      end
    end
  end
  def self.unfizzbuzzize
    undef to_s
    alias to_s org_to_s
  end
end
Fixnum.fizzbuzzize
(1..100).each { |i| print "#{i} " }
puts
Fixnum.unfizzbuzzize
(1..100).each { |i| print "#{i} " }
{% endhighlight %}
[Yet Another Ruby FizzBuzz](/2010/03/18/Yet-Another-Ruby-FizzBuzz/)
