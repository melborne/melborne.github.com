---
layout: post
title: "(注意)「Let It Fall」は、アナと雪の女王の挿入歌「Let It Go」と何ら関係ございません！"
tagline: "LetItFallアップデートのお知らせ"
description: ""
category: 
tags: 
date: 2014-05-12
published: true
---
{% include JB/setup %}

5月1日に公開した「[let_it_fall](https://rubygems.org/gems/let_it_fall "let_it_fall")」のダウンロード数がこの10日間で1000に達しました。私が今まで公開してきたチンピラGemsの中ではダントツの最速記録です。

> [let_it_fall -- BestGems](http://bestgems.org/gems/let_it_fall "let_it_fall -- BestGems")

![let_it_fall]({{ BASE_PATH }}/assets/images/2014/05/let_it_fall01.png)


## 誰がダウンロードしているのか

この原因を考察してみると、一つの予兆に思い当たります。

私はlet_it_fallを次のブログ記事で公開しました。


> [Macのターミナルで〇〇が降る]({{ BASE_PATH }}/2014/05/01/let-it-fall-in-the-mac-terminal/ "Macのターミナルで〇〇が降る") {% hatebu http://melborne.github.io/2014/05/01/let-it-fall-in-the-mac-terminal/ %}

この記事に対するアクセスはそこそこでしたが、これが上記のダウンロード数を導くほどのものというのはちょっと考えにくいです。

一方で、私はその前日に次のような記事を書いていました。

> [Macのターミナルで顔が降る]({{ BASE_PATH }}/2014/04/30/let-it-smile-in-the-terminal/ "Macのターミナルで顔が降る") {% hatebu http://melborne.github.io/2014/04/30/let-it-smile-in-the-terminal/ %}

この記事はlet_it_fallのベースとなっているRubyのワンライナーを紹介する記事ですが、ご覧のようにはてブ数は少なく、一見、この記事が影響しているようにも見えません。

ところが、この記事に対する公開日とその翌日２日間（4/30, 5/1）の実際のアクセス数は次のとおりでした。

![let_it_fall]({{ BASE_PATH }}/assets/images/2014/05/let_it_fall02.png)

私は不思議に思いそのアクセス経路を辿ってみると、果たしてその大半は「[Facebook](https://ja-jp.facebook.com/ "Facebook")」からの流入であることが判明しました。

つまり、この記事を読んだ多くのユーザは、普段ここを訪れるギークなまたははてなな人達ではなく、Facebookを住み処とするスーツの人達だったのです{% fn_ref 1 %}！

確かにそこには彼らの足跡が残されていました。

![let_it_fall]({{ BASE_PATH }}/assets/images/2014/05/let_it_fall03.png)

このブログの記事に対する「いいね！」数が二桁になることは稀ですから、これは異常事態です。

## 私の結論

これで、let_it_fall大量ダウンロードの原因がはっきりしました。私の推論はこうです。

> 普段ここを訪れないスーツの人達の目が、記事の近くにあった「let_it_fall」という文字に留まり、これを「Let It Go」と空見して、このソフトをダウンロードして実行すれば、松さんかMay Jのあの素晴らしい歌声が聴けると勘違いして、思わずMacのターミナルを開いて`gem install let_it_fall`し、さらに`let_it_fall face`とか打ってしまい、なんだか訳の分からないものを見させられてオレの貴重な時間を返せと叫ぶも、フリーで無保証なソフト故に法令に従えば作者に文句も言えず泣き寝入っている。

## お詫びに代えて

このような事態に、作者である私は大変に心苦しい思いでいるのですが、さりとて皆様の期待通りに`let_it_fall`で「Let It Go」を再生することは著作権法上の問題もあり叶いません。

そこで苦肉の策として、もう色んなモノがありのままに降ってくる、「`let_it_fall go`」というコマンドを本ソフトウェアに追加しましたので(version 0.2.0)、これを持って皆様のご理解を賜り謝罪に変えさせて頂きたいと存じますm(__)m

## let_it_fall goの使い方

Macのターミナルを開いて`gem install let_it_fall`した上で、次のコマンドを打ちます。

    % let_it_fall go

こんな風になります。


![let_it_fall](http://gifzo.net/BQ3nYS0gg5S.gif)

> [BQ3nYS0gg5S.gif - Gifzo](http://gifzo.net/BQ3nYS0gg5S "BQ3nYS0gg5S.gif - Gifzo")

終了は`Ctrl-C`です。

## let_it_fallの他のコマンド

`let_it_fall`には`go`コマンドの他にも大量のコマンドがあります。おそらくその数はRubygem史上最多です。`let_it_fall`とだけ打つと使えるコマンドがわかります。

    % let_it_fall
    % Commands:
      let_it_fall MARK             # Let any of following MARKs fall
    
        alien alphabet angel animal apple arrow bee beer
        beers beginner bikini cactus cake christmas cocktail cookie
        cross cyclone dancer dingbat dolphin downarrow ear earth
        eyes face food fuji gem ghost helicopter hocho
        japan juice kanji kiss latin liberty lollipop love
        m money moon mouth naruto nose octopus oden
        oreilly paw perl pistol pizza please poo pushpin
        python smoking snow snowman soccer sorry sparkle sushi
        thunder time toilet tongue tower uparrow wavy wine
    
      let_it_fall matrix [MARK]   # Let it matrix!
      let_it_fall rand            # Let something fall randomly
      let_it_fall go              # Let them Go!
      let_it_fall code CODE       # Let specific character fall by unicode(s) ex. code 0x2660
      let_it_fall help [COMMAND]  # Describe available commands or one specific command
      let_it_fall version         # Show LetItFall version

お仕事に疲れたら`let_if_fall beer`、お腹が空いたなら`let_if_fall food`、愛が必要なら`let_if_fall love`、Pythonistaなら`let_if_fall python`、金平糖が好きなら`let_if_fall snow`、誰かに殺意を抱いたのなら`let_it_fall hocho`、ディズニーよりVFXなSF映画が好みなら`let_it_fall matrix`などとしてください。

追加コマンドのご要望は、[merborne on Twitter](https://twitter.com/merborne "merborne")または[github issueまたはプルリク](https://github.com/melborne/let_it_fall "melborne/let_it_fall")で随時受け付けています。またテストが一行もない（！）ので、それが書ける方も募集しています。

## お詫びに代えて　その２

もしあなたがRubyistで、あなたにとって最高の「Let It Go」が聴きたいのなら、次の記事を開いてください。

> [Let It Go for Rubyists](http://melborne.github.io/2014/05/10/let-it-go-for-rubyists/ "Let It Go for Rubyists")

---

なお、この記事の半分はフィクションです。

---

> [let_it_fall \| RubyGems.org \| your community gem host](https://rubygems.org/gems/let_it_fall "let_it_fall")
> 
> [melborne/let_it_fall](https://github.com/melborne/let_it_fall "melborne/let_it_fall")

---

関連記事：

> [Macのターミナルで顔が降る](http://melborne.github.io/2014/04/30/let-it-smile-in-the-terminal/ "Macのターミナルで顔が降る")
> 
> [Macのターミナルで〇〇が降る](http://melborne.github.io/2014/05/01/let-it-fall-in-the-mac-terminal/ "Macのターミナルで〇〇が降る")
> 
> [Macのターミナルでマトリックス?](http://melborne.github.io/2014/05/07/let-it-matrix-in-the-mac-terminal/ "Macのターミナルでマトリックス?")


{% footnotes %}
{% fn 物語化のため誇張してます。実際はdeeeet.comからのアクセスが最大でした。%}
{% endfootnotes %}

