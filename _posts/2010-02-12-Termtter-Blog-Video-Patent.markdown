---
layout: post
title: TermtterならBlogだってVideoだってPatentだって
date: 2010-02-12
comments: true
categories:
---


gsearch pluginを改良して以下のGoogle検索に対応させました
-Google Web Search
-Google Blog Search
-Google Book Search
-Google Image Search
-Google Video Search
-Google News Search
-Google Patent Search
<del datetime="2010-02-15T09:22:46+09:00">なお日本語検索ができないという致命的な問題があります</del>
(追記：2009/2/15)日本語検索に対応しました
###使い方
###*Google Web Search
Web検索は以下のようにする
{% highlight ruby %}
> google_web ruby または google ruby または gs ruby
{% endhighlight %}
![image](http://img.f.hatena.ne.jp/images/fotolife/k/keyesberry/20100212/20100212095148.png)


起動optionとして l(lang) v(verbose) p(page_size)があって
{% highlight ruby %}
> gs -l en -v true -p small ruby
{% endhighlight %}
とすると結果は以下のようになる
![image](http://img.f.hatena.ne.jp/images/fotolife/k/keyesberry/20100212/20100212095138.png)


site指定もできる
{% highlight ruby %}
> gs termtter site:d.hatena.ne.jp/keyesberry
{% endhighlight %}
![image](http://img.f.hatena.ne.jp/images/fotolife/k/keyesberry/20100212/20100212095139.png)


.termtter/configでsiteのdefault値を予め以下のようにしておけば
{% highlight ruby %}
 config.plugins.google.site = 'd.hatena.ne.jp/keyesberry'
{% endhighlight %}
 --siteオプションが使える  
{% highlight ruby %}
> gs termtter --site
{% endhighlight %}
もちろんTermtterのaliasを使ってサイト指定してもいい
{% highlight ruby %}
 config.plugins.alias.aliases = {
    :amazon => 'gs site:www.amazon.co.jp',
    :wiki      => 'gs site:ja.wikipedia.org'
 }
{% endhighlight %}
こうしておけばAmazonコマンドでAmazonの書籍検索が
wikiコマンドでwikipediaの検索ができるようになる

結果のリストはuri-open pluginで開くことができるが
以下に添付のdefault_replace pluginを使えば
{% highlight ruby %}
> 3
{% endhighlight %}
と番号を指定して開いたり
{% highlight ruby %}
> some 5
{% endhighlight %}
として0～4を一度に開くことができる
###*Google Blog Search
Blog検索は以下のようにする
{% highlight ruby %}
> google_blog google buzz または gb google buzz
{% endhighlight %}
![image](http://img.f.hatena.ne.jp/images/fotolife/k/keyesberry/20100212/20100212095147.png)


起動optionはWebと同じ
{% highlight ruby %}
> gb -l ch -v true -p small google buzz
{% endhighlight %}
###*Google Book Search
Book検索は以下のようにする
{% highlight ruby %}
> google_book ruby または gbk ruby
{% endhighlight %}
![image](http://img.f.hatena.ne.jp/images/fotolife/k/keyesberry/20100212/20100212095141.png)


起動optionは lとp
{% highlight ruby %}
> gbk -l en -p small ruby
{% endhighlight %}
![image](http://img.f.hatena.ne.jp/images/fotolife/k/keyesberry/20100212/20100212095142.png)


###*Google Image Search
Image検索は以下のようにする
{% highlight ruby %}
> google_image flower または gi flower
{% endhighlight %}
![image](http://img.f.hatena.ne.jp/images/fotolife/k/keyesberry/20100212/20100212095146.png)


起動optionは -lvpに加えて c(color) t(image_type) f(file_type) s(image_size)がある
{% highlight ruby %}
> gi flower -c blue -t clipart -f gif -s large
{% endhighlight %}
![image](http://img.f.hatena.ne.jp/images/fotolife/k/keyesberry/20100212/20100212095144.png)


選択肢は以下のとおり
{% highlight ruby %}
  # :image_size = :icon, :small, :medium, :large, :xlarge, :xxlarge, :huge
  # :image_type = :face, :photo, :clipart, :lineart
  # :file_type = :jpg, :png, :gif, :bmp
{% endhighlight %}
###*Google Video Search
Video検索は以下のようにする
{% highlight ruby %}
> google_video rubyconf または gv rubyconf
{% endhighlight %}
![image](http://img.f.hatena.ne.jp/images/fotolife/k/keyesberry/20100212/20100212102205.png)


起動optionは -lvp
###*Google News Search
News検索は以下のようにする
{% highlight ruby %}
> google_news google buzz または gn google buzz
{% endhighlight %}
![image](http://img.f.hatena.ne.jp/images/fotolife/k/keyesberry/20100212/20100212095140.png)


起動optionは -vpに加えて e(edition) t(topic) r(relative_to)がある
{% highlight ruby %}
> gn -e us -t entertainment -r NY people
{% endhighlight %}
![image](http://img.f.hatena.ne.jp/images/fotolife/k/keyesberry/20100212/20100212095143.png)


選択肢は以下のとおり
{% highlight ruby %}
  # :news_edition = ex. :jp, :us, :uk, :fr_ca..
  # :news_topic = :headlines, :world, :business, :nation, :science,
  #               :elections, :politics, :entertainment, :sports, :health
  # :news_relative_to = ex. city, state, province, zipcode..
{% endhighlight %}
###*Google Patent Search
Patent検索は以下のようにする
{% highlight ruby %}
> google_patent programmig multithread または gp programmig multithread
{% endhighlight %}
![image](http://img.f.hatena.ne.jp/images/fotolife/k/keyesberry/20100212/20100212095145.png)


起動optionは -vpに加えて i(issued_only)がある
{% highlight ruby %}
> gp multithread -i true
{% endhighlight %}
###*設定
検索のdefault設定は以下のようになっている
{% highlight ruby %}
  :verbose            => false
  :colors             => ['green']
  :lang               => :ja
  :page_size          => :large
  :news_edition       => :jp
  :news_topic         => :headlines
  :patent_issued_only => false
{% endhighlight %}

これらdefault値は.termtter/configで変更できる
{% highlight ruby %}
 config.plugins.google.verbose = true
 config.plugins.google.colors = ['red', 'on_blue', 'underline']
 config.plugins.google.lang = :en
        :
        :
{% endhighlight %}
![image](http://img.f.hatena.ne.jp/images/fotolife/k/keyesberry/20100212/20100212095149.png)


コードはすべてTermtter licenseに準拠します

(追記：2010/2/21)aliasについての記述を追加しました

[gist: 297408 - Termtter plugins- GitHub](http://gist.github.com/297408)