---
layout: post
title: "行指向ドキュメント処理で活躍するRubyのだんご化３兄弟といったら..."
tagline: "それとtogglate0.1.4アップデートのお知らせ"
description: ""
category: 
tags: 
date: 2014-04-08
published: true
---
{% include JB/setup %}


Rubyにはアクセスログのような行指向ドキュメントなどを、任意の条件で複数の束にまとめ上げる便利なEnumerableのメソッドが３つあります。`group_by`, `chunk`, そして`slice_before`です。これらはRubyの「**だんご化３兄弟**」としてRubyistの間で広く知られています{% fn_ref 1 %}。


簡単に言えばこれらのメソッドは、行単位のデータに対し以下の処理を実現するものとして表現できます。

> `group_by`は、同一条件の行を総まとめするメソッド。
>
> `chunk`は、同一条件の行を部分まとめするメソッド。
>
> `slice_before`は、指定行を先頭に後続行を部分まとめするメソッド。

（もちろん、これらのメソッドは行単位データ以外のEnumerableなデータに適用できます。）

## group_by

> [instance method Enumerable#group_by](http://docs.ruby-lang.org/ja/2.1.0/method/Enumerable/i/group_by.html "instance method Enumerable#group_by")

最も直感的なメソッドは`group_by`です。行単位データの並び順に拘らず、ブロックで渡された条件ごとにデータをまとめ上げます。group_byを使って、ランダムに並んだユーザのスコアーをユーザ単位にまとめてみます。

####score.txt

    Alice,84.0,79.5
    Bob,20.0,56.5
    Jimmy,80.0,31.0
    Kent,90.5,15.5
    Ross,68.0,33.0
    Alice,24.0,15.5
    Bob,60.0,16.5
    Jimmy,85.0,42.0
    Kent,55.5,15.5
    Ross,22.0,33.5
    Alice,64.5,39.5
    Bob,25.0,50.5
    Jimmy,60.0,61.0
    Kent,70.5,25.0
    Ross,48.0,36.5

{% highlight ruby %}
require "pp"
score = File.readlines('score.txt')

pp score.group_by { |line| line.match(/\A\w+/).to_s }

# >> {"Alice"=>["Alice,84.0,79.5\n", "Alice,24.0,15.5\n", "Alice,64.5,39.5\n"],
# >>  "Bob"=>["Bob,20.0,56.5\n", "Bob,60.0,16.5\n", "Bob,25.0,50.5\n"],
# >>  "Jimmy"=>["Jimmy,80.0,31.0\n", "Jimmy,85.0,42.0\n", "Jimmy,60.0,61.0\n"],
# >>  "Kent"=>["Kent,90.5,15.5\n", "Kent,55.5,15.5\n", "Kent,70.5,25.0\n"],
# >>  "Ross"=>["Ross,68.0,33.0\n", "Ross,22.0,33.5\n", "Ross,48.0,36.5\n"]}
{% endhighlight %}

group_byのブロックで先頭ワード（ユーザ名）の一致を条件にします。

今度は、HTTPステータスコードをコードセクションごとにグループ化してみます。

{% highlight ruby %}
require "pp"
require "rack"

pp Rack::Utils::HTTP_STATUS_CODES.group_by { |k, v| k / 100 }

# >> {1=>[[100, "Continue"], [101, "Switching Protocols"], [102, "Processing"]],
# >>  2=>
# >>   [[200, "OK"],
# >>    [201, "Created"],
# >>    [202, "Accepted"],
# >>    [203, "Non-Authoritative Information"],
# >>    [204, "No Content"],
# >>    [205, "Reset Content"],
# >>    [206, "Partial Content"],
# >>    [207, "Multi-Status"],
# >>    [208, "Already Reported"],
# >>    [226, "IM Used"]],
# >>  3=>
# >>   [[300, "Multiple Choices"],
# >>    [301, "Moved Permanently"],
# >>    [302, "Found"],
# >>    [303, "See Other"],
# >>    [304, "Not Modified"],
# >>    [305, "Use Proxy"],
# >>    [306, "Reserved"],
# >>    [307, "Temporary Redirect"],
# >>    [308, "Permanent Redirect"]],
# >>  4=>
# >>   [[400, "Bad Request"],
# >>    [401, "Unauthorized"],
# >>    [402, "Payment Required"],
# >>    [403, "Forbidden"],
# >>    [404, "Not Found"],
# >>    [405, "Method Not Allowed"],
# >>    [406, "Not Acceptable"],
# >>    [407, "Proxy Authentication Required"],
# >>    [408, "Request Timeout"],
# >>    [409, "Conflict"],
# >>    [410, "Gone"],
# >>    [411, "Length Required"],
# >>    [412, "Precondition Failed"],
# >>    [413, "Request Entity Too Large"],
# >>    [414, "Request-URI Too Long"],
# >>    [415, "Unsupported Media Type"],
# >>    [416, "Requested Range Not Satisfiable"],
# >>    [417, "Expectation Failed"],
# >>    [422, "Unprocessable Entity"],
# >>    [423, "Locked"],
# >>    [424, "Failed Dependency"],
# >>    [425, "Reserved for WebDAV advanced collections expired proposal"],
# >>    [426, "Upgrade Required"],
# >>    [427, "Unassigned"],
# >>    [428, "Precondition Required"],
# >>    [429, "Too Many Requests"],
# >>    [430, "Unassigned"],
# >>    [431, "Request Header Fields Too Large"]],
# >>  5=>
# >>   [[500, "Internal Server Error"],
# >>    [501, "Not Implemented"],
# >>    [502, "Bad Gateway"],
# >>    [503, "Service Unavailable"],
# >>    [504, "Gateway Timeout"],
# >>    [505, "HTTP Version Not Supported"],
# >>    [506, "Variant Also Negotiates (Experimental)"],
# >>    [507, "Insufficient Storage"],
# >>    [508, "Loop Detected"],
# >>    [509, "Unassigned"],
# >>    [510, "Not Extended"],
# >>    [511, "Network Authentication Required"]]}
{% endhighlight %}


## chunk

> [instance method Enumerable#chunk](http://docs.ruby-lang.org/ja/2.1.0/method/Enumerable/i/chunk.html "instance method Enumerable#chunk")

行単位データの並びに意味があるときに、その順位を崩さずに部分まとめ（チャンク）を生成するときは`chunk`が使えます。chunkはブロックで渡された条件の評価が切り替わるポイントでチャンクを切ります。chunkを使って、空行で別れた複数のセンテンスを持つ小説`novel.txt`を、センテンスごとに分けてみます。


#### novel.txt

    One morning, when Gregor Samsa woke from troubled dreams,
    he found himself transformed in his bed into a horrible vermin.
    
    He lay on his armour-like back,
    and if he lifted his head a little he could see his brown belly, 
    slightly domed and divided by arches into stiff sections.
    
    The bedding was hardly able to cover it and seemed ready to slide off any moment.
    
    His many legs,
    pitifully thin compared with the size of the rest of him,
    waved about helplessly as he looked.
    
    "What's happened to me?" he thought.
    "It wasn't a dream." 
    
    His room, a proper human room although a little too small, 
    lay peacefully between its four familiar walls.
    
    A collection of textile samples lay spread out on the table
    - Samsa was a travelling salesman - and above it there hung a picture
    that he had recently cut out of an illustrated magazine and housed in a nice, gilded frame.
    

{% highlight ruby %}
require "pp"
novel = File.readlines('novel.txt')

def data_line?(line)
  !!line.match(/\A\s*\S+/)
end

pp novel.chunk { |line| data_line? line }.to_a

# >> [[true,
# >>   ["One morning, when Gregor Samsa woke from troubled dreams,\n",
# >>    "he found himself transformed in his bed into a horrible vermin.\n"]],
# >>  [false, ["\n"]],
# >>  [true,
# >>   ["He lay on his armour-like back,\n",
# >>    "and if he lifted his head a little he could see his brown belly, \n",
# >>    "slightly domed and divided by arches into stiff sections.\n"]],
# >>  [false, ["\n"]],
# >>  [true,
# >>   ["The bedding was hardly able to cover it and seemed ready to slide off any moment.\n"]],
# >>  [false, ["\n"]],
# >>  [true,
# >>   ["His many legs,\n",
# >>    "pitifully thin compared with the size of the rest of him,\n",
# >>    "waved about helplessly as he looked.\n"]],
# >>  [false, ["\n"]],
# >>  [true, ["\"What's happened to me?\" he thought.\n", "\"It wasn't a dream.\" \n"]],
# >>  [false, ["\n"]],
# >>  [true,
# >>   ["His room, a proper human room although a little too small, \n",
# >>    "lay peacefully between its four familiar walls.\n"]],
# >>  [false, ["\n"]],
# >>  [true,
# >>   ["A collection of textile samples lay spread out on the table\n",
# >>    "- Samsa was a travelling salesman - and above it there hung a picture\n",
# >>    "that he had recently cut out of an illustrated magazine and housed in a nice, gilded frame.\n"]]]
{% endhighlight %}

チャンクが空行のところで切れているのが確認できます。

### 不要な行をチャンクから除く

この例において空行のチャンクは不要でしょう。この場合、ブロックで`false`に代えて`nil`（または:_separator）が返るようにすれば、次のような結果が得られます。

{% highlight ruby %}
require "pp"
novel = File.readlines('novel.txt')

def data_line?(line)
  !!line.match(/\A\s*\S+/)
end

+ pp novel.chunk { |line| data_line?(line) || nil }.to_a

# >> [[true,
# >>   ["One morning, when Gregor Samsa woke from troubled dreams,\n",
# >>    "he found himself transformed in his bed into a horrible vermin.\n"]],
# >>  [true,
# >>   ["He lay on his armour-like back,\n",
# >>    "and if he lifted his head a little he could see his brown belly, \n",
# >>    "slightly domed and divided by arches into stiff sections.\n"]],
# >>  [true,
# >>   ["The bedding was hardly able to cover it and seemed ready to slide off any moment.\n"]],
# >>  [true,
# >>   ["His many legs,\n",
# >>    "pitifully thin compared with the size of the rest of him,\n",
# >>    "waved about helplessly as he looked.\n"]],
# >>  [true, ["\"What's happened to me?\" he thought.\n", "\"It wasn't a dream.\" \n"]],
# >>  [true,
# >>   ["His room, a proper human room although a little too small, \n",
# >>    "lay peacefully between its four familiar walls.\n"]],
# >>  [true,
# >>   ["A collection of textile samples lay spread out on the table\n",
# >>    "- Samsa was a travelling salesman - and above it there hung a picture\n",
# >>    "that he had recently cut out of an illustrated magazine and housed in a nice, gilded frame.\n"]]]
{% endhighlight %}

### 単一行のチャンク

この小説のなかで`"`（double quatation mark）で始まる行を特別扱いし、しかもそれらを単一行でチャンクしたい場合は、その特別行に対し`:_alone`を返すようにします。

{% highlight ruby %}
require "pp"
novel = File.readlines('novel.txt')

def data_line?(line)
  !!line.match(/\A\s*\S+/)
end

pp novel.chunk { |line|
  next :_alone if line.match(/\A"/)
  data_line?(line) || nil
}.to_a

# >> [[true,
# >>   ["One morning, when Gregor Samsa woke from troubled dreams,\n",
# >>    "he found himself transformed in his bed into a horrible vermin.\n"]],
# >>  [true,
# >>   ["He lay on his armour-like back,\n",
# >>    "and if he lifted his head a little he could see his brown belly, \n",
# >>    "slightly domed and divided by arches into stiff sections.\n"]],
# >>  [true,
# >>   ["The bedding was hardly able to cover it and seemed ready to slide off any moment.\n"]],
# >>  [true,
# >>   ["His many legs,\n",
# >>    "pitifully thin compared with the size of the rest of him,\n",
# >>    "waved about helplessly as he looked.\n"]],
# >>  [:_alone, ["\"What's happened to me?\" he thought.\n"]],
# >>  [:_alone, ["\"It wasn't a dream.\"\n"]],
# >>  [true,
# >>   ["His room, a proper human room although a little too small, \n",
# >>    "lay peacefully between its four familiar walls.\n"]],
# >>  [true,
# >>   ["A collection of textile samples lay spread out on the table\n",
# >>    "- Samsa was a travelling salesman - and above it there hung a picture\n",
# >>    "that he had recently cut out of an illustrated magazine and housed in a nice, gilded frame.\n"]]]
{% endhighlight %}

自分は翻訳支援ツール「[togglate](https://rubygems.org/gems/togglate "togglate")」というものを作っています。このツールは訳文を作成するテキストに原文をそのセンテンスごとに埋め込むものです。つまり先のコードはtogglateの心臓部です。

## slice_before

> [instance method Enumerable#slice_before](http://docs.ruby-lang.org/ja/2.1.0/method/Enumerable/i/slice_before.html "instance method Enumerable#slice_before")

見出し行とそれに続く複数の行を一まとめにしたチャンクを得たいときなど、次に同じ条件が現れるまでを一つのチャンクとしたいときは、`slice_before`が使えます。行をまとめる機能をもったものに`slice`という名前が付いているので、このメソッドに辿り着くのは難しいかもしれません（個人的には`chunk_from`のような名前のほうがしっくり来ます）。Markdownファイル`README.md`からその大見出し`#`ごとに区切られたチャンクを生成してみます。

#### README.md

    # Goals
    
    * For every future Sinatra release, have at least one fully compatible release
    * High code quality, high test coverage
    * Include plugins people usually ask for a lot
    
    # TODO
    
    * Write documentation, integrate into Sinatra website
    * Finish imports and rewrites
    
    # Included extensions
    
    ## Common Extensions
    
    These are common extension which will not add significant overhead or change any
    behavior of already existing APIs. They do not add any dependencies not already
    installed with this gem.
    
    # Usage
    
    ## Classic Style
    
    A single extension (example: sinatra-content-for):


{% highlight ruby %}
require "pp"
readme = File.readlines('README.md')

pp readme.slice_before { |line|
  line.match(/\A#[^#]/)
}.to_a

# >> [["# Goals\n",
# >>   "\n",
# >>   "* For every future Sinatra release, have at least one fully compatible release\n",
# >>   "* High code quality, high test coverage\n",
# >>   "* Include plugins people usually ask for a lot\n",
# >>   "\n"],
# >>  ["# TODO\n",
# >>   "\n",
# >>   "* Write documentation, integrate into Sinatra website\n",
# >>   "* Finish imports and rewrites\n",
# >>   "\n"],
# >>  ["# Included extensions\n",
# >>   "\n",
# >>   "## Common Extensions\n",
# >>   "\n",
# >>   "These are common extension which will not add significant overhead or change any\n",
# >>   "behavior of already existing APIs. They do not add any dependencies not already\n",
# >>   "installed with this gem.\n",
# >>   "\n"],
# >>  ["# Usage\n",
# >>   "\n",
# >>   "## Classic Style\n",
# >>   "\n",
# >>   "A single extension (example: sinatra-content-for):\n",
# >>   "\n"]]
{% endhighlight %}


`slice_before`はパターンを引数として取ることもできるので、先のコードは次のようにより簡潔に書けます。

{% highlight ruby %}
require "pp"
readme = File.readlines('README.md')

+ pp readme.slice_before(/\A#[^#]/).to_a

# >> [["# Goals\n",
# >>   "\n",
# >>   "* For every future Sinatra release, have at least one fully compatible release\n",
# >>   "* High code quality, high test coverage\n",
# >>   "* Include plugins people usually ask for a lot\n",
# >>   "\n"],
# >>  ["# TODO\n",
# >>   "\n",
# >>   "* Write documentation, integrate into Sinatra website\n",
# >>   "* Finish imports and rewrites\n",
# >>   "\n"],
# >>  ["# Included extensions\n",
# >>   "\n",
# >>   "## Common Extensions\n",
# >>   "\n",
# >>   "These are common extension which will not add significant overhead or change any\n",
# >>   "behavior of already existing APIs. They do not add any dependencies not already\n",
# >>   "installed with this gem.\n",
# >>   "\n"],
# >>  ["# Usage\n",
# >>   "\n",
# >>   "## Classic Style\n",
# >>   "\n",
# >>   "A single extension (example: sinatra-content-for):\n",
# >>   "\n"]]
{% endhighlight %}

<br/>

あなたもRubyの**だんご化３兄弟**と戯れてみませんか？

---

最後に宣伝ですが、「[togglate](https://rubygems.org/gems/togglate "togglate")」をversion0.1.4にアップデートしました。これにより、4スペースインデントによるコードブロックを適切にラップできるようになりました（しかしまだ他のバグが残っています）。

---

関連記事：

[Rubyで不揃いのデータを集計する](http://melborne.github.io/2013/12/26/how-about-enumerable-chunky/ "Rubyで不揃いのデータを集計する")

[素晴らしいオープンソースプロジェクトにおける翻訳者たちの憂鬱とその緩和](http://melborne.github.io/2014/04/01/togglate-now-have-reverse-action/ "素晴らしいオープンソースプロジェクトにおける翻訳者たちの憂鬱とその緩和")

---

{{ "B00000JD0Z" | amazon_medium_image }}
{{ "B00000JD0Z" | amazon_link }} by {{ "B00000JD0Z" | amazon_authors }}


---

{% footnotes %}
{% fn 嘘です。 %}
{% endfootnotes %}
