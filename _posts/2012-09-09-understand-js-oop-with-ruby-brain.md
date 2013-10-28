---
layout: post
title: "Ruby脳が理解するJavaScriptのオブジェクト指向"
description: ""
category: 
tags: [javascript, oop]
date: 2012-09-09
published: true
---
{% include JB/setup %}

(追記：2012-12-15)
本記事およびこれに続くその２，その３をまとめて電子書籍化しました。「[Gumroad](https://gumroad.com/ 'Gumroad')」を通して100円にて販売しています。内容についての追加・変更はありませんが、誤記の修正およびメディア向けの調整を行っています。

![JS OOP Ebook]({{ site.url }}/assets/images/2012/js_oop_cover.png)

<a href="http://gum.co/wNxf" class="gumroad-button">電子書籍「Ruby脳が理解するJavaScriptのオブジェクト指向」EPUB版 </a><script type="text/javascript" src="https://gumroad.com/js/gumroad-button.js"></script><script type="text/javascript" src="https://gumroad.com/js/gumroad.js"></script>


このリンクはGumroadにおける商品購入リンクになっています。クリックすると、オーバーレイ・ウインドウが立ち上がって、この場でクレジットカード決済による購入が可能です。購入にはクレジット情報およびメールアドレスの入力が必要になります。購入すると、入力したメールアドレスにコンテンツのDLリンクが送られてきます。

購入ご検討のほどよろしくお願いしますm(__)m

関連記事： [電子書籍「Ruby脳が理解するJavaScriptのオブジェクト指向」EPUB版をGumroadから出版しました！](http://localhost:4000/2012/12/15/javascript-oop-on-ebook/ '電子書籍「Ruby脳が理解するJavaScriptのオブジェクト指向」EPUB版をGumroadから出版しました！')

---


「世の中がRubyで埋まればいいのに」と思う僕の気持ちとは裏腹に、世界は一層多様で複雑なものに向かっています。エントロピーは日々増大しています。

人々は、その競争原理を指して**「多様性は善である」**といいます。しかし他者の意見が理解できたとき、その多様性は失われるのです。つまり多様性とは他者に対する不理解が継続する状態を言うのです。他者を理解したときに歩み寄りのプロセスは開始され、それは統合に向かって動き出します。

僕たちはハリウッド映画を見ても、韓国ドラマを見ても、それが日本人が演じるドラマを見たときの如くに、胸を詰まらせ同じ色の涙を流すのです。そこに流れるのは人々の感情を揺さぶる共通の体系であり思想です。多様なものは何もありません。

僕の脳は完全にRuby脳です。他言語の知識は無いと言っていいです。その結果、プログラム言語の世界が極めて多様に見えています。これは極めて不健全で、争いの種を生み出す危険な状態です。あまり時間はありませんが、何とかして僕はここから抜けださなければなりません。世界平和のためにも。

大げさですか？ええ、人を呼び込むためのプロローグとは大体そんなものなのです :)

そんなわけで...

Ruby脳の僕がJavaScriptのオブジェクト指向をここ数日学んだので、今の理解を書いておきます。当然に不理解に基づく間違いが含まれています。ご指摘助かります。なお、以下のコードの実行結果はnode v0.6.14のREPLにおける出力に基づいています。


## オブジェクトの生成
JavaScriptでのオブジェクトの生成は、Rubyのハッシュのような構文で行います。オブジェクトは一または複数のプロパティを持てます。プロパティとは、そのオブジェクトに紐付いたデータ（オブジェクトを含む）で、ラベルで参照できるものです。今、`name`と`age`というラベルで参照できるデータを持った２つのオブジェクトcharlie, earlを生成します。
{% highlight javascript %}
var charlie = {
  name: 'Charlie',
  age: 12
};

var earl = {
  name: 'Earl',
  age: 14
};

charlie.name; // 'Charlie'
charlie.age; // 12

earl.name; // 'Earl'
earl.age; // 14
{% endhighlight %}
各オブジェクトのプロパティに対するアクセスは、上述のようにRubyのメソッド呼び出しのような方法で、`.(ピリオド)`を使って行うことができます。

また、オブジェクトに対するプロパティの追加や変更は、変数に値を代入するが如くに極めて簡単に行えます{% fn_ref 1 %}。各オブジェクトに、生まれた日からの日数を計算する`ageInDays`プロパティを追加してみます。
{% highlight javascript %}
charlie.ageInDays = function() {
  return charlie.age * 365;
};

earl.ageInDays = function() {
  return earl.age * 365;
};

charlie.ageInDays(); // 4380

earl.ageInDays(); // 5110
{% endhighlight %}
Rubyと異なりJavaScriptにおいて関数（定義）はオブジェクトであり、このようにプロパティにセットできます{% fn_ref 2 %}。プロパティ名を介して参照される関数は、`()`(括弧)を付することで実行されます。従ってRubyと異なり`()`は必須です。以下ではプロパティにセットされた関数を`メソッド`と呼ぶことがあります。

未定義のプロパティの参照に対しては`undefined`が返されます。
{% highlight javascript %}
charlie.job; // undefined
{% endhighlight %}

## プロパティ探索
しかし一方で、未定義ながら特定のプロパティに対しては所定の値が返されます。`constructor`プロパティを呼んでみます。
{% highlight javascript %}
charlie.constructor; // [Function: Object]
{% endhighlight %}
charlieオブジェクトのコンストラクタはObject関数であるという結果が返ってきました。

未定義のプロパティが呼べたという事実をどう解釈すればいいでしょうか。可能性の一つはオブジェクトの生成時にJavaScriptが自動でそのようなプロパティをセットしたということです。

確かめてみます。
{% highlight javascript %}
charlie.hasOwnProperty('name'); // true
charlie.hasOwnProperty('constructor'); // false
charlie.hasOwnProperty('hasOwnProperty'); // false
{% endhighlight %}

`hasOwnProperty`メソッドに対して、上で定義した`name`はtrueを返しましたが、`constructor`およびこの呼び出しメソッド自体もfalseを返しました。つまりこれらのプロパティはcharlieオブジェクトには存在しないのです。

つまりcharlieオブジェクトにはそのプロパティ探索に関して、別のオブジェクトがリンクされているのです。この別のオブジェクトは`__proto__`プロパティで参照できます{% fn_ref 3 %}。
{% highlight javascript %}
charlie.__proto__; // {}
{% endhighlight %}
`{}`、つまり空のオブジェクトがcharlieオブジェクトにリンクしていることが分かりました。このオブジェクトをJavaScriptではプロトタイプオブジェクトといいます。Rubyにおけるサブクラスに対するスーパークラスの呼び方のようなものですね。では、このオブジェクトが先のプロパティを持っているかを確かめてみます。

{% highlight javascript %}
charlie.__proto__.hasOwnProperty('constructor') // true
charlie.__proto__.hasOwnProperty('hasOwnProperty') // true
{% endhighlight %}
trueが返ってきました。ビンゴです。

以上により、オブジェクトのプロパティが呼ばれたとき、そのオブジェクトに対象プロパティがあればそれを返すが、無い場合は\_\_proto\_\_プロパティにセットされたオブジェクトのプロパティを探索する。そして対象プロパティがそこにあればそれを返すということが分かりました。

ここで仮に、プロトタイプオブジェクトにも対象プロパティが見つからなかった場合はどうなるのでしょうか。これは想像が付きますよね。プロトタイプオブジェクトもcharlieオブジェクトと同種のオブジェクトですから、\_\_proto\_\_プロパティを持ってるはずです。よって、ここから更にその先のオブジェクトを辿るのでしょう。charlieの先の先、つまりそのプロトタイプオブジェクトの\_\_proto\_\_にセットされたオブジェクトを見てみましょう。

{% highlight javascript %}
charlie.__proto__.__proto__ // null
{% endhighlight %}
\_\_proto\_\_プロパティは存在したものの、期待に反して`null`が返ってきました。つまりこの場合、プロパティ探索の旅（プロトタイプチェーン）はここで終了ということですね。

## プロトタイプチェーンを使う
さて、この辺で最初のコードに戻ります。
{% highlight javascript %}
var charlie = {
  name: 'Charlie',
  age: 12
};

charlie.ageInDays = function() {
  return charlie.age * 365;
};

var earl = {
  name: 'Earl',
  age: 14
};

earl.ageInDays = function() {
  return earl.age * 365;
};

charlie.name; // 'Charlie'
charlie.age; // 12
charlie.ageInDays(); // 4380

earl.name; // 'Earl'
earl.age; // 14
earl.ageInDays(); // 5110
{% endhighlight %}
このコードを見て、ムズムズしない人はいないでしょう。そう`ageInDays`メソッドがDRY原則に反しています。その結果どういった問題が生じるでしょう。

仮に、銀河の歪みによって地球の公転周期が今の３倍、つまり１年が365*3=1095日になったらどうなりますか？その場合、あなたはすべての人オブジェクトのageInDaysメソッドを１つづつ修正しなければなりません{% fn_ref 4 %}。

先ほどのプロパティ探索の機構を利用してこの問題を解決します。つまり人の原型となる`person`オブジェクトを定義してプロトタイプチェーンに組み込むのです。
{% highlight javascript %}
var person = {
  name: 'unknown',
  age: 1,
  ageInDays: function() {
    return person.age * 365 * 3;
  }
}

person.name; // 'unknown'
person.age; // 1
person.ageInDays(); // 1095
{% endhighlight %}

personオブジェクトが生成できました。これをcharlie, earlの各オブジェクトのプロトタイプとなるよう、それらの`__proto__`プロパティにセットして、ageInDaysを呼んでみます。

{% highlight javascript %}
charlie.__proto__ = person;
earl.__proto__ = person;

charlie.ageInDays(); // 4380
earl.ageInDays(); // 5110
{% endhighlight %}
結果に変化がありません。残念ながら失敗しています。原因はなんでしょう。

そうでした、charlie,earlの各オブジェクトに直接定義したageInDaysメソッドがまだ生きていたのでした。これらを削除してもう一度呼んでみます。
{% highlight javascript %}
delete charlie.ageInDays; // true
delete earl.ageInDays; // true

charlie.ageInDays(); // 1095
earl.ageInDays(); // 1095
{% endhighlight %}
数値に変化がありましたが、なんか計算がおかしいですね。原因は何でしょう。

もう一度personオブジェクトを見てみます。
{% highlight javascript %}
var person = {
  name: 'unknown',
  age: 1,
  ageInDays: function() {
    return person.age * 365 * 3;
  }
}
{% endhighlight %}
もう分かりました。ageInDaysでperson.ageを呼んでいたのが原因でした。ここは呼び出し元、つまりcharlieまたはearlのageが呼ばれなければいけません。

こういうときのためにJavaScriptには`this`という便利なキーワードがあります。`this`は呼び出し元のオブジェクトを差します。Rubyにおける`self`のようなものですね。

早速、`this`を使ってperson.ageInDaysを書き換えます。
{% highlight javascript %}
person.ageInDays = function() {
  return this.age * 365 * 3;
};

charlie.ageInDays(); // 13140
earl.ageInDays(); // 15330
{% endhighlight %}
今度こそうまくいきました。


プロトタイプチェーンがどう変化したか確認してみます。
{% highlight javascript %}
charlie.__proto__ // { name: 'unknown',
                  //   age: 1,
                  //   ageInDays: [Function] }

charlie.__proto__.__proto__ // {}

charlie.__proto__.__proto__.__proto__ // null
{% endhighlight %}
見事にpersonオブジェクトが間に差し込まれています。

## オブジェクトコンストラクタ
さて、引き続きpersonを型とする別のオブジェクトを生成してみます。
{% highlight javascript %}
var person = {
  name: 'unknown',
  age: 1,
  ageInDays: function() {
    return this.age * 365 * 3;
  }
};

var zena = {
  name: 'Zena',
  __proto__: person
};

var rio = {
  name: 'Rio',
  age: 18,
  __proto__: person
};

var jackie = {
  name: 'Jackie',
  age: 21,
  __proto__: person
};

zena.name; // 'zena'
zena.age; // 1
zena.ageInDays(); // 1095

rio.name; // 'Rio'
rio.age; // 18
rio.ageInDays(); // 19710

jackie.name; // 'Jackie'
jackie.age; // 21
jackie.ageInDays(); // 22995
{% endhighlight %}
クラスベースのオブジェクト指向に慣れたRuby脳の僕にとって、このオブジェクト生成プロセスは面倒に感じられます。もっと簡便にオブジェクトを生成する方法はないでしょうか。

JavaScriptの関数が使えそうです。そう関数でオブジェクトのコンストラクタを作るのです。nameとageを引数にとって、これらをプロパティとしたオブジェクトを返す、そんな関数です。コンストラクタらしく、大文字から始まるPersonコンストラクタを定義します。
{% highlight javascript %}
function Person (name, age) {
  var proto = {
    ageInDays: function() { return this.age * 365 * 3; }
  };
  var obj = { name: name, age: age };
  obj.__proto__ = proto;
  return obj;
};
{% endhighlight %}
ここでの重要なポイントは、ageInDaysプロパティを持ったプロトタイプオブジェクト（proto）を生成し、返されるオブジェクトの\_\_proto\_\_にこれをセットすることです。これで先のコードとほぼ同様{% fn_ref 5 %}のオブジェクトをコンストラクタを使って生成できそうです。

やってみます。
{% highlight javascript %}
var zena = Person('Zena', 1);
var rio = Person('Rio', 18);
var jackie = Person('Jackie', 21);

zena.name; // 'Zena'
zena.age; // 1
zena.ageInDays(); // 1095

rio.name; // 'Rio'
rio.age; // 18
rio.ageInDays(); // 19710

jackie.name; // 'Jackie'
jackie.age; // 21
jackie.ageInDays(); // 22995
{% endhighlight %}
いいですね。

...

と言いたいところですが、先のコンストラクタには問題があります。

今、地球に小惑星が衝突してその公転周期が更に２倍、つまり１年が365\*3\*2=2190日になったとします。結果PersonコンストラクタのageInDaysを再定義する必要が生じました。さてどうやってageInDaysを再定義しましょうか。ageInDaysを持ったオブジェクトはPersonコンストラクタ内のローカル変数で保持されているので、直接アクセスできません。でも、生成した特定のオブジェクト（例えばzena）の\_\_proto\_\_からアクセスできそうですね。やってみます。

{% highlight javascript %}
zena.__proto__.ageInDays = function() {
  return this.age * 365 * 3 * 2;
};
{% endhighlight %}
正しく再定義されたか確かめてみます。

{% highlight javascript %}
zena.ageInDays(); // 2190
rio.ageInDays(); // 19710
jackie.ageInDays(); // 22995
{% endhighlight %}

確かにzenaの結果は倍になりましたが、他のオブジェクトの結果に変化はありません。何が問題でしょうか。もう一度Personコンストラクタの定義を見てみます。

{% highlight javascript %}
function Person (name, age) {
  var proto = {
    ageInDays: function() { return this.age * 365 * 3; }
  };
  var obj = { name: name, age: age };
  obj.__proto__ = proto;
  return obj;
};
{% endhighlight %}
あー、ダメな理由がわかりました。

これではPersonが実行される度にプロトタイプオブジェクトprotoが作成されてしまいます。つまりPersonで生成される各オブジェクトの\_\_proto\_\_にはそれぞれ別のプロトタイプオブジェクトがセットされてしまうのです。

確認してみます。
{% highlight javascript %}
rio.__proto__ == zena.__proto__ // false
zena.__proto__ == jackie.__proto__ // false
rio.__proto__ == jackie.__proto__ // false
{% endhighlight %}
やはり別のオブジェクトでした。

ではどうすればいいでしょうか。

そう、各オブジェクトのプロトタイプオブジェクトをPersonに紐付ければいいのです。つまりプロトタイプオブジェクトをPersonの任意のプロパティにセットし、これを参照させればいいのです。やってみます。
{% highlight javascript %}
function Person (name, age) {
  if (!Person.proto) {
    Person.proto = { ageInDays: function() { return this.age * 365 * 3; } };
  };
  var obj = { name: name, age: age };
  obj.__proto__ = Person.proto;
  return obj;
};
{% endhighlight %}
ageInDaysメソッドを持ったオブジェクトをPerson.protoプロパティにセットし、このプロパティを各オブジェクトの\_\_proto\_\_にセットします。一応、Person.protoがセットされている場合はif文で無駄な処理が繰り返されないようにします。

さあもう一度オブジェクトを生成して試してみます。
{% highlight javascript %}
var zena = Person('Zena', 1);
var rio = Person('Rio', 18);
var jackie = Person('Jackie', 21);

zena.name; // 'Zena'
zena.age; // 1
zena.ageInDays(); // 1095

rio.name; // 'Rio'
rio.age; // 18
rio.ageInDays(); // 19710

jackie.name; // 'Jackie'
jackie.age; // 21
jackie.ageInDays(); // 22995
{% endhighlight %}

プロトタイプオブジェクトのageInDaysメソッドを書き換えて、再度各オブジェクトから呼んでみます。
{% highlight javascript %}
Person.proto.ageInDays = function() {
  return this.age * 365 * 3 * 2;
};

zena.ageInDays(); // 2190
rio.ageInDays(); // 39420
jackie.ageInDays(); // 45990
{% endhighlight %}
今度はうまくいきました。

念のため各オブジェクトが共通のプロトタイプを参照しているか確認します。
{% highlight javascript %}
rio.__proto__ == zena.__proto__ // true
zena.__proto__ == jackie.__proto__ // true
rio.__proto__ == jackie.__proto__ // true
{% endhighlight %}
いいですね。


## new 演算子
ここまで来れば僕が何を言いたいのかが分かると思います。

「それ、`new`演算子でできるよ！」ってことですね。

new演算子には関数コンストラクタを渡しますが、通常の関数の書き方でない特殊な構文の関数を構築して渡します。つまりクラスベースのオブジェクト指向におけるクラスをイミテートした構文の関数を使います。先のPerson関数と等価の関数コンストラクタは次のようになります。

{% highlight javascript %}
function Person (name, age) {
  this.name = name,
  this.age = age,
};

Person.prototype.ageInDays = function() {
  return this.age * 365;
}
{% endhighlight %}
確かにクラスっぽい。

関数コンストラクタ（これも当然オブジェクトです）には、それ専用の`prototype`という名のプロパティが用意されています。既定でここには空のオブジェクトがセットされています。関数をnewすることにより、そこから生成される各オブジェクトの\_\_proto\_\_プロパティにはコンストラクタのprototypeプロパティがセットされます。また、コンストラクタ内の`this`ですが、これは生成される各オブジェクトを指すようになるのです。それが`new`の機能です。

さあPersonコンストラクタをnewしてオブジェクトを生成してみましょう。
{% highlight javascript %}
var charlie = new Person('Charlie', 12);
var earl = new Person('Earl', 14);
 
charlie.name; // 'Charlie'
charlie.age; // 12
charlie.ageInDays(); // 4380

earl.name; // 'Earl'
earl.age; // 14
earl.ageInDays(); // 5110

Person.prototype.ageInDays = function() { return this.age * 365 * 3; };

charlie.ageInDays(); // 13140
earl.ageInDays(); // 15330
{% endhighlight %}
いいですね！

関数コンストラクタの注意点は、これはあくまで関数であり、newが無くても呼べてしまうということです。この場合、上記newの機能は働きません。つまり関数内部の`this`はオブジェクトを指すのではなく（オブジェクトが生成されないので当然です）、その呼び出し環境すなわち`グローバルオブジェクト`を指すことになるのです。そのリスクから**「newは良くない部品」**と言う意見もあるようです。


「継承」「Object.create」などについての説明が欠落していますが、JavaScriptのオブジェクト指向に対する僕の理解は今のところここまでです。最後までありがとうございますm(__)m

---

![JS OOP Ebook]({{ site.url }}/assets/images/2012/js_oop_cover.png)

<a href="http://gum.co/wNxf" class="gumroad-button">電子書籍「Ruby脳が理解するJavaScriptのオブジェクト指向」EPUB版 </a><script type="text/javascript" src="https://gumroad.com/js/gumroad-button.js"></script><script type="text/javascript" src="https://gumroad.com/js/gumroad.js"></script>


このリンクはGumroadにおける商品購入リンクになっています。クリックすると、オーバーレイ・ウインドウが立ち上がって、この場でクレジットカード決済による購入が可能です。購入にはクレジット情報およびメールアドレスの入力が必要になります。購入すると、入力したメールアドレスにコンテンツのDLリンクが送られてきます。

----

(追記：2012-09-11) 関連記事書きました。

[JavaScript脳で理解するRubyのオブジェクト指向](http://melborne.github.com/2012/09/11/understand-ruby-oop-with-js-brain/ 'JavaScript脳で理解するRubyのオブジェクト指向')

(追記：2012-09-15) 続きを書きました。

[Ruby脳が理解するJavaScriptのオブジェクト指向（その２）](http://melborne.github.com/2012/09/15/understand-js-oop-with-ruby-brain-2/ 'Ruby脳が理解するJavaScriptのオブジェクト指向（その２）')
____



{% footnotes %}
  {% fn 変数はグローバルオブジェクトのプロパティです。 %}
  {% fn もちろんRubyにはProcやMethodオブジェクトがあるので同じことができます。 %}
  {% fn __proto__は非標準プロパティです %}
  {% fn ここでの日数計算は過去に遡って適用されるものとします。 %}
  {% fn personコンストラクタではname, ageのデフォルトを提供していません。 %}
{% endfootnotes %}


