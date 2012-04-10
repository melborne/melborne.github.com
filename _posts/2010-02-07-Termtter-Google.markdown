---
layout: post
title: TermtterならGoogle検索だってできる
date: 2010-02-07
comments: true
categories:
---

##TermtterならGoogle検索だってできる
Termtterはpluginによる拡張ができる
パッケージには最初からたくさんのpluginが含まれているので
自分の好みに合わせて機能拡張ができるだけでなく
自分でpluginを書くときの参考としても利用できる

Termtter本体のコードは僕には難易度が高いけれども
pluginならなんとかいけそうだ

pluginとして登録できる機能には
コマンドラインから実行させるCommand
Termtterの動作をフックするHook
出力をフィルタするFilter
簡単なCommandを登録するMacro
Commandエイリアスを登録するaliasなどがある

pluginはRubyによるDSLのようになっていて
Termtter::Clientモジュールのregister_commandメソッドや
register_hookメソッドにHashの値を渡すようにして記述できる
{% highlight ruby %}
Termtter::Client.register_command(
  :name => :fib,
  :exec => lambda {|arg|
    n = arg.to_i
    text = "fib(#{n}) = #{fib n}"
    Termtter::API.twitter.update(text)
    puts "=> " << text
  }
)
{% endhighlight %}
http://termtter.org/plugins

###Google検索plugin
Termtterは検索の使い勝手がいいので
ここでGoogleも検索できたらきっと面白い
少し調べるとgoogle-searchというRubyのライブラリがあったので
これを使って作ってみた
使ってくれる人がいたらうれしい
なおuri-open pluginが必要になる

![image](http://img.f.hatena.ne.jp/images/fotolife/k/keyesberry/20100207/20100207230009.png)


使い方はgsearchコマンドに続けてクエリーを打つ
{% highlight ruby %}
> gsearch termtter または gs termtter
{% endhighlight %}

8件の結果が番号付きでリストされるので
{% highlight ruby %}
> 3
{% endhighlight %}
のように番号を指定して開く

次の8件の検索結果を見たいときは
{% highlight ruby %}
> gnext または gn
{% endhighlight %}
とする

.termtter/configで設定を少し変更できる
{% highlight ruby %}
 config.plugins.gsearch.colors = ['red','on_green','underline']  # defaultは ['green']
 config.plugins.gsearch.verbose = false                  # defaultは true
 config.plugins.gsearch.lang = :en                       # defaultは :ja
 config.plugins.gsearch.size = :small                    # defaultは :large
{% endhighlight %}
colorsで検索結果の色を変更できる
verbose=falseでtitleとuriだけの表示になる
langで対象言語を指定できる
size=:smallで表示数が4件になる(:largeは8)

また.termtter/configで
{% highlight ruby %}
 config.plugins.gsearch.site = 'd.hatena.ne.jp/keyesberry'
{% endhighlight %}
のように特定のサイトを指定した場合 -s(または-site) optionが働いて
{% highlight ruby %}
> gs -s ruby または gs -site ruby
{% endhighlight %}
で指定サイト内の検索ができる
自分の過去の投稿を検索するとき重宝する

いくつか問題点があります
-日本語検索ができない
-uriを１つ開くと一覧の番号と開く番号がずれる
-シングルクオートなどが文字化けする
-uri_openのuriバッファを汚す

(追記：2010/2/8) コードのupdateと対応する説明を追加しました
(追記：2010/2/8) サイト指定検索のコードと説明を追加しました

[gist: 297408 - Termtter plugins- GitHub](http://gist.github.com/297408)

##Rubyで素数とフィボナッチを視覚化しよう！　ーGraphAzサンプル
数字のランダムグラフができたなら
次にやることは決まってる
そうみんな大好き
素数とフィボナッチだ

最初のグラフは素数グラフ
1～100の間にある25個の素数を順番に色付けする
![image](http://img.f.hatena.ne.jp/images/fotolife/k/keyesberry/20100207/20100207132156.gif)


次のグラフはフィボナッチグラフ
50番目までのフィボナッチ数を順番に色付けする
![image](http://img.f.hatena.ne.jp/images/fotolife/k/keyesberry/20100207/20100207144522.gif)


 *グラフはクリックすると拡大します

関連記事：
[Rubyでアニメーション・グラフを作ろう！](/2010/02/03/Ruby/)
[Rubyのランダムをグラフ化しよう！](/2010/02/06/Ruby/)

<script src="http://gist.github.com/296691.js"></script>
