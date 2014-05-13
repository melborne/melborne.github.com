---
layout: post
title: "翻訳ドキュメント作成支援ツールTogglateで翻訳要らず？"
tagline: "Add translate option to Togglate create subcommand"
description: ""
category: 
tags: 
date: 2014-02-25
published: true
---
{% include JB/setup %}


翻訳ドキュメント作成支援ツール「`togglate`」というものがありまして。これは単に、翻訳ドキュメント内に原文をそのセンテンスごとに埋め込んで、翻訳ドキュメントを作るためのベースとなるものを出力するだけの極めて単純なミニツールです。

> [togglate \| RubyGems.org \| your community gem host](https://rubygems.org/gems/togglate "togglate \| RubyGems.org \| your community gem host")
> 
> [melborne/togglate](https://github.com/melborne/togglate "melborne/togglate")

基本的にはmarkdownで書かれた原文を基にHTMLの訳文を作る、以下のようなプロセスで使われることを想定しています。

![togglate noshadow]({{ BASE_PATH }}/assets/images/2014/02/togglate1.png)

詳しくは以下の記事を読んでください。

> [英語圏のオープンソースプロジェクトにおける翻訳ドキュメントの問題点とその解決のための一方策（仕切り直し版）]({{ BASE_PATH }}/2014/02/17/update-togglate-for-renewed-proposal-to-translation/ "英語圏のオープンソースプロジェクトにおける翻訳ドキュメントの問題点とその解決のための一方策（仕切り直し版）")

図において、「**You!**」と書かれたところが翻訳者の手仕事になります。

ここで世界全自動化信奉者としては「**You!**」のところを何とかしたい、と考えるわけです。

そんなわけで...

`togglate create`サブコマンドに`translate`オプションを付けました（version 0.1.1）。

なお、togglateは本バージョンよりRuby2.1.0以降が必要になります（Refinmentsしたかったもので..）。

## translateオプション

togglateはその出力において、原文の各センテンスの前には訳を書く位置を示す`[translation here]`という文字列を挿入します。`translate`オプションを利用すると、この文字列に代えて機械翻訳による原文対応訳が挿入されることになります。翻訳は[MyMemory translated.net](http://mymemory.translated.net/doc/spec.php "MyMemory API technical specifications")のAPIを通して取得しています（APIの制約などについては後述します）。

このオプションはハッシュを取るので以下のようにします。

    % togglate create README.md --translate=from:en to:ja > README.ja.md

`to`は省略できませんが`from`を省略した場合はen(English)からの翻訳として解釈されます。

## 出力サンプル その１

`translate`オプションを実際に使ってみます。RailsのREADME.mdから翻訳ドキュメントを作るとします。各センテンスが500文字以下になるように加工します。

{% highlight text %}
## Welcome to Rails

Rails is a web-application framework that includes everything needed to
create database-backed web applications according to the
[Model-View-Controller (MVC)](http://en.wikipedia.org/wiki/Model%E2%80%93view%E2%80%93controller)
pattern.

Understanding the MVC pattern is key to understanding Rails. MVC divides your
application into three layers, each with a specific responsibility.

The _Model layer_ represents your domain model (such as Account, Product,
Person, Post, etc.) and encapsulates the business logic that is specific to
your application. In Rails, database-backed model classes are derived from
`ActiveRecord::Base`.

Active Record allows you to present the data from
database rows as objects and embellish these data objects with business logic
methods. Although most Rails models are backed by a database, models can also
be ordinary Ruby classes, or Ruby classes that implement a set of interfaces
as provided by the Active Model module. You can read more about Active Record
in its [README](activerecord/README.rdoc).

The _Controller layer_ is responsible for handling incoming HTTP requests and
providing a suitable response. Usually this means returning HTML, but Rails controllers
can also generate XML, JSON, PDFs, mobile-specific views, and more. Controllers load and
manipulate models, and render view templates in order to generate the appropriate HTTP response.

In Rails, incoming requests are routed by Action Dispatch to an appropriate controller, and
controller classes are derived from `ActionController::Base`. Action Dispatch and Action Controller
are bundled together in Action Pack. You can read more about Action Pack in its
[README](actionpack/README.rdoc).

The _View layer_ is composed of "templates" that are responsible for providing
appropriate representations of your application's resources. Templates can
come in a variety of formats, but most view templates are HTML with embedded
Ruby code (ERB files). Views are typically rendered to generate a controller response,
or to generate the body of an email. In Rails, View generation is handled by Action View.
You can read more about Action View in its [README](actionview/README.rdoc).

Active Record, Action Pack, and Action View can each be used independently outside Rails.
In addition to them, Rails also comes with Action Mailer ([README](actionmailer/README.rdoc)), a library
to generate and send emails; and Active Support ([README](activesupport/README.rdoc)), a collection of
utility classes and standard library extensions that are useful for Rails, and may also be used
independently outside Rails.

## Getting Started

1. Install Rails at the command prompt if you haven't yet:

        gem install rails

2. At the command prompt, create a new Rails application:

        rails new myapp

   where "myapp" is the application name.

3. Change directory to `myapp` and start the web server:

        cd myapp
        rails server

   Run with `--help` or `-h` for options.

4. Using a browser, go to `http://localhost:3000` and you'll see:
"Welcome aboard: You're riding Ruby on Rails!"

5. Follow the guidelines to start developing your application. You may find
   the following resources handy:
    * [Getting Started with Rails](http://guides.rubyonrails.org/getting_started.html)
    * [Ruby on Rails Guides](http://guides.rubyonrails.org)
    * [The API Documentation](http://api.rubyonrails.org)
    * [Ruby on Rails Tutorial](http://ruby.railstutorial.org/ruby-on-rails-tutorial-book)

## Contributing

We encourage you to contribute to Ruby on Rails! Please check out the
[Contributing to Ruby on Rails guide](http://edgeguides.rubyonrails.org/contributing_to_ruby_on_rails.html) for guidelines about how to proceed. [Join us!](http://contributors.rubyonrails.org)

## Code Status

* [![Build Status](https://travis-ci.org/rails/rails.png?branch=master)](https://travis-ci.org/rails/rails)

## License

Ruby on Rails is released under the [MIT License](http://www.opensource.org/licenses/MIT).

{% endhighlight %}

> [rails/README.md at master · rails/rails](https://github.com/rails/rails/blob/master/README.md "rails/README.md at master · rails/rails")


このドキュメントに対し次のコマンドを適用し`README.ja.md`を得ます。

    % togglate create README.md --translate=to:ja --code-block --no-embed-code > README.ja.md

ここでは`--code-block`オプションによりコードブロックを翻訳対象外とし、`--no-embed-code`で原文を表示・非表示させるJavaScriptコードを挿入しないようにしています。

出力はこのようになります。

{% highlight text %}
レールに＃＃ようこそ

<!--original
## Welcome to Rails
-->

Railsは、[モデル - ビュー - コントローラ（MVC）]（http://en.wikipedia.org/wiki/Model％E2％80％に従ってデータベース支援のWebアプリケーションを作成するために必要なすべてが含まれていたWebアプリケーションフレームワークです93view％のE2％80％93controller）パターン。

<!--original
Rails is a web-application framework that includes everything needed to
create database-backed web applications according to the
[Model-View-Controller (MVC)](http://en.wikipedia.org/wiki/Model%E2%80%93view%E2%80%93controller)
pattern.
-->

MVCパターンを理解することは、レールを理解するうえで重要です。 MVCは3層、具体的な責任を持って、それぞれにアプリケーションを分割します。

<!--original
Understanding the MVC pattern is key to understanding Rails. MVC divides your
application into three layers, each with a specific responsibility.
-->

_modelのlayer_は（などのアカウント、製品、人物、ポストなど）ドメインモデルを表しており、アプリケーションに固有のもので、ビジネスロジックをカプセル化します。 Railsでは、データベース支援のモデルクラスは `のActiveRecord :: Baseの`から派生しています。

<!--original
The _Model layer_ represents your domain model (such as Account, Product,
Person, Post, etc.) and encapsulates the business logic that is specific to
your application. In Rails, database-backed model classes are derived from
`ActiveRecord::Base`.
-->

[translation here]

<!--original
Active Record allows you to present the data from
database rows as objects and embellish these data objects with business logic
methods. Although most Rails models are backed by a database, models can also
be ordinary Ruby classes, or Ruby classes that implement a set of interfaces
as provided by the Active Model module. You can read more about Active Record
in its [README](activerecord/README.rdoc).
-->

_controllerのlayer_は受信HTTP要求を処理し、適切な応答を提供する責任があります。通常、これはHTMLを返すことを意味するが、コントローラはまた、XML、JSON、PDFファイル、携帯電話固有のビューなどを生成することができますRailsの。コントローラ負荷やモデルを操作し、適当なHTTP応答を生成するために、ビューテンプレートをレンダリングする。

<!--original
The _Controller layer_ is responsible for handling incoming HTTP requests and
providing a suitable response. Usually this means returning HTML, but Rails controllers
can also generate XML, JSON, PDFs, mobile-specific views, and more. Controllers load and
manipulate models, and render view templates in order to generate the appropriate HTTP response.
-->

Railsでは、着信要求を適切なコントローラにアクションディスパッチによってルーティングされ、コントローラクラスは `ActionController :: Baseの`から派生しています。行動発送、アクションコントローラはアクションパックに一緒にバンドルされています。あなたはその[READMEを]（actionpack / README.rdoc）でアクションパックについての詳細を読むことができます。

<!--original
In Rails, incoming requests are routed by Action Dispatch to an appropriate controller, and
controller classes are derived from `ActionController::Base`. Action Dispatch and Action Controller
are bundled together in Action Pack. You can read more about Action Pack in its
[README](actionpack/README.rdoc).
-->

_Viewのlayer_は、アプリケーションのリソースの適切な表現を提供する責任がある「テンプレート」で構成されている。テンプレートには、さまざまな形式で来ることができるが、ほとんどのビューテンプレートは、埋め込まれたRubyコード（ERBファイル）をHTML形式である。ビューは、通常、コントローラの応答を生成するために、または電子メールの本文を生成するためにレンダリングされる。 Railsでは、ビュー生成は、アクションビューによって処理されます。あなたは、その[READMEを]でアクションの表示についての詳細を読むことができます（はActionView / README.rdoc）。

<!--original
The _View layer_ is composed of "templates" that are responsible for providing
appropriate representations of your application's resources. Templates can
come in a variety of formats, but most view templates are HTML with embedded
Ruby code (ERB files). Views are typically rendered to generate a controller response,
or to generate the body of an email. In Rails, View generation is handled by Action View.
You can read more about Action View in its [README](actionview/README.rdoc).
-->

アクティブレコード、アクションパック、およびアクションビューには、各レールの外に独立して使用することができます。それらに加えて、Railsはまた、アクションメーラー（[READMEを]（のActionMailer / README.rdoc））、電子メールを生成して送信するためのライブラリが付属しています。とアクティブサポート（[READMEを]（activesupportの/ README.rdoc））、コレクションユーティリティクラスとRailsのために有用である標準ライブラリの拡張の、またRailsの外で独立して使用することができる。

<!--original
Active Record, Action Pack, and Action View can each be used independently outside Rails.
In addition to them, Rails also comes with Action Mailer ([README](actionmailer/README.rdoc)), a library
to generate and send emails; and Active Support ([README](activesupport/README.rdoc)), a collection of
utility classes and standard library extensions that are useful for Rails, and may also be used
independently outside Rails.
-->

はじめに

<!--original
## Getting Started
-->

1。あなたは、まだいない場合は、コマンドプロンプトでレールを取り付けます。

<!--original
1. Install Rails at the command prompt if you haven't yet:
-->

        gem install rails

2。コマンドプロンプトで、新しいRailsアプリケーションを作成します。

<!--original
2. At the command prompt, create a new Rails application:
-->

        rails new myapp

「myappのは、「アプリケーション名です。

<!--original
   where "myapp" is the application name.
-->

3。 `myappに &#39;にディレクトリを変更し、Webサーバーを起動します。

<!--original
3. Change directory to `myapp` and start the web server:
-->

        cd myapp
        rails server

オプションのヘルプ `や`-H &#39; -  `で実行されます。

<!--original
   Run with `--help` or `-h` for options.
-->

4。ブラウザを使用して、 `http://localhost:3000に`に移動し、あなたが表示されます。「乗っようこそ！あなたはRuby on Railsで乗っている」

<!--original
4. Using a browser, go to `http://localhost:3000` and you'll see:
"Welcome aboard: You're riding Ruby on Rails!"
-->

5。アプリケーションの開発を開始するためのガイドラインに従ってください。あなたが便利な以下のリソースを見つけることができます：*（http://guides.rubyonrails.org/getting_started.html）[Railsの入門] * [Railsのガイドのルビー]（http://guides.rubyonrails.org）* [ APIドキュメント]（http://api.rubyonrails.org）* [ルビーon Railsのチュートリアル]（http://ruby.railstutorial.org/ruby-on-rails-tutorial-book）

<!--original
5. Follow the guidelines to start developing your application. You may find
   the following resources handy:
    * [Getting Started with Rails](http://guides.rubyonrails.org/getting_started.html)
    * [Ruby on Rails Guides](http://guides.rubyonrails.org)
    * [The API Documentation](http://api.rubyonrails.org)
    * [Ruby on Rails Tutorial](http://ruby.railstutorial.org/ruby-on-rails-tutorial-book)
-->

＃＃貢献

<!--original
## Contributing
-->

私たちはRuby on Railsでに貢献することをお勧めします！進め方についてのガイドラインについては、[案内レール上のRubyへの貢献]（http://edgeguides.rubyonrails.org/contributing_to_ruby_on_rails.html）をチェックしてみてください。 [ご参加！]（http://contributors.rubyonrails.org）

<!--original
We encourage you to contribute to Ruby on Rails! Please check out the
[Contributing to Ruby on Rails guide](http://edgeguides.rubyonrails.org/contributing_to_ruby_on_rails.html) for guidelines about how to proceed. [Join us!](http://contributors.rubyonrails.org)
-->

＃＃コードステータス

<!--original
## Code Status
-->

* [！[ステータスのビルド]（https://travis-ci.org/rails/rails.png?branch=master）]（https://travis-ci.org/rails/rails）

<!--original
* [![Build Status](https://travis-ci.org/rails/rails.png?branch=master)](https://travis-ci.org/rails/rails)
-->

ライセンス

<!--original
## License
-->

Ruby on Railsはは[MITライセンス]（http://www.opensource.org/licenses/MIT）の下でリリースされている。

<!--original
Ruby on Rails is released under the [MIT License](http://www.opensource.org/licenses/MIT).
-->
{% endhighlight %}

「乗っようこそ！あなたはRuby on Railsで乗っている」

想像以上の良い結果が得られました。

## 出力サンプル その２

日本語から英語の翻訳も試してみます。

{% highlight text %}
Ruby（ルビー）は、まつもとゆきひろ（通称 Matz）により開発されたオブジェクト指向スクリプト言語であり、スクリプト言語が用いられてきた領域でのオブジェクト指向プログラミングを実現する。

概要
Ruby は当初1993年2月24日に生まれ、1995年12月にfj上で発表された。名称の Ruby は、プログラミング言語 Perl が6月の誕生石である Pearl（真珠）と同じ発音をすることから、まつもとの同僚の誕生石（7月）のルビーを取って名付けられた。

機能として、クラス定義、ガベージコレクション、強力な正規表現処理、マルチスレッド、例外処理、イテレータ、クロージャ、Mixin、演算子オーバーロードなどがある。Perl を代替可能であることが初期の段階から重視されている。Perlと同様にグルー言語としての使い方が可能で、C言語プログラムやライブラリを呼び出す拡張モジュールを組み込むことができる。

Ruby 処理系は、主にインタプリタとして実装されている（詳しくは#実装を参照）。
可読性を重視した構文となっている。Ruby においては整数や文字列なども含めデータ型はすべてがオブジェクトであり、純粋なオブジェクト指向言語といえる。

長らく言語仕様が明文化されず、まつもとによる実装が言語仕様に準ずるものとして扱われて来たが、2010年6月現在、JRuby や Rubinius といった互換実装の作者を中心に機械実行可能な形で明文化する RubySpec という試みが行われている。公的規格としては2011年3月22日にJIS規格（JIS X 3017）が制定され、その後2012年4月1日に日本発のプログラム言語では初めてISO/IEC規格（ISO/IEC 30170）として承認された [2]。

フリーソフトウェアとして Ruby ライセンス（Ruby License や Ruby'sと表記されることもある。GPLかArtisticに似た独自ライセンスを選択するデュアルライセンス。）で配布されている。
設計思想

開発者のまつもとゆきひろは、「Rubyの言語仕様策定において最も重視しているのはストレスなくプログラミングを楽しむことである (enjoy programming)」と述べている。（ただし、まつもとによる明文化された言語仕様は存在しない。）

Perlのモットー「やり方はいろいろある (There's More Than One Way To Do It; TMTOWTDI)」は「多様性は善 (Diversity is Good)」というスローガンで Ruby に引き継がれてはいるものの最重要なものではないとも述べており、非推奨な手法も可能にするとともに、そのような手法を言語仕様により使いにくくすることによって自粛を促している。これは言語仕様が「望ましい」習慣の押し付けを行うということであり、洗脳言語（Babel-17）と言われる一面でもある。
{% endhighlight %}

> [Ruby - Wikipedia](http://ja.wikipedia.org/wiki/Ruby "Ruby - Wikipedia")


コマンドを実行します。

    % togglate create RUBY.txt --translate=from:ja to:en --no-embed-code > RUBY.en.txt

結果は次のようになりました。

{% highlight text %}
Ruby （ Ruby ） to provide object-oriented programming in object-oriented scripting language developed by Hiromi （ a.k.a. Matz ） Matz, and scripting language has been used.

<!--original
Ruby（ルビー）は、まつもとゆきひろ（通称 Matz）により開発されたオブジェクト指向スクリプト言語であり、スクリプト言語が用いられてきた領域でのオブジェクト指向プログラミングを実現する。
-->

About Ruby initially was born in 2/24/1993, was announced on the fj 12/1995. Named, taking the Ruby Birthstone name Ruby is from that sounded similar to the programming language Perl in the June birthstone Pearl （ Pearl ） Matsumoto and colleagues (July).

<!--original
概要
Ruby は当初1993年2月24日に生まれ、1995年12月にfj上で発表された。名称の Ruby は、プログラミング言語 Perl が6月の誕生石である Pearl（真珠）と同じ発音をすることから、まつもとの同僚の誕生石（7月）のルビーを取って名付けられた。
-->

As a function, a class definition, garbage collection, powerful regular expression processing, multithreading, exception processing, iterators, closures, Mixin, operator overloading, etc. Perl have been emphasizing from the early stages that alternate. You can incorporate the extension module allows use as a glue language similar to Perl and C programs and libraries to call.

<!--original
機能として、クラス定義、ガベージコレクション、強力な正規表現処理、マルチスレッド、例外処理、イテレータ、クロージャ、Mixin、演算子オーバーロードなどがある。Perl を代替可能であることが初期の段階から重視されている。Perlと同様にグルー言語としての使い方が可能で、C言語プログラムやライブラリを呼び出す拡張モジュールを組み込むことができる。
-->

Ruby processing system is implemented primarily as an interpreter （ for details # implementing ）. Has been emphasizing human-readable syntax. Ruby integer and string data types including the all objects in a pure object-oriented language can be said.

<!--original
Ruby 処理系は、主にインタプリタとして実装されている（詳しくは#実装を参照）。
可読性を重視した構文となっている。Ruby においては整数や文字列なども含めデータ型はすべてがオブジェクトであり、純粋なオブジェクト指向言語といえる。
-->

Long language specification does not stipulate, Matz and by implementing other equivalent language specification has been named RubySpec came is treated as a 6/2010 now, the author-compatible implementations like JRuby and Rubinius is written mainly machinery available in. 3/22/2011 to JIS （ JIS X 3017 ） enacted as public standards, then 2012 April 1 in Japan from programming languages for the first time as an ISO/IEC standard （ ISO/IEC 30170 ） approved [2].

<!--original
長らく言語仕様が明文化されず、まつもとによる実装が言語仕様に準ずるものとして扱われて来たが、2010年6月現在、JRuby や Rubinius といった互換実装の作者を中心に機械実行可能な形で明文化する RubySpec という試みが行われている。公的規格としては2011年3月22日にJIS規格（JIS X 3017）が制定され、その後2012年4月1日に日本発のプログラム言語では初めてISO/IEC規格（ISO/IEC 30170）として承認された [2]。
-->

Ruby's license as a free software （ may be referred to as Ruby License and Ruby's. Dual license to choose their own licenses like the GPL or Artistic.
） in have been distributed. Design philosophy

<!--original
フリーソフトウェアとして Ruby ライセンス（Ruby License や Ruby'sと表記されることもある。GPLかArtisticに似た独自ライセンスを選択するデュアルライセンス。）で配布されている。
設計思想
-->

Matz of the developer does, ' is very important in the Ruby language specification is enjoy the programming without the stress that (enjoy programming)"and said. （ Matsumoto, however, and by the written language specification does not exist. ）

<!--original
開発者のまつもとゆきひろは、「Rubyの言語仕様策定において最も重視しているのはストレスなくプログラミングを楽しむことである (enjoy programming)」と述べている。（ただし、まつもとによる明文化された言語仕様は存在しない。）
-->

Perl's motto ' there are various ways (There's More Than One Way To Do It; TMTOWTDI) ' is says, is not taken over Ruby in the slogan that diversity is good (Diversity is Good), but the most important ones and also a non-recommended to refrain from urging by cumbersome language specification techniques so that the method also enables you to. Also one side doing language specification is desirable habits are pushing this, and said to brainwash language （ Babel-17 ）.

<!--original
Perlのモットー「やり方はいろいろある (There's More Than One Way To Do It; TMTOWTDI)」は「多様性は善 (Diversity is Good)」というスローガンで Ruby に引き継がれてはいるものの最重要なものではないとも述べており、非推奨な手法も可能にするとともに、そのような手法を言語仕様により使いにくくすることによって自粛を促している。これは言語仕様が「望ましい」習慣の押し付けを行うということであり、洗脳言語（Babel-17）と言われる一面でもある。
-->
{% endhighlight %}

なかなか上出来です。でも、まつもとさんが海外で「**Hiromi**」って呼ばれてるの、初めて知りましたよw

## MyMemory Translated.netの利用について

MyMemoryはWebから利用できる[Translation Memory(翻訳メモリ)](http://ja.wikipedia.org/wiki/%E7%BF%BB%E8%A8%B3%E3%83%A1%E3%83%A2%E3%83%AA "翻訳メモリ - Wikipedia")のサービスで、翻訳結果を取得するREST APIが公開されています。

> [MyMemory API technical specifications](http://mymemory.translated.net/doc/spec.php "MyMemory API technical specifications")

このAPIにアクセスするRuby gem「[spaghetticode/mymemory](https://github.com/spaghetticode/mymemory "spaghetticode/mymemory")」が公開されており、togglateではこれを利用しています。


### アクセスの制約

MyMemoryは無料で認証手続きも不要なので直ぐに利用できることが利点です。一方で、一日のAPIコールが**100回**までという制約があります。Togglateを使って日に100回を超えるアクセスをした場合、翻訳結果の代わりに次のメッセージが挿入されることになります。

    MYMEMORY WARNING: YOU USED ALL AVAILABLE FREE TRANSLATION FOR TODAY. CONTACT ALBERTO@TRANSLATED.NET TO TRANSLATE MORE

このメッセージにあるようにMyMemory側にコンタクトしてメールアドレスを登録すれば、1000 requests/dayまで利用できるようになるようです。自分はまだ試していませんが、登録したメールアドレスを`--translate`に渡すことで一応対応できるようにはなっています。

    % togglate create README.md --translate=to:ja email:user@yourdomain.com

現在のtogglateの実装では、各センテンスブロックごとにAPIコールを発するというユーザ＆APIフレンドリ**でない**ものになっているので、項目数の多いドキュメントを対象にすると直ぐにリミットに達してしまいます。必要に応じて、短いセンテンスをまとめるなどして対応してください。

一方で、一つのセンテンスが500文字を超えると、アクセスは拒否され代わりに次のメッセージが挿入されることになります。

    QUERY LENGTH LIMIT EXCEDEED. MAX ALLOWED QUERY : 500 CHARS

センテンスを分割して対応してください。

この辺はtogglate側でよしなにやってくれるべきですよねー。

また、各アクセスは5秒でタイムアウトするようになっています。その場合は代わりに`[translation here]`が挿入されます。先のサンプルでも一箇所タイムアウトしたところがあったようです。

<br/>


そんなわけで、`togglate create`に`translate`オプションを付けたよ、という話でした。


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


