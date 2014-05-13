---
layout: post
title: "Atom.ioの公式サイトにおける「Creating Packages」ドキュメントをMarkdownにしてKobitoでプレビューしつつVimで編集して勝手翻訳版を作ったので公開しますそして僕のメインエディタはTextMateですorz"
description: ""
category: 
tags: 
date: 2014-03-22
published: true
---
{% include JB/setup %}

## Atomについて

[GitHub](https://github.com/ "GitHub")の相当**ヤバイ**エディタ「[Atom](https://atom.io/ "Atom")」のβ版が公開されています。まだ、スニペットの動作やマルチバイト文字の扱いがうまくないなど問題がありますが、謳い文句通り、21世紀の大本命エディタになるのは間違いなさそうです。Sublimeで挫折した僕もやる気になっています(いまのところ)。

Atomにはパッケージ(Package)という拡張機能があり、コアの相当部分もこの拡張パッケージで構成されているそうです。Atomは[Chromium](http://ja.wikipedia.org/wiki/Chromium "Chromium - Wikipedia")というブラウザ技術をベースに作られており、パッケージはNode.jsのモジュールをCoffeeScriptで書くことで作成します。

つまり「パッケージを制する者、Atomを制する者」となり、パッケージを作ればNode.jsとCoffeeScriptの知識も一緒に付いてくるという、お得感の高い投資になっています。


パッケージ作りの最初の一歩は、公式サイトにおけるASCIIで3D文字を作るチュートリアル「[Create Your First Package](https://atom.io/docs/v0.75.0/your-first-package "Create Your First Package")」を一通りやることでしょう。そして、次の一歩は公式における「[Creating Packages](https://atom.io/docs/v0.75.0/creating-a-package "Creating Packages")」を読むということになりそうです。

で、まあ学習ついでに「Creating Packagesの翻訳があったら嬉しいよね」ということで、勝手に翻訳してgistしました。

> [Translation of Creating Packages](https://gist.github.com/melborne/9703653#file-atom_creating_a_package-ja-md "Atom.io Document Translations")

当然に、誤訳、ケアレスミスが含まれています。不明箇所は原文を参照頂くか、コメントでご指摘頂けると助かります。因みに翻訳ドキュメントには原文がコメントの形で挿入されています。

## 翻訳文の作り方

一応、翻訳文の作成プロセスも書いておきます。次の手順を経ます。

1. [Pandoc](http://johnmacfarlane.net/pandoc/index.html "Pandoc - About pandoc")で原文を取得およびMarkdown変換する。

2. 拙作[togglate](https://rubygems.org/gems/togglate "togglate \| RubyGems.org \| your community gem host")で訳文のベースドキュメントを生成する。

3. エディタ([Vim](http://www.vim.org/ "welcome home : vim online"))で翻訳文を仕上げる。

### Pandocで原文の取得と変換

以下のコマンドで公式サイトから原文htmlを取得し、Markdownに変換したファイル(atom_creating_a_package.md)を得ます。

    % pandoc -s -r html https://atom.io/docs/latest/creating-a-package -o atom_creating_a_package.md

-rオプション(read)にhtmlを指定し、-oオプション(output)にMarkdownの拡張子付きでファイル名を渡します。このやり方は@harupongさんに教えて頂きました。

> [Twitter / harupong: @merborne "pandoc -s -r html ...](https://twitter.com/harupong/status/436670767497891840 "Twitter / harupong: @merborne "pandoc -s -r html ...")

### togglateで翻訳のベースドキュメントを生成

次に、`atom_creating_a_package.md`における不要部分を消してから、以下のコマンドでベースドキュメントを生成します。

    % togglate create atom_creating_a_package.md -t=to:ja > atom_creating_a_package.ja.md

-tオプション(translate)に`to:ja`することで、英語から日本語への機械翻訳が挿入されるようになります。`atom_creating_a_package.ja.md`の最初の部分はこんな感じになります。

    パッケージは、Atomの中核である。メインエディタの外側のほぼすべては、パッケージによって処理されます。つまり、[ファイルツリー]（https://github.com/atom/tree-view）、[ステータスバー]（https://github.com/atom/status-bar）、[構文のような「コア」の部分を含んでいる（https://github.com/atom/language-coffee-script）]の強調表示などがあります。
    
    <!--original
    Packages are at the core of Atom. Nearly everything outside of the main
    editor is handled by a package. That includes "core" pieces like the
    [file tree](https://github.com/atom/tree-view), [status
    bar](https://github.com/atom/status-bar), [syntax
    highlighting](https://github.com/atom/language-coffee-script), and more.
    -->
    
    パッケージは、アトムの動作を変更するために異なるリソースタイプの様々を含むことができる。次のように基本的なパッケージレイアウトは、次のとおりです。
    
    <!--original
    A package can contain a variety of different resource types to change
    Atom's behavior. The basic package layout is as follows:
    -->

詳しくは以下を参照ください。

> [翻訳ドキュメント作成支援ツールTogglateで翻訳要らず？]({{ BASE_URL }}/2014/02/25/togglate-meets-mymemory/ "翻訳ドキュメント作成支援ツールTogglateで翻訳要らず？")

### Vimで翻訳文の仕上げ

さすがに機械翻訳そのままでは使えないので、原文を参照にしながら翻訳文を直します。僕は日本語編集にはVimを使っています。今回は同時に[Kobito](http://kobito.qiita.com/ "Kobito")でMarkdownプレビューを表示しながら編集してみました。Kobitoはリアルタイムプレビューの機能があるので、Vimで編集すると直ちにそれが反映されて便利です。

---

というわけで、「Atom.ioの公式サイトにおける「Creating Packages」ドキュメントをMarkdownにしてKobitoでプレビューしつつVimで編集して勝手翻訳版を作ったので公開します」、でした。


参考記事：

> [GitHub 製エディタ Atom リファレンス - Qiita](http://qiita.com/spesnova/items/d3096d062d70e7385e9d "GitHub 製エディタ Atom リファレンス - Qiita")

> [Github製エディタAtomでパッケージを作ってみた - stanaka's blog](http://blog.stanaka.org/entry/2014/03/03/225327 "Github製エディタAtomでパッケージを作ってみた - stanaka's blog")


---

<p style='color:red'>=== Ruby関連電子書籍100円〜で好評発売中！ ===</p>

[M'ELBORNE BOOKS]({{ BASE_PATH }}/books/ "M'ELBORNE BOOKS")

<a href="{{ BASE_PATH }}/books/">
  <img src="/assets/images/books/rack_cover.png" alt="rack" style="width:200px" />
</a>
<a href="{{ BASE_PATH }}/books/">
  <img src="/assets/images/books/ruby_pack8.png" alt="pack8" style="width:200px" />
</a>
<a href="{{ BASE_PATH }}/books/">
  <img src="/assets/images/books/ruby_parallel_cover.png" alt="ruby_parallel" style="width:200px" />
</a>
