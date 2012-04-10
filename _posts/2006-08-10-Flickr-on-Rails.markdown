---
layout: post
title: Flickr on Railsをいじる(その１)
date: 2006-08-10
comments: true
categories:
---


昨日Railsで作ったFlickrインタフェースを少し改良してみました。改良点は以下の通り。
1. flickrの特定ユーザを検索し、そのコレクションを表示できるようにする。
1. １つの検索インタフェースを使って、タグおよびユーザの両方の検索が切り替えでできるようにする。
1. 表示レイアウトにタイトルバーナーを追加する。
手順は以下の通り。

-1. select_tagの追加
検索の対象を選択するために、select_tagをindex.rhtmlの＜fieldset＞に追加する。選択肢はoptions_for_selectで記述する。
{% highlight bash %}
  <fieldset>
     <label for="tags">Tags:</label>
     <%= select_tag 'kind', options_for_select({'tag' => 'search_tag','user' => 'search_user'}) %>
     <%= text_field_tag 'tags' %>
     <%= submit_tag 'Find' %>
  </fieldset>
{% endhighlight %}
-2. form_remote_tagの修正
select_tagで選択した対象(tag or user)をsearch methodに渡せるようにform_remote_tagを修正する。
{% highlight bash %}
  <%= form_remote_tag :url => {:action => 'search', :params => params[:kind]},
                :update => 'photos',
   	        :complete => visual_effect(:blind_down, 'photos'),
	        :before => %(Element.show('spinner')),
	        :success => %(Element.hide('spinner')) %>
{% endhighlight %}
-3. search methodの修正
select_tagでの選択肢によって処理を切り分けるためにcase文を使う。[こちら](http://redgreenblu.com/flickr/)にあったFlickr.rbのmethodを参照にしてsearch_user内の処理を記述する。
{% highlight bash %}
  def search
    flickr = Flickr.new 'your flickr API key'
    
    case params[:kind]
    when "search_tag"
      render :partial => "photo", 
                 :collection => flickr.photos(:tags => params[:tags], :per_page => '30')
    when "search_user"
      user = flickr.users(params[:tags])
      render :partial => "photo", :collection => user.photos    
    end
  end
{% endhighlight %}
-4. application.rhtmlの修正
タイトルバナーを表示するように、application.rhtmlの<body>を修正する。
{% highlight bash %}
  <body>
	<div id="banner">
		My Flickr
	</div>
	<div id="main">
		<%= yield %>
	</div>
  </body>
{% endhighlight %}
-5. flickr.cssの修正
application.rhtmlに追加したbanner, mainのスタイルをflickr.cssに記述する。
{% highlight bash %}
  #banner {
    background: #C0C0C0;
    padding-top: 10px;
    padding-bottom: 10px;
    border-bottom: 2px solid;
    font: small-caps 40px/40px "Times New Roman", serif;
    color: #A52A2A;
    text-align: center;
  }
  #main {
    margin-left: 0em;
    padding-top: 2ex;
    padding-left: 2em;
    background: white;
  }
{% endhighlight %}
-6. 完了
ブラウザでhttp://localhost:3000/flickrにアクセスし表示を確認。タブでtagまたはuserを選択し検索ワードを入れて検索。動いているようです。select_tagで選択した対象をsearch methodに渡す方法が分からずに悩みました。入力した検索ワードがヒットしない場合に、画面上にrailsのエラーメッセージが出てしまいます。これも直したいです。
