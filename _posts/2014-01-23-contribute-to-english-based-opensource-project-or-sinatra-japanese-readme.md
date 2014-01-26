---
layout: post
title: "英語圏のオープンソースプロジェクトに貢献する最も簡単な方法またはsinatra/README.jp.mdまたは彼はなぜ私を愛するようになったか"
description: ""
category: 
tags: 
date: 2014-01-23
published: true
---
{% include JB/setup %}

今年はもう少しまじめにWebフレームワークというものを勉強しようと考えました。

[Rails](http://rubyonrails.org/ "Ruby on Rails")は私にはちょっと敷居が高いので、軽量Webフレームワークである[Sinatra](http://www.sinatrarb.com/ "Sinatra")を理解することに決めました。今までにSinatraを使ったことは何度かありますがSinatraを知っているとはいえない状況でした。

理解のために、まずは公式サイトのドキュメントを読むことにしました。

[サイト](http://www.sinatrarb.com/ "Sinatra")のトップにはプロジェクトの`README`が掲載されており、そのページを開くと実に9000ワード3000行にも及ぶ、充実した内容の機能解説が目に飛び込んできました。

その分量に圧倒されながらも、ページのヘッダ部分をよく見ると他言語によるREADMEへのリンクが張られていることに気づきました。そして有難いことに、その中には日本語版が含まれていました。

迷うことなく私は日本語版のページを開きました。そして愕然としました。

![sinatra noshadow]({{ BASE_PATH }}/assets/images/2014/01/sinatra01.png)

SinatraはDSLには違いありませんが、それとイコールではあり得ません。原文を確認してみると、果たして次のような正しい説明になっていました。

> Sinatra is a [DSL](http://en.wikipedia.org/wiki/Domain-specific_language) for quickly creating web applications in Ruby with minimal effort:

アップデートの過程で誤ってテキストを誰かが落としてしまったのでしょう。文頭の大切な一文にも拘らず、これが長い間放置されていたようです。翻訳文にはコミッタによるチェック機能が働かないのです。

加えて、日本語版の解説は原文に相当期間追随していないということがわかりました。調べてみると、細かい追加・修正は途中で何度かなされているものの、オリジナルの文章は2010年10月にアップデートされたバージョン1.0のものに対する解説、つまり３年以上も前に書かれたものだということが分かりました（最新バージョンは1.4）。

これらの出来事に私は少なからずショックを受けました。

ご存知のように、SinatraはRuby製のWebフレームワークにおいてRailsに次ぐ人気を誇るライブラリです。現在のGithubにおいてスターの数は5509であり、939のForkが存在し、193人のコントリビュータがいて、現在も活発にアップデートが続けられています。日本人ユーザも相当数が存在すると思われます。そのようなプロジェクトにおいて、３年以上も日本語ドキュメントのアップデートが放置されていたのです！

この事実つまり開発者とユーザとの間の深い溝あるいは言語の壁の問題の深さを痛感しうなだれていると、一条の光が差し込みそこにステージがこつ然と映し出されました。そしてステージ上には若く美しいスーパーヒーローが立っており、私に向いてやさしく微笑みかけながらこう言ったのです。

<br/>


![rkh noshadow](https://2.gravatar.com/avatar/5c2b452f6eea4a6d84c105ebd971d2a4?d=https%3A%2F%2Fidenticons.github.com%2F2ae3d2aaceaf26246581744124859b07.png&r=x&s=200)

「I'm waiting for you.」

「 君を待ってたんだ。」

---

こうして私は`sinatra/README.jp.md`のアップデートに取り掛かったのです。

技術力・翻訳力に不足する私には翻訳作業はかならずしも楽ではありませんでしたが、これがまずはSinatraの全体像を把握する最善の道ともなりました。不足する記述の追加だけでなく、既訳の修正、形式の統一などを行った結果、`README.jp.md`に対し1933件の追加、552件の削除を実施しました。

「[GitHubへpull requestする際のベストプラクティス - hnwの日記](http://d.hatena.ne.jp/hnw/20110528 "GitHubへpull requestする際のベストプラクティス - hnwの日記")」に従い、本家をcloneして専用ブランチで作業を行いそれをまとめて１件のpull requestを出しました。

数時間もするとメインコントリビュータの[rkh (Konstantin Haase)](https://github.com/rkh "rkh (Konstantin Haase)")からmergeしたのと通知を受けました。Pull Requestのページを開いてみると果たしてそこにはmergeしたとの事実だけではなく、彼の気持ちも示されていました。

![pull request noshadow]({{ BASE_PATH }}/assets/images/2014/01/sinatra02.png)

> [Update README.jp.md as a whole by melborne · Pull Request #832 · sinatra/sinatra](https://github.com/sinatra/sinatra/pull/832 "Update README.jp.md as a whole by melborne · Pull Request #832 · sinatra/sinatra")

今私は面識のない外国美少年からの突然の愛の告白に当惑していますが、pull requestをするというのはそういう意味つまり「私をプルして！」という意味だと悟ったのです。

もしあなたに愛が必要なら、お気に入りのオープンソースプロジェクトに是非ともPull Requestを投げてみてください。あなたの心は愛で満たされるはずです。

---

マージされた`README.ja.md`のリンクを貼っておきます。

> [sinatra/README.ja.md at master · sinatra/sinatra](https://github.com/sinatra/sinatra/blob/master/README.ja.md "sinatra/README.ja.md at master · sinatra/sinatra")

前述のとおり訳文に対しては開発者側のチェック機能は働いていないと思われます。よって、私の力不足によりドキュメントにはケアレスなミス、意味不明の解説、深刻な誤訳が含まれている可能性があります。このような問題に気づかれましたら、本家にプルリクするか、それが手間であれば私に連絡くだされば可能な限り対応します。

なお、上記ドキュメントはその変更点が多いためGithub上で差分表示ができません。差分は以下で確認できます。

> [History for README.jp.md - melborne/sinatra](https://github.com/melborne/sinatra/commits/update-readme-jp-spike/README.jp.md "History for README.jp.md - melborne/sinatra")

---

(追記:2014-1-26) `README.jp.md` => `README.ja.md`への変更がマージされたのでリンク先を修正。

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
