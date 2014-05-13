---
layout: post
title: "Ruby製ドキュメント生成ツール「Yampla」でYAMLファイルからXMLファイルを生成する"
description: ""
category: 
tags: 
date: 2013-01-16
published: true
---
{% include JB/setup %}

[前回](http://melborne.github.com/2013/01/15/build-book-pages-with-yampla-gem/ 'Rubyで商品リストのようなものを作るときあなたはいつもどうしていますか？')紹介したRuby製ドキュメント生成ツール「[Yampla](https://rubygems.org/gems/yampla 'yampla \| RubyGems.org \| your community gem host')」を使って、YAMLファイルからXMLファイルを生成する簡単な例を紹介しますね。

対象情報はプログラミング言語にしましょう。まずは以下のサイトから任意に選択した言語についての情報を取得します。

> [Freebase](http://www.freebase.com/ 'Freebase')

任意ディレクトリを用意し、取得した情報をYAMLフォーマットでファイルに記述します。ここでは各言語についてのデザイナ`designer`、公開年`year`、影響を与えた言語`influenced`を対象にします。要素名と値の関係はハッシュ（key: value）で表現します。１要素に複数の値があり得る場合は値を配列（- value）で表現します。

####language.yaml
{% highlight yaml %}
Lisp:
  designer:
    - John McCarthy
  year: 1958
  influenced:
    - Python
    - Perl
    - Ruby
    - Caml
    - Pike
    - Dylan
    - CLOS
    - Smalltalk
    - Logo
    - Emacs Lisp
C:
  designer:
    - Dennis Ritchie
  year: 1972
  influenced:
    - C++
    - PHP
    - Vala
    - LPC
    - Perl
    - Objective-C
    - C--
    - PCASTL
    - AWK
    - JavaScript
C++:
  designer:
    - Bjarne Stroustrup
  year: 1983
  influenced:
    - D
    - C#
    - Dylan
    - Perl
    - PHP
    - Dao Language
    - Aikido Programming Language
    - LPC
    - Ferite
    - URBI
Perl:
  designer:
    - Larry Wall
  year: 1987
  influenced:
    - Ruby
    - PHP
    - Python
    - JavaScript
    - ECMAScript
    - Windows PowerShell
    - Dao Language
    - Groovy
    - Frink
    - LPC
Erlang:
  designer:
    - Ericsson
  year: 1987
  influenced:
    - Scala
    - Clojure
    - Fan
    - F#
Haskell:
  designer:
    - Simon Peyton Jones
    - Philip Wadler
    - Paul Hudak
  year: 1990
  influenced:
    - Python
    - Scala
    - Mercury
    - Clean programming language
    - Language Integrated Query
    - Generic Java programming language
    - Perl 6
    - Epigram programming language
    - Cayenne programming language
    - F#
Ruby:
  designer:
    - Yukihiro Matsumoto
  year: 1995
  influenced:
    - Mantra
    - Groovy
    - Perl 6
    - Frink
    - Windows PowerShell
    - BeanShell
    - Ferite
    - Judoscript
    - URBI
    - Nu
JavaScript:
  designer:
    - Brendan Eich
  year: 1995
  influenced:
    - mjt
    - ActionScript
    - Aikido Programming Language
    - Objective-J
    - DECLAN Pro
    - Squirrel programming language
    - Script.NET
    - Curl programming language
    - JScript
    - JScript .NET
Scala:
  designer:
    - Martin Odersky
  year: 2001
  influenced:
    - Fortress programming language
    - Fan
{% endhighlight %}

次に、XMLテンプレートをindex_template.xmlという名前で用意します。YAMLデータには**items**という変数でアクセスできます。Liquidの式`{{ "{% " }}%}`または出力`{{ "{{ " }}}}`タグを使ってテンプレートにYAML上の情報を埋め込みます。配列要素を展開するには`{{ "{% for item in items " }}%}`式が使えます。

####index_template.xml
{% highlight xml %}
<?xml version="1.0" encoding="UTF-8"?>
<language>
  {{ "{% for lang in items " }}%}
  <name>{{ "{{ lang.id " }}}}</name>
  <designer>
    {{ "{% for name in lang.designer " }}%}
    <name>{{ "{{ name " }}}}</name>
    {{ "{% endfor " }}%}
  </designer>
  <year>{{ "{{ lang.year " }}}}</year>
  <influenced>
    {{ "{% for lang in lang.influenced " }}%}
    <language>{{{ "{ lang " }}}}</language>
    {{ "{% endfor " }}%}
  </influenced>
  {{ "{% endfor " }}%}
</language>
{% endhighlight %}

次にこれらファイルを生成したディレクトリ**lang**において、次のコマンドを実行します。

{% highlight bash %}
lang% yampla
{% endhighlight %}

これによりそのサブディレクトリ**out**に`index.xml`ファイルが生成されます。

{% highlight bash %}
lang% tree
.
├── index_template.xml
├── languages.yaml
└── out
    └── index.xml
{% endhighlight %}

以上により、上記YAMLフィアルから以下のようなXMLデータが生成出来ました。

{% highlight xml %}
<?xml version="1.0" encoding="UTF-8"?>
<language>
  
  <name>Lisp</name>
  <designer>
    
    <name>John McCarthy</name>
    
  </designer>
  <year>1958</year>
  <influenced>
    
    <language>Python</language>
    
    <language>Perl</language>
    
    <language>Ruby</language>
    
    <language>Caml</language>
    
    <language>Pike</language>
    
    <language>Dylan</language>
    
    <language>CLOS</language>
    
    <language>Smalltalk</language>
    
    <language>Logo</language>
    
    <language>Emacs Lisp</language>
    
  </influenced>
  
  <name>C</name>
  <designer>
    
    <name>Dennis Ritchie</name>
    
  </designer>
  <year>1972</year>
  <influenced>
    
    <language>C++</language>
    
    <language>PHP</language>
    
    <language>Vala</language>
    
    <language>LPC</language>
    
    <language>Perl</language>
    
    <language>Objective-C</language>
    
    <language>C--</language>
    
    <language>PCASTL</language>
    
    <language>AWK</language>
    
    <language>JavaScript</language>
    
  </influenced>
  
  <name>C++</name>
  <designer>
    
    <name>Bjarne Stroustrup</name>
    
  </designer>
  <year>1983</year>
  <influenced>
    
    <language>D</language>
    
    <language>C#</language>
    
    <language>Dylan</language>
    
    <language>Perl</language>
    
    <language>PHP</language>
    
    <language>Dao Language</language>
    
    <language>Aikido Programming Language</language>
    
    <language>LPC</language>
    
    <language>Ferite</language>
    
    <language>URBI</language>
    
  </influenced>
  
  <name>Perl</name>
  <designer>
    
    <name>Larry Wall</name>
    
  </designer>
  <year>1987</year>
  <influenced>
    
    <language>Ruby</language>
    
    <language>PHP</language>
    
    <language>Python</language>
    
    <language>JavaScript</language>
    
    <language>ECMAScript</language>
    
    <language>Windows PowerShell</language>
    
    <language>Dao Language</language>
    
    <language>Groovy</language>
    
    <language>Frink</language>
    
    <language>LPC</language>
    
  </influenced>
  
  <name>Erlang</name>
  <designer>
    
    <name>Ericsson</name>
    
  </designer>
  <year>1987</year>
  <influenced>
    
    <language>Scala</language>
    
    <language>Clojure</language>
    
    <language>Fan</language>
    
    <language>F#</language>
    
  </influenced>
  
  <name>Haskell</name>
  <designer>
    
    <name>Simon Peyton Jones</name>
    
    <name>Philip Wadler</name>
    
    <name>Paul Hudak</name>
    
  </designer>
  <year>1990</year>
  <influenced>
    
    <language>Python</language>
    
    <language>Scala</language>
    
    <language>Mercury</language>
    
    <language>Clean programming language</language>
    
    <language>Language Integrated Query</language>
    
    <language>Generic Java programming language</language>
    
    <language>Perl 6</language>
    
    <language>Epigram programming language</language>
    
    <language>Cayenne programming language</language>
    
    <language>F#</language>
    
  </influenced>
  
  <name>Ruby</name>
  <designer>
    
    <name>Yukihiro Matsumoto</name>
    
  </designer>
  <year>1995</year>
  <influenced>
    
    <language>Mantra</language>
    
    <language>Groovy</language>
    
    <language>Perl 6</language>
    
    <language>Frink</language>
    
    <language>Windows PowerShell</language>
    
    <language>BeanShell</language>
    
    <language>Ferite</language>
    
    <language>Judoscript</language>
    
    <language>URBI</language>
    
    <language>Nu</language>
    
  </influenced>
  
  <name>JavaScript</name>
  <designer>
    
    <name>Brendan Eich</name>
    
  </designer>
  <year>1995</year>
  <influenced>
    
    <language>mjt</language>
    
    <language>ActionScript</language>
    
    <language>Aikido Programming Language</language>
    
    <language>Objective-J</language>
    
    <language>DECLAN Pro</language>
    
    <language>Squirrel programming language</language>
    
    <language>Script.NET</language>
    
    <language>Curl programming language</language>
    
    <language>JScript</language>
    
    <language>JScript .NET</language>
    
  </influenced>
  
  <name>Scala</name>
  <designer>
    
    <name>Martin Odersky</name>
    
  </designer>
  <year>2001</year>
  <influenced>
    
    <language>Fortress programming language</language>
    
    <language>Fan</language>
    
  </influenced>
  
</language>

{% endhighlight %}

簡単ですね！

「[Yampla](https://rubygems.org/gems/yampla 'yampla')」を使って、YAMLファイルからXMLファイルを生成する簡単な例を紹介しました。


---

関連記事： [Rubyで商品リストのようなものを作るときあなたはいつもどうしていますか？]({{ site.url }}/2013/01/15/build-book-pages-with-yampla-gem/ 'Rubyで商品リストのようなものを作るときあなたはいつもどうしていますか？')

---

{{ 4873112214 | amazon_medium_image }}
{{ 4873112214 | amazon_link }} by {{ 4873112214 | amazon_authors }}


