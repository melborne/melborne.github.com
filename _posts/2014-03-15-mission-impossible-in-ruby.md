---
layout: post
title: "Rubyでワンタイムメソッドを実装して「スパイ大作戦」を敢行せよ！"
description: ""
category:
tags:
date: 2014-03-15
published: true
---
{% include JB/setup %}

Rubyにはシングルトンメソッドと呼ばれる機能があります。これは、特定のオブジェクトにだけ実装されるメソッドのことです。

{% highlight ruby %}
class User < Struct.new(:name, :age, :job)
end

charlie = User.new('Charlie', 12, :programmer)
liz = User.new("Liz", 15, :teacher)
dick = User.new("Dick", 31, :doctor)

def charlie.passcode
  '22360679'
end

def liz.passcode
  '17320508'
end

charlie.passcode # => "22360679"
liz.passcode # => "17320508"
dick.passcode # => 
# ~> -:18:in `<main>': undefined method `passcode' for #<struct User name="Dick", age=31, job=:doctor> (NoMethodError)
{% endhighlight %}

`passcode`メソッドは個々のUserオブジェクトごとに実装され、そのオブジェクト固有の値を返します。またそれが実装されないオブジェクトにおいては呼び出すことができません。これを「`passcode`の名前空間は、それが定義されたオブジェクトに限定される」と表現することもできます。

しかしRubyの世界はミンコフスキー時空であり、そこには「空間」の次元に加え「時間」の次元が存在します。そして、残念ながらシングルトンメソッドではこの時間つまり「名前時間」を限定することができないのです。

{% highlight ruby %}
Time.now # => 2014-03-15 14:12:15 +0900
charlie.passcode # => "22360679"

Time.now # => 2015-03-15 14:12:15 +0900
charlie.passcode # => "22360679"
{% endhighlight %}

一年後において`charlie.passcode`を実行しましたが、呼べてしまいました..。

時間を自由にコントロールできないとしても、せめて一度呼ばれたメソッドは二度と呼べないようにして時間的な制約をかけたい...。

そんなわけで...

OneTimeモジュールなるものを考えましたよ！

## スパイ大作戦

では、早々試してみます。OneTimeといったらやっぱり用途はこれでしょうねぇ...。古いですか？

{% youtube xxOl4aL1o6Q %}

実装です。

{% highlight ruby %}
module CoreExt
  refine String do
    def ~
      margin = scan(/^ +/).map(&:size).min
      gsub(/^ {#{margin}}/, '')
    end
  end
end

class MissionImpossible
  using CoreExt

  def mission_exist?
    !!methods.detect { |m| m==:mission }
  end

  def mission(name)
    mission_template name: name,
      status: ~<<-ST,
        昨夜、プロジェクトX内において
        NullObjectモジュールなる不審物を発見。
        調査の結果、これが我軍の勝利に深刻な影響を及ぼす
        危険因子であることが判明した。
      ST
      mission: ~<<-MS
        このモジュールをプロジェクトXより速やかに撤去し、
        その安全を確保することにある。
      MS
  end

  private
  def mission_template(name:, status:, mission:)
    puts ~<<-MISSION
      おはよう#{name}君。

      #{status}
      そこで今回の君の使命だが、
      #{mission}
      例によって、君もしくはメンバーが捕らえられ、
      あるいは殺されても当局はいっさい関知しないからそのつもりで。

      なお、このメソッドは自動的に消滅する。
      成功を祈る。

    MISSION
  end
end
{% endhighlight %}

CoreExtモジュールはヒアドキュメントの空白を消すおまじないですから無視してください。捜査員は、`MissionImpossible`オブジェクトを生成して、`mission`メソッドを呼ぶことで本部からの指令を受け取ることができます。

やってみましょう。

{% highlight bash %}
% irb
> require './mission_impossible'
=> true
> mi = MissionImpossible.new
=> #<MissionImpossible:0x007fc49a912b00>
> mi.mission_exist?
=> true
> mi.mission("フェルプス")
おはようフェルプス君。

昨夜、プロジェクトX内において
NullObjectモジュールなる不審物を発見。
調査の結果、これが我軍の勝利に深刻な影響を及ぼす
危険因子であることが判明した。

そこで今回の君の使命だが、
このモジュールをプロジェクトXより速やかに撤去し、
その安全を確保することにある。

例によって、君もしくはメンバーが捕らえられ、
あるいは殺されても当局はいっさい関知しないからそのつもりで。

なお、このメソッドは自動的に消滅する。
成功を祈る。

=> nil
{% endhighlight %}

当然に`mission`メソッドは何度も呼ぶことができてしまいます。

そこで`OneTime`モジュールで制約を掛けます。

{% highlight ruby %}
+ require "./onetime"

module CoreExt
  refine String do
    def ~
      margin = scan(/^ +/).map(&:size).min
      gsub(/^ {#{margin}}/, '')
    end
  end
end

class MissionImpossible
  using CoreExt
+ extend OneTime

  def mission_exist?
    !!methods.detect { |m| m==:mission }
  end

  def mission(name)
    mission_template name: name,
      status: ~<<-ST,
        昨夜、プロジェクトX内において
        NullObjectモジュールなる不審物を発見。
        調査の結果、これが我軍の勝利に深刻な影響を及ぼす
        危険因子であることが判明した。
      ST
      mission: ~<<-MS
        このモジュールをプロジェクトXより速やかに撤去し、
        その安全を確保することにある。
      MS
  end
+ onetime :mission

  private
  def mission_template(name:, status:, mission:)
    puts ~<<-MISSION
      おはよう#{name}君。

      #{status}
      そこで今回の君の使命だが、
      #{mission}
      例によって、君もしくはメンバーが捕らえられ、
      あるいは殺されても当局はいっさい関知しないからそのつもりで。

      なお、このメソッドは自動的に消滅する。
      成功を祈る。

    MISSION
  end
end
{% endhighlight %}

OneTimeモジュールをextendして、`onetime`クラスメソッドで対象のメソッドを指定します。

さて、`mission`メソッドを２度続けて呼んでみます。

{% highlight bash %}
% irb
> require './mission_impossible'
=> true
> mi = MissionImpossible.new
=> #<MissionImpossible:0x007f98da6f3018>
> mi.mission_exist?
=> true
> mi.mission("フェルプス")
おはようフェルプス君。

昨夜、プロジェクトX内において
NullObjectモジュールなる不審物を発見。
調査の結果、これが我軍の勝利に深刻な影響を及ぼす
危険因子であることが判明した。

そこで今回の君の使命だが、
このモジュールをプロジェクトXより速やかに撤去し、
その安全を確保することにある。

例によって、君もしくはメンバーが捕らえられ、
あるいは殺されても当局はいっさい関知しないからそのつもりで。

なお、このメソッドは自動的に消滅する。
成功を祈る。

=> nil
> mi.mission("フェルプス")
NoMethodError: undefined method `mission' for #<MissionImpossible:0x007f98da6f3018>
from (pry):5:in `__pry__'
> mi.mission_exist?
=> false
{% endhighlight %}

２度めの呼び出しは期待通り失敗しました。

## OneTimeモジュールの実装

OneTimeモジュールは次のような実装になってるんですよー。

{% gist 9562475 onetime.rb %}

TracePointオブジェクトを使ってメソッドの実行の返りをフックしています。


いやぁ、TracePointって本当にいいもんですね！

それでは次週をお楽しみください、さよなら、さよなら、さよなら。

> [class TracePoint](http://docs.ruby-lang.org/ja/2.1.0/class/TracePoint.html "class TracePoint")

---

<p style='color:red'>=== Ruby関連電子書籍100円〜で好評発売中！ ===</p>

[M'ELBORNE BOOKS]({{ BASE_PATH }}/books/ "M'ELBORNE BOOKS")

<a href="{{ BASE_PATH }}/books/">
  <img src="/assets/images/books/rack_cover.png" alt="rack" style="width:200px" />
</a>
<a href="{{ BASE_PATH }}/books/">
  <img src="/assets/images/books/ruby_pack8.png" alt="pack8" style="width:200px" />
</a>
<a href="{{ BASE_PATH }}/books/">
  <img src="/assets/images/books/ruby_parallel_cover.png" alt="ruby_parallel" style="width:200px" />
</a>
