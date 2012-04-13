---
layout: post
title: HerokuでSinatraでmemcachedしようよ!
date: 2011-07-11
comments: true
categories:
---

##HerokuでSinatraでmemcachedしようよ!
「NoSQL データベースファーストガイド」(著：佐々木達也)
という本を読んでるよ
各種NoSQLのひと通りの説明と
それぞれにRubyを使ったサンプルがあって
僕のようなNoSQL知識ゼロ(NoKnowledge)
の人にとってはとてもためになるよ
特にサンプルは各NoSQLの利用状況を想定して作られているから
実用的でうれしいよね

{{ '4798029599' | amazon_large_image }}

{{ '4798029599' | amazon_link }}

{{ '4798029599' | amazon_authors }}

その中に音楽視聴ランキングサイトの楽しいサンプルがあるんだよ
それはGyaoの音楽ランキングに基づいて
YouTubeから対応動画を取ってきてリスト表示するというものだよ
一度アクセスしたデータは
memcachedを使ってサイト側で保持することで
サイトのレスポンスを良くすると共に
他サイトへの負荷を下げるという例だよ

早速僕も同じようなサイトを作って
memcachedの使い方を学ぶよ
本の例はRailsをベースにしてるんだけど
僕はRailsをよく知らないのでここではSinatraを使うよ
そして折角だからHerokuにpushもしてみるね

##memcached
環境はOSX Snow Leopardだよ
ローカルでmemcachedを使うには
brew install memcachedすればいいよ
very verboseモードでの起動はこうだよ
{% highlight bash %}
 $ memcached -vv
{% endhighlight %}

Herokuでmemcachedを使う場合は
add-onするだけでいいみたいなんだ{% fn_ref 1 %}
{% highlight bash %}
 $ heroku addons:add memcache
{% endhighlight %}
5MBまでは無料だけど{% fn_ref 2 %}add-onを利用するには
クレジットカード情報などによる登録が必要だよ
登録しないで上のコマンドを実行すると
登録サイトを教えてくれるからそれに従ってね

最初にmemcachedは何かということなんだけれども
僕はこれをリクエスト間の共有メモリ空間と理解したんだ
普通Webサーバはステートレスつまり
ユーザからの各リクエストは別々のメモリ空間で処理されるんだけど
memcachedを使うと多数のリクエストが
一つの共有メモリ空間を利用できるようになる
つまりmemcachedはWebサーバをステートフルにする
こう理解したんだけどあってるかな？

##GyaoRankサイト
さて最終的にでき上がったものは以下にあるよ

http://gyaorank.heroku.com/

まあ見た目がちゃちいけど
サンプルだから許してね..
調べたらGyaoでは
音楽以外のランキングデータも配信していたので{% fn_ref 3 %}
ここではそれらにも対応してみたよ
ヒット率がかなり悪いけど..

ファイル構成をまず示すよ
{% highlight bash %}
├── Gemfile
├── Gemfile.lock
├── app.rb
├── config.ru
├── system_extensions.rb
└── views
    ├── index.haml
    ├── layout.haml
    └── style.scss
{% endhighlight %}

Gemfileの中身は以下のとおりだよ
{% highlight ruby %}
source :rubygems
gem 'sinatra'
gem 'haml'
gem 'sass'
gem 'dalli'
gem 'nokogiri'
{% endhighlight %}
本の例ではmemcachedのRubyインタフェースに
memcache-clientというのを使ってるんだけど
HerokuではSASL{% fn_ref 4 %}という
セキュリティ上の認証ができるgemしか使えないようなんだ
だからSASLに対応したDalliという
変わった名前のgemを使っているよ
余談だけどdalliとnokogiriを並べて書くと
僕にはdankogaiに見えてしょうがないんだよ!

SinatraでDalliを使うときは例えば以下のようにするよ
{% highlight ruby %}
set :cache, Dalli::Client.new(ENV['MEMCACHE_SERVERS'],
                    :username => ENV['MEMCACHE_USERNAME'],
                    :password => ENV['MEMCACHE_PASSWORD'],
                    :expires_in => 1.day)
data = settings.cache.get(key)
settings.cache.set(key,data)
{% endhighlight %}
つまりDalli::Clientオブジェクトをcacheという変数にセットして
getでkeyに対応するデータの取得をし
setでkeyにdataを保存する
データの保持期間はオブジェクト生成時のoptionで指定できる
optionを指定しないならmemcache serverの指定を含めて
引数は不要だよ

次にapp.rbだけど
ちょっと長いので分けて要点だけ説明するよ
{% highlight ruby %}
get '/:term/:category' do |term, category|
  @term, @category, @date = term, category, Date.today
  @videos = videos(term, category, @date.to_s)
  @urls = %w(daily weekly newly).product %w(music movie drama anime owarai variety all)
  haml :index
end
{% endhighlight %}
Gyaoではmusic movie drama anime owarai variety allの
各カテゴリデータにつき
daily weekly newlyという期間データを用意しているんだ
だからgetではそれらをパラメータとして取って
これに応じたビデオのリストを
videosメソッドで取得するようにしている
また@urlsはプルダウンメニューで使っているよ

videosメソッドを見るよ
{% highlight ruby %}
helpers do
  def videos(*term_category_date)
    key = term_category_date * '/'
    if vdata = settings.cache.get(key)
      vdata
    else
      vdata = get_videos(*term_category_date)
      settings.cache.set(key, vdata)
      vdata
    end
  rescue
    get_videos(*term_category_date)
  end
end
{% endhighlight %}
ここではmemcachedにアクセスするためのkeyとして
渡された引数term, category, dateを
/ で連結したものを使っているよ
最初にmemcachedに同じキーのデータがあるか見て
なければget_videosメソッドで
GyaoとYouTubeにアクセスして
データを取得しmemcachedにセットする
rescueでmemcachedが死んでる場合にも一応対応したよ

次にget_videosメソッドを見るよ
{% highlight ruby %}
helpers do
  def get_videos(*term_category_date)
    ranking = rank_data(term_category_date.first 2)
    video_data(ranking)
  end
end
{% endhighlight %}
ここではrank_dataメソッドでGyaoにアクセスし
内容を解析してランキングデータを取得し
video_dataメソッドでそのデータに対応する動画を
YouTubeから取得しているよ

で具体的なこれらの処理の内容は次のとおりだよ
Gyaoのデータはrssライブラリを使って
YouTubeのデータは
nokogiriライブラリを使って解析しているよ
やっていることは本の例と基本的には同じだよ
{% highlight ruby %}
helpers do
  def rank_data(*term_category)
    rss = open( URL(:rank) + term_category*'/' ) { |f| RSS::Parser.parse f.read }
    rss.items.inject([]) { |mem, item| mem << item.title.scan(/[^「」]+/) }
  end
  def video_data(ranking)
    ranking.thread_with(true) do |artist, title|
      opts = ["vq=" + URI.encode("%s %s" % [artist, title]), "format=5"]*'&'
      entry = Nokogiri::XML(open [URL(:video), opts]*'?').search('entry').first
      data = { artist: artist, title:  title }
      if entry
        q = { url:    entry.xpath('media:group/media:content').first['url'],
              type:   entry.xpath('media:group/media:content').first['type'],
              count:  entry.xpath('yt:statistics').first['viewCount'] }
        data.update q
      end
      data
    end
  end
  def URL(code)
    { video: 'http://gdata.youtube.com/feeds/api/videos',
      rank:  'http://gyao.yahoo.co.jp/rss/ranking/c/' }[code]
  end
end
{% endhighlight %}
ただここではビデオの取得にスレッドを使っているよ
折角だからここでは[この間作った](/2011/06/29/notitle/)
Enumerable#thread_withを使ってみたよ
これはsystem_extensions.rbというファイルに置いてあるよ

system_extensions.rbの中身はこうだよ
{% highlight ruby %}
# encoding: UTF-8
module Enumerable
  def thread_with(order=false)
    mem = []
    map.with_index do |*item, i|
      Thread.new(*item) do |*_item|
        mem << [i, yield(*_item)]
      end
    end.each(&:join)
    (order ? mem.sort : mem).map(&:last)
  end
end
class Fixnum
  def day
    self##60*24
  end
  alias days day
end
module Kernel
  def requires(*features)
    features.each { |f| require f.to_s }
  end
end
{% endhighlight %}
Fixnum#dayとKernel#requiresは
app.rbでつかってるんだけど
まあおまけだよ

layout.hamlとindex.hamlには
特に面白いところはないので説明は省くね

NoSQLってなんかもっと難しいものをイメージしてたけど
全然そんなこと無いんだね

(追記：2011-7-11)Dalli::Client.newの引数を修正しました。{% fn_ref 5 %}

<script src="https://gist.github.com/1075425.js"> </script>
{% footnotes %}
   {% fn http://devcenter.heroku.com/articles/memcache %}
   {% fn http://addons.heroku.com/memcache %}
   {% fn http://www.redcruise.com/search.php?srcstr=GyaO %}
   {% fn Simple Authentication and Security Layer %}
   {% fn https://github.com/mperham/dalli/wiki/Heroku-Configuration %}
{% endfootnotes %}
