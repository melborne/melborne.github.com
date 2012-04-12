---
layout: post
title: Rubyのyieldは羊の皮を被ったevalだ！
date: 2008-08-12
comments: true
categories:
---

Yugui著「初めてのRuby」の９章に、Rubyの黒魔術の一つとしてeval族と称されるメソッド群が紹介されている。

{{ 4873113679 | amazon_medium_image }}
{{ 4873113679 | amazon_link }}

危険らしい。素人が安易に手を出すべきではなさそうだ。でも魅力的らしい。

暗黒の世界に引かれていく自分がいる…

勉学のために覗くだけならいいだろうし、危険であればその正しい理解がより重要になるだろう。自分が学んで理解したことをここに整理してみよう。

eval族と呼ばれるものには、instance_evalメソッド、class_evalメソッド(またはmodule_eval)、および組み込み関数evalがある。

##instance_eval
Ruby空間における操作対象はオブジェクトである。オブジェクトは外からのメッセージを受け取ると、その中の対応するメソッドを起動して、そこに書かれている手続きを実行する。

メソッドは他のオブジェクトを引数として取ることができる。引数として渡されたオブジェクトは、メソッドにおいてオブジェクトとして操作され、メソッド内の他のオブジェクトと協同して、その処理の結果をメッセージ送信者に返す。

instance_evalメソッドは文字列オブジェクトを引数として取ることができる。しかし、このメソッドは他の一般的なメソッドとは異なり、これを文字列オブジェクトとしては扱わない。これをRubyの手続きとして扱う。
{% highlight ruby %}
  [1,2,3].instance_eval "print 'Hello'"   # => Hello
{% endhighlight %}
ここでprintは、トップレベルで実行されているように見えるけれども、"print 'Hello'"はinstance_evalの引数として、配列オブジェクト[1,2,3]に渡されているから、この配列オブジェクト内で実行されている、ということを理解しなければならない。

そのことはこうするとよく分かるかもしれない。
{% highlight ruby %}
  [1,2,3].instance_eval "print reverse"    # => [3,2,1]
{% endhighlight %}
文字列中のreverseは明らかに、メッセージを受け取る配列オブジェクトに適用されている。

つまりinstance_evalはオブジェクトの外にいてオブジェクトの中のコンテキストで、渡された文字列をRubyコードとして評価する。

これは確かに恐ろしいことかもしれない。なぜなら完成したプログラムに対して、そのユーザが後からキーボードで文字列を入力することによりコードを追加し改変し、場合によっては破壊できることを意味するからだ。
{% highlight ruby %}
  class Account
    @@bank_money = 0
    def initialize(balance)
      @balance = balance
      @@bank_money += @balance
    end
  end
  my_account = Account.new(10000)
  my_account.instance_eval "print @balance = @balance * 100"
        # =>1000000
{% endhighlight %}
インスタンス変数@balanceは、my_accountオブジェクトの内部状態を保持する。通常この値にアクセスするには、クラスにそのアクセッサメソッドを用意し、これを介さなければならない。
{% highlight ruby %}
  def balance
   @balance
  end
  def balance=(amt)
   @balance = amt
  end
または
  attr_accessor :balance
{% endhighlight %}
Rubyのようなオブジェクト指向言語ではオブジェクトへのアクセスは原則、用意されたメソッドからしか行えない。これがオブジェクトを予期せぬ変更や破壊から守る。

しかしinstance_evalを使えば上のようにアクセッサメソッドを介さずに、インスタンス変数@balanceの参照を変更し、その結果にアクセスすることが可能となる。

instance_evalを使えばメソッド定義も難なくできてしまう。
{% highlight ruby %}
  my_account = Account.new(10000)
  his_account = Account.new(30000)
  my_account.instance_eval "def transfer_all_to_me; @balance += @@bank_money; end"
   #メソッドを定義する
  my_account.transfer_all_to_me
  my_account.instance_eval "print @balance"
      # => 50000
{% endhighlight %}
transfer_all_to_meは
僕のアカウントオブジェクトのコンテキストで生成されるので{% fn_ref 1 %}、僕のオブジェクト専用のメソッド、つまりSingletonメソッド(抽象メソッド)だ。これで誰かが貯金をするたびに僕はお金持ちになっていく！

ここでは示されていないけれども、instance_evalを使えば、ユーザから受け取った文字列を名前としてメソッドを動的に定義する、という荒技も可能だ

行指向の文字列にはヒアドキュメントを使った方が見栄えがいい。
{% highlight ruby %}
  my_account.instance_eval <<DEF
    def transfer_all_to_me
      @balance += @@bank_money
    end
  DEF
{% endhighlight %}
こうすると、まるでブロックを渡しているように見える。

期待に違わず、instance_evalはブロックも受け取る。ブロックの中身を受け取ったオブジェクトのコンテキストでRubyコードとして評価する。だから上のコードはこうも書ける。
{% highlight ruby %}
  my_account.instance_eval do
    def transfer_me_all
      @balance += @@bank_money
    end
  end
{% endhighlight %}
当然にブロックには引数を渡したくなる。それが人情というものだ。Ruby1.9ではinstance_execがそれを可能にする。
{% highlight ruby %}
  my_account.instance_exec(2) do |arg|
    @@bank_money *= arg
    def transfer_me_all_with_double
      @balance += @@bank_money
    end
  end
  my_account.transfer_me_all_with_double
  my_account.instance_eval "print @balance"
      # => 90000
{% endhighlight %}
僕の口座が倍になった！

##class_eval(module_eval)
でもあまりにこれじゃ不公平だ。僕にだって幾らかの良心というものがある。そう思ったらclass_evalを使おう。

class_evalは、そのクラスのコンテキストで文字列やブロックを評価する。だからブロックでメソッド定義をすれば、そのメソッドはクラスのインスタンスメソッドになる。
{% highlight ruby %}
  my_account = Account.new(10000)
  his_account = Account.new(30000)
  Account.class_eval do
    def transfer_all_to_me
      @balance += @@bank_money
    end
  end
  my_account.transfer_all_to_me
  his_account.transfer_all_to_me
  my_account.instance_eval "print @balance"  # => 50000
  his_account.instance_eval "print @balance"  # => 70000
{% endhighlight %}
これでみんながハッピーになれる！

module_evalはclass_evalと同様に、そのモジュールのコンテキストで文字列やブロックを評価する。これを使えば後からモジュールにクラスを定義するようなことができる。

##eval
Rubyにはオブジェクトを意識しないで使える、evalも用意されている。
{% highlight ruby %}
  eval "print 'Hello'"  # => Hello
{% endhighlight %}
evalはRubyの組み込み関数、つまりObjectクラスのインスタンスメソッドだ。これはトップレベルオブジェクトmainのinstance_evalと等価になる。
{% highlight ruby %}
  eval "print self"     # => main
  self.instance_eval "print self"  # => main
{% endhighlight %}
つまりデフォルトでevalはmainオブジェクトのコンテキストで文字列を評価する。

でも、第２引数に他のコンテキストを持ったBindingオブジェクトを与えた場合、evalはそのコンテキストで文字列を評価する。これによりevalの実行コンテキストをトップレベル以外にすることができる。
{% highlight ruby %}
  class Account
    @@bank_money = 0
    def initialize(balance)
      @balance = balance
      @@bank_money += @balance
    end
    def bind    # accountの環境情報を返すメソッド
      binding
    end
  end
  my_account = Account.new(10000)
  # evalの第２引数にBindingオブジェクトを渡す
  # ヒアドキュメントはこういうときでも便利に使える
  eval(<<DEF, my_account.bind)
   def transfer_all_to_me
     @balance += @@bank_money
   end
  DEF
  my_account.transfer_all_to_me
  my_account.instance_eval "print @balance"
     # => 20000
{% endhighlight %}
これは先の例のinstance_evalの使い方と等価である。evalの第２引数にmy_accountオブジェクトのコンテキストを渡すことにより、そのコンテキストでブロックを評価する。

evalはinstance_evalやclass_evalと異なり、引数にブロックを取れない。

##yield
結局eval族は、その引数に与えられた文字列またはブロックを、それが置かれたコンテキストとは別のコンテキストで評価できるようにするものだ。

Rubyにおいてブロックを評価する一般的方法は、ブロックを渡すメソッド内でyieldを呼ぶことである。
{% highlight ruby %}
  class String
    def speak
      yield
    end
  end
  "Charlie".speak { print "hello" }  # => hello
{% endhighlight %}
ブロックが評価されるコンテキストは基本的にそれが置かれたコンテキストだけれど、yieldに引数を取ることによってこれを変えることができる。
{% highlight ruby %}
  class String
    def speak
      yield
    end
    def talk
      yield self   # selfを引数に取る
    end
  end
  "Charlie".speak { print self }  # => main
  "Charlie".talk { |this| print this }  # => Charlie
{% endhighlight %}
ブロックには当然メソッド定義を置くこともできるので、コンテキストの切替えと共にこれを用いれば、先に示したAccountクラスのインスタンス変数にもアクセスできるようになる。
{% highlight ruby %}
  class Account
    def initialize(balance)
      @balance = balance
    end
    def yield_eval   #ブロックを評価するための汎用メソッド
      yield self
    end
  end
  my_account = Account.new(10000)
  my_account.yield_eval do |this|
    def this.add_money(i)
      @balance += i
    end
  end
  p my_account.add_money(10000)    # => 20000
{% endhighlight %}
ここでadd_moneyメソッドは、my_accountオブジェクトのSingletonメソッドである。だからブロックを受ける汎用メソッドを予め用意しておけば、先の例のinstance_eval相当のことができるようになる{% fn_ref 2 %}。

class_eval相当の処理をyieldで実現することもできる。
{% highlight ruby %}
  my_account = Account.new(10000)
  his_account = Account.new(30000)
  my_account.yield_eval do
    def add_money(i)
      @balance += i
    end
    public :add_money
  end
  p my_account.add_money(10000)   # => 20000
  p his_account.add_money(10000)   # => 40000
{% endhighlight %}
ここでyield_evalメソッドはAccountクラスにadd_moneyメソッドを追加する。これでみんながハッピーになれる！

こうしてみるとyieldは、evalの底知れないパワーには及ばないとしても、プログラミングに高い自由度を与える強力なツールであることは間違いないし、まだまだ秘められたパワーを持っていそうだ。そう、だからRubyのyieldは…

羊の皮を被ったevalに違いない！

関連記事：
[Rubyのシンボルは文字列の皮を被った整数だ！](/2008/08/02/Ruby/)
[Rubyのブロックはメソッドに対するメソッドのMix-inだ！](/2008/08/09/Ruby-Mix-in/)
[Rubyのクラスはオブジェクトの母、モジュールはベビーシッター](/2008/08/16/Ruby/)


{% footnotes %}
   {% fn Ruby1.9。Ruby1.8.7ではクラス変数@@bank_moneyがトップレベルのコンテキストで評価されてしまいうまく動作しません。なぜだろう？ %}
   {% fn 先の例におけるクラス変数@@bank_moneyのコンテキストは、yieldを用いる場合なぜかmainのまま変わりません。理由は分かりません。その対応版の作成は断念しました。 %}
{% endfootnotes %}
