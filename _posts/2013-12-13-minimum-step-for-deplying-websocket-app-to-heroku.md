---
layout: post
title: "Ruby製WebSocketアプリを最速でHerokuにデプロイする５つのステップ"
tagline: "Sinatra-websocket-templateの紹介"
description: ""
category: 
tags: 
date: 2013-12-13
published: true
---
{% include JB/setup %}

「テレビ放送が駄目になった」と言われて久しいですがその理由ははっきりしています。それは放送というものがリアルタイム・コンテンツを扱う媒体だからです。リアルタイム・コンテンツはユーザの自由を奪います。ある番組を見るためにユーザはその時間テレビの前に固定化されます。録画放送番組は字義的にはバッファード・コンテンツ{% fn_ref 1 %}と言えますが、ユーザがそのコントロール権を持っていないつまりその視聴タイミングの制御を製作者側が持っているので、これはリアルタイム・コンテンツなのです。ユーザの唯一の武器はDVDレコーダによる制約の中のローカルバファリングのみです。

現在の**Web**は主としてバッファード・コンテンツを扱う媒体です。バッファード・コンテンツの世界ではユーザは好きな時間に好きなだけコンテンツを視聴できるという自由が与えられます。コンテンツの製作者側・提供者側にそのタイミングをコントロールする自由はありません。ユーザがコンテンツのコントロール権を持っている世界、それが**Web**なのです。

その一方でWebにも変化が訪れています。**体験の共有**に対する回帰です。リアルタイム・コンテンツの消費からバッファード・コンテンツの消費への移行でユーザが失ったもの、それが**体験の共有**です。体験の共有はコンテンツに対する消費の同時性つまりリアルタイム性を要求します。前述のようにこれはユーザにとっての制約です。しかしユーザは今、この制約の一部を受け入れてでもWeb上での体験の共有を求めるようになってきています。その結果としてWeb上のコンテンツもバッファード・コンテンツから偽リアルタイム・コンテンツにその一部が変質しつつあります。テキストコンテンツは頁という概念を失い、リアルタイム・コミュニケーションのために140文字の言葉のかけらに圧縮されました。

この変化をWebがすべてを飲み込んでいると見ることもできるでしょう。結局、この世界では誰もコントロール権など持っていない（いらない）、そう理解するのが正しいのかもしれません。

とか。

---

そんなわけで、WebSocketです。WebSocketはWebの世界で真のリアルタイムを実現します。そしてその準備は整いつつあります。

まずは体験です。さあ、次のリンクをクリックして真のリアルタイムの世界を、体験の共有を味わってください！

> [Typewr](http://typewr.herokuapp.com/ "Typewr")

使い方の説明はこちら。

> [チャット？　タイプライター？　音？　何？]({{ BASE_PATH }}/2013/12/10/is-this-chat-or-typewriter/ "チャット？　タイプライター？　音？　何？")

<br/>

スイマセン...遊びに来てくれる人が少なくて...宣伝...。

まあ、でもこれがWebSocketによるリアルタイムWebの一サンプルです。リアルタイムWebの世界は未開拓の地です。発想次第でユニークなものが生まれる可能性があります。

## Ruby製WebSocketアプリを最速でHerokuにデプロイする５つのステップ

さて、ここからが本題です。ふぅ。

Herokuでは現在試験的機能として、WebSocketを可能にするオプションが用意されています。これを使うと[Pusher](http://pusher.com/ "Pusher \| HTML5 WebSocket Powered Realtime Messaging Service")などの外部サービスに頼らずに、HerokuでホスティングされるWebアプリ上でWebSocketの機能を実現できるようになります。

> [Heroku Labs: WebSockets \| Heroku Dev Center](https://devcenter.heroku.com/articles/heroku-labs-websockets "Heroku Labs: WebSockets \| Heroku Dev Center")

加えて、HerokuはRuby（Sinatra）でWebSocketを使ったチャットシステムのサンプル＆デモも公開しています。

> [Using WebSockets on Heroku with Ruby \| Heroku Dev Center](https://devcenter.heroku.com/articles/ruby-websockets#deploy "Using WebSockets on Heroku with Ruby \| Heroku Dev Center")

で、この記事に従えばWebSocketのアプリを作って公開することが簡単にできるのですが、それでもやっぱり定型的なコードを一つずつ用意するのには骨が折れます。SinatraにはRailsのようなGeneratorもないですし。

そんなわけで...。

SinatraでWebSocketを作る際のスケルトンを生成する`Sinatra-websocket-template`というGemを作りました:-)

> [sinatra_websocket_template \| RubyGems.org \| your community gem host](https://rubygems.org/gems/sinatra_websocket_template "sinatra_websocket_template \| RubyGems.org \| your community gem host")
> 
> [melborne/sinatra-websocket-template](https://github.com/melborne/sinatra-websocket-template "melborne/sinatra-websocket-template")

`Sinatra-websocket-template`は、`bundle gem PROJECT`で生成されるファイル群に加えて、上記記事を参考にしたWebSocketに必要なファイル群を生成、出力します。ファイルにはWebSocketを実現するサンプルコードが載っているので、コードを一行も書くこと無くWebSocketの体験ができます。

以下では、このGemを使ってWebSocketアプリを作る手順および作ったWebアプリをHerokuにデプロイする手順を説明します。

##STEP1: Sinatra-websocket-templateのインストール

`Sinatra-websocket-template`をインストールします。

    % gem install sinatra_websocket_template
    Fetching: sinatra_websocket_template-0.0.1.gem (100%)
    Successfully installed sinatra_websocket_template-0.0.1
    1 gem installed

##STEP2: プロジェクトの生成

`sinatra_websocket_template`コマンドを実行してサブコマンドを確認します。

    % sinatra_websocket_template
    Commands:
      sinatra_websocket_template help [COMMAND]  # Describe available commands or one specific command
      sinatra_websocket_template new PROJECT     # Creates a skeleton for your project
      sinatra_websocket_template version         # Prints the SinatraWebsocketTemplate's version

`new`サブコマンドにプロジェクトの名前を渡して、プロジェクトのスケルトンを生成します。

    $ sinatra_websocket_template new hello_chat
          create  hello_chat/Procfile
          create  hello_chat/config.ru
          create  hello_chat/lib/app.rb
          create  hello_chat/lib/views/index.haml
          create  hello_chat/lib/public/css/main.css
          create  hello_chat/lib/public/js/application.js
          create  hello_chat/lib/hello_chat/backend.rb
          create  hello_chat/Gemfile
          create  hello_chat/Rakefile
          create  hello_chat/LICENSE.txt
          create  hello_chat/README.md
          create  hello_chat/.gitignore
          create  hello_chat/hello_chat.gemspec
          create  hello_chat/lib/hello_chat.rb
          create  hello_chat/lib/hello_chat/version.rb
    Initializating git repo in /Users/keyes/Dropbox/playground/hello_chat

プロジェクトのディレクトリに移動して、生成されたファイル群を確認します。

    % cd hello_chat
    /hello_chat% tree
    .
    ├── Gemfile
    ├── LICENSE.txt
    ├── Procfile
    ├── README.md
    ├── Rakefile
    ├── config.ru
    ├── hello_chat.gemspec
    └── lib
        ├── app.rb
        ├── hello_chat
        │   ├── backend.rb
        │   └── version.rb
        ├── hello_chat.rb
        ├── public
        │   ├── css
        │   │   └── main.css
        │   └── js
        │       └── application.js
        └── views
            └── index.haml
    
    6 directories, 14 files

折角だから、「[dir_friend](https://rubygems.org/gems/dir_friend "dir_friend")」を使って、ビジュアライズもします:-)


    % dir_friend dot .
    'a.dot' created in the current directory.

![hello chat noshadow]({{ BASE_PATH }}/assets/images/2013/12/hello_chat1.png)

（参考：[あなたはファイルシステムに美を見るか？]({{ BASE_PATH }}/2013/10/31/there-is-a-beauty-in-your-computer/ "あなたはファイルシステムに美を見るか？")）

この中でWebSocketを実現する重要なファイルは、`lib/hello_chat/backend.rb`と`lib/public/js/application.js`です。中身は後で確認するとして、先に進みます。

##STEP3: ローカルでのプロジェクトの起動

まずは`bundle install`します。

    /hello_chat% bundle install
    Fetching gem metadata from https://rubygems.org/...........
    Fetching gem metadata from https://rubygems.org/..
    Resolving dependencies...
    Using rake (10.1.0)
    Using bundler (1.3.5)
    Using dotenv (0.9.0)
    Using eventmachine (1.0.3)
    Using websocket-driver (0.3.1)
    Using faye-websocket (0.7.1)
    Using thor (0.18.1)
    Using foreman (0.63.0)
    Using tilt (1.4.1)
    Using haml (4.0.4)
    Using rack (1.5.2)
    Using puma (2.7.1)
    Using rack-protection (1.5.1)
    Using sinatra (1.4.4)
    Using hello_chat (0.0.1) from source at /Users/keyes/Dropbox/playground/hello_chat
    hello_chat at /Users/keyes/Dropbox/playground/hello_chat did not have a valid gemspec.
    This prevents bundler from installing bins or native extensions, but that may not affect its functionality.
    The validation message from Rubygems was:
      "FIXME" or "TODO" is not a description
    
    Your bundle is complete!
    Use `bundle show [gemname]` to see where a bundled gem is installed.

アプリケーションに必要なGemsがインストールされました。プロセスマネージャのforemanを通してアプリを起動します。

    /hello_chat% bundle exec foreman start
    13:37:24 web.1  | started with pid 18722
    13:37:27 web.1  | Puma starting in single mode...
    13:37:27 web.1  | * Version 2.7.1, codename: Earl of Sandwich Partition
    13:37:27 web.1  | * Min threads: 0, max threads: 16
    13:37:27 web.1  | * Environment: development
    13:37:27 web.1  | * Listening on tcp://0.0.0.0:5000
    13:37:27 web.1  | Use Ctrl-C to stop

5000番ポートでサーバが起動したので、２つのブラウザを起動してアクセスします。

それぞれのブラウザでページ上のHello!ボタンを交互に押してみます。


![hello chat noshadow]({{ BASE_PATH }}/assets/images/2013/12/hello_chat2.png)

WebSocketによる通信が成功しています。これでSinatra-websocket-templateで生成されるスケルトンで一応WebSocketが実現できることが確認できました。

##STEP4: プロジェクトのコードを書く

生成されたスケルトンを土台にしてプロジェクトに必要なコードを書きます。あなたの出番です。

`git commit`で準備が完了しました。

##STEP5: Herokuへデプロイ

プロジェクトが完成したのでHerokuにアプリを作ります。

    % heroku create hellochat

Heroku上のWebSocketの機能を有効にします。

    % heroku labs:enable websockets

デプロイです。

    % git push heroku master
    % heroku open

これで完了です。

## backend.rbとapplication.jsの中身

スケルトンにおける`backend.rb（WebSocketにおけるサーバー側）`と`application.js（クライアント側）`の中身だけ確認してみます。

backend.rbはRackのミドルウェアとして構成されています。

{% highlight ruby %}
# backend.rb
require 'faye/websocket'
require 'json'

module HelloChat
  class Backend
    KEEPALIVE_TIME = 15
    def initialize(app)
      @app = app
      @clients = []
    end

    def call(env)
      if Faye::WebSocket.websocket?(env)
        ws = Faye::WebSocket.new(env, nil, ping: KEEPALIVE_TIME)
        
        ws.on :open do |event|
          p [:open, ws.object_id]
          @clients << ws
          ws.send({ you: ws.object_id }.to_json)
          @clients.each do |client|
            client.send({ count: @clients.size }.to_json)
          end
        end

        ws.on :message do |event|
          p [:message, event.data]
          @clients.each { |client| client.send event.data }
        end

        ws.on :close do |event|
          p [:close, ws.object_id, event.code]
          @clients.delete(ws)
          @clients.each do |client|
            client.send({ count: @clients.size }.to_json)
          end
          ws = nil
        end
        ws.rack_response
      else
        @app.call(env)
      end
    end
  end
end
{% endhighlight %}

クライアント側からの通信がWebSocketに係る場合、Backend#callでそのイベントをソケット側にハイジャックし（Faye::WebSocket.websocket?(env)）、ここでそのイベントに応じた処理を返します。例えば、クライアント側からWebSocketに係るメッセージが送信されてきた場合は、これを`ws.on :message`で受けて、そのメッセージを全クライントにブロードキャストしています。また、クライアントが立ち上げられたときは、これを`ws.on :open`で受けて、そのクライアントに自身の識別ID（object_id）を返すと共に、クライアントの総数をブロードキャストしています。

次に、`application.js`のコードを見ます。

{% highlight javascript %}
// application.js
function counterRefresh (count) {
  $("#user-counter").val(count);
}

function appendMessage (userid, message) {
  $("#message-box").append("<div class='message'><span class='user-id'>" + userid + ":</span> " + message + "</div>");
}

$("#count-button").click(function(event) {
  var text = this.innerHTML;
  var data = JSON.stringify({ userid: myid, text: text });
  ws.send(data);
});

var myid;

var ws = new WebSocket(location.origin.replace(/^http/, 'ws'));

ws.onmessage = function(msg) {
  var data = JSON.parse(msg.data);
  if (data.you) { myid = data.you; }
  else if (data.text) {
    var id;
    myid==data.userid ? id = 'my-message' : id = data.userid;
    appendMessage(id, data.text);
  }
  else if (data.count) { counterRefresh(data.count); }
}
{% endhighlight %}

クライアント側では、WebSocketオブジェクトを生成して`ws.onmessage`にサーバー側からのメッセージを受けたときの処理を登録しています。そして受信データに含まれるプロパティに応じて処理を切り分けています。また、`Hello!`ボタンがクリックされたときに,`ws.send(data)`でサーバー側にメッセージを送信します。

以上で、説明は終わりです。

是非とも`Sinatra-websocket-template`をベースに何か面白いものを作ってくださいね。

---

<p style='color:red'>=== Ruby関連電子書籍100円で好評発売中！ ===</p>

[M'ELBORNE BOOKS]({{ BASE_PATH }}/books/ "M'ELBORNE BOOKS")

<a href="{{ BASE_PATH }}/books/">
  <img src="/assets/images/2012/ruby_parallel_cover.png" alt="ruby_parallel" style="width:200px" />
</a>
<a href="{{ BASE_PATH }}/books/">
  <img src="/assets/images/2012/rack_cover.png" alt="rack" style="width:200px" />
</a>
<a href="{{ BASE_PATH }}/books/">
  <img src="/assets/images/2012/js_oop_cover.png" alt="js_oop" style="width:200px" />
</a>


{% footnotes %}
{% fn 今勝手に考えた造語です。ユーザがランダムアクセス可能なリソースをイメージしています。 %}
{% endfootnotes %}
