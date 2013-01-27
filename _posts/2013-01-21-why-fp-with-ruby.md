---
layout: post
title: 'Rubyを使って「なぜ関数プログラミングは重要か」を読み解く（改定）─ 前編 ─ 但し後編の予定なし'
description: ""
category: 
tags:
date: 2013-01-21
published: true
---
{% include JB/setup %}

２年ほど前に書いた記事を電子書籍化して「[M'ELBORNE BOOKS]({{ site.url }}/books/ 'M'ELBORNE BOOKS')」で販売するために全体的な見直しを行なって入稿する段になって、これにはベースとなっている他者の論文があって言ってみればこの記事はそのマッシュアップになっているんだけれども、その著者の許可もなくその表現が全く別物だとしてもその主張のあらすじが残っている限りにおいてこれを販売することが果たしていいことなのかという思考に遅ればせながら陥り、それが仮に法的に問題ないとしてもなんだか一表現者の行為としての妥当性を幾分欠いているという結論に至って販売を思い留まった。かと言って折角書き直したものをこのままお蔵にするのもなんだか寂しいなあという気分も一方であり、まあ原作者の意に反したものでもないだろうからブログの記事なら許してくれるよねもう２年前にも書いちゃってるしという勝手な解釈の下、ここにその記事を公開しましたのでお時間の許すRubyが好きで関数プログラミングに興味をお持ちの方居られましたらご一読頂けたらうれしく思います。

<hr/>

##はじめに

「Why Functional Programming Matters:なぜ関数プログラミングは重要か」(原著者：John Huges 邦訳：山下伸夫)という有名な論文があります。

> {% hatebu http://www.sampou.org/haskell/article/whyfp.html なぜ関数プログラミングは重要か %}

これはMirandaという関数型言語を使って、プログラマにとって関数プログラミングがいかに重要であるかを論証したものです。これが書かれてからの年数（1984年公表）と被ブックマーク数から見て、「関数型プログラミングを学ぶ人の必読の書」であることは明らかでしょう。しかし内容は幾分高度であり自分はこれを読み解くのに苦労しています。

以下は、この論文における「4.1. ニュートン-ラプソン法による平方根」の章までについて、Rubyの関数プログラミングの機能を使ってこの論文におけるコードに対応するものを記述し、自分の解釈でその骨子を説明したものとなっています。したがってこの記事の目的は、Rubyを使うことで関数プログラミングの妙味をより分かりやすく伝えると同時に、Rubyにおける関数プログラミングのパワーを知ってもらうことにあります。

なお、オリジナルの論文は「5. 人工知能からの例」までありますが、自分の力不足により上記以降を読み解くことができていません。したがって今のところ、本記事の後編が書かれる予定は無いことを予めご了承下さいm(__)m


##１章　関数プログラミングにおける重要な要素
モジュール化設計がプログラミングを成功させる鍵です。見過ごされがちですがプログラミング言語においてコードを自由にモジュール化するためには、それらを結合する糊が極めて重要な役割を担います。プログラマの目標は小さく、簡潔で、汎用的なモジュールを貼り合せてプログラムを構成することにあります。関数プログラミングには二種類の強力な糊、つまり関数の貼り合せをする糊（高階関数）と、プログラムの貼り合せをする糊（遅延評価）があります。


##２章　関数の貼り合せ ─ リストにおける張り合せ ─
最初に単純な関数を貼り合わせてより複雑な関数が作れるということを見ていきます。このことをリストにおける簡単なリスト処理の問題で説明します。

リストというのは、要素のない空リストであるか、または空リストを含む任意の要素のリストに任意の要素を結合（cons）したものである、という風に理解できます。Rubyにはリスト処理のためのArrayクラスがあるので、ここでは各関数をArrayクラスのメソッドとして定義していきます。

上記定義に従って最初に**cons**をArrayのメソッドとして定義します。またリスト処理を容易にするために、関数言語風にhead（リストの先頭要素）と、tail（リストの先頭要素を除いた残り）を定義します。

{% highlight ruby %}
class Array
  def cons(a)
    [a] + self
  end

  alias :head :first
  def tail
    drop 1
  end
end

[].cons(1) # => [1]
[].cons(2).cons(1) # => [1, 2]
[].cons(3).cons(2).cons(1) # => [1, 2, 3]

[1, 2, 3].head # => 1
[1, 2, 3].tail # => [2, 3]
{% endhighlight %}


最初に、リストの要素を足し合わせる**sum0**を定義します。これは再帰を使って以下のように書くことができます。
{% highlight ruby %}
class Array
  def sum0
    return 0 if empty?
    head + tail.sum0
  end
end

ls = [1,2,3,4,5]
ls.sum0 # => 15
{% endhighlight %}

つまり空リストに対しては0を返すようにし、それ以外ではリストの最初の要素を残りの要素の和に足していくことで結果を得ます。

ここで、この定義における加算に固有の要素つまり「0」と「+」を一般化すると、リスト処理の汎用メソッドreduceができ上がります（Rubyには既に同じ機能を持ったEnumerable#reduceが存在します）。
{% highlight ruby %}
class Array
  def reduce(f, a)
    return a if empty?
    f[head, tail.reduce(f, a)]
  end
end
{% endhighlight %}

Rubyではメソッドはそのままでは引数として渡すことができないので、ここではfとしてProcオブジェクトを受けるようにし`Proc#[]`で実行するようにしています（Proc#.callまたはProc#.()という呼びだし方法もあります）。

今度はreduceとaddメソッドを使って**sum**を再定義してみます。
{% highlight ruby %}
class Array
  def sum
    reduce add, 0
  end

  def add
    ->a,b{ a + b } # lambda{ |a,b| a + b } と同じ
  end
end

ls = [1,2,3,4,5]
ls.sum # => 15
{% endhighlight %}

addメソッドはa,bを引数に取るProcオブジェクト、つまり手続きを返す高階関数です。

同様にしてreduceとmultiplyメソッドを使って、要素を掛け合わせる**product**を定義します（RubyのArrayには別の目的のために同名のメソッドがあるので警告がでます）。
{% highlight ruby %}
class Array
  def product
    reduce multiply, 1
  end

  def multiply
    ->a,b{ a * b }
  end
end

ls = [1,2,3,4,5]
ls.product # => 120
{% endhighlight %}

またreduceを使って、真理値リストの要素のうち何れかが真かを検査する**any_true**と、すべての要素が真であることを検査する**all_true**を同様に定義できます。
{% highlight ruby %}
class Array
  def any_true
    reduce send(:or), false
  end

  def all_true
    reduce send(:and), true
  end

  def or
    ->a,b{ a or b }
  end

  def and
    ->a,b{ a and b }
  end
end

tf1 = [false, true, false]
tf2 = [true, true, true]

tf1.any_true # => true
tf2.any_true # => true
tf1.all_true # => false
tf2.all_true # => true
{% endhighlight %}

Rubyにおいて**or**と**and**は予約語なのでそのままの形では引数として渡すことができません。ここではこの問題を回避するため、`Kernel#send`を使っています（Kernel#methodを使う方法もあります）。

さてここで`reduce(f, a)`をcons(a)との対比で理解してみましょう。リスト[1,2,3]はconsを使って以下のように作ることができます。
{% highlight ruby %}
[].cons(3).cons(2).cons(1) # => [1, 2, 3]
{% endhighlight %}

reduce(f,a)は上の式のconsをすべてfに置き換え、\[ \]をaに置き換えたものとみなすことができます。
{% highlight ruby %}
a.f(3).f(2).f(1)
{% endhighlight %}

その結果、先のsumのreduce add, 0とproductのreduce multiply, 1は、それぞれ以下のように理解できます。
{% highlight ruby %}
0.add(3).add(2).add(1)
1.multiply(3).multiply(2).multiply(1)
{% endhighlight %}

そうするとreduce cons, \[ \]はリストを複写するものであることが理解できるでしょう。consをreduceに渡せるように少し改良して複写メソッドdupを定義します。
{% highlight ruby %}
class Array
  def cons
    ->a,ls=self{ [a] + ls }
  end

  def reduce(f, a)
    return a if empty?
    f[head, tail.reduce(f, a)]
  end

  def dup
    reduce cons, []
  end
end

[1,2,3].dup # => [1, 2, 3]
{% endhighlight %}
consは他の補助メソッドと同様に２つの引数を取るようにし、かつ[]メソッドで実行されるようProcオブジェクト化します。

ここでdupにおけるreduceの第二引数にリストを渡せるようにすれば、リストを結合するappendが定義できます。
{% highlight ruby %}
class Array
  def append(ls)
    reduce cons, ls
  end
end

[1,2,3].append [4,5,6] # => [1, 2, 3, 4, 5, 6]
{% endhighlight %}

続いてリストの要素を２倍するメソッド**double_all**を定義します。double_allはreduceとdouble_and_consを使って次のように書くことができます。double_and_consは要素を倍にして結果をリストに結合するものです。
{% highlight ruby %}
class Array
  def double_all
    reduce double_and_cons, []
  end

  def double_and_cons
    ->num,ls{ cons[2*num, ls] }
  end
end

ls = [1,2,3,4,5]
ls.double_all # => [2, 4, 6, 8, 10]
{% endhighlight %}

ここで**double_and_cons**はさらにdoubleとf_and_consにモジュール化することができます。
{% highlight ruby %}
class Array
  def double_all
    reduce f_and_cons[double], []
  end
  
  def double
    ->num{ 2 * num }
  end
  
  def f_and_cons
    ->f,el,ls{ cons[f[el], ls] }.curry
  end
end

ls = [1,2,3,4,5]
ls.double_all # => [2, 4, 6, 8, 10]
{% endhighlight %}

double_allにおいてreduceはその第１引数としてProcオブジェクトを受け取る必要があります。ここではf_and_consをカリー化することにより、それがdoubleのみを取ってProcオブジェクトを返せるよう工夫しています。このような方法を関数の部分適用といいます。

また2つの関数を合成する**compose**メソッドを定義することにより、consとdoubleを合成する方法もあります。
{% highlight ruby %}
class Array
  def double_all
    reduce compose(cons, double), []
  end

  def double
    ->num{ 2 * num }
  end
  
  def compose(f,g)
    ->x,y{ f[g[x],y] }
  end
end

ls = [1,2,3,4,5]
ls.double_all # => [2, 4, 6, 8, 10]
{% endhighlight %}
（このcomposeは受け取る引数の個数が固定的であり、汎用的なものではありません）

double_allはconsと合成する関数を一般化することによって、更にモジュール化を進めることができます。
{% highlight ruby %}
class Array
  def double_all
    map double
  end

  def map(f)
    reduce compose(cons, f), []
  end
end

ls = [1,2,3,4,5]
ls.double_all # => [2, 4, 6, 8, 10]
{% endhighlight %}

**map**は任意のメソッドfをリストのすべての要素に適用します。mapはreduceと並ぶもう一つの汎用的なメソッドです（Rubyには同じ目的のArray#mapが存在するので警告がでます）。

{% highlight ruby %}
[1,2,3,4,5].map ->x{ x ** 2 } # => [1, 4, 9, 16, 25]
%w(ruby haskell scheme).map ->s{ s.upcase } # => ["RUBY", "HASKELL", "SCHEME"]
{% endhighlight %}

このようにしてメソッドを高階関数と、いくつかの単純なメソッドの合成としてモジュール化することにより、リストのための多数のメソッドを効果的に定義することができました。


##３章　関数の貼り合せ ─ツリーにおける張り合せ ─

貼り合せの能力はリスト上の関数にとどまりません。ラベル付き順序ツリーの例でこれを示しましょう。

Rubyにはリストに都合の良いArrayクラスが組込みでありましたが、ツリーに都合の良いものはないので自分でクラスを定義する必要があります。ツリーはラベルを持ったノードを連結したものとして表現できるので、この連結の機能をもったNodeクラスを定義することでツリーを表現します。
{% highlight ruby %}
class Node
  attr_reader :label, :subtrees

  def initialize(label, *subtrees)
    @label = label
    @subtrees = subtrees
  end
end

def node
  ->label,*subtrees{ Node.new(label, *subtrees) }
end
{% endhighlight %}

ノードオブジェクトは**label**とサブノードのリスト**subtrees**をもつことができます。ここではノードオブジェクトを関数言語風に生成するために、**node関数**(Objectクラスのメソッド)を用意しています。

例えば、
{% highlight bash %}
           1 o
            ／ ＼
          ／     ＼
        ／         ＼
     2 o             o 3
                     |
                     |
                     |
                     o  4
{% endhighlight %}

というツリーはこのNodeクラスを使って以下のように表現できます。

{% highlight ruby %}
tree = node[1, 
            node[2],
            node[3, node[4]]
            ]

# >> #<Node:0x0a431c @label=1, @subtrees=[#<Node:0x0a4420 @label=2, @subtrees=[]>, #<Node:0x0a4358 @label=3, @subtrees=[#<Node:0x0a4394 @label=4, @subtrees=[]>]>]>
{% endhighlight %}

つまりノード１は２つのノード２，３をサブノードとしてもち、ノード３はノード４をサブノードとしてもっていることが表現されています。nodeの第２引数は省略でき、この場合subtreesの値は\[ \]になります。

さてここで、リストで用意したreduceメソッドと同じ目的をツリーで果たす**red_tree**メソッドを定義してみます。

リストのところの説明でreduceがリストを生成するconsとの比較で、consと\[ \]をfとaに置き換えたものとみなせると言いました。同じ発想でツリーがリストを含むノードで生成される、つまりnodeとconsと\[ \]で生成できることから、red_treeはこれらをfとgとaに置き換えたものとみなせます。

ここでツリーとリストは別のクラスなので、それぞれのクラスの上にred_treeを定義する必要があります。
{% highlight ruby %}
class Node
  def red_tree(f, g, a)
    f[label, subtrees.red_tree(f, g, a)]
  end
end

class Array
  def red_tree(f, g, a)
    return a if empty?
    g[head.red_tree(f, g, a), tail.red_tree(f, g, a)]
  end
end
{% endhighlight %}

ここで最初の引数である関数fはノードオブジェクトの要素に適用され、第２の引数である関数gはリストの要素に適用されます。red_treeと他の関数を貼り合せることで興味深い関数がいくつも定義できるようになります。

次の段階に進む前に、Arrayクラスに定義した有用なメソッド群をNodeクラスにも定義します。ここではNodeクラスに同じものを用意するのではなく、Arrayクラスのそれらのメソッドをモジュールに抽出してNodeクラスでも使えるようにしてみます。
{% highlight ruby %}
module Functional
  def cons
    ->x,ls=self{ [x] + ls }
  end

  def append
    ->se=self,ls{ se.reduce cons, ls }
  end

  def add
    ->x,y{ x + y }
  end

  def double
    ->num{ 2 * num }
  end
  
  def compose(f,g)
    ->x,y{ f[g[x],y] }
  end
end

class Array
  include Functional
end

class Node
  include Functional
end
{% endhighlight %}
ここでappendは他の補助メソッドと同様に２つの引数を取るようにし、かつ[]メソッドで実行されるようProcオブジェクト化しています。

準備ができたので、まずツリーのラベルの数値をすべて足す**sum_tree**を定義します。
{% highlight ruby %}
class Node
  def sum_tree
    red_tree add, add, 0
  end
end

tree = node[1,
            node[2],
            node[3, node[4]]
           ]
tree.sum_tree # => 10
{% endhighlight %}


ツリーのlabel全体のリストは以下のように定義できます。
{% highlight ruby %}
class Node
  def labels
    red_tree cons, append, []
  end
end

tree.labels # => [1, 2, 3, 4]
{% endhighlight %}

最後にリストのmapと類似したメソッドつまり関数fをツリーのすべてのラベルに適用するメソッド**map_tree**を定義します。

{% highlight ruby %}
class Node
  def map_tree(f)
    red_tree compose(node, f), cons, []
  end
end
{% endhighlight %}

map_treeを使えば、たとえばラベルの数値を倍にするメソッドを定義できます。
{% highlight ruby %}
class Node
  def double_all
    map_tree double
  end
end

tree.double_all.labels # => [2, 4, 6, 8]
{% endhighlight %}



##４章　プログラムの貼り合せ - 遅延評価 -

次に、関数プログラミングの２つ目の強力な糊、つまりプログラムを貼り合せる糊について説明します。

いま２つのプログラムｆとｇがあって、入力inputをこれらに適用する場合を考ます。
{% highlight ruby %}
g (f input)
{% endhighlight %}

プログラムｆは入力inputを受け取ってその出力を計算し、その出力はプログラムｇの入力として使われます。

一般的なプログラム言語ではｆからの出力を一時的にメモリーに蓄えることでその実装を可能としますが、ケースによってはメモリー占有量が膨大になり得ます。

関数プログラミングではプログラムｆとｇは厳密な同期の上で走ります。つまりプログラムｆはプログラムｇが必要とする分だけ実行されて残りは破棄されます。このことからプログラムｆは無限に出力を生成し続けるものであってもよいということになります。これによってプログラムの停止条件は、ループ本体と切り離すことができ、強力なモジュール化が可能になります。

このようなプログラムの評価方式は「遅延評価」と呼ばれています。

##ニュートンーラプソン法による平方根
遅延評価の力を使って、ニュートンーラプソン法による平方根のアルゴリズムを求めてみます。この方法でnの平方根を求めるとき任意の近似値xを選び、xとn/xの平均を取っていくことでより良い近似値xを得ます。これを繰り返し十分に良い近似値が得られたら処理を終えるようにします。良い近似値かの判断は隣接する近似値の差が許容誤差eps以下であるかにより判断します。

Rubyにおける一般的な実装は以下のようになるでしょう。
{% highlight ruby %}
 EPS = 0.0001    # 許容誤差
 A0 = 1.0        # 初期近似値
 def sqrt(n, x=A0, eps = EPS)
   loop do
     y = x
     x = (x + n/x) / 2.0           # 次の近似値
     return x if (x-y).abs < eps
   end
 end

 sqrt 2 # => 1.4142135623746899
 sqrt 5 # => 2.236067977499978
 sqrt 8 # => 2.8284271250498643
{% endhighlight %}

この実装ではループの停止条件は、ループに組み込まれてしまって分離が容易ではありません。遅延評価を使うことによって実装のモジュール化を行い、その部品が他の場面でも使えることを示します。

基本的にRubyの関数（メソッド）は正格評価であり遅延評価されません。しかし関数をProcやEnumeratorオブジェクトとすることによって、その評価のタイミングを遅らせる、つまり遅延評価させることができます。

まず次の近似値を計算する**next_val**を定義します。
{% highlight ruby %}
 def next_val
   ->n,x{ (x + n/x) / 2.0 }.curry
 end
{% endhighlight %}

next_valは、求める平方根の数値nと近似値xを取って次の近似値を返しますが、これをcurry化されたProcオブジェクトを返すように実装します。これによって、２つの引数を渡すタイミングをコントロールできるようになります。つまり数値nだけを先に渡すことによってnext_valは、１つの引数xを受ける関数に変わります。

例を示します。
{% highlight ruby %}
 next_for_five = next_val[5]

 nx = next_for_five[1.0] # => 3.0
 nx = next_for_five[nx] # => 2.3333333333333335
 nx = next_for_five[nx] # => 2.238095238095238
 nx = next_for_five[nx] # => 2.2360688956433634
{% endhighlight %}

次に、初期値に任意の関数を繰り返し適用して、その結果のリストを返す汎用関数**repeat**を定義します。
{% highlight ruby %}
 def repeat(f, x)
   Enumerator.new { |y| loop { y << x; x = f[x] } }
 end
{% endhighlight %}

repeat関数は１つの引数を取って１つの結果を返す関数ｆと、ｆの初期値となるxを取りEnumeratorオブジェクトを返します。Enumeratorのブロックの中ではloopによってxを関数ｆに適用した結果が、繰り返しｙつまりEnumerator::Yielderオブジェクトに渡されますが、これはEnumeratorオブジェクトが呼び出されるまで実行されず、そのため無限ループにはなりません。

このrepeat関数に先のnext_val関数を渡すことによって、平方根nの近似値のリストが得られるようになります。
{% highlight ruby %}
 approxs = repeat next_val[5], 1.0 # => #<Enumerator: #<Enumerator::Generator:0x0a4aec>:each>

 ls = []
 5.times { ls << approxs.next }
 ls # => [1.0, 3.0, 2.3333333333333335, 2.238095238095238, 2.2360688956433634]
{% endhighlight %}

Enumeratorオブジェクトはその呼び出し（ここではnext）の度にループを１つ回して結果を１つ返します。repeatはその出力を利用する関数と同期して、それが必要とされる分だけ評価されます。つまりrepeatそれ自体は繰り返し回数の制限を持ちません。

次に関数**with_in**を定義します。with_inは許容誤差と近似値のリスト（正確にはリストではなくEnumeratorオブジェクト）を引数に取り、許容誤差よりも小さい２つの連続する近似値を探します。

{% highlight ruby %}
 def with_in(eps, enum)
   a, b = enum.next, enum.peek
   return b if (a-b).abs <= eps
   with_in(eps, enum)
 end
{% endhighlight %}

最初の行でEnumeratorオブジェクトの返す最初の２つの値をnextとpeekでa, bに取ります。`Enumerator#peek`はカーソルを進めないで先頭要素を取ります。２行目の終了条件が満たされない限り、処理は再帰的に繰り返されることになります。

最後に、これらの部品を使って平方根を求める関数**sqrt**を定義します。
{% highlight ruby %}
 EPS = 0.0001    # 許容誤差
 A0 = 1.0        # 初期近似値
 def sqrt(n, a0=A0, eps=EPS)
   with_in eps, repeat(next_val[n], a0)
 end

 sqrt 2 # => 1.4142135623746899
 sqrt 3 # => 1.7320508100147274
 sqrt 5 # => 2.236067977499978
 sqrt 8 # => 2.8284271250498643
{% endhighlight %}

sqrt関数はこのようにしてモジュール化された３つの汎用部品**next_val**、**repeat**、**with_in**を貼り合せて作ることができました。

sqrt関数はモジュールを合成して構成されているので、プログラムの基本的な構造を変えることなく変更が容易に行えます。

今度は、２つの連続する近似値の差がゼロに近づくという条件の代わりに、２つの近似値の比が１に近づくという条件に変えてみます。これは非常に小さいまたは非常に大きい数に対してはより適切な結果を出します。

この目的を達成するには、関数with_inに代わる関数**relative**を定義するだけでいいのです。
{% highlight ruby %}
 def relative(eps, enum)
   a, b = enum.next, enum.peek
   return b if (a-b).abs <= eps*b.abs
   relative(eps, enum)
 end

 def sqrt(n, a0=A0, eps=EPS)
   relative eps, repeat(next_val[n], a0)
 end

 sqrt 2 # => 1.4142135623746899
 sqrt 3 # => 1.7320508100147274
 sqrt 5 # => 2.236067977499978
 sqrt 8 # => 2.8284271250498643
{% endhighlight %}

他の部品を変えることなく新しいsqrt関数ができました。

##終わりに

以上、関数型プログラミングにおける強力な２つの糊、「高階関数」と「遅延評価」の例をいくつか見てきました。これらの糊によりプログラムは柔軟に、汎用的な多数のモジュールに分割できることが分かりました。Rubyにおける関数型プログラミングの支援機能は、純粋な関数型プログラミング言語におけるそれには及ばないものの、Rubyプログラマに大きな力を与え得るのではないでしょうか。

---

{{ '427406896X' | amazon_medium_image }}
{{ '427406896X' | amazon_link }}

