---
layout: post
title: Termtterでuriを開こう！ - uri-openの紹介と改良
date: 2010-01-25
comments: true
categories:
---


Termtterにはstatus内のuriを開くための
uri-openという便利なpluginがある
{% highlight ruby %}
> uri-open list または uo list
{% endhighlight %}
とすればstatusのuriが連番付きでリスト表示されるので
次いで
{% highlight ruby %}
> uri-open 3
{% endhighlight %}
などとして対象のuriを選べばいい
このときexpand-tinyurlというpluginを使って
リスト表示されるuriを短縮形から直しておくのがいい

Termtterには入力のタブ補完機能があるので
長いcommand入力も苦にはならないけど
良く使うcommandにはaliasを割り当てるのが便利だ
.termtter/configファイルで以下のようにする
{% highlight ruby %}
config.plugins.alias.aliases = {
  :o => 'uri-open',
  :ul => 'uri-open list',
}
{% endhighlight %}

また各statusには$amのようなIDが付いているので
{% highlight ruby %}
> o in $am
{% endhighlight %}
とすればstatusを指定してopenできる
最も新しいstatusを開く場合は単に
{% highlight ruby %}
> o
{% endhighlight %}
とすればいい

個別のuriを開くのが面倒ならば
不要なuriを
{% highlight ruby %}
> o delete 5
{% endhighlight %}
などとしてから
{% highlight ruby %}
> o all
{% endhighlight %}
とすればすべて一度にopenすることもできる

uri-open allは確かに便利だけれど
listに大量のuriが入っている場合大変なことになる
そこで僕はuri-openを少しいじって
いくつかのuriをopenするsomeコマンドを追加してみた
{% highlight ruby %}
uri-open.rb
7d6
< config.plugins.uri_open.set_default :some, 5
46,51d44
<   when /^some\s*(\d*)$/
<     some = $1.empty? ? config.plugins.uri_open.some : $1.to_i
<     some.times do
<       return unless uri = public_storage[:uris].shift
<       open_uri(uri)
<     end
83c75
<   %w(all list delete clear in some).grep(/^#{Regexp.quote arg}/).map {|a| "#{cmd} #{a}" }
---
>   %w(all list delete clear in).grep(/^#{Regexp.quote arg}/).map {|a| "#{cmd} #{a}" }
{% endhighlight %}

これにより
{% highlight ruby %}
> o some
{% endhighlight %}
で最新の5つのuriがopenする
{% highlight ruby %}
> o some 10
{% endhighlight %}
とすれば10のuriがopenする

.termtter/configに
{% highlight ruby %}
config.plugins.uri_open.some = 3
{% endhighlight %}
とすればdefaultの5つを変更できる
またconfigに
{% highlight ruby %}
config.plugins.alias.aliases = {
  :some= => 'eval config.plugins.uri_open.some='
}
{% endhighlight %}
とaliasを追加すれば
{% highlight ruby %}
> some= 10
{% endhighlight %}
で一時的にdefaultを変更できる{% fn_ref 1 %}

それからuri-open in $am で個別にopenするときに
$を省略して
{% highlight ruby %}
> o in am
{% endhighlight %}
と打てるようにもしてみた
{% highlight ruby %}
uri-open.rb
68d60
<    id = Termtter::Client.typable_id_to_data(id) unless id =~ /\d+/
{% endhighlight %}

Termtterはこういった改良を簡単にできるので
便利だし勉強にもなる
{% footnotes %}
   {% fn someと=の間にspaceを空けない %}
{% endfootnotes %}
