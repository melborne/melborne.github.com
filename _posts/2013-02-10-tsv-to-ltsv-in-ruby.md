---
layout: post
title: "私、RubyでならTSVからLTSV作れます！"
description: ""
category: 
tags: 
date: 2013-02-10
published: true
---
{% include JB/setup %}

Labeled Tab-Separated Values（LTSV) という、新しいテキストフォーマットのビッグウェーブが来てるみたいです...

> {% hatebu  http://d.hatena.ne.jp/naoya/20130207/1360240992 【今北産業】3分で分かるLTSV業界のまとめ【LTSV】 - naoyaのはてなダイアリー %}

<br  />


私、少し前に「CSV.table最強！」と言いましたよね...

> {% hatebu http://melborne.github.com/2013/01/24/csv-table-method-is-awesome/ Ruby標準添付ライブラリcsvのCSV.tableメソッドが最強な件について %}

<br  />

ちょっと、なんか恥ずかしい気もするんですよね... 今更CSVとかって...

<br  />

こうなったら、`CSV.table`で私もどうにかLTSVのビッグウェーブに乗れませんかね...


<br  />

そんなわけで...


<br  />

CSV.tableを使ってTSVからLTSVを作る方法を紹介します！

---

次のようなタブ区切りのログフォーマット（TSV）があるとします。先頭行はラベルです。

####access_log.tsv
{% highlight text %}
host<TAB>ident<TAB>user<TAB>time<TAB>req<TAB>status<TAB>size<TAB>referer<TAB>ua
127.0.0.1<TAB>-<TAB>frank<TAB>[10/Oct/2000:13:55:36 -0700]<TAB>GET /apache_pb.gif HTTP/1.0<TAB>200<TAB>2326<TAB>http://www.example.com/start.html<TAB>Mozilla/4.08 [en] (Win98; I ;Nav)
127.0.0.1<TAB>-<TAB>frank<TAB>[10/Oct/2000:13:55:36 -0700]<TAB>GET /apache_pb.gif HTTP/1.0<TAB>200<TAB>2326<TAB>http://www.example.com/start.html<TAB>Mozilla/4.08 [en] (Win98; I ;Nav)
{% endhighlight %}


で、これをCSV.tableに掛けて...

{% highlight ruby %}
require "csv"

tsv = CSV.table('access_log.tsv', col_sep:'<TAB>')
puts tsv.map { |l| l.to_hash.map { |kv| kv.join(":") }.join("<TAB>") }

# >> host:127.0.0.1<TAB>ident:-<TAB>user:frank<TAB>time:[10/Oct/2000:13:55:36 -0700]<TAB>req:GET /apache_pb.gif HTTP/1.0<TAB>status:200<TAB>size:2326<TAB>referer:http://www.example.com/start.html<TAB>ua:Mozilla/4.08 [en] (Win98; I ;Nav)
# >> host:127.0.0.1<TAB>ident:-<TAB>user:frank<TAB>time:[10/Oct/2000:13:55:36 -0700]<TAB>req:GET /apache_pb.gif HTTP/1.0<TAB>status:200<TAB>size:2326<TAB>referer:http://www.example.com/start.html<TAB>ua:Mozilla/4.08 [en] (Win98; I ;Nav)
{% endhighlight %}

どうですか？乗れそうですか？ビッグウェーブに。


一応、カラクリを見てみます...

{% highlight ruby %}
require "csv"

tsv = CSV.table('access_log.tsv', col_sep:'<TAB>')

tsv # => #<CSV::Table mode:col_or_row row_count:3>

row = tsv.first

row # => #<CSV::Row host:"127.0.0.1" ident:"-" user:"frank" time:"[10/Oct/2000:13:55:36 -0700]" req:"GET /apache_pb.gif HTTP/1.0" status:200 size:"2326" referer:"http://www.example.com/start.html" ua:"Mozilla/4.08 [en] (Win98; I ;Nav)">

row.headers # => [:host, :ident, :user, :time, :req, :status, :size, :referer, :ua]
row.fields # => ["127.0.0.1", "-", "frank", "[10/Oct/2000:13:55:36 -0700]", "GET /apache_pb.gif HTTP/1.0", 200, "2326", "http://www.example.com/start.html", "Mozilla/4.08 [en] (Win98; I ;Nav)"]

row.to_hash # => {:host=>"127.0.0.1", :ident=>"-", :user=>"frank", :time=>"[10/Oct/2000:13:55:36 -0700]", :req=>"GET /apache_pb.gif HTTP/1.0", :status=>200, :size=>"2326", :referer=>"http://www.example.com/start.html", :ua=>"Mozilla/4.08 [en] (Win98; I ;Nav)"}
{% endhighlight %}

CSV::Tableの各行はCSV::Rowという行指向のクラスになっていて、これがヘッダー情報も持ってる、って訳ですね。

やっぱり「CSV.table最強！」って、言っていいですか？

あとは、combinedログフォーマットとやらをTSVに変換する正規表現書いてくれる人、待つだけです...


---

(追記：2013-02-15) 関連記事を書きました。

[RubyでアクセスログのようなものをLTSVに変換する]({{ site.url }}/2013/02/15/xcombined-access-log-to-ltsv-in-ruby/ 'RubyでアクセスログのようなものをLTSVに変換する')

