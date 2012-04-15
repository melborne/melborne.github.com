---
layout: post
title: Rubyでマリオを奏でよう！
tagline: _whyのbloopsaphoneの紹介
date: 2010-05-27
comments: true
categories:
---


2009年8月19日Ruby界の鬼才_why{% fn_ref 1 %}が
ネットから忽然と姿を消しました{% fn_ref 2 %}
この突然の出来事にRubyist達は驚きそして困惑しました
なぜなら彼自身がただネットから消えたのではなく
_whyはネット上の彼の痕跡も同時にすべて消し去ったのです！

Rubyのガイドブック　ブログ　音楽　カートゥーン
そしてアクティブなライブラリを含む多数のプログラムコード
camping hpricot redcloth shoes TryRuby metaid...
_whyは削除コマンドを実行して
_whyの作品群をクラウドのメモリーから削除しました

このような行動に対しネット上には賛否両論がありましたが
多くの人はそこに至った_whyの心情を悲しみました

そう_whyは_whyの手によって抹殺されたのです...

しかし

_whyにも削除できない記憶域がありました
それはクラウドの向こう側にいる人々の脳内記憶でした
_whyというユニークなペルソナを
人々の記憶から消し去ることは彼にもできなかったのです

その結果としてコミュニティにより
_whyの作品群はネット上に再生されました

[_why's Estate](http://viewsourcecode.org/why/)

ポストモダン時代の天才として
_whyの軌跡を追う記事が最近書かれました

[Why: A Tale Of A Post-Modern Genius](http://www.smashingmagazine.com/2010/05/15/why-a-tale-of-a-post-modern-genius/)

改めて_whyのユニークさを実感します

そう_whyは今も生きているのです...

##bloopsaphone
先の記事で_whyのbloopsaphoneというライブラリを知りました
以下ではその使い方を簡単に説明したいと思います

bloopsaphoneはファミコンサウンドのような
電子音を作るためのRubyとCのライブラリです

[mental's bloopsaphone at master - GitHub](http://github.com/mental/bloopsaphone)

まずはbloopsaphoneで作った音を聞いてください

[link](http://dl.dropbox.com/u/58702/sample.mp3:sound)

これはライブラリに付属の次のコードを再生したものです
{% highlight ruby %}
test.rb
require 'bloops'
# the song object
b = Bloops.new
b.tempo = 320
# an instrument
saw = b.sound Bloops::SINE
#saw = b.sound Bloops::SAWTOOTH
# assign a track to the song
b.tune saw, "c5 c6 b4 b5 d5 d6 e5 e6b"
# make it go
b.play
sleep 1 while !b.stopped?
# a percussion
beat = b.sound Bloops::NOISE
beat.repeat = 0.6
# assign a track to the song
b.tune beat, "4 4 b4 4 d5 4 e5 e6"
# make it go
b.play
sleep 1 while !b.stopped?
{% endhighlight %}
ライブラリにはドキュメントがないですが
サンプルコードを見れば大体使い方がわかります

手順としては次のようになります
1. Bloops.newでsongオブジェクトを作り(Bloopsクラスのインスタンス生成)
1. tempoメソッドでテンポを決め
1. soundメソッドで楽器(音)を選び(Soundクラスのインスタンス生成)
1. setterメソッドで音質調整をし
1. tuneメソッドで楽譜をセットして(Trackクラスのインスタンス生成)
1. playメソッドで再生する

複数トラックの再生が可能で
この例では１回目は１トラック
２回目は２トラックで再生しています

楽器(sound)にはSQUARE SAWTOOTH SINE NOISEの４種があって
そのベース音に対して音質調整用メソッド(ここではrepeat)で
音質調整して最終的な音質を決めます

楽譜はRTTTL(Ring Tone Transfer Language){% fn_ref 3 %}を
ベースにした記法の文字列を渡します
音符の音価(長さ)と音高と音程(オクターブ)を
数字・アルファベット・数字の組で表します
例えば"8:F#4"は"８分音符F#(ファ#)オクターブ４"を表します
音価と音程は省略可能でありその場合はデフォルト値が使われます
オクターブは"+"または"-"で表すこともできます
また":"は省略可能です
休符は数字のみで表されて例えば"4"は"４分休符"を表します

(READMEにある)シンプソンのテーマは次のようになります
{% highlight  bash %}
32 + C E F# 8:A G E C - 8:A 8:F# 8:F# 8:F# 2:G
{% endhighlight %}

これは以下を表しています
{% highlight  bash %}
32分休符 １オクターブ上げ 4分C 4分E 4分F# 8分A 4分G 4分E 4分C
１オクターブ下げ 8分A 8分F# 8分F# 8分F# 2分G
{% endhighlight %}

##インストール
OSXへのインストールは以下のようにします{% fn_ref 4 %}
{% highlight bash %}
sudo port install portaudio
sudo gem install bloopsaphone -- --with-opt-lib=/opt/local/lib --with-opt-include=/opt/local/include
{% endhighlight %}
bloopsaphoneはportaudioというオーディオI/Oライブラリに依存しています

##音質調整メソッド
音質調整はBloops#soundメソッドで生成されるSoundクラスの
インスタンスメソッドで行います
それぞれ0.0～1.0の値をセットします
{% highlight ruby %}
lead = b.sound Bloops::SQUARE
lead.volume = 0.5
lead.attack = 0.02
lead.sustain = 0.4
lead.decay = 0.7
lead.phase = 0.0
lead.psweep = 0.0
lead.vibe = 0.0
lead.vspeed = 0.5
{% endhighlight %}
各メソッドの機能は名前から推測できるものもありますが
そうでないものもあります
値を調整して試してみるほかないようです

音質調整は設定ファイルをロードして行うこともできます
{% highlight ruby %}
require 'bloops'
bases = Dir["../../sounds/*.blu"]
b = Bloops.new
bases.each do |base|
  puts "** playing scale using #{base[/\w+.blu/]}"
  sound = b.load base
  b.tune sound, "c c# d eb e f f# g ab a bb b + c"
  b.play
  sleep 1 while !b.stopped?
  b.clear
end
{% endhighlight %}
このコードはライブラリに添付の複数の設定ファイルを読み出し
各音質で同じコードを再生するものです
音質調整で様々な音が再現できることが分かると思います

[link](http://dl.dropbox.com/u/58702/sample2.mp3:sound)

ここで再生した各設定ファイルは以下の通りです
{% highlight bash %}
dart.blu
type    noise
punch   0.524
sustain 0.160
decay   0.367
freq    0.296
slide  -0.373
vibe    0.665
vspeed  0.103
phase   0.141
psweep -0.005
{% endhighlight %}
{% highlight bash %}
error.blu
type      square
sustain   0.333
decay     0.380
freq      0.336
slide     0.292
square    0.289
sweep     0.020
vibe      0.002
lpf       0.220
lsweep    0.015
resonance 0.875
aspeed    0.035
repeat    0.551
{% endhighlight %}
{% highlight bash %}
ice.blu
type    square
punch   0.441
sustain 0.067
decay   0.197
freq    0.499
{% endhighlight %}
{% highlight bash %}
jump.blu
type    square
sustain 0.266
decay   0.187
freq    0.268
slide   0.179
square  0.326
vibe    0.227
vspeed  0.231
{% endhighlight %}
{% highlight bash %}
pogo.blu
type      square
volume    0.977
punch     0.190
sustain   0.165
slide     0.100
dslide    0.030
square    0.048
sweep    -0.055
vibe      0.437
vspeed    0.310
lpf       0.355
resonance 0.185
hpf       0.205
hsweep    0.255
arp       0.677
aspeed    0.275
phase     0.200
psweep   -0.565
repeat    0.500
{% endhighlight %}
{% highlight bash %}
stun.blu
type    sawtooth
sustain 0.306
decay   0.477
freq    0.429
slide   0.217
repeat  0.677
{% endhighlight %}

##メソッド一覧
bloopsaphoneのメソッド群は次のようになります
{% highlight bash %}
Bloopsクラス
 instance methods: clear, load, play, sound, stopped?, tempo, tempo=, tune
 constants: SQUARE, SAWTOOTH, SINE, NOISE
Soundクラス
 instance methods: arp, arp=, aspeed, aspeed=, attack, attack=, decay, decay=, dslide, dslide=, freq, freq=, hpf, hpf=, hsweep, hsweep=, limit, limit=, lpf, lpf=, lsweep, lsweep=, phase, phase=, psweep, psweep=, punch, punch=, repeat, repeat=, resonance, resonance=, slide, slide=, square, square=, sweep, sweep=, sustain, sustain=, type, type=, vibe, vibe=, vspeed, vspeed=, vdelay, vdelay=, volume, volume=
Trackクラス
 instance methods: to_s
{% endhighlight %}

##BloopSong DSL
bloopsaphoneで長い楽譜を再生しようとすると
以下のような問題がありました
1. CPUの占有率が徐々に上がって途中で再生不能になる
1. トラック数が増えるとコードの可読性が下がる
1. トラック数を変えたり楽譜の一部の小節だけを再生をするのに手間が掛かる

そこでこれらの問題に対応するために
BloopSongという簡単なＤＳＬを書きました
{% highlight ruby %}
require "bloops"
class BloopSong
  def self.init(tempo)
    @bloops = Bloops.new
    @bloops.tempo = tempo
    yield self
    self
  end
  def self.play(score, opt={})
    score = read_score(score)
    tunes = Array(opt[:tune] || :lead)
    range_max = score[tunes.first].length-1
    for i in range(opt[:range], range_max)
      tunes.each do |tune|
        @bloops.tune send(tune), score[tune][i]
      end
      @bloops.play
      sleep 0.01 until @bloops.stopped?
      @bloops.clear
    end
  end
  def self.define_class_method(name)
    (class << self; self end).module_eval { define_method(name) { yield } }
  end
  def self.sound(name=:lead, type)
    self.instance_variable_set("@#{name}", @bloops.sound( Bloops.module_eval(type.to_s) ))
    define_class_method(name) { self.instance_variable_get("@#{name}") }
    yield send(name) if block_given?
    @bloops
  end
  def self.read_score(score)
    q = Hash.new([])
    flag = :lead
    score.each_line do |line|
      next if line =~ /^\s*$/
      case line
      when /^:(\w+)/ then flag = $1
      else
        q[flag.to_sym] += [line]
      end
    end
    q
  end
  def self.range(opt, max)
    if !opt
      (0..max)
    elsif opt.end > max || opt.end < 0
      (opt.begin..max)
    else
      opt
    end
  end
end
{% endhighlight %}

以下のように使います
{% highlight ruby %}
require_relative "bloopsong"
mario =
  BloopSong.init(216) do |b|
    b.sound(:lead, :SQUARE) do |s|
      s.volume  = 0.4
      s.punch   = 0.441
      s.sustain = 0.067
      s.decay   = 0.297
      s.freq    = 0.499
    end
  
    b.sound(:lead2, :SQUARE) do |s|
      s.volume  = 0.4
      s.punch   = 0.441
      s.sustain = 0.067
      s.decay   = 0.297
      s.freq    = 0.499
    end
    b.sound(:base, :SQUARE) do |s|
      s.volume  = 0.4
      s.punch   = 0.641
      s.sustain = 0.197
      s.decay   = 0.197
      s.freq    = 0.499
    end
  end
mario.play(DATA, :range => 0..-1, :tune => [:lead, :lead2, :base])
__END__
:lead
 8E5 8E5 8 8E5 8 8C5 4E5    4G5 4 4G4 4           4C5 8 8G4 4 4E4          8 4A4 4B4 8A#4 4A4
 6G4 6E5 6G5 4A5 8F5 8G5    8 4E5 8C5 8D5 4B4 8   4C5 8 8G4 4 4E4          8 4A4 4B4 8A#4 4A4
 6G4 6E5 6G5 4A5 8F5 8G5    8 4E5 8C5 8D5 4B4 8   4 8G5 8F#5 8F5 4D#5 8E5  8 8G#4 8A4 8C5 8 8A4 8C5 8D5
 4 8G5 8F#5 8F5 4D#5 8E5    8 4C6 8C6 4C6 4       4 8G5 8F#5 8F5 4D#5 8E5  8 8G#4 8A4 8C5 8 8A4 8C5 8D5
:lead2
 8F#4 8F#4 8 8F#4 8 8F#4 4F#4   4G4 4 4G4 4          4E4 8 8E4 4 4C4         8 4C4 4D4 8C#4 4C4
 6C4 6E4 6B4 4C5 8A4 8B4        8 4A4 8E4 8F4 4D4 8  4E4 8 8E4 4 4C4         8 4C4 4D4 8C#4 4C4
 6C4 6E4 6B4 4C5 8A4 8B4        8 4A4 8E4 8F4 4D4 8  4 8E5 8D#5 8D5 4B4 8C5  8 8E4 8F4 8A4 8 8C4 8E4 8F4
 4 8E5 8D#5 8D5 4B4 8C5         8 4G5 8G5 4G5 4      4 8E5 8D#5 8D5 4B4 8C5  8 8E4 8F4 8A4 8 8C4 8E4 8F4
:base
 8D3 8D3 8 8D3 8 8D3 4D3   4G3 4 4G3 4           4G3 8 8E3 4 4C3         8 4F3 4G3 8F#3 4E3
 6E3 6C4 6E4 4F4 8D4 8E4   8 4C4 8A3 8B3 4G3 8   4G3 8 8E3 4 4C3         8 4F3 4G3 8F#3 4E3
 6E3 6C4 6E4 4F4 8D4 8E4   8 4C4 8A3 8B3 4G3 8   4C3 8 8G3 4 4C4         4F3 8 8C4 4C4 4F3
 4C3 8 8E3 4 8G3 8C4       2 4 4G3               4C3 8 8G3 4 4C4         4F3 8 8C4 4C4 4F3 
{% endhighlight %}

BloopSong.initの引数にテンポを渡し
そのブロック内で各楽器の設定を行います
楽器を指定するsoundメソッドの引数には
楽器名とその種類をシンボルで渡し
そのブロック内で音質調整を行います

楽譜はplayメソッドの第1引数に文字列として渡します
渡す文字列においてパート名はシンボル表記します
省略すると:leadが自動的にセットされます

BloopSong.playメソッドは
 :rangeと:tuneの２つキーワード引数を取ります
rangeは楽譜の再生行(小節ではない)を指定します
例のようにするか省略した時にはすべてを再生します
tuneで指定したパートのみを再生します

[link](http://dl.dropbox.com/u/58702/mario_theme.mp3:sound)

コードは以下のリンクにあります

[melborne's bloopsong at master - GitHub](http://github.com/melborne/bloopsong) 

(追記：2010-12-4)bloopsongの修正に伴い、コードおよび一部記述を修正しました。

[関連サイト]
[Early 8-bit Sounds from _why's Bloopsaphone](http://www.urbanhonking.com/ideasfordozens/2009/05/early_8bit_sounds_from__whys_b.html)
[A chiptune cover of Phoenix’s “1901”](http://www.aanandprasad.com/1901)
[AdminMyServer - ruby pong with shoes and bloopsaphone](http://adminmyserver.com/articles/ruby-pong-with-shoes-and-bloopsaphone)
{% footnotes %}
   {% fn http://en.wikipedia.org/wiki/Why_the_lucky_stiff:title %}
   {% fn http://www.rubyinside.com/why-the-lucky-stiff-is-missing-2278.html:title %}
   {% fn http://en.wikipedia.org/wiki/Ring_Tone_Transfer_Language:title %}
   {% fn Installing _why's Bloopsaphone on OS X http://deaddeadgood.com/2010/2/13/installing-_why-s-bloopsaphone-on-os-x/ %}
{% endfootnotes %}
