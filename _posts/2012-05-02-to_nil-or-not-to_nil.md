---
layout: post
title: "nil?すべきかempty?すべきか、それが問題だ！"
description: ""
category: 
tags: [ruby]
date: 2012-05-02
published: true
---
{% include JB/setup %}

##nil?すべきか
Rubyを使っているとコードをより簡潔により美しくしたいという欲求、つまりDRY欲が加速します。

例えば次のようなコードがあります。ここでの関心はprocess_userメソッドです。
{% highlight ruby %}
class String
  def some_process
    "Process_completed for %s" % self
  end
end

def process_user
  unless @user
    @user = 'anonymous'
  end
  @user.some_process
end

@user = nil
process_user # => "Process_completed for anonymous"

@user = 'Charlie'
process_user # => "Process_completed for Charlie"
{% endhighlight %}
Rubyistはこのコードを見てムズムズします。

そして`unless修飾子`を使ってこんな風にリファクタします。
{% highlight ruby %}
def process_user
  @user = 'anonymous' unless @user
  @user.some_process
end

@user = nil
process_user # => "Process_completed for anonymous"

@user = 'Charlie'
process_user # => "Process_completed for Charlie"
{% endhighlight %}

いえいえ、`OR演算子`の短絡を利用して、こんな風にリファクタします。

{% highlight ruby %}
def process_user
  @user = @user || 'anonymous'
  @user.some_process
end

@user = nil
process_user # => "Process_completed for anonymous"

@user = 'Charlie'
process_user # => "Process_completed for Charlie"
{% endhighlight %}

いやいや、自己代入演算子でこんな風にリファクタします。
{% highlight ruby %}
def process_user
  @user ||= 'anonymous'
  @user.some_process
end

@user = nil
process_user # => "Process_completed for anonymous"

@user = 'Charlie'
process_user # => "Process_completed for Charlie"
{% endhighlight %}

##empty?すべきか

@userが`nil`でなく`空文字`を受ける場合はどうでしょう。`String#empty?`を使った最初のコードは次のようになります。
{% highlight ruby %}
def process_user
  if @user.empty?
    @user = 'anonymous'
  end
  @user.some_process
end

@user = ""
process_user # => "Process_completed for anonymous"

@user = 'Charlie'
process_user # => "Process_completed for Charlie"
{% endhighlight %}

ムズムズするので、`if修飾子`を使ってリファクタします。
{% highlight ruby %}
def process_user
  @user = 'anonymous' if @user.empty?
  @user.some_process
end

@user = ""
process_user # => "Process_completed for anonymous"

@user = 'Charlie'
process_user # => "Process_completed for Charlie"
{% endhighlight %}

まだムズムズするので、`OR演算子`を使ってリファクタします。
{% highlight ruby %}
def process_user
  @user = !@user.empty? || 'anonymous'
  @user.some_process
end

@user = ""
process_user # => "Process_completed for anonymous"

@user = 'Charlie'
process_user # => 
# ~> -:9:in `process_user': undefined method `some_process' for true:TrueClass (NoMethodError)
# ~> 	from -:16:in `<main>'
{% endhighlight %}

ところがこれはエラーになります。@userが空文字でなければ、@userに`true`がセットされてしまうからです。

##それが問題だ
そこでこんな対策を考えました。空文字のときはnilを返しそうでないときはselfを返す`String#to_nil`を定義するのです。

{% highlight ruby %}
class String
  def to_nil
    self unless empty?
  end
end
{% endhighlight %}

そしてString#empty?の代わりに使います。
{% highlight ruby %}
def process_user
  @user = @user.to_nil || 'anonymous'
  @user.some_process
end

@user = ""
process_user # => "Process_completed for anonymous"

@user = 'Charlie'
process_user # => "Process_completed for Charlie"
{% endhighlight %}

良いアイディアだと思ったのですが、そんなものはRails界隈でとうの昔にありました。そう、`Object#presence`です。Railsを知らない人は困ります > 私^ ^;

{% highlight ruby %}
require "active_support/all"

def process_user
  @user = @user.presence || 'anonymous'
  @user.some_process
end

@user = ""
process_user # => "Process_completed for anonymous"

@user = 'Charlie'
process_user # => "Process_completed for Charlie"
{% endhighlight %}

因みに実装は次のとおりです。
{% highlight ruby %}
class Object
  def presence
    self if present?
  end

  def present?
    !blank?
  end

  def blank?
    respond_to?(:empty?) ? empty? : !self
  end
end
{% endhighlight %}

これに倣って、私のString#to_nilも`Object#to_nil`に昇格させます。こんな感じでしょうか。
{% highlight ruby %}
class Object
  def to_nil
    self if respond_to?(:empty?) && !empty?
  end
end
{% endhighlight %}

ここまで来ると、DRY浴が止まりません。

nilのときのように自己代入させたいです。
{% highlight ruby %}
def process_user
  @user.to_nil ||= 'anonymous'
  @user.some_process
end

@user = ""
process_user # => 

@user = 'Charlie'
process_user # => 
# ~> -:15:in `process_user': undefined method `to_nil=' for "":String (NoMethodError)
# ~> 	from -:20:in `<main>'
{% endhighlight %}
当然エラーになります。でも`to_nil=`が無いと言っていますので、これを定義してみます。

{% highlight ruby %}
class Object
  def to_nil
    self if respond_to?(:empty?) && !empty?
  end
  
  def to_nil=(obj)
    replace(obj) if respond_to?(:replace)
  end
end

def process_user
  @user.to_nil ||= 'anonymous'
  @user.some_process
end

@user = ""
process_user # => "Process_completed for anonymous"

@user = 'Charlie'
process_user # => "Process_completed for Charlie"
{% endhighlight %}
うまくいきました。自己代入では最初に`to_nil`が呼ばれてselfか'anonymous'が返り、次に`to_nil=`がこの返り値とともに呼ばれてselfをその値でreplaceします。

他のオブジェクトに対しても試してみます。
{% highlight ruby %}
str1, str2, arr1, arr2, hash1, hash2, nil1 = 'hello', '', [1,2,3], [], {a:1, b:2}, {}, nil

str1.to_nil ||= 'default'
str2.to_nil ||= 'default'
arr1.to_nil ||= [:default]
arr2.to_nil ||= [:default]
hash1.to_nil ||= {default: 1}
hash2.to_nil ||= {default: 1}
nil1.to_nil ||= 'default'

str1 # => "hello"
str2 # => "default"
arr1 # => [1, 2, 3]
arr2 # => [:default]
hash1 # => {:a=>1, :b=>2}
hash2 # => {:default=>1}
nil1 # => nil
{% endhighlight %}
当然ながら、nil1の結果だけは期待通りになりません。nilをreplaceできたら面白いかもしれません。

まあちょっと奇妙なコードです。やり過ぎ感が漂います。

そんなわけで、楽しいＧＷを！


{{ 4102020039 | amazon_medium_image }}
{{ 4102020039 | amazon_link }} by {{ 4102020039 | amazon_authors }}

