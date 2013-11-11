---
layout: post
title: "Rubyのソースディレクトリも視覚化してみる"
description: ""
category: 
tags: 
date: 2013-10-21
published: true
---
{% include JB/setup %}

(追記：2013-11-01) 本機能をGem化しました。良かったら使ってみてください。

> [あなたのプロジェクトを美しく視覚化する]({{ BASE_PATH }}/2013/10/28/visualize-your-directory/ "あなたのプロジェクトを美しく視覚化する")

---

前の前の前の記事でCRubyのクラスツリーをGraphvizを使って視覚化した。

> [RubyユニバースをGraphvizで視覚化する]({{ BASE_PATH }}/2013/10/18/visualize-ruby-tree-with-graphviz/ "RubyユニバースをGraphvizで視覚化する")

前の前の記事でRubiniusのクラスツリーをGraphvizを使って視覚化した。

> [Rubiniusユニバースも視覚化してみる]({{ BASE_PATH }}/2013/10/19/visualize-rubinius-tree/ "Rubiniusユニバースも視覚化してみる")

前の記事でJRubyのクラスツリーをGraphvizを使って視覚化した。

> [JRubyユニバースも視覚化してみる](http://melborne.github.io/2013/10/20/visualize-jruby-tree/ "JRubyユニバースも視覚化してみる")

そうしたら今度はRubyのソースのディレクトリ構造も見てみたくなったのでやってみることにした。

## F・Dクラスの定義

Ruby組み込みのFileクラスとDirクラスを使ってRubyのソースディレクトリをトラバースしてもいいけれど折角だからファイルとディレクトリを表現する専用のオブジェクトを作ってそれでやることにした。

まずはファイルを表現するFクラスを定義する。

{% highlight ruby %}
# dir.rb
class F
  attr_reader :name, :path
  def initialize(name)
    @name = File.basename(name)
    @path = File.expand_path(name)
  end

  def to_s
    "F: #{name}"
  end
end

puts F.new('a.txt')
# >> F: a.txt
{% endhighlight %}

次にFクラスを継承してディレクトリを表現するDクラスを定義する。

{% highlight ruby %}
# dir.rb
class D < F
  attr_reader :entries
  def initialize(name)
    super(name)
    @entries = []
    build
    self
  end

  def <<(file)
    @entries << file
  end

  def to_s
    "D: #{name} => [#{entries.join(', ')}]"
  end
  
  private
  def build
    entries = Dir[File.join(path, '*')]
    entries.each do |ent|
      self << begin
        File.directory?(ent) ? D.new(ent) : F.new(ent)
      end
    end
  end
end

if __FILE__ == $0
  puts D.new(ARGV[0])
end
{% endhighlight %}

`@entries`はそのディレクトリ内のエントリのリストを保持する。エントリのリストは`D#build`で初期化時に生成する。#buildにおいてDir.[]でリストを求め、個々にFile.directory?を使ってディレクトリかファイルかを判断する。その結果に応じてDオブジェクトまたはFオブジェクトを生成し@entriesに入れる。ここでDオブジェクトの生成はまた#buildを呼ぶので、ディレクトリが無くなるまでこれは再帰的に繰り返されることとなる。

以下のようなディレクトリ構造を作って試してみる。

{% highlight bash %}
% tree A
A
├── a
├── b
├── c
└── d
    ├── e
    ├── f
    └── g
        ├── h
        └── i

2 directories, 7 files
{% endhighlight %}

実行する。

{% highlight bash %}
% ruby dir.rb A
D: A => [F: a, F: b, F: c, D: d => [F: e, F: f, D: g => [F: h, F: i]]]
{% endhighlight %}

ディレクトリが入れ子で表現されている。いいようだ。

`D#each`も定義する。Gvizで扱いやすいように#eachは対象ディレクトリに含まれるファイルだけでなく、その下位の全ファイルをトラバースできるよう実装する。

{% highlight ruby %}
class D < F

  def each(&blk)
    entries.each do |e|
      blk.call(e)
      e.each(&blk) if e.is_a?(D)
    end
  end

end

if __FILE__ == $0
  d = D.new(ARGV[0])
  d.each { |e| puts e }
end
{% endhighlight %}

ちょっと分かりづらいコードだが、entriesに含まれるものがディレクトリの場合には再帰的に#eachを読んで渡されたブロックを実行できるようにしている。この出力は次のようになる。


{% highlight bash %}
% ruby dir.rb A
F: a
F: b
F: c
D: d => [F: e, F: f, D: g => [F: h, F: i]]
F: e
F: f
D: g => [F: h, F: i]
F: h
F: i
{% endhighlight %}


## Gvizによる描画

下準備ができたのでGvizを使ってディレクトリ構造を描画してみる。描画用コードを書く。

{% highlight ruby %}
#ruby_dir.rb
require 'gviz'
require './dir'

root = D.new(ARGV[0]||'.')

rid = root.path.to_id
ent_ids = root.entries.map { |e| e.path.to_id }

Graph do
  route rid => ent_ids
  node rid, label:root.name               # ルートノードの作成
  
  root.each do |f|
    id = f.path.to_id
    case f
    when D
      ent_ids = f.entries.map { |e| e.path.to_id }
      route id => ent_ids                 # エッジの作成
      node id, label:f.name, shape:'box'  # ディレクトリノードの作成
    when F
      node id, label:f.name               # ファイルノードの作成
    end
  end

  save :ruby_dir, :png
end
{% endhighlight %}

注意点はFはDのsuperclassだからcase式でFよりもDを先に判定することだ。

ファイルを実行して生成されたpngを開く。

{% highlight bash %}
% ruby ruby_dir.rb A
% open ruby_dir.png
{% endhighlight %}

![ruby_dir noshadow]({{ BASE_PATH }}/assets/images/2013/10/ruby_dir1.png)


上手くいったようなので、こんどは着色してみる。

F#levelを導入してファイルの階層レベルを表現する。

{% highlight ruby %}
class F
+ attr_reader :name, :path, :level
+ def initialize(name, level=0)
    @name = File.basename(name)
    @path = File.expand_path(name)
+   @level = level
  end

  def to_s
    "F: #{name}"
  end
end

class D < F
  attr_reader :entries
+ def initialize(name, level=0)
+   super(name, level)
    @entries = []
    build
    self
  end

  def <<(file)
    @entries << file
  end

  def each(&blk)
    entries.each do |e|
      blk.call(e)
      e.each(&blk) if e.is_a?(D)
    end
  end

  def to_s
    "D: #{name} => [#{entries.join(', ')}]"
  end
  
  private
  def build
    entries = Dir[File.join(path, '*')]
    entries.each do |ent|
      self << begin
+       File.directory?(ent) ? D.new(ent, level+1) : F.new(ent, level+1)
      end
    end
  end
end

if __FILE__ == $0
  d = D.new(ARGV[0]||'.')
  d.each { |e| puts [e, e.level].join("/") }
end
{% endhighlight %}

色付けのためのコードを足す。

{% highlight ruby %}
 require 'gviz'
 require './dir'
 
 root = D.new(ARGV[0]||'.')
 
 rid = root.path.to_id
 ent_ids = root.entries.map { |e| e.path.to_id }
+rc = 9 - root.level
 
 Graph do
+  nodes colorscheme:'rdpu9', style:'filled'
 
   route rid => ent_ids
+  node rid, label:root.name, color:rc, fillcolor:rc, fontcolor:'white'
   
   root.each do |f|
     id = f.path.to_id
+    c = 9 - f.level
+    c = 1 if c < 1 
+    fc = c < 4 ? 'black' : 'white'
     case f
     when D
       ent_ids = f.entries.map { |e| e.path.to_id }
       route id => ent_ids
+      node id, label:f.name, shape:'box', color:c, fillcolor:c, fontcolor:fc
     when F
+      node id, label:f.name, color:c, fillcolor:c, fontcolor:fc
     end
   end
 
   save :ruby_dir
 end
{% endhighlight %}

実行してファイルを開いてみる。

![ruby_dir noshadow]({{ BASE_PATH }}/assets/images/2013/10/ruby_dir2.png)

## Rubyソースディレクトリの描画

さて、やっと下準備ができたのでRubyのソースのパスを渡してみる。

{% highlight bash %}
% ruby ruby_dir.rb ruby-2.0.0-p0/
{% endhighlight %}

417268x923pixel、25MBの巨大なpngができた。dotは扱えるがpngは巨大すぎて扱えない。


（DOTの一部をキャプチャ）

{% lightbox  2013/10/ruby_dir5.png, ruby_dir, alt noshadow %}
（クリックで拡大）


Ruby全体のファイル数を数えてみる。

{% highlight bash %}
% tree ruby-2.0.0-p0
ruby-2.0.0-p0
├── BSDL
├── COPYING
├── COPYING.ja
├── ChangeLog
├── GPL
├── KNOWNBUGS.rb

440 directories, 4057 files
{% endhighlight %}

無謀だった。

---

全体像はあきらめてディレクトリの深い階層は切り捨てて描画することを考える。

トラバースするディレクトリ階層を限定できるよう`depth`の概念を入れる。Dクラスを修正する。

{% highlight ruby %}
class D < F
  attr_reader :entries
+ def initialize(name, level=0, depth=Float::MAX.to_i)
    super(name, level)
    @entries = []
+   build(depth) if depth >= 1
    self
  end

  def <<(file)
    @entries << file
  end

  def each(&blk)
    entries.each do |e|
      blk.call(e)
      e.each(&blk) if e.is_a?(D)
    end
  end

  def to_s
    "D: #{name} => [#{entries.join(', ')}]"
  end
  
  private
  def build(depth)
    entries = Dir[File.join(path, '*')]
    entries.each do |ent|
      self << begin
+       File.directory?(ent) ? D.new(ent, level+1, depth-1) : F.new(ent, level+1)
      end
    end
  end
end
{% endhighlight %}

ruby_dir.rbのほうでは第2引数でdepthを取れるよう修正する。

{% highlight ruby %}
root = D.new(ARGV[0]||'.', 0, (ARGV[1]||Float::MAX).to_i)
{% endhighlight %}

`depth=3`くらいでやってみる。

{% highlight bash %}
% ruby ruby_dir.rb ruby-2.0.0-p0 3
{% endhighlight %}

378663x347pixel、13MBの巨大なpngができた。巨大すぎて扱えない。


今度は描画レイアウトを前回同様`fdp`に変えて`depth=2`で試してみる。

{% highlight ruby %}
Graph do
+ global layout:'fdp'
  nodes colorscheme:'rdpu9', style:'filled'

end
{% endhighlight %}

実行して開く。

{% highlight bash %}
% ruby ruby_dir.rb ruby-2.0.0-p0 2
% open ruby_dir.png
{% endhighlight %}

...なかなか開かないけど...開く。

{% lightbox  2013/10/ruby_dir7.png, ruby_dir, alt noshadow %}
（クリックで拡大）

キレイだが相当拡大しないと依然細部が見えないので、トップレベルだけで描画してみる。

{% highlight bash %}
% ruby ruby_dir.rb ruby-2.0.0-p0 1
% open ruby_dir.png
{% endhighlight %}

これくらいなら拡大すればWeb上でも細部が見える。

{% lightbox  2013/10/ruby_dir8.png, ruby_dir, alt noshadow %}
（クリックで拡大）

この絵の中に以下のファイルが含まれている。これでも相当な数だ。

{% highlight bash %}
% ls ruby-2.0.0-p0
BSDL             encdb.h          nacl             sprintf.c
COPYING          encoding.c       newline.c        st.c
COPYING.ja       enum.c           node.c           strftime.c
ChangeLog        enumerator.c     node.h           string.c
GPL              error.c          node_name.inc    struct.c
KNOWNBUGS.rb     eval.c           numeric.c        symbian
LEGAL            eval_error.c     object.c         template
Makefile.in      eval_intern.h    opt_sc.inc       test
NEWS             eval_jump.c      optinsn.inc      thread.c
README           ext              optunifs.inc     thread_pthread.c
README.EXT       file.c           pack.c           thread_pthread.h
README.EXT.ja    gc.c             parse.c          thread_win32.c
README.ja        gc.h             parse.h          thread_win32.h
addr2line.c      gem_prelude.rb   parse.y          time.c
addr2line.h      golf_prelude.c   prelude.rb       timev.h
array.c          golf_prelude.rb  probes.d         tool
bcc32            goruby.c         probes.dmyh      transcode.c
benchmark        hash.c           probes_helper.h  transcode_data.h
bignum.c         ia64.s           proc.c           transdb.h
bin              id.c             process.c        util.c
bootstraptest    id.h             random.c         variable.c
class.c          include          range.c          version.c
common.mk        inits.c          rational.c       version.h
compar.c         insns.def        re.c             vm.c
compile.c        insns.inc        regcomp.c        vm.inc
complex.c        insns_info.inc   regenc.c         vm_backtrace.c
configure        internal.h       regenc.h         vm_core.h
configure.in     io.c             regerror.c       vm_debug.h
constant.h       iseq.c           regexec.c        vm_dump.c
cont.c           iseq.h           regint.h         vm_eval.c
cygwin           known_errors.inc regparse.c       vm_exec.c
debug.c          lex.c            regparse.h       vm_exec.h
defs             lex.c.blt        regsyntax.c      vm_insnhelper.c
dir.c            lib              revision.h       vm_insnhelper.h
dln.c            load.c           ruby.c           vm_method.c
dln.h            main.c           ruby_atomic.h    vm_opts.h
dln_find.c       man              safe.c           vm_trace.c
dmydln.c         marshal.c        sample           vmtc.inc
dmyencoding.c    math.c           signal.c         vsnprintf.c
dmyext.c         method.h         siphash.c        win32
dmyversion.c     miniprelude.c    siphash.h
doc              misc             sparc.c
enc              missing          spec

22 directories, 147 files。
{% endhighlight %}

今度は`lib`ディレクトリ内を階層を限定しないで描画してみる。

{% highlight bash %}
% ruby ruby_dir.rb ruby-2.0.0-p0/lib
% open ruby_dir.png
{% endhighlight %}


{% lightbox  2013/10/ruby_dir9.png, ruby_dir, alt noshadow %}
（クリックで拡大）

libの中だけでも64 directories, 639 filesが含まれている。

{% highlight bash %}
% tree ruby-2.0.0-p0/lib
ruby-2.0.0-p0/lib
├── English.rb
├── abbrev.rb
├── base64.rb
├── benchmark.rb
├── cgi
│   ├── cookie.rb
│   ├── core.rb
│   ├── html.rb
│   ├── session
│   │   └── pstore.rb
│   ├── session.rb
│   └── util.rb
├── cgi.rb

64 directories, 639 files
{% endhighlight %}

## やっぱりRubyの全体像をWebで

でここまできてSVGという手があるのを思い出す。`save`で:pngに代えて:svgを渡してやってみる。

{% highlight bash %}
% ruby ruby_dir.rb ruby-2.0.0-p0
% open ruby_dir.svg
{% endhighlight %}

成功！

Rubyの巨大な世界をどうぞご覧ください！


（クリックで別ファイルが開きます）

<a href="{{ BASE_PATH }}/assets/images/2013/10/ruby_dir.svg" title="Ruby Dir"><img src="{{ BASE_PATH }}/assets/images/2013/10/ruby_dir10.png" alt="ruby_dir noshadow" /></a>

---

{% gist 7077236 %}

---

関連記事：

[Yet Another Ruby Graphviz Interfaceを作ったからみんなで大量のグラフを作って遊ぼうよ！]({{ BASE_PATH }}/2012/09/25/ruby-plus-graphviz-should-eql-gviz/ "Yet Another Ruby Graphviz Interfaceを作ったからみんなで大量のグラフを作って遊ぼうよ！")

