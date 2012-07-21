---
layout: post
title: Rubyで英文小説をWordleしようよ
date: 2011-12-12
comments: true
categories:
tags: [ruby, wordle, Visualization]
---

Wordleって知ってる？Wordleはテキスト中の単語をグラフィカルに配置して表示するツール／サービスだよ。

[Wordle - Beautiful Word Clouds](http://www.wordle.net/)

例えばProject Gutenbergから「[Alice's Adventures In Wonderland](http://www.gutenberg.org/cache/epub/11/pg11.txt)」を取ってきて、Createページのテキストボックスにこれを貼りつければこんなものができるんだよ。

![image](http://img.f.hatena.ne.jp/images/fotolife/k/keyesberry/20111212/20111212175942.png)


すばらしいよね！

Wordleではテキスト中の単語の出現頻度に応じて文字の大きさを調整してるよ。加えてRandomizeボタンを押したり、FontやLayoutやColorを変えたりすることで、全く違ったイメージのWordleが作れるよ。

Wordleのアルゴリズムについては「Beautiful Visualization」という、データビジュアライゼーションの本に解説があるよ。

{{ '4873115043' | amazon_medium_image }}

{{ '4873115043' | amazon_link }} by {{ '4873115043' | amazon_authors }}

Wordleはすばらしいんだけど一点だけ不満があるよ。それは、その単語の大きさがそのテキストの特徴を必ずしもうまく表していないことだよ。つまりWordleではストップワードの除去があまりうまくいっていないんだよ。ちなみにストップワードはその言語で一般的に使われる語、例えばthe a forとかの非特徴的な単語のことだよ。先の結果を見ると余り特徴的でない単語が並んでることがわかるよね。

で、以前にこのブログのチュートリアルで作ったWordDictionaryクラスを思い出したんだよ。

[Rubyチュートリアル ～英文小説の最頻出ワードを見つけよう!(最終回)]({{ site.url }}/2009/04/23/Ruby/)

WordDictionaryクラスでは、他のテキストからなるベース辞書との比較で対象テキストの特徴語を抽出できるんだったよ。試しにちょっと固めの小説をベースとしてアリスの特徴語を抽出してみるよ。

{% highlight ruby %}
require_relative "word_dictionary"
alice = "alices_adventures_in_wonderland.txt"
bases = %w(english_literature.txt analyze_people_on_sight.txt)
alice_wd = WordDictionary.new(alice)
base_wd = bases.map { |base| WordDictionary.new(base, base) }.inject(:+)
p alice_wd.uniq_words(40, base_wd)
# >> [["alice", 403], ["turtle", 59], ["hatter", 56], ["mock", 56], ["gryphon", 55], ["rabbit", 51], ["mouse", 44], ["ve", 44], ["duchess", 42], ["tone", 40], ["dormouse", 40], ["cat", 37], ["march", 35], ["hare", 31], ["white", 30], ["replied", 29], ["caterpillar", 28], ["jury", 22], ["cried", 20], ["sort", 20], ["tea", 19], ["soup", 18], ["spoke", 17], ["sat", 17], ["talking", 17], ["garden", 16], ["hastily", 16], ["arm", 15], ["mad", 15], ["suppose", 14], ["didn", 14], ["anxiously", 14], ["dinah", 14], ["baby", 14], ["footman", 14], ["yes", 13], ["dodo", 13], ["cats", 13], ["wouldn", 13], ["dance", 13]]
{% endhighlight %}
なんかそれっぽい単語が抽出されたね。

うれしいことにWordleのサイトでは単語とその重み付けのリストを渡して、Wordleを作ることもできるんだよ(Advancedページ)。早々WordDictinaryで抽出したAliceの特徴語を使ってWordleを作ってみたよ。

Alices Adventures In Wonderland (40 words)

![image](http://img.f.hatena.ne.jp/images/fotolife/k/keyesberry/20111212/20111212175943.png)

Alices Adventures In Wonderland (100 words)

![image](http://img.f.hatena.ne.jp/images/fotolife/k/keyesberry/20111212/20111212175949.png)


なんかいい感じだよね！

他の小説でも試してみるよ。

Pride And Prejudice

![image](http://img.f.hatena.ne.jp/images/fotolife/k/keyesberry/20111212/20111212175944.png)


The Adventures Of Sherlock Holmes

![image](http://img.f.hatena.ne.jp/images/fotolife/k/keyesberry/20111212/20111212175945.png)


Frankenstein

![image](http://img.f.hatena.ne.jp/images/fotolife/k/keyesberry/20111212/20111212175946.png)


Hamlet

![image](http://img.f.hatena.ne.jp/images/fotolife/k/keyesberry/20111212/20111212175947.png)


Peter Pan

![image](http://img.f.hatena.ne.jp/images/fotolife/k/keyesberry/20111212/20111212175948.png)


Wordleは楽しいから是非とも試してみて！僕が作ったWordleは次のURLで見れるよ。

[Wordle - Gallery: merborne](http://www.wordle.net/gallery?username=merborne)

<script src="https://gist.github.com/1454681.js"> </script>
