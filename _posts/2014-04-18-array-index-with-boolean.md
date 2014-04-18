---
layout: post
title: "Rubyの条件分岐をもっと簡潔に"
description: ""
category: 
tags: 
date: 2014-04-18
published: true
---
{% include JB/setup %}

条件分岐の構文としてRubyには「**if-else**」があります。

{% highlight ruby %}
animal = 'hippopotamus'

if animal.size > 10
  puts "You must idiot!"
else
  puts "You are good in size."
end
# >> You must idiot!
{% endhighlight %}

しかし、たかがメッセージの出力にこんなに行数を消費したくはない、と思うのが平均的なRubyistの思考です。そしてRuby唯一の三項演算子を使います。

{% highlight ruby %}
puts animal.size > 10 ? "You must idiot!" : "You are good in size."
# >> You must idiot!
{% endhighlight %}

短くなりましたが、もう一つ問題があります。それは、手続きブロックとしての結合優先順位が低いということです。

{% highlight ruby %}
puts (animal.size > 10 ? "You must idiot!" : "You are good in size.").upcase
# >> YOU MUST IDIOT!

puts begin
  if animal.size > 10
    "You must idiot!"
  else
    "You are good in size."
  end
end.upcase
# >> YOU MUST IDIOT!
{% endhighlight %}

このようにその返り値をputsする場合、括弧や**begin-end**で括るか一時変数に代入する必要があります。

そんなわけで...

こんなのどうですか？

{% highlight ruby %}
module CoreExt
  refine Array do
    def [](*args)
      if args.size == 1 &&
         [true, false, nil].any? { |e| e == args.first }
        super( args.first ? 0 : 1 )
      else
        super
      end
    end
  end
end

using CoreExt

animal = 'hippopotamus'

puts ["You must idiot!", "You are good in size."][animal.size > 10].upcase
# >> YOU MUST IDIOT!

result = false
%w(success fail)[result] # => "fail"
{% endhighlight %}

つまりArray#[]を弄って、引数にtrueが渡されたらindex 0の要素を返し、falseなら1の要素を返すようにします。

みんな一度はこんなこと考えたんじゃないですかねー。でも、まあ..いらないですかね..

---

関連記事：

> [Rubyの条件分岐をメソッド化する]({{ BASE_PATH }}/2013/04/01/methodize-a-conditional-operator/ "Rubyの条件分岐をメソッド化する")

---

(追記：2014-4-19) k-shogoさんのコメントを受けて記述を一部訂正しました。

