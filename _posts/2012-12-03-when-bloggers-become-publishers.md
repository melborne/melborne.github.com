---
layout: post
title: "RubyによるMarkdownをベースにしたEPUB電子書籍の作り方と出版のお知らせ"
tagline: "ブログが電子書籍に変わる日"
category: 
tags: [ebook, epub]
date: 2012-12-03
published: true
---
{% include JB/setup %}

「情報革命」とは何でしょうか。それはネットを介した大量情報の流入による社会生活の変化の連続のことです。情報革命の初期に始まる一つの変化は「見る変化」です。情報を最も効率的に処理できる人間の入力デバイスは「目」であり、そのための環境作りがまず構築されるでしょう。

スマートフォンが携帯電話を駆逐したのは、iPhoneのデザインが素晴らしかったからではありません。人々が大量の情報を処理するためには、非効率な「耳」デバイスを置いて、より効率的な「目」デバイスを活用する必要があったからです。

７インチタブレットの新製品投入が相次いでいます。これは何を意味し、何を駆逐するのでしょうか。そのフォルムを見れば答えは明らかでしょう。それはまさに「書籍」なのです。７インチタブレットは「アトムの読書」を「ビットの読書」にすべて置き換えようとしています。

スマートフォンは、話し言葉を文字化して見るためのデバイスとして登場しました。そして７インチタブレットは、文章を読むのに最適化されたデバイスとして今ここに登場したのです。


「見る変化」第二幕の始まりです...

----

スマホもタブレットも持ってない僕が、偉そうに言うことじゃありませんでしたね！（えっ？）


## ブログを電子書籍化する

さて、そうなると僕はこのブログの行く末が心配です。ブログというメディアはもっぱら大型モニタ用に作られたメディアですから、７インチタブレットにおける快適な読書体験に適しているかというと疑問が残ります。苦労して書いた記事を誰も読まない日が来るとしたら悲しいです。承認欲求が満たされません。ブコメやツイートでの「面白い」「へぇ〜」とかの言葉を食べて今日まで生きてきたのに。


<br/>

そんなわけで...

<br/>


Jekyllを使ったこのブログ記事を電子書籍化するツール「`Maliq`」をRubyで作りました！


> rubygems: [Maliq](https://rubygems.org/gems/maliq 'maliq | RubyGems.org | your community gem host')    　　github: [melborne/maliq](https://github.com/melborne/maliq 'melborne/maliq')

つまり`Maliq`は、Liquid拡張されたMarkdown形式のコンテンツからEPUBパッケージを作るツールです。Liquidにより実現されているコードのsyntax highlightingやAmazonリンク付きのコンテンツを、そのまま電子書籍化できます。「Markdown」と「Liquid」の頭を取って「Maliq」です。Mr. マリック（Maric）とは何の関係もありません。



Maliqは、`maliq`と`maliq_gepub`という２つのコマンドを持っていて、これらのコマンドで簡単にEPUBパッケージが作れるようになっています。maliq はMarkdownをXHTMLに変換し、maliq_gepubはXHTMLファイルからEPUBパッケージを生成します。

maliq_gepubは、小嶋智さんによる「[Gepub](https://github.com/skoji/gepub 'skoji/gepub')」というEPUB3に対応した、Ruby製EPUBジェネレータの単なるラッパーです。Maliqにおける変換の仕事の大半はこのGepubで実現されています。素晴らしい！


## Maliqの使い方

以下ではMaliqの使い方を説明しています。MaliqはGem化されているので、`gem install maliq`で入手できます。gepubも同時にインストールされます。


### コマンドの使い方

以下の手順に従います。

    1. Markdownで書かれたコンテンツファイルを準備する（ex. chapter01.md）。

    2. EPUB生成に必要とされるメタ情報をYAMLフォーマットでファイル（複数ある場合は最初のファイル）先頭に記述する（Yaml Front Matter）。

    3. ファイル内にチャプター区切りを示す特別のマーカーを書くことで、１つのMarkdownファイルを分割して複数のXHTMLファイルを生成できる。デフォルトでのマーカーの書式は`<<<--- <filename> --->>>`（ex. `<<<--- chapter02 --->>>`）。

    4. CSSおよび画像ファイルがあるなら、カレントディレクトリまたはそのサブディレクトリに配置する。

    5. コンテンツに特別なLiquid Tagが含まれている場合、対応Pluginを`plugins`サブディレクトリに置く。

    6. `maliq`コマンドにMarkdownファイル名を渡して実行する(maliq chapter01.md)。これにより、１または複数のXHTMLファイルがカレントディレクトリに生成される。

    7. `maliq_gepub`を実行する。これにより、EPUBファイルがカレントディレクトリ生成される。

### Yaml Front Matterのサンプル

YFMのサンプルを示します。

{% highlight text %}
---
language: 'en'
unique_identifier:
 - 'http:/example.jp/bookid_in_url'
 - 'BookID'
 - 'URL'
title: 'Book of Charlie'
subtitle: 'Where Charlie goes to'
creator: 'melborne'
date: '2012-01-01'
---
{% endhighlight %}

トリプルダッシュの行の間に、EPUB生成で必要とされるメタ情報をYAMLフォーマットで記述します。メタ項目については以下が参考になります。

[Epub Format Construction Guide - HXA7241 - 2007](http://www.hxa.name/articles/content/epub-guide_hxa7241_2007.html 'Epub Format Construction Guide - HXA7241 - 2007')

### Liquid plugins

ネット上には各種Liquid pluginがありますが、Maliqでそれらを利用するためには少し修正が要ります。例えば、ネット上のデータにアクセスする必要のあるpluginではそれをローカル保存するような修正が必要になるでしょう。gistにJekyll向けliquid pluginを修正した僕のpluginが少し置いてあるので利用して下さい。

> [Liquid filters for Maliq gem to generate xhtml — Gist](https://gist.github.com/4134497 'Liquid filters for Maliq gem to generate xhtml — Gist')


### コードでの使い方
上記コマンドでは定型的なことしかできません。より柔軟に変換を行いたい場合にはRubyでコードを書く必要があります。

`Maliq::Converter.new`にMarkdownテキストを渡して`#run`メソッドを実行します。

{% highlight ruby %}
puts Maliq::Converter.new("#header1\nline1\n\nline2").run
{% endhighlight %}

これにより以下が得られます。

{% highlight html %}
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml" xmlns:epub="http://www.idpf.org/2007/ops" xml:lang="ja">
  <head>
    <title></title>
    
  </head>
  <body>
    <h1>header1</h1>

    <p>line1</p>

    <p>line2</p>
  </body>
</html>
{% endhighlight %}

pluginでliquid tagをパースするためには、pluginのフォルダを指定する必要があります。これはYaml Front Matterまたは`#set_meta`メソッドで行います。フォルダのデフォルトは`plugins`になっているので、その場合は指定は不要です。

{% highlight ruby %}
Maliq::Converter.new(<<-EOS).run(false)
---
liquid: 'filters'
---
# header1
{{ "{% calc 2 + 3"}} %}
EOS
{% endhighlight %}

これにより`filters`というフォルダ名にあるcalc pluginが使えるようになります。出力です。

{% highlight html %}
<h1>header1</h1>

<p>2 + 3 = 5</p>
{% endhighlight %}

`#run`にfalseを渡すとbody要素のみを返します。


## 簡単なチュートリアル
次に、順を追って電子書籍を実際に作ってみます。

### コンテンツを準備する

まずはMarkdownによるコンテンツを用意します。作業ディレクトリを`my_first_ebook`、ファイル名を`chapter01.md`とします。

このコンテンツにおけるポイントは次の３点です。

    1. コンテンツは"Syntax Highlighting", "Gist", "Amazon Link"用のLiquid Tagを含んでいる。
    2. ファイル先頭のYaml Front Matterにおいてメタ情報を定義している。
    3. 各章の前にチャプター区切りマーカーを配置している。

Syntax Highlightingには[Pygments](http://pygments.org/ 'Pygments — Python syntax highlighter')とそのRubyラッパー`pygments.rb`を使うので、事前にそのインストールが必要になります。以下を参考にしてください。

[Install · mojombo/jekyll Wiki](https://github.com/mojombo/jekyll/wiki/Install 'Install · mojombo/jekyll Wiki')

pygments.rbは`gem install pygments.rb`です。

またAmazon Linkを使うには、AWSのアカウントとruby-aawsのインストールが必要になります。以下を参考にしてください。

[Amazon Plugin for Octopress - Zanshin.net](http://zanshin.net/2011/08/24/amazon-plugin-for-octopress/ 'Amazon Plugin for Octopress - Zanshin.net')

YFMにおいて`unique_identifier`、`title`属性は必須です。`language`属性も本来必須の属性ですが、Maliqではデフォルトを'ja'としているので、その場合は省略できます。

チュートリアル用に小説を用意しました。上記ポイントに注意しながら目を通してください。中身は気にせずに...

#### chapter01.md
{% highlight text %}
---
unique_identifier:
 - 'http:/example.jp/bookid_in_url'
 - 'BookID'
 - 'URL'
title: 'Rubyと鶏卵'
subtitle: 'Egg in the Ruby'
creator: 'melborne'
date: '2012-12-01'
---

# １章　私を煮るなら殻にして

今にして思えばあの時にちゃんとRubyの中に鶏卵を納めておくべきだった。そうすれば、彼女がこんなに変わってしまうことはなかった。そのときの光景はおぞましくも僕の脳裏に焼き付いて離れないけど、それをコードで表現するなら差し詰め次のようになるだろう。

{{ "{% highlight ruby"}} %}
if egg.nil?
  egg = Egg.new
elsif egg.empty?
  egg << Egg.new
end
{{ "{% endhighlight"}} %}

僕はここで重大なミスを犯す。彼女は`egg`がnilのときにカラにして欲しいと望んだのに、どういう訳か僕は誤って`Egg.new`してしまった。

それからだった。彼女のすべてが変わってしまったのは。

<<<--- chapter02 --->>>


# ２章　怠惰な日々とはにわとGeorge

ルート101を北に向かってもう３時間も休みなしに走ってる。隣には「デカバチンはにわ」が100個ほど置いてある。全くやってられない。彼女は「デカバチンはにわ100個をGeorgeに必ず渡して」って言ったけど、僕はGeorgeがどこで何を生業として生きている人間であるかの情報を、これっぽっちも持ち合わせていない。あるのは彼がRubyと鶏卵に深い造詣があるという彼女からの情報だけだ。それとてフタシカなものだけれども。僕の今の陰鬱な気分をせめてコードで表現させてほしい。

{{ "{% gist 4174909 ruby_egg.rb"}} %}

あぁ、どうやら頭が混乱しているようだ。これは昨日Stefanieが僕にpushしたコード片じゃないか。全く、どうかしているよ。

<<<--- chapter03 --->>>

# ３章　僕とタップを踊ろうよ、どんな意味においても

要約するならば、まあ僕がどうしようもなく世間知らずな若造だった、ってことだ。「デカバチンはにわ」を待ってるGeorgeなんて男は元々この世には存在しなかったし、`egg`がemptyのときは`Egg.new`をappendするってのも悪い方策とも言えない。問題の根本解決にはならないかもしれないけれども。それでも僕はルート101とはにわ100個の不整合性には、もっと早くに気づくべきだった。この一件に関しては完全に僕の負けを認めざるを得ない。ゴメンよRuby。許してくれるなら、僕とタップを踊ろうよ。どんな意味においても。

完

{{ "{{ 4806906557 | amazon_medium_image"}} }}
{{ "{{ 4806906557 | amazon_link"}} }}
{% endhighlight %}

小説中のgist tagはgistサーバー上のコードを指し示しています。内容は次のとおりです。

[melborne's gist: 4174909 — Gist](https://gist.github.com/4174909#file_ruby_egg.rb 'melborne's gist: 4174909 — Gist')

#### ruby_egg.rb
{% highlight ruby %}
# encoding: UTF-8

∞= 1.0/0
(1..∞).lazy.map {|i| Statue.new(i) }
           .select {|statue| statue.of_liberty? }
           .take(100).send(:george)

# ~> YouLazzyError: undefined method ‘lazy’ for 1..Infinity:Range
{% endhighlight %}


### Liquid Pluginの配置
次に、`plugins`サブディレクトリを作って、ここにpluginを配置します。ここでは僕のgist上のものをcloneします。

[Liquid filters for maliq gem to generate xhtml — Gist](https://gist.github.com/4134497 'Liquid filters for maliq gem to generate xhtml — Gist')

{% highlight bash %}
my_first_ebook% mkdir plugins
my_first_ebook% git clone git://gist.github.com/4134497.git plugins     
{% endhighlight %}

結果、ファイル構成は次のようになります。

{% highlight bash %}
my_first_ebook% tree
.
├── chapter01.md
└── plugins
    ├── amazon_liquid_tags.rb
    ├── gist_tag.rb
    ├── highlight.rb
    └── syntax.css

1 directory, 5 files
{% endhighlight %}

### CSSおよび画像ファイルの配置

CSSや画像がある場合は、それぞれcss, imagesなどのサブディレクトリを作って配置します。ここでは`css`ディレクトリを作って、簡単なスタイルシート`style.css`とsyntax highliting用の`syntax.css`を配置します。syntax.cssは先程gistからcloneした中に含まれるものを使います。style.cssは以下のとおりです。

{% highlight css %}
h1, h2, h3 {
  color: #8B1A1A;
}

ol {
  list-style-type: none;
}
{% endhighlight %}


ここでは実践しませんが、表紙画像がある場合はファイル名に`cover`を使って(ex. cover.jpg)、imagesディレクトリに配置します。

### XHTMLファイルの生成

さて下準備ができたので、`maliq`コマンドを使ってEPUB用XHTMLファイルを生成します。

{% highlight bash %}
my_first_ebook% maliq chapter01.md 
/Users/keyes/.rbenv/versions/1.9.3-p327/lib/ruby/1.9.1/rubygems/custom_require.rb:36:in `require': iconv will be deprecated in the future, use String#encode instead.
'chapter01.xhtml' created.
'chapter02.xhtml' created.
Image downloading...
'chapter03.xhtml' created.
{% endhighlight %}

警告が出ますが、気にせずに生成されたファイル群を見てみます。

{% highlight bash %}
my_first_ebook% tree
.
├── chapter01.md
├── chapter01.xhtml
├── chapter02.xhtml
├── chapter03.xhtml
├── css
│   ├── style.css
│   └── syntax.css
├── images
│   └── 51C9X825VXL._SL160_.jpg
└── plugins
    ├── amazon_liquid_tags.rb
    ├── gist_tag.rb
    └── highlight.rb

2 directories, 8 files
{% endhighlight %}

chapter01〜03のXHTMLファイルが生成され、Amazonリンクに係る画像データがDLされているのが分かります。

chapter01.xhtmlの中身をちょっと覗いてみます。

{% highlight html %}
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml" xmlns:epub="http://www.idpf.org/2007/ops" xml:lang="ja">
  <head>
    <title>Rubyと鶏卵</title>
    <link href='css/style.css' rel='stylesheet' type='text/css'/>
<link href='css/syntax.css' rel='stylesheet' type='text/css'/>
  </head>
  <body>
<h1>１章　私を煮るなら殻にして</h1>

<p>今にして思えばあの時にちゃんとRubyの中に鶏卵を納めておくべきだった。そうすれば、彼女がこんなに変わってしまうことはなかった。そのときの光景はおぞましくも僕の脳裏に焼き付いて離れないけど、それをコードで表現するなら差し詰め次のようになるだろう。</p>

<div class="highlight"><pre><code class="ruby"><span class="k">if</span> <span class="n">egg</span><span class="o">.</span><span class="n">nil?</span>
  <span class="n">egg</span> <span class="o">=</span> <span class="no">Egg</span><span class="o">.</span><span class="n">new</span>
<span class="k">elsif</span> <span class="n">egg</span><span class="o">.</span><span class="n">empty?</span>
  <span class="n">egg</span> <span class="o">&lt;&lt;</span> <span class="no">Egg</span><span class="o">.</span><span class="n">new</span>
<span class="k">end</span>
</code></pre></div>


<p>僕はここで重大なミスを犯す。彼女は<code>egg</code>がnilのときにカラにして欲しいって望んだのに、どういう訳か僕は誤って<code>Egg.new</code>してしまった。</p>

<p>それからだった。彼女のすべてが変わってしまったのは。</p>
  </body>
</html>
{% endhighlight %}

うまく行ったようです。

### EPUBパッケージの生成
さて、最後に`maliq_gepub`コマンドを使って、EPUBファイルを生成します。

{% highlight bash %}
my_first_ebook% maliq_gepub -o ruby_egg.epub
my_first_ebook% ls -l
total 56
-rw-r--r--  1 keyes  staff   2733 11 30 19:07 chapter01.md
-rw-r--r--  1 keyes  staff   1541 11 30 21:21 chapter01.xhtml
-rw-r--r--  1 keyes  staff   1190 11 30 21:21 chapter02.xhtml
-rw-r--r--  1 keyes  staff   2065 11 30 21:21 chapter03.xhtml
drwxr-xr-x  3 keyes  staff    102 11 30 21:21 images
drwxr-xr-x  6 keyes  staff    204 11 30 19:27 plugins
-rw-r--r--  1 keyes  staff  11716 11 30 21:43 ruby_egg.epub
{% endhighlight %}

生成された`ruby_egg.epub`の中身を見てみます。

{% highlight bash %}
my_first_ebook% unzip -v ruby_egg.epub 
Archive:  ruby_egg.epub
 Length   Method    Size  Ratio   Date   Time   CRC-32    Name
 --------  ------  ------- -----   ----   ----   ------    ----
      20  Stored       20   0%  11-30-12 21:43  2cab616f  mimetype
     252  Defl:N      172  32%  11-30-12 21:43  e0f26a53  META-INF/container.xml
    1541  Defl:N      740  52%  11-30-12 21:43  a0b369fe  OEBPS/chapter01.xhtml
    1190  Defl:N      748  37%  11-30-12 21:43  6b7298be  OEBPS/chapter02.xhtml
    2065  Defl:N     1062  49%  11-30-12 21:43  7dd26128  OEBPS/chapter03.xhtml
    6034  Defl:N     6003   1%  11-30-12 21:43  988e6d97  OEBPS/images/51C9X825VXL._SL160_.jpg
     710  Defl:N      377  47%  11-30-12 21:43  0b041246  OEBPS/nav.html
     542  Defl:N      370  32%  11-30-12 21:43  05e77aca  OEBPS/nav.xhtml
    1504  Defl:N      552  63%  11-30-12 21:43  30d6f9d0  OEBPS/package.opf
    1227  Defl:N      514  58%  11-30-12 21:43  0a6ee4da  OEBPS/toc.ncx
--------          -------  ---                            -------
   15085            10558  30%                            10 files
{% endhighlight %}

よさそうです。

では、EPUBリーダーでファイルを開いてみます。

![Alt title]({{ site.url }}/assets/images/2012/ruby_egg01.png)

![Alt title]({{ site.url }}/assets/images/2012/ruby_egg02.png)

![Alt title]({{ site.url }}/assets/images/2012/ruby_egg03.png)

![Alt title]({{ site.url }}/assets/images/2012/ruby_egg04.png)

いいですね！

EPUB電子書籍の完成です。

<br/>

## 電子書籍「これからRubyを始める人たちへ」の販売について

このEPUB生成ツールを使って、早々このブログにおけるRubyの入門記事を１つ電子書籍化しました。

そしてこれに表紙を付けて、「[Gumroad](https://gumroad.com/ 'Gumroad')」を通して販売させて戴くことにしました。


![start Ruby]({{ site.url }}/assets/images/2012/start_ruby.jpg)

![start Ruby]({{ site.url }}/assets/images/2012/start_ruby2.png)
![start Ruby]({{ site.url }}/assets/images/2012/start_ruby3.png)

価格は100円です。

コンテンツについては、ブログ記事「[これからRubyを始める人たちへ](http://melborne.github.com/2012/04/09/to-newbie/ 'これからRubyを始める人たちへ')」における、不適切な記述（!）およびメディア向けの調整を行っていますが、実質的な内容についての追加・変更はありません。したがってテキストに関し、有料購入する価値は無いと思います。しかしながら、次の何れかの理由で興味を持たれる方が居られるかもしれません。

> 1. コンテンツに関心があるので、それが電子書籍の形態で読めるのはやはり便利だ。
> 
> 2. コードのSyntax HighlightingをEPUBで実現したものをあまり見たことがない。どんなものかちょっと見てみたい。
> 
> 3. ブログでは不愉快な記述があったので読む気がしなかったが、電子書籍版はその部分が訂正されているそうだからそちらで読んでみたい。
> 
> 4. このEPUB生成ツール`Maliq`に関心がある。つまり自分もブログを電子書籍化したいので、その出力サンプルとして参考にしたい。
> 
> 5. ブログの記事を読んだが参考になった。これが無料なんて申し訳なく思うから買ってあげたい。
> 
> 6. ブログの記事は読んでないが、興味はあるのでどうせなら電子書籍で読んでみよう。
> 
> 7. なんか表紙が気に入ったからそれを眺めるために買ってみよう。
> 
> 8. このブログのネタは全体としてなかなか面白い。これからも継続して欲しいので寄付の気持ちで購入してもいいかな。
> 
> 9. タブレットを買ったばかりなので、いろいろな電子書籍を衝動買いしたい。
> 
> 10. 今日はいい気分だ。だれでもいいから俺の100円受け取って。


次のリンクはGumroadにおける商品購入リンクになっています。クリックすると、オーバーレイ・ウインドウが立ち上がって、この場でクレジットカード決済による購入が可能です。購入にはクレジット情報およびメールアドレスの入力が必要になります。購入すると、入力したメールアドレスにコンテンツのDLリンクが送られてきます。

<a href="http://gum.co/RjRO" class="gumroad-button">電子書籍「これからRubyを始める人たちへ」EPUB版</a><script type="text/javascript" src="https://gumroad.com/js/gumroad-button.js"></script><script type="text/javascript" src="https://gumroad.com/js/gumroad.js"></script>


ご検討のほど、よろしくお願いしますm(__)m


なお、EPUBは[Amazon Kindle](http://www.amazon.co.jp/gp/product/B007OZO03M/ref=bb1_ads_cel_1121?ie=UTF8&nav_sdd=aps&pf_rd_m=AN1VRQENFRJN5&pf_rd_s=center-1&pf_rd_r=1Z9P3B1C879AW391AVRT&pf_rd_t=101&pf_rd_p=122583989&pf_rd_i=489986 'Kindle Paperwhite - ライト内蔵の電子書籍リーダー')では読めないので、mobiなどへの変換が必要です。変換には「[calibre](http://calibre-ebook.com/ 'calibre - E-book management')」が便利です。

---

以上、EPUB生成ツール`Maliq`の紹介と 電子書籍「これからRubyを始める人たちへ」の宣伝でした。

----

関連記事：[エラーメッセージから学ぶ電子書籍EPUB - 最初の一歩](http://melborne.github.com/2012/11/12/epub-tutorial/ 'エラーメッセージから学ぶ電子書籍EPUB - 最初の一歩')

---

(追記：2012−12−04) pygments.rbのインストールについて追記しました。

---


{{ 'B007OZNYMU' | amazon_medium_image }}
{{ 'B007OZNYMU' | amazon_link }}

