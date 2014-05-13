---
layout: post
title: Rubyで写真にタイトルを付けてFlickrにアップしよう!
date: 2009-10-01
comments: true
categories:
---


毎回食事の写真を撮ってタイトル付きでFlickrにアップしている
タイトルは「Lunch Sep 29 2009」のように
食事の種別と日付にしている
毎食となると月に100以上も写真をアップすることになるので
このタイトル付けは結構しんどい
何の目的もなく食事の写真を撮っているのでやめてもいいんだけど
こういうことは一旦始めるとやめるのにも覚悟がいる
そこで覚悟を先送りにしたい自分の結論はこうなる

こういう面倒なことはRubyにやってもらおう!

##Exifデータの取得
デジカメで撮った写真データにはExifというメタデータが付いている
Exifには撮影日時のデータが含まれているので
これを読み出せれば上記のようなタイトルの構築は簡単だ

Rubyにはこの目的にexifrというライブラリがある
これをインストールして使ってみよう
(Mac OSX Tigerを前提に書いています)
{% highlight ruby %}
 % sudo gem install exifr
{% endhighlight %}
まずはirbで
{% highlight ruby %}
 % irb -rexifr
 irb(main):001:0> p01 = EXIFR::JPEG.new "RIMG0001.JPG"
 => #<EXIFR::JPEG:0x5ef948 @bits=8, @height=2448, @width=3264, @exif=[{:image_desc ription=>"", :make=>"RICOH", :model=>"GR Digital", :orientation=>#<EXIFR::TIFF::O rientation:0x5fcd3c @value=1, @type=:TopLeft>, :x_resolution=>(72/1), :y_resoluti on=>(72/1), :resolution_unit=>2, :date_time=>2009-09-29 19:37:07 +0900, :ycb_cr_positioning=>2, :copyright=>"(C) by GR Digital User", :exposure_time=>(1/9), :f_number=>(12/5), :exposure_program=>2, :iso_speed_ratings=>154, :date_time_original=>2009-09-29 19:37:07 +0900, :date_time_digitized=>2009-09-29 19:37:07 +0900, :compressed_bits_per_pixel=>(14/5), :aperture_value=>(5/2), :brightness_value=>(858993455/2), :exposure_bias_value=>(0/1), :max_aperture_value=>(12/5), :metering_mode=>5, :light_source=>0, :flash=>16, :focal_length=>(59/10), :color_space=>1, :pixel_x_dimension=>3264, :pixel_y_dimension=>2448, :exposure_mode=>0, :white_balance=>0, :scene_capture_type=>0, :sharpness=>0}, {:compression=>6, :x_resolution=>(72/1), :y_resolution=>(72/1), :resolution_unit=>2, :jpeg_interchange_format=>25361, :jpeg_interchange_format_length=>5397}]> 
 irb(main):002:0> p01.date_time_original
 => 2009-09-29 19:37:07 +0900
 irb(main):003:0> p01.date_time_original.class
 => Time
{% endhighlight %}
ほうこりゃ簡単だ
EXIFR::JPEG#date_timeはTimeクラスを返すので
Time#strftimeが使える
{% highlight ruby %}
 irb(main):004:0> p01.date_time_original.strftime("%b %d %Y")
 => "Sep 29 2009"
{% endhighlight %}

##Flickrへのアップロード
次にFlickrへのアップロードだ
FlickrにはFlickr上の写真を操作するためのAPIが用意されている
APIには写真をFlickrにアップするためのメソッドもある
このAPIを使うには自分のFlickrアカウントにリンクした
API Keyを事前に取得しておく必要がある

Flickr Services
http://www.flickr.com/services/

また写真をアップするためにはそのプログラムを
対象アカウントに認証させるためのトークンの取得が必要になる

Rubyにはrflickrというライブラリがあり
認証トークンの取得および写真のアップロードの機能を持っている
これをインストールして使ってみよう
{% highlight ruby %}
 % sudo gem install rflickr
{% endhighlight %}
更新が止まっていてRuby1.9には対応していない
添付のGETTING-STARTEDにはトークン取得のためのサンプルコードがある{% fn_ref 1 %}
{% highlight ruby %}
  flickr = Flickr.new(token_cache_file,MY_APPLICATION_KEY,MY_SHARED_SECRET)
  unless flickr.auth.token
    flickr.auth.getFrob
    url = @flickr.auth.login_link
    puts "You must visit #{url} to authorize this application.  Press enter"+
     " when you have done so. This is the only time you will have to do this."
    gets
    flickr.auth.getToken
    flickr.auth.cache_token
  end
{% endhighlight %}
このコードを実行してターミナルに表示されたURLにアクセスし
そこでこのプログラムに対する認証を行えば
token_cache_fileに認証トークンが保存されるようだ
二度目からは取得した認証トークンを使って
プログラムの認証が行われる

以上の知識を使ってFlickrPhotoクラスを書いてみた

使い方は以下のようにする

1.FlickrPhoto.set_tokenでプログラムを認証させる
2.FlickrPhoto.newで写真のオブジェクトを生成する
3.タイトルなど必要な属性をセットする
4.FlickrPhoto#uploadで写真をアップロードする

<script src="http://gist.github.com/197856.js"></script>
保証はありませんが同じようなことで
お困りの方がおられたら使ってください

(参考)
[digital:pardoe - Using rFlickr](http://digitalpardoe.co.uk/blog/show/87)

[Ruby を使って Flickr へ写真をアップロード - まちゅダイアリー(2008-10-20)](http://www.machu.jp/diary/20081020.html#p01)

(追記:2009/10/11)撮影日を取得するのにdate_timeではなくdate_time_originalを使うよう修正しました。API KeyをPitを使って管理するようにしました。
<a href="http://subtech.g.hatena.ne.jp/cho45/20080102/1199257680">アカウント情報を管理するコマンド pit - 冬通りに消え行く制服ガールは、夢物語にリアルを求めない。 - subtech</a>

{% footnotes %}
   {% fn Macでは /opt/local/lib/ruby/gems/1.8/gems/rflickr-2006.02.01/GETTING-STARTED %}
{% endfootnotes %}
