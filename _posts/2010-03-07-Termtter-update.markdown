---
layout: post
title: Termtterでupdateコマンドを省略する
date: 2010-03-07
comments: true
categories:
---


Termtterが他のTwitterクライアントと違うことの１つは
ユーザが入力した文字列を
Twitterへの投稿文字列とは解釈しないところだ

Termtterは常にそれをコマンド(+引数)として解釈する

だからそのことを忘れて投稿文字列を打つと
以下のように言われる
{% highlight ruby %}
> 誰か僕の代わりに仕事してくれないかなあ
[ERROR] Termtter::CommandNotFound: 誰か僕の代わりに仕事してくれないかなあ
{% endhighlight %}
知ってるよ！そんなコマンドあるわきゃない！

つまり投稿文字列を打つときも
その先頭にコマンドが必要になる
{% highlight ruby %}
> update 誰か僕の代わりに仕事してくれないかなあ
{% endhighlight %}

updateにはuというショートカットがあるので
{% highlight ruby %}
> u 誰か僕の代わりに仕事してくれないかなあ
{% endhighlight %}
とできる

それでも僕はしばしばこのuを忘れて
リターンキーを押してからuが無いのに気付く

だから僕が少し長い文章を打ったら
それは単にuを忘れてるんだと解釈して欲しい

そんな想いからclient.rbを少しいじってみました
{% highlight ruby %}
150,158c150,151
<           
<           unless command = find_command(text)
<             if text.length > 20 and config.confirm
<               text = 'update ' + text
<               retry
<             else
<               raise CommandNotFound, text
<             end
<           end
---
>           command = find_command(text)
>           raise CommandNotFound, text unless command
{% endhighlight %}

(追記：2010/5/20) Ruby1.9ではretryがrescueの外では使えないようなので以下のようにしました。
{% highlight ruby %}
150,158c150,151
<
<          begin
<            raise unless command = find_command(text)
<          rescue
<            if text.length > 15 && config.confirm
<              text = 'update ' + text
<              retry
<            else
<              raise CommandNotFound, text
<            end
<          end
---
>           command = find_command(text)
>           raise CommandNotFound, text unless command
{% endhighlight %}

(追記：2010/5/29) Termtter1.8.0では添付のeasy_post pluginで同様のことができるようになっています。command_not_foundをフックすればいいんですね。
{% highlight ruby %}
module Termtter::Client
  register_hook(:easy_post, :point => :command_not_found) do |text|
    execute("update #{text}")
  end
end
{% endhighlight %}
ただ自分は先のパッチのようにupdateの省略をconfirm=trueかつテキストが長いときに限定したいので、別のplugin(default_replace.rb)に以下を追加して対応することにしました。
{% highlight ruby %}
module Termtter::Client
  register_hook(:easy_post, :point => :command_not_found) do |text|
    if config.confirm && text.length > 15
      execute("update #{text}")
    else
      raise Termtter::CommandNotFound, text
    end  
  end
end
{% endhighlight %}

[gist: 297408 - Termtter plugins- GitHub](http://gist.github.com/297408)