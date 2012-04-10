---
layout: post
title: RubyのメタプログラミングでInterpreterパターンを実装しよう！
date: 2011-07-25
comments: true
categories:
---


「Rubyによるデザインパターン」(著：ラス・オルセン)は
GoFの23あるデザインパターンのうちの14個について
Rubyによる実装とその解説を試みた書籍です

{{ 4894712857 | amazon_large_image }}

{{ 4894712857 | amazon_link }}

{{ 4894712857 | amazon_authors }}

###Interpreterパターン
その中にInterpreterパターンを取り扱った章(15)があります
Interpreterパターンでは言語上に
問題解決に特化した専用言語を構築します
専用言語で書かれたプログラムはパーサで抽象構文木(AST)
というオブジェクトのツリー構造に変換され
評価(interpret)されます
ASTはオブジェクトノードの集まりですが
これはその言語のプリミティブなノードである終端(terminal)と
終端への参照を含む高階の非終端(nonterminal)で構成されます

本書ではRubyによるInterpreterパターンの実装例として
ファイル検索用インタープリタが紹介されています
このインタープリタでは最終的に以下のような書き方で
ファイル検索が行えます
{% highlight ruby %}
  (bigger(1024) & writable) | file_name('*.mp3')
{% endhighlight %}

説明は不要と思いますが
この記述で1KB以上の書き込み可能ファイルと
mp3ファイルの集合が表現されています
Rubyをよく知っている人なら
このプログラムを構文解析するのに
パーサは不要であることに気づくでしょう

そう
Rubyでは演算子のように使える & や | メソッドを活用することで
パーサ無しで利用者にやさしい専用言語を構築できるのです！
つまりこれは内部DSLですね

そして特定のディレクトリでこの集合を評価することで
該当ディレクトリに含まれるファイルリストが得られます
{% highlight ruby %}
  file_exp = (bigger(1024) & writable) | file_name('*.mp3')
  puts file_exp.evaluate('~/target_directory')
{% endhighlight %}

この専用言語を構築する具体的な手順は
本書を参照してくださいね
もっとも実装コードだけなら
以下のサイトから取得することもできます{% fn_ref 1 %}

[Design Patterns In Ruby: Home](http://designpatternsinruby.com/index.html)

###InterpreterBuilder
デザインパターン初学者の自分にとって
Interpreterパターンはとても新鮮に感じられました
しかしその一方でそれを構築するには
それなりの量のコードが必要であることを知りました
例えば上記ファイル検索用インタープリタを実現するのに
著者はおよそ120行のコードを書いています

でも中を見ると似たようなコードの繰り返しなんですよねー

そんなわけで..

Rubyのメタプログラミングを使って
Interpreterパターンを簡単に実現する
InterpreterBuilderというライブラリを書いてみました:)

早速先のファイル検索用インタープリタを
InterpreterBuilderライブラリを使って書き直してみます{% fn_ref 2 %}
{% highlight ruby %}
require "find"
require "interpreter_builder"
module FileSelect
  extend InterpreterBuilder    # (1)
  class Expression      # (2)
    def |(other)
      Or.new(self, other)
    end
    
    def &(other)
      And.new(self, other)
    end
    def evaluate(dir)
      files(dir).select { |f| yield f }
    end
    def files(dir)
      dir = File.expand_path(dir)
      Find.find(dir).select { |f| File.file? f }
    end
  end
  terminals = {
    all: ->f { true },
    file_name: ->f, pattern{ File.fnmatch pattern, File.basename(f) },
    bigger: ->f, size{ File.size(f) > size },
    writable: ->f { File.writable? f }
  }
  
  terminals.each do |name, blk|
    converter =->dir{ Expression.new.files(dir) }
    define_terminal(name, Expression, :evaluate, converter, &blk)  # (3)
  end
  
  nonterminals = {
    except: :-,
    or: :|,
    and: :&
  }
  
  nonterminals.each do |name, op|
    define_nonterminal(name, Expression, :evaluate, op, false)   # (4)
  end
  def except(exp)
    Except.new(All.new, exp)
  end
end
{% endhighlight %}
InterpreterBuilderを使うことで
ファイル検索用インタプリタの実装は
僅か50行になりました！

使い方の手順は以下のとおりです
1. InterpreterBuilderモジュールをextendする(1)
1. ASTノードのベースクラスExpressionを定義する(2)
1. define_terminalメソッドを使って終端オブジェクト(Expressionのサブクラス)を定義する(3)
1. define_nonterminalメソッドを使って非終端オブジェクト(Expressionのサブクラス)を定義する(4)

define_terminalではAll FileName Bigger Writableという名の
Expressionサブクラスを作ります
同時に同名の関数的メソッド
all file_name bigger writableも生成されます{% fn_ref 3 %}
第3引数にはサブクラスでオーバーライドするメソッド名を
第4引数にはその引数を被評価集合に変換するconverterを
更に被評価集合に対する適合条件をブロックで渡します

define_nonterminalではExcept Or Andという名の
Expressionサブクラスを作ります
第4引数にはその非終端で参照される
非終端オブジェクトに適用する演算子を指定します

説明が不十分で言ってることがよくわからないと思いますが
先のコードを見て理解して頂けると助かります^^;

InterpreterBuilderの内部実装は以下のとおりです
{% highlight ruby %}
# encoding: UTF-8
class String
  alias _capitalize capitalize
  def capitalize
    self.split('_').map(&:_capitalize).join
  end
end
module InterpreterBuilder
  def define_terminal(name, superclass, target_meth, converter=->p{p}, function=true)
    define_node(name, superclass, target_meth, function) do |*dir|
      converter[*dir].select { |item| yield item, *@attrs }
    end
  end
  def define_nonterminal(name, superclass, target_meth, op, function=true)
    define_node(name, superclass, target_meth, function) do |*dir|
      f1, *f2 = @attrs.map { |attr| attr.send(target_meth, *dir) }
      f1.send(op, *f2)
    end
  end
  def define_node(name, superclass, target_meth, function, &blk)
    klass = Class.new(superclass) do
      def initialize(*attrs)
        *@attrs = attrs
      end
      define_method(target_meth, &blk)
    end
    const_set(name.to_s.capitalize, klass)
    define_function(name) if function
  end
  def define_function(name)
    self.class_eval {
      define_method(name) do |*args|
        Module.const_get(name.to_s.capitalize).new(*args)
      end
    }
  end
end
{% endhighlight %}

###ユーザ検索用インタープリタ
別の例を示します
今度はInterpreterBuilderを使って
ユーザの属性集合を求める
ユーザ検索用のクエリー言語を構築してみます

今ここに
カンマ区切りのユーザ属性情報があります
{% highlight bash %}
Joe, 25, M, US, Programmer
Armstrong, 28, M, US, Teacher
Karen, 43, F, US, Programmer
Ken, 38, M, JP, Doctor
Yui, 18, F, JP, Student
Paku, 33, M, KO, RestaurantOwner
Soh, 51, M, KO, Teacher
Ralf, 29, M, DE, Programmer
Naomi, 16, F, FR, Student
{% endhighlight %}

ユーザ調査用インタープリタはこのユーザ情報を読み取り
以下のような簡単なクエリー言語を使って
対象ユーザの抽出を行えるようにします
{% highlight ruby %}
 except(nationality(:JP))  # 日本人以外のユーザ
 age(30, :>) & sex(:M)   # 30歳以上の男性ユーザ
 age(30, :<) & job('Programmer') & (nationality(:US) | nationality(:DE))
 # 30歳未満の米国またはドイツのプログラマー
{% endhighlight %}

最初にInterpreterBuilderを使わずに
このクエリー言語を構築するコードを示します
{% highlight ruby %}
# encoding: UTF-8
module Census
  Person = Struct.new(:name, :age, :sex, :nationality, :job)  
  
  class Expression
    def |(other)
      Or.new(self, other)
    end
    def &(other)
      And.new(self, other)
    end
    
    def evaluate(people)
      people.select { |f| yield f }
    end
  end
  module Interface
    def all
      All.new
    end
    def sex(sex)
      Sex.new(sex)
    end
    
    def age(age, op)
      Age.new(age, op)
    end
    
    def nationality(n)
      Nationality.new(n)
    end
    
    def job(job)
      Job.new(job)
    end
    
    def except(exp)
      Except.new(All.new, exp)
    end
  end
  include Interface
  class All < Expression
    def evaluate(people)
      super { true }
    end
  end
  class Sex < Expression
    def initialize(sex)
      @sex = sex
    end
  
    def evaluate(people)
      super { |p| p.sex == @sex }
    end
  end
  class Age < Expression
    def initialize(age, op)
      @age, @op = age, op
    end
  
    def evaluate(people)
      super { |p| p.age.send(@op, @age) }
    end
  end
  class Nationality < Expression
    def initialize(nationality)
      @nationality = nationality
    end
  
    def evaluate(people)
      super { |p| p.nationality == @nationality }
    end
  end
  class Job < Expression
    def initialize(job)
      @job = job
    end
  
    def evaluate(people)
      super { |p| p.job == @job }
    end
  end
  class Except < Expression
    def initialize(expression1, expression2)
      @expression1 = expression1
      @expression2 = expression2
    end
  
    def evaluate(people)
      @expression1.evaluate(people) - @expression2.evaluate(people)
    end
  end
  
  class Or < Expression
    def initialize(expression1, expression2)
      @expression1, @expression2 = expression1, expression2
    end
  
    def evaluate(people)
      @expression1.evaluate(people) | @expression2.evaluate(people)
    end
  end
  
  class And < Expression
    def initialize(expression1, expression2)
      @expression1, @expression2 = expression1, expression2
    end
  
    def evaluate(people)
      @expression1.evaluate(people) & @expression2.evaluate(people)
    end
  end
end
{% endhighlight %}
およそ120行のコードが必要になります

次にこれと等価なコードを
InterpreterBuilderを使って構築してみます
{% highlight ruby %}
# encoding: UTF-8
require "../lib/interpreter_builder"
module Census
  extend InterpreterBuilder
    
  Person = Struct.new(:name, :age, :sex, :nationality, :job)  
  class Expression
    def |(other)
      Or.new(self, other)
    end
    def &(other)
      And.new(self, other)
    end
    
    def evaluate(people)
      raise "override this method in the subclass"
    end
  end
  terminals = {
    all: ->person { true },
    sex: ->person,sex { person.sex == sex },
    age: ->person,age,op { person.age.send(op, age) },
    nationality: ->person, nation { person.nationality == nation },
    job: ->person,job { person.job == job }
  }
  
  terminals.each do |name, blk|
    define_terminal(name, Expression, :evaluate, &blk)
  end
  nonterminals = {
    except: :-,
    or: :|,
    and: :&
  }
  
  nonterminals.each do |name, op|
    define_nonterminal(name, Expression, :evaluate, op, false)
  end
  def except(exp)
    Except.new(All.new, exp)
  end
end
{% endhighlight %}
48行で構築できました

では先のユーザ情報を読み取って
クエリーを実行してみましょう
{% highlight ruby %}
require "./sample/census"
include Census
people = DATA.lines.map do |line|
  name, age, sex, nationality, job = line.scan(/\w+/)
  Person[name, age.to_i, sex.intern, nationality.intern, job]
end
none_japanese = except(nationality(:JP))
puts none_japanese.evaluate(people)
over30men = age(30, :>) & sex(:M)
puts over30men.evaluate(people)
under30_us_or_de_programmer = age(30, :<) & job('Programmer') & (nationality(:US) | nationality(:DE))
puts under30_us_or_de_programmer.evaluate(people)
__END__
Joe, 25, M, US, Programmer
Armstrong, 28, M, US, Teacher
Karen, 43, F, US, Programmer
Ken, 38, M, JP, Doctor
Yui, 18, F, JP, Student
Paku, 33, M, KO, RestaurantOwner
Soh, 51, M, KO, Teacher
Ralf, 29, M, DE, Programmer
Naomi, 16, F, FR, Student
{% endhighlight %}

ここでは__END__以下のデータを読み取って
各ユーザ毎に
Personオブジェクトを生成してpeople変数に格納し
これを先のクエリー言語で評価しています
結果は以下のとおりです
{% highlight ruby %}
puts none_japanese.evaluate(people)
#<struct Census::Person name="Joe", age=25, sex=:M, nationality=:US, job="Programmer">
#<struct Census::Person name="Armstrong", age=28, sex=:M, nationality=:US, job="Teacher">
#<struct Census::Person name="Karen", age=43, sex=:F, nationality=:US, job="Programmer">
#<struct Census::Person name="Paku", age=33, sex=:M, nationality=:KO, job="RestaurantOwner">
#<struct Census::Person name="Soh", age=51, sex=:M, nationality=:KO, job="Teacher">
#<struct Census::Person name="Ralf", age=29, sex=:M, nationality=:DE, job="Programmer">
#<struct Census::Person name="Naomi", age=16, sex=:F, nationality=:FR, job="Student">
puts over30men.evaluate(people)
#<struct Census::Person name="Ken", age=38, sex=:M, nationality=:JP, job="Doctor">
#<struct Census::Person name="Paku", age=33, sex=:M, nationality=:KO, job="RestaurantOwner">
#<struct Census::Person name="Soh", age=51, sex=:M, nationality=:KO, job="Teacher">
puts under30_us_or_de_programmer.evaluate(people)
#<struct Census::Person name="Joe", age=25, sex=:M, nationality=:US, job="Programmer">
#<struct Census::Person name="Ralf", age=29, sex=:M, nationality=:DE, job="Programmer">
{% endhighlight %}
うまくいっているようですね！

###算術演算インタープリタ
あまり意味が無いのですが
InterpreterBuilderの活用例として
以下のような構文を実現する
算術演算インタープリタを実装してみます
{% highlight ruby %}
 exp = divide( plus(2, multiple(3,4)), 3 )
 exp.to_i # => 4
{% endhighlight %}

算術演算では終端は数字になるので
selfを返すFixnum#to_iをiterpretメソッドとして使います
{% highlight ruby %}
# encoding: UTF-8
require_relative "../lib/interpreter_builder"
module Calc
  extend InterpreterBuilder
  
  class Expression
  end
  
  nonterminals = {
    plus: :+,
    minus: :-,
    multiple: :*,
    divide: :/
  }
  
  nonterminals.each do |name, op|
    define_nonterminal(name, Expression, :to_i, op)
  end
end
{% endhighlight %}
非終端である演算子の定義を追加することで
他の算術演算も可能になります

Interpreterパターンに対する根本的な理解が間違っていて
意味不明なことをやっている可能性がありますが
誰かの何かの参考になればうれしいです

(追記：2011-7-26)算術演算の例を一部修正しました。

https://github.com/melborne/InterpreterBuilder
{% footnotes %}
   {% fn 該当ファイルはchap15/ex1_files.rbとex3_operators.rbです %}
   {% fn 一部実装が異なります %}
   {% fn 関数メソッドが不要の場合は第5引数にfalseを渡します %}
{% endfootnotes %}
