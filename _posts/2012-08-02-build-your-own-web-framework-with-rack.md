---
layout: post
title: "エラーメッセージから学ぶRack - 最初の一歩"
description: ""
category: 
tags: [rack]
date: 2012-08-02
published: true
---
{% include JB/setup %}

(追記：2012-12-25)
本記事およびこれに続くRackの記事（全４本）をまとめて電子書籍化しました。「[Gumroad](https://gumroad.com/ 'Gumroad')」を通して100円にて販売しています。内容についての追加・変更はありませんが、誤記の修正およびメディア向けの調整を行っています。


![Rack Ebook]({{ site.url }}/assets/images/2012/rack_cover.png)

<a href="http://gum.co/ZqRt" class="gumroad-button">電子書籍「エラーメッセージから学ぶRack」EPUB版 </a><script type="text/javascript" src="https://gumroad.com/js/gumroad-button.js"></script><script type="text/javascript" src="https://gumroad.com/js/gumroad.js"></script>

このリンクはGumroadにおける商品購入リンクになっています。クリックすると、オーバーレイ・ウインドウが立ち上がって、この場でクレジットカード決済による購入が可能です。購入にはクレジット情報およびメールアドレスの入力が必要になります。購入すると、入力したメールアドレスにコンテンツのDLリンクが送られてきます。

詳細は以下を参照して下さい。

> [電子書籍「エラーメッセージから学ぶRack」EPUB版をGumroadから出版しました！](http://melborne.github.com/2012/12/24/learning-rack-on-ebook/ '電子書籍「エラーメッセージから学ぶRack」EPUB版をGumroadから出版しました！')

購入ご検討のほどよろしくお願いしますm(__)m

---

Rackがわかりません。

[Rack](http://rack.github.com/ 'Rack')のサイトには、Rackについて次のように書いてあります。

> Rack provides a minimal interface between webservers supporting Ruby and Ruby frameworks.
>
> Rackは、Ruby向けWebサーバとRuby製フレームワークとの間の最小のインタフェースを提供します。

やっぱりよくわかりませんが、たぶんそれは、Ruby製Webフレームワークを作る人にとっては**仮想Webサーバ**であり、またRuby向けWebサーバを作る人にとっては**仮想Webフレームワーク**になるものだと理解します。

##エラーメッセージから学ぶ

古くからの格言の一つに「Rackのことはrackupに聞け」というものがあります。Rackがわからないので、この格言に従いrackupに聞いてみることにします。

昨日はドラクエの発売日だったので、`draque`というディレクトリを作って、ここで`rackup`を実行します。因みに私はドラクエは一度もやったことはありません。やっぱりそれは不幸なことですか？

{% highlight bash %}
% mkdir draque
% cd draque
% rackup
configuration config.ru not found
{% endhighlight %}

config.ruという設定ファイルがないと言われました。それでは、これを作って再度rackupします。

{% highlight bash %}
% touch config.ru
% rackup
~/.rbenv/..../rack/builder.rb:129:in `to_app': missing run or map statement (RuntimeError)
        from config.ru:1:in `<main>'
{% endhighlight %}

今度はrunまたはmapが見つからないと言われたので、config.ruに`run`と書いてもう一度やってみます。
{% highlight bash %}
% echo run > config.ru 
% rackup              
~/.rbenv/.../rack/builder.rb:99:in `run': wrong number of arguments (0 for 1) (ArgumentError)
        from config.ru:2:in `block in <main>'
{% endhighlight %}

今度は引数が足りないと言われました。`run`は恐らくWebアプリを走らせるコマンドでしょうから、Webアプリのインスタンスを渡せばよさそうです。試しに`1`を渡してみます。

{% highlight ruby %}
# config.ru
run 1
{% endhighlight %}

{% highlight bash %}
% rackup      
>> Thin web server (v1.3.1 codename Triple Espresso)
>> Maximum connections set to 1024
>> Listening on 0.0.0.0:9292, CTRL+C to stop
{% endhighlight %}
ポート9292でThin Webサーバが立ち上がりました。

Browserでhttp://localhost:9292 にアクセスしてみます。
{% highlight bash %}
NoMethodError: undefined method `call' for 1:Fixnum
{% endhighlight %}
`call`メソッドがないと言われました。では、Fixnum#callを定義してみます。

{% highlight ruby %}
# config.ru
class Fixnum
  def call
  end
end

run 1
{% endhighlight %}

今度はどうでしょう。
{% highlight bash %}
ArgumentError: wrong number of arguments (1 for 0)
        config.ru:3:in `call'
{% endhighlight %}

引数がないと言われました。引数を付けてみます。

{% highlight ruby %}
# config.ru
class Fixnum
  def call(arg)
  end
end

run 1
{% endhighlight %}

どうでしょう。
{% highlight bash %}
Rack::Lint::LintError: Status must be >=100 seen as integer
{% endhighlight %}
Statusは100以上の数でなければならないとのRack::Lint::LintErrorが吐かれました。ではcallメソッドが200を返すようにしてみます。

{% highlight ruby %}
# config.ru
class Fixnum
  def call(arg)
    200
  end
end

run 1
{% endhighlight %}

どうでしょう。
{% highlight bash %}
Rack::Lint::LintError: headers object should respond to #each, but doesn't (got NilClass as headers)
{% endhighlight %}
headersオブジェクトはNilClassだから`#each`できないと言われました。では第２返り値として#eachできるオブジェクト`[1]`を渡してみます。

{% highlight ruby %}
# config.ru
class Fixnum
  def call(arg)
    return 200, [1]
  end
end

run 1
{% endhighlight %}

どうでしょう。
{% highlight bash %}
Rack::Lint::LintError: header key must be a string, was Fixnum
{% endhighlight %}

今度はヘッダーキーが文字列じゃないと言われました。これで#eachできるオブジェクトがHashとわかりました。キーが文字列のHashオブジェクトを返してみます。

{% highlight ruby %}
# config.ru
class Fixnum
  def call(arg)
    return 200, {'one' => 1}
  end
end

run 1
{% endhighlight %}

どうでしょう。
{% highlight bash %}
Rack::Lint::LintError: a header value must be a String, but the value of 'one' is a Fixnum
{% endhighlight %}

今度は値も文字列じゃないとダメだと言われたので、これに対応してみます。
{% highlight ruby %}
# config.ru
class Fixnum
  def call(arg)
    return 200, {'one' => '1'}
  end
end

run 1
{% endhighlight %}

どうでしょう。
{% highlight bash %}
Rack::Lint::LintError: No Content-Type header found
{% endhighlight %}
`Content-Type`ヘッダーがないと言われました。用意します。

{% highlight ruby %}

# config.ru
class Fixnum
  def call(arg)
    return 200, {'one' => '1', 'Content-Type' => 'text/plain'}
  end
end

run 1
{% endhighlight %}

どうでしょう。
{% highlight bash %}
!! Unexpected error while processing request: Response body must respond to each
127.0.0.1 - - [02/Aug/2012 20:38:50] "GET / HTTP/1.1" 200 - 0.0010
{% endhighlight %}
"**GET / HTTP/1.1" 200**"が返ってきました。しかし、レスポンスボディが`each`できないと言っています。

それでは第３返り値として、eachできるbodyを返すようにしてみます。

{% highlight ruby %}
# config.ru
class Fixnum
  def call(arg)
    return 200, {'one' => '1', 'Content-Type' => 'text/plain'}, "Welcome to ONE".chars
  end
end

run 1
{% endhighlight %}

どうでしょう。
![draque1]({{ site.url }}/assets/images/draque1.png)

Browserにレスポンスが返ってきました。

以上のことをまとめます。

> 1. rackupコマンドはWebサーバを起動する。
> 1. その際、config.ruという設定ファイル（Rubyスクリプト）を読み込む。
> 1. config.ruでは、Webアプリのインスタンスをrunメソッドに渡す。
> 1. Webアプリのインスタンスは、１引数のcallメソッドを持っている必要がある。
> 1. callメソッドは、３つの返り値、すなわち（１）100以上の数字からなるステータスコード、（２）少なくとも"Content-Type"をキーに、文字列を値に持つハッシュによるヘッダー、および（３）eachできるボディを返す。

## Rack Webフレームワーク

さて、Webアプリが`1`では発展性が無さそうです。もう少しマシなWebアプリを考えます。

`call`メソッドを持っているオブジェクトと言えば、真っ先に思い浮かぶのはProcオブジェクトです。次に、思い浮かぶのはMethodオブジェクトです。ここでは後者を使ってみます。draqueメソッドを定義し、これをMethodオブジェクト化してrunに渡します。

{% highlight ruby %}
# config.ru
def draque(arg)
  return 200, {'one' => '1', 'Content-Type' => 'text/plain'}, "Welcome to the World of Draque!!".chars
end

run method(:draque)
{% endhighlight %}

`rackup`してBrowserでアクセスします。

![draque2]({{ site.url }}/assets/images/draque2.png)

いいようです。

さて次に、draqueに渡される引数について見てみます。まずは`p`します。
{% highlight ruby %}
# config.ru
def draque(arg)
  p arg
  return 200, {'one' => '1', 'Content-Type' => 'text/plain'}, "Welcome to the World of Draque!!".chars
end

run method(:draque)
{% endhighlight %}

コンソールに次のような出力が得られました。
{% highlight bash %}
% rackup      
>> Thin web server (v1.3.1 codename Triple Espresso)
>> Maximum connections set to 1024
>> Listening on 0.0.0.0:9292, CTRL+C to stop
{"SERVER_SOFTWARE"=>"thin 1.3.1 codename Triple Espresso", "SERVER_NAME"=>"localhost", "rack.input"=>#<Rack::Lint::InputWrapper:0x00000100a156c0 @input=#<StringIO:0x000001009dab38>>, "rack.version"=>[1, 0], "rack.errors"=>#<Rack::Lint::ErrorWrapper:0x00000100a15648 @error=#<IO:<STDERR>>>, "rack.multithread"=>false, "rack.multiprocess"=>false, "rack.run_once"=>false, "REQUEST_METHOD"=>"GET", "REQUEST_PATH"=>"/", "PATH_INFO"=>"/", "REQUEST_URI"=>"/", "HTTP_VERSION"=>"HTTP/1.1", "HTTP_HOST"=>"localhost:9292", "HTTP_CONNECTION"=>"keep-alive", "HTTP_CACHE_CONTROL"=>"max-age=0", "HTTP_USER_AGENT"=>"Mozilla/5.0 (Macintosh; Intel Mac OS X 10_6_8) AppleWebKit/537.3 (KHTML, like Gecko) Chrome/22.0.1221.0 Safari/537.3", "HTTP_ACCEPT"=>"text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8", "HTTP_ACCEPT_ENCODING"=>"gzip,deflate,sdch", "HTTP_ACCEPT_LANGUAGE"=>"ja,en-US;q=0.8,en;q=0.6", "HTTP_ACCEPT_CHARSET"=>"UTF-8,*;q=0.5", "HTTP_COOKIE"=>"_gauges_unique_year=1; _gauges_unique=1; _blog_app_session=BAh7B0kiD3Nlc3Npb25faWQGOgZFRkkiJTVjMmY2ZDU1ODBiNTUxMDY5NGY3ZDkxNzQ3ZmRkOWVkBjsAVEkiEF9jc3JmX3Rva2VuBjsARkkiMTQvY1IyYUpOaFBYUXpFYTNXOEU5SHlpYnVEU0ZEaDRxTmUwTzVINThmbmc9BjsARg%3D%3D--f9184f85f7974529836b4bce7c23a5f7132bf8df", "GATEWAY_INTERFACE"=>"CGI/1.2", "SERVER_PORT"=>"9292", "QUERY_STRING"=>"", "SERVER_PROTOCOL"=>"HTTP/1.1", "rack.url_scheme"=>"http", "SCRIPT_NAME"=>"", "REMOTE_ADDR"=>"127.0.0.1", "async.callback"=>#<Method: Thin::Connection#post_process>, "async.close"=>#<EventMachine::DefaultDeferrable:0x00000100a06c38>}127.0.0.1 - - [02/Aug/2012 21:39:21] "GET / HTTP/1.1" 200 - 0.0023
{% endhighlight %}

クライアントの環境情報がWebサーバからハッシュで渡されていました。これらの情報があれば、クライアントの環境に応じたレスポンスが構築できそうです。まずは、これらを一覧表示するレスポンスを書いてみます。Content-Typeも**text/html**に変更します。

{% highlight ruby %}
# config.ru
def draque(env)
  return 200, {'one' => '1', 'Content-Type' => 'text/html'}, body(env)
end

def body(env)
  ["<h1>Welcome to the World of Draque!!</h1>"] +
  env.map { |k,v| "<p>%s => %s</p>" % [k, v] }
end

run method(:draque)
{% endhighlight %}

どうでしょうか。

![draque3]({{ site.url }}/assets/images/draque3.png)

タイトルとともにクライアントの環境情報がレンダリングされました。

次に環境変数におけるパス情報を使って、パスに応じたレスポンスを返すようにしてみます。

case式でパスに応じてレスポンスを切り替えるようにします。
{% highlight ruby %}
# config.ru
def draque(env)
  path = env['PATH_INFO']
  case path
  when '/draque' then [ 200, headers, draque_body ]
  when '/'       then [ 200, headers, top_body(env) ]
  else [ 404, headers, not_found ]
  end
end

def headers
  {'Content-Type' => 'text/html'}
end

def top_body(env)
  ["<h1>Welcome to the World of Draque!!</h1>"] +
  env.map { |k,v| "<p>%s => %s</p>" % [k, v] }
end

def draque_body
  ["<img src='http://www.dqx.jp/storage/img/top/main_visual.png'>"]
end

def not_found
  ["<img src='https://a248.e.akamai.net/assets.github.com/images/modules/404/parallax_octocat.png?1329921026'>", "<img src='https://a248.e.akamai.net/assets.github.com/images/modules/404/parallax_errortext.png?1329921026'>"]
end

run method(:draque)
{% endhighlight %}

`/draque`にアクセスします。

![draque4]({{ site.url }}/assets/images/draque4.png)

次に、用意されていない`/ruby`にアクセスします。

![draque5]({{ site.url }}/assets/images/draque5.png)

うまくいっています。怒られるでしょうか。


さて、ここまで来たら、ルーティングはsinatra風に書きたいです。getメソッドを定義して、パスに応じたレスポンスを登録できるようにします。

{% highlight ruby %}
# config.ru
@routes = { get:{} }

def draque(env)
  path = env['PATH_INFO']
  if res = @routes[:get][path]
    res.call(env)
  else
    [ 404, headers, not_found ]
  end
end

def get(path, &blk)
  @routes[:get][path] = blk
end

get '/draque' do
  [ 200, headers, draque_body ]
end

get '/' do |env|
  [ 200, headers, top_body(env) ]
end

def headers
  {'Content-Type' => 'text/html'}
end

def top_body(env)
  ["<h1>Welcome to the World of Draque!!</h1>"] +
  env.map { |k,v| "<p>%s => %s</p>" % [k, v] }
end

def draque_body
  ["<img src='http://www.dqx.jp/storage/img/top/main_visual.png'>"]
end

def not_found
  ["<img src='https://a248.e.akamai.net/assets.github.com/images/modules/404/parallax_octocat.png?1329921026'>", "<img src='https://a248.e.akamai.net/assets.github.com/images/modules/404/parallax_errortext.png?1329921026'>"]
end

run method(:draque)
{% endhighlight %}

わかりづらくなってきたので、フレームワークの部分をモジュール化します。

{% highlight ruby %}
# config.ru
module Draque
  @@routes = { get:{} }

  def draque(env)
    path = env['PATH_INFO']
    if res = @@routes[:get][path]
      res.call(env)
    else
      [ 404, headers, not_found ]
    end
  end

  def get(path, &blk)
    @@routes[:get][path] = blk
  end

  def headers
    {'Content-Type' => 'text/html'}
  end
end

Object.send(:include, Draque)

get '/draque' do
  [ 200, headers, draque_body ]
end

get '/' do |env|
  [ 200, headers, top_body(env) ]
end

def top_body(env)
  ["<h1>Welcome to the World of Draque!!</h1>"] +
  env.map { |k,v| "<p>%s => %s</p>" % [k, v] }
end

def draque_body
  ["<img src='http://www.dqx.jp/storage/img/top/main_visual.png'>"]
end

def not_found
  ["<img src='https://a248.e.akamai.net/assets.github.com/images/modules/404/parallax_octocat.png?1329921026'>", "<img src='https://a248.e.akamai.net/assets.github.com/images/modules/404/parallax_errortext.png?1329921026'>"]
end

run method(:draque)
{% endhighlight %}

なんちゃってWebフレームワークdraqueの完成です^ ^;

Rack、最初の一歩は踏み出せたでしょうか。


[Joke Rack Web framework Draque — Gist](https://gist.github.com/3243357 'Joke Rack Web framework `Draque` — Gist')

----

(追記：2012-08-06) 続きを書きました。

[エラーメッセージから学ぶRack - Middlewareの魔法](http://melborne.github.com/2012/08/06/use-rack-middleware/ 'エラーメッセージから学ぶRack - Middlewareの魔法')

----

{{ 'B0052YV3XC' | amazon_medium_image }}

{{ 'B0052YV3XC' | amazon_link }}

