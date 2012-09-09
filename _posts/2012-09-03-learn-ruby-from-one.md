---
layout: post
title: "１から始めるRuby (スライド版)"
description: ""
category: 
tags: [showoff]
date: 2012-09-03
published: true
---
{% include JB/setup %}

[ShowOff](https://github.com/schacon/showoff#readme 'schacon/showoff')というRuby製のプレゼンソフトがあります。ShowOffではプレゼンスライドをmarkdownで書いて、[Sinatra](http://www.sinatrarb.com/ 'Sinatra')アプリとして簡単に実行できます。Sinatraですから当然、[Heroku](http://www.heroku.com/ 'Heroku')にも簡単にデプロイできます。

## スライド版

プレゼンには全く縁はありませんが、スライド作りが面白そうだったので、１つ作ってHerokuにデプロイしてみました。ネタは１年くらい前にブログで書いた[「1から始めるRuby」](http://melborne.github.com/2011/07/27/1-Ruby/ '1から始めるRuby')です。

[「１から始めるRuby」 on Heroku](http://learn-ruby-from-one.herokuapp.com/)

見てくれる人がいたらうれしいですが、現状では`Safari`でしかスライドのコントロールがうまくできません。僕の環境(OSX Snow Leopard)の`Chrome`および`Firefox`ではコントロールが効きません（但し、ページを開いた後ブラウザの戻るを押すことで自動再生はできます）。解決策ご存知の方おられましたら助けてくださいm(__)m

## PDF版

またShowOff`では[wkhtmltopdf](http://code.google.com/p/wkhtmltopdf/ 'wkhtmltopdf')を使ったPDF変換も簡単にできるので{% fn_ref 1 %}、ついでに「１から始めるRuby (PDF版)」も作って[Speaker Deck](https://speakerdeck.com/ 'Speaker Deck')にアップしてみました。スライド版がうまく再生できない方は、こちらをどうぞ！

<script async class="speakerdeck-embed" data-id="50432e8fd956d50002024bc2" data-ratio="1.2945638432364097" src="//speakerdeck.com/assets/embed.js"></script>


github repo: [melborne/learn-ruby-from-one](https://github.com/melborne/learn-ruby-from-one 'melborne/learn-ruby-from-one')


関連記事：[1から始めるRuby](http://melborne.github.com/2011/07/27/1-Ruby/ '1から始めるRuby')


----

{{ 4894713284 | amazon_medium_image }}
{{ 4894713284 | amazon_link }} by {{ 4894713284 | amazon_authors }}

{% footnotes %}
  {% fn http://presen-url/pdfにアクセスするだけ! %}
{% endfootnotes %}
