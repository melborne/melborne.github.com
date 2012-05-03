---
layout: post
title: "Railsでブログを作ろう！(Creating a Weblog in 15 minutes)"
date: 2007-06-14
comments: true
categories:
tags:
published: true
---


Ruby on Railsのサイトで紹介されている有名なscreencastデモ"[Creating a Weblog in 15 minutes](http://www.rubyonrails.org/screencasts)"を自分の勉強を兼ねて勝手にドキュメント化してみました(解説はこちらで適当にしました。DHHさんのものではありません)。デモは、Mac OSXの環境で、[MySQL](http://www.mysql.com/), [iTerm](http://iterm.sourceforge.net/), [TextMate](http://macromates.com/), [CocoaMySQL](http://cocoamysql.sourceforge.net/)を使って行われています。
##1. brablogプロジェクトの作成
iTerm(Terminal)を立ち上げて、brablogという名前でプロジェクトを作ります。
{% highlight bash %}
 $ rails brablog
{% endhighlight %}
作成されたbrablogのフォルダに移動し、webrickサーバーを起動して、プロジェクトが立ち上がっているか確認します。
{% highlight bash %}
 $ cd brablog
 $ ./script/server
{% endhighlight %}
ブラウザで、 [http://localhost:3000/](http://localhost:3000/) へアクセス。RailsのWelcomeページが表示されましたね？
##2. Blogコントローラの作成
iTermで別セッションを開き(command+T)、そこからBlogプロジェクトの関連ファイルをTextMate上にオープンします。
{% highlight bash %}
 $ cd brablog
 $ mate .
{% endhighlight %}
既に多数の関連ファイルが作成されているのがわかりますね。
次に、script/generateコマンドを使って、Blogコントローラを作成します。
{% highlight bash %}
 $ ./script/generate controller Blog
{% endhighlight %}
[http://localhost:3000/blog](http://localhost:3000/blog) にアクセスすると、indexに対するactionが定義されていないとのエラーメッセージが出ました。
では、indexを定義しましょう。TextMateに移って、app-controllerフォルダにあるblog_controller.rbをオープンし、以下を加えます。
{% highlight bash %}
 def index
   render :text => "Hello World!"
 end
{% endhighlight %}
[http://localhost:3000/blog](http://localhost:3000/blog) にアクセスすると、今度は"Hello World!"の文字が表示されましたね？
今度は、def index endの定義だけを残して、中身のrender :text...を削除します。代わりに、app-views-blogフォルダ内に、index.rhtmlを作成して、そこに以下を打ち込みましょう。
{% highlight bash %}
hello from the template
{% endhighlight %}
同様にブラウザでアクセスして、上の文字が表示されましたか？
では、blog_controller.rb内のdef index endを削除して、どうなるか見てみましょう。これでもindex.rhtmlの内容が同じように表示されましたね。
##3. データベースへの設定
次に、blogのデータを格納するデータベースの準備します。最初に、若干の設定をします。configフォルダにあるdatabase.ymlを編集しましょう。developmentのデータベースをblog_development,testのものをblog_testとします。usernameなど他の設定はご自身の環境に合わせてください。
{% highlight bash %}
development:
  adapter: mysql
  database: blog_development
  username: root
  password: 
  socket: /tmp/mysql.sock
test:
  adapter: mysql
  database: blog_test
  username: root
  password: 
  socket: /tmp/mysql.sock
production:
  development
{% endhighlight %}
##4. データベースの作成
次に、CocoaMySQLを立ち上げて、blog_developmentデータベースを作成し、postsテーブルを作成します。テーブル名は複数形(posts)にします。コラムは、id(auto_increment, primary key), title(varchar 255)を作成します。なお、後述しますが、現行バージョンのRailsではmigrationというデータベースのスキーマ管理機能があるので、テーブルの作成はそちらを使う方が便利です。
##5. Postモデルの作成
script/generateコマンドを使って、モデルを作成します。
{% highlight bash %}
 $ ./script/generate model Post
{% endhighlight %}
##6. scaffoldメソッド
次に、blog_controller.rbのBlogControllerクラス内に以下の一行を記述します。
{% highlight bash %}
 scaffold :post
{% endhighlight %}
データベースの設定を変更したので、サーバを立ち上げ直しましょう。
{% highlight bash %}
 $ ^C
 $ ./script/server
{% endhighlight %}
[http://localhost:3000/blog](http://localhost:3000/blog) にアクセスしましょう。うまく表示されましたか？では、New Postボタンを押して、タイトル("Hello Brazil!")を入力してみましょう。
##7. コラムの追加
次に、CocoaMySQLに移り、コラムbody(text)を追加します。
ブラウザをリロードすれば、bodyの入力エリアが現れました。bodyにも入力してみましょう("Yes, yes, hello indeed!")。
どうですか？うまく動いていますか？
では、更に、作成日時を記録するようにもしましょう。CocoaMySQLで、コラムcreated_at(datetime)を追加します。
ブラウザをリロードしてみましょう。入力したデータをエディットしてみてください。作成日時が追加されますね。
では、CocoaMySQL上で、コラムcreated_atをマウスでドラッグしてbodyコラムの上に移動してみてください。ブラウザをリロードするとどうなりますか？
これらの一連の作業において、サーバーの再起動も、再コンパイルも必要ありません。
Railsの名前規約に従っていれば、Railsアプリケーションは簡単にデータベースへアクセスすることができるようになります。

> ##~Migration~
> なお、デモからは外れますが、現行のRailsバージョンではmigrationが使えるので、上記の代わりにこれを使った方が便利です。CocoaMySQLでblog_developmentデータベースを作成した後、db-migrateフォルダにある001_create_posts.rbを編集します。このファイルはモデルの作成時に同時に作成されます。
> >||
> class CreatePosts < ActiveRecord::Migration
>   def self.up
>     create_table :posts do |t|
>       t.column :title, :string
>       t.column :body,  :text
>       t.column :created_at :datetime
>     end
>   end
> 
>   def self.down
>     drop_table :posts
>   end
> end
> ||<
> 雛形が出来上がっているので、create_tableのブロック内を追加するだけです。このときidコラムは自動生成されるためここでの追加は不要です。
> 次いで、migrationを実行すれば、上記upメソッドが実行されて、postsテーブルが生成されます。
> >||
>  $ rake db:migrate
> ||<

次に、タイトル入力に対する検証をするようにします。app-modelsフォルダ内のpost.rbに、以下を追加します。
{% highlight bash %}
 validate_presence_of :title
{% endhighlight %}
タイトルを入れないで投稿して見てください。エラーメッセージが出ますね？
では、ちゃんと投稿してみましょう(title "Better fill it in, then!", body "Aye, aye, sir")。
##8. scaffoldジェネレータ
先のscaffoldメソッドはワンラインで便利なんですけど、コードが変更できない問題があります。ですので、他の方法をやってみましょう。scaffoldジェネレータを使います。
{% highlight bash %}
 $ ./scrip/generate scaffold Post Blog
{% endhighlight %}
途中、blog_controller.rbを上書きしてよいか聞かれますので、a を押して上書きしてください。
TextMateでblog_controller.rbを見てみると、いろいろなコードが生成されているのが分かります。add-viewsフォルダ内には各アクションに対応したビューも自動生成されています。ブラウザをリロードしてみてください。同じ表示が維持されていると思います。
自動生成された表示はブログに適したものになっていないので、list.rhtmlをブログに適したものに編集してみましょう。
{% highlight bash %}
<h1>My wonderful weblog</h1>
<% for post in @posts %>
   <div>
	<h2><%= link_to post.title, :action => 'show', :id => post %></h2>
	<p><%= post.body %></p>
	<p><small>
	   <%= post.created_at.to_s(:long) %>
	   (<%= link_to 'Edit', :action => 'edit', :id => post %>)
	</small></p>
   </div>
<% end %>
<%= link_to 'New post', :action => 'new' %>
{% endhighlight %}
ブラウザをリロードしてみてください。体裁が良くなりました。新たにデータも追加しましょう(title "Let's just add a third, for good measure", body "Oh yeah")。
最新投稿が一番上に来るように、表示されるリストの順序を逆にしましょう。先ほどのlist.rhtmlの
{% highlight bash %}
<% for post in @posts %>
{% endhighlight %}
を、以下に修正してください。
{% highlight bash %}
<% for post in @posts.reverse %>
{% endhighlight %}
次に、textilizeメソッドを使って、表示をリッチにします。先に、bodyに入力した、"Aye, aye, sir"を以下のように修正します。
{% highlight bash %}
 Aye, *aye*, _sir_
{% endhighlight %}
そして、list.rhtmlの、
{% highlight bash %}
 <p><%= post.body %></p>
{% endhighlight %}
を、
{% highlight bash %}
 <p><%= textilize(post.body) %></p>
{% endhighlight %}
のように修正します。このメソッドにはRedClothモジュールが必要です。
{% highlight bash %}
 $ sudo gem install redcloth
{% endhighlight %}
ブラウザをリロードして、リストが逆順になったことと、bodyの表示がリッチになった点を確認してください。
##9. partialの使用
同様の表示をpartialを使ってやってみましょう。app-views-blogフォルダ内に _post.rhtmlというファイルを作成し、先のlist.rhtmlにおける、以下の部分を移動します。
{% highlight bash %}
 <div>
   <h2><%= link_to post.title, :action => 'show', :id => post %></h2>
   <p><%= post.body %></p>
   <p><small>
      <%= post.created_at.to_s(:long) %>
      (<%= link_to 'Edit', :action => 'edit', :id => post %>)
   </small></p>
 </div>
{% endhighlight %}
そして、list.rhtmlの内容は以下のようにします。
{% highlight bash %}
 <h1>My wonderful weblog</h1>
 <%= render :partial => "post", :collection => @posts.reverse %>
 <%= link_to 'New post', :action => 'new' %>
{% endhighlight %}
ブラウザをリロードすれば、表示に変化がないことがわかります。
次いで、showビューでもこの_post.rhtmlのテンプレートを使いましょう。app-views-blogフォルダのshow.rhtmlを以下のようにします。
{% highlight bash %}
 <%= render :partial => "post", :object => @post %>
 <%= link_to 'Edit', :action => 'edit', :id => @post %> |
 <%= link_to 'Back', :action => 'list' %>
{% endhighlight %}
これでshowビューもきれいになりました。
##10. Commentデータの管理
さて、次に、ブログにはコメントが必要ですので、これを作ります。まずは、Commentモデルを作ります。
{% highlight bash %}
 $ ./script/generate model Comment
{% endhighlight %}
生成されたComment.rb(Commentモデル)に、Postモデルとの関係性を示す以下を追加します。
{% highlight bash %}
 belongs_to :post
{% endhighlight %}
一方、Post.rb(Postモデル)にもCommentモデルとの関係性を記述します。
{% highlight bash %}
 has_many :comments
{% endhighlight %}
１つのPostが複数のcommentを持ち得るので、":comments"と複数形になります。
次いで、CocoaMySQLで、commentsテーブル(複数形)を作成し、コラムid(auto_increment, primary key), body(text), post_id(int11)を追加します。
> 現行バージョンではmigrationを使うことができます。002_create_comments.rbを以下のようにします。
> >||
> class CreateComments < ActiveRecord::Migration
>   def self.up
>     create_table :comments do |t|
>       t.column :body, :text
>       t.column :post_id, :integer
>     end
>   end
> 
>   def self.down
>     drop_table :comments
>   end
> end
> ||<
> そして、migrateします。
> >||
>  $ rake db:migrate
> ||<
CocoaMySQLにおいて、commentデータを１件入力してみましょう(body "Yes, I agree with the Hello!" post_id "1")。
さて、次に、show.rhtmlに以下を追加して、コメントがそこに表示されるようにしましょう。
{% highlight bash %}
<h2>Comments</h2>
<% for comment in @post.comments %>
   <%= comment.body %>
   <hr />
<% end %>
{% endhighlight %}
さらに、コメントをこのページで投稿できるようにしましょう。show.rhtmlにさらに以下の入力フォームのコードを追加します。
{% highlight bash %}
<%= form_tag :action => "comment", :id => @post %>
	<%= text_area "comment", "body" %><br>
	<%= submit_tag "Comment!" %>
<%= end_form_tag %>
{% endhighlight %}
そして、このフォームに応答するcommentアクションを、blog_controller.rbに定義します。
{% highlight bash %}
 def comment
   Post.find(params[:id]).comments.create(params[:comment])
   flash[:notice] = "Added your comment."
   redirect_to :action => "show", :id => params[:id]
 end
{% endhighlight %}
ブラウザをリロードして、コメントを投稿してみてください("Me too, me too!")。うまく行きましたか？ページの上部にはコメントが追加されたことを示すフラッシュが表示されます。これで、コメント付きのブログができました。
##11. テスト他
さて、これまでにどれだけのコードを書いたのでしょうか。調べてみましょう。
{% highlight bash %}
 $ rake stats
{% endhighlight %}
たった58行のコード！
次に、ログからrailsの挙動を見ることもできます。
{% highlight bash %}
 $ tail -f log/development.log
{% endhighlight %}
上のコマンドを実行してから、投稿や画面遷移をしてみてください(ctrl+Cで終了)。
Railsではunitテストやfunctionalテストも簡単にできるようになっています。
まず、CocoaMySQLでblog_testデータベースを作成します。そして、以下を実行します。
{% highlight bash %}
 $ rake test:units
{% endhighlight %}
test-unitフォルダを見ると、既に2つのunitテストが用意されており、これをパスしたようです。
post_test.rbを編集して、別のテストをしてみましょう。
{% highlight bash %}
require File.dirname(__FILE__) + '/../test_helper'
class PostTest < Test::Unit::TestCase
  fixtures :posts
  def setup
    @post = Post.find(1)
  end
  def test_adding_comment
    @post.comments.create :body => "My new comment"
    @post.reload
    assert_equal 1, @post.comments.size
  end
end
{% endhighlight %}
再度、テストします。
{% highlight bash %}
 $ rake test:units
{% endhighlight %}
簡単ですね。
また、Railsにはconsoleという優れたツールがあります。
これを使えばWebインタフェースを介さずにデータの操作ができます。
{% highlight bash %}
 $ ./script/console
{% endhighlight %}
でconsoleを立ち上げて、
{% highlight bash %}
 p = Post.find :first
 p.title = "Hello Denmark"
 p.save
{% endhighlight %}
などとします。ブラウザをリロードして変化を確かめてください。
{% highlight bash %}
 p.comments.create :body => "Greeting to the cold north!"
 p.comments.create :body => "Greeting to the super, super cold north!"
 p.comments
{% endhighlight %}
最初の投稿に対してコメントを追加しました。
{% highlight bash %}
 p.destroy
{% endhighlight %}
これで投稿が削除されます。
