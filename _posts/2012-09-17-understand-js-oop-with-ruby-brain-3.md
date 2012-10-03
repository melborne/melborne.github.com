---
layout: post
title: "Ruby脳が理解するJavaScriptのオブジェクト指向（その３）"
description: ""
category: 
tags: [javascript, oop]
date: 2012-09-17
published: true
---
{% include JB/setup %}

「[Ruby脳が理解するJavaScriptのオブジェクト指向](http://melborne.github.com/2012/09/09/understand-js-oop-with-ruby-brain/ 'Ruby脳が理解するJavaScriptのオブジェクト指向'){% hatebu http://melborne.github.com/2012/09/09/understand-js-oop-with-ruby-brain/ %}」および「[Ruby脳が理解するJavaScriptのオブジェクト指向（その２）](http://melborne.github.com/2012/09/15/understand-js-oop-with-ruby-brain-2/ 'Ruby脳が理解するJavaScriptのオブジェクト指向（その２）'){% hatebu http://melborne.github.com/2012/09/15/understand-js-oop-with-ruby-brain-2/ %}」の続きです。

----

引き続きJavaScriptにおける**「Object.create」**について学んだので、自分の理解を書いてみます。当然に、間違いが含まれています。ご指摘助かります。

    [注意事項！]はっきり言ってRubyはもう全然関係ない記事になっています。記事のタイトルにおける「Ruby脳が」を「僕が」に置換して、納得された上で以下の記事をお楽しみ下さいm(__)m

## new 演算子問題に対する解決策を考える
JavaScriptにおいて同種のオブジェクトを複数生成するには、クラス風記法のコンストラクタ関数とnew演算子の組合せを利用するのが便利だと学びました。その一方で、この特殊コンストラクタはnewを忘れると深刻なバグを生むという問題が指摘されています。ここではこの問題の解決策を考えてみます。「newを使うな！」というのは簡単ですが、なんらかの代替案が必要です。

最も単純で効果的な策は、特殊コンストラクタとnew演算子をラップする関数を用意して、ユーザはこの関数を使ってオブジェクトを生成するようにすることでしょう。この関数を使う限り、ユーザがnewを付け忘れてコンストラクタ内のプロパティがグローバルな世界を汚染するというリスクはなくなります。


前回作ったiPhone5コンストラクタをベースとして、これを改良しつつ目的の関数を構築します。まずはiPhone5コンストラクタを再掲します。
{% highlight javascript %}
function iPhone5 (id, name) {
  this.id = id;
  this.name = name;
};

iPhone5.prototype = {
  call: function(number) {
    return "Calling to " + number + " ...";
  },
  iTunes: function(title, artist) {
    return "Playing: => `" + title + "` of " + artist;
  },
  camera: function() {
    return this.name + " Take a Photo!";
  },
  panorama: function() {
    return this.name + " Take a Panorama Photo!!";
  }
};

var jonathan = new iPhone5(12345, 'Jonathan');
var scott = new iPhone5(12346, 'Scott');

jonathan.id; // 12345
jonathan.name; // 'Jonathan'
jonathan.call('800-692-7753'); // 'Calling to 800-692-7753 ...'
jonathan.iTunes('Imagine', 'John Lennon'); // 'Playing: => `Imagine` of John Lennon'
jonathan.panorama(); // 'Jonathan Take a Panorama Photo!!'

scott.id; // 12346
scott.name; // 'Scott'
scott.call('800-275-2273'); // 'Calling to 800-275-2273 ...'
scott.iTunes('My Hero', 'Foo Fighters'); // 'Playing: => `My Hero` of Foo Fighters'
scott.panorama(); // 'Scott Take a Panorama Photo!!'
{% endhighlight %}
`new`演算子を使ってiPhone5コンストラクタから２つのオブジェクトを生成しています。もうコードの説明は不要ですよね。

## ラッパー関数
さて、まずは何も考えずにこのコンストラクタとnew演算子を関数でラップしてみます。関数名は`iPhone5Create`にしましょう。

{% highlight javascript %}
function iPhone5Create (id, name) {
  function iPhone5 (id, name) {
    this.id = id;
    this.name = name;
  };

  iPhone5.prototype = {
    call: function(number) {
      return "Calling to " + number + " ...";
    },
    iTunes: function(title, artist) {
      return "Playing: => `" + title + "` of " + artist;
    },
    camera: function() {
      return this.name + " Take a Photo!";
    },
    panorama: function() {
      return this.name + " Take a Panorama Photo!!";
    }
  };
  return new iPhone5(id, name);
};
{% endhighlight %}
特に難しいことは何もありません。iPhone5Create関数で受けた引数をiPhone5コンストラクタに引き渡すだけです。ではiPhone5Createに引数を渡して、先程と同様に２つのオブジェクトを生成してみます。

{% highlight javascript %}
var jonathan = iPhone5Create(12345, 'Jonathan');
var scott = iPhone5Create(12346, 'Scott');

jonathan.id; // 12345
jonathan.name; // 'Jonathan'
jonathan.call('800-692-7753'); // 'Calling to 800-692-7753 ...'
jonathan.iTunes('Imagine', 'John Lennon'); // 'Playing: => `Imagine` of John Lennon'
jonathan.panorama(); // 'Jonathan Take a Panorama Photo!!'

scott.id; // 12346
scott.name; // 'Scott'
scott.call('800-275-2273'); // 'Calling to 800-275-2273 ...'
scott.iTunes('My Hero', 'Foo Fighters'); // 'Playing: => `My Hero` of Foo Fighters'
scott.panorama(); // 'Scott Take a Panorama Photo!!'
{% endhighlight %}
うまくいきました。

この時点でユーザがiPhone5コンストラクタをnewする場合と大きく異なるのは、ユーザはもはやiPhone5コンストラクタにアクセス出来ないという点です。その結果、new無しでiPhone5コンストラクタを呼んでしまうというリスクは消えました。確かめてみます。
{% highlight javascript %}
iPhone5 // ReferenceError: iPhone5 is not defined

var jonathan = iPhone5Create(12345, 'Jonathan');
jonathan.name; // 'Jonathan'

iPhone5 // ReferenceError: iPhone5 is not defined
{% endhighlight %}

## ラッパー関数の一般化
現状、ラッパー関数`iPhone5Create`はその名の通り、iPhone5オブジェクトしか生成できません。JavaScriptのあらゆるユーザがnewにタッチしなくていいようにするためには、これを一般化する必要があります。

そのための第一歩として、コンストラクタ関数の`prototype`プロパティにセットされるオブジェクトを、引数を通して渡せるようにしてみます。一般化のためにラッパー関数名を`ObjectCreate`、コンストラクタ関数名を`F`としましょう。
{% highlight javascript %}
function ObjectCreate (base, id, name) {
  function F (id, name) {
    this.id = id;
    this.name = name;
  };

  F.prototype = base;
  return new F(id, name);
};
{% endhighlight %}

大分シンプルになりました。

さあ、ObjectCreate関数に渡すiPhone5オブジェクトを用意して、もう一度ここから２つのオブジェクトを生成してみます。
{% highlight javascript %}
var iPhone5 = {
  call: function(number) {
    return "Calling to " + number + " ...";
  },
  iTunes: function(title, artist) {
    return "Playing: => `" + title + "` of " + artist;
  },
  camera: function() {
    return this.name + " Take a Photo!";
  },
  panorama: function() {
    return this.name + " Take a Panorama Photo!!";
  }
};

var jonathan = ObjectCreate(iPhone5, 12345, 'Jonathan');
var scott = ObjectCreate(iPhone5, 12346, 'Scott');

jonathan.id; // 12345
jonathan.name; // 'Jonathan'
jonathan.call('800-692-7753'); // 'Calling to 800-692-7753 ...'
jonathan.iTunes('Imagine', 'John Lennon'); // 'Playing: => `Imagine` of John Lennon'
jonathan.panorama(); // 'Jonathan Take a Panorama Photo!!'

scott.id; // 12346
scott.name; // 'Scott'
scott.call('800-275-2273'); // 'Calling to 800-275-2273 ...'
scott.iTunes('My Hero', 'Foo Fighters'); // 'Playing: => `My Hero` of Foo Fighters'
scott.panorama(); // 'Scott Take a Panorama Photo!!'
{% endhighlight %}
これもうまくいきました。

さて現状ObjectCreateに渡すプロパティは`id`、`name`固定になっています。これを一般化する必要があります。最も単純な方法は、ObjectCreate関数ではプロパティの設定を行わないようにし、ObjectCreateの実行後、生成されたオブジェクトに対してプロパティ設定を直接行う方法です。

やってみます。ObjectCreate関数を直します。
{% highlight javascript %}
function ObjectCreate (base) {
  function F () {  };
  F.prototype = base;
  return new F;
};
{% endhighlight %}
ObjectCreate関数はベースとなるオブジェクトを取るだけの極めてシンプルなものになりました。

オブジェクトを生成してから`id`と`name`プロパティを設定するんでしたね。
{% highlight javascript %}
var jonathan = ObjectCreate(iPhone5);
jonathan.id = 12345;
jonathan.name = 'Jonathan';

var scott = ObjectCreate(iPhone5);
scott.id = 12346;
scott.name = 'Scott';

jonathan.id; // 12345
jonathan.name; // 'Jonathan'
jonathan.call('800-692-7753'); // 'Calling to 800-692-7753 ...'
jonathan.iTunes('Imagine', 'John Lennon'); // 'Playing: => `Imagine` of John Lennon'
jonathan.panorama(); // 'Jonathan Take a Panorama Photo!!'

scott.id; // 12346
scott.name; // 'Scott'
scott.call('800-275-2273'); // 'Calling to 800-275-2273 ...'
scott.iTunes('My Hero', 'Foo Fighters'); // 'Playing: => `My Hero` of Foo Fighters'
scott.panorama(); // 'Scott Take a Panorama Photo!!'
{% endhighlight %}
うまくいきました。

別の種類のオブジェクトも生成してみます。
{% highlight javascript %}
var Twitter = {
  tweet: function(words) {
    return this.account + ": " + words;
  },
  retweet: function(at, words) {
    return "@" + at + ": " + words;
  }
};

var charlie = ObjectCreate(Twitter);
charlie.account = 'charlie';

charlie.tweet('JavaScriptなう!'); // 'charlie: JavaScriptなう!'
charlie.retweet('earl', 'JSのOOPって難しくね？'); // '@earl: JSのOOPって難しくね？'
{% endhighlight %}
いいですね！

## プロパティを取れるようにする
ただ、ここまで来たらやっぱりObjectCreateに初期化プロパティを渡せるようにしたいです。

ObjectCreateの第２引数に、プロパティ情報を持ったオブジェクトを渡してこれを返されるオブジェクトにセットするようにしてみます。

{% highlight javascript %}
function ObjectCreate (base, properties) {
  function F () {  };
  F.prototype = base;
  var obj = new F;
  for(var prop in properties) {
    obj[prop] = properties[prop];
  };
  return obj;
};
{% endhighlight %}
`for...in`を使って返されるオブジェクトにプロパティをセットします。

試してみます。
{% highlight javascript %}
var jonathan = ObjectCreate(iPhone5, { id: 12345, name: 'Jonathan' });
var scott = ObjectCreate(iPhone5, { id: 12346, name: 'Scott' });

jonathan.id; // 12345
jonathan.name; // 'Jonathan'
jonathan.call('800-692-7753'); // 'Calling to 800-692-7753 ...'
jonathan.iTunes('Imagine', 'John Lennon'); // 'Playing: => `Imagine` of John Lennon'
jonathan.panorama(); // 'Jonathan Take a Panorama Photo!!'

scott.id; // 12346
scott.name; // 'Scott'
scott.call('800-275-2273'); // 'Calling to 800-275-2273 ...'
scott.iTunes('My Hero', 'Foo Fighters'); // 'Playing: => `My Hero` of Foo Fighters'
scott.panorama(); // 'Scott Take a Panorama Photo!!'


var charlie = ObjectCreate(Twitter, { account: 'charlie' });

charlie.tweet('JavaScriptなう!'); // 'charlie: JavaScriptなう!'
charlie.retweet('earl', 'JSのOOPって難しくね？'); // '@earl: JSのOOPって難しくね？'
{% endhighlight %}
成功です！


## Object.createメソッド
ここまで来れば僕が何を言いたいのかが分かると思います。

「それ、`Object.create`メソッドでできるよ！」ってことですね。

`Object.create`メソッドは、先のObjectCreate関数と同様に、その第２引数にプロパティを取れますが、より細かい指定ができるようになっています。つまり各プロパティのアクセス属性をここでコントロールできるようになるのです。

`Object.create`を使って、上記と同じオブジェクトを生成してみましょう。
{% highlight javascript %}
var jonathan = Object.create(iPhone5, { id: { value: 12345 }, name: { value: 'Jonathan' }});
var scott = Object.create(iPhone5, { id: { value: 12346 }, name: { value: 'Scott' }});

jonathan.id; // 12345
jonathan.name; // 'Jonathan'
jonathan.call('800-692-7753'); // 'Calling to 800-692-7753 ...'
jonathan.iTunes('Imagine', 'John Lennon'); // 'Playing: => `Imagine` of John Lennon'
jonathan.panorama(); // 'Jonathan Take a Panorama Photo!!'

scott.id; // 12346
scott.name; // 'Scott'
scott.call('800-275-2273'); // 'Calling to 800-275-2273 ...'
scott.iTunes('My Hero', 'Foo Fighters'); // 'Playing: => `My Hero` of Foo Fighters'
scott.panorama(); // 'Scott Take a Panorama Photo!!'


var charlie = Object.create(Twitter, { account: { value: 'charlie' }});

charlie.tweet('JavaScriptなう!'); // 'charlie: JavaScriptなう!'
charlie.retweet('earl', 'JSのOOPって難しくね？'); // '@earl: JSのOOPって難しくね？'
{% endhighlight %}
第２引数におけるプロパティ値の渡し方が少し異なっています。ここには、`value`の他、`writable`（書き込み可否）、`configurable`（再設定可否）、`enumerable`（for..in可否）などの各プロパティに対する属性指定子を渡せます。デフォルトではこれらは`false`にセットされます。これによりJavaScriptのオブジェクトが、より本来のオブジェクトっぽい挙動になります。

## オブジェクト関係図の比較
最後に、コンストラクタ関数 + `new`演算子を使ってオブジェクトを生成する場合と、`Object.create`を使って生成する場合における、オブジェクトの関係図を比較してみます。

まずはコンストラクタ関数 + new演算子の場合。

![JS prototype chain noshadow]({{ site.url }}/assets/images/js_proto01.png)

次に、Object.createの場合。

![JS prototype chain noshadow]({{ site.url }}/assets/images/js_create01.png)

見ての通り、基本的なプロトタイプチェーン構造は同じです。上で説明した通りObject.createは、特殊コンストラクタ + new演算子をラップしたものに過ぎないとも言えるので、当然といえば当然です。しかしながら、次の３点で相違があります。

> 1. コンストラクタ関数 + new演算子の場合、プロトタイプオブジェクトにはコンストラクタ関数を介してしかアクセスできないのに対して{% fn_ref 1 %}、Object.createの場合はアクセスできる。つまり前者ではプロトタイプオブジェクトとコンストラクタ関数は密結合されるが、後者でそれらは疎結合である。
> 2. コンストラクタ関数 + new演算子の場合、ユーザがコンストラクタ関数に自由にアクセスできるのに対して、Object.createの場合はアクセスできない。
> 3. Object.createではオブジェクトの生成時に、各プロパティの属性情報をコントロールできる。

以上、`Object.create`に対する現在の僕の理解を書いてみました。最後までありがとうございます。

----

{{ 4873113911 | amazon_medium_image }}
{{ 4873113911 | amazon_link }} by {{ 4873113911 | amazon_authors }}

{% footnotes %}
{% fn 事前に変数代入などすればこの限りではありません。 %}
{% endfootnotes %}
