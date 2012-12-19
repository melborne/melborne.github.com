---
layout: post
title: irbから学ぶRubyの並列処理 ~ forkからWebSocketまで
date: 2011-09-29
comments: true
categories:
---

(追記：2012-12-13)
本記事を電子書籍化しました。「[Gumroad](https://gumroad.com/ 'Gumroad')」を通して100円にて販売しています。内容についての追加・変更はありませんが、文体の変更、誤記の修正およびメディア向けの調整を行っています。

![Ruby Parallel Ebook]({{ site.url }}/assets/images/2012/ruby_parallel_cover.png)

<a href="http://gum.co/PjVk" class="gumroad-button">電子書籍「irbから学ぶRubyの並列処理 ~ forkからWebSocketまで」EPUB版 </a><script type="text/javascript" src="https://gumroad.com/js/gumroad-button.js"></script><script type="text/javascript" src="https://gumroad.com/js/gumroad.js"></script>

このリンクはGumroadにおける商品購入リンクになっています。クリックすると、オーバーレイ・ウインドウが立ち上がって、この場でクレジットカード決済による購入が可能です。購入にはクレジット情報およびメールアドレスの入力が必要になります。購入すると、入力したメールアドレスにコンテンツのDLリンクが送られてきます。

購入ご検討のほどよろしくお願いしますm(__)m

関連記事： [電子書籍「irbから学ぶRubyの並列処理 ~ forkからWebSocketまで」EPUB版をGumroadから出版しました！]({{ site.url }}/2012/12/13/ruby-parallel-on-ebook/ '電子書籍「irbから学ぶRubyの並列処理 ~ forkからWebSocketまで」EPUB版をGumroadから出版しました！')

---
世の中は並列化花ざかりだよ。人間はシングルタスクのままなのに、プログラミングするときはマルチタスクが要求されるなんて、世知辛い世の中になったものだね。

でも、情報革命は始まったばかりだから、愚痴ってばかりもいられないよ。自分がその波にうまく乗れないとしても、うまく乗ってる人の様を間近で見てみたいと思うんだ。

そんなわけで..

Rubyのfork、Thread、Reactor、EventMachine、WebSocketなどの並列化について少し学んだので、自分の理解をここにまとめておくよ。

##REPL
irbはRubyにおける対話型の実行環境だよ。これは一般にはREPLと呼ばれてるんだ。REPLはユーザの入力を読み取り(Read)、評価し(Eval)、出力する(Print) 処理を、繰り返すよ(Loop)。

irbのコードは5000行にものぼるらしいけど、その核心は次のように1行で書けるよ。
{% highlight ruby %}
 loop{ puts eval gets }
{% endhighlight %}
getsでユーザ入力を読み取り、evalで評価し、putsで出力する処理を、loopで繰り返す。これじゃGEPLだけどね:)

このコードを保存して(gepl.rb)、実行してみよう。
{% highlight sh %}
$ ruby gepl.rb
%w(ruby lisp haskell).map(&:upcase)
RUBY
LISP
HASKELL       
"hello, repl!".gsub('r','g')
hello, gepl!  
{% endhighlight %}
ちゃんと動いてるね。Ctrl+Cで終了するよ。

通常loopは無限ループを生成するけど、先のコードではgetsのところで処理が止まり、ユーザからの入力を待ち受ける。ここがポイントだよ。

ちなみにこのコードは、その入出力を明示的にして次のようにも書けるね。
{% highlight ruby %}
loop do
  input = $stdin.gets
  output = eval(input)
  $stdout.puts output
end
{% endhighlight %}
デフォルトでグローバル変数$stdinと$stdoutには、標準入力、標準出力がセットされてるから、キーボードからの入力が読み取られ、ディスプレイに出力がなされるんだ。

##マルチユーザーREPL
REPLは１ユーザに対する対話環境だよ。でも複数ユーザで使えたらもっとうれしいよね。どうすればいい？

そうだよ。入出力と評価(eval)を切り離せばいいんだよ。いわゆるクライアント・サーバー方式だね。クライアントからの入力をサーバーに渡して評価し、結果をクライアントに出力する。

じゃあ早速REPLサーバーを書いてみるよ。
{% highlight ruby %}
#repl_server.rb
require "socket"
server = TCPServer.new(60000)
loop do
  client = server.accept   # clientからの接続を待つ
  
  begin
    loop { client.puts eval client.gets }
  rescue
  ensure
    client.close
  end
end
{% endhighlight %}
Rubyならこんなに簡単に書けちゃうんだ。TCPServer.newでサーバーインスタンスを生成し、acceptメソッドでクライアントからの接続を待ち受けるよ。クライアントが接続したら、getsでユーザからの入力を評価し結果をユーザに返す。接続したクライアント(これをソケットと呼ぶよ)からgetsし、ソケットにputsしてるところがポイントだよ。

$stdin $stdoutの参照先をクライアントのソケットに切り替えるやり方にすると、最初のコードとの違いがはっきりするかもね。
{% highlight ruby %}
#repl_server.rb
require "socket"
server = TCPServer.new(60000)
loop do
  client = server.accept
  begin
    $stdin, $stdout = client, client
    loop { puts eval gets }
  rescue
  ensure
    client.close
    $stdin = STDIN
    $stdout = STDOUT
  end
end
{% endhighlight %}
ensure節ではこれらの後処理をしているよ。

サーバーを立ち上げてクライアントから接続してみようよ。telnetを使うね。
{% highlight sh %}
$ telnet localhost 60000
Trying 127.0.0.1...
Connected to localhost.
Escape character is '^]'.
3.times.map { "Hello, friend" }
Hello, friend
Hello, friend
Hello, friend
{% endhighlight %}
いい感じだね。Ctrl+]に続きquitでtelnetの接続を切るよ。

##並列化REPL
でも先のサーバーには大きな問題があるよ。誰か一人が接続していると他の人が接続できない、つまり複数の人が同時に使えないんだよ。先のコードで１つの接続がacceptされると、loop内のgetsはその接続先ユーザからの入力を待ち続けることになる。で、そのユーザの接続が切れてはじめて、処理はループされacceptで別の接続を待ち受けられるようになるんだ。これは大問題だね。複数のターミナルから接続して試してみればわかるよ。

さあ、ここで並列化の出番だよ。

Rubyで並列化を実現するにはいくつかの方法があるよ。ちょっとどんなやり方があるか考えてみてくれる？

##個別接続による並列化
もっとも単純な方法は処理が終わるたびに、ユーザからの接続を毎回切る方法だよ。前のユーザの接続が切れれば、サーバーは別の接続を待てるからね。まあ、これを並列化と呼ぶのはどうかとも思うけど..

コードは次のような感じになるかな。
{% highlight ruby %}
require "socket"
server = TCPServer.new(60000)
loop do
  client = server.accept
  client.puts eval client.gets
  client.close
end
{% endhighlight %}
evalしたものをクライアントに返したら、そのソケットを閉じる。これによってそのクライアントの接続は切れるから、別のクライアントからの接続を待ち受けられるようになる。

構成がシンプルでいいんだけど、ユーザにとってはちょっと面倒だよね。使うたびに接続し直さなきゃならないからね。なんかWebサーバーみたいだよね..

##forkによる並列化
２つ目は複数のプロセスを起動する方法だよ。Rubyでプロセスを並列化するにはKernel#forkを使うよ。

forkのブロックで囲まれたコードは別プロセスで起動されるから、loop{}のところをforkのブロックに投げればよさそうだね。やってみるよ。
{% highlight ruby %}
require "socket"
server = TCPServer.new(60000)
loop do
  client = server.accept
  fork do    # 別プロセスで起動
    begin
      loop { client.puts eval client.gets }
    rescue
    ensure
      client.close
    end
  end
end
{% endhighlight %}
acceptでクライアントが接続するとforkで別プロセスが起動されて、その中でgetsの待ち受けがされるけど、メインプロセスは外側のループで先頭に戻り、これでacceptで別のクライアントの接続を待てるね。

じゃあ複数のtelnetから接続して試してみよう。
{% highlight sh %}
$ telnet localhost 60000
Trying 127.0.0.1...
Connected to localhost.
Escape character is '^]'.
1 + 2
3
---------------------------------------
$ telnet localhost 60000
Trying 127.0.0.1...
Connected to localhost.
Escape character is '^]'.
[2011,10,1].join '-'
2011-10-1
{% endhighlight %}
うまくいったね。

念のためこの状況で複数のプロセスが立ってるか確認してみるよ。
{% highlight sh %}
$ ps aux | grep repl_server
keyes     1335   0.3  0.1  2448356   1176 s001  R+    3:01PM   0:00.90 ruby repl_server.rb
keyes     1303   0.3  0.0  2448356   1040 s001  S+    2:59PM   0:01.30 ruby repl_server.rb
keyes     1301   0.3  0.2  2448356   3756 s001  R+    2:59PM   0:01.34 ruby repl_server.rb
{% endhighlight %}
３つのプロセスが立ってるのがわかるね。

ただ、プロセスは個々に独立したメモリ空間を専有するから、接続ユーザ数が多くなるとちょっと心配だよね。またチャットサーバーのようにユーザ間での情報のやり取りが必要な場合、プロセス間で通信させなきゃならないから、そんなときはちょっと厄介そうだよね。

##Threadによる並列化
３つ目はスレッドを使う方法だよ。スレッドは１つのプロセス内で処理を並走させる仕組みだよ。並走する処理は同じプロセス内にあるから、その間でのデータ共有が容易という利点があるんだ。

じゃあThreadクラスを使ったサーバーを書いてみるよ。
{% highlight ruby %}
require "socket"
server = TCPServer.new(60000)
loop do
  client = server.accept
  
  Thread.new(client) do |cl|
    begin
      loop { cl.puts eval cl.gets }
    rescue
    ensure
      cl.close
    end
  end
end
{% endhighlight %}
forkをThread.newに変えればいいだけだから簡単だね。ただスレッドは同じプロセス内で並走するから、acceptしたclientをブロック引数を通して、ちゃんと渡さないと問題が生じるよ。

同じように複数のtelnetから接続してみるよ。
{% highlight sh %}
Trying 127.0.0.1...
Connected to localhost.
Escape character is '^]'.
[*1..10].select{|i| i.even? }
2
4
6
8
10
-------------------------------
Connected to localhost.
Escape character is '^]'.
Array.ancestors
Array
Enumerable
Object
Kernel
BasicObject
-------------------------------
$ ps aux |grep repl_server
keyes     1712   0.3  0.2  2451964   3808 s001  S+    7:03PM   0:00.24 ruby repl_server.rb
{% endhighlight %}
プロセスは１つのままだってこと確認できるよね。

前でスレッドがマルチプロセスよりもデータ共有が容易って書いたから、そのサンプルも書いてみるよ。サーバーからの出力を接続しているすべてのクライアントに出力する例だよ。
{% highlight ruby %}
require "socket"
server = TCPServer.new(60000)
clients = []   # 接続クライアントの管理用配列
loop do
  client = server.accept
  clients << client  # 接続クライアントを登録
  
  Thread.new(client) do |cl|
    begin
      loop do
        output = eval cl.gets
        clients.each { |c| c.puts output }  # 結果を全クライアントに配信
      end
    rescue
    ensure
      cl.close
      clients.delete(cl) # 切断したクライアントを管理対象外に
    end
  end
end
{% endhighlight %}
接続クライアント管理用の配列を用意して結果を全員にブロードキャストすればいいね。簡単だね。

ただ、スレッドモデルはスレッド間で共有するデータを書き換えるような場合の取り扱いがちょっと厄介だよ。それと、やっぱり各スレッドごとにいつ来るかわからないデータを待っている、というのが無駄といえば無駄だよね。

##Reactorパターンによる並列化
４つ目はReactorパターンを使って並列化する方法だよ。Reactorパターンというのは簡単に言うと、一箇所でいろいろなイベントを待ち受けて、イベントが来たらこれに反応(リアクト)して、その種類に応じた処理を実行するモデルのことだよ。RubyでReactorパターンを実現するには、IO.selectメソッド(またはKernel#select)を使うよ。

早速Reactor版REPLサーバーを書いてみるよ。REPLサーバーにおけるイベントにはサーバーに対するものつまりクライアントの接続と、クライアントに対するものつまりソケットへのデータ入力があるよ。これらをsocketsという配列で管理しよう。
{% highlight ruby %}
require "socket"
server = TCPServer.new(60000)
sockets = [server]
loop do
  r_sockets = IO.select(sockets)[0] # すべてのイベントを待ち受ける
  r_sockets.each do |socket|
    case socket
    when TCPServer     # サーバーに対するクライアントの接続があったとき
      client = socket.accept
      sockets << client
    when TCPSocket     # クライアントに対するデータ入力があったとき
      unless socket.eof?
        socket.puts eval socket.gets
      else
        socket.close
        sockets.delete(socket)
      end
    end
  end
end
{% endhighlight %}
IO.selectは登録したソケットに対する入力／出力／例外のイベントを待ち受け、そのイベントが発生したソケットを返すけど、返り値はイベント別のソケットの配列になっているよ。ここでは入力イベントだけに関心があるから、配列の第一要素のみ取り出してるよ。

そしてcase式でイベントのあったソケットの種類に応じて処理を切り分けてるよ。つまりサーバーがクライアントからの接続を受けたときは、TCPServerの節に入ってsockets配列に接続のあったクライアントが登録され、ループでselectに戻って次のイベントを待つよ。最初のクライアントの接続時には、sockets配列にはserverしか登録されていないから、処理は必ずここに来ることになるよ。

一方、クライアントにデータの入力があったときは、TCPSocketの節に入って入力データの処理をするよ。入力データがあるときはそれを評価し結果を返し、無いときはソケットを閉じてその接続を解放するよ。そしてループでまたselectに戻って次のイベントを待つよ。

Reactorパターンでは、すべてのクライアントの接続は維持されたままなのに、処理が並走しないつまり単一プロセス単一スレッドで、複数クライアントからの要求に応じることができる、という点がユニークだよ。このモデルなら処理が並走することはないので、共有データを書き換えるようなことも簡単にできるよね。

##EventMachineによる並列化
ただ、when式でのソケットの切り分け処理が面倒といえば面倒だよね。でも安心していいよ。EventMachineというライブラリを使えば、これが驚異的に簡単にできちゃうんだよ。
{% highlight ruby %}
require "eventmachine"
EM.run do
  EM.start_server('localhost', 60000) do |c|
    def c.receive_data(data)
      send_data eval(data)
    end
  end
end
{% endhighlight %}
EventMachineはRreactorパターンによる、イベント駆動型のI/Oインタフェースを提供するライブラリだよ。JavaScriptのNode.jsみたいなものなんだろうね。

もうコードを見れば分かると思うけど、EM.runでイベントループが開始されて、クライアントからのデータ入力があると、receive_dataメソッドが呼び出されるので、ここでsend_dataを呼んでevalした入力を返せばいいんだ。

EventMachineを使えば、チャットサーバーだって簡単に書けちゃうんだ。
{% highlight ruby %}
require "eventmachine"
module Chat
  @@channel = EM::Channel.new
  def post_init
    puts "-- someone connected"
    @sid = @@channel.subscribe { |data| send_data ">> #{data}" }
  end

  def receive_data(data)
    @@channel.push data
  end

  def unbind
    puts "-- someone disconnected from the server"
    @@channel.unsubscribe(@sid)
  end
end

EM.run do
  EM.start_server('localhost', 60000, Chat)
end
{% endhighlight %}
EMサーバーはクライアントの接続があるたびにその引数でセットしたChatモジュールをインスタンス化して、その監視対象として登録するよ。{% fn_ref 1 %} 各インスタンスのpost_initメソッドはその接続時に、unbindメソッドはその切断時に呼び出され、receive_dataは先の例と同様にデータ受信時に呼び出されるよ。

データをブロードキャストするにはEM::Channelを使うよ。subscribeでそのクライアントに対する処理を登録して、pushで呼び出せばいいんだ。

gem install eventmachineして、telnetから試してみてね。

##WebSocket
ここまでくるとWebサーバー上でもこの並列化技術を使いたい、と考えるのが人情だよね。そう、これこそがWebSocketなんだよ。

そしてうれしいことに、EventMachineにはそのためのプラグインem-websocketがあるんだ。gem install em-websocketして使うよ。サーバー側のコードは次のような感じだよ。
{% highlight ruby %}
require 'em-websocket'
EM.run {
  @channel = EM::Channel.new
  EM::WebSocket.start(:host => "localhost", :port => 60000) do |ws|
    sid = nil
    ws.onopen { sid = @channel.subscribe { |msg| ws.send msg } }
    ws.onmessage { |msg| @channel.push "#{sid}: #{msg}" }
    ws.onclose { @channel.unsubscribe(sid) }
  end
}
{% endhighlight %}
EM::WebSocket.startでサーバーインスタンスを立ち上げて、クライアントからの接続を待ち受けるよ。クライアントからの接続があるとonopenが呼ばれるから、ここでchannelにメッセージをブロードキャストする処理を登録するよ。クライアントがテキストを送信するとonmessageが呼ばれるから、それをchannelにpushして登録した処理を呼ぶよ。

次にクライアントサイドのコードだよ。
{% highlight html %}
<html>
  <head>
    <script src='http://ajax.googleapis.com/ajax/libs/jquery/1.6.2/jquery.min.js'></script>
    <script>
      $(document).ready(function(){
        function debug (str) { $("#debug").append("<p>"+str+"</p>") };
        
        ws = new WebSocket("ws://localhost:60000/");
        ws.onopen = function() { debug("Welcome to Chattata!") };
        ws.onmessage = function(evt) { $("#msglist").append("<p>"+evt.data+"</p>") };
        ws.onclose = function() { debug("socket closed") };
        $("form").submit(function(){
          var msg = $("input#msg");
          ws.send(msg.val());
          msg.val('');
          return false;
        });
      });
    </script>
  </head>
  <body>
    <div id="debug"></div>
    <form>
      <input id="msg" type="text"></input>
    </form>
    <div id="msglist"></div>
  </body>
</html>
{% endhighlight %}
クライアント側では、サーバーに接続するソケットをインスタンス化するよ。ユーザがテキストを送信すると$("form").submitが呼ばれ、その内容はws.sendでソケットに送り出されるよ。これによってサーバー側のchannelに登録された処理が呼ばれ、接続されているクライアントにテキストがブロードキャストされるよ。クライアント側ではこれをonmessageで受けて、テキストをwindow上に表示するよ。

じゃあ試してみるよ。

![image](http://img.f.hatena.ne.jp/images/fotolife/k/keyesberry/20110929/20110929223805.png)


良い感じだね！

WebSocketはHTML5の新しい規格だから対応ブラウザか確認してね。

ちょっと長い投稿になっちゃったけど、最後まで付き合ってくれてありがとう。
{% footnotes %}
   {% fn モジュールをインスタンス化って変だよね.. %}
{% endfootnotes %}
