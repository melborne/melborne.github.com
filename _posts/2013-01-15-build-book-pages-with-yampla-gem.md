---
layout: post
title: "Rubyで商品リストのようなものを作るときあなたはいつもどうしていますか？"
description: ""
category: 
tags: 
date: 2013-01-15
published: true
---
{% include JB/setup %}

ブログ記事を電子書籍化して販売するとかいう個人プロジェクトをやってて、先日そのための販売サイトというかページを「[M'ELBORNE BOOKS](http://melborne.github.com/books/ 'M'ELBORNE BOOKS')」という名の下で公開したんだけど、最初このサイトというかページは全書籍が一覧できるトップページの一頁しかなく、それじゃ余りに販売サイトとしては寂しすぎるというか貧相というかそういう想いから、ここは一つトップページに加えて各書籍のもう少し詳しい情報が書かれた個別ページもあって然るべきだから作るべきとなったんだけど、どうもこの手の作業は一々タグとタグの間に書きたい項目を書かなきゃならないとか想像以上に苦労が多くて遅々として作業が進まずこりゃかなわんなあと悶々としていたところ、自分は実はRubyが書けるのであったところを思い出し、書誌事項を記述した一枚ペラのテキストからこれらトップページと個別ページを生成したら今後も書籍が増えたときにこの面倒なHTMLタグやらとかを書かなくて済むのでこれいいんちゃうという着想に遅ればせながら気づき、早々にやってみたところまんまと目的の物がRubyスクリプトから次々と生まれ出てきてホンマにこりゃ便利Ruby愛してるわと相成って、そんなこんなで「M'ELBORNE BOOKS」をリニューアルしましたので皆様にお知らせ致します。

> [M'ELBORNE BOOKS]({{ site.url }}/books/ 'M'ELBORNE BOOKS')

![Alt title]({{ site.url }}/assets/images/2013/01/yampla0.png)

各画像クリックで個別ページに飛びます。

---

で、便利ついでに汎用性とか実用性とか将来性とかについては全くもって自分には想像できないのだけれども、さりとてどこか遠くの地域の特殊な環境のなかで暮らす幾ばくかの人たちの中の一人が「おーこりゃほら例のあの誰だかのプロジェクトにおいて使ったら便利かもしれん」などと言う可能性を完全に否定することもできず、また一方でRSpecがまともに書けない状態をいつまでも引きずっている自分からなんとか抜け出したくそのためにはコードを衆目の下に晒し恥をかくことしかないとの想いも手伝って、ここは一つ一念発起、YAMLファイルにアイテム情報をリストアップしてLiquidテンプレートを用意したならRubyが勝手にインデックスと個別アイテムのページを生成してくれるって文脈で、そのYAMLとテンプレートとをくっつけて圧縮したような「`yampla`」といった安直な名前を考えついたので、そんなのいらんわカスとか罵られる可能性を右側頭部に感じながらも、これをgem化して公開しましたので皆様にお知らせ致します。

> rubygems: [Yampla](https://rubygems.org/gems/yampla 'yampla | RubyGems.org | your community gem host')
> github: [melborne/yampla](https://github.com/melborne/yampla 'melborne/yampla · GitHub')

## Yamplaとは
Yamplaとは、YAMLフォーマットで書かれたアイテム情報と、テンプレートファイルを入力として、アイテム一覧ページ(index page)およびアイテム個別ページ(item page)を出力するRuby製のドキュメント生成ツールです。テンプレート言語には[Liquid](http://liquidmarkup.org/ 'Liquid Templating language')を使っています。

## Yamplaの使い方
Yamplaの最も簡単な使い方は、`yampla`コマンドを使う方法です。

特定のディレクトリにおいて、アイテム情報に係るYAMLファイル、index用テンプレートファイル、item用テンプレートファイルを用意し、`yampla`コマンドを実行します。これによりサブディレクトリ'out'にindex pageと複数のitem pageが生成されます。

書籍情報を表示するHTMLページを例に説明します。mybookディレクトリを用意し次の３つのファイルを作ります。

{% highlight bash %}
/mybook% tree
.
├── books.yaml
├── index_template.html
└── item_template.html
{% endhighlight %}

### book.yaml

`book.yaml`に書籍情報を書きます。

{% highlight yaml %}
b1:
  title: book1
  price: 1000JPY
  date: 2013-1-1
  keywords:
    - ruby
    - beginner
b2:
  title: book2
  price: 1500JPY
  date: 2013-2-7
  keywords:
    - rails
b3:
  title: book3
  price: 2400JPY
  date: 2013-3-15
  keywords:
    - sinatra
    - rack
{% endhighlight %}

例において、b1〜b3が各書籍の`id`となります。

### index_template.html

indexページのためのテンプレート`index_template.html`を書きます。

{% highlight html %}
<!DOCTYPE html>
<html>
  <head>
    <meta http-equiv="Content-type" content="text/html; charset=utf-8">
    <title>Book List</title>
  </head>
  <body>
    <ol>
      {{ "{% for item in items " }}%}
      <li id="{{ "{{ item.id " }}}}"><a href="{{ "{{ item.id " }}}}.html">{{ "{{ item.title " }}}}</a></li>
      {{ "{% endfor " }}%}
    </ol>
  </body>
</html>
{% endhighlight %}

book.yamlにおける書籍データには、`items`変数を通してアクセスできます。各書籍の属性情報はメソッド呼び出しのような形(ex item.title)でアクセスできます。`{{ "{% " }}%}`および`{{ "{{ " }}}}`はLiquidにおけるタグで、前者が式用、後者が出力用、つまりERBにおける`<% %>`および`<%= %>`にそれぞれ対応します。詳細は以下を参考にして下さい。

> [Liquid for Designers · Shopify/liquid Wiki](https://github.com/Shopify/liquid/wiki/Liquid-for-Designers 'Liquid for Designers · Shopify/liquid Wiki')

### item_template.html

itemページのためのテンプレート`item_template.html`を書きます。

{% highlight html %}
<!DOCTYPE html>
<html>
  <head>
    <meta http-equiv="Content-type" content="text/html; charset=utf-8">
    <title>{{ "{{ item.title " }}}}</title>
  </head>
  <body>
    <h2>{{ "{{ item.title " }}}}</h2>
    <p>{{ "{{ item.price " }}}}</p>
    <p>{{ "{{ item.date " }}}}</p>
    <div>
      {{ "{% for key in item.keywords " }}%}
      <small>{{ "{{ key " }}}}</small>
      {{ "{% endfor " }}%}
    </div>
  </body>
</html>
{% endhighlight %}

各書籍データには`item`変数を通じてアクセスできます。

### yamplaコマンドの実行

そして**mybook**ディレクトリにおいて`yampla`コマンドを実行します。

{% highlight bash %}
/mybook% yampla
{% endhighlight %}

これによりサブディレクトリ**out**に、`index.html` `b1.html` `b2.html` `b3.html` の各ファイルが生成されます。

{% highlight bash %}
/mybook% tree
.
├── books.yaml
├── index_template.html
├── item_template.html
└── out
    ├── b1.html
    ├── b2.html
    ├── b3.html
    └── index.html
{% endhighlight %}

####index.html

{% highlight html %}
<!DOCTYPE html>
<html>
  <head>
    <meta http-equiv="Content-type" content="text/html; charset=utf-8">
    <title>Book List</title>
  </head>
  <body>
    <ol>
      
      <li id="b1"><a href="b1.html">book1</a></li>
      
      <li id="b2"><a href="b2.html">book2</a></li>
      
      <li id="b3"><a href="b3.html">book3</a></li>
      
    </ol>
  </body>
</html>
{% endhighlight %}

####b1.html

{% highlight html %}
<!DOCTYPE html>
<html>
  <head>
    <meta http-equiv="Content-type" content="text/html; charset=utf-8">
    <title>book1</title>
  </head>
  <body>
    <h2>book1</h2>
    <p>1000JPY</p>
    <p>2013-01-01</p>
    <div>
      
      <small>ruby</small>
      
      <small>beginner</small>
      
    </div>
  </body>
</html>
{% endhighlight %}

liquidにはERBにおける`<% -%>`に対応する`{{ "{% -" }}%}`がないようなので、空行についてはご容赦を。


![Alt title]({{ site.url }}/assets/images/2013/01/yampla1.png)
![Alt title]({{ site.url }}/assets/images/2013/01/yampla2.png)
![Alt title]({{ site.url }}/assets/images/2013/01/yampla3.png)
![Alt title]({{ site.url }}/assets/images/2013/01/yampla4.png)

`yampla`コマンドにおけるファイル名の変更などのオプションについては、`yampla --help`を参照して下さい。

## Rubyスクリプトで作る


先の出力をRubyスクリプトで実現する場合は、次のようにします。

####book\_build.rb
{% highlight ruby %}
require "yampla"

ya = Yampla::Build.new('books.yaml')
ya.set_template(:index, 'index_template.html')
ya.set_template(:items, 'item_template.html')

ya.save(:index)
ya.save(:items)
{% endhighlight %}

文字列で出力を得たいときは`#run`を使います。

{% highlight ruby %}
ya.run(:index)
ya.run(:items)
{% endhighlight %}

`items`の出力は次のような配列で得られます。

{% highlight ruby %}
{"b1"=>"<!DOCTYPE html>\n<html>\n  <head>\n    <meta http-equiv=\"Content-type\" content=\"text/html; charset=utf-8\">\n    <title>book1</title>\n  </head>\n  <body>\n    <h2>book1</h2>\n    <p>1000JPY</p>\n    <p>2013-01-01</p>\n    <div>\n      \n      <small>ruby</small>\n      \n      <small>beginner</small>\n      \n    </div>\n  </body>\n</html>\n",
 "b2"=>"<!DOCTYPE html>\n<html>\n  <head>\n    <meta http-equiv=\"Content-type\" content=\"text/html; charset=utf-8\">\n    <title>book2</title>\n  </head>\n  <body>\n    <h2>book2</h2>\n    <p>1500JPY</p>\n    <p>2013-02-07</p>\n    <div>\n      \n      <small>rails</small>\n      \n    </div>\n  </body>\n</html>\n",
 "b3"=>"<!DOCTYPE html>\n<html>\n  <head>\n    <meta http-equiv=\"Content-type\" content=\"text/html; charset=utf-8\">\n    <title>book3</title>\n  </head>\n  <body>\n    <h2>book3</h2>\n    <p>2400JPY</p>\n    <p>2013-03-15</p>\n    <div>\n      \n      <small>sinatra</small>\n      \n      <small>rack</small>\n      \n    </div>\n  </body>\n</html>\n"}
{% endhighlight %}

以上です。

良かったら遊んでみて下さい。

また「M'ELBORNE BOOKS」のほうもどうぞよろしくお願いしますm(__)m

> [M'ELBORNE BOOKS]({{ site.url }}/books/ 'M'ELBORNE BOOKS')

