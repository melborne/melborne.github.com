---
layout: post
title: "RubyでObject#dockというのはどうですか？"
description: ""
category: 
tags: 
date: 2014-07-08
published: true
---
{% include JB/setup %}

Rubyでその必要性は明らかだけれども名前が決まらずに承認されないメソッドというのがあって長く議論が続いているものに「単に`self`を返すメソッド」というのがあるよ。

>[Feature #6373: public #self - ruby-trunk - Ruby Issue Tracking System](https://bugs.ruby-lang.org/issues/6373 "Feature #6373: public #self - ruby-trunk - Ruby Issue Tracking System")
>
>[ruby - Is there a short way to write `{|x| x}`? - Stack Overflow](http://stackoverflow.com/questions/16932711/is-there-a-short-way-to-write-x-x "ruby - Is there a short way to write `{|x| x}`? - Stack Overflow")

{% highlight ruby %}
class Object
  def identity
    self
  end
end
{% endhighlight %}

で、これの何が嬉しいのかっていうことなんだけど、例えばこう書くとろこを、

{% highlight ruby %}
nums = [1,2,3,4,5,1,2,2,3]

nums.group_by { |i| i } # => {1=>[1, 1], 2=>[2, 2, 2], 3=>[3, 3], 4=>[4], 5=>[5]}
{% endhighlight %}

こう書けるとか。

{% highlight ruby %}
nums.group_by(&:identity) # => {1=>[1, 1], 2=>[2, 2, 2], 3=>[3, 3], 4=>[4], 5=>[5]}
{% endhighlight %}

えっ、これだけ？って感じなんだけど、それじゃ余りにも使いでなさそうってことで、ブロックぐらい取れるようにという案も出てるよ。

{% highlight ruby %}
class Object
  def itself
    if block_given?
      yield self
    else
      self
    end
  end
end

nums = [1,2,3,4,5,1,2,2,3]

nums.itself { |s| s.inject(:+) / s.size.to_f  } # => 2.5555555555555554

nums.group_by(&:itself) # => {1=>[1, 1], 2=>[2, 2, 2], 3=>[3, 3], 4=>[4], 5=>[5]}
{% endhighlight %}

> [Feature #6721: Object#yield_self - ruby-trunk - Ruby Issue Tracking System](https://bugs.ruby-lang.org/issues/6721 "Feature #6721: Object#yield_self - ruby-trunk - Ruby Issue Tracking System")

で、その決まらない名前のほうなんだけれども、`identity`だとか`itself`だとか`yourself`だとか`the_self`だとか`_`だとか`it`だとか`reference`だとか`yield_self`だとか`ergo`だとか`self`をパブリックにするだとか`tap`を拡張するだとかいろんな案が出てるよ。で、matzが`itself`かなとか言ってるんだけど。

でも、個人的にはブロック取るケースのほうが圧倒的に多いと思うから、ブロック取ることを前提にした名前にした方がいいと思うんだけどね。上のブロック取る例で、`itself`ってなんかピンと来ないよね。

---

で、随分前に自分は`Object#do`って名前考えてFeatureリクエストだしたんだけど@n0kadaさんに、

    something.do do end seems messy

って言われて簡単に玉砕したという歴史があって。

> [Feature #6684: Object#do - ruby-trunk - Ruby Issue Tracking System](https://bugs.ruby-lang.org/issues/6684 "Feature #6684: Object#do - ruby-trunk - Ruby Issue Tracking System")

まあ、それでもこのときに@knuさんに`Object#tap + break`という必殺技を教えてもらって、リクエストの甲斐があったんだけど。

> [Object#doメソッドというのはありですか？](http://melborne.github.io/2012/06/13/objectdo/ "Object#doメソッドというのはありですか？")

---

で、懲りずに今回、こんな名前を考えたよ。

{% highlight ruby %}
class Object
  def dock(&blk)
    return instance_eval(&blk) if block_given?
    self
  end
end

nums.dock { inject(:+) / size.to_f } # => 2.5555555555555554

nums.group_by(&:dock) # => {1=>[1, 1], 2=>[2, 2, 2], 3=>[3, 3], 4=>[4], 5=>[5]}
{% endhighlight %}

実装は先の`itself`のものとほぼ同じなんだけど、selfのコンテキストでブロックを評価する点が異なってるよ。で、`dock`って名前なんだけど「船をドックに入れる」の`ドック`のことで、ブロックをドックに見立てて船たるselfをそこに入れてゴニョゴニョするというイメージだよ。selfをブロック引数で渡さないほうが、selfがポンとブロックの中に投げ入れられる感じで`dock`の名に合ってると思うんだ。ブロックを取らないときはおかしな名前になっちゃうんだけど、どうかな、これそんなに使うのかな？

まあ、でもちょっと大げさな名前かな...。

ほんとは`Object#do`が慎み深くていいんだけど。

{% highlight ruby %}
nums.do { inject(:+) / size.to_f } # => 2.5555555555555554

nums.do inject(:+) / size.to_f end # => 2.5555555555555554

nums.group_by(&:do) # => {1=>[1, 1], 2=>[2, 2, 2], 3=>[3, 3], 4=>[4], 5=>[5]}
{% endhighlight %}

みたいに、`something.do do...end`を`something.do...end`って書けたら、嬉しいんだけどね。

