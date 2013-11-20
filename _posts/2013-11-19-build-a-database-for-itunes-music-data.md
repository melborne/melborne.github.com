---
layout: post
title: "iTunes.appの音楽ライブラリを最速でWebアプリにするたった３つのステップ"
description: ""
category: 
tags: 
date: 2013-11-19
published: true
---
{% include JB/setup %}

意味もなく`iTunes.app`に入ってる音楽ライブラリをブラウザ上に表示したいという衝動に駆られる。

手始めに音楽ファイルからメタ情報を取るライブラリがないか探してみる。次のようなものが見つかる。

> [arbarlow/ruby-mp4info](https://github.com/arbarlow/ruby-mp4info "arbarlow/ruby-mp4info")
> 
> [moumar/ruby-audioinfo](https://github.com/moumar/ruby-audioinfo "moumar/ruby-audioinfo")

しかしどういうわけか上手く働かない。

次にAppleScriptをブリッジしてMacなアプリを操作するための`rb-appscript`の存在を思い出す。

> [rb-appscript | RubyGems.org | your community gem host](https://rubygems.org/gems/rb-appscript "rb-appscript | RubyGems.org | your community gem host")
> 
> [rb-appscript manual | Contents](http://appscript.sourceforge.net/rb-appscript/doc/appscript-manual/index.html "rb-appscript manual | Contents")

iTunesを操作できるんだから情報くらいとれるに違いない。

{% highlight ruby %}
% irb -rappscript
IRB on Ruby2.0.0
>> include Appscript #=> Object
>> itunes = app("iTunes") #=> app("/Applications/iTunes.app")
>> itunes.elements
=> ["AirPlay_devices", "EQ_presets", "EQ_windows", "URL_tracks", "application", "artworks", "audio_CD_playlists", "audio_CD_tracks", "browser_windows", "encoders", "file_tracks", "folder_playlists", "items", "library_playlists", "playlist_windows", "playlists", "print_settings", "radio_tuner_playlists", "shared_tracks", "sources", "tracks", "user_playlists", "visuals", "windows"]
{% endhighlight %}

`tracks`というのが怪しい。

{% highlight ruby %}
>> itunes.tracks #=> app("/Applications/iTunes.app").tracks
>> itunes.tracks.first #=> app("/Applications/iTunes.app").tracks.first
>> itunes.tracks.first.class #=> Appscript::Reference
>> itunes.tracks.first.properties
=> ["AirPlay_enabled", "EQ", "EQ_enabled", "active", "address", "album", "album_artist", "album_rating", "album_rating_kind", "artist", "available", "band_1", "band_10", "band_2", "band_3", "band_4", "band_5", "band_6", "band_7", "band_8", "band_9", "bit_rate", "bookmark", "bookmarkable", "bounds", "bpm", "capacity", "category", "class_", "closeable", "collapseable", "collapsed", "collating", "comment", "compilation", "composer", "container", "converting", "copies", "current_AirPlay_devices", "current_EQ_preset", "current_encoder", "current_playlist", "current_stream_URL", "current_stream_title", "current_track", "current_visual", "data_", "database_ID", "date_added", "description", "disc_count", "disc_number", "downloaded", "duration", "enabled", "ending_page", "episode_ID", "episode_number", "error_handling", "fax_number", "finish", "fixed_indexing", "format", "free_space", "frontmost", "full_screen", "gapless", "genre", "grouping", "iTunesU", "id_", "index", "kind", "location", "long_description", "lyrics", "minimized", "modifiable", "modification_date", "mute", "name", "network_address", "pages_across", "pages_down", "parent", "persistent_ID", "played_count", "played_date", "player_position", "player_state", "podcast", "position", "preamp", "printer_features", "properties_", "protected", "rating", "rating_kind", "raw_data", "release_date", "requested_print_time", "resizable", "sample_rate", "season_number", "selected", "selection", "shared", "show", "shufflable", "shuffle", "size", "skipped_count", "skipped_date", "smart", "song_repeat", "sort_album", "sort_album_artist", "sort_artist", "sort_composer", "sort_name", "sort_show", "sound_volume", "special_kind", "start", "starting_page", "supports_audio", "supports_video", "target_printer", "time", "track_count", "track_number", "unplayed", "update_tracks", "version", "video_kind", "view", "visible", "visual_size", "visuals_enabled", "volume_adjustment", "year", "zoomable", "zoomed"]
{% endhighlight %}

思ったとおりだ。

{% highlight ruby %}
>> itunes.tracks.first.name.get #=> "S.O.S."
>> itunes.tracks.first.artist.get #=> "ABBA"
{% endhighlight %}

これを使ってまずはCSVファイルを吐くか。

---

そんなわけで...。

`rb-appscript`を使ってiTunesのtrack情報にアクセスする`ItunesTrack`というライブラリを作りました:-)

> [itunes_track | RubyGems.org | your community gem host](https://rubygems.org/gems/itunes_track "itunes_track | RubyGems.org | your community gem host")
> 
> [melborne/itunes_track](https://github.com/melborne/itunes_track "melborne/itunes_track")

`ItunesTrack`には`to_csv`という抽出した音楽情報をCSVに落とすメソッドがあるので、以下ではこれを使って３ステップでWebアプリを作る手順を説明します。`ItunesTrack`の詳しい説明は別の記事にします。


##STEP1: ItunesTrackでITunesから音楽データを取得しCSV化する

ItunesTrackをインストールします。

{% highlight bash %}
/itunes% gem install itunes_track
Fetching: itunes_track-0.0.1.gem (100%)
Successfully installed itunes_track-0.0.1
1 gem installed
{% endhighlight %}

これでターミナル上でitunes_trackコマンドが使えるようになります。

まずはitunes_trackコマンドで表示されるhelpを確認します。

{% highlight bash %}
itunes% itunes_track
Commands:
  itunes_track csv PATH        # Create CSV file from tracks data
  itunes_track help [COMMAND]  # Describe available commands or one specific command
  itunes_track size ARTIST     # Show track size for ARTIST match
  itunes_track tracks          # Show tracks
  itunes_track version         # Show ItunesTrack version
{% endhighlight %}

`size`サブコマンドを使って自分の音楽ライブラリの曲数を数えます。

{% highlight bash %}
itunes% itunes_track size
1091
{% endhighlight %}

これくらいならさばけそうなので`csv`サブコマンドで全曲をCSV化します。まずはヘルプを読みます。

{% highlight bash %}
/itunes% itunes_track help csv
Usage:
  itunes_track csv PATH

Options:
  -f, [--fields=FIELDS]
                         # Default: name,time,artist,album,genre,rating,played_count,year,composer,track_count,track_number,disc_count,disc_number,lyrics
  -a, [--artist=ARTIST]

Create CSV file from tracks data
{% endhighlight %}

`--fields`オプションで抽出するフィールドを限定できるようなので、name, time, artist, album, played_count, lyricsを対象にして、CSVを作ってみます。

{% highlight bash %}
/itunes% itunes_track csv itunes.csv -f name,time,artist,album,played_count,lyrics
I am working on csv...
CSV file successfully created at itunes.csv.
{% endhighlight %}

カレントディレクトリにできた`itunes.csv`を開いてみます。

{% highlight bash %}
name,time,artist,album,played_count,lyrics
S.O.S.,3:23,ABBA,The Piano Songs [Disc 2],76,"Where are those happy..."
Daydreamer,3:40,Adele,19,13,""
Best For Last,4:18,Adele,19,11,""
Chasing Pavements,3:30,Adele,19,11,""
Cold Shoulder,3:11,Adele,19,12,""
Crazy For You,3:28,Adele,19,14,""
  .
  .
  .
Things Will Change,4:53,Audiophil,"Mercedes-Benz Mixed Tape ""Fine Frequencies""",22,""
Hard Line,6:03,AXMusique,Mercedes-Benz Mixed Tape ‘Cherry Chimes’,60,""
New-Ish,3:14,Azekel ,Mercedes-Benz Mixed Tape ‘Anniversary Bliss’,82,""
Oblivious,3:12,Aztec Camera,The Guitar Songs [Disc 1],71,""
Spirit You Are My Cherry Blossom,4:55,Baker,Mercedes-Benz Mixed Tape #52,7,""
僕たちの将来,6:46,Bank Band,沿志奏逢,79,"あたしたち多分 大丈夫よね..."
突然の贈り物,6:11,Bank Band,沿志奏逢,78,""
糸,4:44,Bank Band,沿志奏逢,61,"なぜ　めぐり逢うのかを..."
  .
  .
  .
{% endhighlight %}

いい感じです。

##STEP2: CtoDでCSVからデータベース・テーブルを作る

CSVができればあとは`CtoD`に投げればいいです。

> [CSVデータをデータベース化するツール「CtoD」の紹介](http://melborne.github.io/2013/11/14/introduce-ctod-gem-easyway-to-make-a-database-table/ "CSVデータをデータベース化するツール「CtoD」の紹介")

上の記事に従って`ctoD export`します。

{% highlight bash %}
/itunes% ctoD export itunes.csv sqlite3://localhost/$PWD/itunes.sqlite3
Table 'itunes' created at sqlite3://localhost//Users/keyes/Dropbox/playground/itunes/itunes.sqlite3.
CSV data exported successfully.
{% endhighlight %}

sqlite3データベースの完成です。

##STEP3: SinatraでWebアプリを作る

あとはSinatraを使ってRubyのコードを書きます。

> [Excelデータを最速でWebアプリ(Heroku)にする<del>１０</del>９のステップ](http://melborne.github.io/2013/11/11/your-data-from-excel-to-the-web/ "Excelデータを最速でWebアプリ(Heroku)にする<del>１０</del>９のステップ")


{% highlight ruby %}
#app.rb
require 'sinatra'
require 'haml'
require 'ctoD'

class Itune < ActiveRecord::Base
end

configure :development do
   CtoD::DB.connect("sqlite3://localhost/#{ENV['PWD']}/itunes.sqlite3")
end

get '/' do
  redirect '/itune'
end

get '/itune' do
  @collection = Itune.all
  haml :index
end

get '/itune/:id' do |id|
  # avoid ActiveRecord::ConnectionTimeoutError
  ActiveRecord::Base.connection_pool.with_connection do
    @item = Itune.find(id)
    haml :item
  end
end

helpers do
  def columns(&excond)
    Itune.column_names.reject(&excond)
  end

  def columns_long
    columns { |n| n.match /_at$/ }
  end

  def columns_short
    columns { |n| n.match /(_at|lyrics)$/ }
  end
end

__END__
@@layout
!!!
%html
  %head
    %meta{charset:'utf-8'}
    %title iTunes Music
    %link{:href=>"//netdna.bootstrapcdn.com/bootstrap/3.0.2/css/bootstrap.min.css", :rel=>"stylesheet"}
    %script{:src=>"//netdna.bootstrapcdn.com/bootstrap/3.0.2/js/bootstrap.min.js"}
  %body
    .container
      != yield

@@index
%h2 iTunes Music
%table.table.table-striped.table-hover.table-bordered
  %thead.header
    - columns_short.each do |t|
      %th= t
  %tbody
    - @collection.each do |st|
      %tr
        - columns_short.each do |t|
          - if t=='name'
            %td
              %a{href:"/itune/#{st.id}"}= st[t]
          - else
            %td= st[t]

@@item
%h3= @item.name
%table.table
  - columns_long.each do |t|
    %tr
      %td= t
      %td= @item[t]
{% endhighlight %}

`ruby app.rb`して[http://localhost:4567/itune](http://localhost:4567/itune "iTunes Music")にアクセスします。

![itunes noshadow]({{ BASE_PATH }}/assets/images/2013/11/itune1.png)

リンクを開きます。

![itunes noshadow]({{ BASE_PATH }}/assets/images/2013/11/itune2.png)

ソートとかフィルタリングとか検索とかの機能がほしいですねぇ。

---

(追記：2013-11-20) ItunesTrackの説明記事を書きました。

[iTuneの音楽ライブラリにアクセスしてCSV化できる「iTunesTrack」の紹介](http://localhost:4000/2013/11/20/introduce-itunestrack-gem/ "iTuneの音楽ライブラリにアクセスしてCSV化できる「iTunesTrack」の紹介")

---

{{ 'B000JCENFM' | amazon_medium_image }}

{{ 'B000JCENFM' | amazon_link }}




