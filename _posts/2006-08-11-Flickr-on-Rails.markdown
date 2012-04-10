---
layout: post
title: Flickr on Railsをいじる(その２)
date: 2006-08-11
comments: true
categories:
---


Flickrインタフェースをさらに少し改良してみました。改良点は写真をオーバーレイ表示する機能の追加です。ネットを検索したらLightbox JSというスクリプトを使って既にこれを実現しているサイトがありましたので利用させて頂きました。
[](http://seb.box.re/articles/2006/06/11/add-lightbox-zoom-on-the-flickr-ajax-rails-tutorial)
手順は以下の通り。
-1. Lightbox JSを入手
[こちらのサイト](http://www.huddletogether.com/projects/lightbox2/)からLightbox JS v2.0をダウンロードする。
-2. 必要ファイルをflickrプロジェクトにコピー
以下のファイルをプロジェクトの対応ディレクトリにコピーする。
lightbox.css => public/stylesheets/
lightbox.js   => public/javascripts/
image-1.jpg, thumb-1.jpg以外のすべてのイメージファイル => public/images/
-3. application.rhtmlの修正
lightbox.css, lightbox.jsを参照するようapplication.rhtmlの対応箇所に追加する。
{% highlight bash %}
 <%= javascript_include_tag :defaults, 'lightbox' %>
 <%= stylesheet_link_tag 'flickr', 'lightbox' %>
{% endhighlight %}
-4. Lightboxリンクの作成
表示される写真にLightboxのリンクが貼られるように_photo.rhtmlを修正する。
{% highlight bash %}
<a href="<%= photo.sizes[3]['source'] %>" rel="lightbox"><img class="photo" src="<%= photo.sizes[0]['source'] %>"/></a>
{% endhighlight %}
-5. index.rhtmlの修正
Lightboxが初期化されるようにindex.rhtmlにおけるform_remote_tagのcompleteオプションを修正する。
{% highlight bash %}
 :complete => visual_effect(:blind_down, 'photos') + %(new Lightbox())
{% endhighlight %}
個々の写真を拡大して見れるようになりました。すばらしいですね。
