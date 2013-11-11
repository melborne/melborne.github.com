---
layout: post
title: "あなたのプロジェクトを美しく視覚化する"
tagline: "Directory Visualizing Tool 'DirFriend'の紹介"
description: ""
category: 
tags: 
date: 2013-10-28
published: true
---
{% include JB/setup %}

(追記：2013-11-01) DirFriendのバージョンアップについての記事を書きました。

> [あなたはファイルシステムに美を見るか？]({{ BASE_PATH }}/2013/10/31/there-is-a-beauty-in-your-computer/ "あなたはファイルシステムに美を見るか？")

---

プロジェクトにおけるディレクトリ構造をさっと把握したいという欲求があります。そういうときは通常`tree`します。

{% highlight bash %}
% bundle gem gem_project -bt
% tree gem_project
gem_project
├── Gemfile
├── LICENSE.txt
├── README.md
├── Rakefile
├── bin
│   └── gem_project
├── gem_project.gemspec
├── lib
│   ├── gem_project
│   │   └── version.rb
│   └── gem_project.rb
└── spec
    ├── gem_project_spec.rb
    └── spec_helper.rb

4 directories, 10 files
{% endhighlight %}

極めて簡易ですが色気がありません。プレゼンに使うにはちょっと躊躇します。プレゼンしませんが。

一方で前回の記事で示したように、Graphvizを使えばディレクトリ構造を美しく視覚化することができます。

> [Rubyのソースディレクトリも視覚化してみる]({{ BASE_PATH }}/2013/10/21/visualize-ruby-files-with-graphviz/ "Rubyのソースディレクトリも視覚化してみる")

しかしそのためには相応の手間が掛かります。

どうしたらいいでしょうか。もっと簡単に美しくプロジェクトをビジュアライズする方法はないのでしょうか。

<br/>

「[DirFriend](https://rubygems.org/gems/dir_friend "dir_friend | RubyGems.org | your community gem host")があります。」

<br/>

----

そんなわけで...

`DirFriend`というディレクトリ構造を簡単に視覚化できるツールを作りましたので紹介します:-)

> [dir_friend | RubyGems.org | your community gem host](https://rubygems.org/gems/dir_friend "dir_friend | RubyGems.org | your community gem host")
> 
> [melborne/dir_friend](https://github.com/melborne/dir_friend "melborne/dir_friend")

なお、DirFriendで生成されるDOTファイルを見るには[Graphviz](http://www.graphviz.org/ "Graphviz | Graphviz - Graph Visualization Software")が必要です。

> [Download. | Graphviz - Graph Visualization Software](http://www.graphviz.org/Download..php "Download. | Graphviz - Graph Visualization Software")

対象Rubyバージョンは`>= 2.0.0`です。最新のMac OS（Mavericks）を使っているなら`gem install dir_friend`で準備は完了です。

## DirFriendのターミナルでの使い方

DirFriendにはコマンド`dir_friend`が用意されています。早速使ってみます。引数なしで実行するとヘルプが表示されます。

{% highlight bash %}
% dir_friend
DirFriend is a tool for visualizing file directory.
Commands:
  dir_friend dot PATH        # Create a graphviz dot file for PATH
  dir_friend help [COMMAND]  # Describe available commands or one specific command
  dir_friend info PATH       # Show PATH info
  dir_friend version         # Show DirFriend version
{% endhighlight %}

プロジェクトのディレクトリで`info`すると簡単な情報が出力されます。

{% highlight bash %}
% dir_friend info gem_project
{:directories=>4, :files=>10, :depth=>3}
{% endhighlight %}

何の役にも立たないので、次に`dot`してみます。

{% highlight bash %}
% dir_friend dot gem_project
Dot file created: `a.dot`
{% endhighlight %}

カレントディレクトリに`a.dot`というDOTファイルが生成されました。開いてみます。

{% highlight bash %}
% open a.dot
{% endhighlight %}

Graphvizが起動してそのWindowに以下が表示されます。

(追記：version0.0.4よりMac OSでは自動でGraphvizが起動するようになりました。)

![dir_friend noshadow]({{ BASE_PATH }}/assets/images/2013/10/prj_tree1.png)

`dot`サブコマンドは色々なオプションを取れます。まずはヘルプで確認します。

{% highlight bash %}
% dir_friend help dot
Usage:
  dir_friend dot PATH

Options:
  -l, [--layout=LAYOUT]
  -c, [--colorscheme=COLORSCHEME]
      [--dir-shape=DIR_SHAPE]
      [--file-shape=FILE_SHAPE]
  -g, [--global=GLOBAL]
  -n, [--nodes=NODES]
  -e, [--edges=EDGES]
  -s, [--save=SAVE]
                                   # Default: a
  -d, [--depth=DEPTH]
                                   # Default: 9
  -o, [--with-open]
                                   # Default: true

Description:
  ex.

  `dir_friend dot path/ -l fdp -c blues, -e "arrowhead:none"`

  `dir_friend dot path/ -c greens -g "bgcolor:azure,rankdir:LR,splines:ortho"`
{% endhighlight %}

まずは`--colorscheme`オプションで色を付けてみます。

{% highlight bash %}
% dir_friend dot gem_project -c blues
Dot file created: `a.dot`
{% endhighlight %}

![Alt title noshadow]({{ BASE_PATH }}/assets/images/2013/10/prj_tree2.png)

ディレクトリの深さに応じて色がグラデーションします。colorschemeにセットできる色は以下で確認できます。

> [Color Names | Graphviz - Graph Visualization Software](http://www.graphviz.org/content/color-names "Color Names | Graphviz - Graph Visualization Software")

このとき色数を表す末尾の数字を省略するとDirFriend側でよしなに処理します。DirFriendと一緒にインストールされる`Gviz`のコマンドを使っても色を知ることができます。

{% highlight bash %}
% gviz man color_schemes
Color schemes:
  accent, blues, brbg, bugn, bupu, dark, gnbu, greens,
  greys, oranges, orrd, paired, pastel, piyg, pubu,
  pubugn, puor, purd, purples, rdbu, rdgy, rdpu, rdylbu,
  rdylgn, reds, set, spectral, ylgn, ylorbr, ylorrd
{% endhighlight %}

赤系の色を使ってみます。

{% highlight bash %}
% dir_friend dot gem_project -c ylorrd
Dot file created: `a.dot`
{% endhighlight %}

![Alt title noshadow]({{ BASE_PATH }}/assets/images/2013/10/prj_tree3.png)

`ylorrd`はyellow-redの略ですね。

---

他のオプションも使ってみます。

{% highlight bash %}
% dir_friend dot gem_project -c greens -l fdp --dir_shape box -g "bgcolor:azure" -e "arrowhead:none,color:violet"
Dot file created: `a.dot`
{% endhighlight %}

--global, --edges, --nodesのオプションは属性名と値を`:`で結合して渡します。複数ある場合は`,`で区切ります。

出力です。

![Alt title noshadow]({{ BASE_PATH }}/assets/images/2013/10/prj_tree4.png)

もう一つ。

{% highlight bash %}
% dir_friend dot gem_project -c purd -g "rankdir:LR,splines:ortho" -e "color:violet" --dir_shape diamond --file_shape egg
Dot file created: `a.dot`
{% endhighlight %}

rankdir:LRはグラフの向きをLeft->Rightにし、splines:orthoはエッジのカーブを直交(orthogonal)にします。Graphvizで指定可能な属性は以下を参考にします。

> [attrs | Graphviz - Graph Visualization Software](http://www.graphviz.org/content/attrs#dsplines "attrs | Graphviz - Graph Visualization Software")


出力です。

![Alt title noshadow]({{ BASE_PATH }}/assets/images/2013/10/prj_tree5.png)

## Rubyスクリプトでの使い方

次にスクリプトとしての使い方を見ます。ここでは先ほどの`gem_project`ディレクトリでirbします。

`dir_friend`をrequireして`DirFriend::D.new`でディレクトリオブジェクトを生成します。
{% highlight bash %}
/gem_project% irb -rdir_friend
IRB on Ruby2.0.0
>> d = DirFriend::D.new('.')
>> d.class.instance_methods(false) #=> [:entries, :each, :info, :up, :down, :depth, :to_s, :to_dot]
{% endhighlight %}

このオブジェクトに対し、`entries`, `each`, `info`, `up`, `down`, `to_dot`といったメソッドが使えます。

`info`, `entries`は説明は不要ですね。

{% highlight ruby %}
>> d.info #=> {:directories=>4, :files=>10, :depth=>3}
>> puts d.entries
D: bin
F: gem_project.gemspec
F: Gemfile
D: lib
F: LICENSE.txt
F: Rakefile
F: README.md
D: spec           #=> nil
{% endhighlight %}

各エントリはディレクトリDのインスタンスまたはファイルFのインスタンスです。よって一応それぞれが固有の情報を持っています。

{% highlight ruby %}
>> bin = d.entries.first
>> bin.class #=> DirFriend::D
>> bin.directory? #=> true
>> bin.size #=> 102
>>
>> gemspec = d.entries[1]
>> gemspec.class #=> DirFriend::F
>> gemspec.file? #=> true
>> gemspec.info #=> {:mode=>33188, :nlink=>1, :uid=>501, :gid=>20, :size=>869, :mtime=>2013-10-28 18:12:56 +0900}
{% endhighlight %}

`each`は対象ディレクトリ以下のすべてのファイルおよびディレクトリをトラバースします。`Enumerable`モジュールをincludeしているので、map, selectなどの便利なメソッドがディレクトリエントリに対して使えます。

{% highlight ruby %}
>> d.map {|ent| "%d:%s" % [ent.size, ent.name]}
=> ["102:bin", "43:gem_project", "869:gem_project.gemspec", "96:Gemfile", "136:lib", "102:gem_project", "42:version.rb", "80:gem_project.rb", "1064:LICENSE.txt", "117:Rakefile", "508:README.md", "136:spec", "206:gem_project_spec.rb", "81:spec_helper.rb"]
>> puts d.select {|ent| ent.file? }
F: gem_project
F: gem_project.gemspec
F: Gemfile
F: version.rb
F: gem_project.rb
F: LICENSE.txt
F: Rakefile
F: README.md
F: gem_project_spec.rb
F: spec_helper.rb                   #=> nil
{% endhighlight %}

`up`, `down`はディレクトリの階層を移動します。
{% highlight ruby %}
>> lib = d.down('lib')
>> lib.info #=> {:directories=>1, :files=>2, :depth=>2}
>> puts lib.entries
D: gem_project
F: gem_project.rb   #=> nil
{% endhighlight %}

で、`to_dot`です。to_dotは基本的にGvizのオブジェクトを返します。Gvizオブジェクトはputsすると生成されたDOTデータを吐きます。

{% highlight ruby %}
>> d.to_dot.class #=> Gviz
>> puts d.to_dot #=> nil
digraph G {
  layout="dot";
  866200300794894346[label="bin",shape="ellipse",color="3",fontcolor="black"];
  -1429329569930946693[label="gem_project.gemspec",shape="ellipse",color="3",fontcolor="black"];
  2115984733485499187[label="Gemfile",shape="ellipse",color="3",fontcolor="black"];
  -3614298417482850489[label="lib",shape="ellipse",color="3",fontcolor="black"];
  -3184207857630325133[label="LICENSE.txt",shape="ellipse",color="3",fontcolor="black"];
  -4419621440078560366[label="Rakefile",shape="ellipse",color="3",fontcolor="black"];
  -4122678336619934219[label="README.md",shape="ellipse",color="3",fontcolor="black"];
  3938812965865281884[label="spec",shape="ellipse",color="3",fontcolor="black"];
  -836275752370073350[label="gem_project",shape="ellipse",color="4",fontcolor="black"];
  1988668566619024527[label="gem_project",shape="ellipse",color="2",fontcolor="black"];
  -1001180075471808653[label="gem_project",shape="ellipse",color="2",fontcolor="black"];
  3934351981608848895[label="gem_project.rb",shape="ellipse",color="2",fontcolor="black"];
  2453083216909575357[label="version.rb",shape="ellipse",color="1",fontcolor="black"];
  2899348101810456306[label="gem_project_spec.rb",shape="ellipse",color="2",fontcolor="black"];
  3060308287118039450[label="spec_helper.rb",shape="ellipse",color="2",fontcolor="black"];
  -836275752370073350 -> 866200300794894346;
  -836275752370073350 -> -1429329569930946693;
  -836275752370073350 -> 2115984733485499187;
  -836275752370073350 -> -3614298417482850489;
  -836275752370073350 -> -3184207857630325133;
  -836275752370073350 -> -4419621440078560366;
  -836275752370073350 -> -4122678336619934219;
  -836275752370073350 -> 3938812965865281884;
  866200300794894346 -> 1988668566619024527;
  -3614298417482850489 -> -1001180075471808653;
  -3614298417482850489 -> 3934351981608848895;
  -1001180075471808653 -> 2453083216909575357;
  3938812965865281884 -> 2899348101810456306;
  3938812965865281884 -> 3060308287118039450;
}
{% endhighlight %}

ファイルに保存したい場合は`save`します。

{% highlight ruby %}
>> d.to_dot.save(:mydotfile) #=> nil
{% endhighlight %}

to_dotは先程の例のようにオプションを取れます。オプションはハッシュで渡します。

Mac限定の機能として、`open => true`を渡すとtempfileを生成してGraphvizを自動で起動するといったものがあります。

{% highlight ruby %}
>> d.to_dot open:true
Graphviz opened tempfile: /var/folders/sk/9h0z77c10g16n_vc0khd_chr0000gn/T/dirfriend20131028-72725-aa866a.dot
=> nil
{% endhighlight %}

![dir_friend noshadow]({{ BASE_PATH }}/assets/images/2013/10/prj_tree1.png)

<del>残念がらこの機能はコマンドでは実現できていません（泣）help me.</del>

    追記：help meと書いたら@rosylillyさんがプルリクで助けてくれました。これによりMac限定ですが、dotコマンドにおいて生成したDotファイルは自動でオープンされるようになりました。スバラシイ！

> [Add a 'with_open' option to a 'dot' subcommand by rosylilly · Pull Request #1 · melborne/dir_friend](https://github.com/melborne/dir_friend/pull/1 "Add a `with_open` option to a `dot` subcommand by rosylilly · Pull Request #1 · melborne/dir_friend")

説明は以上です。

あなたのプロジェクトもDirFriendで視覚化してみませんか？

---

(追記：2013-10-29) 対象Rubyバージョンなどについて記述を追加しました。

(追記：2013-10-29) MacでDotファイルを自動オープンする記述について追加しました。

---

<p style='color:red'>=== Ruby関連電子書籍100円で好評発売中！ ===</p>

[M'ELBORNE BOOKS]({{ BASE_PATH }}/books/ "M'ELBORNE BOOKS")

<a href="{{ BASE_PATH }}/books/">
  <img src="/assets/images/2013/02/ruby_object_cover.png" alt="ruby_object" style="width:200px" />
</a>
<a href="{{ BASE_PATH }}/books/">
  <img src="/assets/images/2013/04/ruby_tutorial_cover.png" alt="ruby_tutorial" style="width:200px" />
</a>
<a href="{{ BASE_PATH }}/books/">
  <img src="/assets/images/2013/03/ruby_trivia_cover.png" alt="ruby_trivia" style="width:200px" />
</a>


