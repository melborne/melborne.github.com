---
layout: post
title: "ねえRuby、どこまでが君でどこからが内部DSLなの？"
description: ""
category: 
tags: [dsl]
date: 2012-08-17
published: true
---
{% include JB/setup %}

Rubyは`内部DSL`(Domain Specific Language)に向いている言語と言われます。[Rake](https://rubygems.org/gems/rake 'rake \| RubyGems.org \| your community gem host'), [RSpec](https://rubygems.org/gems/rspec 'rspec \| RubyGems.org \| your community gem host'), [Rack](http://rack.github.com/ 'Rack: a Ruby Webserver Interface'), [Sinatra](http://www.sinatrarb.com/ 'Sinatra')などは内部DSL on Rubyの代表的なサンプルです。Rubyの構文のユルさとメタプログラミングが内部DSLを容易にするんですね。

しかし正直僕は、何が内部DSLで、何が内部DSLでないのかがわかっていません。人が何をさして「これは内部DSLである」と言っているのかがよくわかりません。

そんなわけで...

以下では、Userクラスの設計を通して内部DSLらしきものを作ってみます。このイテレーションに対して「ここからが内部DSLだよ」「これは内部DSLとは呼ばないよ」と、誰か僕に優しく教えてくれませんか？


## Userクラスの作成
Userクラスはユーザ情報を管理するクラスです。ファイル名はuser.rbとします。

まずはユーザの登録機能を作ります。

{% highlight ruby %}
# user.rb
class User
  @@users, @@id = [], 0
  attr_accessor :name, :age, :job
  attr_reader :id
  def initialize(name, age, job)
    @@id += 1
    @id, @name, @age, @job = @@id, name, age, job
    @@users << self
  end

  def to_s
    "%d:%s(%d/%s)" % [id, name, age, job]
  end
end

User.new('Charlie', 12, :programmer) # => 1:Charlie(12/programmer)
User.new('Ben', 17, :teacher) # => 2:Ben(17/teacher)
{% endhighlight %}

生成されたUserオブジェクトは@@usersクラス変数で管理します。

次に、検索機能を付けます。id, name, age, jobの各属性で検索ができるようにします。

{% highlight ruby %}
class User

  class << self
    def all
      @@users
    end

    [:id, :name, :age, :job].each do |m|
      define_method("find_by_#{m}") do |arg|
        blk = ->usr { usr.send(m) == arg }
        meth = [:id, :name].include?(m) ? :detect : :select
        @@users.send(meth, &blk)
      end
    end
  end
end
{% endhighlight %}
idとnameはユニークなものとしてdetectを、age, jobは複数の結果を返すものとしてselectを使った`find_by`メソッドをそれぞれ定義します。

ユーザを複数登録して、検索してみます。

{% highlight ruby %}
userlist = [
  [ 'Charlie',   12, :programmer ],
  [ 'Ben',       17, :teacher ],
  [ 'Dick',      33, :lawyer ],
  [ 'Elizabeth', 23, :doctor ],
  [ 'Fernand',   27, :teacher ],
  [ 'George',    33, :programmer ],
  ]

userlist.each { |attrs| User.new(*attrs) }

User.all # => [1:Charlie(12/programmer), 2:Ben(17/teacher), 3:Dick(33/lawyer), 4:Elizabeth(23/doctor), 5:Fernand(27/teacher), 6:George(33/programmer)]

User.find_by_id 4 # => 4:Elizabeth(23/doctor)
User.find_by_name 'Alice' # => nil
User.find_by_name 'Charlie' # => 1:Charlie(12/programmer)
User.find_by_age 33 # => [3:Dick(33/lawyer), 6:George(33/programmer)]
User.find_by_job :programmer # => [1:Charlie(12/programmer), 6:George(33/programmer)]
{% endhighlight %}

いいですね。

## 改良１（registerの導入）
さて、これでUserクラスができたので、大量にユーザを登録していきたいと思います。上のようにuserlistを作って、eachすればいいですね！

って、ちょっと躊躇しますよね。多重配列の括弧とカンマを打つのが面倒です。

もう少しマシなインタフェースを用意します。

{% highlight ruby %}
class User

  class << self
    def register
      yield(self)
    end

    alias :add :new

  end
end
{% endhighlight %}

クラスメソッドregisterとaddを用意しました。

これらを使ったユーザ登録は、次のようになります。

{% highlight ruby %}
User.register do |u|
  u.add 'Charlie',   12, :programmer
  u.add 'Ben',       17, :teacher
  u.add 'Dick',      33, :lawyer
  u.add 'Elizabeth', 23, :doctor
  u.add 'Fernand',   27, :teacher
  u.add 'George',    33, :programmer
end

User.all # => [1:Charlie(12/programmer), 2:Ben(17/teacher), 3:Dick(33/lawyer), 4:Elizabeth(23/doctor), 5:Fernand(27/teacher), 6:George(33/programmer)]
{% endhighlight %}

大分、入力が簡単になりました。

## 改良２（instance_evalの利用）
でもここまで来ると、ブロック引数でUserクラスを引き渡すのが面倒と言えば面倒です。

改善します。

{% highlight ruby %}
class User

  class << self
    def register(&blk)
      instance_eval(&blk)
    end

    alias :add :new

  end
end
{% endhighlight %}

instance_evalを使って、registerのブロック内をUserクラスのコンテキストとして評価させます。

registerの使い方は次のように変わります。

{% highlight ruby %}
User.register do
  add 'Charlie',   12, :programmer
  add 'Ben',       17, :teacher
  add 'Dick',      33, :lawyer
  add 'Elizabeth', 23, :doctor
  add 'Fernand',   27, :teacher
  add 'George',    33, :programmer
end

User.all # => [1:Charlie(12/programmer), 2:Ben(17/teacher), 3:Dick(33/lawyer), 4:Elizabeth(23/doctor), 5:Fernand(27/teacher), 6:George(33/programmer)]
{% endhighlight %}

更に入力が楽になりました。


## 改良３（userupコマンドの導入）
ここまで来たらUserクラスとユーザの登録コマンドを別ファイルにしたほうがよさそうです。
user.rbから'User.register do' 以下を削除し、次のような`userup`ファイルを用意します。

{% highlight ruby %}
#!/usr/bin/env ruby
require_relative "user"

User.register do
  add 'Charlie',   12, :programmer
  add 'Ben',       17, :teacher
  add 'Dick',      33, :lawyer
  add 'Elizabeth', 23, :doctor
  add 'Fernand',   27, :teacher
  add 'George',    33, :programmer
end

puts User.all
{% endhighlight %}


userupに実行権限を付与して実行します。
{% highlight bash %}
% chmod +x userup 
% ./userup

1:Charlie(12/programmer)
2:Ben(17/teacher)
3:Dick(33/lawyer)
4:Elizabeth(23/doctor)
5:Fernand(27/teacher)
6:George(33/programmer)
{% endhighlight %}

ユーザは、userup内registerでユーザを登録して、userupコマンドを実行すれば良くなりました。

## 改良４（configファイルの導入）
しかしながら、実行コマンド内にユーザ登録をするというのもなんか変です。

ユーザ登録は別ファイルに分離して、それを読み込むようにするのがよさそうです。user.rbのregisterメソッドを改良します。

{% highlight ruby %}
class User

  class << self
    def register(cfg='userdata', &blk)
      case
      when blk then instance_eval(&blk)
      when cfg then instance_eval ::File.read(cfg)
      else raise ArgumentError
      end
    rescue Errno::ENOENT
      abort "userdata file `#{cfg}` not found"
    end

  end
end
{% endhighlight %}
registerにブロックが渡された場合はそれを評価しますが、ブロックが無い場合はcfgファイルを読み込んで評価するようにします。cfgファイルはデフォルトで'userdata'とします。

userupコマンドは次のようにします。
{% highlight ruby %}
#!/usr/bin/env ruby
require_relative "user"

User.register

puts User.all
{% endhighlight %}


そして、'userdata'ファイルを用意して、ここでaddコマンドでユーザ情報を登録していきます。
{% highlight bash %}
# userdata
add 'Charlie',   12, :programmer
add 'Ben',       17, :teacher
add 'Dick',      33, :lawyer
add 'Elizabeth', 23, :doctor
add 'Fernand',   27, :teacher
add 'George',    33, :programmer
{% endhighlight %}

準備ができたので、`userup`してみます。

{% highlight bash %}
% ./userup

1:Charlie(12/programmer)
2:Ben(17/teacher)
3:Dick(33/lawyer)
4:Elizabeth(23/doctor)
5:Fernand(27/teacher)
6:George(33/programmer)
{% endhighlight %}

いいですね。


## 改良５（IRBの利用）

最後に仕上げとして、userupコマンドをirbを使ったインタラクティブなものにします。

{% highlight ruby %}
#!/usr/bin/env ruby
require_relative "user"

User.register

require "irb"
IRB.start
{% endhighlight %}

'userup'してみます。

{% highlight ruby %}
% ./userup
IRB on Ruby1.9.3
>> User.all #=> [1:Charlie(12/programmer), 2:Ben(17/teacher), 3:Dick(33/lawyer), 4:Elizabeth(23/doctor), 5:Fernand(27/teacher), 6:George(33/programmer)]
>> User.find_by_name 'Fernand' #=> 5:Fernand(27/teacher)
>> User.find_by_age 33 #=> [3:Dick(33/lawyer), 6:George(33/programmer)]
>> User.find_by_job :programmer #=> [1:Charlie(12/programmer), 6:George(33/programmer)]
>> exit 
{% endhighlight %}

いいですね。



で、最初の質問に戻ります。

**どれが内部DSLなのか僕に教えてください！**


[Inner DSL on Ruby sample? — Gist](https://gist.github.com/3384729 'Inner DSL on Ruby sample? — Gist')

----

関連記事：

[SinatraはDSLなんかじゃない、Ruby偽装を使ったマインドコントロールだ！](http://melborne.github.com/2011/06/03/Sinatra-DSL-Ruby/ 'SinatraはDSLなんかじゃない、Ruby偽装を使ったマインドコントロールだ！')

----

{{ 4864010471 | amazon_medium_image }}
{{ 4864010471 | amazon_link }} by {{ 4864010471 | amazon_authors }}

