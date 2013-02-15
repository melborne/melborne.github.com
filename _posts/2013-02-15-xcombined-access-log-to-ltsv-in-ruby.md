---
layout: post
title: "RubyでアクセスログのようなものをLTSVに変換する"
description: ""
category: 
tags: 
date: 2013-02-15
published: true
---
{% include JB/setup %}


Rubyでアクセスログからいま話題の[LTSV（Labeled Tab-separated Values）](http://ltsv.org/ 'Labeled Tab-separated Values (LTSV)')を生成しようと考えました。ところが自分はアクセスログを扱った経験がなくそのフォーマットをよく知らないという事実に気付いたのでした（遅い）。一方で、仕様書を読むモチベーションもなく、仕方がないのでアクセスログというものの基礎仕様を以下のように仮定してみることにしました。

    1. １エントリ内の各情報はスペース区切りされている。
    2. [ ]または" "で囲まれた情報を含むことができ、その間ではスペースが許容される。

それで、この仕様に基いたアクセスログ（のようなもの）をLTSVフォーマットに変換するために、次の手順を考えました。

    1. スペース区切りをタブ区切り（TSV）のアクセスログに変換する。
      1-1. [ ]または" "で囲まれた情報内におけるスペースを一旦特殊シンボルに変換する。
      1-2. スペースをタブに変換する。
      1-3. 特殊シンボルをスペースに戻す。
    2. タブ区切りアクセスログをLTSVに変換する。

## サンプルアクセスログ
アクセスログのサンプルとして、ここでは以下のものを使います。

####access_log
{% highlight text %}
80.101.90.180 - - [02/Jun/2009:15:11:51 -0400] "GET /network/email/clients/outlook/using-scanost-repairs.php HTTP/1.1" 200 4898
80.101.90.180 - - [02/Jun/2009:15:11:52 -0400] "GET /images/mplogo-white.jpg HTTP/1.1" 200 9350
80.101.90.180 - - [02/Jun/2009:15:11:52 -0400] "GET /css/style.css HTTP/1.1" 200 2816
127.0.0.1 - frank [10/Oct/2000:13:55:36 -0700] "GET /apache_pb.gif HTTP/1.0" 200 2326 "http://www.example.com/start.html" "Mozilla/4.08 [en] (Win98; I ;Nav)"
10.2.3.4 - - [18/Apr/2005:00:10:47 +0900] "GET / HTTP/1.1" 200 854 "-" "Mozilla/4.0 (compatible; MSIE 5.5; Windows 98)"
10.2.3.4 - - [18/Apr/2005:00:10:47 +0900] "GET /style.css HTTP/1.1" 200 102 "http://www.geekpage.jp/" "Mozilla/4.0 (compatible; MSIE 5.5; Windows 98)"
10.2.3.4 - - [18/Apr/2005:00:10:47 +0900] "GET /img/title.png HTTP/1.1" 304 - "http://www.geekpage.jp/" "Mozilla/4.0 (compatible; MSIE 5.5; Windows 98)"
{% endhighlight %}

## TSVへの変換
上記方針に従って、スペース区切りをタブ区切りへ変換するメソッドを書いてみます。

{% highlight ruby %}
def to_tsv(log)
  combined_re = /\[.*?\]|".*?"/
  irregular = "<__IRREGULAR__>"
  log.gsub(combined_re) { |m| m.gsub(" ", irregular) }
     .tr(" ", "\t" ).gsub(irregular, " ")
end
{% endhighlight %}
最初の`gsub`で\[ \]または" "で囲まれた情報をブロックに取り込み、次の`gsub`でその内部のスペースを特殊シンボル`<__IRREGULAR__>`に置換します。次に`tr`で残っているすべてのスペースをタブに変換します。最後に`gsub`で特殊シンボルをスペースに戻します。

これを上記アクセスログに適用してみます。

{% highlight ruby %}
log = File.read('access_log')

to_tsv(log) # => "80.101.90.180\t-\t-\t[02/Jun/2009:15:11:51 -0400]\t\"GET /network/email/clients/outlook/using-scanost-repairs.php HTTP/1.1\"\t200\t4898\n80.101.90.180\t-\t-\t[02/Jun/2009:15:11:52 -0400]\t\"GET /images/mplogo-white.jpg HTTP/1.1\"\t200\t9350\n80.101.90.180\t-\t-\t[02/Jun/2009:15:11:52 -0400]\t\"GET /css/style.css HTTP/1.1\"\t200\t2816\n127.0.0.1\t-\tfrank\t[10/Oct/2000:13:55:36 -0700]\t\"GET /apache_pb.gif HTTP/1.0\"\t200\t2326\t\"http://www.example.com/start.html\"\t\"Mozilla/4.08 [en] (Win98; I ;Nav)\"\n10.2.3.4\t-\t-\t[18/Apr/2005:00:10:47 +0900]\t\"GET / HTTP/1.1\"\t200\t854\t\"-\"\t\"Mozilla/4.0 (compatible; MSIE 5.5; Windows 98)\"\n10.2.3.4\t-\t-\t[18/Apr/2005:00:10:47 +0900]\t\"GET /style.css HTTP/1.1\"\t200\t102\t\"http://www.geekpage.jp/\"\t\"Mozilla/4.0 (compatible; MSIE 5.5; Windows 98)\"\n10.2.3.4\t-\t-\t[18/Apr/2005:00:10:47 +0900]\t\"GET /img/title.png HTTP/1.1\"\t304\t-\t\"http://www.geekpage.jp/\"\t\"Mozilla/4.0 (compatible; MSIE 5.5; Windows 98)\""
{% endhighlight %}

よさそうです。

## TSVへの変換
次に、TSVからLTSVへの変換をするメソッドを書きます。ここでは標準添付ライブラリ`csv`を使います。

{% highlight ruby %}
require "csv"

LABELS = %w(host ident user time req status size referer ua)

def to_ltsv(tsv)
  label = LABELS * "\t" + "\n"
  tsv = CSV.new( label + tsv, col_sep:"\t",
                              headers:true,
                              converters: :numeric,
                              header_converters: :symbol )

  tsv.map { |l| l.to_hash.map { |kv| kv * ":" } * "\t" } * "\n"
end
{% endhighlight %}
ヘッダーラベルLABELSを用意しこれをTSVデータの先頭に結合し、csvライブラリに掛けます。このコードの説明は次の記事に書いています。なお、何回も登場する`*`はArray#joinと等価です。

> {% hatebu http://melborne.github.com/2013/02/10/tsv-to-ltsv-in-ruby/ '私、RubyでならTSVからLTSV作れます！' %}

上で生成したTSVに適用してみます。

{% highlight ruby %}
log = File.read('access_log')
tsv = to_tsv(log)

ltsv = to_ltsv(tsv) # => "host:80.101.90.180\tident:-\tuser:-\ttime:[02/Jun/2009:15:11:51 -0400]\treq:GET /network/email/clients/outlook/using-scanost-repairs.php HTTP/1.1\tstatus:200\tsize:4898\treferer:\tua:\nhost:80.101.90.180\tident:-\tuser:-\ttime:[02/Jun/2009:15:11:52 -0400]\treq:GET /images/mplogo-white.jpg HTTP/1.1\tstatus:200\tsize:9350\treferer:\tua:\nhost:80.101.90.180\tident:-\tuser:-\ttime:[02/Jun/2009:15:11:52 -0400]\treq:GET /css/style.css HTTP/1.1\tstatus:200\tsize:2816\treferer:\tua:\nhost:127.0.0.1\tident:-\tuser:frank\ttime:[10/Oct/2000:13:55:36 -0700]\treq:GET /apache_pb.gif HTTP/1.0\tstatus:200\tsize:2326\treferer:http://www.example.com/start.html\tua:Mozilla/4.08 [en] (Win98; I ;Nav)\nhost:10.2.3.4\tident:-\tuser:-\ttime:[18/Apr/2005:00:10:47 +0900]\treq:GET / HTTP/1.1\tstatus:200\tsize:854\treferer:-\tua:Mozilla/4.0 (compatible; MSIE 5.5; Windows 98)\nhost:10.2.3.4\tident:-\tuser:-\ttime:[18/Apr/2005:00:10:47 +0900]\treq:GET /style.css HTTP/1.1\tstatus:200\tsize:102\treferer:http://www.geekpage.jp/\tua:Mozilla/4.0 (compatible; MSIE 5.5; Windows 98)\nhost:10.2.3.4\tident:-\tuser:-\ttime:[18/Apr/2005:00:10:47 +0900]\treq:GET /img/title.png HTTP/1.1\tstatus:304\tsize:-\treferer:http://www.geekpage.jp/\tua:Mozilla/4.0 (compatible; MSIE 5.5; Windows 98)"
{% endhighlight %}

上手くいっているようですね。

上記コードをクラス化したものを貼っておきます。


{% gist 4960036 %}

で、ここまで書いてアレなんですが、Dankogai氏のPerl版（[combined2ltsv.pl](http://colabv6.dan.co.jp/ltsv/combined2ltsv.pl 'colabv6.dan.co.jp/ltsv/combined2ltsv.pl')）を見る限り、アクセスログの変換にはもっと複雑な処理が必要そうなので（Perlが読みきれない（泣））、やっぱりこのコードの実用性はなさそうです...

> [404 Blog Not Found:perl - Apache Combined Log を LTSV に](http://blog.livedoor.jp/dankogai/archives/51853024.html '404 Blog Not Found:perl - Apache Combined Log を LTSV に')


Melborne the Man who lack knowledge of AccessLog


