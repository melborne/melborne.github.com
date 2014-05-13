---
layout: post
title: "Sinatraが、Jekyllが、オープンソース翻訳プロジェクトが、今静かに動き出している"
tagline: "Togglateの小さいアップデートのお知らせ"
description: ""
category: 
tags: 
date: 2014-04-03
published: true
---
{% include JB/setup %}

## Sinatraの日本語ドキュメント

私は以前の記事で、軽量なWEBサイト構築DSLである[Sinatra](http://www.sinatrarb.com/ "Sinatra")プロジェクトにおけるドキュメントの日本語版作成が滞っていたので、私がそれを一歩進めたら彼に愛されたということを書きました。

> [英語圏のオープンソースプロジェクトに貢献する最も簡単な方法またはsinatra/README.jp.mdまたは彼はなぜ私を愛するようになったか]({{ BASE_PATH }}/2014/01/23/contribute-to-english-based-opensource-project-or-sinatra-japanese-readme/ "英語圏のオープンソースプロジェクトに貢献する最も簡単な方法またはsinatra/README.jp.mdまたは彼はなぜ私を愛するようになったか")

その後、このプロジェクトでは複数の日本語を扱える方たちがそのメンテナンスを継続下さっていて、オリジナルドキュメントの更新がマージされると速やかに日本語版の更新が作成され、またときとして、その更新版に間違いが見つかると別の方がこれを指摘または修正する、という理想的な環境になっています。私のケアレスなミスも随分と直して頂きました。

## Jekyllの日本語ドキュメント

ところで、このブログの構築にも利用している[Jekyll](http://jekyllrb.com/ "Jekyll")という静的サイト構築のためのソフトウェアプロジェクトがあります。このプロジェクトは、「[Jekyllいつやるの？ジキやルの？今でしょ！]({{ BASE_PATH }}/2013/05/20/now-the-time-to-start-jekyll/ "Jekyllいつやるの？ジキやルの？今でしょ！")」でも書いた通り、停滞気味だった開発が１年半ほど前から非常に活発になっています。そして、そのドキュメントも極めて充実したものが提供されているのですが、一方でその日本語版が存在しない状況が続いていました。

しかしここに来て、[@kk_Ataka](https://twitter.com/kk_Ataka "ごしゅじん (kk_Ataka) on Twitter")(gosyujin)さんが、その日本語翻訳リポジトリを立ち上げ、その翻訳活動を開始されたのです。

> [gosyujin/jekyllrb.com.jp](https://github.com/gosyujin/jekyllrb.com.jp "gosyujin/jekyllrb.com.jp")
> 
> [Jekyll • シンプルで、ブログのような、静的サイト](http://gosyujin.github.io/jekyllrb.com.jp/ "Jekyll • シンプルで、ブログのような、静的サイト")

実は自分も、Jekyllドキュメントの充実っぷりに刺激を受けて以前にその翻訳にトライしたことがあるのですが、完全に停滞していたのでこれは大変有難いです。加えて、Sinatraにおける私の活動が切っ掛けということで、有り難さ倍増です。

![jekyll noshadow]({{ BASE_PATH }}/assets/images/2014/04/jekyll_translate01.png)

@kk_Atakaさんによれば、翻訳ドキュメントの本家への取り込みを本家側に相談するも、そのメンテナンス性の点から難しいとされ、別リポジトリを立ち上げたという経緯があるそうです。

> [Jekyllドキュメントの日本語翻訳リポジトリ「jekyllrb.com.jp」を作成しました - kk_Atakaの日記](http://d.hatena.ne.jp/kk_Ataka/20140314/1394723421 "Jekyllドキュメントの日本語翻訳リポジトリ「jekyllrb.com.jp」を作成しました - kk_Atakaの日記")

この日本語翻訳リポジトリでは、推敲・翻訳を手伝ってくれる人を募集しているそうですので、興味のある方はこの機会に参加・貢献されてみては如何でしょうか。

ということで、SinatraとJekyllにおける日本語翻訳活動が少しずつ動き出している感があり、自分がこれに絡めていることが嬉しいですね。

## togglateの小さいアップデート

さて、私は先のSinatraにおける翻訳を切っ掛けに、翻訳ドキュメントの生成を支援する[togglate](https://rubygems.org/gems/togglate "togglate")というツールを作ってることは、このブログで何度か言いました。

> [素晴らしいオープンソースプロジェクトにおける翻訳者たちの憂鬱とその緩和]({{ BASE_PATH }}/2014/04/01/togglate-now-have-reverse-action/ "素晴らしいオープンソースプロジェクトにおける翻訳者たちの憂鬱とその緩和")

それで、このツールの存在を[@chezou](https://twitter.com/chezou "chezou (chezou) on Twitter")さんが@kk_Atakaさんに伝えてくれて、@kk_AtakaさんがJekyllの翻訳リポジトリで使えないかいろいろと検証してくれています。

> [[WIP]togglateの検証 · Issue #36 · gosyujin/jekyllrb.com.jp](https://github.com/gosyujin/jekyllrb.com.jp/issues/36 "[WIP]togglateの検証 · Issue #36 · gosyujin/jekyllrb.com.jp")

自分はSinatraのプロジェクトではtogglateを使うことができておらずその検証が不十分だったので、これは大変助かります。

で、取り急ぎ、次の２点だけ対応したversion0.1.3をリリースしましたので、お知らせ致します。

> 1. 対応Rubyバージョンを2.1.0以上から2.0.0以上に変更
> 2. Liquidタグ（{{ "{%  "}} %}）によるブロックに対応

1.については「Refinementsをモジュール内で使ってみたかった」という理由だけだったのでその使用を止めました。ただ、2.0から導入されたキーワード引数を随所で使っていたので1.9への対応は諦めました。2.についてはこれによりLiquidタグで囲まれた箇所は、他のブロック同様、一つのコメントタグで囲まれるようになりました。ただ、現状、togglateは4スペースで字下げされたコードブロックには対応できていません（実装方法を検討中です）。

検証で挙がっている他の事項についてもこれから検討し、対応できるものはしていくつもりですので、togglateを今後ともよろしくお願いします。


> [togglate \| RubyGems.org \| your community gem host](https://rubygems.org/gems/togglate "togglate \| RubyGems.org \| your community gem host")
> 
> [melborne/togglate](https://github.com/melborne/togglate "melborne/togglate")
