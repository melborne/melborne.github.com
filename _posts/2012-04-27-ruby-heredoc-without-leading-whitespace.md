---
layout: post
title: "チルダがRubyのヒアドキュメントをもっと良くする"
description: ""
category: 
tags: [ruby, tips]
date: 2012-04-27
published: true
---
{% include JB/setup %}
Rubyのヒアドキュメントは便利です。複数行に渡る整形文章を出力するときに、これを使わない手はありません。
{% highlight ruby %}
class ATool
  def self.help
    lines = <<EOS
              Instruction of `#{self}`

    `#{self}` is one of a great tool in the world.
       This helps you a lot on your daily work.
      Your life will be changed with `#{self}`!!
           Everyone knows about `#{self}`.
        So, You can ask them to learn `#{self}`

                Just Use `#{self}`

                   from Today!
EOS
    lines
  end
end

puts ATool.help

# >>               Instruction of `ATool`
# >> 
# >>     `ATool` is one of a great tool in the world.
# >>        This helps you a lot on your daily work.
# >>       Your life will be changed with `ATool`!!
# >>            Everyone knows about `ATool`.
# >>         So, You can ask them to learn `ATool`
# >> 
# >>                 Just Use `ATool`
# >> 
# >>                    from Today!
{% endhighlight %}

ただ、終端ラベル(EOS)のポジションが見苦しいです。これは`<<`に代えて`<<-`とすることで解決できます。
{% highlight ruby %}
class ATool
  def self.help
    lines = <<-EOS
              Instruction of `#{self}`

    `#{self}` is one of a great tool in the world.
       This helps you a lot on your daily work.
      Your life will be changed with `#{self}`!!
           Everyone knows about `#{self}`.
        So, You can ask them to learn `#{self}`

                Just Use `#{self}`

                   from Today!
    EOS
    lines
  end
end

puts ATool.help
# >>               Instruction of `ATool`
# >> 
# >>     `ATool` is one of a great tool in the world.
# >>        This helps you a lot on your daily work.
# >>       Your life will be changed with `ATool`!!
# >>            Everyone knows about `ATool`.
# >>         So, You can ask them to learn `ATool`
# >> 
# >>                 Just Use `ATool`
# >> 
# >>                    from Today!
{% endhighlight %}
EOSをオフセットできました。

##ヒアドキュメントの問題点

しかし依然、問題があります。文章の先頭マージンを除去したい場合は、次のようにしなければなりません。
{% highlight ruby %}
class ATool
  def self.help
    lines = <<-EOS
          Instruction of `#{self}`

`#{self}` is one of a great tool in the world.
   This helps you a lot on your daily work.
  Your life will be changed with `#{self}`!!
       Everyone knows about `#{self}`.
    So, You can ask them to learn `#{self}`

            Just Use `#{self}`

               from Today!
    EOS
    lines
  end
end

puts ATool.help
# >>           Instruction of `ATool`
# >> 
# >> `ATool` is one of a great tool in the world.
# >>    This helps you a lot on your daily work.
# >>   Your life will be changed with `ATool`!!
# >>        Everyone knows about `ATool`.
# >>     So, You can ask them to learn `ATool`
# >> 
# >>             Just Use `ATool`
# >> 
# >>                from Today!
{% endhighlight %}

これは頂けません。可読性が下がります。Rubyistたちはこれに苦労しています。

[How do I remove leading whitespace chars from Ruby HEREDOC? - Stack Overflow](http://stackoverflow.com/questions/3772864/how-do-i-remove-leading-whitespace-chars-from-ruby-heredoc 'How do I remove leading whitespace chars from Ruby HEREDOC? - Stack Overflow')

しかし、スマートな解決策は見当たりません。

##DATAによる解決策
そこで解決策を考えてみました。

まずはDATAの活用です。\_\_END\_\_以降に整形文章を先頭マージン無しで置き、これを読み込むようにします。
{% highlight ruby %}
class ATool
  def self.help
    lines = <<-EOS
      #{DATA.read}
    EOS
    lines
  end
end

puts ATool.help
__END__

          Instruction of `#{self}`

`#{self}` is one of a great tool in the world.
   This helps you a lot on your daily work.
  Your life will be changed with `#{self}`!!
       Everyone knows about `#{self}`.
    So, You can ask them to learn `#{self}`

            Just Use `#{self}`

               from Today!

# >>       
# >>           Instruction of `#{self}`
# >> 
# >> `#{self}` is one of a great tool in the world.
# >>    This helps you a lot on your daily work.
# >>   Your life will be changed with `#{self}`!!
# >>        Everyone knows about `#{self}`.
# >>     So, You can ask them to learn `#{self}`
# >> 
# >>             Just Use `#{self}`
# >> 
# >>                from Today!
# >> 
{% endhighlight %}
可読性は上がりました。しかし、DATAはファイルをrequireすると読めないなどの問題があり、実用的ではありません。

##`~`(チルダ)による解決策
そこで先日のトリビアで紹介した、単項演算子`~`(チルダ)を使う手を思いついたのです。`~`はそのレシーバがメソッドの後ろに来るというユニークな特徴があります。

まず、`String#~`を定義します。
{% highlight ruby %}
class String
  def ~
    margin = scan(/^ +/).map(&:size).min
    gsub(/^ {#{margin}}/, '')
  end
end
{% endhighlight %}
このコードで先頭マージンが除去されます。

そしてヒアドキュメントにおける`<<`の前に、~を置いて`~<<-EOS`のようにすればいいのです。
{% highlight ruby %}
class ATool
  def self.help
    lines = ~<<-EOS
              Instruction of `#{self}`

    `#{self}` is one of a great tool in the world.
       This helps you a lot on your daily work.
      Your life will be changed with `#{self}`!!
           Everyone knows about `#{self}`.
        So, You can ask them to learn `#{self}`

                Just Use `#{self}`

                   from Today!
    EOS
    lines
  end
end

puts ATool.help

# >>           Instruction of `ATool`
# >> 
# >> `ATool` is one of a great tool in the world.
# >>    This helps you a lot on your daily work.
# >>   Your life will be changed with `ATool`!!
# >>        Everyone knows about `ATool`.
# >>     So, You can ask them to learn `ATool`
# >> 
# >>             Just Use `ATool`
# >> 
# >>                from Today!
{% endhighlight %}

先頭マージンが除去されました。

`~`、いいですね！

____

{{ 4892950947 | amazon_medium_image }}
{{ 4892950947 | amazon_link }} by {{ 4892950947 | amazon_authors }}

____

関連記事：[第３弾！知って得する12のRubyのトリビアな記法](http://melborne.github.com/2012/04/26/ruby-trivias-you-should-know/ '第３弾！知って得する12のRubyのトリビアな記法')


(追記:2012-04-27) String#~にバグがあったので直しました。

(追記:2012-04-27) @n0kadaさんのツイートを受けてString#~を変更しました。無駄なことしていました。([Twitter / @n0kada: gsub(/^ {#{self.scan(/^ +/ ...](https://twitter.com/#!/n0kada/status/195763435932356608 'Twitter / @n0kada: gsub(/^ {#{self.scan(/^ +/ ...'))

    (修正前)
    def ~
      indent = lines.map { |l| l[/^ +/] }.compact.map(&:size).min
      lines.map { |line| line[indent..-1] || "\n" }.join
    end

