---
layout: post
title: jQuery UIでCanvasアニメーションを操作しようよ
date: 2011-02-22
comments: true
categories:
---


HTML5 Canvasがマイブームです
でも慣れないJavaScriptに悪戦苦闘しています
なかなかキレイにコードが書けません...

[](http://crayovas.heroku.com/)　[](http://aclock.heroku.com/)に続き
デモを作ったので公開します
jQuery UIのスライダーを使って
ボールの速度や色の属性を調整できます

まあ　それだけです..

![image](http://img.f.hatena.ne.jp/images/fotolife/k/keyesberry/20110222/20110222190656.png)


[](http://eqball.heroku.com/)

以下では前回のデモと異なる部分を中心に説明します
その他の箇所は前回の記事を読んでください

##ファイル構成
ファイル構成は次のようになります
{% highlight bash %}
 .
 ├── Gemfile
 ├── Gemfile.lock
 ├── config.ru
 ├── eqball.rb
 ├── public
 │&#160;&#160; ├── css
 │&#160;&#160; │&#160;&#160; └── ui-lightness
 │&#160;&#160; │&#160;&#160;     ├── images
 │&#160;&#160; │&#160;&#160;     │&#160;&#160; ├── ui-bg_diagonals.. png
 │&#160;&#160; │&#160;&#160;     │&#160;&#160; ├── ui-bg_diagonals.. png
 │&#160;&#160; │&#160;&#160;     │&#160;&#160; ├──            :
 │&#160;&#160; │&#160;&#160;     │&#160;&#160; └── ui-icons_ffffff_256x240.png
 │&#160;&#160; │&#160;&#160;     └── jquery-ui-1.8.9.custom.css
 │&#160;&#160; └── javascripts
 │&#160;&#160;     └── eqball.js
 └── views
     ├── index.haml
     ├── layout.haml
     └── style.scss
{% endhighlight %}
デモではjQuery UIのslider widget{% fn_ref 1 %}を使っています
public/css/以下のファイル群はsliderのテーマファイルです
以下から取得してpublic以下に配置します

[](http://jqueryui.com/download)

##layout.haml
{% highlight ruby %}
!!! 5
%html
  %head
    %meta{:'http-equiv' => 'Content-type', :content => 'text/html', :charset => 'utf-8'}
    %title= APP_TITLE
    %link{:rel => 'stylesheet', :href => '/style.css', :type => 'text/css'}
    %link{:rel => "stylesheet", :href => "/css/ui-lightness/jquery-ui-1.8.9.custom.css", :type => "text/css"}
    %script{:type => "text/javascript", :src => "https://ajax.googleapis.com/ajax/libs/jquery/1.5.0/jquery.min.js", :charset => "utf-8" }
    %script{:type => "text/javascript", :src => "https://ajax.googleapis.com/ajax/libs/jqueryui/1.8.9/jquery-ui.min.js", :charset => "utf-8" }
    %script{:type => "text/javascript", :src => "/javascripts/eqball.js", :charset => "utf-8" }
  %body
    = yield
{% endhighlight %}

スライダーのcssファイルにリンクを張ります
jQueryとjQuery UI本体はGoogleが提供するものを使います

##index.haml
{% highlight ruby %}
%header
#main
  %h2 HTML5 Canvas & jQuery UI Demo
  %canvas#eqball{:width => '1000px', :height => '500px'}Only for html5 adapted browsers
  -%w(size spx spy trail red green blue alpha).each do |id|
    .box
      %label{:for => id}= "#{id}:"
      %input{:id => id, :type => 'text', :style => "color:#F6931F;font-weight:bold"}
      %span.slider{:id => id}
%footer
  %a{:href => CREDIT[1]}=CREDIT[0]
{% endhighlight %}

ボールのサイズ　速度　軌跡　色を調整するために
８個のスライダーと対応するラベルを用意します

##eqball.js(1)
{% highlight javascript %}
var canvas = {};
var ball = {
  radius : 35,
  x : 50,
  y : 50,
  spx : 10,
  spy : 10,
  color : 'rgba(30,30,30,1)'
};
var _360 = 2*Math.PI
var x = ball.radius, y = ball.radius;
var bg_alpha = 1.0;
$(document).ready(function(){
  
  setInterval(function(){ bounce(ball) }, 40);
  $(".slider").slider({ orientation: 'vertical', range: 'min' });
  
  $(".slider#size").slider({ min: 5, max: 75, value: ball.radius,
    slide: function(event, ui){
      ball.radius = ui.value;
      label($(this), ui);
    }
  });
})
{% endhighlight %}

ballオブジェクトを生成しsetInterval()で
bounce関数に一定周期で渡します
スライダーの初期設定と操作されたときのイベントを
$(".slider").sliderの引数として記述します
slideイベントでスライダーの値ui.valueを
ボールの各属性にセットします

後述のlabel関数でラベルの表示も変更します
ここでは
サイズを変更するスライダーのコードのみを示していますが
他のスライダーについても同じように記述します

##eqball.js(2)
{% highlight javascript %}
function label (obj, ui) {
  var id = obj.attr('id');
  $("input#"+id).val(ui.value);
}
function bounce (ball) {
  rad = ball.radius;
  if (ball.x > canvas.width-rad || ball.x < 0+rad) { ball.spx = -ball.spx };
  if (ball.y > canvas.height-rad || ball.y < 0+rad) { ball.spy = -ball.spy };
  ball.x += ball.spx;
  ball.y += ball.spy;
  var ctx = canvas.ctx
  fadeToClear(bg_alpha);
  ctx.beginPath();
  ctx.arc(ball.x, ball.y, rad, 0, _360, true);
  ctx.fillStyle = ball.color;
  ctx.fill();
}
function fadeToClear (alpha) {
  var ctx = canvas.ctx;
  ctx.fillStyle = rgba(255,255,240,alpha);
  ctx.fillRect(0, 0, canvas.width, canvas.height);
}
{% endhighlight %}

label関数でスライダーのラベルの表示を変更します
bounce関数でボールを描画します
キャンバスの境界でボールが反転するように
if条件でspx spyの向きを変えます
この反転条件は手抜きでボールが壁に沈んでしまいますが
ここではよしとします

fadeToClear関数でキャンバスをクリアしたのち
ctx.arc ~ ctx.fillでボールを描きます
fadeToClear関数はボールの軌跡を残せるように
clearRectせずに
alpha値を調整したキャンバスの色を再描画します

視覚に訴えるプログラミングも楽しいですね！

Enjoy Your Canvas Life!

ソースコードは以下にあります
[](https://github.com/melborne/EQBall)
{% footnotes %}
   {% fn http://jqueryui.com/demos/slider/ %}
{% endfootnotes %}
