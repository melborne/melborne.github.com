---
layout: post
title: "GitHubで使える絵文字Emojiが何か分からないとき😖（Mac向け）"
description: ""
category: 
tags: 
date: 2014-05-19
published: true
---
{% include JB/setup %}

またEmojiネタで恐縮ですが😓、`emot`というMacのターミナル💻で絵文字を表示するためのGem💎を作りましたので紹介します😃

> [emot \| RubyGems.org \| your community gem host](https://rubygems.org/gems/emot "emot")
> 
> [melborne/emot](https://github.com/melborne/emot "melborne/emot")

Web⛅️にある「[Emoji cheat sheet for Campfire and GitHub](http://www.emoji-cheat-sheet.com/ "Emoji cheat sheet for Campfire and GitHub")」のMacターミナル版ですね。

Rubyで絵文字を扱うツールには既にGitHub🐙🐱社の「[gemoji](https://github.com/github/gemoji "github/gemoji")」というのがあるのですが、これは絵文字imageを含んでいて軽量でなく、とりあえずMacで使えればいいという自分の需要には合わず、またjugyo👶さんによるMacでの使用を前提にした軽量な「[named_emoji](https://github.com/jugyo/named_emoji "jugyo/named_emoji")」というのがありましたが対応絵文字が少し少なくまたunicodeも表示したかったので、別途作ることにしました。

絵文字とその名前の対応表は、gemojiの`Emoji#mapping`というメソッドの出力を加工して作りました。
   
## EmotをMacターミナルで使う

`gem install emot`でインストールすると、`emot`というコマンドが使えるようになります。サブコマンドを渡さなければhelpが表示されます。

    % emot                
    Commands:
      emot help [COMMAND]  # Describe available commands or one specific command
      emot icons           # show all emoji icons
      emot names           # show all available names for emoji
      emot show [NAME]     # show emoji icon and unicode for NAME

`emot show`とすると870個の絵文字がその名前とunicodeとともに、ずらっと表示されます。

![emot noshadow]({{ BASE_PATH }}/assets/images/2014/05/emot01.png)

これをインラインで表示したい場合は、--inlineオプションを渡して、`emot show -i`とします。

![emot noshadow]({{ BASE_PATH }}/assets/images/2014/05/emot02.png)

アイコンだけで表示したい場合は、--onlyオプションに`icon`を渡して、`emot show -o=icon -i`などとするか、`emot icons`とします。

![emot noshadow]({{ BASE_PATH }}/assets/images/2014/05/emot03.png)

アイコン＋名前、アイコン＋unicodeで表示したい場合は、--onlyオプションに`name`または`code`を渡します。また、名前だけをずらっと表示したいときは`nameonly`をオプションで渡すか、`emot names`します。

まだカテゴリ別表示などに対応していないので使いづらいです👎 🙅 🙇 

## EmotをRubyで使う

Rubyでは次のような感じで使います。

{% highlight ruby %}
require 'emot'

Emot.icon(:sunflower) # => 🌻

Emot.unicode(:sunflower) # => "U+1F33B"

Emot.list # list available emoji with name and unicode.
{% endhighlight %}

## Symbol#~

`emot`は余計な機能💩として、Symbolクラスに`~`メソッドを勝手に差し込みます😱。その結果、次のような感じで絵文字を含んだ文を簡単に作れるようになります。

{% highlight ruby %}
require "emot"

puts ~:smile
puts ~:beginner
puts ~:shit
puts ~:jack_o_lantern
puts ~:'+1'
puts ~:"I broken_heart you!"
puts ~:"The pencil is mightier than gun"
puts ~:"dango is better than sunflower"
puts ~:"疲れたら beer を飲もう！"
puts ~:"fish + hocho => sushi"
puts ~:".fush + .hocho => sushi" # escape emoji with prefix dot.

# >> 😄
# >> 🔰
# >> 💩
# >> 🎃
# >> 👍
# >> I 💔 you!
# >> The 📝 is mightier than 🔫
# >> 🍡 is better than 🌻
# >> 疲れたら 🍺 を飲もう！
# >> 🐟 + 🔪 => 🍣
# >> fush + hocho => 🍣
{% endhighlight %}

絵文字をエスケープしたいときは、最後の例のように.（ピリオド）を前置します。

これは前回のネタがスベった🏄 ので、無理やりGemにぶち込みました👈 

> [オレは遂にRubyのチルダの究極の使い方に辿り着いたのだ！]({{ BASE_PATH }}/2014/05/16/emoji-be-easy/ "オレは遂にRubyのチルダの究極の使い方に辿り着いたのだ！")

## let_if_fallのアップデート

当然の流れとして、あのターミナルから物がありのままに降ってくる「[let_it_fall](https://rubygems.org/gems/let_it_fall "let_it_fall")」を`emot`を使った版にアップデートしましたので、お知らせします。バージョンは0.3.0です。

その結果、使えるコマンド数は870を超えました🙀。ターミナルで`let_it_fall`とだけ打てば使えるコマンドが分かります。まずは、`let_it_fall go`として順番に降ってくる、およそ870個の絵文字をぼーっと眺めるのがお薦めです👀 


もう絵文字ネタは終わりたい..。

---

関連記事：

> [Macのターミナルで〇〇が降る]({{ BASE_PATH }}/2014/05/01/let-it-fall-in-the-mac-terminal/ "Macのターミナルで〇〇が降る")
> 
> [(注意)「Let It Fall」は、アナと雪の女王の挿入歌「Let It Go」と何ら関係ございません！]({{ BASE_PATH }}/2014/05/12/letitfall-is-not-letitgo/ "(注意)「Let It Fall」は、アナと雪の女王の挿入歌「Let It Go」と何ら関係ございません！")

