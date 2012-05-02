---
layout: post
title: 知って得する21のRubyのトリビアな記法
tagline: 21 Trivia Notations you should know in Ruby
date: 2011-06-22
comments: true
categories:
tags: [ruby, tips]
---

ちょっとトリビアだけど、知っていると意外と便利なRubyの記法を21個拾ってみたよ(Ruby1.9限定)。

君なら全部知ってるかもしれないけど..

##1. 動的継承
Rubyのクラス継承では < 記号の右辺にクラス定数だけでなくクラスを返す式が書けるよ。
{% highlight ruby %}
 class Male
  def laugh; 'Ha ha ha!' end
 end
 class Female
  def laugh; 'Fu fu fu..' end
 end
 class Me < [Male, Female][rand 2]
 end
 Me.superclass # => Female
 Me.new.laugh # => 'Fu fu fu..'
{% endhighlight %}
{% highlight ruby %}
 def io(env=:development)
   env==:test ? StringIO : IO
 end
 env = :test
 class MyIO < io(env)
 end
 MyIO.superclass #=> StringIO
{% endhighlight %}
つまりRubyでは条件に応じて継承するクラスを動的に変えることができるんだよ。
##2. 大文字メソッド
Rubyでは通常メソッド名には英小文字を使うけど、英大文字も許容されてるんだよ。大文字メソッドは一見定数に見えるよね。
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
定数は継承サブクラスで参照されるけど、これを非公開にしたいこともあるよね。そんなときには大文字メソッドがいいかもね。

引数がないときでもカッコを省略できないという欠点があるけど、関連する複数の定数を定義するときなんかも便利に使えるよ。
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
僕は「定数メソッド」って呼んでるんだけど、どうかな？
##3. メソッド引数のスペース
Rubyで引数付きメソッドを呼ぶときそのカッコを省略できるけど、引数がシンボルであればさらに、メソッド名との間のスペースも省略できるよ。
{% highlight ruby %}
 def name(sym)
   @name = sym
 end
 name:charlie # => :charlie
{% endhighlight %}
こうするとより宣言的に見えるよね。

また* &の後ろのスペースは無視されるから、次のような書き方ができるよ。
{% highlight ruby %}
 def teach_me(question, * args, & block)
   google(question, * args, & block)
 end
 a, b, * c = 1,2,3,4
 c # => [3,4]
{% endhighlight %}
だからどうしたって話だけど...
##4. 関数部分適用
似たようなメソッドを複数書くことはDRY原則に反するよね。Proc#curryを使えばこれを回避できるかもね。四季判定関数の例を示すね。
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
こうなると変数名に ? が使えるとうれしいんだけどなあ。
##5. Procによるcase判定
Procの実行はcallメソッドを呼ぶことで実現できるけど、Proc#===はその別名になってるんだよ。先の四季判定関数をcase式で使う例で使い方を見るね。
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
引数の受け渡しが暗黙的に行われるので、case式が非常にすっきりするよね。
##6. Structクラス
属性主体のクラスを生成するときにはStructが便利だよね。
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
 charlie.length_of_life('2011/6/22') # => 3
{% endhighlight %}

実はStruct.newはブロックを取れるから、下のような書き方もできるんだよ。
{% highlight ruby %}
 Person = Struct.new(:name, :age, :occupation) do
   def length_of_life(date)
     (Fortune::Teller.ask(name, age, occupation) - Date.parse(date)).to_i
   end
 end
 charlie = Person.new('charlie', 13, :programmer)
 charlie.length_of_life('2011/6/22') # => 3
{% endhighlight %}
##7. retryと引数デフォルト
rescue節ではretryを使うことによって、そのブロックの処理を再実行させることができるよね。これをメソッド引数のデフォルト値と組み合わせることで、便利に使えるときがあるんだ。
{% highlight ruby %}
 require "date"
 def last_date(date, last=[28,29,30,31])
   d = Date.parse date
   Date.new(d.year, d.mon, last.pop).day rescue retry
 end
 
 last_date '2010/6/1' # => 30
 last_date '2010/2/20' # => 28
 last_date '2008/2' # => 29
{% endhighlight %}
この例では31日からDateオブジェクトの生成を試して、例外が発生するとretryにより次の日付を試していく。

まあ上のはこれでいいんだけど...
{% highlight ruby %}
 Date.new(2009,2,-1).day # => 28
{% endhighlight %}
##8. 否定
否定に使われる ! あるいは not が好きじゃない人いる？ならBasicObject#!があるよ！
{% highlight ruby %}
 true.! # => false
 false.! # => true
 1.! # => false
 'hello'.!.! # => true
{% endhighlight %}
...

次に行きます..
##9. ％ノーテーション
String#%を使うことで文字列に指定フォーマットでオブジェクトを埋め込めるけど、%は配列を受け取れるんだ。
{% highlight ruby %}
 lang = [:ruby, :java]
 "I love %s, not %s" % lang # => "I love ruby, not java"
{% endhighlight %}

それだけじゃなくて実はハッシュも取れるんだよ。
{% highlight ruby %}
 lang = {a: :java, b: :ruby}
 "I love %{b}, not %{a}" % lang # => "I love ruby, not java"
{% endhighlight %}
##10. 文字列区切り
文字列を各文字に区切るには、String#splitかString#charsが使えるよね。
{% highlight ruby %}
 alpha = "abcdefghijklmnopqrstuvwxyz"
 alpha.split(//) # => ["a", "b", "c", "d", "e", "f", "g", "h", "i", "j", "k", "l", "m", "n", "o", "p", "q", "r", "s", "t", "u", "v", "w", "x", "y", "z"]
 
 alpha.chars.to_a # => ["a", "b", "c", "d", "e", "f", "g", "h", "i", "j", "k", "l", "m", "n", "o", "p", "q", "r", "s", "t", "u", "v", "w", "x", "y", "z"]
{% endhighlight %}

でも文字列を複数文字単位で区切るにはString#scanが便利だよ。
{% highlight ruby %}
 alpha.scan(/.../) # => ["abc", "def", "ghi", "jkl", "mno", "pqr", "stu", "vwx"]
 alpha.scan(/.{1,3}/) # => ["abc", "def", "ghi", "jkl", "mno", "pqr", "stu", "vwx", "yz"]
 
 number = '12345678'
 def number.comma_value
   reverse.scan(/.{1,3}/).join(',').reverse
 end
 number.comma_value # => "12,345,678"
{% endhighlight %}
##11. Array#*
Array#*に整数を渡すとそれを繰り返した新たな配列を返すけど、文字列を渡すとそれをセパレータとした連結文字列を返すjoinの役割を果たすよ。
{% highlight ruby %}
 [1, 2, 3] * 3 # => [1, 2, 3, 1, 2, 3, 1, 2, 3]
 
 [2009, 1, 10] * '-' # => "2009-1-10"
{% endhighlight %}
##12. Arrayスタック系メソッド
Array#<<は一つのオブジェクトしか引数に取れないんだけど、Array#pushは複数取れるんだ。またArray#popは一度に複数の値をポップできる。Array#unshift Array#shiftも同じだよ。
{% highlight ruby %}
 stack = []
 stack.push 1, 2, 3 # => [1, 2, 3]
 stack.pop 2 # => [2, 3]
 stack # => [1]
 stack.unshift 4, 5, 6 # => [4, 5, 6, 1]
 stack.shift 3 # => [4, 5, 6]
 stack # => [1]
{% endhighlight %}

また任意位置の複数の値を取り出す場合は、Array#values_atが便利だよ。
{% highlight ruby %}
 lang = %w(ruby python perl haskell lisp scala)
 lang.values_at 0, 2, 5 # => ["ruby", "perl", "scala"]
{% endhighlight %}
##13. Array#uniq
配列から重複した値を取り除くときはArray#uniqを使うけど、uniqはブロックを取れるからそこで重複の条件を指定できるんだ。
{% highlight ruby %}
 Designer = Struct.new(:name, :lang)
 data = {'matz' => :ruby, 'kay' => :smalltalk, 'gosling' => :java, 'dhh' => :ruby}
 designers = data.to_a.map { |name, lang| Designer[name, lang] }
 
 designers.uniq.map(&:name) # => ["matz", "kay", "gosling", "dhh"]
 designers.uniq{ |d| d.lang }.map(&:name) # => ["matz", "kay", "gosling"]
{% endhighlight %}
##14. Kernel#Array
異なる型の引数を統一的に処理するときにはKernel#Arrayが便利だよ。
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
##15. 文字列リスト%w
文字列のリストを作るときには%ｗリテラルが便利だけど、文字列が空白文字を含むときはバックスラッシュでエスケープすればいいよ。
{% highlight ruby %}
 designers = %w(John\ McCarthy Yukihiro\ Matsumoto Larry\ Wall Alan\ Kay Martin\ Odersky)
 designers # => ["John McCarthy", "Yukihiro Matsumoto", "Larry Wall", "Alan Kay", "Martin Odersky"]
{% endhighlight %}
##16. 要素区切りコンマ
配列とハッシュの各要素の区切りにはコンマが使われるけど、最後の要素のカンマは無視されるんだよ。
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
要素を頻繁に追加・削除したり、ファイルからevalするときなどにいいかもね。
##17. ハッシュリテラル
Ruby1.9ではハッシュの新しい記法が導入されたけど、これは古い記法と混在できるんだ。
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
##18. Enumerable#each_with_object
Enumerable#injectは便利なメソッドだけど、ブロック内で条件指定をするような場合でも各イテレーションで畳込みオブジェクトが返されることを保証しなければならないよ。
{% highlight ruby %}
 designers.inject([]) { |mem, (lang, name)| mem << [name,lang]*'/' if lang[/l/]; mem }
  # => ["John McCarthy/lisp", "Larry Wall/perl", "Alan Kay/smalltalk", "Martin Odersky/scala"]
{% endhighlight %}
ブロックの最後の「; mem」の部分だよ。

Enumerable#each_with_objectならその手間は要らないよ。
{% highlight ruby %}
 designers.each_with_object([]) { |(lang, name), mem| mem << [name,lang]*'/' if lang[/l/] }
  # => ["John McCarthy/lisp", "Larry Wall/perl", "Alan Kay/smalltalk", "Martin Odersky/scala"]
{% endhighlight %}
名前が長いからどうしても避けちゃうけどね..reduceにマッピングしてくれたらうれしいなあ。
##19. Kernel#loop
無限の繰り返しはコードのブロックをKernel#loopに渡すことで実現できるよね。
{% highlight ruby %}
 require "mathn"
 prime = Prime.each
 n = 0
 loop do
   printf "%d " % prime.next
   break if n > 10
   n += 1
 end
 # >> 2 3 5 7 11 13 17 19 23 29 31 37 
{% endhighlight %}

ここでloopにブロックを渡さないとEnumeratorが返るんだよ。これを利用すればloopのインデックスを作ることができるよ{% fn_ref 1 %}。
{% highlight ruby %}
 loop # => #<Enumerator: main:loop>
 
 loop.with_index do |_,n|
   printf "%d " % prime.next
   break if n > 10
 end
 # >> 2 3 5 7 11 13 17 19 23 29 31 37 
{% endhighlight %}
ブロックの第1引数がnilになっちゃうけど..
##20. splat展開
Rubyでアルファベットの配列を作るときなどは通常、以下のようにするよね。
{% highlight ruby %}
 (1..20).to_a # => [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20]
 ('a'..'z').to_a # => ["a", "b", "c", "d", "e", "f", "g", "h", "i", "j", "k", "l", "m", "n", "o", "p", "q", "r", "s", "t", "u", "v", "w", "x", "y", "z"]
 (1..10).to_a + (20..30).to_a # => [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30]
{% endhighlight %}

これは*(splat)展開を使って以下のようにも書けるよ。
{% highlight ruby %}
 [*1..20] # => [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20]
 [*'a'..'m'] # => ["a", "b", "c", "d", "e", "f", "g", "h", "i", "j", "k", "l", "m"]
 [*1..10, *20..30] # => [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30]
{% endhighlight %}
##21. 前置コロン
文字列をシンボルに変換するときは通常、String#internかString#to_symを使うけど、文字列リテラルにコロンを前置することでも可能だよ。
{% highlight ruby %}
 'goodbye'.intern # => :goodbye
 'goodbye'.to_sym # => :goodbye
 
 :'goodbye' # => :goodbye
 
 a = 'goodbye'
 :"#{a}" # => :goodbye
{% endhighlight %}


長かったけどこれで説明を終わるよ。知らないものいくつあった？

よかったら僕にも君のトリビア教えてね！

第２弾を書いたよ!
[第２弾！知って得する12のRubyのトリビアな記法 ~ 12 Trivia Notations you should know in Ruby]({{ site.url }}/2012/02/08/2-12-Ruby-12-Trivia-Notations-you-should-know-in-Ruby/)

(追記：2011-6-26) 21の「文字列にコロンを」を「文字列リテラルにコロンを」に変更しました。
(追記：2011-6-27) 2の「カッコを省略できないという欠点があるけど」を「引数がないときでもカッコを省略できないという欠点があるけど」に変更しました。

(comment)
> カッコを省略できないという欠点があるけど<br>省略できます
> :"aaa" は別のリテラル
>>ujihisaさん<br>コメントありがとう。でも僕の1.9.2p180環境だとuninitialized constantとなってしまうんです。最新版が必要なのかな<br><br>
>>sora_hくん<br>コメントありがとう<br>それは別のシンボルという意味ですか？<br>でも:hello.equal? :'hello' #=> true になるよ

>"aaa bbb"のシンボルを作りたい時に:"aaa bbb"することができるようになっている． 文字列を作る "" リテラルの手前に : をつけるとsymbolのリテラルにはなるが，文字列のオブジェクトの手前に:をつけてもならないよね?<br>:""という別のリテラルがある．リテラルは "String" や 1 (数値)や 'String' や [Array] などの事ね．
>>sora_hくん<br>なるほど確かにそうですね。記述を少し直しました。ありがとう。
>>ujihisaさん<br>あーやっとわかりました。係り受けが曖昧でしたね。記述を直しました。

>-> も curry もその存在を知らずに読んでちょっとビックリ。<br><br>->range,date{...}.curry より<br><br>->range{->date{...}} がわりやすいかなと思いました
>>s-:さん<br>コメントありがとう。あーこの例だとそれでもよいですね。ただcurryは動的に引数の数を変えられるのがいいんですよね- :)


{{ 4873113946 | amazon_medium_image }}
{{ 4873113946 | amazon_link }}


{% footnotes %}
   {% fn @no6v1さんに教えていただきました. http://friendfeed.com/no6v1/0d7a24e4/loop-with_index-_-i-break-if-p-3-qt-merborne %}
{% endfootnotes %}
