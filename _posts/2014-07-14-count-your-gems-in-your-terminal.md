---
layout: post
title: "自分が公開しているgemの日々のダウンロード数が気になって寝られません。どうしたらいいでしょうか（Yawhoo知恵袋）"
description: ""
category: 
tags: 
date: 2014-07-14
published: true
---
{% include JB/setup %}

## 質問

【ID非公開さん】

> [RubyGems.org](https://rubygems.org/ "RubyGems.org")でいくつかのチンピラgemを公開してます。それらの人気度が気になって毎日サイトにアクセスしてます。サイトでは個々のgemの総ダンロード数はわかるんですが、僕が知りたいのは、今日どのgemがどれくらいダンロードされたかなんです。これって、知る方法ないですか？

## ベストアンサーに選ばれた回答

【melborneさん】

> 「[Mygegegems](https://rubygems.org/gems/mygegegems "mygegegems")」というgemを使ってください。使い方を説明します。


### Mygegegemsの使い方

ターミナルを開いて、`gem install mygegegems`でインストールが完了したら、次のようにしてローカルデータをアップデートします。

    % mygegegems update
    Your gems data updated!(/Users/keyes/.mygegegems.yaml)

初めて`update`を実行するとあなたのホームディレクトリに`.mygegegems.yaml`というファイルが生成されます。

そして、次のようにすれば、あなたのgemのダウンロード数がターミナルに出力されます。

    % mygegegems stat
    As of 2014-07-14 (last: 2014-07-13)
    -----------------------------------
    14061 + 0 gviz
     9349 + 0 colorable
     7175 + 0 flippy
     6173 + 0 maliq
     4505 + 0 hateda2md
     3345 + 0 let_it_fall
     2784 + 0 dir_friend
     2357 + 0 yampla
     2227 + 2 togglate
     1656 + 0 ctoD
     1072 + 0 gsub_filter
      977 + 0 hatebu_entry
      762 + 0 emot
      401 + 0 money_exchange
      373 + 4 gh-diff
      370 + 0 itunes_track
      349 + 0 sinatra_websocket_template
      306 + 5 tildoc
      299 + 0 matreska
      143 +41 mygegegems
    -----------------------------------
    58684 +52 20 gems

あなたが前日にも`mygegegems update`を行っている場合には、この出力のようにその差分も同時に出力されます。ですから日々のダウンロード数が知りたいのであれば、少なくとも一日に一度は`update`を行ってください。そうすればデータは、`.mygegegems.yaml`に蓄積されていきます。

Mygegegemsの利用を始めてからひと月が経過したら`--target=last_month`オプションを付けて`stat`を実行してみてください。先月から現在までのダウンロード数が分かります。

## 質問２

> ライバルのgemのダウンロード数も気になるんですが。


## 回答２

> `stat`に`--handle`オプションを渡してください。

    % mygegegems stat --handle=webster132
    webster132's gems
    ------------------------------
     43528735   -  activesupport
     37099337   -  rails
     34430394   -  activerecord
     33366557   -  actionpack
     32336612   -  actionmailer
     31319769   -  activemodel
     27515830   -  activeresource
     27036316   -  railties
     17819546   -  jquery-rails
      3470429   -  jbuilder
      3034996   -  turbolinks
       938464   -  actionview
       779842   -  strong_parameters
       391404   -  protected_attributes
       270171   -  actionwebservice
       200740   -  cache_digests
        62006   -  pjax_rails
        42795   -  routing_concerns
        27548   -  tolk
        27301   -  actionpack-xml_parser
        24967   -  commands
        12722   -  custom_configuration
        10933   -  pjax-rails
         6933   -  instiki
         2104   -  activesupport-json_encoder
         1191   -  activemodel-globalid
          604   -  activejob
          285   -  actionmailer-deliver_later
    ------------------------------
    293758531 28 gems

他のオプションは、`mygegegems help stat`により参照してください。

## 質問３

> 変化のグラフくらい出力できないんですか？


## 回答３

> できません。「[BestGems](http://bestgems.org/ "BestGems")」を使うか、気長に待つか、それができなければ[PR](https://github.com/melborne/mygegegems "melborne/mygegegems")してください。

---

> [mygegegems](https://rubygems.org/gems/mygegegems "mygegegems")
> 
> [melborne/mygegegems](https://github.com/melborne/mygegegems "melborne/mygegegems")

