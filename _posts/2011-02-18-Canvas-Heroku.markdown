---
layout: post
title: CanvasアニメーションをHerokuで公開しようよ！
date: 2011-02-18
comments: true
categories:
tags: [ruby, heroku, sinatra, canvas]
---

もしあなたが暇で暇でしようがなくて、一日中時計をぼーっと眺めるのも悪くない、と考えているのなら、次のリンクをクリックしてください。3分くらいならあなたの時間をつぶせるかもしれません。

[aclock](http://aclock.heroku.com/)

もしあなたがRubyを使っていて、JavaScriptのことはよく知らないけれども、HTML5のCanvasに興味がでてきて、その成果物をネットで簡単に公開できればうれしいかも、と考えているのなら、以下の記事を読む価値があるかもしれません。もちろん何の保証もありませんが..

##Canvasを使ったWebアプリケーションの構築
この記事は先のリンクで示した、接近する時計のWebアプリケーションを構築する手順を書いています。HTMLはhamlとscssを使って、JavaScriptはjQueryを使って記述しています。WebフレームワークSinatraを使ってHerokuにデプロイしています。OSはMac OSX Tiger..です

##ディレクトリ構成
最終的なファイル構成は以下のようになります。
{% highlight bash %}
.
├── Gemfile
├── Gemfile.lock
├── clock.rb
├── config.ru
├── public
│ └── javascripts
│ └── clock.js
└── views
    ├── index.haml
    ├── layout.haml
    └── style.scss
{% endhighlight %}
Sinatraのためにclock.rb layout.haml index.haml style.scssが必要になります。時計を描画するJavaScriptはclock.jsに記述します。Herokuにデプロイするために更にconfig.ru Gemfileが必要になります。Gemfile.lockはbundler installコマンドで自動生成されます。

以下では一つずつファイルを用意する必要がありますが、僕のような無精者のために、Sinatra版scaffold ease_sinatra.rbを用意しました。

[gist](https://gist.github.com/802707)

カレントディレクトリでWebApp::ease_sinatraすれば、Sinatraのテンプレートファイルが得られます。かなりいい加減な作りであることをご了承下さい..

##clock.rb
まずWebフレームワークのコントローラとなるclock.rbを書きます。
{% highlight ruby %}
require 'sinatra'
require 'haml'
require 'sass'
configure do
  APP_TITLE = "Approaching Clock"
  CREDIT = ['hp12c', "http://d.hatena.ne.jp/keyesberry"]
end
get '/' do
  haml :index
end
get '/style.css' do
  scss :style
end
{% endhighlight %}
configureブロックはアプリ立ち上げ時に一度だけ呼ばれます。get '/'でルートが呼ばれた(GETされた)ときの挙動を記述します。ここでは、hamlで記述されたviews/index.hamlが返されるよう指定しています。get '/style.css'でlink属性でstyle.cssが呼ばれたときに、scssで記述されたvews/style.scssが返されるよう指定しています。

##layout.haml
次にlayout.hamlを記述します。Sinatraではlayoutという名のテンプレートが存在する場合、各テンプレートの読み出しに先立ってそれが自動で読み出されます。
{% highlight ruby %}
!!! 5
%html
  %head
    %meta{:'http-equiv' => 'Content-type', :content => 'text/html', :charset => 'utf-8'}
    %title= APP_TITLE
    %link{:rel => 'stylesheet', :href => '/style.css', :type => 'text/css'}
    %script{:type => "text/javascript", :src => "https://ajax.googleapis.com/ajax/libs/jquery/1.5.0/jquery.min.js", :charset => "utf-8" }
    %script{:type => "text/javascript", :src => "/javascripts/clock.js", :charset => "utf-8" }
  %body
    = yield
{% endhighlight %}
titleタグに先ほどのconfigureで定義したAPP_TITLEを指定します。hamlでは=(イコール)以降をRubyのコードとして評価します。jQueryはGoogleが提供するものを使っています。時計を記述するclock.jsを指定します。bodyタグの中身はyieldで実体ファイル(index.haml)に委ねます。

##index.haml
次にindex.hamlを記述します。
{% highlight ruby %}
%header
#main
  %canvas#clock{:width => '1000px', :height => '500px'}Only for HTML5 adapted browsers
%footer
  %a{:href => CREDIT[1]}= CREDIT[0]
{% endhighlight %}
mainのcanvasタグにclockというid名を付けサイズを指定します。HTML5非対応ブラウザのためのメッセージを記述します。footerタグにCREDITのリンクを貼ります。

##style.scss
次にstyle.scssを記述します。scssはsassy css(sassライクなcss)を意味するcssの拡張言語です。scssを使用することによりcssの文法に沿って、sassの拡張を取り入れることができます。
{% highlight ruby %}
$font_color: #D0FFD0;
$bg_color: #325F82;
$canvas_color: #FFFFFF;
@mixin rounded($topl:32px, $topr:32px, $btmr:32px, $btml:32px) {
  border-radius: $topl $topr $btmr $btml;
  -moz-border-radius: $topl $topr $btmr $btml;
}
* {
  margin: 0;
  padding: 0;
  font-family: Trebuchet ms, Verdana, Myriad Web, Syntax, sans-serif
}
body {
  color: $font_color;
  background-color: $bg_color;
  width: 1000px;
  margin: 60px auto;
}
header {
  display:block;
}
#main {
  canvas#clock {
    border: thin solid #444;
    background-color: $canvas_color;
    @include rounded();
  }
}
footer {
  display: block;
  height: 30px;
  text-align: center;
  margin-top: 20px;
  a {
    text-decoration: none;
    color: $font_color;
    &:visited {
      color: $font_color;
    }
  }
}
{% endhighlight %}
$varnameでグローバル変数を定義できます。セレクタをネストできます。@mixin-@includeでセレクタブロックを関数ライクに使えます。ここではrounded()で角丸にミックスインを使っています。

##clock.js
メインとなるclock.jsを記述します。JavaScript初学者なので書き方に問題があるかもしれません。間違いをご指摘頂けるとうれしいです。少し長いので分けて説明します。
{% highlight javascript %}
var canvas = {};
$(document).ready(function(){
  canvas.c = $("canvas#clock");
  canvas.ctx = canvas.c[0].getContext('2d');
  canvas.width = canvas.c.width();
  canvas.height = canvas.c.height();
  
  canvas.ctx.translate(canvas.width/2, canvas.height/2);
  
  const min = 60;
  var x = min;
  var sp = 2;
  clock(x);
  setInterval(
    function(){
      clock(x);
      x += sp;
      if (x > canvas.width*0.6 || x < min) { sp = -sp };
    },
    500
  );
})
{% endhighlight %}
グローバルに参照できるcanvasオブジェクトを定義します。$(document).ready..はHTMLドキュメントの読み込みの完了を待って、その引数の関数が実行されることを保証します。そのなかで最初にcanvasオブジェクトにcanvasの情報をオブジェクト・プロパティとしてセットします。JavaScriptではオブジェクト・プロパティは先行する宣言が不要です。

canvasへの描画はcanvasオブジェクトの2Dコンテキストに対し行います。そのためgetContext('2d')しますが、jQueryではcanvasオブジェクトはArrayを返すので注意が必要です。

時計の描画は中心点を基準に行うほうがやり易いので、ctx.translateで座標軸をcanvasの中心に移動します。

Canvasにおけるアニメーションの描画にはsetIntervalを使います。setIntervalは第２引数に指定した周期で第１引数に渡した関数を関数の実行スタックに繰り返し登録します。setIntervalの第１引数にはclock関数を包んだ匿名関数を渡します。時計を描画するclock関数はそのサイズxを引数にとります。サイズxは匿名関数が呼ばれる度にspだけ増分されてclockに渡されるので、呼び出しの度に時計のサイズは大きくなっていきます。サイズxが任意の値を超えると(ここではcanvas.width*0.6)、時計は今度は徐々に小さくなっていきます。

続いてclock関数の中身を見ていきます。
{% highlight javascript %}
function clock (radius) {
  canvas.ctx.clearRect(-canvas.width/2,-canvas.height/2,canvas.width,canvas.height);
  var unit = radius/75;
  drawFrame(radius, '#325FA2');
  canvas.ctx.save();
  canvas.ctx.rotate(-Math.PI/2); //set start angle at twelve o'clock
  drawHand('hr', radius*0.5, unit*3, unit*5, 'black');
  drawHand('min', radius*0.9, unit*2, unit*10, 'black');
  drawHand('sec', radius*0.9, unit, unit*5, 'red');
  canvas.ctx.restore();
}
{% endhighlight %}
ctx.clearRectでキャンバスをクリアします。drawFrame関数で時計の文字盤を描画し、drawHand関数で針を描画します。針の描画はctx.rotateでキャンバスの座標系を回転させながら行うので、最初に初期位置を12時の位置に合わせています。ctx.save() ctx.restore()は動かした座標系を元に戻すために使います{% fn_ref 2 %}。saveでそれ以前の状態を保存し座標系を動かして描画を行った後、restoreで元に戻します。各描画サイズはclockに渡されるサイズxに対する比で規定することによって、時計のサイズが変わってもそのバランスが崩れないようにします。

次にdrawFrame関数の中身をみます。
{% highlight javascript %}
function drawFrame (radius, color) {
  drawCircle(radius, radius*0.1, color, false);
  drawPitchLines(radius*0.9, 2, 1);
  drawNumbers(radius/5, radius*0.7, color);
}
function drawCircle (distance, width, color, filly) {
  var ctx = canvas.ctx;
  ctx.beginPath();
  ctx.lineWidth = width;
  ctx.strokeStyle = color;
  ctx.arc(0, 0, distance, 0, 2*Math.PI, true);
  filly ? ctx.fill() : ctx.stroke();
}
function drawPitchLines (distance, length, width) {
  var ctx = canvas.ctx;
  ctx.save();
  for (var i=0; i < 60; i++) {
    ctx.beginPath();
    ctx.strokeStyle = "black";
    ctx.lineWidth = width;
    ctx.lineCap = 'round';
    var len = i%5==0 ? length*3 : length;
    ctx.moveTo(0, -distance);
    ctx.lineTo(0, -(distance-len));
    ctx.stroke();
    ctx.rotate(2*Math.PI/60);
  };
  ctx.restore();
}
function drawNumbers (size, distance, color) {
  var ctx = canvas.ctx;
  ctx.font = size + "px Helvetica";
  ctx.fillStyle = color;
  
  for (var i=1; i <= 12; i++) {
    ctx.save();
    ctx.translate(distance*Math.sin(Math.PI/6*i), -distance*Math.cos(Math.PI/6*i));
    ctx.fillText(i, -size/3, size/3);
    ctx.restore();
  };
}
{% endhighlight %}
drawFrame関数では外円とインデックスバーと数字を描画するdrawCircle drawPitchLines drawNumbersを呼びます。線の描画はbeginPathで開始宣言し、moveToで開始点lineToで終了点を決めて、strokeで実際に描画します。円はarcで描画します。引数には中心座標　半径　描画角始点終点、および描画方向を指定します。数字の描画はfillTextで行います。

次に時計の針を描画するdrawHand関数をみます。
{% highlight javascript %}
function drawHand (unit, length, width, offset, color) {
  var now = new Date();
  var hr = now.getHours(), min = now.getMinutes(), sec = now.getSeconds();
  hr = hr >= 12 ? hr-12 : hr;
  var _360 = 2*Math.PI;
  var angle;
  if (unit=='hr') {
    angle = hr*_360/12 + min*_360/(12*60) + sec*_360/(12##60);
  } else if (unit=='min') {
    angle = min*_360/60 // + sec*_360/(60*60);
  } else {
    angle = sec*_360/60;
  };
  var ctx = canvas.ctx;
  ctx.save();
  ctx.strokeStyle = color;
  ctx.lineWidth = width;
  ctx.rotate(angle);
  ctx.beginPath();
  ctx.moveTo(-offset,0);
  ctx.lineTo(length,0);
  ctx.stroke();
  ctx.restore();
}
{% endhighlight %}
Dateオブジェクトを使って現在の時・分・秒を取得します。針の種類によって一度に進む量angleが異なるので場合分けします。ここでは時針は時刻の進行で少しずつ移動しますが、分針は60秒ごとに一気に１つ進むようにしています。

clock.jsは以上です。

##ローカルでの起動
これでローカルで実行する環境が整いました。早々立ち上げてみましょう。
{% highlight ruby %}
/Users/keyes/aclock% ruby clock.rb
== Sinatra/1.1.2 has taken the stage on 4567 for development with backup from Thin
>> Thin web server (v1.2.7 codename No Hup)
>> Maximum connections set to 1024
>> Listening on 0.0.0.0:4567, CTRL+C to stop
{% endhighlight %}

Ruby1.9.2でshotgunを利用する場合、カレントパスをロードする必要があるかもしれません。
{% highlight ruby %}
/Users/keyes/aclock% shotgun -I. clock.rb 
== Shotgun/WEBrick on http://127.0.0.1:9393/
[2011-02-18 18:28:47] INFO  WEBrick 1.3.1
[2011-02-18 18:28:47] INFO  ruby 1.9.2 (2010-12-25) [i386-darwin8.11.1]
[2011-02-18 18:28:47] INFO  WEBrick::HTTPServer#start: pid=1613 port=9393
{% endhighlight %}

##Herokuへのデプロイ
http://localhost:4567で問題なくアプリケーションが起動したら、Herokuにデプロイするためにconfig.ruとGemfileを用意します。

config.ru
{% highlight ruby %}
require "bundler"
Bundler.require
$LOAD_PATH << File.expand_path(File.dirname(__FILE__))
require 'clock'
run Sinatra::Application
{% endhighlight %}

Gemfile
{% highlight ruby %}
source :rubygems
gem "sinatra"
gem "haml"
{% endhighlight %}
Herokuに必要なgemsをインストールするために、BundlerというGem管理ツールを使います。Gemfileに必要なgemsを羅列し、config.ruではbundlerをrequireしてこれらを読み込むよう指定します。

Bundlerをインストールしてinstallコマンドを実行します。
{% highlight bash %}
/Users/keyes/aclock% gem install bundler
/Users/keyes/aclock% bundle install
{% endhighlight %}
これでGemfileに記述したgemsがアプリケーションで使えるようになります。同時にGemfile.lockが生成され、ローカルとHerokuで使われるgemsのバージョンの一致が保証されます{% fn_ref 3 %}。

HerokuへのデプロイはgitとHeroku gemを使います。初回はSSHキーのセットアップなどが必要になりますが、説明は他サイトに譲ります{% fn_ref 4 %}。
{% highlight bash %}
/Users/keyes/aclock% git init
/Users/keyes/aclock% git add .
/Users/keyes/aclock% git commit -m 'initial'
{% endhighlight %}

Heroku側にアプリケーションのレポジトリを用意し、git pushでデプロイします。
{% highlight bash %}
/Users/keyes/aclock% heroku create myclock
/Users/keyes/aclock% git push heroku master
{% endhighlight %}

早々アプリケーションを立ち上げましょう。
{% highlight bash %}
/Users/keyes/aclock% heroku open
{% endhighlight %}
うまくいかない場合はlogを見てみましょう。
{% highlight bash %}
/Users/keyes/aclock% heroku logs
{% endhighlight %}

さあ、あなたもCanvasを使ったサイトを立ち上げましょう！

enjoy your Canvas life!

ソースコードは以下にあります。
[Approaching-Clock](https://github.com/melborne/Approaching-Clock)

参照： [Sass、そしてSassy CSS (SCSS)](http://hail2u.net/documents/sass-and-sassy-css.html)

{% footnotes %}
   {% fn save,restoreが保持するのは座標系だけに限らない %}
   {% fn http://devcenter.heroku.com/articles/bundler %}
   {% fn http://devcenter.heroku.com/articles/quickstart %}
{% endfootnotes %}
