---
layout: post
title: "flippy consoleで上下反転文字の不思議な感覚を味わってみませんか？"
description: ""
category: 
tags: 
date: 2013-02-19
published: true
---
{% include JB/setup %}

少し前に文字列を上下反転して出力する`flippy`というgemを書きましたよ。

> {% hatebu http://melborne.github.com/2013/01/28/make-ruby-script-encript-with-flippy/ 'RubyのコードをFlipして暗号化する？' %}

このgemにはflippyコマンドが付いていて、ターミナルで簡単に反転文字が作れるようになっているのでした。

{% highlight bash %}
% flippy Hello, world!
¡plɹoʍ ‘olləH
{% endhighlight %}

で、今回これをもう少し拡張して、専用コンソールで反転文字を打てる`flippy console`というのを追加しましたので、お知らせしますね。flippy consoleはflippyコマンドに`--console`オプションを付加することで起動することができます。

デモをスクリーンキャストしたので見てください。

<iframe src="http://www.screenr.com/embed/YIZ7" width="650" height="396" frameborder="0"></iframe>

カーソルが追随しないところがイマイチですけど、どうですか？ちょっと面白いですよね？実際に入力してると、ちょっと不思議な感覚があります。

実用性ですか？

ん〜、タッチタイピング練習具とか、右脳発育訓練具とかどうでしょう...

少し逆立ちして考えてみます... それよりもここでは実装方法を少し書き残しておきますね。

## termios
flippy consoleの実現にはプログラムからターミナルの設定を変更する必要があります。つまりターミナルはデフォルトで打った文字をエコーバックします。また、リターンキーを押すまで入力を受け付けないモードにセットされています（これを「カノニカルモード」といいます）。flippy consoleではこのエコーを無効にすると共に、入力文字をすぐに読み取るモード（非カノニカルモード）に一時的に変える必要があります。

これらの設定を変更するにはターミナルの標準インタフェースとなっている`termios`構造体というものにアクセスしてその設定を変える必要があります。幸いRubyには`ruby-termios`というtermiosのラッパーがあるのでこれを使えば、Rubyからターミナルの設定を変更できます。

次のような感じで使います。

{% highlight ruby %}
require "termios"

$stdin.extend Termios

begin
  term_preset = $stdin.tcgetattr
  term = term_preset.dup
  [Termios::ICANON, Termios::ECHO].each { |flag| term.lflag &= ~flag }
  $stdin.tcsetattr(Termios::TCSANOW, term)

  # ターミナルを使う
ensure
  $stdin.tcsetattr(Termios::TCSANOW, term_preset)
end
{% endhighlight %}
`$stdin.extend Termios`で標準入力オブジェクトへTermiosモジュールのメソッドをmix-inします。`#tcgetattr`で現在のターミナルの設定を読み出し、これを保存しておきます。termiosには４種類の設定モード、入力（iflag）、出力（oflag）、制御（cflag）、ローカル（lflag）があって、その何れかに所望の設定を行います。

設定は対象モードに対しフラグをビット単位で論理和することで実現します（ex. term.iflag \|\|= flag）。対象ビットをクリアするには先のコードのように`term.flag &= ~flag`とします。ここでは、カノニカルモード（ICANON）とエコー（ECHO）の設定をオフにしています。

この状態で`#tcsetattr`を使い、ターミナルに変更を加えたtermiosをセットします。第一引数の`TCSANOW`は直ちに設定を反映させるための指定です。以上でターミナルはエコー無し、非カノニカルモードとして動作するようになります。ターミナルの使用後は設定を元に戻しておきます。

> [TERMIOS](http://linuxjm.sourceforge.jp/html/LDP_man-pages/man3/termios.3.html 'Man page of TERMIOS')

## エスケープシーケンス
flippy consoleではカーソルの移動を制御する必要があります。カーソルの制御には標準添付ライブラリの`curses`がありますが、簡単な制御ならエスケープシーケンスで行うことができます。flippyでは今ひとつ上手くできてないですが。

{% highlight ruby %}
print "\e[5;10H"  # カーソルをスクリーンの5行10列に移動
print "\e[1A"     # カーソルを一つ上に移動
print "\e[1B"     # カーソルを一つ下に移動
print "\e[1C"     # カーソルを一つ前に移動
print "\e[1D"     # カーソルを一つ後ろに移動
{% endhighlight %}

色の制御もエスケープシーケンスで行います。これについては以前に記事を書いているので、そちらを参考にして下さい。本当は文字単位で色の制御を行えるようにしたかったのですが、実装が難しくて諦めました。

> [RubyでANSIカラーシーケンスを学ぼう！](http://melborne.github.com/2010/11/07/Ruby-ANSI/ 'RubyでANSIカラーシーケンスを学ぼう！')

エスケープシーケンスの詳細については以下が参考になります。

> [ASCII Table - ANSI Escape sequences](http://ascii-table.com/ansi-escape-sequences.php 'ASCII Table - ANSI Escape sequences')

以上、flippy consoleの紹介と実装の簡単な説明でした。あなたも`flippy -c`して不思議な感覚味わってみませんか？

---

あっ、いい使い道思いついた...ムカつく上司の端末に(ry

該当箇所のコードも一応貼っておきます。

{% gist 4984652 %}


---

関連記事：cursesを使ったサンプル

> [Rubyであみだくじ](http://melborne.github.com/2012/06/07/amida-ruby/ 'Rubyであみだくじ')

