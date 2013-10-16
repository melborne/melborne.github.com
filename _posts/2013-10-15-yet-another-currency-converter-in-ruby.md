---
layout: post
title: "やっぱり通貨換算もターミナルでしたいよね - Google Currency APIをRubyで使う"
description: ""
category: 
tags: 
date: 2013-10-15
published: true
---
{% include JB/setup %}

Web上には無数の通貨換算ツールがあるけれどもやっぱりターミナル上で簡単に通貨換算できたらうれしいよね。

で手頃なAPIはないかと探していたら次の記事にであったんだ。

> [Google's Currency Converter and JSON API](http://motyar.blogspot.jp/2011/12/googles-currency-converter-and-json-api.html "Google's Currency Converter and JSON API")

記事によればGoogleが通貨換算のJSON APIを非公式で公開してるそうだよ（ちょっとそのJSON壊れてるようなんだけれども..）。

それでRubyで実装された通貨換算ツールがいろいろあることを承知のうえでまあ何事も勉強だからということでターミナルで簡単に利用できるもう一つの通貨換算ツールを作ったから公開するよ。

>[melborne/money_exchange](https://github.com/melborne/money_exchange "melborne/money_exchange")
>
>[money_exchange | RubyGems.org | your community gem host](https://rubygems.org/gems/money_exchange "money_exchange | RubyGems.org | your community gem host")

一応gemにもしたから`gem i money_exchange`でインストールもできるよ。

## ターミナルでの使い方

`MoneyExchange`をインストールすると`money_exchange`ってコマンドが使えるようになるよ。でこれを実行すると次のようなヘルプメッセージがでるよ。

{% highlight bash %}
% money_exchange
Commands:
  money_exchange ex AMOUNT BASE *TARGETS  # Currency Exchange from base to targets
  money_exchange help [COMMAND]           # Describe available commands or one specific command
  money_exchange version                  # Show MoneyExchange version

Available currency codes:
  AUD: Australian dollar
  CAD: Canadian dollar
  CHF: Swiss franc
  CNY: Chinese yuan
  DKK: Danish krone
  EUR: Euro
  GBP: British pound
  HKD: Hong Kong dollar
  HUF: Hungarian forint
  INR: Indian rupee
  JPY: Japanese yen
  MXN: Mexican peso
  NOK: Norwegian krone
  NZD: New Zealand dollar
  PLN: Polish złoty
  SEK: Swedish krona
  SGD: Singapore dollar
  TRY: Turkish lira
  USD: United States Dollar
  ZAR: South African rand
{% endhighlight %}

でヘルプにしたがって`ex`コマンドに続いて金額とコードを入れれば結果が出力されるよ。

{% highlight bash %}
% money_exchange ex 1 usd jpy
USD 1  => JPY 98.65

% money_exchange ex 1 usd jpy eur gbp
USD 1  => JPY 98.65
          EUR 0.74
          GBP 0.63
{% endhighlight %}

コマンドライン・パーサーには「[Thor](https://github.com/erikhuda/thor "erikhuda/thor")」を使ってるんだけどこれ便利だからもし使ったことなければオススメするよ。

## Rubyでの使い方

`money_exchange`をrequireするとFixnumとStringに`#xxx_to_yyy`と`#xxx_to`というメソッドが追加されるよ。`xxx`, `yyy`には通貨コードが入るよ。

{% highlight ruby %}
% irb -rmoney_exchange
IRB on Ruby2.0.0
>> 1.usd_to_jpy #=> 98.65
>> '1'.usd_to_jpy #=> 98.65
>> 1.usd_to(:jpy, :eur, :gbp) #=> [98.65, 0.74, 0.63]
{% endhighlight %}


## MoneyExchangeの実装

実はGoogleのAPIがどの通貨に対応しているかは分かってなくて先に上げたもの以外でも呼び出せる可能性があるよ。MoneyExchangeではユーザが投げたコードをそのままAPIに投げる構造になっているよ。悪しき習慣`method_missing`フックを使ってるんだ ;-(

{% highlight ruby %}
module MoneyExchange

  # Presume '#xxx_to' style methods as for money exchanges
  def method_missing(meth, *a, &b)
    case meth
    when /^([a-z]{3})_to_([a-z]{3})$/
      currency, target = $~.captures
      Money.new(self, currency).send("to_#{target}")
    when /^([a-z]{3})_to$/
      currency, targets = $~[1], a
      targets.map { |t| Money.new(self, currency).send("to_#{t}") }
    else
      super
    end
  end

  class Money
    attr_reader :amount, :currency
    def initialize(amount, currency)
      @amount = Float(amount)
      @currency = currency
    end
    
    def method_missing(meth, *a, &b)
      case meth
      when /^to_([a-z]{3})$/
        Exchange.calc(self, $~[1])
      else
        super
      end
    end
  end

  class Exchange
    class NoCurrencyDataError < StandardError; end

    class << self
      def calc(money, target)
        res = money.amount * rate(money.currency, target)
        (res * 100).round.to_f / 100
      end

      private
      def rate(base, target)
        response = call_google_currency_api(base, target)
        rate = parse_rate(response)
      end
      
      def parse_rate(response)
        body = JSON.parse(fix_json response)

        if ['0', ''].include?(body['error']) # when no error
          body['rhs'].split(',')[0].to_f
        else
          raise NoCurrencyDataError
        end
      end

      # Because Google Currency API returns a broken json.
      def fix_json(json)
        json.gsub(/(\w+):/, '"\1":')
      end

      def call_google_currency_api(base, target)
        uri = "http://www.google.com/ig/calculator"
        query = "?hl=en&q=1#{base}=?#{target}"
        URI.parse(uri+query).read
      rescue OpenURI::HTTPError => e
        abort "HTTP Access Error:#{e}"
      end
    end
  end
end

class Numeric
  include MoneyExchange
end

class String
  include MoneyExchange
end
{% endhighlight %}

GoogleのこのAPIも僕のコードも信用ならないから真面目な用途には使えないけどターミナルでちょっとレートをってときに便利に使ってくれたらうれしいよ。


>[melborne/money_exchange](https://github.com/melborne/money_exchange "melborne/money_exchange")
>
>[money_exchange | RubyGems.org | your community gem host](https://rubygems.org/gems/money_exchange "money_exchange | RubyGems.org | your community gem host")


---

<p style='color:red'>=== Ruby関連電子書籍100円で好評発売中！ ===</p>

[M'ELBORNE BOOKS]({{ BASE_PATH }}/books/ "M'ELBORNE BOOKS")

<a href="{{ BASE_PATH }}/books/">
  <img src="/assets/images/2013/02/ruby_object_cover.png" alt="ruby_object" style="width:200px" />
</a>
<a href="{{ BASE_PATH }}/books/">
  <img src="/assets/images/2013/04/ruby_tutorial_cover.png" alt="ruby_tutorial" style="width:200px" />
</a>
<a href="{{ BASE_PATH }}/books/">
  <img src="/assets/images/2013/03/ruby_trivia_cover.png" alt="ruby_trivia" style="width:200px" />
</a>

