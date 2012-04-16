---
layout: post
title: SinatraはDSLなんかじゃない、Ruby偽装を使ったマインドコントロールだ！
date: 2011-06-03
comments: true
categories:
tags: [ruby, sinatra, dsl]
---

Sinatraのサイトを開くとSinatraはDSLだと書いてある。
 
> Sinatra is a DSL for quickly creating web applications in Ruby with minimal effort:
> (SinatraはRubyで手早くWebアプリケーションをつくるためのDSLです)

DSLというのはDomain-Specific Language、つまり特定の目的に特化した言語のことだ。確かにSinatraはWebアプリケーションという特定の目的のために作られたものだけれども、それは言語じゃない。

それが言語といえるためにはオブジェクトのように独立していて閉じてなきゃいけない{% fn_ref 1 %}。でもSinatraは独立も閉じてもなくて、Rubyに寄生することで存在している。

いやSinatraは言語どころか、Rubyの上の専門用語ですらない。

それが用語といえるためにはせりでの手やりのように、その専門の特別のルールで動かなきゃいけない{% fn_ref 2 %}。でもSinatraはそれ専用のルールで動いてなくて、Rubyのルールで動いてる。
{% highlight ruby %}
  # myapp.rb
  require 'sinatra'
  
  get '/' do
    'Hello world!'
  end
{% endhighlight %}

上のコードをRubyで実行すればSinatraが動くけど、コードの中のgetはRubyの関数{% fn_ref 3 %}呼び出しに過ぎない。

irbで確かめてみよう。
{% highlight ruby %}
% irb -f
irb(main):001:0> get '/' do
irb(main):002:1*  'Hello world!'
irb(main):003:1> end
NoMethodError: undefined method `get' for main:Object
        from (irb):1
        from /Users/keyes/.rvm/rubies/ruby-1.9.2-p180/bin/irb:16:in `<main>'
{% endhighlight %}
Sinatraをrequireせずにgetを呼ぶと、Objectクラスのインスタンスmainにはgetメソッドは未定義とのエラーが出た。

今度はSinatraをrequireしてgetを呼んでみよう。
{% highlight ruby %}
irb(main):004:0> require 'sinatra'
=> true
irb(main):005:0> get '/' do
irb(main):006:1*  'Hello world!'
irb(main):007:1> end
=> [/^\/$/, [], [], #<Proc:0x00000101331218@/Users/keyes/.rvm/gems/ruby-1.9.2-p180/gems/sinatra-1.2.6/lib/sinatra/base.rb:1152>]
{% endhighlight %}
今度はgetが呼べた。そしてRegexpオブジェクトやProcオブジェクトを含んだ、Arrayオブジェクトが返された。

それじゃカッコを省略せずにRubyの礼儀正しい構文で呼んでみよう。
{% highlight ruby %}
irb(main):008:0> get('/') { 'Hello world!' }
=> [/^\/$/, [], [], #<Proc:0x0000010133bce0@/Users/keyes/.rvm/gems/ruby-1.9.2-p180/gems/sinatra-1.2.6/lib/sinatra/base.rb:1152>]
irb(main):009:0> 
{% endhighlight %}
同じ結果が返ってきた。

ここでRubyのトップレベルで呼べる関数は、Objectクラスに定義されたプライベート・インスタンスメソッドであった。このことをputsで確認してみよう。
{% highlight ruby %}
irb(main):024:0> Object.private_instance_methods.grep /^puts/
=> [:puts]
{% endhighlight %}

しかしその定義の実態はObjectクラスにはなくて、それにインクルードされたKernelモジュールにあるのだった。
{% highlight ruby %}
irb(main):025:0> Object.private_instance_methods(false).grep /^puts/
=> []
irb(main):026:0> Kernel.private_instance_methods(false).grep /^puts/
=> [:puts]
{% endhighlight %}

じゃあ同様にgetもsinatraをrequireしたことによって、Objectクラスに定義されているはずだ。
{% highlight ruby %}
irb(main):027:0> Object.private_instance_methods.grep /^get/
=> [:get, :gets]
{% endhighlight %}
あった。

さてその実態はやはりKernelにあるのだろうか。
{% highlight ruby %}
irb(main):028:0> Object.private_instance_methods(false).grep /^get/
=> []
irb(main):031:0> Kernel.private_instance_methods(false).grep /^get/
=> [:gets]
{% endhighlight %}
Kernelにはなかった...

そうすると想像できるのはsinatraのrequireによってObjectクラスに別のモジュールがインクルードされたということだ。確かめてみよう。
{% highlight ruby %}
irb(main):032:0> Object.included_modules
=> [Sinatra::Delegator, Kernel]
{% endhighlight %}

Sinatra::Delegatorというモジュールがインクルードされていた。じゃあここにgetメソッドが定義されているんだろう。
{% highlight ruby %}
irb(main):061:0> Sinatra::Delegator.private_instance_methods(false).grep /^get/
=> [:get]
{% endhighlight %}
やはりそうだった。Sinatraのソースコードで中身を確認してみよう。
{% highlight ruby %}
# base.rb
module Sinatra
  module Delegator #:nodoc:
    def self.delegate(*methods)
      methods.each do |method_name|
        eval <<-RUBY, binding, '(__DELEGATE__)', 1
          def #{method_name}(*args, &b)
            ::Sinatra::Application.send(#{method_name.inspect}, *args, &b)
          end
          private #{method_name.inspect}
        RUBY
      end
    end
    delegate :get, :put, :post, :delete, :head, :template, :layout,
             :before, :after, :error, :not_found, :configure, :set, :mime_type,
             :enable, :disable, :use, :development?, :test?, :production?,
             :helpers, :settings
  end
end
{% endhighlight %}

ちょっと分かりづらいけど、要はDelegator.delegateでDelegatorモジュールにgetプライベート・インスタンスメソッドを生成している。そしてその中身は受け取った引数とブロックをそのまま、Sinatra::Applicationクラスに定義されたgetクラスメソッドに移譲するものとなっている。

つまりsinatraをrequireしてトップレベルでgetを呼ぶと、Delegatorモジュールを介してSinatra::Applicationクラスのgetクラスメソッドが呼ばれる。

irbで直接これを呼んで確かめてみよう。
{% highlight ruby %}
irb(main):037:0> Sinatra::Application.get('/') { "hello, world" }
=> [/^\/$/, [], [], #<Proc:0x0000010131a9f0@/Users/keyes/.rvm/gems/ruby-1.9.2-p180/gems/sinatra-1.2.6/lib/sinatra/base.rb:1152>]
{% endhighlight %}
期待通りの結果が返ってきた。じゃあその定義があるか確認してみよう。
{% highlight ruby %}
irb(main):051:0> Sinatra::Application.singleton_methods(false).grep /^get/
=> []
{% endhighlight %}
無い...Sinatra::Applicationにはスーパークラスがあるのかな？
{% highlight ruby %}
irb(main):053:0> Sinatra::Application.superclass
=> Sinatra::Base
{% endhighlight %}
Sinatra::BaseというのがSinatra::Applicationのスーパークラスだった
{% highlight ruby %}
irb(main):055:0> Sinatra::Base.singleton_methods(false).grep /^get/
=> [:get]
{% endhighlight %}
getの定義はここにあった。

一応ソースを確認してみよう。
{% highlight ruby %}
module Sinatra
  class Base
    class << self
      def get(path, opts={}, &block)
        conditions = @conditions.dup
        route('GET', path, opts, &block)
        @conditions = conditions
        route('HEAD', path, opts, &block)
      end
      def put(path, opts={}, &bk);    route 'PUT',    path, opts, &bk end
      def post(path, opts={}, &bk);   route 'POST',   path, opts, &bk end
      def delete(path, opts={}, &bk); route 'DELETE', path, opts, &bk end
      def head(path, opts={}, &bk);   route 'HEAD',   path, opts, &bk end
    private
      def route(verb, path, options={}, &block)
        # Because of self.options.host
        host_name(options.delete(:bind)) if options.key?(:host)
        options.each {|option, args| send(option, *args)}
        pattern, keys = compile(path)
        conditions, @conditions = @conditions, []
        define_method "#{verb} #{path}", &block
        unbound_method = instance_method("#{verb} #{path}")
        block =
          if block.arity != 0
            proc { unbound_method.bind(self).call(*@block_params) }
          else
            proc { unbound_method.bind(self).call }
          end
        invoke_hook(:route_added, verb, path, block)
        (@routes[verb] ||= []).
          push([pattern, keys, conditions, block]).last
      end
    end
  end
end
{% endhighlight %}

要するにこういうことだ。sinatraをrequireするとトップレベルに書かれたgetは、あたかもSinatra::Baseクラスの中に書かれたように解釈されて、そこに定義されたクラスメソッドが呼ばれるのだ。

試しにSinatra::Base.getを再定義してその効果を見てみよう。
{% highlight ruby %}
irb(main):075:0> class Sinatra::Base
irb(main):076:1>   def self.get(path)
irb(main):077:2>     {path.intern => yield}
irb(main):078:2>   end
irb(main):079:1> end
=> nil
irb(main):080:0> get '/' do
irb(main):081:1*  "hello , world!"
irb(main):082:1> end
=> {:/=>"hello , world!"}
{% endhighlight %}
うまくいった。

つまりSinatraはほんとうはRubyそのものなんだけど、その構文のユルさとメタプログラミングを使って専用言語を装い、ユーザをその独自の世界に引き込むべく僕らをマインドコントロールしてたんだ！

もう僕はダマされないぞ！

関連記事：

1. [Sinatraに別構文があってもいいじゃないか！]({{ site.url }}/2011/06/05/Sinatra/)

2. [内部DSLを使って、RubyのWebフレームワークを書こう！]({{ site.url }}/2011/06/07/DSL-Ruby-Web/)

(comment)
> Try http://github.com/padrino/padrino-framework
>>Dexterさん<br>情報どうもです

{% footnotes %}
   {% fn http://www.eonet.ne.jp/~human-being/sub2.html %}
   {% fn http://ja.wikipedia.org/wiki/%E5%B0%82%E9%96%80%E7%94%A8%E8%AA%9E %}
   {% fn Objectクラスに定義されたメソッド %}
{% endfootnotes %}
