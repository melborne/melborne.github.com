---
layout: post
title: "メソッドの使い方もRubyに教えてほしい"
description: ""
category: 
tags: 
date: 2013-09-04
published: true
---
{% include JB/setup %}


Rubyの世界には**「RubyのことはRubyに聞け」**という格言があります{% fn_ref 1 %}。

この格言に従い、早速Arrayクラスがどんなメソッドを持っているかRubyに聞いてみます。`irb`を使います。

{% highlight ruby %}
% irb
irb> Array.instance_methods(false)
=> [:inspect, :to_s, :to_a, :to_ary, :frozen?, :==, :eql?, :hash, :[], :[]=, :at, :fetch, :first, :last, :concat, :<<, :push, :pop, :shift, :unshift, :insert, :each, :each_index, :reverse_each, :length, :size, :empty?, :find_index, :index, :rindex, :join, :reverse, :reverse!, :rotate, :rotate!, :sort, :sort!, :sort_by!, :collect, :collect!, :map, :map!, :select, :select!, :keep_if, :values_at, :delete, :delete_at, :delete_if, :reject, :reject!, :zip, :transpose, :replace, :clear, :fill, :include?, :<=>, :slice, :slice!, :assoc, :rassoc, :+, :*, :-, :&, :|, :uniq, :uniq!, :compact, :compact!, :flatten, :flatten!, :count, :shuffle!, :shuffle, :sample, :cycle, :permutation, :combination, :repeated_permutation, :repeated_combination, :product, :take, :take_while, :drop, :drop_while, :bsearch, :pack, :abbrev]

irb> Array.methods(false)
=> [:[], :try_convert]
{% endhighlight %}

> 参考：[Rubyのメソッドを数えましょう♫]({{ site.url }}/2013/08/27/count-methods-of-ruby/ "Rubyのメソッドを数えましょう♫")


さて、ここで特定のメソッドの使い方を知りたいとします。そんなときはirbで`help`と打ちます（まあ、やり方はいろいろありますが..）。

メッセージのあと入力プロンプトが現れるので、知りたいメソッドを入力します。お気に入りの`Array#unshift`を調べてみます :-) 

{% highlight ruby %}
irb> help

Enter the method name you want to look up.
You can use tab to autocomplete.
Enter a blank line to exit.

>> Array#unshift
{% endhighlight %}

リターンで以下の説明が出力されます。


{% highlight ruby %}
= Array#unshift

(from ruby core)
------------------------------------------------------------------------------
  ary.unshift(obj, ...)  -> ary

------------------------------------------------------------------------------

Prepends objects to the front of self, moving other elements upwards. See also
Array#shift for the opposite effect.

  a = [ "b", "c", "d" ]
  a.unshift("a")   #=> ["a", "b", "c", "d"]
  a.unshift(1, 2)  #=> [ 1, 2, "a", "b", "c", "d"]
{% endhighlight %}

なるほどなるほど。


<br />


## Googleクラスを調べる

今ここに、**Google Inc.**をシミュレートできる`Googleクラス`があるとします。

{% highlight ruby %}
# This class is a wrapper of Google Inc.
class Google
  # Returns the stock price of Google Inc.
  # param: time
  def self.price(time=Time.now)
    WWW::GOOGLE::Finance.new(:GOOG).price(time)
  end
  
  # Initialize object with locale and account
  def initialize(locale, account)
    @locale = locale
    @account = account
  end

  # Search the word with google.
  # 
  # param: word in string
  # return: array of search results 
  #
  def search(word)
    WWW::GOOGLE::SEARCH.get(word, @locale)
  end
  
  # Send a mail with gmail.
  # 
  # param: to, what, from
  # return: true or false
  #
  def gmail(to, what, from=@account)
    WWW::GOOGLE::GMAIL.new(from).send(to, what)
  end
end
{% endhighlight %}

Arrayの場合と同様に、Googleクラスがどんなメソッドを持っているかRubyに聞いてみます。

{% highlight ruby %}
% irb -r'./google'
irb> Google.instance_methods(false)
=> [:search, :gmail]
irb> Google.methods(false)
=> [:price]
{% endhighlight %}

Googleクラスに定義したメソッド群がリストアップされました。

さて、次にメソッドの使い方を見てみます。helpして、`Google#search`を調べます。

{% highlight bash %}
irb> help

Enter the method name you want to look up.
You can use tab to autocomplete.
Enter a blank line to exit.

>> Google#search
RDoc::RI::Driver::NotFoundError: Google
{% endhighlight %}

残念ながら、`RDoc::RI::Driver::NotFoundError: Google`というエラーが出力されました。つまり、解説が見当たらないということです。

折角、コードにコメント付けたのに...


## ドキュメント生成ツール

暫しの調査の結果、コードに付けたコメントをドキュメント化するには、[RDoc](http://rdoc.rubyforge.org/ "rdoc-4.0.0 Documentation")や[YARD](http://yardoc.org/ "YARD - A Ruby Documentation Tool")といったドキュメント生成ツールが必要なことが分かりました。

早速、RDocに付随する`rdoc`コマンドを使って`Googleクラス`をドキュメント化します。

{% highlight bash %}
% rdoc --ri google.rb
Parsing sources...
100% [ 1/ 1]  google.rb

Generating RI format into /Users/keyes/.rdoc...

Files:      1

Classes:    1 (0 undocumented)
Modules:    0 (0 undocumented)
Constants:  0 (0 undocumented)
Attributes: 0 (0 undocumented)
Methods:    4 (0 undocumented)

Total:      5 (0 undocumented)
100.00% documented

Elapsed: 0.0s
{% endhighlight %}

もう一度、irbを立ち上げてhelpしてみます。

{% highlight bash %}
% irb -r'./google'
irb> help

Enter the method name you want to look up.
You can use tab to autocomplete.
Enter a blank line to exit.

>> Google
{% endhighlight %}

出力です。

{% highlight bash %}
= Google < Object

(from ~/.rdoc)
------------------------------------------------------------------------------
This class is a wrapper of Google Inc.
------------------------------------------------------------------------------
= Class methods:

  new, price

= Instance methods:

  gmail, search
{% endhighlight %}


`Google#search`も調べてみます。

{% highlight bash %}
= Google#search

(from ~/.rdoc)
------------------------------------------------------------------------------
  search(word)

------------------------------------------------------------------------------

Search the word with google.

param: word in string return: array of search results
{% endhighlight %}

コードに付けたコメントが今度は出力されました。

（前置きが長い）

<br/>

##メソッドの使い方もRubyに教えてほしい


しかしこのことは言い換えれば、これらの解説はRubyが出力しているのではなく、RDocないしはriというツールが生成・出力していることに他なりません。

先の格言を深く信じてきた自分としては、ちょっと裏切られたような気分です{% fn_ref 2 %}。

できれば、メソッドの使い方もRubyに教えてもらいたかった...。

<br/>

そんなわけで...

<br/>

コード中のコメントをRubyが出力できるようにするモジュールを作りましたよ！

（ネタと了解した上で先にお進み下さい...。）


##Dochoodモジュールの使い方

Googleクラスを例に取ります。先のコードを次のように修正します。

{% gist 6434147 google.rb %}

説明します。

`Dochood`モジュールをrequireして（①）、extendします（③）。クラスの解説は`@class_des`変数にセットします（②）。これはモジュールをextendする前に配置する必要があります。

メソッド説明文の前には`_`（アンダーバー）を前置します（④）。説明文はクオートする必要があります。ヒアドキュメントを使うこともできます（⑤）。<<の前の`~`（チルダ）は先頭マージンを除去するおまじないです。

このファイルをirbに読み込んで、出力を見てみます。

ドキュメントの呼び出しには`<ClassName>.doc`メソッドを使います。引数にメソッド名をシンボルで渡します。

{% highlight bash %}
% irb -r'./google'
>> Google.instance_methods(false) #=> [:search, :gmail]
>> Google.methods(false) #=> [:price]

>> puts Google.doc(:search) #=> nil
Name: search
Owner: Google
Kind: instance_method

Search the word with google.

param: word in string
return: array of search results


>> puts Google.doc(:gmail) #=> nil
Name: gmail
Owner: Google
Kind: instance_method

Send a mail with gmail.

param: to, what, from
return: true or false


>> puts Google.doc(:price) #=> nil
Name: price
Owner: Google
Kind: singleton_method

Returns the stock price of Google Inc.
param: time
{% endhighlight %}

引数を省略すると全解説を出力します（適当です）。

{% highlight bash %}
>> puts Google.doc
Name: Google
Owner: Google
Kind: Class

This class is a wrapper of Google Inc.


-----------
Name: price
Owner: Google
Kind: singleton_method

Returns the stock price of Google Inc.
param: time

-----------
Name: initialize
Owner: Google
Kind: instance_method

Initialize object with locale and account

-----------
Name: search
Owner: Google
Kind: instance_method

Search the word with google.

param: word in string
return: array of search results


-----------
Name: gmail
Owner: Google
Kind: instance_method

Send a mail with gmail.

param: to, what, from
return: true or false


=> nil
{% endhighlight %}

これでもう、他のツールに頼らずにRubyがメソッドの使い方も出力できるようになりましたね。

<br />



## Inside Dochood

ここまできて、「なんかどっかで似たようなの見たことあるな...」と思ったあなた...。

「スルドイ！」

これは、「[Thor(command-line interface builder)](http://whatisthor.com/ "Thor - Home")」の<del>パクリ</del>実装にヒントを得て作ったのです。

`Dochood`モジュールの実装です。

{% gist 6434147 dochood.rb %}

`extended`, `method_added`, `singleton_method_added`の各フックメソッドを使って、@descにセットされたコメント分を`Dochood`オブジェクト化して管理しています。


Thorの実装が面白いと思ったので、まあネタで作ってみました。それにしても`@class_desc`がイケてない...。



---

<p style='color:red'>=== Ruby関連電子書籍100円で好評発売中！ ===</p>

[M'ELBORNE BOOKS]({{ BASE_PATH }}/books/ "M'ELBORNE BOOKS")

<a href="{{ BASE_PATH }}/books/">
  <img src="/assets/images/2013/03/ruby_trivia_cover.png" alt="ruby_trivia" style="width:200px" />
</a>
<a href="{{ BASE_PATH }}/books/">
  <img src="/assets/images/2012/ruby_parallel_cover.png" alt="ruby_parallel" style="width:200px" />
</a>
<a href="{{ BASE_PATH }}/books/">
  <img src="/assets/images/2012/rack_cover.png" alt="rack" style="width:200px" />
</a>


{% footnotes %}
{% fn 嘘です %}
{% fn まさか！ %}
{% endfootnotes %}


