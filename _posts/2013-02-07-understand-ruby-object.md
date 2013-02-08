---
layout: post
title: 'Rubyを始めたけど今ひとつRubyのオブジェクト指向というものが掴めないという人、ここに来て見て触って！'
description: ""
category: 
tags: 
date: 2013-02-07
published: true
---
{% include JB/setup %}

Rubyのオブジェクト指向は一貫性があってわかりやすいという評判だけれども、オブジェクトを意識しない便利な手続き的な書き方もできるからそれがRubyの本来の姿を分かり難くしているという面もあってその辺でRubyを始めたけど今ひとつ本質的なものが見えてこない人たちもいるんじゃないかと思う今日此の頃ですが皆さんいかがお過ごしですか？

それで随分と前に僕がRubyを始めてそんなに時間が経っていないときに書いたブログの記事があってそのことを思い出して、読み返してみるとRubyのオブジェクトを中心にしたちょっとユニークな説明になっていてまあ書き足りない部分もあるけれどもあの頃の知識でよく書けてるじゃないのなどと自画自賛しつつ、これは先の「Rubyを始めたけど今ひとつ本質的なものが見えてこない人たち」の役にも立つのではないかという発想が生まれて、結果ここにその記事群の文体を変えたり間違いを直したり挿絵を入れたりして加筆修正したものを再掲しましたのでどなたかのお役に立てれば幸いです。

加えて昨年12月より始めている「このブログの記事を電子書籍化してGumroadで販売する」という僕の個人プロジェクトがあるんだけれどもこの記事をその一冊に加えましたので電子書籍版に興味があったりまあ無くてもお試し的なノリとか応援的なノリとか冷やかし的なノリとかで買ってもいいぜよ100円ならとおっしゃる方などが居られましたら、是非ともご検討のほどよろしくお願いしますm(__)m


> [M'ELBORNE BOOKS]({{ site.url }}/books/ 'M'ELBORNE BOOKS')

![Alt title]({{ site.url }}/assets/images/2013/02/ruby_object_cover.png)


---

##１章　Rubyにおけるオブジェクトの種類
Rubyはオブジェクト指向言語であり、Ruby実行空間に存在するオブジェクトをその操作対象とします。Ruby実行空間には３種類のオブジェクト、すなわち「インスタンスオブジェクト」、「クラスオブジェクト」、そして「モジュールオブジェクト」が存在しています。これらは通常単に、「オブジェクト（またはインスタンス）」、「クラス」、「モジュール」と呼ばれています。以下順に各オブジェクトの特徴について説明していきます。



##２章　クラスオブジェクト ─クラスとしての顔─
クラスオブジェクトは通常単に「クラス」と呼ばれ、主にRuby実行空間にオブジェクトを生み出すために存在します。生み出されるオブジェクトのデザインは、クラスに記述されており、ユーザがオブジェクトにアクセスしてその機能を実現しようとするとき、オブジェクトはクラスからその機能を借り出します。

Rubyにはその設計者により予め多数のクラスが用意されています。これらは組み込みクラスと呼ばれます。ユーザは組み込みクラスを自由に使えますが、**class**式を使って独自クラスを定義することもできます。**Creature**クラスを定義してみましょう。
{% highlight ruby %}
class Creature
  def initialize(name)
    @name = name
  end
end
{% endhighlight %}

仮に、ユーザがclass式を使って既存クラスと同名のクラスを定義した場合、それは既存クラスの書き換えではなく拡張となります。その既存クラスが本来持っている機能は失われず、新たな機能がそこに付加されることになるのです。**String#expand**を定義します。
{% highlight ruby %}
class String
  def expand(n=2)
    self.gsub(/./) { |m| m * n }
  end
end

my_name = "charlie"
my_name.length # => 7
my_name.expand # => "cchhaarrlliiee"
{% endhighlight %}

もっとも同名のメソッドを再定義すれば、それは基のメソッドの上書きになるので注意を要します。
{% highlight ruby %}
class String
  def length
    "I don't wanna tell you."
  end
end

"Charlie".length  # => "I don't wanna tell you."
{% endhighlight %}

特定のクラスからオブジェクトを生成するには、**new**メソッドを使います。"Doggie"という名の生物を生成しましょう。
{% highlight ruby %}
class Creature
  def initialize(name)
    @name = name
  end
end

# Creatureクラスのnewメソッドでオブジェクトを生成する
my_pet = Creature.new('Doggie') 
{% endhighlight %}

一方で、代表的な組み込みクラスでは「リテラル表記」を使って、簡易にオブジェクトを生成することができます。
{% highlight ruby %}
# 文字列オブジェクトの生成
my_name = "Charlie"
# 整数オブジェクトの生成
my_age = 195
# 配列オブジェクトの生成
my_pets = [ 'Dog', 'Crocodile', 'Hippopotamus' ]
# ハッシュオブジェクトの生成
my_favorite = { :number => 3, :language => 'Ruby', :color => 'Blue' } 
# 範囲オブジェクトの生成
my_range = 9..21
# 正規表現オブジェクトの生成
my_regexp = /ruby/ 
{% endhighlight %}

オブジェクトの特性はそのクラスのメソッド定義でほぼ決まります。既に見てきたように、メソッドは**def**式を使って定義できます。
{% highlight ruby %}
class Creature
  def initialize(name)
    @name = name
  end

  def name
    @name
  end
end
{% endhighlight %}
クラスに定義されるこの種のメソッドを「インスタンスメソッド」と呼びます。インスタンスメソッドはこのクラスから派生するオブジェクトの挙動を決定付けます。つまり、クラスからオブジェクトが生成されたとき、インスタンスメソッドがあたかも、オブジェクト自身が持つメソッドのように振る舞います。
{% highlight ruby %}
 my_pet = Creature.new('Doggie')
 my_pet.name   # => "Doggie"
{% endhighlight %}



##３章　クラスオブジェクト ─オブジェクトとしての顔─
確かにクラスはオブジェクトを生成するための雛形的なものです。しかし同時に、クラスはそれ自身もRuby実行空間に存在するオブジェクトなのです。

オブジェクトにクラスという母があるように、すべてのクラスにも**Class**クラスという母があります。

つまりすべてのクラスの雛形となっているのはClassクラスであり、クラスはすべてここから生成されているのです。**class**メソッドでこの事実を知ることができます（一部のクラスは省略しています）。
{% highlight ruby %}
Object.class           # => Class
Array.class            # => Class
Binding.class          # => Class
Data.class             # => Class
Exception.class        # => Class
Dir.class              # => Class
Encoding.class         # => Class
Enumerator.class       # => Class
File::Stat.class       # => Class
Hash.class             # => Class
IO.class               # => Class
File.class             # => Class
MatchData.class        # => Class
Method.class           # => Class
Module.class           # => Class
Numeric.class          # => Class
Proc.class             # => Class
Process::Status.class  # => Class
Random.class           # => Class
Range.class            # => Class
Regexp.class           # => Class
String.class           # => Class
Struct.class           # => Class
Symbol.class           # => Class
Thread.class           # => Class
ThreadGroup.class      # => Class
Time.class             # => Class
UnboundMethod.class    # => Class
TrueClass.class        # => Class
FalseClass.class       # => Class
NilClass.class         # => Class
{% endhighlight %}

そうなると、Classクラスの母は一体誰なのかという疑問が持ち上がります。Classクラスにclassメソッドを送ってこの疑問に答えましょう。
{% highlight ruby %}
Class.class # => Class
{% endhighlight %}
驚くべきことに、Classクラスの母もこのClassクラス自身だったのです！

あなたが後から作るクラスも、その母はあなたではなくClassクラスです。
{% highlight ruby %}
Creature.class # => Class
{% endhighlight %}
またある特定のクラスのサブクラスもその母はスーパークラスではなく、Classクラスです。
{% highlight ruby %}
class Person < Creature  # CreatureクラスのサブクラスPersonを定義

end

Person.class # => Class
{% endhighlight %}
兎にも角にも、あらゆるクラスは、**Class**という一つのクラスから生成されているのです。

つまりRuby実行空間には、最初にClassクラスから生成されたClassクラスがあり、そのClassクラスが次いで他のすべてのクラスを生成し、最後にこの生成された各種のクラスからオブジェクトが生成される、という構図が描かれます。

![Alt title noshadow]({{ site.url }}/assets/images/2013/02/ruby_class.png)

<br clear='all' />

クラスからオブジェクトを生成するときはユーザがnewメソッドを使ってその生成を明示し、これを変数などに格納してアクセスできるようにする必要があります。しかしクラスの生成にその必要はありません。class定義式の解析時にRubyが自動でそれらを生成します。生成されたクラスにはそのクラス名を冠した定数が付けられ、これによりユーザによるクラスへのアクセスが可能になります。

このことを確認するために、恣意的にClassクラスのnewクラスメソッドを使ってクラスを生成してみましょう。
{% highlight ruby %}
class Creature
  def initialize(name)
    @name = name
  end
end

puts Creature = Class.new(Creature) # !> already initialized constant Creature
# >> Creature
{% endhighlight %}
これによりCreature定数には既にCreatureクラスがセットされていることが確認できます。なお上記によりCreatureクラスのサブクラスが生成され、それがCreature定数に再設定されたことになります。

クラスには自身のためのselfメソッドを定義できます。これは通常「クラスメソッド」と呼ばれます。クラスに対しクラスメソッドを直接呼び出すことによって、クラス自身にアクセスできます。クラスメソッドはそこから派生したオブジェクト全体を管理するためなどに使うことができます。

Creatureクラスにそこから派生したオブジェクトの数を返す**count**クラスメソッドを定義します。def式においてメソッド名の前に**self**を置くことでクラスメソッドが定義できます。
{% highlight ruby %}
class Creature
  @@counter = 0
  def initialize(name)
    @name = name
    @@counter += 1
  end

  def self.count
    "You have #{@@counter} creatures."
  end
end

dog = Creature.new('hot')
alligator = Creature.new('thanks')
hippopotamus = Creature.new('idiot')

Creature.count  # => "You have 3 creatures."
{% endhighlight %}




##４章　継承（Inheritance）
「継承」とはクラス間の相互依存関係のことです。Rubyではあるクラスが定義したメソッドを、あたかも自分に定義されたもののように他のクラスが利用できます。利用される側をスーパークラス、利用する側をサブクラスと呼びます。

他のクラスを利用してクラスを定義する場合、自分の名前にスーパークラス名を接ぎ木します。CreatureクラスをスーパークラスとするPersonクラスを定義します。
{% highlight ruby %}
class Creature
  def initialize(name)
    @name = name
  end

  def name
    @name
  end
end

class Person < Creature  # CreatureクラスのサブクラスPersonを定義
  def initialize(name,age)
    super(name)
    @age = age
  end

  def age
   @age
  end
end

me = Person.new('Charlie', 8)
me.name   # => "Charlie"
me.age    # => 8
{% endhighlight %}
こうすればサブクラスPersonのインスタンスであるmeオブジェクトでも、自ら定義することなくメソッドnameが使えるようになります。つまり、me.nameが実行されたとき、このメッセージは最初Personクラスに送られて、そこで対応するnameメソッドが存在しないことが分かると、次いでそのスーパークラスに渡され実行されます（モジュールの話はここでは割愛します）。

一般的に言えば、Rubyはメッセージに対応するメソッドが見つかるまでクラスツリーを遡り、最後にはObjectクラス（正確にはBasicObjectクラス）に至ります。

一つのクラスは同時並行的に複数のクラスと継承関係になれません。つまり複数のスーパークラスを同時に持てないのです。このような制限を、制限のない「多重継承」に対して「単純継承」といいます。

しかし他のクラスのサブクラスをスーパークラスにすることはできます。この数つまり経時直線的な段数に制限はありません。CreatureクラスのサブクラスであるPersonクラスをスーパークラスとして、PersonInEarthを定義してみましょう。
{% highlight ruby %}
class PersonInEarth < Person
  def initialize(name, age, country)
    super(name, age)
    @country = country
  end

  def country
    @country
  end
end

a_friend = PersonInEarth.new('Fernando', 34, "Spain")
a_friend.name    # >> "Fernando"
a_friend.country # >> "Spain"
{% endhighlight %}

この継承関係を図に示します。

![ruby inheritance noshadow]({{ site.url }}/assets/images/2013/02/ruby_inherit.png)

<br clear='all' />


誰がスーパークラスかはsuperclassメソッドで調べることができます。
{% highlight ruby %}
PersonInEarh.superclass # >> Person
{% endhighlight %}

Rubyでは継承関係にない独立したクラスというのは作れません。クラス定義においてスーパークラスを指定しないとき、Rubyは勝手にObjectクラスをそのスーパークラスにセットします。つまりすべてのクラスはObjectクラスのサブクラスなのです。組み込みクラスも例外ではありません。

何も定義しないクラスでmethodsメソッドを呼べば、それが既にObjectクラスのサブクラスになっていることが確認できます（このメソッドを呼べること自体が証拠です）。
{% highlight ruby %}
class Nothing

end
n = Nothing.new
Nothing.superclass # => Object
n.methods # => [:nil?, :===, :=~, :!~, :eql?, :hash, :<=>, :class, :singleton_class, :clone, :dup, :initialize_dup, :initialize_clone, :taint, :tainted?, :untaint, :untrust, :untrusted?, :trust, :freeze, :frozen?, :to_s, :inspect, :methods, :singleton_methods, :protected_methods, :private_methods, :public_methods, :instance_variables, :instance_variable_get, :instance_variable_set, :instance_variable_defined?, :instance_of?, :kind_of?, :is_a?, :tap, :send, :public_send, :respond_to?, :respond_to_missing?, :extend, :display, :method, :public_method, :define_singleton_method, :object_id, :to_enum, :enum_for, :==, :equal?, :!, :!=, :instance_eval, :instance_exec, :__send__, :__id__]
{% endhighlight %}
NothingクラスはObjectクラスが持っているすべてのメソッドを継承しています。

継承はクラス間の師弟制度のようなものです。とりわけ、Rubyの継承は一子相伝、一人がそのすべてを引き継ぐという特徴を有します。この特徴のため、継承関係が成熟しクラス階層が限りなきものになったとしても、Rubyは迷うことなくその末端から頂点、つまりObjectクラスまでを遡ることができるのです。

基本的にサブクラスはスーパークラスの特性をすべて引き継ぎますが、サブクラスにおいてその一部を拒否したり再定義することは許されます。
{% highlight ruby %}
class PersonInEarth < Person
  undef :age  # ageメソッドを未定義にする

  def initialize(name,age,country)
    super(name,age)
    @country = country
  end

  def country
    @country
  end

  alias :name_old :name  #nameメソッドをname_oldに変える
  def name   # nameメソッドを再定義する
    "my name is #{name_old}."
  end
end

a_friend = PersonInEarth.new('Fernand', 34, "Spain")
p a_friend.name # >> "my name is Fernand."
p a_friend.age
  # ~> -:39: undefined method `age` for #<PersonInEarth:0x23550> (NoMethodError)
{% endhighlight %}




##５章　モジュールオブジェクト
単純継承はメソッド探索の複雑さを排除します。一方で継承の本来的意義を低下させ得ます。仮に異なる系譜の継承クラス群があり、その両方の系譜の特性を持ったクラスを生成したい場合、単純継承ではそれを一方の系譜のサブクラスとし、そこに他方の系譜の特性すべてを一から書き足す必要が生じます。これは継承の目的に反し極めて非生産的です。

Rubyでは「モジュール」がこの問題を最小化します。

モジュールは、継承関係に立つことができない独立したクラスです。そこからオブジェクトを生成することもできません。モジュールはその中に特定の機能のまとまりを持って、クラスに「Mix-in」つまり挿し木されます。モジュールをMix-inしたクラスは追加的にその機能を獲得することになります。ここでは**Behavior**モジュールを定義して、PersonInEarhクラスにMix-inしてみます。
{% highlight ruby %}
module Behavior
  def self.description  # モジュールメソッドの定義
    "I'm a Behavior Module."
  end

  def sleep  # インスタンスメソッドの定義
    "I'm sleeping."
  end

  def eat
    "I'm eating."
  end
end

class PersonInEarth < Person
  include Behavior  # Behaviorモジュールを読み込む
  def initialize(name,age,country)
    super(name,age)
    @country = country
  end

  def country
    @country
  end
end

a_friend = PersonInEarth.new('Fernand', 34, "Spain")
a_friend.eat # => "I'm eating."
a_friend.sleep # => "I'm sleeping."
Behavior.description # => "I'm a Behavior Module."
{% endhighlight %}

モジュールの定義は**module**式で行います。クラスと同様モジュールには、オブジェクトのためのインスタンスメソッドと、自身のためのselfメソッドとを定義できます。モジュールのselfメソッドは一般に「モジュールメソッド」と呼ばれています。

クラスにモジュールをMix-inするには**include**メソッドを使います。これによりあたかも、モジュールで定義したメソッドがクラスにあるかのように働きます。よって、クラスから生成されたオブジェクトは、それらのインスタンスメソッドを自由に使えるようになります。

もっとも、モジュールのselfメソッドがMix-in先クラスのselfメソッドとして働くことはありません。つまりモジュールメソッドはクラスメソッドにはならないのです。この点が継承の場合とは異なっています。

モジュールのMix-inによって継承におけるメソッド探索のルートが変わります。モジュールをMix-inしたクラス内が探索されると、そのスーパークラスに先立ってモジュール内が探索されます。多重継承におけるようなあいまいさはありません。**ancestors**メソッドでその順位を確認できます。PersonInEarthクラスでそれを確認します。
{% highlight ruby %}
PersonInEarth.ancestors # => [PersonInEarth, Behavior, Person, Creature, Object, Kernel, BasicObject]
{% endhighlight %}

PersonInEarthにおける継承関係とモジュールの位置づけを図にすると以下のようになります。

![Alt title noshadow]({{ site.url }}/assets/images/2013/02/ruby_module.png)

<br clear='all' />


オブジェクトにとって、その母がクラスであるならば、モジュールは、彼のベビーシッターのような存在です。母に代わって子をヘルプします。現実のベビーシッターがそうであるように、モジュールは、複数のクラスにおいて掛け持ちされ得ます。

なお、モジュールは継承関係には立てませんが、モジュールに他のモジュールをMix-inすることはできます。しかし最終的にモジュールはクラスにMix-inされ、その継承関係に割り込まなければ機能しません（モジュールメソッドは直接呼ぶことができます）。



##６章　インスタンスオブジェクト
インスタンスオブジェクトは通常単に「オブジェクト」あるいは「インスタンス」と呼ばれ、先に書いたようにクラスをnewすることでRuby実行空間に生み出されます。

Ruby実行空間では、各種のクラスから生み出された多数のオブジェクトが、順次・分岐・繰り返しの制御構造の中で相互に働き掛けあうことによって、ユーザの所望する意味のある結果が返されることになります。

Rubyでは「オブジェクト」が主役です。

ところがその存在の重みとは裏腹に、オブジェクトの中身はほとんど空です。基本的にオブジェクトは自分の属性情報のみを保持し、他のオブジェクトとの相互作用のためのメソッド群を保持しません。つまりインスタンスオブジェクトは、自分が何者で誰が親なのかということは知っているけれども、ユーザから送られてくるメッセージの処理方法を知らないということです。

オブジェクトへのアクセスはそれにメッセージを送ることで達成されます。より正確には、メッセージを送る以外にオブジェクトにアクセスする手段はありません。

結局、メッセージを受け取ったオブジェクトは、それを自分の生成元のクラスに投げ、彼女がオブジェクトに代わって答えを用意します。そのクラス自身が対応するメソッドを備えていない場合、先に書いたように、モジュールを含むクラスツリーを辿ってメソッドが探索されます。

PersonInEarthクラスの例で、メソッド探索の手順を追ってみましょう。
{% highlight ruby %}
class Creature
  def initialize(name)
    @name = name
  end

  def name
    @name
  end
end

class Person < Creature
  def initialize(name, age)
    super(name)
    @age = age
  end
  
  def age
    @age
  end
end

module Behavior
  def sleep
    "I'm sleeping."
  end

  def eat
    "I'm eating."
  end
end

class PersonInEarth < Person
  include Behavior
  def initialize(name, age, country)
    super(name, age)
    @country = country
  end
  
  def country
    @country
  end
end

a_friend = PersonInEarth.new('Fernando', 34, "Spain")

# a_friendでラベル付けされたオブジェクトにメッセージnameを送る
a_friend.name # => "Fernando"
{% endhighlight %}

この例でa_friendでラベル付けされたオブジェクトは、メッセージnameを受け取るとこれをその生成元であるPersonInEarthクラスへ送ります（後で述べるSingletonメソッドがある場合はまずそれを探索します）。PersonInEarthでは対応するnameメソッドを呼び出すために、まず自分自身がそれを持っているかが調べられます。次いで、そこにincludeしたBehaviorモジュール内が探索されます。PersonInEarthおよびBehaviorモジュールはnameメソッドを持っていないので、メッセージは今度はそのスーパークラスであるPersonに渡されます。

ところが、Personクラスもnameメソッドを備えていないので、メッセージは更にそのスーパークラスであるCreatureクラスに渡されることになります。そしてここに定義されたnameメソッドが実行され、その結果が順次逆のルートを辿って、a_friendでラベル付けされたオブジェクトからユーザに返されるのです。




##７章　Singletonメソッド（抽象メソッド）
オブジェクトの中身はほとんど空であるということを書きました。しかしオブジェクトはクラスやモジュールと同様に、その内部にselfメソッドを持つことができます。オブジェクトにおけるselfメソッドは、「Singletonメソッド」または「抽象メソッド」などと呼ばれています。

Singletonメソッドは、そのオブジェクト固有のメソッドを定義するために使われます。
{% highlight ruby %}
a_friend = PersonInEarth.new('Fernand', 34, "Spain")

def a_friend.name
  "My friend, #{@name}"
end

a_friend.name # => "My friend, Fernando"
{% endhighlight %}
メソッド定義におけるメソッド名の前にオブジェクトを置くことによって、そのオブジェクトのSingletonメソッドが定義できます。Singletonメソッドはクラスツリーの最下層に位置し、メソッド探索において最優先の探索先となります。

正確に記せばSingletonメソッドは、そのオブジェクト自身に定義されているのではなく、そのオブジェクトとそのクラスとの間に生成される、**無名のクラス**に定義されます。したがってこの無名クラスにSingletonメソッドを定義しても同様の結果が得られます。
{% highlight ruby %}
class << a_friend
  def name
    "My friend, #{@name}"
  end
end

a_friend.name # => "My friend, Fernando"
{% endhighlight %}
class名を無名とし、オブジェクト名を二重の接ぎ木記号で繋ぎます（感情的には接ぎ木の向きは逆ですが）。複数のSingletonメソッドをまとめて定義する場合、この書式が有用です。この無名クラスは「Singletonクラス」とも呼ばれます。

![Alt title noshadow]({{ site.url }}/assets/images/2013/02/ruby_singleton.png)

<br clear='all' />

Singletonクラスはクラスメソッドやモジュールメソッドを定義する場合にも使えます。



##８章　extend
なおSingletonクラスはクラスに他ならないので、当然そこにモジュールをMix-inできます。
{% highlight ruby %}
module Business
  def job
    "Programmer"
  end
end

class << a_friend
  include Business
end

a_friend.job # => "Programmer"
{% endhighlight %}
SingletonクラスにMix-inされたBusinessモジュールのjobメソッドは、a_friendオブジェクトのSingletonメソッドになります。

しかしRubyではもっと簡単に、モジュールメソッドをSingletonメソッドとしてMix-inする方法があります。それが「extend」です。

SingletonメソッドがSingletonクラスのメソッドを直接オブジェクトに追加できるようにするのと同様、extendはモジュールのメソッドを直接オブジェクトに追加できるようにします。
{% highlight ruby %}
a_friend.extend Business

a_friend.job # => "Programmer"
{% endhighlight %}
これによりモジュール内メソッドは特定のオブジェクトの機能になります。

![Alt title noshadow]({{ site.url }}/assets/images/2013/02/ruby_extend.png)

<br clear='all' />



##９章　まとめ
最後にクラス、モジュールおよびオブジェクトの特性を整理しておきましょう。

1. すべてのクラスは、Classクラスから生成される。
1. クラスは、オブジェクトの雛形となり、それを生み出す母のような存在である。
1. それと共にそれ自身もオブジェクトである。
1. クラスは、オブジェクトのためのインスタンスメソッドと自身のためのクラスメソッドを持てる。
1. クラスは、継承によって他のクラスのメソッドを利用できる。
1. すべてのクラスは継承に係わっていて、その頂点にはObjectクラスがいる。
1. Rubyの継承は、スーパークラスを唯一つしか持たない単純継承である。
1. しかし継承の経時直線的な段数には制限はない。
1. モジュールは、クラスに代わってオブジェクトを支援する、ベビーシッターのような存在である。
1. モジュールは継承関係に係われず、オブジェクトを生成することもできない。
1. モジュール自身もオブジェクトであり、インスタンスメソッドの他に自身のためのモジュールメソッドを持てる。
1. オブジェクトは、クラスから生成される。
1. オブジェクトがRuby実行空間における主役である。
1. オブジェクトには、メッセージ送信以外にアクセス方法がない。
1. オブジェクトに送られたメッセージは、クラスツリーに従って順次クラスに渡される。
1. オブジェクト自身も固有のメソッドを持てる。

##付録１　RubyのObjectクラスは過去を再定義するタイムマシンだ！

Objectクラスはすべてのクラスのスーパークラスです。よってObjectクラスに定義されたインスタンスメソッドoは、すべてのクラスで定義されたインスタンスメソッドoになります。
{% highlight ruby %}
class Object
  def o
    'o'
  end
end

class MyClass

end

Object.new.o # => "o"
Array.new.o # => "o"
Hash.new.o # => "o"
MyClass.new.o # => "o"
{% endhighlight %}
ClassクラスもObjectクラスのサブクラスなので、このインスタンスメソッドoは当然、Classクラスのインスタンスメソッドoにもなります。
{% highlight ruby %}
Class.new.o # => "o"
{% endhighlight %}

一方、Classクラスはすべてのクラスの生成クラスです。よってClassクラスのインスタンスメソッドとなったoは、すべてのクラスのクラスメソッドself.oになります。
{% highlight ruby %}
Array.o # => "o"
Hash.o # => "o"
MyClass.o # => "o"
{% endhighlight %}
この中には当然Objectクラスが含まれているので、Classクラスのインスタンスメソッドoは、Objectクラスのクラスメソッドself.oにもなります。
{% highlight ruby %}
Object.o # => "o"
{% endhighlight %}

ところが、ObjectクラスはClassクラスのスーパークラスなので、Objectクラスのクラスメソッドになったself.oはClassクラスのクラスメソッドself.oにもなります。
{% highlight ruby %}
Class.o # => "o"
{% endhighlight %}

整理しましょう。

Objectクラスが１つのインスタンスメソッドoを持つと、それがClassクラスを含むすべてのクラスのインスタンスメソッドoとなり、Objectを含むすべてのクラスのクラスメソッドself.oとなり、Classクラスのクラスメソッドself.oとなります。こうしてRuby実行空間に存在するすべてのクラスには、インスタンスメソッドoとクラスメソッドself.oが生まれることとなるのです。

ClassクラスはObjectクラスを含むすべてのクラスの母です。従って、すべてのクラスはClassクラスの特性に依存します。一方でClassクラスはその子であるObjectクラスの弟子（サブクラス）です。従って、ClassクラスはObjectクラスの特性を受け継ぎます。

このような多層的循環構造によってObjectクラスが変わると、Classクラスが変わり、その変化はすべてのクラスを変えるのです。つまりObjectクラスへのオペレーションは、過去の事実（Classクラス）を再定義し、延いては今の世界（すべてのクラス）を再構築するのです！

そうRubyのObjectクラスは...

「時空を超えて過去を再定義し、世界を再構築するタイムマシン」なのです！

ところでObjectクラスにはKernelモジュールがincludeされています。モジュールに定義されたインスタンスメソッドはそれをincludeしたクラスのものになるので、KernelモジュールのインスタンスメソッドはObjectクラスのものになります。

つまりKernelモジュールはObjectクラスに過去を変えるためのメソッドを補給します。Kernelモジュールから補給されたメソッドは、Objectクラスに定義されたメソッドとして同様に、過去を再定義し今の世界を再構築します。

そうRubyのKernelモジュールは...

「タイムマシン補助燃料タンク」だったのです！

##付録２　RubyのModuleクラスはすべてのモジュールの母であり同時にすべてのクラスの父である！

Moduleクラスはすべてのモジュールの生成クラスです。よってModuleクラスに定義されたインスタンスメソッドmは、すべてのモジュールで定義されたモジュールメソッドself.mになります。
{% highlight ruby %}
class Module
  def m
    'm'
  end
end

Module.new.m # => "m"
Kernel.m # => "m"
Enumerable.m # => "m"
Math.m # => "m"
{% endhighlight %}
またModuleクラスはClassクラスのスーパークラスでもあります。よってModuleクラスに定義されたインスタンスメソッドmは、Classクラスで定義されたインスタンスメソッドmになります。
{% highlight ruby %}
Class.new.m # => "m"
{% endhighlight %}
ここで、Classクラスはすべてのクラスの生成クラスです。よってClassクラスのインスタンスメソッドとなったmは、すべてのクラスのクラスメソッドself.mになります。
{% highlight ruby %}
Object.m # => "m"
Array.m # => "m"
class MyClass
end
MyClass.m # => "m"
{% endhighlight %}
この中には当然Moduleクラスも含まれているので、Classクラスのインスタンスメソッドmは、Moduleクラスのクラスメソッドself.mにもなります。
{% highlight ruby %}
Module.m # => "m"
{% endhighlight %}
ところが、ModuleクラスはClassクラスのスーパークラスなので、Moduleクラスのクラスメソッドになったself.mは、Classクラスのクラスメソッドself.mにもなります。
{% highlight ruby %}
Class.m # => "m"
{% endhighlight %}

整理しましょう。

Moduleクラスが１つのインスタンスメソッドmを持つと、それがすべてのモジュールのモジュールメソッドself.mとなり、Classクラスのインスタンスメソッドmとなり、ModuleクラスおよびClassクラスを含む、すべてのクラスのクラスメソッドself.mとなります。

Moduleクラスはモジュールの生成クラスです。よって、Classクラスがすべてのクラスを生み出すように、Moduleクラスはすべてのモジュールを生み出します。そして生み出されたすべてのモジュールは、Moduleクラスの特性に依存します。

そう、Classクラスがすべてのクラスの母であるなら...

「Moduleクラスはすべてのモジュールの母」なのです！

加えて、ModuleクラスはClassクラスのスーパークラスでもあります。そのためModuleクラスに定義されたすべてのメソッドはClassクラスで使えます。すべてのクラスはその生成クラスであるClassクラスの影響を受けるので、結果すべてのクラスはModuleクラスの影響を受けることになります。つまり、ModuleクラスはClassクラスによるクラス生成において、それを支援する極めて重要な役割を担っているのです。

要するにModuleクラスは、すべてのクラスの母であるClassクラスを支える...

「すべてのクラスの父」なのです！

そうModuleクラスは、一方で各モジュールの母として彼らを生み出し、他方で各クラスの父としてClassクラスを支えるという、父と母の２つの顔を持った実体だったのです！

---


![Alt title]({{ site.url }}/assets/images/2013/02/ruby_object_cover.png)

<a href="http://gum.co/zxUk" class="gumroad-button">電子書籍「オブジェクトの理解から始めるRuby」EPUB版</a><script type="text/javascript" src="https://gumroad.com/js/gumroad-button.js"></script><script type="text/javascript" src="https://gumroad.com/js/gumroad.js"></script>


このリンクはGumroadにおける商品購入リンクになっています。クリックすると、オーバーレイ・ウインドウが立ち上がって、この場でクレジットカード決済による購入が可能です。購入にはクレジット情報およびメールアドレスの入力が必要になります。購入すると、入力したメールアドレスにコンテンツのDLリンクが送られてきます。

> [M'ELBORNE BOOKS]({{ site.url }}/books/ 'M'ELBORNE BOOKS')

---

この記事は過去に書いた次の記事がベースとなっています。

> [Rubyのクラスはオブジェクトの母、モジュールはベビーシッター](http://melborne.github.com/2008/08/16/Ruby/ 'Rubyのクラスはオブジェクトの母、モジュールはベビーシッター')
>
> [RubyのObjectクラスは過去を再定義するタイムマシンだ！](http://melborne.github.com/2008/09/27/Ruby-Object/ 'RubyのObjectクラスは過去を再定義するタイムマシンだ！')
> 
> [RubyのModuleクラスはすべてのモジュールの母であり同時にすべてのクラスの父である！](http://melborne.github.com/2008/09/30/Ruby-Module/ 'RubyのModuleクラスはすべてのモジュールの母であり同時にすべてのクラスの父である！')

---

(追記：2013-02-08) タイトルを変更し前文を追加しました。

