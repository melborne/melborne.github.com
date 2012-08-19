---
layout: post
title: "Rackをminifyした僅か100行のLackで学ぶRackの中身"
description: ""
category: 
tags: 
date: 2012-08-08
published: true
---
{% include JB/setup %}

「[エラーメッセージから学ぶRack最初の一歩](http://melborne.github.com/2012/08/02/build-your-own-web-framework-with-rack/ 'エラーメッセージから学ぶRack最初の一歩')」および「[エラーメッセージから学ぶRack - Middlewareの魔法](http://melborne.github.com/2012/08/06/use-rack-middleware/ 'エラーメッセージから学ぶRack - Middlewareの魔法')」の続きです。

----

前２本の記事で、Rackは`rackup`コマンドを起動すると、defaultでconfig.ruを読み込みWebサーバを起動するということが分かりました。また、config.ruの中でuseを使ってmiddlewareを指定すると、Webアプリをラップして内側から外側に向けてそれらの#callを順次呼び出すということも分かりました。ちなみに僕はこの呼び出しスタイルを今後「マトリョーシカ呼び出し」と呼ぶことにしました。

ここで２点気になることがあります。config.ruはRubyスクリプトです。rackupコマンドの実行からRackはどうやってこのファイルを実行しているのでしょうか。まあ簡単に想像はつきますが（エバるほどではない）、これが１点目です。もう１点は、マトリョーシカ呼び出しの実装がどうなってるかです。

そんなわけで、今回はRackのソースを参照して、rackupコマンドからRackの起動の流れを追って行きたいと思います。つまりコードリーディングです。

## Rackの起動の流れを追う
と、言いたいところですが、これについては僕の出る幕はもうありません。なぜなら、**すがまさお**さんによる素晴らしい解析記事がすでに存在するからです。

> [Rackの起動の流れを追う - @sugamasao.blog.title # => ”コードで世界を変えたい”](http://d.hatena.ne.jp/seiunsky/20120213/1329152534 'Rackの起動の流れを追う - @sugamasao.blog.title # => ”コードで世界を変えたい”')


「先ずはこれを嫁」で、話は終わりなんですが、Rackのファイル構成を見ると、ここでは語られていない結構な数のファイルが存在することが分かります。このギャップから自分はRackの最小構成は一体何かということが気になったのでした。


そんなわけで...


Rackのミニマムを知るために、その最小構成だけを抽出したWebサーバインタフェース`Lack`を作りました^ ^;

`Lack`はRackに対し、次の欠落があります。

> 1. optionを一切受け付けない。
> 1. mapが使えない。
> 1. middlewareが１つも含まれていない。
> 1. WEBRick, Thin以外のWebサーバを使えない。
> 1. エラー処理がなされていない。
> 1. Rackの各種ユーティリティ(Rack::Utils, Rack::Requestとか)が全く使えない。

つまりLackは、Rackのdefaule設定でWebサーバを起動するための最低構成のインタフェースです。つまりLackは、Rackのベースを知るための教則コードです。以下では、先の記事で、すがまさおさんがRackのソースを使って行なっていたことと同じことを、Lackのソースを使って駆け足で行います。

## Rackのファイル構成
Lackのソースを追う前に、まずは本家Rackのファイル構成を見てみます。Rack1.4.1のlib/rackディレクトリ以下は次のようになっています。

{% highlight bash %}
[in]: /gems/rack-1.4.1/lib/rack/
..
+ auth/          
+ backports/     
+ handler/       
+ multipart/     
+ session/       
- body_proxy.rb                               500B 
- builder.rb                               3.79  K 
- cascade.rb                                  808B 
- chunked.rb                               1.32  K 
- commonlogger.rb                          1.49  K 
- conditionalget.rb                        1.97  K 
- config.rb                                   277B 
- content_length.rb                           765B 
- content_type.rb                             672B 
- deflater.rb                              2.71  K 
- directory.rb                             4.0   K 
- etag.rb                                  1.77  K 
- file.rb                                  3.59  K 
- handler.rb                               2.73  K 
- head.rb                                     257B 
- lint.rb                                  20.99 K 
- lobster.rb                               1.83  K 
- lock.rb                                     483B 
- logger.rb                                   357B 
- methodoverride.rb                           803B 
- mime.rb                                  30.38 K 
- mock.rb                                  5.24  K 
- multipart.rb                             1.13  K 
- nulllogger.rb                               386B 
- recursive.rb                             1.71  K 
- reloader.rb                              2.95  K 
- request.rb                               10.66 K 
- response.rb                              3.99  K 
- rewindable_input.rb                      3.18  K 
- runtime.rb                                  710B 
- sendfile.rb                              4.43  K 
- server.rb                                9.23  K 
- showexceptions.rb                        11.64 K 
- showstatus.rb                            3.46  K 
- static.rb                                2.14  K 
- urlmap.rb                                2.7   K 
- utils.rb                                 15.70 K 

10 directories, 63 files
{% endhighlight %}

ファイル行数も数えてみましょう。

{% highlight bash %}
/gems/rack-1.4.1% wc -l lib/rack/**/*
   7126 total
{% endhighlight %}
これら63ファイルのトータル行数は7126行ありました。大量のファイルに目が眩みます。

一方、これらのファイル郡を整理すると、おおまかに４つのグループ、すなわち（１）Core、（２）Helper、（３）Middleware、（４）sample Web Applicationに分類できました{% fn_ref 1 %}。

{% highlight bash %}
[Core]
- server.rb                                9.23  K 
- builder.rb                               3.79  K 
- handler.rb                               2.73  K 

[Helper]
+ backports/                         [DIR]         
+ handler/                           [DIR]         
+ multipart/                         [DIR]         
- body_proxy.rb                               500B 
- directory.rb                             4.0   K 
- file.rb                                  3.59  K 
- mime.rb                                  30.38 K 
- mock.rb                                  5.24  K 
- multipart.rb                             1.13  K 
- request.rb                               10.66 K 
- response.rb                              3.99  K 
- rewindable_input.rb                      3.18  K 
- urlmap.rb                                2.7   K 
- utils.rb                                 15.70 K 

[Middleware]
+ auth/                              [DIR]         
+ session/                           [DIR]         
- cascade.rb                                  808B 
- chunked.rb                               1.32  K 
- commonlogger.rb                          1.49  K 
- conditionalget.rb                        1.97  K 
- config.rb                                   277B 
- content_length.rb                           765B 
- content_type.rb                             672B 
- deflater.rb                              2.71  K 
- etag.rb                                  1.77  K 
- head.rb                                     257B 
- lint.rb                                  20.99 K 
- lock.rb                                     483B 
- logger.rb                                   357B 
- methodoverride.rb                           803B 
- nulllogger.rb                               386B 
- recursive.rb                             1.71  K 
- reloader.rb                              2.95  K 
- runtime.rb                                  710B 
- sendfile.rb                              4.43  K 
- showexceptions.rb                        11.64 K 
- showstatus.rb                            3.46  K 
- static.rb                                2.14  K 

[sample Web Application]
- lobster.rb                               1.83  K 
{% endhighlight %}

RackのCoreは僅か３ファイルで構成されており、ファイルの大半はMiddlewareということが分かりました。

Coreの行数を見てみます。
{% highlight bash %}
/gems/rack-1.4.1% wc -l lib/rack/builder.rb lib/rack/handler.rb lib/rack/server.rb 
     145 lib/rack/builder.rb
      94 lib/rack/handler.rb
     323 lib/rack/server.rb
     562 total
{% endhighlight %}
思いの外サイズが小さいです。でもまだ読む気になりません。

## Lackのファイル構成
さて、次にRackの欠落版`Lack`のファイル構成を見ます。

{% highlight bash %}
% tree lack 
lack
├── bin
│   └── lackup
└── lib
    ├── lack
    │   ├── builder.rb
    │   ├── handler
    │   │   ├── thin.rb
    │   │   └── webrick.rb
    │   ├── handler.rb
    │   └── server.rb
    └── lack.rb
4 directories, 7 files
{% endhighlight %}
lib/lack内にはCoreとなるserver.rb, builder.br, handler.rbがあります。handlerディレクトリ内の２つのファイルはRackからそのままコピーしたそれらWebサーバのインタフェースです。

Coreの３ファイルの行数を見てみます。

{% highlight bash %}
/lack% wc -l lib/lack/server.rb lib/lack/builder.rb lib/lack/handler.rb
      61 lib/lack/server.rb
      25 lib/lack/builder.rb
       9 lib/lack/handler.rb
      95 total
{% endhighlight %}
僅か95行です。これなら読む気になりますね！{% fn_ref 2 %}

## Coreファイルのソース
Coreファイルのソースを順番に載せます。なお、これらの各クラスにおけるメソッドの呼び出し構造は、オリジナルのものから変えていません。その結果、一見無駄なことをやっているように見える部分がありますが、その点ご了承ください。まずは、メインとなる`server.rb`です。

<script src="https://gist.github.com/3284736.js?file=lib/lack/server.rb"></script>

次に、`builder.rb`。

<script src="https://gist.github.com/3284736.js?file=lib/lack/builder.rb"></script>

最後に、`handler.rb`です。

<script src="https://gist.github.com/3284736.js?file=lib/lack/handler.rb"></script>


## Lackの起動の流れを追う
これらのファイルを見れば一目瞭然なので、説明はいらない気がしますが、一応追ってみます。

まずはこれらのファイルで前回作った`draque`がちゃんと動くか確かめます。起動コマンドはもちろん`lackup`です。
{% highlight bash %}
/draque% ./lack/bin/lackup
>> Thin web server (v1.3.1 codename Triple Espresso)
>> Maximum connections set to 1024
>> Listening on 0.0.0.0:9292, CTRL+C to stop
{% endhighlight %}

browserでhttp://localhost:9292にアクセスします。

![draque10]({{ site.url }}/assets/images/draque10.png)

うまく動いていますね。

まずは`lackup`コマンドの中身を見ます。
{% highlight ruby %}
#!/usr/bin/env ruby
require_relative "../lib/lack"
Lack::Server.start #0
{% endhighlight %}
僅か３行ですが、これは基本的に本家`rackup`と同じです。

## server.rbを追う

lackupではLack::Serverクラスのstartクラスメソッドが呼ばれています。server.rbの対応箇所を見ます。

{% highlight ruby %}
class Lack::Server
  def self.start #1
    new.start
  end

  def start #2
    server.run wrapped_app, options
  end

  def options #3
    @options ||= parse_options(ARGV)
  end

  def parse_options(args) #4
    default_options
  end

  def default_options #5
    {
      :environment => ENV['RACK_ENV'] || "development",
      :pid         => nil,
      :Port        => 9292,
      :Host        => "0.0.0.0",
      :AccessLog   => [],
      :config      => "config.ru"
    }
  end
end
{% endhighlight %}
呼び出しの順位に従って番号を振ってあります。流れを追って行きましょう。

> 1.　Lack::Server.startは#newでServerオブジェクトを生成して#startメソッドを呼ぶ。
>
> 2.　Server#startは、wrapped_appとoptionsを引数にserver.runを呼ぶ。

Server#startでLackのすべてが表現されている気がします。ここでwrapped_appは、前回の説明で想像できるように、Webアプリをmiddlewareでラップしたものと想像できます。wrapped_appを後にして、まずはoptionsを追ってみます。optionsはそのすぐ下にある通りメソッドです。

> 3.　#optionsは、ARGVつまりコマンドライン引数をparse_optionsメソッドに渡して、その解析結果を@optionsインスタンス変数へ代入する。
>
> 4.　#parse_optionsは、単にdefault_optionsメソッドを呼び出す。オリジナルでは、ここで引数の解析を行います。
>
> 5.　#default_optionsは、デフォルト設定のハッシュを返す。:configキーには'config.ru'がセットされる。

さて、Server#startに戻って、wrapped_appを追います。wrapped_appもメソッド呼び出しです。Rubyでは無引数のメソッド呼び出しとローカル変数は見た目が同じなので、これらは等価なものと考えていいと思います。

{% highlight ruby %}
class Lack::Server
  def start #2
    server.run wrapped_app, options
  end

  def wrapped_app #6
    @wrapped_app ||= build_app app
  end

  def app #7
    @app = Lack::Builder.parse_file(self.options[:config])
  end
end
{% endhighlight %}

> 6.　#wrapped_appは、appを引数にbuild_appメソッドを呼んで、その結果を@wrapped_appにセットします。

まずは引数のappメソッドを追います。

> 7.　#appは、options[:config]を引数に、Lack::Builder.parse_fileを呼び出し、結果を@appにセットします。

## builder.rbを追う

options[:config]は先ほど見た通り'config.ru'を指しています。ここから想像されるように、Lack::Builderは、config.ruをパースしてアプリオブジェクトを構築（ビルド）するようです。では、`builder.rb`に移ってコードを見てみます。

{% highlight ruby %}
class Lack::Builder
  def self.parse_file(config) #8
    cfgfile = ::File.read(config)
    app = eval "Lack::Builder.new {\n" + cfgfile + "\n}.to_app", TOPLEVEL_BINDING, config
    return app
  end

  def initialize(&block) #9
    @use = []
    instance_eval(&block)
  end
end
{% endhighlight %}

> 8.　Builder.parse_fileは、"Lack::Builder.new { }.to_app"をevalして、Webアプリオブジェクトを生成する。このブロックに`config.ru`ファイルの内容を渡す。

どうやら、気になる１点目に来たようです。やっぱりエバってました。evalの第2引数でevalするコンテキストをTOPLEVL_BINDING（つまりクラスの外側）としていますが、なければLack::Builderのコンテキストでevalされるので、必ずしもいらない気がします{% fn_ref 3 %}。また、次のような書き方もできますね。
{% highlight ruby %}
 app = eval "new {\n" + cfgfile + "\n}.to_app"
{% endhighlight %}

さて、次にBuilder#initializeを見ます。

> 9.　@useに空配列をセットし、ブロックをinstance_evalする。

ブロックつまりconfig.ruの内容は、そのインスタンスつまりBuilderオブジェクトのコンテキストでevalされます。ここで前の記事で作ったdraqueのconfig.ruを再掲します。

{% highlight ruby %}
# config.ru
require "./draque"

class UpDown
  def initialize(app)
    @app = app
  end

  def call(env)
    status, headers, body = @app.call(env)
    [status, headers, body.reverse]
  end
end

class Fire
  def initialize(app, pattern)
    @app = app
    @pattern = pattern
  end

  def call(env)
    status, headers, body = @app.call(env)

    replace = ->pat{ "<em style='background-color:red'>#{pat}</em>" }
    new_body = body.inject([]) { |m, part| m << part.gsub(@pattern) { replace[$&] } }
    
    [status, headers, new_body]
  end
end

use Fire, /rack|draque/i

use UpDown

run method(:draque)
{% endhighlight %}

さてconfig.ru内には`use`および`run`メソッド呼び出しが書かれています。initializeにおいてこのファイルをinstance_evalすることにより、これらはBuilderオブジェクトのメソッド呼び出しと評価されます。ちなみに、UpDownおよびFireの各クラスはトップレベルで定義されたものと解釈されるようです。では、use, runのメソッド定義を見てみます。

{% highlight ruby %}
class Lack::Builder
  def use(middleware, *args, &block) #10
    @use << proc { |app| middleware.new(app, *args, &block) }
  end

  def run(app) #11
    @run = app
  end
end
{% endhighlight %}

> 10.　#useは引数のmiddleware（これはクラス）を#newする処理をProcオブジェクトでラップして、@use配列に追加する。第2以降の引数とブロックは#newにそのまま渡される。

ここでのポイントは、Procオブジェクトの呼び出し時に、#newの第1引数にappが渡されてmiddleware#newの第1引数として渡される点です。ええ、例のマトリョーシカするためですね:)

次に#runを見ます。

> 11.　#runは引数のappを@runにセットする。

これだけです。

さて次に、Builder.parse_fileに戻って、続きを見ます。上記処理によりBuilderオブジェクトを生成した後に、すぐに#to_appし、evalはそれを評価するようになっています。evalしてから#to_appしてもいい気がしますが、どうなんでしょう。では#to_appを見てみます。

{% highlight ruby %}
class Lack::Builder
  def self.parse_file(config) #8
    cfgfile = ::File.read(config)
    app = eval "Lack::Builder.new {\n" + cfgfile + "\n}.to_app", TOPLEVEL_BINDING, config
    return app
  end

  def to_app #12
    app = @run
    @use.reverse.inject(app) { |a,e| e[a] }
  end
end
{% endhighlight %}

> 12.　@useに登録したmiddlewareのProcラッパーを逆順で呼び出し、injectで@runにセットしたappに順次畳み込む。

「マトリョーシカ」の登場です。先のconfig.ruの例で追ってみます。

> 1. appにはdraqueアプリがセットされる。
> 1. @use.reverseで後からuseしたUpDown middlewareのProcラッパーが#[]つまり#callされ、その引数にdraqueが渡される。
> 1. これによりdraqueをラップしたUpDownオブジェクトが生成され、injectのapp変数にセットされる。
> 1. 次にFire MiddlewareのProcラッパーが#callされ、その引数にUpDownオブジェクトが渡される。
> 1. これによりUpDownオブジェクトをラップしたFireオブジェクトが生成され、injectのapp変数にセットされる。
> 1. イテレーションが終了し、#to_appの返り値として上記Fireオブジェクトが返る。

以上でbuilder.rbにおけるBuilder.parse_fileの呼び出しが完了しました。

## server.rbに戻る

さて、Builder.parse_fileの呼び出し元sever.rbのappに戻ります。

{% highlight ruby %}
class Lack::Server
  def wrapped_app #6
    @wrapped_app ||= build_app app
  end

  def app #7
    @app = Lack::Builder.parse_file(self.options[:config])
  end
end
{% endhighlight %}

\#appでparse_fileからの返り値つまりビルドされたアプリが@appにセットされ、それは、#wrapped_appにおいて、更にbuild_appの引数として渡されます。ビルドされたアプリを、更にビルドするようです。#build_appを見てみます。

{% highlight ruby %}
class Lack::Server
  def build_app(app) #13
    middleware[options[:environment]].reverse.inject(app) { |a, mid| mid.new(a) }
  end

  def middleware #14
    self.class.middleware
  end

  def self.middleware #15
    @middleware ||= begin
      m = Hash.new {|h,k| h[k] = []}
      # m["deployment"].concat [
      #   [Rack::ContentLength],
      #   [Rack::Chunked],
      #   logging_middleware
      # ]
      # m["development"].concat m["deployment"] + [[Rack::ShowExceptions], [Rack::Lint]]
      m
    end
  end
end
{% endhighlight %}

> 13.　middlewareに登録したmiddlewareを逆順で呼び出し、injectでオブジェクト化してappに順次畳み込む。

Buider#to_appとそっくりな処理が出てきました。つまりto_appにおいてmiddlewareにラップされたappを、さらに別のmiddlewareでラップするようです。middlewareはメソッド呼び出しのようですから、これを追ってみましょう。

> 14.　#middlewareはServer.middlewareクラスメソッドを呼ぶ。
>
> 15.　Server.middlewareは各環境ごとに選択された複数のmiddlewareを@middlewareに登録する。

なるほど各Serverオブジェクトは、defaultで共通のmiddlewareをいくつか読み込むんですね。そして、それらをappにラップするというわけです。前回の記事でRack::Lint::LintErrorが吐かれていたのは、ここでLintを組み込んでいたからなんですね。なお、Lackではこれらのmiddlewareを持っていないので、コメントアウトして空のハッシュが返るようにしています。

さあ以上で、wrapped_appメソッドにおいて@wrapped_appにmiddlewareでラップされたWebアプリがセットされました。そして、#startにおいてserver.runに渡される引数が確定したわけです。

{% highlight ruby %}
class Lack::Server
  def start #2
    server.run wrapped_app, options
  end

  def wrapped_app #6
    @wrapped_app ||= build_app app
  end
{% endhighlight %}

さあ、もう一歩です。serverもメソッド呼び出しですから見てみます。

{% highlight ruby %}
class Lack::Server
  def server #16
    @_server ||= Lack::Handler.default(options)
  end
end
{% endhighlight %}

> 16.　Lack::Handler.default(options)を呼び出し、結果を@_serverにセットする。

## handler.rbを追う

`handler.rb`に移って、その実装を見てみます。

{% highlight ruby %}
module Lack::Handler
  def self.default(options = {}) #17
     Lack::Handler::Thin
   rescue LoadError
     Lack::Handler::WEBrick
  end
  autoload :WEBrick, "lack/handler/webrick"
  autoload :Thin, "lack/handler/thin"
end
{% endhighlight %}

> 17.　Lack::Handler::Thinをロードし、失敗した場合はLack::Handler::WEBrickをロードする。

本家Rackではもちろん引数のoptionsを使っていますが、Lackでは無視してまずはThinサーバを呼び、ダメならWEBrickを呼びます。

これで無事、@_serverにThinまたはWEBrickサーバがセットされ、Server.startにおけるserver.runが呼べるようになりました。では、次にThinサーバのrunクラスメソッドを見てみましょう。

## thin.rbを追う
Thin WebサーバのRackインタフェースはlack/handler/thin.rbです。見てみましょう。

{% highlight ruby %}
require "thin"

module Lack::Handler
  class Thin
    def self.run(app, options={}) #18
      server = ::Thin::Server.new(options[:Host] || '0.0.0.0',
                                  options[:Port] || 8080,
                                  app)
      yield server if block_given?
      server.start
    end

    def self.valid_options
      {
        "Host=HOST" => "Hostname to listen on (default: localhost)",
        "Port=PORT" => "Port to listen on (default: 8080)",
      }
    end
  end
end
{% endhighlight %}

このコードはRackのコードそのままです。

> 18.　Thin.runでは、Thinサーバオブジェクトを生成し、#startで起動する。

ここでThinサーバにmiddlewareでラップされたWebアプリ（app）が渡されていることが確認できます。

この状態で、BrowserからThinサーバに対してリクエストがあると、渡されたappのcallメソッドが呼び出され、アプリにおけるマトリョーシカ呼び出しが実行され、そのレスポンスが生成されることになります。一応、Thinサーバにおけるapp.call呼び出しのコードの部分を載せておきます。

{% highlight ruby %}
module Thin
  class Connection < EventMachine::Connection
    def pre_process

      # When we're under a non-async framework like rails, we can still spawn
      # off async responses using the callback info, so there's little point
      # in removing this.
      response = AsyncResponse
      catch(:async) do
        # Process the request calling the Rack adapter
        response = @app.call(@request.env)
      end
      response
    rescue Exception
      handle_error
      terminate_request
      nil # Signal to post_process that the request could not be processed
    end
end
{% endhighlight %}

以上で、lackupから始まってサーバが起動されるまでの流れに沿った、`Lack`のコードリーディングは完了です。

最後までお付き合いありがとうございますm(__)m

しかし、高々100行のコードを説明するのがこんな大変なことだとは思いませんでしたorz

[Lack is a minified Rack just for study. — Gist](https://gist.github.com/3284736 'Lack is a minified Rack just for study. — Gist')

----

{{ "B003ZX8G5A" | amazon_medium_image }}

{{ "B003ZX8G5A" | amazon_link }}

----

{% footnotes %}
  {% fn 精査していないので、間違いがあるかも知れません %}
  {% fn すべてのファイルを含めると193行になります %}
  {% fn 第3引数を渡すために書いているのかもしれません %}
{% endfootnotes %}
