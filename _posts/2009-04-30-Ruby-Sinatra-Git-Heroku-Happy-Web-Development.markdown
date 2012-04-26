---
layout: post
title: 'Ruby.Sinatra.Git.Heroku #=> "Happy Web Development!"'
date: 2009-04-30
comments: true
categories:
tags: [ruby, sinatra, webapp, heroku]
---

##Ruby
10年前にRubyといえば7月の誕生石のことか、5.5ポイント活字のことでした。でも今はGoogleを30頁めくっても、妻に誕生石をプレゼントすることはできません。宝石店のSEO対策は日本人の作った言語セットの前では無力なのです。

この点PerlのLarryさんは巧妙にやりました。Pearlは今も6月の誕生石の地位を守っています。ここにLarryの奥さんは6月生まれであり、Matzの奥さんは7月生まれでないとの仮説が成り立ちます。

##Sinatra
なぜWebフレームワークの名前を[Sinatra](http://www.sinatrarb.com/)としたのか皆目検討も付きません。シナトラハットがトレードマークですから、そうなんでしょうがそれにしても...Railsとは違うMyWayを行くという意味でしょうか。それとも裏社会との繋がりを暗示しているのでしょうか。まさか「[支那虎](http://www.google.co.jp/search?client=safari&rls=ja-jp&q=%E6%94%AF%E9%82%A3%E8%99%8E&esrch=BetaShortcuts&ie=UTF-8&oe=UTF-8)」ですか？

ー名は体を表すー といいますが、これほどに体をイメージし辛い名も滅多にありません。改名を強く望みます。Googleで「[Sinatra](http://www.google.co.jp/search?client=safari&rls=ja-jp&q=sinatra&esrch=BetaShortcuts&ie=UTF-8&oe=UTF-8)」と打って、このWebフレームワークがトップに来た日がその命日にならないことを祈りつつ。

##Git
[Git](http://git-scm.com/)は「ぎっと」と発音します。意味はこうです。
{% highlight bash %}
 git  {名} : まぬけ、ばか、あほ、役立たず、無能な人
{% endhighlight %}
Linusさんにそう言われれば返す言葉は何もありません。でも消沈する必要はありません。「git」とググられて、わたしやあなたの名前はもう出てこないのですから。これは[GoogleBomb](http://en.wikipedia.org/wiki/Google_bomb)ではなくGooglePieceなのです。ですから誰か早く、ヴァージョン管理システム「[ass hole](http://www.google.co.jp/search?client=safari&rls=ja-jp&q=ass%20hole&esrch=BetaShortcuts&ie=UTF-8&oe=UTF-8)」を作って我が国の首相を救ってください！

##Heroku
[Heroku](http://heroku.com/)は「Her-OH-koo」と発音します。Google App Engineほどつまらない名前はないですが、その意味に辿り着けないというのもまたつまらないものです。でも、わたしはその答えにおそらく辿り着けました。ヒントはプライスリストです。

[Heroku | Pricing](http://heroku.com/pricing#blossom-2)

彼らもまた東洋の神秘に見せられていたのです！でも答えは「奥歯」じゃありません。韓流にハマっている妻に付き合っていた意味が、今顕在化したのです...

Herokuはハングルで「&#54616;&#50725;」と書きます。意味は「下獄」つまり、「罪人を牢屋に入れること」です。つまりHerokuユーザは、知らずのうちに罪人とされていたのです！わたしも気が付くのが遅すぎました。暫く刑に服そうと思います。「[チェオクの剣](http://www3.nhk.or.jp/kaigai/tamo/)」でも見ながら...

Sinatraを使って無機能Webカレンダーを作ります。それをGitでHerokuにデプロイします。OSX+Terminal+TextMateを前提に書きます。

あなたも罪人になってみませんか？

##Ruby+Sinatra
Sinatraをインストールします。現時点でRuby1.9には完全には対応していません。
{% highlight ruby %}
 % sudo gem install sinatra
{% endhighlight %}

mycalフォルダにmycal.rbファイルを作ります。
{% highlight ruby %}
 % mkdir mycal
 % cd mycal/
 mycal% mate mycal.rb
{% endhighlight %}

mycal.rbを編集します。
{% highlight ruby %}
 require "rubygems"
 require "sinatra"
 
 get '/' do
   @year = Time.now.year
   @ycal = `cal #{@year}`
   erb :index
 end
 
 __END__
 @@index
 <!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.1//EN"
   "http://www.w3.org/TR/xhtml11/DTD/xhtml11.dtd">
 <html>
   <head>
     <meta http-equiv="Content-type" content="text/html; charset=utf-8">
     <title>mycal</title>
   </head>
   <body id="mycal">
     <pre><%= @ycal %></pre>
   </body>
 </html>
{% endhighlight %}
`(バッククオート)でシェルコマンドcalを呼んでいます。\_\_END__以降にerbテンプレートを書きます。@@indexがラベルです。

calが使えない環境の場合、ふなばただよしさんのcal.rbが使えます。

[cal.rb](http://www.funaba.org/ruby.html#cal)

その場合cal.rbをrequireして@ycal = \`cal...を以下に変えます。
{% highlight ruby %}
 require 'cal'
 cal = Cal.new
 cal.opt_y(mon ? false : true)
 @ycal = cal.print(year, mon)
{% endhighlight %}

mycal.rbを実行します。
{% highlight ruby %}
 mycal% ruby mycal.rb
{% endhighlight %}

Webサーバが起動するので、ブラウザでhttp://localhost:4567/にアクセスします。カレンダーが表示されます。

サーバを起動したまま、mycal.rbに以下を追加します。
{% highlight ruby %}
 get '/:year' do |year|
   @year = year.to_i
   @ycal = `cal #{@year}`
   erb :year
 end
{% endhighlight %}

\_\_END\_\_以下を次のように変えます。
{% highlight ruby %}
 __END__
 @@layout
 <!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.1//EN"
   "http://www.w3.org/TR/xhtml11/DTD/xhtml11.dtd">
 <html>
   <head>
     <meta http-equiv="Content-type" content="text/html; charset=utf-8">
     <title>mycal</title>
   </head>
   <body id="mycal">
     <pre><%= yield %></pre>    
   </body>
 </html>
 
 @@index
 <%= @ycal %>
 
 @@year
 <%= @ycal %>
{% endhighlight %}
つまり \<pre\>\</pre\> 内にyieldを置いてlayoutと実体を分けます。

ブラウザでhttp://localhost:4567/1999にアクセスします。1999年のカレンダーが表示されます。

mycal.rbに以下を追加します。
{% highlight ruby %}
 get '/:year/:mon' do |*ym|
   @year, @mon = ym.map { |x| x.to_i  }
   @mcal = `cal #{@mon} #{@year}`
   erb :mon
 end
 
 __END__
 
 @@mon
 <%= @mcal %>
{% endhighlight %}

ブラウザでhttp://localhost:4567/1999/12にアクセスします。1999年12月のカレンダーが表示されます。

helpersを使って\`cal...を一ヶ所にまとめます。
{% highlight ruby %}
 get '/' do
   @year = Time.now.year
   @ycal = cal(@year)
   erb :index
 end
 
 get '/:year' do |year|
   @year = year.to_i
   @ycal = cal(@year)
   erb :year
 end
 
 get '/:year/:mon' do |ym|
   @year, @mon = ym.map { |x| x.to_i  }
   @mcal = cal(@year, @mon)
   erb :mon
 end
 
 helpers do
   def cal(*date)
     year, mon = date
     `cal #{mon} #{year}`
   end
 end
{% endhighlight %}

年カレンダーの月にリンクを張ります。
{% highlight ruby %}
 helpers do
   MONTHS = %w(Jan Feb Mar Apr May Jun Jul Aug Sep Oct Nov Dec)  
   def cal(*date)
     year, mon = date
     cal = `cal #{mon} #{year}`
     cal.gsub(/((#{MONTHS.join('|')})\w*)/) do
       %Q{<a href="/#{year}/#{MONTHS.index($2)+1}">#{$1}</a>}
     end
   end
 end
{% endhighlight %}

gsubで月の文字列にマッチさせます。ブラウザでhttp://localhost:4567/にアクセスします。Aprilのリンクをクリックして。4月のカレンダーが表示されるか確かめます。

ロードの度にTerminalに以下の警告が表れています。
{% highlight ruby %}
 ./mycal.rb:23: warning: already initialized constant MONTHS
{% endhighlight %}

MONTHS定義をconfigureに移して対処します。
{% highlight ruby %}
 configure do
   MONTHS = %w(Jan Feb Mar Apr May Jun Jul Aug Sep Oct Nov Dec)  
 end
{% endhighlight %}
configureブロックのコードは最初に一度起動されるだけです。ctrl+cでWebサーバを停止し、ruby mycal.rbで再起動して有効にします。

layoutをバナーとメインに分けます。バナーにはタイトルと前年・翌年のリンクを置きます。
{% highlight ruby %}
 __END__
 @@layout
 <!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.1//EN"
   "http://www.w3.org/TR/xhtml11/DTD/xhtml11.dtd">
 <html>
   <head>
     <meta http-equiv="Content-type" content="text/html; charset=utf-8">
     <title>mycal</title>
     
   </head>
   <div id="banner">
     <h1><a id='title' href='/'>Web Calendar</a></h1>
     <div id="year_pred"><a href="/<%= @year-1 %>">Previous Year</a></div>
     <div id="year_next"><a href="/<%= @year+1 %>">Next Year</a></div>
   </div>
   <div id="main">
     <pre><%= yield %></pre>    
   </div>
 </html>
{% endhighlight %}
ブラウザでhttp://localhost:4567/にアクセスしてPrevious Year/Next Yearを適当にクリックします。タイトルをクリックして本年に戻るか確認します。

##Git
そろそろGitでHerokuにデプロイしてみます。

念のためmycal.rbの全体を載せます。
{% highlight ruby %}
 require "rubygems"
 require "sinatra"
 
 get '/' do
   @year = Time.now.year
   @ycal = cal(@year)
   erb :index
 end
 
 get '/:year' do |year|
   @year = year.to_i
   @ycal = cal(@year)
   erb :year
 end
 
 get '/:year/:mon' do |ym|
   @year, @mon = ym.map { |x| x.to_i  }
   @mcal = cal(@year, @mon)
   erb :mon
 end
 
 configure do
   MONTHS = %w(Jan Feb Mar Apr May Jun Jul Aug Sep Oct Nov Dec)  
 end
 
 helpers do
   def cal(*date)
     year, mon = date
     cal = `cal #{mon} #{year}`
     cal.gsub(/((#{MONTHS.join('|')})\w*)/) do
       %Q{<a href="/#{year}/#{MONTHS.index($2)+1}">#{$1}</a>}
     end
   end
 end
 
 __END__
 @@layout
 <!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.1//EN"
   "http://www.w3.org/TR/xhtml11/DTD/xhtml11.dtd">
 <html>
   <head>
     <meta http-equiv="Content-type" content="text/html; charset=utf-8">
     <title>mycal</title>
     
   </head>
   <body id="mycal">
     <div id="banner">
       <h1><a id='title' href='/'>Web Calendar</a></h1>
       <div id="year_pred"><a href="/<%= @year-1 %>">Previous Year</a></div>
       <div id="year_next"><a href="/<%= @year+1 %>">Next Year</a></div>
     </div>
     <div id="main">
       <pre><%= yield %></pre>    
     </div>
   </body>
 </html>
 
 @@index
 <%= @ycal %>
 
 @@year
 <%= @ycal %>
 
 @@mon
 <%= @mcal %>
{% endhighlight %}

Gitのインストールはこの辺を参考にします。

[hikariworks::blog&#160;&#187;&#160; MacPortsでgitをインストール](http://hikariworks.jp/blog/2008/06/18/macports%E3%81%A7git%E3%82%92%E3%82%A4%E3%83%B3%E3%82%B9%E3%83%88%E3%83%BC%E3%83%AB/)

[Heroku | Using Git](http://docs.heroku.com/git#installing)

Webサーバを止めてGitをセットアップします。
{% highlight ruby %}
 mycal% git init
{% endhighlight %}
.gitフォルダができます。

以下の内容のconfig.ruを作ります。
{% highlight ruby %}
 require 'mycal'
 run Sinatra::Application
{% endhighlight %}

{% highlight ruby %}
 mycal% echo "require 'mycal' ; run Sinatra::Application" > config.ru
{% endhighlight %}

Gitにファイルを追加します。
{% highlight ruby %}
 mycal% git add .
{% endhighlight %}

コミットします。
{% highlight ruby %}
 mycal% git commit -m "first commit"
{% endhighlight %}

##Heroku
Herokuにアカウントが無ければ作ります。

[Heroku](http://heroku.com/)

次にHeroku gemをインストールします。
{% highlight ruby %}
 mycal% sudo gem install heroku
{% endhighlight %}

Herokuではsshを使うので、ssh keyが無ければ作っておきます。
{% highlight ruby %}
 % ssh-keygen -t rsa
{% endhighlight %}

この辺を参考にします。

[Heroku | Using Git](http://docs.heroku.com/git#setting-up-ssh-public-keys)

[＠IT：Linuxでsshの鍵を作成するには](http://www.atmarkit.co.jp/flinux/rensai/linuxtips/432makesshkey.html)

Herokuにレポジトリを作ります。
{% highlight ruby %}
 mycal% heroku create
{% endhighlight %}

任意のレポ名が割り当てられます。レポ名.heroku.comがurlになります。heroku create myappとして、レポ名を指定できます(mycalは取得されています)。heroku rename newnameでリネイムできます。

初回だけemailとpasswordを聞かれます。初回だけkeyのアップロードの要否が聞かれます。

そしてHerokuにコードをpushします。
{% highlight ruby %}
 mycal% git push heroku master
{% endhighlight %}
次回以降masterは不要です。

これでデプロイできました。アプリケーションにアクセスしましょう。
{% highlight ruby %}
 mycal% heroku open
{% endhighlight %}

以下のようなカレンダーが表示されたら成功です。

![image](http://img.f.hatena.ne.jp/images/fotolife/k/keyesberry/20090430/20090430100819.png)


([次回に続く]({{ site.url }}/2009/05/01/notitle/))

(参考リンク)

[sinatra's heroku-sinatra-app at master - GitHub](http://github.com/sinatra/heroku-sinatra-app/tree/master)

[Heroku | Heroku Documentation](http://docs.heroku.com/)

[Heroku & Sinatra](http://www.slideshare.net/myles_byrne/heroku-sinatra)

[zerosum dirt(nap) - Clone Pastie with Sinatra & DataMapper 0.9](http://blog.zerosum.org/2008/7/2/clone-pastie-with-sinatra-datamapper-redux)

[Heroku Garden](http://herokugarden.com/)

[git チュートリアル (バージョン 1.5.1 以降用)](http://www8.atwiki.jp/git_jp/pub/Documentation.ja/tutorial.html)

[$ cheat git](http://cheat.errtheblog.com/s/git)

