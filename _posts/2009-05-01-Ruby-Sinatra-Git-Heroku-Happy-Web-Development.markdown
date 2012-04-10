---
layout: post
title: Ruby.Sinatra.Git.Heroku #=> "Happy Web Development!"　(後編)
date: 2009-05-01
comments: true
categories:
---


mycal.rbに戻ってもう少し機能を増やします
日表示のための以下のコードを追加します
{% highlight ruby %}
 get '/:year/:mon/:day' do |*ymd|
   @year, @mon, @day = ymd.map { |x| x.to_i }
   @dcal = cal(@year, @mon)
   @message = 'Webカレンダー完成予定日'
   erb :day
 end
 
 __END__
 
 @@day
 <%= @year %>年<%= @mon %>月<%= @day %>日
 <%= @message %>
 <%= @dcal %>
{% endhighlight %}

Webサーバを起動します
{% highlight ruby %}
 mycal% ruby mycal.rb
{% endhighlight %}

http://localhost:4567/1993/2/24にアクセスして
1993年2月24日の頁が表示されるか確認します

頁のカレンダーにおいて
対象の日の色付けを行うためタグを挿入します
メッセージもグレードアップします
先のコードを以下のように修正します
{% highlight ruby %}
 get '/:year/:mon/:day' do |*ymd|
   @year, @mon, @day = ymd.map { |x| x.to_i }
   @dcal = cal(@year, @mon).sub(/\s#{@day}(?=\D)/, '<span id="target">\0</span>')
   @message = 'Webカレンダー完成予定日'
   @message += '<br/>って、期限過ぎてるじゃん！' if Time.local(*ymd) - Time.now < 0
   erb :day
 end
{% endhighlight %}
subを使って日にマッチさせタグを挿入しています

http://localhost:4567/1998/5/14にアクセスします
メッセージを確認します
頁のソースを表示して14日にタグが挿入されているか確認します

表示形式が頁によって異なっているので
divで要素を識別できるようにテンプレートを修正します
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
     <div id="banner">
       <h1><a id='title' href='/'>Web Calendar</a></h1>
       <div id="year_pred"><a href="/<%= @year-1 %>">Previous Year</a></div>
       <div id="year_next"><a href="/<%= @year+1 %>">Next Year</a></div>
     </div>
     <div id="main">
       <%= yield %>
     </div>
   </body>
 </html>
 
 @@index
 <div id="index">
   <pre class="ycal"><%= @ycal %></pre>
 </div>
 
 @@year
 <div id="year">
   <pre class="ycal"><%= @ycal %></pre>
 </div>
 
 @@mon
 <div id="mon">
   <pre class="mcal"><%= @mcal %></pre>
 </div>
 
 @@day
 <div id="day">
   <h3 id="date"><%= @year %>年<%= @mon %>月<%= @day %>日</h3>
   <p id="message"><%= @message %></p>
   <pre class="dcal"><%= @dcal %></pre>
 </div>
{% endhighlight %}
yield回りの＜pre＞を削除し
各実体頁側で対応するようにします

年のカレンダーにおいて月単位でのデータ処理を実現するため
各月のカレンダーを生成し個別のdivで管理するようにします
helpersを以下のように修正します
{% highlight ruby %}
 helpers do
   def cal(*date)
     year, mon = date
     cal = if mon
       calendar(mon, year)
     else
       (1..12).inject("") do |s, m|
         monthly_cal = "<div class='mon_cal' id='mon_#{m}'>" + calendar(m, year) + "</div>"
         s << monthly_cal
       end
     end
     cal.gsub(/((#{MONTHS.join('|')})\w*)/) do
       %Q{<a href="/#{year}/#{MONTHS.index($2)+1}">#{$1}</a>}
     end
   end
   
   def calendar(m, y)
     `cal #{m} #{y}`
   end
 end
{% endhighlight %}
calコマンドはcalendarメソッドとして別にします
この時点でhttp://localhost:4567/にアクセスすると
表示は崩れていますが表示がなされていれば先に進みます

今日の日付にタグを付けます
calメソッドのelse節を次のようにします
{% highlight ruby %}
 (1..12).inject("") do |s, m|
   monthly_cal = "<div class='mon_cal id='mon_#{m}>" + calendar(m, year) + "</div>"
   #make today tag
   today = Time.now
   if m == today.mon and year == today.year
     monthly_cal.sub!(/\s#{today.day}(?=\D)/, '<span id="today">\0</span>')          
   end
   s << monthly_cal
 end
{% endhighlight %}

更に各日付に該当頁のリンクタグを挿入します
else節に追加します
{% highlight ruby %}
 (1..12).inject("") do |s, m|
   monthly_cal = "<div class='mon_cal id='mon_#{m}>" + calendar(m, year) + "</div>"
   #make days link
   monthly_cal.gsub!(/(\s([1-3]?[0-9](?=\D)))/) do
     %Q{<a class="days_link" href="/#{year}/#{m}/#{$2}">#{$1}</a>}
   end
   #make today tag
   today = Time.now
   if m == today.mon and year == today.year
     monthly_cal.sub!(/\s#{today.day}(?=\D)/, '<span id="today">\0</span>')          
   end
   s << monthly_cal
 end
{% endhighlight %}

最後にテンプレートに以下のスタイルを挿入して完成です
{% highlight css %}
 __END__
 @@layout
 <!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.1//EN"
   "http://www.w3.org/TR/xhtml11/DTD/xhtml11.dtd">
 <html>
   <head>
     <meta http-equiv="Content-type" content="text/html; charset=utf-8">
     <title>mycal</title>
     <style type="text/css" media="screen">
       * { margin: 0; padding: 0;}
       body {background:#eed;}
       #banner { margin:20px; margin-left:auto; margin-right:auto; width:700px; color:#906; }
       #title { margin-left:250px;}
       #year_pred { float:left; }
       #year_next { float:right; }
 
       #main { position:absolute; left:50%; margin:30px 0 0 -360px; height:60%;}
       .ycal { color:#514; font-weight:bold;}
       .mon_cal { float:left; margin:5px 10px 5px 10px;}
       #mon_5, #mon_9 {clear:left;}
       #mon { margin-left:100px;}
       .mcal { color:#217; font-size:32pt; margin-top:10px; clear:right; }
       #day { margin-left:250px;}
       .dcal { color:#217; font-size:16pt; clear:right; }
       h3#date { font-size:24pt; color:#c06;}
       #message { font-size:14pt; color:#360; margin:30px 0 30px 0;}
       #target { color:#c06;}
       a {text-decoration:none; color:#514;}
       a.days_link:link, a.days_link:visited { color:#217;}
       a:hover, a.days_link:hover { color:#383;}
       #today { color:#060;}
     </style>
   </head>
   <body id="mycal">
     <div id="banner">
       <h1><a id='title' href='/'>Web Calendar</a></h1>
       <div id="year_pred"><a href="/<%= @year-1 %>">Previous Year</a></div>
       <div id="year_next"><a href="/<%= @year+1 %>">Next Year</a></div>
     </div>
     <div id="main">
       <%= yield %>
     </div>
   </body>
 </html>
{% endhighlight %}
http://localhost:4567/にアクセスします
Previous Yearを5回クリックしてAugustをクリックします
2004年8月のカレンダーが表示されているのを確認します
そこからNext Yearを3回クリックして
Octoberの15日をクリックします
2007年10月15日のカレンダーが表示されているのを確認します
そこからNext Yearを3回クリックしてMayの3日をクリックします
2010年5月3日のカレンダーが表示されているのを確認します

カレンダーが完成したのでcommitしてHerokuにpushします
{% highlight ruby %}
 mycal% git commit -m "second commit"
 mycal% git push heroku
 mycal% heroku open
{% endhighlight %}

以下のようなカレンダーがブラウザに表示されたら成功です
![image](http://img.f.hatena.ne.jp/images/fotolife/k/keyesberry/20090501/20090501093355.png)


こちらで作成したサイトには以下からアクセスできます

[mycal](http://mycal.heroku.com/)

コードは以下にあります
[gist: 104362 - GitHub](http://gist.github.com/104362)

[前回](http://d.hatena.ne.jp/keyesberry/20090425/p1)と[前々回](http://d.hatena.ne.jp/keyesberry/20090407/p1)のチュートリアルで作成した
アプリケーションのURLも貼っておきます

ScanAnimation
http://scananimation.heroku.com/

WORDS in Books
http://words-in-books.heroku.com/