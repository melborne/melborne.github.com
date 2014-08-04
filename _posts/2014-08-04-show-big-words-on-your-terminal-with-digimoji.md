---
layout: post
title: "ターミナルにデジタル式デカ文字を出力する「digi_moji」の紹介"
description: ""
category: 
tags: 
date: 2014-08-04
published: true
---
{% include JB/setup %}

個人的にはターミナル文字の色付けツールである拙作「[colcolor](https://rubygems.org/gems/colcolor "colcolor")」を気に入ってまして。

> [Yet Another Terminal Color for Ruby: Colcolorの紹介]({{ BASE_PATH }}/2014/07/14/yet-another-terminal-color-for-ruby/ "Yet Another Terminal Color for Ruby: Colcolorの紹介")
> 
> [colcolor](https://rubygems.org/gems/colcolor "colcolor")

{% highlight ruby %}
require "colcolor"

str = "Languages: Python Lisp Ruby Perl Haskell Erlang"

puts str.colco(:yellow, :blue, :magenta, :red, :yellow, :blue, :red)
puts str.colco(:green, :blue, cyclic:true)
puts str.colco(:red_bold, regexp:/ruby/i)
puts str.colco(:black_magenta, cyclic:true, regexp:/^\w+|[A-Z]/)
{% endhighlight %}


![digi_moji noshadow]({{ BASE_PATH }}/assets/images/2014/08/digi_moji1.png)

このデモ的なものを作って宣伝できないかと考えたわけです。

それで「[digi_moji](https://rubygems.org/gems/digi_moji "digi_moji")」なるツールが生まれました。

で、ステマをしたのですが...


> {% hatebu http://melborne.github.io/2014/08/04/can-you-see-words-on-your-terminal/ わかりやすいREADME.mdの書き方がわかりません。どうしたらいいでしょうか（Yawhoo知恵袋） - digi_mojiのステマ %}

見事にコケましたorz

----

そんなわけで...。

ここでちゃんと`digi_moji`の紹介記事を書いておくことにします。

## DigiMojiとは

5x7で構成されたデジタル文字をターミナルに表示するためのツールです。裏で先の`colcolor`を使っているので文字にANSIカラーによる色付けができます。

> [digi_moji](https://rubygems.org/gems/digi_moji "digi_moji")
> 
> [melborne/digi_moji](https://github.com/melborne/digi_moji "melborne/digi_moji")

`gem install digi_moji`すると、`digi_moji`というターミナルコマンドが一緒にインストールされて使えるようになります。

    % digi_moji help
    Commands:
      digi_moji help [COMMAND]  # Describe available commands or one specific command
      digi_moji new WORD        # Print a digital word
      digi_moji time            # Print current time
      digi_moji timer SEC       # Print count down timer
    
    Options:
      -f, [--fg=FG]      # Foreground color
                         # Default: bg_white
      -b, [--bg=BG]      # Background color
      -c, [--cell=CELL]  # Cell character
      -w, [--width=N]    # Character width
                         # Default: 2

## digi_moji newコマンド

ターミナル上に単純に文字を出力するには`digi_moji new`コマンドを使います。引数として出力したい文字を渡します。

    % digi_moji new BIGGER

![digi_moji noshadow]({{ BASE_PATH }}/assets/images/2014/08/digi_moji2.png)

スペースを含むときは文字列をクオートしてください。

`new`コマンドにはいくつかのオプションがあります。

    % digi_moji help new
    Usage:
      digi_moji new WORD
    
    Options:
      -f, [--fg=FG]      # Foreground color
                         # Default: bg_white
      -b, [--bg=BG]      # Background color
      -c, [--cell=CELL]  # Cell character
      -w, [--width=N]    # Character width
                         # Default: 2
    
    Print a digital word

色を付けてみます。

    % digi_moji new BIGGER --fg=bg_red --bg=bg_blue

![digi_moji noshadow]({{ BASE_PATH }}/assets/images/2014/08/digi_moji3.png)

色指定の際の注意点は、`--fg`、`--bg`ともに、`bg_<color>`のように背景色指定を渡すことです。これは文字を構成する各セルがスペース（空文字）で表現されているので、前景色を指定しても色が出ないためです。

各セルの文字を空文字以外にセットすると前景色が効くようになります。

    % digi_moji new BIGGER --fg=green --cell=B

![digi_moji noshadow]({{ BASE_PATH }}/assets/images/2014/08/digi_moji4.png)


前景色が効くようになると、`blink`や`underscore`などのテキスト属性が使えるようになります。

    % digi_moji new BIGGER --fg=green_bold --cell=B --bg=green_blink

![digi_moji noshadow]({{ BASE_PATH }}/assets/images/2014/08/digi_moji5.gif)

`--fg`、`--bg`に渡す引数のフォーマットは`colcolor`のそれに倣っていますので、先に示したcolcolorの記事を参考にしてください。

文字の大きさを調整したい場合は、`--width`オプションを使います。デフォルトは`2`です。

![digi_moji noshadow]({{ BASE_PATH }}/assets/images/2014/08/digi_moji6.png)


英大文字、英小文字、キーボード上に表記された記号には概ね対応しています。

![digi_moji noshadow]({{ BASE_PATH }}/assets/images/2014/08/digi_moji7.png)


## digi_moji timeコマンド

デジタル文字の代表と言えば、それは「デジタル時計」です。`time`コマンドはまさにそのためのコマンドです。

    % digi_moji time -f=bg_cyan

![digi_moji noshadow]({{ BASE_PATH }}/assets/images/2014/08/digi_moji8.gif)

ターミナル上に好きな色のデジタル時計を表示できます。`Ctrl+c`で終了します。

色を工夫すれば、オリジナリティ溢れた時計が作れます。

    % digi_moji time -f=cyan  -b=yellow_blink -c=T

![digi_moji noshadow]({{ BASE_PATH }}/assets/images/2014/08/digi_moji9.gif)

いや、ちょっと見づらいですか。

## digi_moji timerコマンド

「デジタル時計」があるなら「タイマー」もほしいと思うのが人情です。`timer`コマンドは引数で渡した時間（デフォルトで秒）を計測するカウントダウンタイマーを出力します。

     % digi_moji timer 5 -f=bg_magenta

![digi_moji noshadow]({{ BASE_PATH }}/assets/images/2014/08/digi_moji10.gif)

`timer`コマンドには追加のオプションとして、`--unit`、`--message`、`--message-color`があります。

    % digi_moji help timer
    Usage:
      digi_moji timer SEC
    
    Options:
      -m, [--message=MESSAGE]              # Message on time's up
                                           # Default: TIME'S UP!
      -k, [--message-color=MESSAGE_COLOR]  # Message color
                                           # Default: bg_red
      -u, [--unit=UNIT]                    # Argument unit
                                           # Default: sec
      -f, [--fg=FG]                        # Foreground color
                                           # Default: bg_white
      -b, [--bg=BG]                        # Background color
      -c, [--cell=CELL]                    # Cell character
      -w, [--width=N]                      # Character width
                                           # Default: 2

`--unit`は引数の単位を変えるもので、'min', 'hour'が渡せます。`--message`は終了メッセージとして"TIME'S UP!"以外を表示できるようにします。`--message-color`はそのメッセージの色を指定します。

    % digi_moji timer 3 -u=min -f=bg_green -m=EAT -k=bg_yellow

![digi_moji noshadow]({{ BASE_PATH }}/assets/images/2014/08/digi_moji11.gif)

## Rubyスクリプトからの使い方

デジ文字は`DigiMoji::String.new`で生成します。

{% highlight ruby %}
require "digi_moji"

str = DigiMoji::String.new("RUBY", fg:'bg_red')

puts str
{% endhighlight %}

出力です。

![digi_moji noshadow]({{ BASE_PATH }}/assets/images/2014/08/digi_moji12.png)

`String#to_digimoji`を用意してあるので、このコードは次のように書くこともできます。

{% highlight ruby %}
require "digi_moji"

str = "RUBY".to_digimoji(fg:'bg_red')

puts str
{% endhighlight %}

いまのところインスタンスメソッドは、`+`、`join`、`<<`の結合系メソッドだけです。`join`はオプションを渡しやすくするための`+`のエイリアスです。`<<`はデジ文字を破壊的に結合します。

{% highlight ruby %}
str = "RUBY".to_digimoji(fg:'bg_red')

puts str + "IST"
puts
puts str.join("IST", fg:'bg_green')
puts
puts str
puts
str << "IST"
puts
puts str
{% endhighlight %}


![digi_moji noshadow]({{ BASE_PATH }}/assets/images/2014/08/digi_moji13.png)

各結合系メソッドには、`DigiMoji::String`オブジェクトを渡してもいいです。

## 特殊文字

いくつかの非ASCII文字に特殊文字が割り当てられています。

`≤`文字にはARROW_LEFT、`≥`文字にはARROW_RIGHT、`¬`文字にはARROW_UP、`—`文字にはARROW_DOWNが割り当てられています。同様に、`÷`文字にはDIVIDE、`æ`文字にはBLOCKが割り当てられています。これらの文字は、`alt + <key>`のコンビネーションでそれぞれ入力可能です（`alt + ,`、`alt + .`、`alt + L`、`alt + ;`、`alt + /`、`alt + '`）。

{% highlight ruby %}
require "digi_moji"

chars = %w(≤ ≥ ¬ — ÷ æ)
colors= %w(red green yellow blue magenta cyan).to_enum

chars.map! { |char| char.to_digimoji(fg:"bg_#{colors.next}") }

puts chars.inject { |m, char| m + char }
{% endhighlight %}


![digi_moji noshadow]({{ BASE_PATH }}/assets/images/2014/08/digi_moji14.png)

## デジ文字のユーザ定義

使われていない非ASCII文字を使って、独自のデジ文字を登録することができます。`Ω`（alt + z）を登録してみます。

デジ文字の登録には、`DigiMoji::Char.register`を使います。第１引数に登録する文字、第２引数にデジ文字を構成するセルを配列で定義します。

{% highlight ruby %}
require "digi_moji"

DigiMoji::Char.register("Ω", %w(f f f f f
                                f t t t f
                                t f f f t
                                t f f f t
                                t f f f t
                                f t f t f
                                t t f t t))

puts "18.3Ω".to_digimoji(fg:'bg_green')
{% endhighlight %}

コードにあるように、セルの定義は文字`t`と`f`の１次元配列で行います。`t`の箇所が文字の形を構成します。

![digi_moji noshadow]({{ BASE_PATH }}/assets/images/2014/08/digi_moji15.png)

以上で説明を終わります。まあ、どんな場面で使えるかわかりませんが、`digi_moji`をよろしくです！


> [digi_moji](https://rubygems.org/gems/digi_moji "digi_moji")
> 
> [melborne/digi_moji](https://github.com/melborne/digi_moji "melborne/digi_moji")

