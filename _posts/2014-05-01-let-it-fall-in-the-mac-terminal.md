---
layout: post
title: "Macのターミナルで〇〇が降る"
tagline: "let_it_fall.gemのご紹介"
description: ""
category: 
tags: 
date: 2014-05-01
published: true
---
{% include JB/setup %}

(追記:2014-5-6) let_it_fallをバージョンアップしました(version0.1.2)。

> [Macのターミナルでマトリックス?]({{ BASE_PATH }}/2014/05/06/let-it-matrix-in-the-mac-terminal/ "Macのターミナルでマトリックス?")

---

取り急ぎ、「Macのターミナルで〇〇が降る」をgem化しましたので、お知らせ致します。

---

> [let_it_fall \| RubyGems.org \| your community gem host](https://rubygems.org/gems/let_it_fall "let_it_fall \| RubyGems.org \| your community gem host")
> 
> [melborne/let_it_fall](https://github.com/melborne/let_it_fall "melborne/let_it_fall")

## 使い方

Macのターミナルを開いて、`gem install let_it_fall`と打ってインストールします。

インストールができたら次のように打ちます。

    $ let_it_fall beer

終了は`Ctrl-c`です。

    $ let_it_fall money

とかすると幸せになれるかもしれません。

    $ let_it_fall help

で使えるコマンドが表示されます。お腹が空いたら`food`してください。`perl`, `python`はありますが、残念ながら`ruby`はありません。代わりに`gem`してください。個人的には`moon`, `kanji`が好きです。

任意の**何か**を降らせたいときは`rand`してください(version0.0.3~)。


スピード調整用のオプション`--speed`があります（ex -s=3）。レンジは0.1〜10くらいでしょうか。

## let_it_fall code
`let_it_fall code`というコマンドだけが特殊で、これは0xで始まるunicodeを引数に取ります。

    $ let_it_fall code 0x2660

複数のunicodeを取ることができ、さらに`--range`オプションで範囲指定もできます。

    $ let_it_fall code 0x2660 0x2666 -r

以下のサイトでunicodeと対応キャラクタの一覧（一部）が確認できます。

> [Emoji unicode characters for use on the web](http://apps.timwhitlock.info/emoji/tables/unicode "Emoji unicode characters for use on the web")


辛いことがあったときに、どうぞ。

---

関連記事：

> [Let it Snow in the Terminal of Mac OS X with This Command](http://osxdaily.com/2013/12/06/snow-terminal-mac-os-x-command/ "Let it Snow in the Terminal of Mac OS X with This Command")

> [「Macのターミナルで雪が降る」をカラー化した。翻訳した。]({{ BASE_PATH }}/2013/12/13/translate-let-it-snow-in-the-terminal/ "「Macのターミナルで雪が降る」をカラー化した。翻訳した。")

> [Macのターミナルで顔が降る](http://melborne.github.io/2014/04/30/let-it-smile-in-the-terminal/ "Macのターミナルで顔が降る")

> [Macのターミナルでビールが降る  SOTA](http://deeeet.com/writing/2014/04/30/beer-on-terminal/ "Macのターミナルでビールが降る SOTA")

---

(追記:2014-5-2) `rand`コマンドについて追記しました。

---

<p style='color:red'>=== Ruby関連電子書籍100円〜で好評発売中！ ===</p>

[M'ELBORNE BOOKS]({{ BASE_PATH }}/books/ "M'ELBORNE BOOKS")

<a href="{{ BASE_PATH }}/books/">
  <img src="/assets/images/books/ruby_pack8.png" alt="pack8" style="width:200px" />
</a>
<a href="{{ BASE_PATH }}/books/">
  <img src="/assets/images/books/ruby_parallel_cover.png" alt="ruby_parallel" style="width:200px" />
</a>


