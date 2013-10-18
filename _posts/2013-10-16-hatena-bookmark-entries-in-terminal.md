---
layout: post
title: "はてなブックマークの人気エントリーもターミナルでみたいよね - ブクマ取得APIをRubyで使う"
description: ""
category: 
tags: 
date: 2013-10-16
published: true
---
{% include JB/setup %}

自分のブログの人気エントリーは、はてなブックマークのエントリーリストにサイトのURLを投げることで見ることができます。例えば、このブログ（hp12c）における人気エントリーを見るにはブラウザで以下にアクセスします。

> [http://b.hatena.ne.jp/entrylist?sort=count&url=http://melborne.github.io](http://b.hatena.ne.jp/entrylist?sort=count&url=http://melborne.github.io)

人気記事上位20件が表示されます。ここでsortのパラメータに`eid`を渡すとブクマされたすべての記事から新着20件が表示され、また`hot`を渡すとブクマ3件以上の新着20件が表示されます。

ところでこれには対応する非公式のAPIがあってプログラムからアクセスが可能です{% fn_ref 1 %}。

> [小粋空間: JSONP: 2012年6月 アーカイブ](http://www.koikikukan.com/archives/jsonp/2012/06/ "小粋空間: JSONP: 2012年6月 アーカイブ")

そうとなればRubyでアクセスしない手はないですよね。ちょうどこのブログはギットハブにおける諸事情によりドメインが途中で変わってしまい、ブクマが分散してるのでその総数を知りたいという事情もありますし。

> 参考：[ギットハブにはてブとはてスタを殺されたので、このブログの人気記事一覧を作りました。](http://melborne.github.io/2013/04/15/i-need-bookmarks/ "ギットハブにはてブとはてスタを殺されたので、このブログの人気記事一覧を作りました。")

<br/>

そんなわけで...

ターミナルで簡単にはてブの人気エントリーリストを出力するツール「HatebuEntry」を作りましたので公開します。

> [melborne/hatebu_entry](https://github.com/melborne/hatebu_entry "melborne/hatebu_entry")
> 
> [hatebu_entry | RubyGems.org | your community gem host](https://rubygems.org/gems/hatebu_entry "hatebu_entry | RubyGems.org | your community gem host")

## ターミナルでの使い方

`gem install hatebu_entry`でHatebuEntryをインストールすると、`hatebu_entry`というコマンドが使えるようになります。これを実行すると次のようなメッセージが出力されます。

{% highlight bash %}
% hatebu_entry
Commands:
  hatebu_entry get URL         # Get Hatena bookmark entries for URL
  hatebu_entry help [COMMAND]  # Describe available commands or one specific command
  hatebu_entry merge *URLs     # Merge counts for same entries on several URLs
  hatebu_entry version         # Show HatebuEntry version
{% endhighlight %}

`get`コマンドで対象のURLに対する人気エントリーが取得できます。`http://d.hatena.ne.jp`を見てみます。

{% highlight bash %}
% hatebu_entry get http://d.hatena.ne.jp
 6691: 僕は自分が思っていたほどは頭がよくなかった - しのごの... (http://d.hat...
 5785: 「 2 」か「 9 」で割ってみる - ナイトシフト (http://d.hatena.ne.jp/nig...
 5605: 読みやすい文章を書くための技法 - RyoAnna’s iPhone Blog (http://d.hate...
 4483: この「いじめ対策」はすごい！ - 森口朗公式ブログ (http://d.hatena.ne.jp...
 4167: 知らないと損する英語の速読方法（1） - 一法律学徒の英語... (http://d.ha...
 3973: パワポでもここまでできる！米財務省から学べる美しい資... (http://d.hate...
 3967: デジタル一眼レフカメラの基礎から実践まで - #RyoAnnaBlog (http://d.hate...
 3853: 『忙しい人』と『仕事ができる人』の２０の違い (http://d.hatena.ne.jp/fa...
 3717: MacBook Air 11インチ欲しい！とは - はてなキーワード (http://d.hatena.n...
 3715: おさえておきたいメールで使う敬語 - かみんぐあうとっ (http://d.hatena.n...
{% endhighlight %}

（ここでの表記上、URLの一部を省略しています）

デフォルトで10件ですが、`--pages`オプションで取得件数を増やせます。1で20件、2で40件になります。`--sort`オプションには先に書いた`hot`, `eid`が渡せます。

{% highlight bash %}
% hatebu_entry get http://d.hatena.ne.jp -p1 -s hot
    6: 公式Twitterアカウント運用についてのアドバイス - とかいろいろ (http://...
    7: 産経新聞、整理・校閲部門を一部分社化　社員は出向 - edgefirstのメモ (h...
    3: 市場と闘い続けた視点 - LittermanによるFamaへのインタビュー - 投資の消...
   19: JAGATセミナー　電子書籍の最新事情とEPUB制作環境の進展 - ちくちく日記 ...
   16: 研究職を考えたきっかけは「育英会」の奨学金 - 殺シ屋鬼司令 (http://d.h...
    3: スティーブン・キングの新作『11/22/63』は残酷なまでの切なさに満ちた傑 ...
   18: 意味がなさすぎる「日本を元気にする国民運動」 - シェイブテイル日記 (ht...
  433: 文科系の大学生にプログラミングを教えて思ったこと - UEI shi3zの日記 (h...
    5: 『GATCHAMAN CROWDS』　中村健治監督　ヒーローものはどこへ行くのか？　 ...
    7: やなせたかし先生、あなたが僕のアンパンマンでした。 - 琥珀色の戯言 (ht...
    4: 「1964年のジャイアント馬場」中間報告。「プロレススーパースター列伝」 ...
   21: 昆虫研究界に新エースあらわる - むしブロ (http://d.hatena.ne.jp/horika...
    4: 洋書も左から右へ並べるようだ - 最終防衛ライン２ (http://d.hatena.ne.j...
    5: 10月15日 - finalventの日記 (http://d.hatena.ne.jp/finalvent/20131015/...
   76: 汝はヒーローなりや？／『ガッチャマンクラウズ』の宿題 - デマこいてんじ...
    4: 3つでやめるルール - laiso (http://d.hatena.ne.jp/laiso/20131015/p1)...
   19: はてなブックマーク人気エントリにおけるコメント率の変化 - Life like a ...
   22: 東京国立博物館『京都―洛中洛外図と障壁画の美』、西洋美術館『ミケラン ...
    3: 『BE BLUES!』高校編、桜庭さん再登場で一気におもしろい - 水星さん家 (h...
   20: 愛された子の副作用 - 傘をひらいて、空を (http://d.hatena.ne.jp/kasawo...
{% endhighlight %}

`merge`コマンドは別のドメインにおける同じ記事のブックマーク数をマージして出力します。このブログの以前のURL`http://melborne.github.com`と現在をマージしてみます。まずは比較のため以前のURLを普通に出力してみます。

{% highlight bash %}
% hatebu_entry get http://melborne.github.com
 1377: これからRubyを始める人たちへ (http://melborne.github.com/2012/04/09/t...
  633: 知って得する！５５のRubyのトリビアな記法 (http://melborne.github.com/...
  514: Rubyのcaseを〇〇(言語名)のswitch文だと思っている人たちにぼ... (http:/...
  442: 知って得する21のRubyのトリビアな記法 (http://melborne.github.com/2011...
  435: Ruby脳が理解するJavaScriptのオブジェクト指向 (http://melborne.github....
  269: 今年の冬休みに電子書籍であなたがRubyを習得しなければい... (http://mel...
  236: Ruby、君のオブジェクトはなんて呼び出せばいいの？ (http://melborne.git...
  187: Rubyを使って「なぜ関数プログラミングは重要か」を読み解... (http://mel...
  178: Ruby脳が理解するJavaScriptのオブジェクト指向（その２） (http://melbor...
  145: Ruby標準添付ライブラリcsvのCSV.tableメソッドが最強な件につ... (http:/...
{% endhighlight %}

次に現在のURLとマージした結果を出力します。

{% highlight bash %}
% hatebu_entry merge http://melborne.github.com http://melborne.github.io
 1414: これからRubyを始める人たちへ (http://melborne.github.com/2012/04/09/t...
  670: 知って得する！５５のRubyのトリビアな記法 (http://melborne.github.com/...
  613: Rubyのcaseを〇〇(言語名)のswitch文だと思っている人たちにぼくから一言 ...
  545: 知って得する21のRubyのトリビアな記法 (http://melborne.github.com/2011...
  435: Ruby脳が理解するJavaScriptのオブジェクト指向 (http://melborne.github....
  269: 今年の冬休みに電子書籍であなたがRubyを習得しなければいけないたった一 ...
  236: Ruby、君のオブジェクトはなんて呼び出せばいいの？ (http://melborne.git...
  187: Rubyを使って「なぜ関数プログラミングは重要か」を読み解く（改定）─ 前...
  180: Ruby標準添付ライブラリcsvのCSV.tableメソッドが最強な件について (http:...
  178: Ruby脳が理解するJavaScriptのオブジェクト指向（その２） (http://melbor...
  159: 30分のチュートリアルでJekyllを理解する (http://melborne.github.com/20...
  150: Jekyllいつやるの？ジキやルの？今でしょ！ (http://melborne.github.io/2...
  144: 第2弾!知って得する12のRubyのトリビアな記法 (http://melborne.github.co...
  111: メソッドの使い方もRubyに教えてほしい (http://melborne.github.io/2013/...
  106: 一生涯はてな記法しますか？それともMarkdownしますか？ (http://melborne...
   98: RubyによるMarkdownをベースにしたEPUB電子書籍の作り方と出版のお知らせ ...
   96: 東京の地下鉄をGviz（Ruby Graphviz Wrapper）で描く (http://melborne.gi...
                                  .
                                  .
                                  .
{% endhighlight %}

マージされた結果のブックマーク数が増えているのがわかると思います。まあこのコマンドに用のある人は少ないでしょうけど。

## Rubyでの使い方

Rubyで先の`get`コマンドを使いたい場合は、HatebuEntry.newにURLを渡して`#entries`を呼びます。

{% highlight bash %}
% irb
IRB on Ruby2.0.0
>> require 'hatebu_entry' #=> true
>> hent = HatebuEntry.new('http://melborne.github.io') #=> #<HatebuEntry:0x007f8ad9b1e110 @params={:url=>"http://melborne.github.io", :sort=>"count", :of=>0}>
>> hent.entries
=> [#<struct HatebuEntry::Entry link="http://melborne.github.io/2013/05/20/now-the-time-to-start-jekyll/", count=150, title="Jekyllいつやるの？ジキやルの？今でしょ！">, #<struct HatebuEntry::Entry link="http://melborne.github.io/2013/09/04/is-that-a-yet-another-rdoc/", count=111, title="メソッドの使い方もRubyに教えてほしい">, #<struct HatebuEntry::Entry link="http://melborne.github.io/2011/06/22/21-Ruby-21-Trivia-Notations-you-should-know-in-Ruby/", count=103, title="知って得する21のRubyのトリビアな記法">, ...（省略）... #<struct HatebuEntry::Entry link="http://melborne.github.io/2013/09/27/auto-attr-set-in-ruby/", count=59, title="RubyistたちのDRY症候群との戦い">, #<struct HatebuEntry::Entry link="http://melborne.github.io/2012/10/29/rubys-new-control-structure-by-tap-and-break/", count=46, title="TapがRubyの新たな制御構造の世界を開く">, #<struct HatebuEntry::Entry link="http://melborne.github.io/2012/05/13/first-step-of-jekyll/", count=41, title="30分のチュートリアルでJekyllを理解する">]
>> puts hent.entries #=> nil
  150: Jekyllいつやるの？ジキやルの？今でしょ！ (http://melborne.github.i...
  111: メソッドの使い方もRubyに教えてほしい (http://melborne.github.io/20...
  103: 知って得する21のRubyのトリビアな記法 (http://melborne.github.io/20...
   99: Rubyのcaseを〇〇(言語名)のswitch文だと思っている人たちにぼ... (htt...
   87: 分別のあるRubyモンキーパッチャーになるために (http://melborne.gith...
   72: ((Rubyで) 書く (Lisp) インタプリタ) (http://melborne.github.io/201...
   62: ええ、ハッキリ言います。私はRubyのArray#unshiftが嫌いです。 (http:...
   59: RubyistたちのDRY症候群との戦い (http://melborne.github.io/2013/09/...
   46: TapがRubyの新たな制御構造の世界を開く (http://melborne.github.io/2...
   41: 30分のチュートリアルでJekyllを理解する (http://melborne.github.io/...
{% endhighlight %}

`sort`オプションはnewの第２引数として渡します。`pages`は#entriesの引数として渡します。実装上、引数なしの場合は先の非公式API（JSONPを返します）にアクセスしていますが、引数を渡して20件以上を取得する場合はhtmlページを取得してnokogiriでパースしています。

`merge`は`HatebuEntry::Entry.merge`を使います。こんな感じで。

{% highlight ruby %}
ent1 = HatebuEntry.new('http://melborne.github.com').entries(1)
ent2 = HatebuEntry.new('http://melborne.github.io').entries(1)

merged = HatebuEntry::Entry.merge(ent1, ent2)

puts merged
{% endhighlight %}

マージされる記事の同一性の判断は、URLから取得される日付の一致とタイトルの前方の一致を見るというちょっと適当な実装になってます。

使い方の説明は以上です。

よかったら使ってみてください:-)

> [melborne/hatebu_entry](https://github.com/melborne/hatebu_entry "melborne/hatebu_entry")
> 
> [hatebu_entry | RubyGems.org | your community gem host](https://rubygems.org/gems/hatebu_entry "hatebu_entry | RubyGems.org | your community gem host")

---

最後にHatebuEntryで生成したhp12cの人気記事トップ２０のリンクを貼ってお別れしたいと思います。タイトルとブクマ数はリンクになっていますので、興味のある記事がありましたら読んでもらえたらうれしいです。では、さようなら。

## hp12cの人気エントリーTOP20

[[1414](http://b.hatena.ne.jp/entry/http://melborne.github.com/2012/04/09/to-newbie/)] : [これからRubyを始める人たちへ](http://melborne.github.com/2012/04/09/to-newbie/)

[[670](http://b.hatena.ne.jp/entry/http://melborne.github.com/2013/03/04/ruby-trivias-you-should-know-4/)] : [知って得する！５５のRubyのトリビアな記法](http://melborne.github.com/2013/03/04/ruby-trivias-you-should-know-4/)

[[614](http://b.hatena.ne.jp/entry/http://melborne.github.com/2013/02/25/i-wanna-say-something-about-rubys-case/)] : [Rubyのcaseを〇〇(言語名)のswitch文だと思っている人たちにぼくから一言ガツンと申し上げたい](http://melborne.github.com/2013/02/25/i-wanna-say-something-about-rubys-case/)

[[545](http://b.hatena.ne.jp/entry/http://melborne.github.com/2011/06/22/21-Ruby-21-Trivia-Notations-you-should-know-in-Ruby/)] : [知って得する21のRubyのトリビアな記法](http://melborne.github.com/2011/06/22/21-Ruby-21-Trivia-Notations-you-should-know-in-Ruby/)

[[442](http://b.hatena.ne.jp/entry/http://melborne.github.com/2012/09/09/understand-js-oop-with-ruby-brain/)] : [Ruby脳が理解するJavaScriptのオブジェクト指向](http://melborne.github.com/2012/09/09/understand-js-oop-with-ruby-brain/)

[[272](http://b.hatena.ne.jp/entry/http://melborne.github.com/2012/12/25/ebooks-for-learning-ruby/)] : [今年の冬休みに電子書籍であなたがRubyを習得しなければいけないたった一つの理由](http://melborne.github.com/2012/12/25/ebooks-for-learning-ruby/)

[[236](http://b.hatena.ne.jp/entry/http://melborne.github.com/2012/07/16/ruby-methods-analysis/)] : [Ruby、君のオブジェクトはなんて呼び出せばいいの？](http://melborne.github.com/2012/07/16/ruby-methods-analysis/)

[[202](http://b.hatena.ne.jp/entry/http://melborne.github.com/2013/01/21/why-fp-with-ruby/)] : [Rubyを使って「なぜ関数プログラミングは重要か」を読み解く（改定）─ 前編 ─ 但し後編の予定なし](http://melborne.github.com/2013/01/21/why-fp-with-ruby/)

[[180](http://b.hatena.ne.jp/entry/http://melborne.github.com/2013/01/24/csv-table-method-is-awesome/)] : [Ruby標準添付ライブラリcsvのCSV.tableメソッドが最強な件について](http://melborne.github.com/2013/01/24/csv-table-method-is-awesome/)

[[178](http://b.hatena.ne.jp/entry/http://melborne.github.com/2012/09/15/understand-js-oop-with-ruby-brain-2/)] : [Ruby脳が理解するJavaScriptのオブジェクト指向（その２）](http://melborne.github.com/2012/09/15/understand-js-oop-with-ruby-brain-2/)

[[159](http://b.hatena.ne.jp/entry/http://melborne.github.com/2012/05/13/first-step-of-jekyll/)] : [30分のチュートリアルでJekyllを理解する](http://melborne.github.com/2012/05/13/first-step-of-jekyll/)

[[150](http://b.hatena.ne.jp/entry/http://melborne.github.io/2013/05/20/now-the-time-to-start-jekyll/)] : [Jekyllいつやるの？ジキやルの？今でしょ！](http://melborne.github.io/2013/05/20/now-the-time-to-start-jekyll/)

[[144](http://b.hatena.ne.jp/entry/http://melborne.github.com/2012/02/08/2-12-Ruby-12-Trivia-Notations-you-should-know-in-Ruby/)] : [第2弾!知って得する12のRubyのトリビアな記法](http://melborne.github.com/2012/02/08/2-12-Ruby-12-Trivia-Notations-you-should-know-in-Ruby/)

[[111](http://b.hatena.ne.jp/entry/http://melborne.github.io/2013/09/04/is-that-a-yet-another-rdoc/)] : [メソッドの使い方もRubyに教えてほしい](http://melborne.github.io/2013/09/04/is-that-a-yet-another-rdoc/)

[[109](http://b.hatena.ne.jp/entry/http://melborne.github.com/2012/05/05/to-be-hatena-notation-or-to-be-markdown/)] : [一生涯はてな記法しますか？それともMarkdownしますか？](http://melborne.github.com/2012/05/05/to-be-hatena-notation-or-to-be-markdown/)

[[107](http://b.hatena.ne.jp/entry/http://melborne.github.com/2012/10/29/rubys-new-control-structure-by-tap-and-break/)] : [TapがRubyの新たな制御構造の世界を開く](http://melborne.github.com/2012/10/29/rubys-new-control-structure-by-tap-and-break/)

[[100](http://b.hatena.ne.jp/entry/http://melborne.github.com/2012/12/03/when-bloggers-become-publishers/)] : [RubyによるMarkdownをベースにしたEPUB電子書籍の作り方と出版のお知らせ](http://melborne.github.com/2012/12/03/when-bloggers-become-publishers/)

[[98](http://b.hatena.ne.jp/entry/http://melborne.github.com/2012/10/02/draw-metro-map-with-gviz/)] : [東京の地下鉄をGviz（Ruby Graphviz Wrapper）で描く](http://melborne.github.com/2012/10/02/draw-metro-map-with-gviz/)

[[93](http://b.hatena.ne.jp/entry/http://melborne.github.com/2012/08/17/what-is-dsl-for-ruby/)] : [ねえRuby、どこまでが君でどこからが内部DSLなの？](http://melborne.github.com/2012/08/17/what-is-dsl-for-ruby/)

[[91](http://b.hatena.ne.jp/entry/http://melborne.github.com/2012/09/25/ruby-plus-graphviz-should-eql-gviz/)] : [Yet Another Ruby Graphviz Interfaceを作ったからみんなで大量のグラフを作って遊ぼうよ！](http://melborne.github.com/2012/09/25/ruby-plus-graphviz-should-eql-gviz/)

---

(追記：2013-10-17) hp12c人気エントリーのリストを修正しました。

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

{% footnotes %}
{% fn 似たようなAPIは公式のものでもあるようです %}
{% endfootnotes %}

