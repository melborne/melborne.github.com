---
layout: post
title: "YOUたち!RubyでinjectしちゃいなYO!"
tagline: "injectで29のArrayメソッドを実装する"
description: 
category: 
tags: [ruby, inject]
date: 2012-06-18
published: true
---
{% include JB/setup %}

プログラミングの存在価値は処理の自動化です。任意の集合に対して処理を繰り返しその結果を返す、それがプログラムです。つまり集合に対して処理を繰り返す能力が、プログラムの価値を決定付けるのです{% fn_ref 1 %}。

「手続き型言語」では`ループ`が処理の繰り返しを実現するための重要な手法の一つです。しかしループは、一時変数を用意してプログラマがループの進行を管理しなければならない、という欠点があります。そしてその管理ミスがバグとなります。

「関数型言語」では`再帰`が処理の繰り返しを実現するための重要な手法の一つです。再帰では再帰の進行はその構造に基づいて自動的になされるので、プログラマがそれを管理する必要はありません。しかしその一方で、処理が多段階に渡る立体的なものとなるので、その動作の理解が平面的なループ処理に比べて難しいという欠点があります。習得には慣れが必要です。

`Ruby`は、手続き型言語と関数型言語の両方の側面を合わせ持った言語です。したがって、処理の繰り返しを実現する手法として、ループも再帰も使うことができます。しかしRubyにはループよりもその進行管理が容易で、再帰よりも動作の理解が容易な第３の手法があり、多くのRubyistはそれを多用します。それがEnumerable#eachに代表される`イテレータ(Iterator)`です。特にRubyのイテレータはブロックにより関数を引き渡せるので、処理の実体が見易いという利点があり、それがイテレータが多用される理由になっています。

Rubyには多数のイテレータ・メソッドがありますが、その中で最強のものは`Enumerable#inject`です{% fn_ref 2 %}。injectはいわゆる畳み込み演算を実現するメソッドですが、`each`と比較した場合、その処理結果を返せるという利点があります（eachはselfを返します）。

この記事では「injectが最強である！」ということを示すために、Arrayに備えられた29個の便利なメソッドを、injectを使った短いコードで再実装してみます。暇人のみがなしうる試みです。ちなみに、「inject!, inject!」と騒いでるRuby使いのことを`inject厨`と言うそうです。ええ、私は間違いなく、inject厨です。

##injectの動作
まずは`inject`の動作を確認します。
{% highlight ruby %}
[1,2,3,4,5].inject(0) { |m, x| m + x } # => 15
{% endhighlight %}
配列の各数を足し合わせた結果を返す例です。ブロックには、ブロックの実行結果をその都度指す変数mと配列の各要素を順番に指す変数xが渡されます。変数mの初期値はinjectの引数です。つまり上の例でブロックの実行は`m = m + x`のループと等価です。そしてxが5を指して最後のブロックの実行が終わるとその結果、つまり変数mが指すものをinjectの返り値として出力します。

引数として渡されるオブジェクトの種類によって、injectは多様な処理を成し得ます。それがinjectの魅力です。

Rubyのinjectは引数を省略することができ、その場合、配列の先頭要素を変数mにセットし、第２要素からイテレーションを始めます。よって次のコードは先のコードと同じ結果を返します。
{% highlight ruby %}
[1,2,3,4,5].inject { |m, x| m + x } # => 15
{% endhighlight %}

##実装ターゲット
ここではArray（Enumerableを含む）が持っている次の29個の便利なメソッドを、injectを使って再実装してみます。

    map size at index select reject detect all? any? one? none? min max minmax take_while grep include? partition group_by count join assoc zip reverse values_at compact take flat_map product

まずは、Rubyに実装されたこれらのメソッドを使えないようにします。Array自体を弄るのは都合が悪いので{% fn_ref 3 %}、Arrayを継承したListクラスでundefします。

{% highlight ruby %}
class List < Array
  undef_method *%w(inject map size at index select reject detect all? any? one? none? min max minmax take_while grep include? partition group_by count join assoc zip reverse values_at compact take flat_map product)
end

List[1,2,3,4,5].inject(0) { |m, x| m + x } # => 
List[1,2,3,4,5].map { |x| x + 1 } # => 
# ~> -:5:in `<main>': undefined method `inject' for [1, 2, 3, 4, 5]:List (NoMethodError)
# ~> -:6:in `<main>': undefined method `map' for [1, 2, 3, 4, 5]:List (NoMethodError)

{% endhighlight %}

##injectの実装
injectも共にundefしたので、まずは再帰を使ってinjectを実装します。
{% highlight ruby %}
class List < Array
  def inject(m, &blk)
    return m if empty?
    (drop 1).inject( yield(m, first), &blk)
  end
end

List[1,2,3,4,5].inject(0) { |m, x| m + x } # => 15
{% endhighlight %}
injectの一行目は、配列の要素が全て処理されたら変数mが指すものを返して処理を終えるコードです。二行目が再帰になっていて、`drop 1`が配列の先頭要素を除いたものに対して再度injectを呼び出すコードです。ここでの第１引数は、変数mと配列の最初の要素に対するブロックの実行結果になります。

##1. map
さてinjectが実装できたので、これを使って順番にメソッドを実装して行きます。まずはmapです。`map`は配列の各要素にブロックを適用した結果を返すメソッドです。

{% highlight ruby %}
class List < Array
  def map
    inject([]) { |m, x| m << yield(x) }
  end
end

List[1,2,3,4,5].map { |x| x**2 } # => [1, 4, 9, 16, 25]
{% endhighlight %}
injectの引数に空配列`[]`を渡します。そしてブロックではmapに渡したブロックを実行した結果を変数mつまり配列に挿入していきます。

##2. size
配列の長さを返す`size`を実装します。
{% highlight ruby %}
class List < Array
  def size
    inject(0) { |m, x| m + 1 }
  end
end

List[1,2,3,4,5].size # => 5
{% endhighlight %}
injectの引数を0とし、ブロック実行毎に1を加算していきます。つまり変数mをカウンタとして使います。

##3. at
引数で与えられた位置posにある要素を返す`at`を実装します。
{% highlight ruby %}
class List < Array
  def at(pos)
    inject(0) do |m, x|
      return x if m==pos
      m + 1
    end
    nil
  end
end

List[1,2,3,4,5].at(3) # => 4
{% endhighlight %}
sizeと同様に変数mをカウンタとして使い、atの引数posと一致したところの要素xを返すようにします。posが配列要素数より多い場合にnilが変えるようにします。

##4. index
引数で与えられた値の配列上の位置を返す`index`を実装します。
{% highlight ruby %}
class List < Array
  def index(val)
    inject(0) do |m, x|
      return m if x==val
      m + 1
    end
    nil
  end
end

List[1,2,3,4,5].index(3) # => 2
{% endhighlight %}
atとほぼ同じですが、返り値が位置を指す変数mを返すところが違います。

RubyのArray#indexは引数に変えてブロックを取ることができ、その場合はブロックの条件に一致する最初の要素の位置を返します。これにも対応してみます。

{% highlight ruby %}
class List < Array
  def index(val=nil)
    inject(0) do |m, x|
      return m if (val.nil? && block_given? ? yield(x) : x==val)
      m + 1
    end
    nil
  end
end

List[1,2,3,4,5].index { |x| x.even? } # => 1
{% endhighlight %}
if式の条件だけを変えます。block_given?でブロックがあるか判定します。

##5. select
ブロックの条件に合致した要素の配列を返す`select`を実装します。
{% highlight ruby %}
class List < Array
  def select
    inject([]) { |m, x| m << x if yield(x); m }
  end
end

List[1,2,3,4,5].select { |x| x.odd? } # => [1, 3, 5]
{% endhighlight %}
ブロックの実行結果が真のときだけ変数mが指す配列に要素を追加していきます。偽のときはブロックの結果がnilになってしまうので、最後にmを置いてそれが返るようにします。

##6. reject
selectと逆、つまりブロックの条件に合致した要素を除いた配列を返す`reject`を実装します。
{% highlight ruby %}
class List < Array
  def reject
    inject([]) { |m, x| m << x unless yield(x); m }
  end
end

List[1,2,3,4,5].reject { |x| x.odd? } # => [2, 4]
{% endhighlight %}
ifがunlessになるだけです。

##7. detect
ブロックの条件に合致した最初の要素を返す`detect`を実装します。

{% highlight ruby %}
class List < Array
  def detect
    inject(nil) do |m, x|
      return x if yield(x)
      m
    end
  end
end

List[1,2,3,4,5].detect { |x| x.even? } # => 2
{% endhighlight %}
yield(x)が真になる要素xがあったときそれを返します。injectの引数をnilとして該当がないときnilが返るようにします。

##8. all?
ブロックの実行結果がすべて真になる場合にtrueを返す`all?`を実装します。
{% highlight ruby %}
class List < Array
  def all?
    inject(true) { |m, x| m && yield(x) }
  end
end

List[1,2,3,4,5].all? { |x| x.even? } # => false
List[2,4,6,8,10].all? { |x| x.even? } # => true
{% endhighlight %}
injectの引数にtrueを渡しブロックの実行結果と&&します。

##9. any?
ブロックの実行結果の何れかが真になる場合にtrueを返す`any?`を実装します。
{% highlight ruby %}
class List < Array
  def any?
    inject(false) { |m, x| m || yield(x) }
  end
end

List[1,2,3,4,5].any? { |x| x.even? } # => true
List[1,3,5,7,9].any? { |x| x.even? } # => false
{% endhighlight %}
injectの引数にfalseを渡しブロックの実行結果と||します。

##10. one?
ブロックの実行結果が１つだけ真になる場合にtrueを返す`one?`を実装します。
{% highlight ruby %}
class List < Array
  def one?
    inject(0) { |m, x| yield(x) ? m + 1 : m } == 1
  end
end

List[1,2,3,4,5].one? { |x| x.even? } # => false
List[1,3,6,7,9].one? { |x| x.even? } # => true
{% endhighlight %}
変数mで真になる数を数えて、最後に1と比較します。

##11. none?
ブロックの実行結果がすべて偽となる場合にtrueを返す`none?`を実装します。
{% highlight ruby %}
class List < Array
  def none?
    inject(0) { |m, x| yield(x) ? m + 1 : m } == 0
  end
end

List[1,2,3,4,5].none? { |x| x.even? } # => false
List[1,3,5,7,9].none? { |x| x.even? } # => true
{% endhighlight %}
変数mで真になる数を数えて、最後に0と比較します。

##12. min
最小値を返す`min`を実装します。
{% highlight ruby %}
class List < Array
  def min
    inject(first) { |m, x| m = x if m > x; m }
  end
end

List[3,6,2,5,8].min # => 2
{% endhighlight %}
変数mに最初は先頭値をセットし、それよりも大きい要素が現れたら変数mの参照先を変えることで最小値を探します。

元実装と同様にブロックを取れるようにして、その条件での最小要素を求められるようにもします。

{% highlight ruby %}
class List < Array
  def min
    inject(first) do |m, x|
      _m, _x = block_given? ? [yield(m), yield(x)] : [m, x]
      m = x if _m > _x
      m
    end
  end
end

List['python', 'ruby', 'haskell'].min { |x| x.size } # => "ruby"
{% endhighlight %}

##13. max
最大値を返す`max`を実装します。
{% highlight ruby %}
class List < Array
  def max
    inject(first) do |m, x|
      _m, _x = block_given? ? [yield(m), yield(x)] : [m, x]
      m = x if _m < _x
      m
    end
  end
end

List[3,6,2,5,8].max # => 8
List['python', 'ruby', 'haskell'].max { |x| x.size } # => "haskell"
{% endhighlight %}

##14. minmax
最大値と最小値を返す`minmax`を実装します。
{% highlight ruby %}
class List < Array
  def minmax(&blk)
    [min(&blk), max(&blk)]
  end
end

List[3,6,2,5,8].minmax # => [2, 8]
List['python', 'ruby', 'haskell'].minmax { |x| x.size } # => ["ruby", "haskell"]
{% endhighlight %}
既に実装したminとmaxを使います。

##15. take_while
先頭からブロックの条件が満たされている要素までを返す`take_while`を実装します。
{% highlight ruby %}
class List < Array
  def take_while
    inject([]) do |m, x|
      return m unless yield(x)
      m << x
    end
  end
end

List[1,2,3,4,5].take_while { |x| x < 4 } # => [1, 2, 3]
{% endhighlight %}
変数mに順次要素を入れていき、ブロックの実行結果が偽となったところで返します。

##16. grep
パターンにマッチする全要素を返す`grep`を実装します。
{% highlight ruby %}
class List < Array
  def grep(pattern)
    inject([]) do |m, x|
      case x
      when pattern
        m << x
      else
        m
      end
    end
  end
end

List['abc', 'acb', 'bcc', 'bbc', 'bbb'].grep(/c$/) # => ["abc", "bcc", "bbc"]
{% endhighlight %}
case式でpatternにマッチするか検査します。

元実装同様、ブロックを取れるようにして、マッチした要素に対して処理を施せるようにします。
{% highlight ruby %}
class List < Array
  def grep(pattern)
    inject([]) do |m, x|
      case x
      when pattern
        m << ( block_given? ? yield(x) : x )
      else
        m
      end
    end
  end
end

List['abc', 'acb', 'bcc', 'bbc', 'bbb'].grep(/c$/) # => ["abc", "bcc", "bbc"]
List['abc', 'acb', 'bcc', 'bbc', 'bbb'].grep(/c$/) { |x| x.upcase } # => ["ABC", "BCC", "BBC"]
{% endhighlight %}

##17. include?
渡した要素と等しい要素が配列内にあるか調べる`include?`を実装します。
{% highlight ruby %}
class List < Array
  def include?(val)
    inject(false) do |m, x|
      return true if x == val
      false
    end
  end
end

List['ruby', 'python', 'haskell'].include?('haskell') # => true
{% endhighlight %}
`x == val`で一致する要素があったらtrueを返して処理を終えます。

##18. partition
ブロックの条件で要素を２つのグループに分ける`partition`を実装します。

{% highlight ruby %}
class List < Array
  def partition
    inject([[], []]) { |m, x| ( yield(x) ? m[0] : m[1] ) << x; m }
  end
end

List[3,5,1,4,2,0].partition { |x| x < 3 } # => [[1, 2, 0], [3, 5, 4]]
{% endhighlight %}
変数mが`[[],[]]`を指すようにし、ブロックの実行結果に応じて要素xの挿入先を変えます。

##19. group_by
ブロックの条件で要素を分けたハッシュを返す`group_by`を実装します。
{% highlight ruby %}
class List < Array
  def group_by
    inject({}) { |m, x| ( m[yield(x)] ||= [] ) << x; m }
  end
end

List[3,5,1,4,2,0].group_by { |x| x%3 } # => {0=>[3, 0], 2=>[5, 2], 1=>[1, 4]}
{% endhighlight %}
変数mが`{}`を指すようにし、ブロックの実行結果をキーとして要素xを挿入していきます。

##20. count
渡した要素の配列中の個数を返す`count`を実装します。
{% highlight ruby %}
class List < Array
  def count(val)
    inject(0) { |m, x| x==val ? m + 1 : m }
  end
end

List[1,2,3,2,3,5,1,4,2,0].count(2) # => 3
{% endhighlight %}
引数valに一致する要素があるときに変数mを増分します。

元の実装では引数がないときは要素数を返すので、これにも対応します。
{% highlight ruby %}
class List < Array
  def count(val=nil)
    inject(0) do |m, x|
      case
      when val
        x==val ? m + 1 : m
      else
        m + 1
      end
    end
  end
end

List[1,2,3,2,3,5,1,4,2,0].count(2) # => 3
List[1,2,3,2,3,5,1,4,2,0].count # => 10
{% endhighlight %}

更に、ブロックが渡されたときはその条件に一致する要素数を返す機能も実装します。

{% highlight ruby %}
class List < Array
  def count(val=nil)
    inject(0) do |m, x|
      case 
      when val
        x==val ? m + 1 : m
      when val.nil? && block_given?
        yield(x) ? m + 1 : m
      else
        m + 1
      end
    end
  end
end

List[1,2,3,2,3,5,1,4,2,0].count(2) # => 3
List[1,2,3,2,3,5,1,4,2,0].count # => 10
List[1,2,3,2,3,5,1,4,2,0].count { |x| x > 3 } # => 2
{% endhighlight %}
ブロックを渡されたときのwhen節を追加します。

##21. join
要素を連結した文字列を返す`join`を定義します。
{% highlight ruby %}
class List < Array
  def join
    inject('') { |m, x| m + x  }
  end
end

List['hello', 'world', 'of', 'inject'].join # => "helloworldofinject"
{% endhighlight %}
String#+で空の文字列に要素を足していきます。

セパレータを入れられるようにします。
{% highlight ruby %}
class List < Array
  def join(sep=nil)
    s = inject('') { |m, x| m + "#{x}#{sep}" }
    sep ? s.gsub(/#{sep}$/,'') : s
  end
end

List['hello', 'world', 'of', 'inject'].join # => "helloworldofinject"
List['hello', 'world', 'of', 'inject'].join('-') # => "hello-world-of-inject"
{% endhighlight %}

ついでにブロックも取れるようにします。
{% highlight ruby %}
class List < Array
  def join(sep=nil)
    s = inject('') { |m, x| m + (block_given? ? yield("#{x}#{sep}") : "#{x}#{sep}") }
    sep ? s.gsub(/#{sep}$/,'') : s
  end
end

List['hello', 'world', 'of', 'inject'].join # => "helloworldofinject"
List['hello', 'world', 'of', 'inject'].join('-') # => "hello-world-of-inject"
List['hello', 'world', 'of', 'inject'].join('-') { |x| x.capitalize } # => "Hello-World-Of-Inject"
{% endhighlight %}

##22. assoc
２次元配列をハッシュに見立てて、渡されたキーに一致する要素を返す`assoc`を実装します。
{% highlight ruby %}
class List < Array
  def assoc(key)
    inject(nil) do |m, x|
      return x if x[0]==key
      m
    end
  end
end

List[[:a, 1], [:b, 2], [:c, 3]].assoc(:b) # => [:b, 2]
{% endhighlight %}
引数keyと一致する先頭要素を持つ配列があったときに、その配列を返します。

##23. zip
複数のリストの要素をその要素位置でグループ化した新たな配列を作る`zip`を実装します。
{% highlight ruby %}
class List < Array
  def zip(list)
    xs = list.dup
    inject([]) { |m, x| m << [x, xs.shift]; m }
  end
end

List[:a,:b,:c].zip(List[:x,:y,:z]) # => [[:a, :x], [:b, :y], [:c, :z]]
{% endhighlight %}
引数で渡されたlist自身が破壊されないようコピーを作って操作します。shiftを使って先頭要素を取り出します。

３以上のリストにも対応させます。
{% highlight ruby %}
class List < Array
  def zip(*list)
    xs = list.map(&:dup)
    inject([]) do |m, x|
      m << [x] + xs.inject([]) { |_m, _x| _m << _x.shift; _m }
      m
    end
  end
end

List[:a,:b,:c].zip(List[:x,:y,:z]) # => [[:a, :x], [:b, :y], [:c, :z]]
List[:a,:b,:c].zip(List[:x,:y,:z],List[1,2,3]) # => [[:a, :x, 1], [:b, :y, 2], [:c, :z, 3]]
{% endhighlight %}
引数で渡されたリストxsに対してもinjectを適用して各リストの先頭要素を順次引き出します。

##24. reverse
要素の順位を逆にする`reverse`を実装します。
{% highlight ruby %}
class List < Array
  def reverse
    inject([]) { |m, x| m.unshift x }
  end
end

List[1,2,3,4,5].reverse # => [5, 4, 3, 2, 1]
{% endhighlight %}
Array#unshiftを使って、要素を空配列に前から挿入していきます。

##25. values_at
渡された複数の位置の要素を返す`values_at`を実装します。
{% highlight ruby %}
class List < Array
  def values_at(*pos)
    l = []
    inject(0) { |m, x| l << x if pos.include?(m); m + 1 }
    l
  end
end

List[1,2,3,4,5,6,7].values_at(1,3,5) # => [2, 4, 6]
{% endhighlight %}
変数mはカウンタとして使い、結果を格納する配列lを別途用意します。

##26. compact
配列からnil要素を除去する`compact`を実装します。
{% highlight ruby %}
class List < Array
  def compact
    inject([]) { |m, x| x ? m << x : m }
  end
end

List[:a, :b, nil, :c, nil, :d, nil, :e].compact # => [:a, :b, :c, :d, :e]
{% endhighlight %}

##27. take
先頭から渡された数までの要素の配列を返す`take`を実装します。
{% highlight ruby %}
class List < Array
  def take(n)
    l = []
    inject(0) do |m, x|
      return l if m >= n
      l << x
      m + 1
    end
    l
  end
{% endhighlight %}
配列mをカウンタとして、別途用意した空配列lにカウンタがnになるまで要素を追加していきます。

##28. flat_map
２次元配列に対するブロックの実行結果を１次元配列として返す`flat_map`を実装します。
{% highlight ruby %}
class List < Array
  def flat_map
    inject([]) { |m, x| m + yield(x) }
  end
end

List[List[1,2],List[3,4]].flat_map { |xs| xs.map { |x| x*2 } } # => [2, 4, 6, 8]
{% endhighlight %}

##29. product
各配列から順次抽出される要素の組の集合を返す`product`を実装します。
{% highlight ruby %}
class List < Array
  def product(list)
    inject([]) do |m, x|
      m + list.inject([]) { |_m, y| _m << [x, y] }
    end
  end
end

List[1,2,3].product(List[4,5]) # => [[1, 4], [1, 5], [2, 4], [2, 5], [3, 4], [3, 5]]
{% endhighlight %}
injectを二重に使って要素を引き出します。

-----

29個のメソッドの実装が完了しました。inject、最強ですよね？ガッテンしてもらえるなら、あなたも明日からinject厨です！


[list method implementation with inject — Gist](https://gist.github.com/2944128 'list method implementation with `inject` — Gist')

{% footnotes %}
  {% fn ええ、個人的極論です %}
  {% fn ええ、個人的感想です %}
  {% fn rspecが使えなくなります %}
{% endfootnotes %}
