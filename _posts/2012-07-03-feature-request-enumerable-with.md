---
layout: post
title: "はじめてのふぃちゃありくえすと〜Ruby編"
description: ""
category: 
tags: [ruby, Enumerable]
date: 2012-07-03
published: true
---
{% include JB/setup %}

Rubyは自分によくフィットする言語ですが{% fn_ref 1 %}、それでももちろん、こんな機能があったらとかあんなメソッドがあったらとかと、思うことは良くあります。で、そんなときはTwitterで「〜ができたらなあ」と小さく呟くか、少しがんばってこのブログの記事にするのですが、それで何かが変わるということはありません。

まあ基本それで不満はありませんが、一方で、仮に自分の欲しいと思っていたものが次のRubyで採用されたとしたら、そのフィット率は83%から84%に上がるということは確実なんです。それならなんでもいいから、とっとと開発サイドにリクエストを出せということになります。

しかし話はそう単純ではありません。なぜなら、僕がRubyの開発サイドにリクエストを出すということは、イコール、**Rubyを作りその歴史と機能を熟知した一級のハッカーたちの前に、素人考えのアイディアを恥も外聞もなく晒す**、ということを意味するからです。しかもRubyコミッタはコミッタ同士でも恐れをなすほど怖いという話まであります。


    今興味をもっているテーマはなんですか？
    遠藤 2.0 のリリース。
    たるい なるほど。
    遠藤 仕事しないリリースマネージャを目指す。怖くないコミッタを心がける。
    一同 (笑)
    遠藤 コミッタには怖い人多いですよね。
    ささだ ねー。
    遠藤 ささださんはその中でもかなり怖くない方で。最近まつもとさんがかなり怖くないですか。
    ささだ 疲れてるんですかね。
    遠藤 ねえ。なかださんも sigh とか書いてたし。
    mrkn モヒカンの集まりですからね。

[Rubyist Magazine - Rubyist Hotlinks 【第 30 回】 遠藤侑介さん](http://jp.rubyist.net/magazine/?0038-Hotlinks 'Rubyist Magazine - Rubyist Hotlinks 【第 30 回】 遠藤侑介さん')より

モヒカン...

まあ、無謀なことは止めておけという話です。

----

そんな折、日本でも[Stack Overflow](http://stackoverflow.com/ 'Stack Overflow')のようなプログラマ向けQ&Aサイト「[QA@IT](http://qa.atmarkit.co.jp/ 'QA@IT')」が始まりました。要望提出に若干の興味を捨て切れない自分は、<del>探りを入れるために、</del>Rubyに要望を出すための手続きについて聞いてみたのです:)

[Rubyの機能について改善要望をしたい場合は？ - QA@IT](http://qa.atmarkit.co.jp/q/2073#answer_14485 'Rubyの機能について改善要望をしたい場合は？ - QA@IT')

    Rubyの機能について改善要望をしたい場合（例えば、Object#blank?がほしいとか）について、次のような質問があります。
       
    1. 要望を出すための公式なまたは標準となっている手続きがあれば知りたい。
    2. そのような手続きがあるとして、要望を出すための最低限のマナーを知りたい。具体的には、初〜中級者による不完全な、つまり単なる願望、過去の経緯に対する無知、実装コードを伴わない要望などは、歓迎されないのかを知りたい。
    3. 過去にあった要望とそれに対する評価（拒絶の理由）を効率的に一覧する方法があれば知りたい。
     以上、よろしくお願いします。

この質問に対しては、複数のコミッタの方から手続きに関する有益な情報を頂きました。一方で、マナーについては、次のような回答を頂きました。

    マナーはよくわかりませんが、愚かさにはその度合いに対応した反応(無視を含む)が返されるでしょう。 実装は必ずしも要求されませんが、ユースケースの提示がないFeatureリクエストはほぼ無条件にrejectされる傾向はあります。

((((；ﾟДﾟ))))ｶﾞｸｶﾞｸﾌﾞﾙﾌﾞﾙ


まあ、愚かな恥さらしは止めておけという話です。

----

ところが、暫くすると別の転機が訪れました。

![matz_tweet]({{ site.url }}/assets/images/matz_tweet.png)

[礼儀正しさ重要（Good Manners Matter 日本語訳）](http://www.yamdas.org/column/technique/GoodMannersMatterj.html '礼儀正しさ重要（Good Manners Matter 日本語訳）')

Matzがリンクしたこの文章は、技術サポートのあり方について書かれたものですが、僕にとってそれは、「愚かさは罪ではない」と教えてくれるものとなりました。そう、**愚かさは罪ではない**。怖がる必要はないよね。みんな年下なんだしさ:)

----

そんなわけで..

やっとの思いで、２件のFeatureリクエストを[Ruby Issue Tracking System](http://bugs.ruby-lang.org/ 'Ruby Issue Tracking System')にポストしてみましたよ！ダメ元で。

> [Feature #6684: Object#do - ruby-trunk - Ruby Issue Tracking System](http://bugs.ruby-lang.org/issues/6684 'Feature #6684: Object#do - ruby-trunk - Ruby Issue Tracking System')
> 
> [Feature #6687: Enumerable#with - ruby-trunk - Ruby Issue Tracking System](http://bugs.ruby-lang.org/issues/6687 'Feature #6687: Enumerable#with - ruby-trunk - Ruby Issue Tracking System')

１件目については、このブログで既に記事を書いているので([Object#doメソッドというのはありですか？](http://melborne.github.com/2012/06/13/objectdo/ 'Object#doメソッドというのはありですか？'))、内容についてはそちらに委ねて、ここには２件目の内容を一部修正して貼っておきます。まあ、通ればうれしいですが、むずかしいでしょうねぇ。

----

##Enumerable#with

`Enumerable#each_with_object`のエイリアス、またはその置き換えとして、`Enumerable#with`を提案します。

##理由

`Enumerable#inject`を使ってハッシュを生成するときには、ブロックの返り値としてハッシュが返ることを保証する必要があります。

{% highlight ruby %}
words.inject(Hash.new(0)) { |h, word| h[word] += 1; h } # => {"You"=>3, "say"=>10, "Yes"=>1, "I"=>7, "No"=>1, "Stop"=>1, "and"=>2, "Go"=>1, "go"=>2, "Oh"=>1, "no"=>1, "Goodbye"=>2, "Hello"=>2, "hello"=>5, "don"=>2, "t"=>2, "know"=>2, "why"=>2, "you"=>2, "goodbye"=>1}
{% endhighlight %}

しかし、これを嫌うRubyistは多く、ネット上でその改善についての議論をしばしば見掛けます。

> [Feature #5662: inject-accumulate, or Haskell's mapAccum* - ruby-trunk - Ruby Issue Tracking System](http://bugs.ruby-lang.org/issues/5662)
>     
> [Ruby inject with intial being a hash - Stack Overflow](http://stackoverflow.com/questions/9434162/ruby-inject-with-intial-being-a-hash)

そしてその有力な解決策として、`Enumerable#each_with_object`が提示されてきました。

{% highlight ruby %}
words.each_with_object(Hash.new(0)) { |word, h| h[word] += 1 } # => {"You"=>3, "say"=>10, "Yes"=>1, "I"=>7, "No"=>1, "Stop"=>1, "and"=>2, "Go"=>1, "go"=>2, "Oh"=>1, "no"=>1, "Goodbye"=>2, "Hello"=>2, "hello"=>5, "don"=>2, "t"=>2, "know"=>2, "why"=>2, "you"=>2, "goodbye"=>1}
{% endhighlight %}

しかし、その有用性にも拘らず、依然としてeach_with_objectの知名度および利用頻度は低いと思われます。そして、その原因は、その名前の長さにあると考えます。

以下の演算により、Ruby1.9.3の環境下でeach_with_objectは、754件中39番目に長い名前のメソッドであることが分かりました。

{% highlight ruby %}
methods = Module.constants.flat_map do |c|
  next [] if c == :Gem
  k = Module.const_get(c)
  k.methods(false) + k.instance_methods(false) rescue []
end.uniq.reject { |m| "#{m}".start_with? '_deprecated' }.sort_by { |m| -m.size }

methods.size # => 754
methods.index(:each_with_object) # => 39

puts methods.take(100).group_by(&:size).to_a
{% endhighlight %}

出力です。

    26
    protected_instance_methods
    instance_variable_defined?
    25
    protected_method_defined?
    24
    private_instance_methods
    23
    class_variable_defined?
    public_instance_methods
    define_singleton_method
    private_method_defined?
    22
    singleton_method_added
    public_instance_method
    public_method_defined?
    21
    instance_variable_get
    instance_variable_set
    remove_class_variable
    20
    private_class_method
    repeated_combination
    repeated_permutation
    compare_by_identity?
    19
    respond_to_missing?
    abort_on_exception=
    public_class_method
    compare_by_identity
    18
    undefine_finalizer
    instance_variables
    abort_on_exception
    class_variable_get
    class_variable_set
    relative_path_from
    17
    internal_encoding
    external_encoding
    default_internal=
    default_external=
    protected_methods
    singleton_methods
    ascii_compatible?
    16
    global_variables
    executable_real?
    initialize_clone
    each_with_object   # <= Here!
    require_relative
    private_constant
    default_external
    included_modules
    instance_methods
    define_finalizer
    default_internal
    15
    private_methods
    fixed_encoding?
    class_variables
    instance_method
    each_with_index
    public_constant
    garbage_collect
    source_location
    valid_encoding?
    singleton_class
    world_writable?
    local_variables
    world_readable?
    method_defined?
    14
    readable_real?
    locale_charmap
    const_defined?
    collect_concat
    initialize_dup
    add_trace_func
    close_on_exec=
    close_on_exec?
    named_captures
    set_trace_func
    write_nonblock
    writable_real?
    each_codepoint
    force_encoding
    public_methods
    13
    const_missing
    each_filename
    default_proc=
    set_backtrace
    public_method
    read_nonblock
    instance_exec
    absolute_path
    count_objects
    instance_eval
    12
    marshal_load
    reverse_each
    exclude_end?
    instance_of?
    make_symlink
    set_encoding
    block_given?
    default_proc
    slice_before
    marshal_dump
    11
    rationalize
    realdirpath
    each_object
    expand_path
    with_object

このリストから分かることは、長さ15を超えるメソッドはその大半がリフレクション用か特殊目的用のものであるという事実です。each_with_objectはより汎用的なメソッドですから、その名前はもっと短くあるべきと考えます。現状の長さは、そのメソッドを無きものにしています。

そこで`Enumerable#with`を提案します。まず、Rubyで扱われるデータはすべてオブジェクトですから、each_with_objectにおけるobjectは自明であり不要と考えます。次に、Enumerableオブジェクトに対するメソッド呼び出しという点から見て、eachも必須のものとは言えず、削除可能と考えます。そして残ったwithで十分にその目的、つまりEnumerableな要素を任意のオブジェクトと共に操作する、を意図できていると考えます。

最後に、`Enumerable#with`を使った例を示します。

{% highlight ruby %}
Enumerable.send(:alias_method, :with, :each_with_object)

words.with(Hash.new(0)) { | word, h| h[word] += 1 } # => {"You"=>3, "say"=>10, "Yes"=>1, "I"=>7, "No"=>1, "Stop"=>1, "and"=>2, "Go"=>1, "go"=>2, "Oh"=>1, "no"=>1, "Goodbye"=>2, "Hello"=>2, "hello"=>5, "don"=>2, "t"=>2, "know"=>2, "why"=>2, "you"=>2, "goodbye"=>1}

[*1..10].with(5).map(&:*) # => [5, 10, 15, 20, 25, 30, 35, 40, 45, 50]

['ruby', 'python', 'haskell'].with('ist').map(&:+) # => ["rubyist", "pythonist", "haskellist"]
{% endhighlight %}

ご検討の程よろしくお願い致します。

----
{{ 4834005259 | amazon_medium_image }}
{{ 4834005259 | amazon_link }} by {{ 4834005259 | amazon_authors }}


{% footnotes %}
  {% fn 他言語を殆ど知らない故なのかも知れませんが.. %}
{% endfootnotes %}
