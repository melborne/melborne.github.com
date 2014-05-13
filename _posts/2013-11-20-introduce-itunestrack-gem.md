---
layout: post
title: "iTuneの音楽ライブラリにアクセスしてCSV化できる「iTunesTrack」の紹介"
description: ""
category: 
tags: 
date: 2013-11-20
published: true
---
{% include JB/setup %}


前の記事では`iTunesTrack`を使ってiTunesから音楽データを抽出しWebアプリ化する手順を説明しました。

> [iTunes.appの音楽ライブラリを最速でWebアプリにするたった３つのステップ]({{ BASE_PATH }}/2013/11/19/build-a-database-for-itunes-music-data/ "iTunes.appの音楽ライブラリを最速でWebアプリにするたった３つのステップ")

ここでは`iTunesTrack`の詳細を説明します。対象バージョンは0.0.1です。

> [itunes_track \| RubyGems.org \| your community gem host](https://rubygems.org/gems/itunes_track "itunes_track \| RubyGems.org \| your community gem host")
> 
> [melborne/itunes_track](https://github.com/melborne/itunes_track "melborne/itunes_track")


## ターミナルでの使い方

`gem install itunes_track`でインストールすると、`itunes_track`ターミナルコマンドが使えるようになります。サブコマンドを渡さなければそのヘルプが表示されます。

{% highlight bash %}
% itunes_track
Commands:
  itunes_track csv PATH        # Create CSV file from tracks data
  itunes_track help [COMMAND]  # Describe available commands or one specific command
  itunes_track size [ARTIST]   # Show track size for ARTIST match
  itunes_track tracks          # Show tracks
  itunes_track version         # Show ItunesTrack version
{% endhighlight %}

`size`サブコマンドは、引数で渡したARTISTにマッチするトラックの数を返します。引数を省略すると全楽曲数が返ります。

{% highlight bash %}
% itunes_track size sixpence
47
% itunes_track size
1091
{% endhighlight %}

`tracks`サブコマンドは楽曲一覧を表示するもので、`--artist`と`--album`というオプションを取れます。

{% highlight bash %}
% itunes_track help tracks
Usage:
  itunes_track tracks

Options:
  -a, [--artist=ARTIST]
  -l, [--album=ALBUM]

Show tracks
{% endhighlight %}

    % itunes_track tracks -a sixpence -l 'Best Of'
     Kiss Me 3:29 Sixpence None The Richer The Best Of Sixpence None The Richer 36
     Loser Like Me 3:33 Sixpence None The Richer The Best Of Sixpence None The Richer 53
     Need To Be Next To You 4:07 Sixpence None The Richer The Best Of Sixpence None The Richer 51
     Breathe 4:05 Sixpence None The Richer The Best Of Sixpence None The Richer 53
     Dancing Queen 4:02 Sixpence None The Richer The Best Of Sixpence None The Richer 46
     Melody Of You 4:50 Sixpence None The Richer The Best Of Sixpence None The Richer 42
     I Can't Catch You 4:12 Sixpence None The Richer The Best Of Sixpence None The Richer 38
     I Just Wasn't Made For These Times 3:02 Sixpence None The Richer The Best Of Sixpence None The Richer 57
     There She Goes 2:43 Sixpence None The Richer The Best Of Sixpence None The Richer 44
     Don't Dream It's Over 4:02 Sixpence None The Richer The Best Of Sixpence None The Richer 45
     I Need Love 4:12 Sixpence None The Richer The Best Of Sixpence None The Richer 54
     Breathe Your Name 3:56 Sixpence None The Richer The Best Of Sixpence None The Richer 37
     Us 4:22 Sixpence None The Richer The Best Of Sixpence None The Richer 42
     The Ground You Shook 4:18 Sixpence None The Richer The Best Of Sixpence None The Richer 42
     Too Far Gone 6:37 Sixpence None The Richer The Best Of Sixpence None The Richer 45
     Waiting On The Sun 2:52 Sixpence None The Richer The Best Of Sixpence None The Richer 46
     Brighten My Heart 4:38 Sixpence None The Richer The Best Of Sixpence None The Richer 44
     Trust 3:21 Sixpence None The Richer The Best Of Sixpence None The Richer 44

現状、カラー化できていないので非常に見づらいものとなっています^ ^;

`csv`サブコマンドは、抽出したトラックデータをCSVファイルに保存するためのコマンドです。対象フィールドを指定する`--fields`とアーティストを特定する`--artist`オプションがあります。

{% highlight bash %}
% itunes_track help csv
Usage:
  itunes_track csv PATH

Options:
  -f, [--fields=FIELDS]
                         # Default: name,time,artist,album,genre,rating,played_count,year,composer,track_count,track_number,disc_count,disc_number,lyrics
  -a, [--artist=ARTIST]

Create CSV file from tracks data
{% endhighlight %}

次のように使います。

{% highlight bash %}
% itunes_track csv sixpence.csv -a sixpence -f name,artist,album,year
I am working on csv...
CSV file successfully created at sixpence.csv.
{% endhighlight %}

以下のようなファイルが出来上がります。

    name,artist,album,year
    Kiss Me,Sixpence None The Richer,The Best Of Sixpence None The Richer,1999
    Loser Like Me,Sixpence None The Richer,The Best Of Sixpence None The Richer,2004
    Need To Be Next To You,Sixpence None The Richer,The Best Of Sixpence None The Richer,2004
    Breathe,Sixpence None The Richer,The Best Of Sixpence None The Richer,2004
    Dancing Queen,Sixpence None The Richer,The Best Of Sixpence None The Richer,2004
    Melody Of You,Sixpence None The Richer,The Best Of Sixpence None The Richer,2004
    I Can't Catch You,Sixpence None The Richer,The Best Of Sixpence None The Richer,2004
    I Just Wasn't Made For These Times,Sixpence None The Richer,The Best Of Sixpence None The Richer,2004
    There She Goes,Sixpence None The Richer,The Best Of Sixpence None The Richer,1997
    Don't Dream It's Over,Sixpence None The Richer,The Best Of Sixpence None The Richer,2002
    I Need Love,Sixpence None The Richer,The Best Of Sixpence None The Richer,2004
    Breathe Your Name,Sixpence None The Richer,The Best Of Sixpence None The Richer,2002
    Us,Sixpence None The Richer,The Best Of Sixpence None The Richer,2004
    The Ground You Shook,Sixpence None The Richer,The Best Of Sixpence None The Richer,2004
    Too Far Gone,Sixpence None The Richer,The Best Of Sixpence None The Richer,2004
    Waiting On The Sun,Sixpence None The Richer,The Best Of Sixpence None The Richer,2004
    Brighten My Heart,Sixpence None The Richer,The Best Of Sixpence None The Richer,2004
    Trust,Sixpence None The Richer,The Best Of Sixpence None The Richer,2004
     .
     .
     .

## Rubyスクリプトでの使い方

ItunesTrackクラスは次のようなクラスメソッドを持っています。

{% highlight ruby %}
% irb -ritunes_track
IRB on Ruby2.0.0
>> ItunesTrack.methods(false) #=> [:build, :full_build, :tracks, :itunes, :itunes_tracks, :size, :track_properties, :to_csv]
>>
{% endhighlight %}

`.size`メソッドは楽曲数を返しますが、条件を指定したブロックを取ることができます。

{% highlight ruby %}
>> ItunesTrack.size {|t| t.genre.get.match /jazz/i } #=> 66
>> ItunesTrack.size {|t| t.name.get.match /hello/i } #=> 3
{% endhighlight %}

`rb-appscript`の仕様上、メソッドの最後で`get`する必要があります（イケてない）。

`.build`メソッドは対象のタグ（フィールド）を指定して、ブロックで渡した条件のトラックのリストを生成し`tracks`変数に格納します。

{% highlight ruby %}
>> ItunesTrack.build(:name, :time, :artist) { |t| t.artist.get == 'Adele' }

=> [#<ItunesTrack::Track name="Daydreamer", time="3:40", artist="Adele">, #<ItunesTrack::Track name="Best For Last", time="4:18", artist="Adele">, #<ItunesTrack::Track name="Chasing Pavements", time="3:30", artist="Adele">, #<ItunesTrack::Track name="Cold Shoulder", time="3:11", artist="Adele">, #<ItunesTrack::Track name="Crazy For You", time="3:28", artist="Adele">, #<ItunesTrack::Track name="Melt My Heart To Stone", time="3:23", artist="Adele">, #<ItunesTrack::Track name="First Love", time="3:10", artist="Adele">, #<ItunesTrack::Track name="Right As Rain", time="3:17", artist="Adele">, ... ]
{% endhighlight %}

引数を省略した場合、name, time, artist, album, genre, rating, played_count, year, composer, track_count, track_number, disc_count, disc_number, lyricsを対象にリストを生成します。`rb-appscript`でアクセス可能なすべてのタグを取得したい場合は`build`に代えて`full_build`メソッドを使います。楽曲数が多い場合、生成に時間がかかることを覚悟します。

`.to_csv`メソッドはbuildしたデータをcsvファイルに保存します。第２引数でCSV化するフィールドを更に限定することもできます。

{% highlight ruby %}
ItunesTrack.to_csv('adele.csv', [:name, :album, :time])
{% endhighlight %}


大体以上です。


---

<p style='color:red'>=== Ruby関連電子書籍100円で好評発売中！ ===</p>

[M'ELBORNE BOOKS]({{ BASE_PATH }}/books/ "M'ELBORNE BOOKS")

<a href="{{ BASE_PATH }}/books/">
  <img src="/assets/images/2013/02/ruby_object_cover.png" alt="ruby_object" style="width:200px" />
</a>
<a href="{{ BASE_PATH }}/books/">
  <img src="/assets/images/2013/04/ruby_tutorial_cover.png" alt="ruby_tutorial" style="width:200px" />
</a>
<a href="{{ BASE_PATH }}/books/">
  <img src="/assets/images/2013/03/ruby_trivia_cover.png" alt="ruby_trivia" style="width:200px" />
</a>

