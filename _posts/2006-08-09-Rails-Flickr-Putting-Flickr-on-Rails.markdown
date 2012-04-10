---
layout: post
title: RailsでFlickrを遊ぼう! (Putting Flickr on Rails)
date: 2006-08-09
comments: true
categories:
---


Ruby on Railsサイトには、Flickrのインタフェースを５分で作ってしまうというデモビデオがあります([screencasts](http://www.rubyonrails.org/screencasts))。ちょっと感動したので自分でも同じものを作ってみました。手順を書いておきます。

まず、自分はRailsの環境としてLocomotiveを使っていたのですが、flickr libraryの取得がうまくできなかったので、AWDwRで紹介のあった[こちらのサイト](http://hivelogic.com/articles/2005/12/01/ruby_rails_lighttpd_mysql_tiger)で環境を再構築しました。

-1. Flickr API keyの取得
Flickr APIを利用するためには、[flickrのサイト](http://www.flickr.com/services/)よりAPI keyを取得する必要があります。簡単な必要事項を入力すれば直ちにkeyが発行されます。公開サーバーでAPIを利用する場合はconfigurationが必要になりますが、ローカルで遊ぶだけなら必要ありません。
-2. flickrプロジェクトの作成
flickrという名前でrailsのプロジェクトを作成します。
{% highlight bash %}
  >rails flickr
{% endhighlight %}
-3. flickr libraryのインストール
rubyでflickr APIを使うためのライブラリFlickrをインストールします。
{% highlight bash %}
  >sudo gem install flickr
{% endhighlight %}
-4. 環境設定
flickr libraryを使えるように、configディレクトリにあるenvironment.rbの最後に以下を追加する。
{% highlight bash %}
  require 'flickr'
{% endhighlight %}
-5. application.rhtmlの作成
viewのlayoutディレクトリ内に、以下のapplication.rhtmlファイルを作成する。
{% highlight bash %}
  <!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN"
	"http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
  <html>
	<head>
		<meta http-equiv="Content-type" content="text/html; charset=utf-8" />
		<title>Flickr</title>
		<%= javascript_include_tag :defaults %>
		<%= stylesheet_link_tag 'flickr' %>
	</head>
	<body>
		<%= yield %>
	</body>
  </html>
{% endhighlight %}
-6. flickr.cssの作成
public/stylesheetsディレクトリにflickr.cssを作成し、application.rhtmlのスタイルを記述する。
{% highlight bash %}
  body {
	background-color: #888;
	font-family: Lucida Grande;
	font-size: 11px;
	margin: 25px;
  }
{% endhighlight %}
-7. flickr controllerの作成
flickrという名前でcontrollerを作成する。
{% highlight bash %}
  > ruby script/generate controller flickr
{% endhighlight %}
-8. index.rhtmlの作成
views/flickrディレクトリにindex.rhtmlを作成し、以下を記述する。
{% highlight bash %}
  <%= form_remote_tag :url => {:action => 'search'}, :update => 'photos' %>
	
	<fieldset>
		<label for="tags">Tags:</label>
		<%= text_field_tag 'tags' %>
		<%= submit_tag 'Find' %>
	</fieldset>
	<div id="photos"></div>
  <%= end_form_tag %>
{% endhighlight %}
-9. index.rhtmlに対するスタイルをflickr.cssに記述する。
{% highlight bash %}
  form {
	margin: 0;
	margin-bottom: 10px;
	background-color: #eee;
	border: 5px solid #333;
	padding: 25px;
  }
  fieldset {
	border: none;
  }
{% endhighlight %}
-10. サーバーの起動
サーバーを起動し、http://localhost:3000/flickrにアクセスして表示を確かめる。
{% highlight bash %}
  >ruby script/server
{% endhighlight %}
-11. search methodの実装
controllersディレクトリ内のflickr_controller.rbにsearch methodを記述する。1.で取得したFlickr API keyをFlickr.newのパラメータとして渡す。
{% highlight bash %}
  def search
    flickr = Flickr.new 'your flickr API key'
    render :partial => "photo", :collection => flickr.photos(:tags => params[:tags], :per_page => '24')
  end
{% endhighlight %}
-12. _photo.rhtmlの作成
indexのpartial viewとして、views/flickrディレクトリに_photo.rhtmlを作成し、以下を記述する。
{% highlight bash %}
  <img class="photo" src="<%= photo.sizes[0]['source'] %>">
{% endhighlight %}
-13. _photo.rhtmlに対するスタイルをflickr.cssに記述する。
{% highlight bash %}
  #photos img {
	border: 1px solid #000;
	width: 75px;
	height:75px;
	margin: 5px;
  }
{% endhighlight %}
-14. 表示の確認
ブラウザをリロードし、検索ワード'rubyconf'を入れて表示を確かめる。
-15. index.rhtmlの修正
(1)表示エフェクトの追加,(2)spinner.gif(データロード待ちの間くるくる回っているやつ)の表示のためにindex.rhtmlを以下のように修正する。
{% highlight bash %}
  <%= form_remote_tag :url => {:action => 'search'}, :update => 'photos',
 	:complete => visual_effect(:blind_down, 'photos'),
	:before => %(Element.show('spinner')),
	:success => %(Element.hide('spinner')) %>
	
	<%= image_tag 'spinner.gif', :id => 'spinner', :style => 'display: none' %>
	
	<fieldset>
		<label for="tags">Tags:</label>
		<%= text_field_tag 'tags' %>
		<%= submit_tag 'Find' %>
	</fieldset>
	<div id="photos" style="display: none"></div>
  <%= end_form_tag %>
{% endhighlight %}
-16. spinnerのスタイルをflickr.cssに記述する。
{% highlight bash %}
  #spinner {
	float: right;
	margin: 10px;
  }
{% endhighlight %}
-17. spinner.gifの入手
[こちら](http://trac.turbogears.org/turbogears/attachment/ticket/274/spinner.gif)などからspinner.gifを入手し、public/imagesディレクトリにコピー。
-18. 完成
ブラウザをリロードし試してみてください。僕の環境ではちょっと動作が重いですが、なかなか楽しめそうです。enjoy!

関連記事：[Flickr on Railsをいじる(その１)](http://d.hatena.ne.jp/keyesberry/20060810/p1)
　　　　　[Flickr on Railsをいじる(その２)](http://d.hatena.ne.jp/keyesberry/20060811/p1)

追記(2006/10/28)：flickrライブラリ(flickr.rb)の仕様が変わったようで、現時点(2006/10/28)では上記はうまく動きませんね。今の仕様ではflickr api keyはflickr.rb内に記述するようになっていますので、以下を試してください。
1./usr/local/lib/ruby/gems/1.8/gems/flickr-1.0.0にあるflickr.rb内の仮のapi keyを取得したapi keyに書き換える。
2.flickr_controller.rbではapi keyを書かずに、flickr = Flickr.newのみとする。 
追記(2007/5/21)：flickr.rbの在処は環境によって異なります。上記を試して表示されるエラーの内容で場所を確認してください。
非常に参考になりました。追記の変更もためしてみましたが、うまく動きませんでした。Brian Leonard氏の以下のサイトに従い、再度ためすとうまく動きましたのでご参考まで：<br>http://weblogs.java.net/blog/bleonard/archive/2007/03/building_a_ruby.htmlyoshiさん、コメントありがとうございます。こちらでも再検証してみます。
