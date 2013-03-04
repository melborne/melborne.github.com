---
layout: post
title: '知って得する！５５のRubyのトリビアな記法'
tagline: '55 Trivia Notations you should know in Ruby'
category: 
tags: 
date: 2013-03-04
published: true
---
{% include JB/setup %}


Rubyはたのしい言語です。Rubyを触っているとマニュアルにも書いていない「**小さな発見**」に遭遇することがよくあります。このような「発見」は、プログラムの質や効率の改善には直結しないかもしれません。いや、むしろチームプログラミングでは妨げになる可能性すらあります。しかしその一方で、言語自体が自分の知らない領域を持ち続けていることが、その対象に対する興味を失わせないための大きな要因である、というのもまた疑いのない事実なのです。つまり「発見」はたのしさに直結しているのです。

このブログにおいて「知って得するRubyのトリビアな記法」というタイトルで、今まで３回記事を書きました。

> {% hatebu http://melborne.github.com/2011/06/22/21-Ruby-21-Trivia-Notations-you-should-know-in-Ruby/ "知って得する21のRubyのトリビアな記法" %}
>
> {% hatebu http://melborne.github.com/2012/02/08/2-12-Ruby-12-Trivia-Notations-you-should-know-in-Ruby/ "第２弾！知って得する12のRubyのトリビアな記法" %}
>
> {% hatebu http://melborne.github.com/2012/04/26/ruby-trivias-you-should-know/ "第３弾！知って得する12のRubyのトリビアな記法" %}

これらのトリビアには、ネット検索で見つけたもの、Twitterで教えてもらったもの、自分で発見したものが含まれていますが、それらに出会うたびに「へぇ〜」とか「ほぅ〜」とかの声が出て自分の口元は緩みました。

ここでは上記45個のトリビアを再編集したものと、新たに用意した10のトリビアをまとめて紹介します。全体を再構成し、比較的理解しやすいものを前半にやや難解なものを後半に配置し、一部記述も簡潔になるよう修正しました。ここでは言語とはどうあるべきかリーダブルなコードとはなにかなどと難しいことはあまり考えずに、口元を緩めながら気楽にトリビアを楽しんでもらえればと思います。対象Rubyバージョンは1.9および2.0です。

---

加えて、本記事を電子書籍化もしました。本記事を電子書籍形式でじっくりと楽しみたい方は購入ご検討下さい。epub形式に加えKindleで扱えるmobi形式を同梱しました。

<a href="{{ BASE_PATH }}/books/">
  <img src="/assets/images/2013/03/ruby_trivia_cover.png" alt="trivia" style="width:200px" />
</a>

> [M'ELBORNE BOOKS]({{ site.url }}/books/ 'M'ELBORNE BOOKS')

---

##1. Arrayスタック系メソッド
`Array#<<`は一つのオブジェクトしか引数に取れませんが、`Array#push`は複数取れます。また`Array#pop`は一度に複数の値をポップできます。`Array#unshift` `Array#shift`も同じです。
{% highlight ruby %}
 stack = []
 stack.push 1, 2, 3 # => [1, 2, 3]
 stack.pop 2 # => [2, 3]
 stack # => [1]
 stack.unshift 4, 5, 6 # => [4, 5, 6, 1]
 stack.shift 3 # => [4, 5, 6]
 stack # => [1]
{% endhighlight %}

また任意位置の複数の値を取り出す場合は、`Array#values_at`が便利です。
{% highlight ruby %}
 lang = %w(ruby python perl haskell lisp scala)
 lang.values_at 0, 2, 5 # => ["ruby", "perl", "scala"]
{% endhighlight %}

これはHashにもあります。
{% highlight ruby %}
lang = {ruby:'matz', python:'guido', perl:'larry', lisp:'mccarthy'}

lang.values_at :ruby, :perl # => ["matz", "larry"]
{% endhighlight %}

##2. Kernel#Array
異なる型の引数を統一的に処理するときには`Kernel#Array`が便利です。
{% highlight ruby %}
 Array 1 # => [1]
 Array [1,2] # => [1, 2]
 Array 1..5 # => [1, 2, 3, 4, 5]
 
 require "date"
 def int2month(nums)
   Array(nums).map { |n| Date.new(2010,n).strftime "%B"  }
 end
 
 int2month(3) # => ["March"]
 int2month([2,6,9]) # => ["February", "June", "September"]
 int2month(4..8) # => ["April", "May", "June", "July", "August"]
{% endhighlight %}

##3. 要素区切りコンマ
配列とハッシュの各要素の区切りにはコンマが使われますが、最後の要素のカンマは無視されます。
{% highlight ruby %}
 p designers = [
                 "John McCarthy",
                 "Yukihiro Matsumoto",
                 "Larry Wall",
                 "Alan Kay",
                 "Martin Odersky",
               ]
 
 # >> ["John McCarthy", "Yukihiro Matsumoto", "Larry Wall", "Alan Kay", "Martin Odersky"]
 
 p designers = {
                 :lisp => "John McCarthy",
                 :ruby => "Yukihiro Matsumoto",
                 :perl => "Larry Wall",
                 :smalltalk => "Alan Kay",
                 :scala => "Martin Odersky",
               }
 
 # >> {:lisp=>"John McCarthy", :ruby=>"Yukihiro Matsumoto", :perl=>"Larry Wall", :smalltalk=>"Alan Kay", :scala=>"Martin Odersky"}
{% endhighlight %}
要素を頻繁に追加・削除したり、ファイルからevalするときなどにいいかもしれません。

##4. ハッシュリテラル
Ruby1.9ではハッシュの新しい記法が導入されましたが、これは古い記法と混在できます。
{% highlight ruby %}
 designers1 = {
               :lisp => "John McCarthy",
               :ruby => "Yukihiro Matsumoto",
               :perl => "Larry Wall",
               :smalltalk => "Alan Kay",
               :'C++' =>  "Bjarne Stroustrup",
             }
 
 designers2 = {
               java: "James Gosling",
               python: "Guido van Rossum",
               javascript: "Brendan Eich",
               scala: "Martin Odersky",
             }
 
 designers = designers1.merge designers2
  # => {:lisp=>"John McCarthy", :ruby=>"Yukihiro Matsumoto", :perl=>"Larry Wall", :smalltalk=>"Alan Kay", :"C++"=>"Bjarne Stroustrup", :java=>"James Gosling", :python=>"Guido van Rossum", :javascript=>"Brendan Eich", :scala=>"Martin Odersky"}
{% endhighlight %}

##5. Enumerable#each_with_object
Enumerable#injectは便利なメソッドですが、ブロック内で条件指定をするような場合でも各イテレーションで畳込みオブジェクトが返されることを保証しなければなりません。
{% highlight ruby %}
 designers.inject([]) { |mem, (lang, name)| mem << [name,lang].join('/') if lang[/l/]; mem }
  # => ["John McCarthy/lisp", "Larry Wall/perl", "Alan Kay/smalltalk", "Martin Odersky/scala"]
{% endhighlight %}
ブロックの最後の「; mem」の部分です。

`Enumerable#each_with_object`ならその手間は要りません。
{% highlight ruby %}
 designers.each_with_object([]) { |(lang, name), mem| mem << [name,lang].join('/') if lang[/l/] }
  # => ["John McCarthy/lisp", "Larry Wall/perl", "Alan Kay/smalltalk", "Martin Odersky/scala"]
{% endhighlight %}
名前が長いのでどうしても避けちゃいますが...

##6. splat展開
Rubyでアルファベットの配列を作るときなどは通常、以下のようにします。
{% highlight ruby %}
 (1..20).to_a # => [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20]
 ('a'..'z').to_a # => ["a", "b", "c", "d", "e", "f", "g", "h", "i", "j", "k", "l", "m", "n", "o", "p", "q", "r", "s", "t", "u", "v", "w", "x", "y", "z"]
 (1..10).to_a + (20..30).to_a # => [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30]
{% endhighlight %}

これは`*`(splat)展開を使って以下のようにも書けます。
{% highlight ruby %}
 [*1..20] # => [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20]
 [*'a'..'m'] # => ["a", "b", "c", "d", "e", "f", "g", "h", "i", "j", "k", "l", "m"]
 [*1..10, *20..30] # => [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30]
{% endhighlight %}

##7. 前置コロン
文字列をシンボルに変換するときは通常、String#internかString#to_symを使いますが、文字列リテラルにコロンを前置することでも可能です。
{% highlight ruby %}
 'goodbye'.intern # => :goodbye
 'goodbye'.to_sym # => :goodbye
 
 :'goodbye' # => :goodbye
 
 a = 'goodbye'
 :"#{a}" # => :goodbye
{% endhighlight %}


##8. Enumerator#with_index
任意のリストを標準出力するときに連番を同時に振る場合、普通は`Enumerable#each_with_index`を使います。
{% highlight ruby %}
names = Module.constants.take(10)
names.each_with_index { |name, i| puts "%d: %s" % [i+1, name] }
# >> 1: Object
# >> 2: Module
# >> 3: Class
# >> 4: Kernel
# >> 5: NilClass
# >> 6: NIL
# >> 7: Data
# >> 8: TrueClass
# >> 9: TRUE
# >> 10: FalseClass
{% endhighlight %}


`i+1`ってのがイマイチですよね？そんな人には`Enumerator#with_index`があります。
{% highlight ruby %}
names = Module.constants.take(10)
names.each.with_index(1) { |name, i| puts "%d: %s" % [i, name] }
# >> 1: Object
# >> 2: Module
# >> 3: Class
# >> 4: Kernel
# >> 5: NilClass
# >> 6: NIL
# >> 7: Data
# >> 8: TrueClass
# >> 9: TRUE
# >> 10: FalseClass
{% endhighlight %}

with_indexはindexのoffsetを引数に取れます。comparableなオブジェクトが取れたらもっとよかったのですが。

##9. Integer#times
`times`は処理を特定回数だけ繰り返したいときに使います。
{% highlight ruby %}
you_said = 'てぶくろ'
6.times { puts you_said.reverse! } # => 6
# >> ろくぶて
# >> てぶくろ
# >> ろくぶて
# >> てぶくろ
# >> ろくぶて
# >> てぶくろ
{% endhighlight %}

timesはブロックを渡さないとEnumeratorを返します。よって複数のオブジェクトを生成するようなことにも使えます。20個のRGBカラーサンプルを作ってみます。
{% highlight ruby %}
20.times.map { [rand(256), rand(256), rand(256)] } # => [[45, 190, 194], [94, 43, 125], [6, 104, 181], [144, 92, 114], [34, 161, 214], [96, 69, 241], [216, 246, 133], [6, 237, 131], [194, 95, 214], [177, 252, 202], [184, 149, 142], [184, 166, 45], [41, 108, 115], [176, 100, 138], [124, 213, 89], [173, 123, 34], [137, 31, 47], [54, 92, 186], [118, 239, 217], [150, 184, 240]]
{% endhighlight %}

##10. String#succ / Integer#succ
ExcelのAから始まる横のラベルを作りたいんだけどどうする？といった問題が最近ありました。Rubyには`String#succ`または`next`があるからこれは簡単です。
{% highlight ruby %}
col = '@'
60.times.map { col = col.succ } # => ["A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z", "AA", "AB", "AC", "AD", "AE", "AF", "AG", "AH", "AI", "AJ", "AK", "AL", "AM", "AN", "AO", "AP", "AQ", "AR", "AS", "AT", "AU", "AV", "AW", "AX", "AY", "AZ", "BA", "BB", "BC", "BD", "BE", "BF", "BG", "BH"]
{% endhighlight %}

##11. Comparable.between?
値が一定範囲内にあるかどうかで処理を切り分けたいことがあります。普通は次のようにします。
{% highlight ruby %}
pos = 48
status =
  if 0 <= pos && pos <= 50
    :you_are_in
  else
    :you_are_out
  end
status # => :you_are_in
{% endhighlight %}
そしてCoffeeScriptを見て悔しがるのです。しかし安心して下さい、Rubyには`between?`があります。
{% highlight ruby %}
pos = 48
status =
  if pos.between?(0, 50)
    :you_are_in
  else
    :you_are_out
  end
status # => :you_are_in

pos = 'D'
grade =
  if pos.between?('A', 'C')
    :you_are_good!
  else
    :try_again!
  end
grade # => :try_again!
{% endhighlight %}


もっとも僕はcase派ですが..
{% highlight ruby %}
pos = 48
status =
  case pos
  when 0..50
    :you_are_in
  else
    :you_are_out
  end
status # => :you_are_in
{% endhighlight %}

##12. Array#first/last
`Array#first/last`は個数の引数を取れます。
{% highlight ruby %}
arr = [*1..100]
arr.first(5) + arr.last(5) # => [1, 2, 3, 4, 5, 96, 97, 98, 99, 100]
{% endhighlight %}

これはRangeにもあるので上の式は次のように書くのが正しいですね。
{% highlight ruby %}
range = (1..100)
range.first(5) + range.last(5) # => [1, 2, 3, 4, 5, 96, 97, 98, 99, 100]
{% endhighlight %}

##13. 変数のnil初期化 
多数の変数を`nil`で初期化したいときってありませんか？そんなときはこうしますか？
{% highlight ruby %}
a, b, c, d, e, f, g, h, i, k = [nil] * 10

[a, b, c, d, e, f, g, h, i, k].all?(&:nil?) # => true
{% endhighlight %}

しかし、多重代入で対応する値がない場合はnilが入るので、これは次で足ります。
{% highlight ruby %}
a, b, c, d, e, f, g, h, i, k = nil

[a, b, c, d, e, f, g, h, i, k].all?(&:nil?) # => true
{% endhighlight %}

##14. ハッシュのキー
ハッシュリテラルは次のように書きます。
{% highlight ruby %}
{a: 1, b: 2, c: 3, a: 4, e: 5} # => {:a=>4, :b=>2, :c=>3, :e=>5}
{% endhighlight %}
気が付きましたか？うっかりキーを重複させてもエラーにならないのです。

特に配列をハッシュに変換するときなどには注意が必要です。
{% highlight ruby %}
arr = [a: 1, b: 2, c: 3, a: 4, e: 5]
Hash[ *arr ] # => {:a=>4, :b=>2, :c=>3, :e=>5}
{% endhighlight %}

##15. メソッド引数のスペース
Rubyで引数付きメソッドを呼ぶときはそのカッコを省略できますが、引数がシンボルであればさらに、メソッド名との間のスペースも省略できます。
{% highlight ruby %}
 def name(sym)
   @name = sym
 end

 name:charlie # => :charlie
{% endhighlight %}
こうするとより宣言的に見えます。

と、思いましたがこれを変数に代入したりputsしたりすると、上手くパースされないということが分かったので、用途は限定的です。

また* &の後ろのスペースは無視されるので、次のような書き方ができます。
{% highlight ruby %}
 def teach_me(question, * args, & block)
   google(question, * args, & block)
 end

 a, b, * c = 1,2,3,4
 c # => [3,4]
{% endhighlight %}
だからどうしたという話ですが。


##16. 否定
否定に使われる`!`あるいは`not`が好きじゃない人いますか？それなら`BasicObject#!`があります！
{% highlight ruby %}
 true.! # => false
 false.! # => true
 1.! # => false
 'hello'.!.! # => true
{% endhighlight %}
...

次に行きます..

##17. ％ノーテーション
String#%を使うことで文字列に指定フォーマットでオブジェクトを埋め込めますが、%は配列を受け取れるのです。
{% highlight ruby %}
 lang = [:ruby, :java]
 "I love %s, not %s" % lang # => "I love ruby, not java"
{% endhighlight %}

それだけじゃなく実はハッシュも取れるのです。
{% highlight ruby %}
 lang = {a: :java, b: :ruby}
 "I love %{b}, not %{a}" % lang # => "I love ruby, not java"
{% endhighlight %}

##18. 文字列区切り
文字列を各文字に区切るには、`String#split`か`String#chars`が使えます。
{% highlight ruby %}
 alpha = "abcdefghijklmnopqrstuvwxyz"
 alpha.split(//) # => ["a", "b", "c", "d", "e", "f", "g", "h", "i", "j", "k", "l", "m", "n", "o", "p", "q", "r", "s", "t", "u", "v", "w", "x", "y", "z"]
 
 alpha.chars.to_a # => ["a", "b", "c", "d", "e", "f", "g", "h", "i", "j", "k", "l", "m", "n", "o", "p", "q", "r", "s", "t", "u", "v", "w", "x", "y", "z"]
{% endhighlight %}
ちなみに、ruby2.0ではcharsの後のto_aは不要です。

しかし文字列を複数文字単位で区切るには`String#scan`が便利です。
{% highlight ruby %}
 alpha.scan(/.../) # => ["abc", "def", "ghi", "jkl", "mno", "pqr", "stu", "vwx"]
 alpha.scan(/.{1,3}/) # => ["abc", "def", "ghi", "jkl", "mno", "pqr", "stu", "vwx", "yz"]
 
 number = '12345678'
 def number.comma_value
   reverse.scan(/.{1,3}/).join(',').reverse
 end
 number.comma_value # => "12,345,678"
{% endhighlight %}

##19. Array#*
`Array#*`に整数を渡すとそれを繰り返した新たな配列を返しますが、文字列を渡すとそれをセパレータとした連結文字列を返す`join`の役割を果たします。
{% highlight ruby %}
 [1, 2, 3] * 3 # => [1, 2, 3, 1, 2, 3, 1, 2, 3]
 
 [2009, 1, 10] * '-' # => "2009-1-10"
{% endhighlight %}

では、この知識を生かしてつぎのxの出力を答えて下さい！
{% highlight ruby %}
*a, b, c = %w(1 2 3 4 5)

x = a * b + c

puts x
{% endhighlight %}

##20. Array#uniq
配列から重複した値を取り除くときは`Array#uniq`を使いますが、uniqはブロックを取れるのでそこで重複の条件を指定できるのです。
{% highlight ruby %}
 Designer = Struct.new(:name, :lang)
 data = {'matz' => :ruby, 'kay' => :smalltalk, 'gosling' => :java, 'dhh' => :ruby}
 designers = data.to_a.map { |name, lang| Designer[name, lang] }
 
 designers # => [#<struct Designer name="matz", lang=:ruby>, #<struct Designer name="kay", lang=:smalltalk>, #<struct Designer name="gosling", lang=:java>, #<struct Designer name="dhh", lang=:ruby>]

 designers.uniq.map(&:name) # => ["matz", "kay", "gosling", "dhh"]
 designers.uniq{ |d| d.lang }.map(&:name) # => ["matz", "kay", "gosling"]
{% endhighlight %}

そうそう、No19の答えは「"142435"」です。

##21. 配列要素の一致判定
配列の全要素が同じかどうかを調べたいときにもArray#uniqが使えます。
{% highlight ruby %}
[1, 1, 1, 1, 1, 1, 1, 1, 1, 1].uniq.size==1 # => true
[1, 1, 1, 1, 1, 1, 1, 2, 1, 1].uniq.size==1 # => false
{% endhighlight %}

条件を揃えたいときはuniqのブロックを使えばいいですね。
{% highlight ruby %}
%w(street retest setter tester).uniq { |w| w.chars.sort }.size==1 # => true
{% endhighlight %}


##22. 文字列リスト%w
文字列のリストを作るときには%ｗリテラルが便利ですが、文字列が空白文字を含むときはバックスラッシュでエスケープすればいいです。
{% highlight ruby %}
 designers = %w(John\ McCarthy Yukihiro\ Matsumoto Larry\ Wall Alan\ Kay Martin\ Odersky)
 designers # => ["John McCarthy", "Yukihiro Matsumoto", "Larry Wall", "Alan Kay", "Martin Odersky"]
{% endhighlight %}

##23. 動的継承
Rubyのクラス継承では `<` 記号の右辺にクラス定数だけでなくクラスを返す式が書けます。乱数でsuperclassを決める例です。
{% highlight ruby %}
 class Male
  def laugh
    'Ha ha ha!'
  end
 end

 class Female
  def laugh
    'Fu fu fu..'
  end
 end

 class Me < [Male, Female][rand 2]
 end

 Me.superclass # => Female
 Me.new.laugh # => 'Fu fu fu..'
{% endhighlight %}

環境に応じてIOを切り替える例も示します。
{% highlight ruby %}
 def io(env=:development)
   env==:test ? StringIO : IO
 end

 env = :test

 class MyIO < io(env)
 end

 MyIO.superclass #=> StringIO
{% endhighlight %}
つまりRubyでは条件に応じて継承するクラスを動的に変えることができるのです。

##24. 大文字メソッド
Rubyでは通常メソッド名には英小文字を使いますが、英大文字も許容されています。大文字メソッドは一見定数に見えます。
{% highlight ruby %}
 class Google
   def URL
     'www.google.com'
   end
   private :URL

   def search(word)
     get( URL(), word)
   end
 end
{% endhighlight %}
定数は継承サブクラスで参照されますが、これを非公開にしたいこともあるでしょう。そんなときには大文字メソッドがいいかもしれません。

引数がないときでもカッコを省略できないという欠点はありますが、関連する複数の定数を定義するときなどにも便利に使えます。
{% highlight ruby %}
 class Google
   def search(word, code=:us)
     get( URL(code), word )
   end

   def URL(code)
     { us: 'www.google.com',
       ja: 'www.google.co.jp' }[code]
   end
   private :URL
{% endhighlight %}
「定数メソッド」という呼び方はどうでしょう。

##25. 関数部分適用
似たようなメソッドを複数書くことはDRY原則に反します。`Proc#curry`を使えばこれを回避できるかもしれません。四季判定関数の例を示します。
{% highlight ruby %}
 require "date"
 
 season = ->range,date{ range.include? Date.parse(date).mon }.curry
 
 is_spring = season[4..6]
 is_summer = season[7..9]
 is_autumn = season[10..12]
 is_winter = season[1..3]
 
 is_autumn['11/23'] # => true
 is_summer['1/1'] # => false
{% endhighlight %}
こうなると変数名に`?`が使えるとうれしいですね。

##26. Procによるcase判定
Procの実行はcallメソッドを呼ぶことで実現できますが、`Proc#===`はその別名になっているのです。先の四季判定関数をcase式で使う例で使い方を見ます。
{% highlight ruby %}
 for date in %w(2/4 11/23 6/14 8/3)
   act = 
     case date
     when is_spring; 'Wake up!'
     when is_summer; 'Cool down!'
     when is_autumn; 'Read!'
     when is_winter; 'Sleep!'
     end
   puts "#{date} => #{act}"
 end
 # >> 2/4 => Sleep!
 # >> 11/23 => Read!
 # >> 6/14 => Wake up!
 # >> 8/3 => Cool down!
{% endhighlight %}
引数の受け渡しが暗黙的に行われるので、case式が非常にすっきりします。

##27. Structクラス
属性主体のクラスを生成するときには`Struct`が便利です。
{% highlight ruby %}
 module Fortune
   class Teller
     require "date"
     def self.ask(name, age, occupation)
       Date.today.next_day(rand 10)
     end
   end
 end
 
 class Person < Struct.new(:name, :age, :occupation)
   def length_of_life(date)
     (Fortune::Teller.ask(name, age, occupation) - Date.parse(date)).to_i
   end
 end
 
 charlie = Person.new('charlie', 13, :programmer)
 charlie.length_of_life('2013/3/1') # => 6
{% endhighlight %}

実はStruct.newはブロックを取れるので、下のような書き方もできます。
{% highlight ruby %}
 Person = Struct.new(:name, :age, :occupation) do
   def length_of_life(date)
     (Fortune::Teller.ask(name, age, occupation) - Date.parse(date)).to_i
   end
 end

 charlie = Person.new('charlie', 13, :programmer)
 charlie.length_of_life('2013/3/1') # => 3
{% endhighlight %}

##28. Structのデフォルト値

もう一つStructです。今度はBeverageオブジェクトを作ります。

{% highlight ruby %}
class Beverage < Struct.new(:name, :cost)
end

# または、Beverage = Struct.new(:name, :cost)

starbucks = Beverage.new(:staba, 430) # => #<struct Beverage name=:staba, cost=430>
heineken = Beverage.new(:heineken, 580) # => #<struct Beverage name=:heineken, cost=580>
{% endhighlight %}

ここで`new`に引数を渡さないとその属性値にはnilがセットされてしまいます。

{% highlight ruby %}
Beverage.new # => #<struct Beverage name=nil, cost=nil>
{% endhighlight %}

できればクラスの場合と同じようにデフォルト値をセットしたいです。そんなときはこうします。
{% highlight ruby %}
class Beverage < Struct.new(:name, :cost)
  def initialize(name=:water, cost=0)
    super(name, cost)
  end
end

starbucks = Beverage.new(:staba, 430) # => #<struct Beverage name=:staba, cost=430>
heineken = Beverage.new(:heineken, 580) # => #<struct Beverage name=:heineken, cost=580>

water = Beverage.new # => #<struct Beverage name=:water, cost=0>
{% endhighlight %}


##29. retryと引数デフォルト
rescue節では`retry`を使うことによって、そのブロックの処理を再実行させることができます。これをメソッド引数のデフォルト値と組み合わせることで、便利に使えるときがあります。
{% highlight ruby %}
 require "date"
 def last_date(date, last=[28,29,30,31])
   d = Date.parse date
   Date.new(d.year, d.mon, last.pop).day rescue retry
 end
 
 last_date '2013/6/1' # => 30
 last_date '2012/2/20' # => 29
 last_date '2013/2' # => 28
{% endhighlight %}
この例では31日からDateオブジェクトの生成を試して、例外が発生するとretryにより次の日付を試していきます。

まあ上のはこれでいいんですが。
{% highlight ruby %}
 Date.new(2013,2,-1).day # => 28
{% endhighlight %}


##30. Array#zip
`Array#zip`は知ってますよね？複数の配列を二次元配列に見立てて縦方向に組み替えるものです。
{% highlight ruby %}
[1, 2, 3].zip([4, 5, 6], [7, 8, 9]) # => [[1, 4, 7], [2, 5, 8], [3, 6, 9]]

[:A, :B, :C].zip([:E, :F, :G], [:H, :I, :J]) # => [[:A, :E, :H], [:B, :F, :I], [:C, :G, :J]]
{% endhighlight %}

zipは通常１または複数の配列を引数に取りますが、値が連続する場合はRangeを渡せるのです。

{% highlight ruby %}
[1, 2, 3].zip(4..6, 7..9) # => [[1, 4, 7], [2, 5, 8], [3, 6, 9]]

[:A, :B, :C].zip(:E..:G, :H..:J) # => [[:A, :E, :H], [:B, :F, :I], [:C, :G, :J]]
{% endhighlight %}

加えて、zipはブロックを取ることもできるのです。
{% highlight ruby %}
[1, 2, 3].zip(4..6, 7..9) { |xyz| puts xyz.inject(:+) } # => nil
# >> 12
# >> 15
# >> 18

[:A, :B, :C].zip(:E..:G, :H..:J) { |xyz| puts xyz.join } # => nil
# >> AEH
# >> BFI
# >> CGJ
{% endhighlight %}
ただ、返り値がnilになるので副作用しか使えない点注意が必要です。

##31. Enumerable#zip
zipはEnumerableにも定義されています。

{% highlight ruby %}
(1..3).zip(4..6, 7..9) # => [[1, 4, 7], [2, 5, 8], [3, 6, 9]]

(:A..:C).zip(:E..:G, :H..:J) # => [[:A, :E, :H], [:B, :F, :I], [:C, :G, :J]]
{% endhighlight %}

StructもEnumerableなオブジェクトなので、こんなこともできます。
{% highlight ruby %}
water = Beverage.new  # => #<struct Beverage name=:water, cost=0>
starbucks = Beverage.new(:staba, 430) # => #<struct Beverage name=:staba, cost=430>
heineken = Beverage.new(:heineken, 580) # => #<struct Beverage name=:heineken, cost=580>

water.zip(starbucks, heineken) # => [[:water, :staba, :heineken], [0, 430, 580]]
{% endhighlight %}

##32. ARGF
ARGFはいいですよね。これはコマンドライン引数をファイル名とした連結ファイルオブジェクトを表します。ところで、このオブジェクトのクラスは何だか知ってますか？classメソッドを送れば答えがわかりますね。
{% highlight ruby %}
ARGF.class # => ARGF.class
{% endhighlight %}
そう、答えは`ARGF.class`クラスなのです。

ならnewしたらARGFできるの？と思いますよね。
{% highlight ruby %}
ARGF.class # => ARGF.class
MYARGF = ARGF.class.new  # => ARGF
MYARGF.class # => ARGF.class

puts MYARGF.filename
{% endhighlight %}

できた！って思ったのも束の間、これはうまく動きません。
{% highlight bash %}
% ruby argf_test.rb abc.txt
-
{% endhighlight %}
残念！

##33. Object#tap
`tap`はそのブロックの評価結果を捨てるという風変わりなメソッドですが、その結果を欲しいときもたまにあります。そんなときはbreakします（thanks to knuさん）。

{% highlight ruby %}
average = [56, 87, 49, 75, 90, 63, 65].tap { |sco| break sco.inject(:+) / sco.size } # => 69
{% endhighlight %}

カップ麺好きのあなたには次のコードを贈ります。
{% highlight ruby %}
puts "Eat!".tap { sleep 180 } # ３分後に'Eat!'
{% endhighlight %}

##34. 使わない変数 
配列データの端の要素を捨てたいときがあります。
{% highlight ruby %}
header, *data = DATA.each_line.map { |line| line.chomp.split }
header # => ["name", "age", "job"]
data # => [["charlie", "12", ":programmer"], ["tommy", "17", ":student"], ["nick", "27", ":doctor"]]

__END__
name age job
charlie 12 :programmer
tommy 17 :student
nick 27 :doctor
{% endhighlight %}

ところが、ここで`header`変数を使わないと警告がでるのです。
{% highlight ruby %}
header, *data = DATA.each_line.map { |line| line.chomp.split } # !> assigned but unused variable - header
data # => [["charlie", "12", ":programmer"], ["tommy", "17", ":student"], ["nick", "27", ":doctor"]]
{% endhighlight %}

これを避けるには変数名を`_`（アンダースコア）にします。
{% highlight ruby %}
_, *data = DATA.each_line.map { |line| line.chomp.split }
data # => [["charlie", "12", ":programmer"], ["tommy", "17", ":student"], ["nick", "27", ":doctor"]]
{% endhighlight %}

もしあなたが既に2.0ユーザなら、先頭に`_`を付けるだけでいいです。
{% highlight ruby %}
_header, *data = DATA.each_line.map { |line| line.chomp.split }
{% endhighlight %}

##35. ファイル抽出
ファイル群の中から、特定の条件にマッチする一つのファイルだけを抜き出して別の変数に格納したいとします。`Array#delete`を使えばうまくいきそうですが、どうでしょう。

{% highlight ruby %}
files = ['Gemfile', 'LICENSE.txt', 'README.md', 'Rakefile', 'bin', 'lib', 'maliq.gemspec', 'pkg', 'spec']

gemspec = files.delete(/\.gemspec$/)
gemspec # => nil
files # => ["Gemfile", "LICENSE.txt", "README.md", "Rakefile", "bin", "lib", "maliq.gemspec", "pkg", "spec"]
{% endhighlight %}
残念ながらうまくいきません。これは、Array#deleteが`==`で一致判定するからですね。

なら`Array#partition`と多重代入を使ってみましょう。
{% highlight ruby %}
gemspec, files = files.partition { |f| f.match(/\.gemspec$/) }
gemspec # => ["maliq.gemspec"]
files  # => ["Gemfile", "LICENSE.txt", "README.md", "Rakefile", "bin", "lib", "pkg", "spec"]
{% endhighlight %}

ちょっと惜しいですが、gemspecが配列になっているのでもう一歩です。しかしこれは多重代入＋括弧で解決します。

{% highlight ruby %}
(gemspec, *_), files = files.partition { |f| f.match(/\.gemspec$/) }
gemspec # => "maliq.gemspec"
files # => ["Gemfile", "LICENSE.txt", "README.md", "Rakefile", "bin", "lib", "pkg", "spec"]
{% endhighlight %}

##36. Symbolにコメント
シンボルにもコメントを付けたいと思ったことはありますか？それなら、こうして下さい。

{% highlight ruby %}
sym = :#this symbol is nice
hello

sym # => :hello
{% endhighlight %}
誰が何のために...

##37. Kernel#loop
無限の繰り返しはコードのブロックを`Kernel#loop`に渡すことで実現できます。
{% highlight ruby %}
 require "prime"

 prime = Prime.each

 n = 0
 loop do
   printf "%d " % prime.next
   break if n > 10
   n += 1
 end
 # >> 2 3 5 7 11 13 17 19 23 29 31 37 
{% endhighlight %}

ここでloopにブロックを渡さないとEnumeratorが返ります。これを利用すればloopのインデックスを作ることができます（thanks to @no6v1さん）。
{% highlight ruby %}
 loop # => #<Enumerator: main:loop>
 
 loop.with_index do |_,n|
   printf "%d " % prime.next
   break if n > 10
 end
 # >> 2 3 5 7 11 13 17 19 23 29 31 37 
{% endhighlight %}
ブロックの第１引数がnilになってしまいますが。


##38. BasicObject#instance_eval
`instance_eval`はオブジェクトの生成をDSL風にするときに良く使われています。
{% highlight ruby %}
class Person
  def initialize(&blk)
    instance_eval(&blk)
  end
  def name(name)
    @name = name
  end
  def age(age)
    @age = age
  end
  def job(job)
    @job = job
  end
  def profile
    [@name, @age, @job] * '-'
  end
end

t = Person.new do
  name 'Charlie'
  age  13
  job  :programmer
end

t.profile # => "Charlie-13-programmer"
{% endhighlight %}
しかし、このコンテキストを一時的に切り替えるこの機能はDSL以外でも便利に使えるのです。テストの結果の平均値を求めてみます。まずは普通のやり方で。

{% highlight ruby %}
scores = [56, 87, 49, 75, 90, 63, 65]
scores.inject(:+) / scores.size # => 69
{% endhighlight %}
短いコードで変数scoresが３回も出てきます。

instance_evalを使うと、scoreを消すことができます。
{% highlight ruby %}
[56, 87, 49, 75, 90, 63, 65].instance_eval { inject(:+) / size } # => 69
{% endhighlight %}


さらに標準偏差sdを求めてみます。まず普通に。
{% highlight ruby %}
scores = [56, 87, 49, 75, 90, 63, 65]
avg = scores.inject(:+) / scores.size
sigmas = scores.map { |n| (avg - n)**2 }
sd = Math.sqrt(sigmas.inject(:+) / scores.size) # => 14.247806848775006
{% endhighlight %}

instance_evalで。
{% highlight ruby %}
scores = [56, 87, 49, 75, 90, 63, 65]
sd = scores.instance_eval do
  avg = inject(:+) / size
  sigmas = map { |n| (avg - n)**2 }
  Math.sqrt(sigmas.inject(:+) / size)
end
sd # => 14.247806848775006
{% endhighlight %}
中間的な変数をブロック内に閉じ込められる上、ブロックで式がまとまって見やすくありませんか？

##39. 正規表現:名前付き参照
正規表現中で`()`を使えば部分マッチを捕捉できます。そして、それに名前を付けたいときは`?\<pattern\>`を使えばいいです。
{% highlight ruby %}
langs = "python lisp ruby haskell erlang scala"
m = langs.match(/(?<lang>\w+)/) # => #<MatchData "python" lang:"python">
m['lang'] # => "python"
{% endhighlight %}

そして、正規表現リテラルを左辺にした場合はこれをローカル変数として持ち出せるのです。
{% highlight ruby %}
langs = "python lisp ruby haskell erlang scala"
if /(?<most_fun_lang>r\w+)/ =~ langs
  printf "you should learn %s!", most_fun_lang
end
# >> you should learn ruby!
{% endhighlight %}

##40. 正規表現:POSIXブラケット
Ruby1.9では`\w`は日本語にマッチしなくなりました。1.9で日本語にもマッチさせたいときはPOSIXブラケットで`word`を使うといいかもしれません。
{% highlight ruby %}
need_japanese = "this-日本語*is*_really_/\\変わってる!"
need_japanese.scan(/\w+/) # => ["this", "is", "_really_"]
need_japanese.scan(/[[:word:]]+/) # => ["this", "日本語", "is", "_really_", "変わってる"]
{% endhighlight %}

##41. String#match
`String#match`はMatchDataオブジェクトを返すので次のように使えます。

{% highlight ruby %}
date = "2012february14"
m = date.match(/\D+/)
mon, day, year = m.to_s.capitalize, m.post_match, m.pre_match
"#{mon} #{day}, #{year}" # => "February 14, 2012"
{% endhighlight %}

しかしmatchはブロックを取れるので、次のようにしてもいいです。
{% highlight ruby %}
date = "2012february14"
mon, day, year = date.match(/\D+/) { |m| [m.to_s.capitalize, m.post_match, m.pre_match] }
"#{mon} #{day}, #{year}" # => "February 14, 2012"
{% endhighlight %}

##42. String#unpack
数字列を決まった長さ基準で区切りたいときはどうしますか？正規表現を使うのでしょうか。
{% highlight ruby %}
a_day = '20120214'
a_day.match(/(.{4})(.{2})(.{2})/).captures # => ["2012", "02", "14"]
{% endhighlight %}

`String#unpack`を使うともっと簡単かもしれません（thanks to @no6v1さん）。
{% highlight ruby %}
a_day = '20120214'
a_day.unpack('A4A2A2') # => ["2012", "02", "14"]
{% endhighlight %}


##43. Enumerable#each_with_object
Enumerable#mapではブロックの代わりに`&`付きのシンボルを渡す技が知られています。
{% highlight ruby %}
langs = ["ruby", "python", "lisp", "haskell"]
langs.map(&:capitalize) # => ["Ruby", "Python", "Lisp", "Haskell"]
{% endhighlight %}

しかし、この技は引数をとるようなメソッドには使えないという問題があります。
{% highlight ruby %}
langs = ["ruby", "python", "lisp", "haskell"]
langs.map(:+, 'ist') # => 
# ~> -:2:in `map': wrong number of arguments (2 for 0) (ArgumentError)
# ~> 	from -:2:in `<main>'
{% endhighlight %}

こんなときは`each_with_object`が使えます。
{% highlight ruby %}
langs = ["ruby", "python", "lisp", "haskell"]

langs.each_with_object('ist').map(&:+) # => ["rubyist", "pythonist", "lispist", "haskellist"]

[1, 2, 3].each_with_object(10).map(&:+) # => [11, 12, 13]
(1..5).each_with_object(2).map(&:**) # => [1, 4, 9, 16, 25]
{% endhighlight %}

名前がちょっと長いですね。って、素直にmapにブロック渡せって話ですね。

また、こんな技もあります（thanks to @tmaedaさん）。
{% highlight ruby %}
[1, 2, 3].map(&10.method(:+)) # => [11, 12, 13]
{% endhighlight %}
レシーバと引数が逆転するので用途は限定的ですが。

##44. Float::INFINITY
任意の数列を作りたい、しかしその大きさは事前に決めたくないというときがあります。ここで思いつくのは`Enumerator`です。

{% highlight ruby %}
sequence = Enumerator.new { |y| i=1; loop { y << i; i+=1 } }

sequence.take(10) # => [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]
100.times.map { sequence.next } # => [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32, 33, 34, 35, 36, 37, 38, 39, 40, 41, 42, 43, 44, 45, 46, 47, 48, 49, 50, 51, 52, 53, 54, 55, 56, 57, 58, 59, 60, 61, 62, 63, 64, 65, 66, 67, 68, 69, 70, 71, 72, 73, 74, 75, 76, 77, 78, 79, 80, 81, 82, 83, 84, 85, 86, 87, 88, 89, 90, 91, 92, 93, 94, 95, 96, 97, 98, 99, 100]
{% endhighlight %}

ただ`Enumerator`を使わなくても、似たようなことは無限大定数の`Float::INFINITY`でできます。
{% highlight ruby %}
sequence = 1..Float::INFINITY
sequence.take(10) # => [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]

seq = sequence.to_enum
100.times.map { seq.next } # => [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32, 33, 34, 35, 36, 37, 38, 39, 40, 41, 42, 43, 44, 45, 46, 47, 48, 49, 50, 51, 52, 53, 54, 55, 56, 57, 58, 59, 60, 61, 62, 63, 64, 65, 66, 67, 68, 69, 70, 71, 72, 73, 74, 75, 76, 77, 78, 79, 80, 81, 82, 83, 84, 85, 86, 87, 88, 89, 90, 91, 92, 93, 94, 95, 96, 97, 98, 99, 100]
{% endhighlight %}

Infinityはゼロ除算で取れるので、次のように書いてもいいです。
{% highlight ruby %}
(1..1.0/0).take(10) # => [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]

1.step(1.0/0, 1.5).take(20) # => [1.0, 2.5, 4.0, 5.5, 7.0, 8.5, 10.0, 11.5, 13.0, 14.5, 16.0, 17.5, 19.0, 20.5, 22.0, 23.5, 25.0, 26.5, 28.0, 29.5]
{% endhighlight %}

##45. Enumerable#grep
caseにおける同値判定は再定義可能な`===`でされます。
{% highlight ruby %}
temp = 85
status =
  case temp
  when 1..40;   :low
  when 80..100; :Danger
  else :ok
  end
status # => :Danger

class Trivia
end
t = Trivia.new

klass =
  case t
  when String; 'no good'
  when Array;  'no no'
  when Trivia; 'Yes! Trivia!'
  end
klass # => "Yes! Trivia!"
{% endhighlight %}

例は`Range#===`と`Module#===`による判定です。

実は`Enumerable#grep`におけるパターンマッチも===で判定されるのです。
{% highlight ruby %}
numbers = 5.step(80, 5).to_a # => [5, 10, 15, 20, 25, 30, 35, 40, 45, 50, 55, 60, 65, 70, 75, 80]
numbers.grep(20..50) # => [20, 25, 30, 35, 40, 45, 50]

t1, t2, t3, t4, t5 = 'trivia', Trivia.new, [:trivia], {trivia:1}, Trivia.new

[t1, t2, t3, t4, t5].grep(Trivia) # => [#<Trivia:0x000001008613b0>, #<Trivia:0x000001008610e0>]
{% endhighlight %}

##46. String#gsub
文字列の中に現れる部分文字列の繰り返し回数を数えたい、というときがあります。普通、`String#scan`を使うと思います。
{% highlight ruby %}
DATA.read.scan(/hello/i).count # => 48

__END__
You say "Yes", I say "No".
You say "Stop" and I say "Go, go, go".
Oh no.
You say "Goodbye" and I say "Hello, hello, hello".
I don't know why you say "Goodbye", I say "Hello, hello, hello".
I don't know why you say goodbye, I say hello.
I say "High", you say "Low".
You say "Why?" And I say "I don't know".
Oh no.
You say "Goodbye" and I say "Hello, hello, hello".
I don't know why you say "Goodbye", I say "Hello, hello, hello".
(Hello, goodbye, hello, goodbye. Hello, goodbye.)
I don't know why you say "Goodbye", I say "Hello".
(Hello, goodbye, hello, goodbye. Hello, goodbye. Hello, goodbye.)
Why, why, why, why, why, why, do you
Say "Goodbye, goodbye, bye, bye".
Oh no.
You say "Goodbye" and I say "Hello, hello, hello".
I don't know why you say "Goodbye", I say "Hello, hello, hello".
I don't know why you say "Goodbye", I say "Hello".
You say "Yes", I say "No".
(I say "Yes", but I may mean "No").
You say "Stop", I say "Go, go, go".
(I can stay still it's time to go).
Oh, oh no.
You say "Goodbye" and I say "Hello, hello, hello".
I don't know why you say "Goodbye", I say "Hello, hello, hello".
I don't know why you say "Goodbye", I say "Hello, hello, hello".
I don't know why you say "Goodbye", I say "Hello-wow, oh. Hello".
Hela, heba, helloa. Hela, heba, helloa. Hela, heba, helloa.
Hela, heba, helloa. (Hela.) Hela, heba, helloa. Hela, heba, helloa.
Hela, heba, helloa. Hela, heba, helloa. Hela, heba, helloa.
{% endhighlight %}
いい歌詞ですね。

しかし`String#gsub`はブロックを渡さないとEnumeratorを返すから、同じことができます。
{% highlight ruby %}
DATA.read.gsub(/hello/i).count # => 48

__END__
You say "Yes", I say "No".
You say "Stop" and I say "Go, go, go".
Oh no.
You say "Goodbye" and I say "Hello, hello, hello".
....
{% endhighlight %}


##47. クラスメソッド定義 
クラスやモジュールのメソッドを定義するときは、普通次のようにします。
{% highlight ruby %}
class Calc
  class << self
    def >>(exp)
      eval exp
    end
  end
end

Calc >> '1 + 2' # => 3
Calc >> '10 ** 2' # => 100
{% endhighlight %}

外側のクラス定義を`Class.new`や`Module.new`で行えば、次のような書き方もできます。
{% highlight ruby %}
class << Calc = Class.new
  def >>(exp)
    eval exp
  end
end

Calc >> '123 / 4.0' # => 30.75
Calc >> '2 * Math::PI' # => 6.283185307179586
{% endhighlight %}

このネタは大したことありませんが、`Calc.>>`ってメソッド名、irb風で良くないですか？

##48. true, false, nil
Rubyが取り扱うデータはすべてオブジェクトで、Rubyの世界では数字も、クラスも、そして`true`, `false`, `nil`もすべてオブジェクトってことは知っていると思います。よって当然、これらはメソッドを持っていて、後からメソッドを追加することもできるのです。
{% highlight ruby %}
def true.true?
  'Beleive me. you are true.'
end

def false.true?
  'I said, you are false!'
end

my_point, your_point = 87, 35
border = 60
my_result = my_point > border
your_result = your_point > border

my_result # => true
my_result.true? # => "Beleive me. you are true."
your_result # => false
your_result.true? # => "I said, you are false!"
{% endhighlight %}

`nil`にもメソッド定義してみます。`===`メソッドを定義してcaseで使ってみます。
{% highlight ruby %}
def nil.===(other)
  other.nil? || other.empty?
end

def proceed(obj)
  Array(obj).join.split(//).join('*')
end

full = "I'm full."
empty = ""
_nil_ = nil

objects = [full, empty, _nil_, %w(I am full), [], {:hello => 'world'}, {}]

for obj in objects
  case obj
  when nil
    puts "Stop it! `#{obj.inspect}` is empty or nil."
  else
    puts proceed obj
  end
end
# >> I*'*m* *f*u*l*l*.
# >> Stop it! `""` is empty or nil.
# >> Stop it! `nil` is empty or nil.
# >> I*a*m*f*u*l*l
# >> Stop it! `[]` is empty or nil.
# >> h*e*l*l*o*w*o*r*l*d
# >> Stop it! `{}` is empty or nil.
{% endhighlight %}
凝り過ぎました。


##49. 強制型変換coerce
数値のリストをn倍したらその要素がn倍されるようなオブジェクトが欲しいとします。Arrayを継承したNumListでこれを実現しましょう。

{% highlight ruby %}
class NumList < Array
  def *(n)
    map { |e| e * n }
  end
end

numlist = NumList[1, 2, 3]

numlist * 3 # => [3, 6, 9]
{% endhighlight %}

欲がでて、数値を前に置いた場合でも動くようにしたいと考えます。

{% highlight ruby %}
3 * numlist # => 
# ~> -:15:in `*': NumList can't be coerced into Fixnum (TypeError)
# ~> 	from -:15:in `<main>'
{% endhighlight %}

当然`Fixnum#*`は引数としてNumListオブジェクトを受けられないので、エラーが出ます。Fixnum#*を弄るなんてまさかできません。どうしましょう。

こんなときは`coerce`（強制型変換）が使えます。
{% highlight ruby %}
class NumList < Array
  def *(n)
    map { |e| e * n }
  end

  def coerce(n)
    [self, n]
  end
end

numlist = NumList[1, 2, 3]

numlist * 3 # => [3, 6, 9]
3 * numlist # => [3, 6, 9]
{% endhighlight %}
Fixnum#*は引数が型変換できないときはそのオブジェクトのcoerceメソッドを呼ぶので、そこに望む処理を書きます。


##50. DATA.rewind
DATAは\_\_END\_\_以降をFileとしたオブジェクトです。よってrewindメソッドが使えますが、これは\_\_END\_\_の最初の行に戻るのではなくてファイルのトップに戻るのです。したがってこれを使えば、なんちゃってQuineができるのです。
{% highlight ruby %}
#!/usr/bin/env ruby
require "g"
def evaluate(str)
  op = %w(\+ \* \/)
  digit = /-*\d+/
  if m = str.match(/(#{op})\s+(#{digit})\s+(#{digit})/)
    op, a, b = m.captures
    inner = a.to_i.send(op, b.to_i)
    str = m.pre_match + inner.to_s + m.post_match
    evaluate(str)
  else
    str
  end
end
g evaluate("+ * 3 4 5")
DATA.rewind
puts DATA.to_a
__END__
{% endhighlight %}
このコードを実行すると、evaluateの結果がgrowl出力されると共に、このコード自身が標準出力されます。
##51. Rubyのキーワード 
Rubyのキーワードは予約語ではないので、それが明示的な文脈で使われる限り、メソッド名などにも使えます。ここでは`case`, `if`, `for`をTriviaクラスに定義してみます。
{% highlight ruby %}
class Trivia
  def case(klass)
    case self
    when klass; 'You are my sunshine.'
    else 'No, you are Alien for me'
    end
  end

  def if(bool, arg)
    if bool
      yield arg
    else
      arg.reverse
    end
  end
  
  def for(list)
    list.map { |e| yield e }
  end
end

t = Trivia.new

t.case(Trivia) # => "You are my sunshine."
t.case(Array) # => "No, you are Alien for me"

t.if(true, 'my name is charlie') { |str| str.upcase } # => "MY NAME IS CHARLIE"
t.if(false, 'my name is charlie') { |str| str.upcase } # => "eilrahc si eman ym"

t.for([*1..10]) { |i| i**2 } # => [1, 4, 9, 16, 25, 36, 49, 64, 81, 100]
{% endhighlight %}

##52. YAMLタグ指定
ユーザデータなどのプログラムに書き込みたくないデータをRubyで扱うには、`yamlライブラリ`が便利です。
{% highlight ruby %}
require "yaml"

langs_array = YAML.load(DATA)
puts langs_array.map { |lang| "My favorite language is " + lang }

# >> My favorite language is Ruby
# >> My favorite language is Lisp
# >> My favorite language is C++

__END__
---
- Ruby
- Lisp
- C++
{% endhighlight %}
ここで`!ruby/`ではじまるタグを使えば、その文字列に対するクラス指定ができますが、`!ruby/object:<クラス名>`というタグを使えば、独自クラスの指定もできるのです。LanguageクラスのオブジェクトとしてYAMLデータを読みだしてみます。

{% highlight ruby %}
 require "yaml"
 class Language
   attr_accessor :name, :born, :designer
   def profile
     [name, born, designer] * '-'
   end
 end
 
 members = YAML.load(DATA)
 
 puts members.map { |member| member.profile }
 
 # >> Ruby-1993-Yukihiro Matsumoto
 # >> Lisp-1958-Joh McCarthy
 # >> C++-1983-Bjarne Stroustrup
 
 __END__
 --- 
 - !ruby/object:Language
   name: Ruby
   born: 1993
   designer: Yukihiro Matsumoto
 - !ruby/object:Language
   name: Lisp
   born: 1958
   designer: Joh McCarthy
 - !ruby/object:Language
   name: C++
   born: 1983
   designer: Bjarne Stroustrup
{% endhighlight %}

##53. 単項演算子 ~ (チルダ)
単項演算子`~`は実はメソッドですが、これはどこで定義されているか知ってますか？そう、`Fixnum`と`Bignum`でNOT演算をするために用意されているのです。
{% highlight ruby %}
~1 # => -2
~2 # => -3
~3 # => -4
~7 # => -8

1.to_s(2) # => "1"
2.to_s(2) # => "10"
3.to_s(2) # => "11"
7.to_s(2) # => "111"

(~1).to_s(2) # => "-10"
(~2).to_s(2) # => "-11"
(~3).to_s(2) # => "-100"
(~7).to_s(2) # => "-1000"
{% endhighlight %}

また、`Regexp`にも定義されています。これはgetsからの入力を受ける変数`$_`とのパターンマッチをするためのものです。
{% highlight ruby %}
$_ = 'Ruby is a dynamic, open source programming language with a focus on simplicity and productivity.'

pos = ~ /\w{8,}/
puts "8+long-word `#{$&}` appeared at #{pos}"

# >> 8+long-word `programming` appeared at 31
{% endhighlight %}

単項演算子がユニークなのは、レシーバーがメソッドの後ろに来る点です。こんなユニークで使い勝手のいいメソッドはどんどん定義するべきですね。結合強度も強いのでメソッドチェーン上も問題ありません。
{% highlight ruby %}
class String
  def ~
    reverse
  end
end

class Symbol
  def ~
    swapcase
  end
end

class Array
  def ~
    reverse
  end
end

class Hash
  def ~
    invert
  end
end

~'よるなくたにし なんてしつけいい' # => "いいけつしてんな しにたくなるよ"

s = 'godtoh'
~s.swapcase # => "HOTDOG"

~:Hello # => :hELLO

~[1,2,3,4] # => [4, 3, 2, 1]

~{ruby: 1, lisp: 2} # => {1=>:ruby, 2=>:lisp}
{% endhighlight %}

まあ確かに、`~(にょろ)`だけじゃ、メソッドの意図がわかりづらいですが。

##54. マルチバイトメソッド
1.9からメソッド名などにマルチバイト文字を使えるようになりましたが、あまり活用事例を見ません。それではRubyが可哀想なので、ここで例を示して布教します。
{% highlight ruby %}
class String
  def ©(name='anonymous')
    self + " - Copyright © #{name} #{Time.now.year} All rights reserved. -"
  end

  def 
    self + ' - Designed by Apple in California -'
  end
end

'this is my work'.©(:Charlie) # => "this is my work - Copyright © Charlie 2012 All rights reserved. -"

poetry = <<EOS
Ruby is not a Gem
Gem is not a Jam
Jam is not a Jelly
Jam is about Traffic
Gem is about Library
Ruby is about Language!
EOS

puts poetry.©

# >> Ruby is not a Gem
# >> Gem is not a Jam
# >> Jam is not a Jelly
# >> Jam is about Traffic
# >> Gem is about Library
# >> Ruby is about Language!
# >>  - Copyright © anonymous 2012 All rights reserved. -

'hello, apple'. # => "hello, apple - Designed by Apple in California -"
{% endhighlight %}
``はMacのkeyboardだと`~$k`(Option+Shift+k)を押します。

`Numeric`には通貨メソッドを追加してみます。ここでは`def_method`というメソッド定義メソッドを作って、クラスをオープンする手間を省きます。
{% highlight ruby %}
def def_method(name, klass=self.class, &body)
  blk = block_given? ? body : ->{ "#{name}: not implemented yet." }
  klass.class_eval { define_method("#{name}", blk) }
end

currencies = %w(¥ € £ $).zip [:JPY, :EUR, :GBP, :USD]
currencies.each do |cur, sym|
  def_method(cur, Numeric) do
    int, dec = Exchange(self, sym).to_s.split('.')
    dec = dec ? ".#{dec[/.{1,2}/]}" : ''
    cur + int.reverse.scan(/.{1,3}/).join(',').reverse + dec
  end
end

def Exchange(num, _for_)
  num * {USD:1.0, JPY:81.3, EUR:0.76, GBP:0.62}[_for_]
end

123.45.¥ # => "¥10,036.48"
1000000.¥ # => "¥81,300,000.0"
123.€ # => "€93.48"
1000000.€ # => "€760,000.0"
123.45.£ # => "£76.53"
1000000.£ # => "£620,000.0"
{% endhighlight %}

まあ入力が難ですが..


##55. 秘伝メソッド
上で見たようにRubyではキーワードや記号文字をメソッド名に使えますが、使えないものもあります。例えば、`.`, `,`, `@`, `=`, `(`, `#`, `$` などはメソッド名には使えませんよね。
{% highlight ruby %}
def .
end
# ~> -:1: syntax error, unexpected '.'

def ,
end
# ~> -:1: syntax error, unexpected ','

def @
end
# ~> -:1: syntax error, unexpected $undefined

def =
end
# ~> -:1: syntax error, unexpected '='

def (
end
# ~> -:2: syntax error, unexpected keyword_end

def #
end
# ~> -:4: syntax error, unexpected $end

def $
end
# ~> -:1: syntax error, unexpected $undefined
{% endhighlight %}

と、普通思いますよね。ところが、実はこれらも`define_method`を使えば、定義できるのです。先のdef_methodを使ってこれらのメソッドを定義してみます。
{% highlight ruby %}
def def_method(name, klass=self.class, &body)
  blk = block_given? ? body : ->{ "#{name}: not implemented yet." }
  klass.class_eval { define_method("#{name}", blk) }
end

class Trivia
  
end

methods = [".", ",", "@", "=", "(", "#", "$"]
methods.each { |meth| def_method meth, Trivia }

Trivia.public_instance_methods(false) # => [:".", :",", :"@", :"=", :"(", :"#", :"$"]
{% endhighlight %}

ね？

ただ、これらのメソッドにはひとつだけ問題があります..

それは...

呼び出しができないのです！ ^ ^;

{% highlight ruby %}

t = Trivia.new

t.. # => 
t., # => 
t.@ # => 
t.= # => 
t.( # => 
t.# # => 
t.$ # => 

# ~> -:42: syntax error, unexpected ')'
# ~> ...1335430361_15646_549583 = (t..);$stderr.puts("!XMP1335430361...
# ~> ...                               ^
# ~> -:43: syntax error, unexpected ','
# ~> ..._1335430361_15646_549583 = (t.,);$stderr.puts("!XMP133543036...
# ~> ...                               ^
# ~> -:44: syntax error, unexpected $undefined
# ~> ..._1335430361_15646_549583 = (t.@);$stderr.puts("!XMP133543036...
# ~> ...                               ^
# ~> -:45: syntax error, unexpected '='
# ~> ..._1335430361_15646_549583 = (t.=);$stderr.puts("!XMP133543036...
# ~> ...                               ^
# ~> -:48: syntax error, unexpected $undefined
# ~> ..._1335430361_15646_549583 = (t.$);$stderr.puts("!XMP133543036...
# ~> ...                               ^
# ~> -:65: syntax error, unexpected $end, expecting ')'
{% endhighlight %}

ただ、`Object#send`や`Method#call`を使って呼び出す、という手段はあります。
{% highlight ruby %}
t = Trivia.new

t.send '.' # => ".: not implemented yet."
t.method(',').call # => ",: not implemented yet."

def_method('@', Trivia) do |num|
  "#{self.class}".center(num, '@')
end

def_method('(', Trivia) do |str|
  "( #{str} )"
end

t.send '@', 12 # => "@@@Trivia@@@"
t.send '(', 'I love Ruby'  # => "( I love Ruby )"
{% endhighlight %}
つまり、これらの記号文字メソッドは、通常の方法では定義も呼び出しもできないが、通常でない特殊な方法を使えば定義も呼び出しもできる、特殊なメソッド群と言えます。僕はこれらのメソッド群を、特殊な方法で隠されたメソッド、つまり`秘伝(hidden)`メソッドと名付けました。使い道は...なさそうです..ね..


以上、Rubyにおける55個のトリビアを駆け足で紹介しました。新しい発見はありましたか？口元は緩みましたか？

---

<a href="{{ BASE_PATH }}/books/">
  <img src="/assets/images/2013/03/ruby_trivia_cover.png" alt="trivia" style="width:200px" />
</a>

<a href="http://gum.co/owIqH" class="gumroad-button">電子書籍「知って得する！５５のRubyのトリビアな記法」EPUB/MOBI版</a><script type="text/javascript" src="https://gumroad.com/js/gumroad-button.js"></script><script type="text/javascript" src="https://gumroad.com/js/gumroad.js"></script>

このリンクはGumroadにおける商品購入リンクになっています。クリックすると、オーバーレイ・ウインドウが立ち上がって、この場でクレジットカード決済による購入が可能です。購入にはクレジット情報およびメールアドレスの入力が必要になります。購入すると、入力したメールアドレスにコンテンツのDLリンクが送られてきます。

---

<p style='color:red'>=== Ruby関連電子書籍100円で好評発売中！ ===</p>

[M'ELBORNE BOOKS]({{ site.url }}/books/ "M'ELBORNE BOOKS")

<a href="{{ BASE_PATH }}/books/">
  <img src="/assets/images/2012/start_ruby.jpg" alt="start_ruby" style="width:200px" />
</a>
<a href="{{ BASE_PATH }}/books/">
  <img src="/assets/images/2013/02/ruby_object_cover.png" alt="ruby_object" style="width:200px" />
</a>
<a href="{{ BASE_PATH }}/books/">
  <img src="/assets/images/2012/rack_cover.png" alt="rack" style="width:200px" />
</a>

