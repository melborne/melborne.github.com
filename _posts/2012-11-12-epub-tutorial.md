---
layout: post
title: "エラーメッセージから学ぶ電子書籍EPUB - 最初の一歩"
description: ""
category: 
tags: [epub] 
date: 2012-11-12
published: true
---
{% include JB/setup %}

ソフトウェア（プログラム）は中間を飲み込みます。ソフトウェアによって電話交換手が消えました。株仲買人が消えました。写植屋さんが消えました。Amazonの登場で書店の経営は厳しさを増しています。ソフトウェアは市場において、発信者と受信者が円滑にコミュニケートするためのいくつもの障壁を、次々と飲み込んでいるのです。

そして電子書籍です。EPUBです。EPUBは言うなればソフトウェアで構成された電子出版社です。それは本の著者と読者を直接結びます。それは既存の出版社は言うに及ばず、Amazonにとっても脅威となりうる存在なのです...

----

と言ってみたものの...


僕自身はEPUBのことがよくわかっていません^ ^;


でも、いつまでもそう言ってもいられないでしょう。


そんなわけで...

EPUBについて最初の一歩を踏み出したので、ここに記録としてまとめておきます。環境はMac OSX 10.8.2です。長い記事になります。

## EPUB

WikipediaはEPUBについて次のように書いています。


    EPUBは、HTMLやウェブブラウザのオープン性を保持しつつ、インターネット接続が切断された状態の携帯情報端末 (PDA) やノートパソコンなどでも電子書籍の閲覧が継続できるようにダウンロード配信を前提にパッケージ化された、XHTMLのサブセット的なファイル・フォーマット規格であり、画面の大きさに合わせて表示を調整する「リフロー機能」が特徴である。

[EPUB - Wikipedia](http://ja.wikipedia.org/wiki/EPUB 'EPUB - Wikipedia')



やっぱりよくわかりませんが、たぶんそれは、XHTMLフォーマットで書かれた文章をZIPか何かでまとめたアーカイブファイルだと理解します。


##エラーメッセージから学ぶ

古くからの格言の一つに「EPUBのことはEpubcheckに聞け」というものがあります。EPUBがわからないので、この格言に従いEpubcheckに聞いてみることにします。

## Epubcheckのダウンロード
以下のサイトからEpubcheckをダウンロードして、EPUBを作るディレクトリ下に置きます。

[Downloads - epubcheck - Validation tool for EPUB](http://code.google.com/p/epubcheck/downloads/list 'Downloads - epubcheck - Validation tool for EPUB - Google Project Hosting')

## コンテンツの準備
コンテンツがなければ話になりません。

表紙、目次、チャプター１，２からなるチャーリーの物語を用意します。XHTMLでコンテンツを作るなんて最初から死ににいくようなものですから、ここではMarkdownを使います。

{% highlight bash %}
% touch front.md toc.md chapter{01,02}.md        
% tree
.
├── chapter01.md
├── chapter02.md
├── front.md
└── toc.md
{% endhighlight %}

各ファイルの中身です。

front.md
{% highlight xml %}
# チャーリーの本の冒険

## チャーリー　著
{% endhighlight %}

toc.md
{% highlight xml %}
# 目次

## チャーリーの本の冒険

[第一章：チャーリーについて](chapter01.xhtml)

[第二章：本の冒険について](chapter02.xhtml)
{% endhighlight %}


chapter01.md
{% highlight xml %}
# 第一章：チャーリーについて

## チャーリーの呪文
チャーリーが呪文を唱えた。

Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.

## チャーリーのいびき
チャーリーのいびきはうるさい。

Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.
{% endhighlight %}

chapter02.md
{% highlight xml %}
# 第二章：本の冒険について

## 本
チャーリーが乱暴に本を開いたら、大きな音がした。
Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.

## 冒険
そして、チャーリーは長い長い冒険に出かけた。長い長い歌を口ずさみながら。Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.
{% endhighlight %}

## MarkdownからXHTMLへ
ここでは[Maruku](http://maruku.rubyforge.org/index.html 'Maruku: a Markdown-superset interpreter')というRuby製のconverterを使って、先のコンテンツをXHTMLに変換します。なければ`gem install maruku`します。

{% highlight bash %}
% maruku front.md
% maruku toc.md
% maruku chapter01.md
% maruku chapter02.md
{% endhighlight %}

それぞれ同名のhtmlファイルができているので、それらをxhtmlにリネイムします。

{% highlight bash %}
% mv front.html front.xhtml
% mv toc.html toc.xhtml
% mv chapter01.html chapter01.xhtml
% mv chapter02.html chapter02.xhtml
{% endhighlight %}

変換後のファイルは次のようになっています。front.xhtmlだけ示します。

front.xhtml
{% highlight xml %}
<?xml version="1.0" encoding="utf-8"?>
<!DOCTYPE html PUBLIC
    "-//W3C//DTD XHTML 1.1 plus MathML 2.0 plus SVG 1.1//EN"
    "http://www.w3.org/2002/04/xhtml-math-svg/xhtml-math-svg.dtd">
<html xml:lang='en' xmlns:svg='http://www.w3.org/2000/svg' xmlns='http://www.w3.org/1999/xhtml'>
<head><meta content='application/xhtml+xml;charset=utf-8' http-equiv='Content-type' /><title>チャーリーの本の冒険</title></head>
<body>
<h1 id='id1'>チャーリーの本の冒険</h1>

<h2 id='id2'>チャーリー　著</h2>
</body></html>
{% endhighlight %}

## charlie.epubにパッケージ化
さあ、コンテンツが用意できたので、ZIPを使って`charlie.epub`というファイルにまとめます。

{% highlight bash %}
% zip charlie.epub *.xhtml
  adding: chapter01.xhtml (deflated 62%)
  adding: chapter02.xhtml (deflated 58%)
  adding: front.xhtml (deflated 24%)
  adding: toc.xhtml (deflated 38%)
{% endhighlight %}

## Epubcheckで検証
さあEPUBファイルができたので、Epubcheckしてみます。

{% highlight bash %}
% java -jar epubcheck-3.0-RC-1/epubcheck-3.0-RC-1.jar charlie.epub
Epubcheck Version 3.0-RC-1

ERROR: charlie.epub: Length of the first filename in archive must be 8, but was 15
ERROR: charlie.epub: Required META-INF/container.xml resource is missing

Check finished with warnings or errors
{% endhighlight %}

２つのエラーが報告されました。アーカイブの最初のファイル名は８文字でなければならないと言っています。また、`META-INF/container.xml`が無いと言っています。

## mimetype

調べたところ`mimetype`という８文字のファイルが必要なことがわかりました。追加します。

{% highlight bash %}
% touch mimetype
% zip charlie.epub mimetype
  adding: mimetype (stored 0%)
{% endhighlight %}

２つ目のエラーに対応する前にもう一度Epubcheckチェックします。

{% highlight bash %}
% java -jar epubcheck-3.0-RC-1/epubcheck-3.0-RC-1.jar charlie.epub
Epubcheck Version 3.0-RC-1

ERROR: charlie.epub: Length of the first filename in archive must be 8, but was 15
ERROR: charlie.epub: Required META-INF/container.xml resource is missing

Check finished with warnings or errors
{% endhighlight %}

変化がありません。アーカイブの中身を見てみます。

{% highlight bash %}
% unzip -v charlie.epub 
Archive:  charlie.epub
 Length   Method    Size  Ratio   Date   Time   CRC-32    Name
 --------  ------  ------- -----   ----   ----   ------    ----
 1134  Defl:N      426  62%  11-11-12 23:01  c908417c  chapter01.xhtml
 1168  Defl:N      493  58%  11-11-12 23:01  6c07547b  chapter02.xhtml
   72  Defl:N       55  24%  11-11-12 23:00  3f0e329a  front.xhtml
  210  Defl:N      131  38%  11-11-12 23:01  7f9384c2  toc.xhtml
    0  Stored        0   0%  11-11-12 23:08  00000000  mimetype
 --------      -------  ---                            -------
 2584             1105  57%                            5 files
{% endhighlight %}

mimetypeが先頭ファイルになってませんでした。

コンテンツファイル群をディレクトリに放り投げて対応します。ディレクトリ名はなんでもいいですが、「Open EBook Publication Structure」に基いて`OEBPS`とします。

{% highlight bash %}
% mkdir OEBPS
% mv *.xhtml OEBPS                                         
% tree
.
├── OEBPS
│   ├── chapter01.xhtml
│   ├── chapter02.xhtml
│   ├── front.xhtml
│   └── toc.xhtml
├── charlie.epub
└── mimetype
{% endhighlight %}

アーカイブからコンテンツファイルを削除し、OEBPS下のものを追加します。
{% highlight bash %}
% zip -d charlie.epub front.xhtml toc.xhtml chapter01.xhtml chapter02.xhtml
  deleting: chapter01.xhtml
  deleting: chapter02.xhtml
  deleting: front.xhtml
  deleting: toc.xhtml

% zip charlie.epub OEBPS/*
  adding: OEBPS/chapter01.xhtml (deflated 62%)
  adding: OEBPS/chapter02.xhtml (deflated 58%)
  adding: OEBPS/front.xhtml (deflated 24%)
  adding: OEBPS/toc.xhtml (deflated 38%)

% unzip -v charlie.epub
Archive:  charlie.epub Length   Method    Size  Ratio   Date   Time   CRC-32    Name
--------  ------  ------- -----   ----   ----   ------    ----
   0  Stored        0   0%  11-11-12 23:08  00000000  mimetype
1134  Defl:N      426  62%  11-11-12 23:01  c908417c  OEBPS/chapter01.xhtml
1168  Defl:N      493  58%  11-11-12 23:01  6c07547b  OEBPS/chapter02.xhtml
  72  Defl:N       55  24%  11-11-12 23:00  3f0e329a  OEBPS/front.xhtml
 210  Defl:N      131  38%  11-11-12 23:01  7f9384c2  OEBPS/toc.xhtml
--------      -------  ---                            -------
2584             1105  57%                            5 files
{% endhighlight %}

再度検証します。

{% highlight bash %}
% java -jar epubcheck-3.0-RC-1/epubcheck-3.0-RC-1.jar charlie.epub
Epubcheck Version 3.0-RC-1

ERROR: charlie.epub: Extra field length for first filename must be 0, but was 28
ERROR: charlie.epub: Required META-INF/container.xml resource is missing

Check finished with warnings or errors
{% endhighlight %}

mimetypeのExtra fieldの長さが０じゃないと言っています。これに対処するには、zipコマンドに-X(大文字)を付ければいいようです{% fn_ref 1 %}。

{% highlight bash %}
% zip -X charlie.epub mimetype
  updating: mimetype (stored 0%)

% java -jar epubcheck-3.0-RC-1/epubcheck-3.0-RC-1.jar charlie.epub
Epubcheck Version 3.0-RC-1

ERROR: charlie.epub: Mimetype contains wrong type (application/epub+zip expected).
ERROR: charlie.epub: Required META-INF/container.xml resource is missing

Check finished with warnings or errors
{% endhighlight %}

こんどはmimetypeに`application/epub+zip`と書けといっているので、従います。

{% highlight bash %}
% echo application/epub+zip > mimetype 
% zip -X charlie.epub mimetype                                       
updating: mimetype (stored 0%)

% java -jar epubcheck-3.0-RC-1/epubcheck-3.0-RC-1.jar charlie.epub
Epubcheck Version 3.0-RC-1

ERROR: charlie.epub: Required META-INF/container.xml resource is missing

Check finished with warnings or errors
{% endhighlight %}

## META-INF/container.xml

最初のエラーが解消できたので、次のエラーに対処して`META-INF/container.xml`ファイルを追加します。

{% highlight bash %}
% mkdir META-INF
% touch META-INF/container.xml
% zip charlie.epub META-INF/container.xml
  adding: META-INF/container.xml (stored 0%)

% java -jar epubcheck-3.0-RC-1/epubcheck-3.0-RC-1.jar charlie.epub
Epubcheck Version 3.0-RC-1

ERROR: charlie.epub/META-INF/container.xml(1,1): Premature end of file.
ERROR: charlie.epub/META-INF/container.xml: Premature end of file.
ERROR: charlie.epub/META-INF/container.xml: No rootfile with media type 'application/oebps-package+xml'

Check finished with warnings or errors
{% endhighlight %}

お前のファイルは全然ダメだ、rootfileもないし、と言っています。

ググったところcontainer.xmlはコンテンツの所在を示すもののようです。具体的には、コンテンツのメタデータとなるファイル`content.opf`のパスとメディアタイプをroutefileとして指定します。

次のような内容にします。

container.xml
{% highlight xml %}
<?xml version="1.0"?>
<container version="1.0" xmlns="urn:oasis:names:tc:opendocument:xmlns:container">
  <rootfiles>
    <rootfile full-path="OEBPS/content.opf" media-type="application/oebps-package+xml"/>
  </rootfiles>
</container>
{% endhighlight %}

検証します。

{% highlight bash %}
% zip charlie.epub META-INF/container.xml
  updating: META-INF/container.xml (deflated 34%)

% java -jar epubcheck-3.0-RC-1/epubcheck-3.0-RC-1.jar charlie.epub
Epubcheck Version 3.0-RC-1

ERROR: charlie.epub/OEBPS/content.opf: 
ERROR: charlie.epub/OEBPS/content.opf: Version not found
Check finished with warnings or errors
{% endhighlight %}

## OEBPS/content.opf

指し示した`OEBPS/content.opf`が無いと言っているようなので、次のような内容で用意します。

content.opf
{% highlight xml %}
<?xml version="1.0" encoding="UTF-8"?>
<package version="3.0" xmlns="http://www.idpf.org/2007/opf" unique-identifier="BookId">

</package>
{% endhighlight %}
`unique-identifier`はこのパッケージにおける固有IDのようです。適当に付けます。


検証します。

{% highlight bash %}
% zip charlie.epub OEBPS/content.opf            
  adding: OEBPS/content.opf (stored 0%)

% java -jar epubcheck-3.0-RC-1/epubcheck-3.0-RC-1.jar charlie.epub
Epubcheck Version 3.0-RC-1

Validating against EPUB version 3.0
ERROR: charlie.epub/OEBPS/content.opf(4,11): element "package" incomplete; missing required element "metadata"
ERROR: charlie.epub/OEBPS/content.opf(2,88): assertion failed: package element unique-identifier attribute does not resolve to a dc:identifier element (given reference was 'BookId')
ERROR: charlie.epub/OEBPS/content.opf: unique-identifier attribute in package element must reference an existing identifier element id
WARNING: charlie.epub: item (OEBPS/front.xhtml) exists in the zip file, but is not declared in the OPF file
WARNING: charlie.epub: item (OEBPS/chapter01.xhtml) exists in the zip file, but is not declared in the OPF file
WARNING: charlie.epub: item (OEBPS/chapter02.xhtml) exists in the zip file, but is not declared in the OPF file
WARNING: charlie.epub: item (OEBPS/toc.xhtml) exists in the zip file, but is not declared in the OPF file

Check finished with warnings or errors
{% endhighlight %}

幾つかのエラーと幾つかの警告がでました。順番に対処します。

まずはpackageに`metadata`という要素がないといっているので、追加します。それからpackageの`unique-identifier`が`identifier`要素を参照してないといったようなことを言っているので、そう言った要素を追加します。

content.opf
{% highlight xml %}
<?xml version="1.0" encoding="UTF-8"?>
<package version="3.0" xmlns="http://www.idpf.org/2007/opf" unique-identifier="BookId">
  <metadata xmlns:dc="http://purl.org/dc/elements/1.1/" xmlns:dcterms="http://purl.org/dc/terms/" xmlns:opf="http://www.idpf.org/2007/opf">
    <dc:identifier id="BookId">http://charlie.com/BN001</dc:identifier>

  </metadata>
</package>
{% endhighlight %}

検証します。
{% highlight bash %}
% zip charlie.epub OEBPS/content.opf
  updating: OEBPS/content.opf (deflated 43%)

% java -jar epubcheck-3.0-RC-1/epubcheck-3.0-RC-1.jar charlie.epub
Epubcheck Version 3.0-RC-1

Validating against EPUB version 3.0
ERROR: charlie.epub/OEBPS/content.opf(6,14): element "metadata" incomplete; missing required elements "dc:language" and "dc:title"
ERROR: charlie.epub/OEBPS/content.opf(7,11): element "package" incomplete; missing required element "manifest"
ERROR: charlie.epub/OEBPS/content.opf(3,140): assertion failed: package dcterms:modified meta element must occur exactly once
WARNING: charlie.epub: item (OEBPS/front.xhtml) exists in the zip file, but is not declared in the OPF file
WARNING: charlie.epub: item (OEBPS/chapter01.xhtml) exists in the zip file, but is not declared in the OPF file
WARNING: charlie.epub: item (OEBPS/chapter02.xhtml) exists in the zip file, but is not declared in the OPF file
WARNING: charlie.epub: item (OEBPS/toc.xhtml) exists in the zip file, but is not declared in the OPF file

Check finished with warnings or errors
{% endhighlight %}

`dc:language`と`dc:title`要素がmetadataに無い、`manifest`要素がpackageに無い、`dcterms:modified`メタ要素が無いと言っています。また、コンテンツに係るXHTMLファイルがあるのに、ここで宣言されてないと警告しています。まずはエラーに対処します。

content.opf
{% highlight xml %}
<?xml version="1.0" encoding="UTF-8"?>
<package version="3.0" xmlns="http://www.idpf.org/2007/opf" unique-identifier="BookId">
  <metadata xmlns:dc="http://purl.org/dc/elements/1.1/" xmlns:dcterms="http://purl.org/dc/terms/" xmlns:opf="http://www.idpf.org/2007/opf">
    <dc:identifier id="BookId">http://charlie.com/BN001</dc:identifier>
    <dc:title>チャーリーの本の冒険</dc:title>
    <dc:language>ja</dc:language>
    <meta property="dcterms:modified">2012-11-12T00:00:00Z</meta>
  </metadata>
  <manifest>
  
  </manifest>
</package>
{% endhighlight %}

検証します。

{% highlight bash %}
% zip charlie.epub OEBPS/content.opf
  updating: OEBPS/content.opf (deflated 41%)

% java -jar epubcheck-3.0-RC-1/epubcheck-3.0-RC-1.jar charlie.epub
Epubcheck Version 3.0-RC-1

Validating against EPUB version 3.0
ERROR: charlie.epub/OEBPS/content.opf(11,14): element "manifest" incomplete; missing required element "item"
ERROR: charlie.epub/OEBPS/content.opf(12,11): element "package" incomplete; missing required element "spine"
ERROR: charlie.epub/OEBPS/content.opf(9,13): assertion failed: Exactly one manifest item must declare the 'nav' property (number of 'nav' items: 0).
WARNING: charlie.epub: item (OEBPS/front.xhtml) exists in the zip file, but is not declared in the OPF file
WARNING: charlie.epub: item (OEBPS/chapter01.xhtml) exists in the zip file, but is not declared in the OPF file
WARNING: charlie.epub: item (OEBPS/chapter02.xhtml) exists in the zip file, but is not declared in the OPF file
WARNING: charlie.epub: item (OEBPS/toc.xhtml) exists in the zip file, but is not declared in the OPF file

Check finished with warnings or errors
{% endhighlight %}

`item`要素がmanifestに、`spine`要素がpackageに無いと言っています。また、`nav`属性の１つのmanifest要素が無いと言っています。どうやらmanifestではコンテンツファイルにidを付けてリストアップすればいいようです。また`nav`要素は目次を作るためのファイルを指定するもののようです。これらを追加します。

{% highlight xml %}
<?xml version="1.0" encoding="UTF-8"?>
<package version="3.0" xmlns="http://www.idpf.org/2007/opf" unique-identifier="BookId">
  <metadata xmlns:dc="http://purl.org/dc/elements/1.1/" xmlns:dcterms="http://purl.org/dc/terms/" xmlns:opf="http://www.idpf.org/2007/opf">
    <dc:identifier id="BookId">http://charlie.com/BN001</dc:identifier>
    <dc:title>チャーリーの本の冒険</dc:title>
    <dc:language>ja</dc:language>
    <meta property="dcterms:modified">2012-11-12T00:00:00Z</meta>
  </metadata>
  <manifest>
    <item properties="nav" id="nav" href="nav.xhtml" media-type="application/xhtml+xml" />
    <item id="front" href="front.xhtml" media-type="application/xhtml+xml" />
    <item id="toc" href="toc.xhtml" media-type="application/xhtml+xml" />
    <item id="chapter01" href="chapter01.xhtml" media-type="application/xhtml+xml" />
    <item id="chapter02" href="chapter02.xhtml" media-type="application/xhtml+xml" />
  </manifest>
  <spine>
  
  </spine>
</package>
{% endhighlight %}

検証します。

{% highlight bash %}
% zip charlie.epub OEBPS/content.opf
updating: OEBPS/content.opf (deflated 57%)

% java -jar epubcheck-3.0-RC-1/epubcheck-3.0-RC-1.jar charlie.epub
Epubcheck Version 3.0-RC-1

Validating against EPUB version 3.0
ERROR: charlie.epub/OEBPS/content.opf(18,11): element "spine" incomplete; missing required element "itemref"
ERROR: charlie.epub: File OEBPS/nav.xhtml is missing in the package.
ERROR: charlie.epub/OEBPS/front.xhtml: Obsolete or irregular DOCTYPE statement. External DTD entities are not allowed. Use '<!DOCTYPE html>' instead.
ERROR: charlie.epub/OEBPS/front.xhtml(339,2): External entities are not allowed. External entity declaration found: %xhtml-qname-extra.mod
ERROR: charlie.epub/OEBPS/front.xhtml(388,36): External entities are not allowed. External entity declaration found: %SVG.dtd
ERROR: charlie.epub/OEBPS/front.xhtml(1,1): Entity '%SVG.dtd' is undeclared
ERROR: charlie.epub/OEBPS/front.xhtml(60,31): External entities are not allowed. External entity declaration found: %svg-model.mod
ERROR: charlie.epub/OEBPS/front.xhtml(65,33): External entities are not allowed. External entity declaration found: %svg-attribs.mod

（中略）

ERROR: charlie.epub/OEBPS/chapter02.xhtml(1,1): Entity '%ent-mmlextra' is undeclared
ERROR: charlie.epub/OEBPS/chapter02.xhtml(2144,37): External entities are not allowed. External entity declaration found: %ent-mmlalias
ERROR: charlie.epub/OEBPS/chapter02.xhtml(1,1): Entity '%ent-mmlalias' is undeclared
ERROR: charlie.epub/OEBPS/chapter02.xhtml(6,87): value of attribute "http-equiv" is invalid; must be a string matching the regular expression "([Dd][Ee][Ff][Aa][Uu][Ll][Tt]\-[Ss][Tt][Yy][Ll][Ee])|([Rr][Ee][Ff][Rr][Ee][Ss][Hh])"

Check finished with warnings or errors
{% endhighlight %}

コンテンツファイルに関し大量のエラーが出ましたが、まずは、spineに`itemref`要素がない、目次ファイル`nav.xhtml`ファイルがないというエラーに対処します。spineは「本の背」のことですが、ここでmanifestで宣言したファイルの並び順を指定するようです。

{% highlight xml %}
<?xml version="1.0" encoding="UTF-8"?>
<package version="3.0" xmlns="http://www.idpf.org/2007/opf" unique-identifier="BookId">
  <metadata xmlns:dc="http://purl.org/dc/elements/1.1/" xmlns:dcterms="http://purl.org/dc/terms/" xmlns:opf="http://www.idpf.org/2007/opf">
    <dc:identifier id="BookId">http://charlie.com/BN001</dc:identifier>
    <dc:title>チャーリーの本の冒険</dc:title>
    <dc:language>ja</dc:language>
    <meta property="dcterms:modified">2012-11-12T00:00:00Z</meta>
  </metadata>
  <manifest>
    <item properties="nav" id="nav" href="nav.xhtml" media-type="application/xhtml+xml" />
    <item id="front" href="front.xhtml" media-type="application/xhtml+xml" />
    <item id="toc" href="toc.xhtml" media-type="application/xhtml+xml" />
    <item id="chapter01" href="chapter01.xhtml" media-type="application/xhtml+xml" />
    <item id="chapter02" href="chapter02.xhtml" media-type="application/xhtml+xml" />
  </manifest>
  <spine>
    <itemref idref="front" />
    <itemref idref="toc" />
    <itemref idref="chapter01" />
    <itemref idref="chapter02" />
  </spine>
</package>
{% endhighlight %}

次に、nav.xhtmlファイルを作ります。

{% highlight bash %}
% touch OEBPS/nav.xhtml
{% endhighlight %}

## コンテンツファイルの修正

さて、次にコンテンツファイルを直します。不要なタグを削除し`html`タグにxmlns, xml:langを指定します。

front.xhtml
{% highlight xml %}
<?xml version="1.0" encoding="utf-8"?>
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="ja">
  <head>
    <title>チャーリーの本の冒険</title>
  </head>
  <body>
    <h1 id='id1'>チャーリーの本の冒険</h1>

    <h2 id='id2'>チャーリー　著</h2>
  </body>
</html>
{% endhighlight %}

toc.xhtml
{% highlight xml %}
<?xml version="1.0" encoding="utf-8"?>
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="ja">
  <head>
    <title>目次</title>
  </head>
  <body>
    <h1 id='id1'>目次</h1>

    <h2 id='id2'>チャーリーの本の冒険</h2>

    <p><a href='chapter01.xhtml'>第一章：チャーリーについて</a></p>

    <p><a href='chapter02.xhtml'>第二章：本の冒険について</a></p>
  </body>
</html>
{% endhighlight %}


chapter01.xhtml
{% highlight xml %}
<?xml version="1.0" encoding="utf-8"?>
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="ja">
  <head>
    <title>第一章：チャーリーについて</title>
  </head>
  <body>
    <h1 id='id1'>第一章：チャーリーについて</h1>

    <h2 id='id2'>チャーリーの呪文</h2>

    <p>チャーリーが呪文を唱えた。</p>

    <p>Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.</p>

    <h2 id='id3'>チャーリーのいびき</h2>

    <p>チャーリーのいびきはうるさい。</p>

    <p>Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.</p>
  </body>
</html>
{% endhighlight %}


chapter02.xhtml
{% highlight xml %}
<?xml version="1.0" encoding="utf-8"?>
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="ja">
  <head>
    <title>第二章：本の冒険について</title>
  </head>
  <body>
    <h1 id='id1'>第二章：本の冒険について</h1>

    <h2 id='id2'>本</h2>

    <p>チャーリーが乱暴に本を開いたら、大きな音がした。 Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.</p>

    <h2 id='id3'>冒険</h2>

    <p>そして、チャーリーは長い長い冒険に出かけた。長い長い歌を口ずさみながら。Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.</p>
  </body>
</html>
{% endhighlight %}

さて準備ができたので、検証します。

{% highlight bash %}
% zip charlie.epub OEBPS/*
updating: OEBPS/chapter01.xhtml (deflated 60%)
updating: OEBPS/chapter02.xhtml (deflated 56%)
updating: OEBPS/front.xhtml (deflated 33%)
updating: OEBPS/toc.xhtml (deflated 35%)
updating: OEBPS/content.opf (deflated 60%)
updating: OEBPS/nav.xhtml (stored 0%)

% java -jar epubcheck-3.0-RC-1/epubcheck-3.0-RC-1.jar charlie.epub
Epubcheck Version 3.0-RC-1

Validating against EPUB version 3.0
ERROR: charlie.epub/OEBPS/nav.xhtml(1,1): Premature end of file.
ERROR: charlie.epub/OEBPS/nav.xhtml: Premature end of file.

Check finished with warnings or errors
{% endhighlight %}

コンテンツファイルに対するエラーが解消しました。

## nav.xhtml

次に、`nav.xhtml`のエラーに対処します。まずは、先に作った`toc.xhtml`と同じような構造にします。

nav.xhtml
{% highlight xml %}
<?xml version="1.0" encoding="UTF-8"?>
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="ja">

<head>
<title>目次</title>
</head>
<body>

</body>
</html>
{% endhighlight %}

検証します。

{% highlight bash %}
% zip charlie.epub OEBPS/nav.xhtml 
updating: OEBPS/nav.xhtml (deflated 16%)

% java -jar epubcheck-3.0-RC-1/epubcheck-3.0-RC-1.jar charlie.epub
Epubcheck Version 3.0-RC-1

Validating against EPUB version 3.0
ERROR: charlie.epub/OEBPS/nav.xhtml(7,7): assertion failed: Exactly one 'toc' nav element must be present

Check finished with warnings or errors
{% endhighlight %}

`toc`というnav要素が１つ必要だと言っているので、追加します。

{% highlight xml %}
<?xml version="1.0" encoding="UTF-8"?>
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="ja">
  <head>
    <title>目次</title>
  </head>
  <body>
    <nav xmlns:epub="http://www.idpf.org/2007/ops" epub:type="toc"></nav>
  </body>
</html>
{% endhighlight %}

検証します。

{% highlight bash %}
% zip charlie.epub OEBPS/nav.xhtml                                   
updating: OEBPS/nav.xhtml (deflated 27%)

% java -jar epubcheck-3.0-RC-1/epubcheck-3.0-RC-1.jar charlie.epub
Epubcheck Version 3.0-RC-1

Validating against EPUB version 3.0
ERROR: charlie.epub/OEBPS/nav.xhtml(8,74): element "nav" incomplete; missing required element "ol"

Check finished with warnings or errors
{% endhighlight %}

`ol`要素が無いと言っています。`ol`要素で目次項目をリストアップするようです。対処します。

{% highlight xml %}
<?xml version="1.0" encoding="UTF-8"?>
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="ja">
  <head>
    <title>目次</title>
  </head>
  <body>
    <nav xmlns:epub="http://www.idpf.org/2007/ops" epub:type="toc">
      <h1>チャーリーの本の冒険</h1>
      <ol>
        <li><a href="front.xhtml">表紙</a></li>
        <li><a href="toc.xhtml">目次</a></li>
        <li><a href="chapter01.xhtml">第一章：チャーリーについて</a></li>
        <li><a href="chapter02.xhtml">第二章：本の冒険について</a></li>
      </ol>
    </nav>
  </body>
</html>
{% endhighlight %}

検証します。

{% highlight bash %}
% zip charlie.epub OEBPS/nav.xhtml 
updating: OEBPS/nav.xhtml (deflated 45%)
% java -jar epubcheck-3.0-RC-1/epubcheck-3.0-RC-1.jar charlie.epub
Epubcheck Version 3.0-RC-1

Validating against EPUB version 3.0
No errors or warnings detected.
{% endhighlight %}

やたー！おめでとう！

すべてのエラーと警告が解消しました。EPUBのミニマムを満たした電子書籍の完成です。


## EPUB Readerで見る
完成した`charlie.epub`をEPUB Readerで見てみます。ここでは、[Kitabu](https://itunes.apple.com/jp/app/kitabu/id492498910?mt=12 'Mac App Store - Kitabu')を使います。

ファイルを開きます。


<p><img src="{{ site.url }}/assets/images/2012/book01.png" alt="book" width=320 />
<img src="{{ site.url }}/assets/images/2012/book02.png" alt="book" width=320 /></p>


<p><img src="{{ site.url }}/assets/images/2012/book03.png" alt="book" width=320 />
<img src="{{ site.url }}/assets/images/2012/book04.png" alt="book" width=320 /></p>

スバラシイ！

ただ、残念なことにKitabuはEPUB3に対応していないようで、目次が表示できません。EPUB2ではNCXというファイル形式で目次を記述するようです。

## iBooksで見る

EPUB3に対応した[iBooks](https://itunes.apple.com/jp/app/ibooks/id364709193?mt=8 'iTunes App Store で見つかる iPhone、iPod touch、iPad 対応 iBooks')に送って見てみましょう。


<p><img src="{{ site.url }}/assets/images/2012/book05.png" alt="book" width=320 />
<img src="{{ site.url }}/assets/images/2012/book06.png" alt="book" width=320 /></p>

いいですね！

EPUB、最初の一歩、踏み出してみませんか？

----

参考情報：

[日本語Epubブックサンプル - 横浜工文社](http://www.kobu.com/docs/epub/ '日本語Epubブックサンプル - 横浜工文社')

[EPUB3チュートリアル](http://tutorial.epubcafe.jp/ 'EPUB3チュートリアル')

[いいパブッ!! - よくわかるEPUB 3](http://www.slideshare.net/lost_and_found/iipabu-11542571 'いいパブッ!! - よくわかるEPUB 3')

[電子書籍ファイルePubについて -ePubを自分で作成する- « lab.naoki.sato.name](http://naoki.sato.name/lab/archives/45 '電子書籍ファイルePubについて -ePubを自分で作成する- « lab.naoki.sato.name')

[OEBPS Container Format (OCF) 1.0 日本語版](http://naoki.sato.name/ocf/ocf_1_0_spec_ja.html 'OEBPS Container Format (OCF) 1.0 日本語版')

[EPUB 3 Overview](http://idpf.org/epub/30/spec/epub30-overview.html 'EPUB 3 Overview')

[Sus scrofa liaodongensis: EPUB ZIP コンテナの作り方](http://lamium.blogspot.jp/2011/05/epub-zip.html 'Sus scrofa liaodongensis: EPUB ZIP コンテナの作り方')

----

{{ 4844332112 | amazon_medium_image }}
{{ 4844332112 | amazon_link }} by {{ 4844332112 | amazon_authors }}

----

{% footnotes %}
{% fn  http://lamium.blogspot.jp/2011/05/epub-zip.html %}
{% endfootnotes %}

