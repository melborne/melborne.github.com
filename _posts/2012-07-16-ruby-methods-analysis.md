---
layout: post
title: "Ruby、君のオブジェクトはなんて呼び出せばいいの？"
tagline: "Google Chart APIでRubyメソッドの命名傾向を知る"
description: ""
category: 
tags: [ruby, method] 
date: 2012-07-16
published: true
---
{% include JB/setup %}

Rubyには大量のメソッドがあります。次のコードでRuby1.9.3に含まれるメソッド数を数えたら単純合計で1659個、ユニーク数（同名を1と数えて）で937個と出力されました。

{% highlight ruby %}
all_methods = ObjectSpace.each_object(Module).flat_map do |c|
  c.methods(false) + c.instance_methods(false)
end.reject { |m| "#{m}".start_with? '_deprecated' }

all_methods.size # => 1659
methods = all_methods.uniq
methods.size # => 937
{% endhighlight %}

つまりRubyには、937個もの異なる名前のメソッドがあるのです。各メソッド名は、その動作や機能を端的に表現したものでなければならないので、その一つ一つに適切な名前を付けていく作業には想像を絶する時間と労力が費やされていると思われます。

Rubyのメソッド名は、その長さや記号においてバラエティに富み、１記号からなる演算子風メソッドから_(underscore)で連結された20文字を超える長いものまであります。また、指針としての次のような命名規約が存在し、概ねこの規約に従って命名がなされています。

> 1. メソッド名は、すべて小文字とし、単語の区切りに`_`を用いる。メソッド名には動詞の原形を使用する。
> 1. 真偽値を返すメソッド名は、動詞または形容詞に`?`を付け、形容詞に`is_`は付けない。
> 1. また、破壊的なメソッドと非破壊的なメソッドの両方を提供する場合、破壊的なメソッドには`!`を付ける。

[Rubyコーディング規約](http://shugo.net/ruby-codeconv/codeconv.html 'Rubyコーディング規約')より

## メソッド名の傾向を知る
さてここより本題です。

以下では、このRubyの937個のメソッドが、どのような傾向をもって名付けられているのか、ちょっと調べてみたいと思います。集合の傾向を見るにはグラフが最適ですから、[Google Chart API](https://developers.google.com/chart/ 'Google Chart Tools — Google Developers')を使ってみます。Google Chartは、グラフ属性に係るパラメータを指定して発行したリクエストに対し、グラフ画像を返すWebAPIサービスです。[Googlecharts](http://googlecharts.rubyforge.org/ 'Googlecharts')というgemが公開されているので、Rubyのコードから簡単にこのリクエストURLを生成できます。

## メソッド名の長さ
まずは名前の長さのバラエティを見ます。リクエストの生成コードは次のとおりです。
{% highlight ruby %}
require "gchart"

by_len = methods.group_by(&:size).sort

# build a url for Google Chart API
x, data = by_len.map { |s, m| [s, m.size] }.transpose
y = 0.step(130, 10).to_a

puts Gchart.bar(:data => data,
             :max_value => 130,
             :axis_with_labels => 'x,y',
             :axis_labels => [x, y],
             :size => '600x400',
             :bar_width_and_spacing => 16,
             :title => 'Methods by Name Length',
             :bg => 'efefdd',
             )

##> http://chart.apis.google.com/chart?chxl=0:|1|2|3|4|5|6|7|8|9|10|11|12|13|14|15|16|17|18|19|20|21|22|23|24|25|26|29|31|1:|0|10|20|30|40|50|60|70|80|90|100|110|120|130&chxt=x,y&chbh=16&chf=bg,s,efefdd&chd=s:HHX9641fiWULHKLHHECDCBCABAAA&chtt=Methods+by+Name+Length&cht=bvs&chs=600x400&chxr=0,15,130
{% endhighlight %}

このコードで生成されるリクエストURLから、次のようなグラフが得られます。横軸がメソッド名の文字数、縦軸が該当メソッド数です。
![length noshadow](http://chart.apis.google.com/chart?chxl=0:\|1\|2\|3\|4\|5\|6\|7\|8\|9\|10\|11\|12\|13\|14\|15\|16\|17\|18\|19\|20\|21\|22\|23\|24\|25\|26\|29\|31\|1:\|0\|10\|20\|30\|40\|50\|60\|70\|80\|90\|100\|110\|120\|130&chxt=x,y&chbh=16&chf=bg,s,efefdd&chd=s:HHX9641fiWULHKLHHECDCBCABAAA&chtt=Methods+by+Name+Length&cht=bvs&chs=600x400&chxr=0,15,130)

大半は3文字から11文字の間に集中しているのがわかります。一方で、20を超える長さのメソッドもそれなりにあるんですね。

平均と標準偏差も計算してみます。
{% highlight ruby %}
avg = methods.map(&:size).tap { |ms| break ms.inject(:+) / ms.size.to_f } # => 7.924226254002135

sd = methods.map(&:size).tap do |ms|
  sigmas = ms.map { |n| (avg - n)**2 }
  break Math.sqrt(sigmas.inject(:+) / ms.size)
end
sd # => 4.6276072940465225
{% endhighlight %}
平均文字長さは7.92文字、標準偏差は4.63文字と出力されました{% fn_ref 1 %}。つまりRubyのメソッド名は、その大半が4〜12文字の範囲に収まっているということで、これはグラフでの感触と一致していますね。

以下に13文字以上の長さを持つメソッドを並べてみます。
{% highlight ruby %}
puts by_len.select { |n, _| n > 12  }
           .map { |n, ms| "%d => %s (%d)" % [n, ms.sort.join(' '), ms.size] }
{% endhighlight %}

{% highlight bash %}
13 => absolute_path activate_spec configuration const_missing count_objects default_proc= each_filename inplace_mode= insert_output instance_eval instance_exec pre_uninstall public_method read_nonblock set_backtrace win_platform? (16)
14 => add_trace_func all_load_paths close_on_exec= close_on_exec? collect_concat compile_option configuration= const_defined? default_bindir each_codepoint force_encoding initialize_dup locale_charmap named_captures post_uninstall public_methods readable_real? set_trace_func sid_available? suffix_pattern writable_real? write_nonblock (22)
15 => class_variables compile_option= default_sources each_with_index fixed_encoding? garbage_collect grant_privilege instance_method latest_spec_for local_variables marshal_version method_defined? pre_reset_hooks private_methods public_constant readagain_bytes search_convpath singleton_class source_encoding source_location unresolved_deps valid_encoding? world_readable? world_writable? (24)
16 => change_privilege default_external default_internal define_finalizer each_with_object executable_real? global_variables included_modules initialize_clone instance_methods load_env_plugins post_build_hooks post_reset_hooks private_constant re_exchangeable? require_relative (16)
17 => ascii_compatible? default_external= default_internal= external_encoding incomplete_input? internal_encoding latest_load_paths load_plugin_files pre_install_hooks primitive_convert primitive_errinfo promote_load_path protected_methods required_location singleton_methods (15)
18 => abort_on_exception class_variable_get class_variable_set instance_variables latest_version_for location_of_caller post_install_hooks relative_path_from undefine_finalizer (9)
19 => abort_on_exception= compare_by_identity default_exec_format pre_uninstall_hooks public_class_method respond_to_missing? (6)
20 => asciicompat_encoding compare_by_identity? destination_encoding post_uninstall_hooks private_class_method repeated_combination repeated_permutation source_encoding_name (8)
21 => default_rubygems_dirs instance_variable_get instance_variable_set remove_class_variable report_activate_error (5)
22 => load_path_insert_index public_instance_method public_method_defined? singleton_method_added (4)
23 => class_variable_defined? define_singleton_method latest_rubygems_version private_method_defined? public_instance_methods (5)
24 => private_instance_methods (1)
25 => destination_encoding_name ensure_gem_subdirectories protected_method_defined? (3)
26 => instance_variable_defined? protected_instance_methods (2)
29 => default_user_source_cache_dir (1)
31 => default_system_source_cache_dir (1)
{% endhighlight %}

さすがに見慣れない名前が並んでいます。もしかしたら、このあたりのメソッドが攻略できたなら、Rubyが攻略できるとか...まさか。

## メソッド名の先頭文字
次に、メソッド名の先頭文字について見ます。まずはURL生成コードです。

{% highlight ruby %}
by_begin = methods.group_by do |m|
  case m[0]
  when 'a'..'z' then m[0]
  when 'A'..'Z' then 'A-Z'
  else 'Sym'
  end
end.sort

x, data = by_begin.map { |s, m| [s, m.size] }.transpose
y = 0.step(90, 10).to_a

puts Gchart.bar(:data => data,
             :axis_with_labels => 'x,y',
             :axis_labels => [x, y],
             :size => '600x400',
             :bar_width_and_spacing => 17,
             :title => 'Methods by Beginning Character Type',
             :bg => 'efefdd',
             )

#>> http://chart.apis.google.com/chart?chxl=0:|A-Z|Sym|a|b|c|d|e|f|g|h|i|j|k|l|m|n|o|p|q|r|s|t|u|v|w|y|z|1:|0|10|20|30|40|50|60|70|80|90&chxt=x,y&chbh=17&chf=bg,s,efefdd&chd=s:DSYKtbkUUEUADWUJFlBo9ZRDJBB&chtt=Methods+by+Beginning+Character+Type&cht=bvs&chs=600x400&chxr=0,7,120

{% endhighlight %}

大文字アルファベットと記号はぞれぞれ一つのグループにまとめています。グラフは次のようになりました。

![beginning noshadow](http://chart.apis.google.com/chart?chxl=0:\|A-Z\|Sym\|a\|b\|c\|d\|e\|f\|g\|h\|i\|j\|k\|l\|m\|n\|o\|p\|q\|r\|s\|t\|u\|v\|w\|y\|z\|1:\|0\|10\|20\|30\|40\|50\|60\|70\|80\|90&chxt=x,y&chbh=17&chf=bg,s,efefdd&chd=s:DSYKtbkUUEUADWUJFlBo9ZRDJBB&chtt=Methods+by+Beginning+Character+Type&cht=bvs&chs=600x400&chxr=0,7,120)

`s`で始まるメソッドが最も多く、`c`,`r`,`p`,`e`,`d`と続きます。

とりあえず以下に、大文字, 記号, s, c, r で始まるメソッドを並べてみます。
{% highlight ruby %}
puts by_begin.select { |c, ms| %w(s c r A-Z Sym).include?(c) }
             .map { |c, ms| "%s => %s (%d)\n\n" % [c, ms.sort.join(' '), ms.size] }
{% endhighlight %}

結果は次のとおりです。
{% highlight bash %}
A-Z => Array Complex Float Integer Pathname Rational String (7)

Sym => ! != !~ % & * ** + +@ - -@ / < << <= <=> == === =~ > >= >> [] []= ^ __callee__ __id__ __method__ __send__ _dump _id2ref _load ` | ~ (35)

c => cache cache_dir cache_gem call caller capitalize capitalize! captures casecmp casefold? catch cbrt ceil center change_privilege chardev? chars chdir children chmod chomp chomp! chop chop! chown chr chroot chunk class class_eval class_exec class_variable_defined? class_variable_get class_variable_set class_variables cleanpath clear clear_paths clone close close_on_exec= close_on_exec? close_read close_write closed? codepoints coerce collect collect! collect_concat combination compact compact! compare_by_identity compare_by_identity? compatible? compile compile_file compile_option compile_option= concat config_file configuration configuration= conj conjugate const_defined? const_get const_missing const_set constants convert convpath copy_stream coredump? cos cosh count count_objects cover? crypt cstime cstime= ctime current curry cutime cutime= cycle (89)

r => raise rand rassoc rationalize rdev rdev_major rdev_minor re_exchange re_exchangeable? read read_binary read_nonblock readable? readable_real? readagain_bytes readbyte readchar readline readlines readlink readpartial real real? realdirpath realpath reason receiver rect rectangular reduce refresh regexp rehash reject reject! relative? relative_path_from remainder remove_class_variable rename reopen repeated_combination repeated_permutation replace replacement replacement= replicate report report_activate_error require require_relative required_location requirement requirement= respond_to? respond_to_missing? restore result resume reverse reverse! reverse_each rewind rid rindex rjust rmdir rmtree root? rotate rotate! round rpartition rstrip rstrip! ruby ruby_engine ruby_version run (79)

s => safe_level sample saturday? scan search_convpath searcher sec seed seek select select! send set_backtrace set_encoding set_trace_func setbyte setegid seteuid setgid setgid? setpgid setpgrp setpriority setregid setresgid setresuid setreuid setrgid setrlimit setruid setsid setuid setuid? shift shuffle shuffle! sid_available? signaled? signm signo sin singleton_class singleton_method_added singleton_methods sinh size size? skip skip= skip_during sleep slice slice! slice_before socket? sort sort! sort_by sort_by! source source_encoding source_encoding_name source_index source_location sources sources= spawn spec spec= split sprintf sqrt squeeze squeeze! srand start start_with? stat status step sticky? stime stime= stop stop? stopped? stopsig store stress stress= strftime string strip strip! sub sub! sub_ext subsec succ succ! success? suffix_pattern suffixes sum sunday? superclass swapcase swapcase! switch symlink symlink? sync sync= synchronize syscall sysopen sysread sysseek system syswrite (120)
{% endhighlight %}

なるほど、なるほど。


## メソッド名の終端文字
次に、メソッド名の終端文字を見ます。次のコードにより、終端が`!`, `?`, `=`で終わるものをグループ分けして、円グラフに表示します。

{% highlight ruby %}
by_end = methods.group_by { |m| m.match /[!?=]$/; $& }

x, data = by_end.map { |s, m| ["#{s}(#{m.size})", m.size] }.transpose
puts Gchart.pie(:data => data,
             :labels => x,
             :size => '500x320',
             :title => 'End Character Types',
             :bg => 'efefdd',
             )

#>> http://chart.apis.google.com/chart?chf=bg,s,efefdd&chd=s:9JDC&chl=%28763%29|%3F%28116%29|%3D%2843%29|%21%2834%29&chtt=End+Character+Types&cht=p&chs=500x320&chxr=0,763,763

{% endhighlight %}

結果は次のとおりです。

![end noshadow](http://chart.apis.google.com/chart?chf=bg,s,efefdd&chd=s:9JDC&chl=%28763%29\|%3F%28116%29\|%3D%2843%29\|%21%2834%29&chtt=End+Character+Types&cht=p&chs=500x320&chxr=0,763,763)

終端が`!`, `?`, `=`で終わるものが全体の2割を占めます。それらをリスト表示しておきましょう。


{% highlight ruby %}
puts by_end.reject { |t, ms| t.nil? }
           .map { |t, ms| "%s => %s (%d)\n\n" % [t, ms.sort.join(' '), ms.size] }

{% endhighlight %}

{% highlight bash %}
? => absolute? alive? all? any? ascii_compatible? ascii_only? autoclose? autoload? available? between? binmode? block_given? blockdev? casefold? chardev? class_variable_defined? close_on_exec? closed? compare_by_identity? compatible? const_defined? coredump? cover? directory? dst? dummy? empty? enabled? enclosed? end_with? eof? eql? equal? even? exclude_end? executable? executable_real? exist? exists? exited? file? finite? fixed_encoding? fnmatch? friday? frozen? gmt? grpowned? has_key? has_value? identical? include? incomplete_input? infinite? instance_of? instance_variable_defined? integer? is_a? iterator? key? kind_of? lambda? loaded_path? locked? member? method_defined? monday? mountpoint? nan? nil? none? nonzero? odd? one? owned? pipe? private_method_defined? protected_method_defined? public_method_defined? re_exchangeable? readable? readable_real? real? relative? respond_to? respond_to_missing? root? saturday? setgid? setuid? sid_available? signaled? size? socket? start_with? sticky? stop? stopped? success? sunday? symlink? tainted? thursday? tty? tuesday? untrusted? utc? valid_encoding? value? wednesday? win_platform? world_readable? world_writable? writable? writable_real? zero? (116)

= => != <= == === >= []= abort_on_exception= autoclose= close_on_exec= compile_option= configuration= cstime= cutime= default= default_external= default_internal= default_proc= egid= eid= euid= exit_code= file_path= gid= groups= host= inplace_mode= lineno= maxgroups= name= paths= platforms= pos= priority= replacement= requirement= skip= sources= spec= stime= stress= sync= uid= utime= (43)

! => ! capitalize! chomp! chop! collect! compact! delete! downcase! encode! exit! flatten! gsub! lstrip! map! merge! next! reject! reverse! rotate! rstrip! select! shuffle! slice! sort! sort_by! squeeze! strip! sub! succ! swapcase! tr! tr_s! uniq! upcase! (34)

{% endhighlight %}

実は、`?`で終わる116個のメソッドのうち、26個はFileのクラスメソッドなんですってよ！

{% highlight ruby %}
File.methods(false).select { |m| m.to_s.end_with?('?') }.uniq.size # => 26
{% endhighlight %}


使いすぎ！いや、使いすぎ？


## メソッド名における単語数
さて、次はメソッドが何単語でできているかを見ます。

{% highlight ruby %}
require "gchart"

by_sep= methods.group_by { |m| "#{m}".scan(/[^_]+/).size }.sort

x, data = by_sep.map { |n, m| [[n,m.size], m.size] }.transpose
x = x.map { |n,s| %w(one\ word two\ words three\ words four\ words five\ words)[n-1] + "(#{s})" }

puts Gchart.pie(:data => data,
             :labels => x,
             :size => '500x320',
             :title => 'Words in a Method Name',
             :bg => 'efefdd',
             )

#>> http://chart.apis.google.com/chart?chf=bg,s,efefdd&chd=s:9UEAA&chl=one+word%28675%29|two+words%28225%29|three+words%2853%29|four+words%281%29|five+words%282%29&chtt=Words+in+a+Method+Name&cht=p&chs=500x320&chxr=0,675,675

{% endhighlight %}

結果は次のとおりです。

![words noshadow](http://chart.apis.google.com/chart?chf=bg,s,efefdd&chd=s:9UEAA&chl=one+word%28675%29\|two+words%28225%29\|three+words%2853%29\|four+words%281%29\|five+words%282%29&chtt=Words+in+a+Method+Name&cht=p&chs=500x320&chxr=0,675,675)

１単語によるメソッドが70％以上を占めていることがわかります。

さて、３単語以上からなるメソッドをリストアップしておきましょう。
{% highlight ruby %}
puts by_sep.select { |n, ms| n > 2 }
           .map { |t, ms| "%s => %s (%d)\n\n" % [t, ms.sort.join(' '), ms.size] }
{% endhighlight %}

{% highlight bash %}
3 => abort_on_exception abort_on_exception= add_trace_func all_load_paths class_variable_defined? class_variable_get class_variable_set close_on_exec= close_on_exec? compare_by_identity compare_by_identity? default_exec_format default_rubygems_dirs define_singleton_method destination_encoding_name each_with_index each_with_object ensure_gem_subdirectories instance_variable_defined? instance_variable_get instance_variable_set latest_load_paths latest_rubygems_version latest_spec_for latest_version_for load_env_plugins load_plugin_files location_of_caller post_build_hooks post_install_hooks post_reset_hooks post_uninstall_hooks pre_install_hooks pre_reset_hooks pre_uninstall_hooks private_class_method private_instance_methods private_method_defined? promote_load_path protected_instance_methods protected_method_defined? public_class_method public_instance_method public_instance_methods public_method_defined? relative_path_from remove_class_variable report_activate_error respond_to_missing? set_trace_func singleton_method_added source_encoding_name to_write_io (53)

4 => load_path_insert_index (1)

5 => default_system_source_cache_dir default_user_source_cache_dir (2)
{% endhighlight %}
５単語からなる２つの最長メソッドは、そう、Gemライブラリに含まれるものですorz..

悲しい、ボクハトテモカナシイ..

ちなみに３単語メソッドの平均語長は19.15でした。長いですねーーーーーー。
{% highlight ruby %}
by_sep.detect { |n, ms| n == 3 }.last
      .tap { |ms| break ms.map(&:size).inject(:+) / ms.size.to_f } # => 19.15
{% endhighlight %}

## メソッド名における単語出現頻度
最後に、メソッド名の中で使われている単語のうち、出現頻度の高いものをカウントしてみます。ここでは４種類以上のメソッドで使われている単語のみを対象にします。

{% highlight ruby %}
by_word = methods.flat_map { |m| "#{m}".scan(/[^_=!?~%&*<^@\[\]+\/-]+/) }
                 .inject(Hash.new(0)) { |h, x| h[x] +=1; h }
                 .select { |k, v| v >= 8 }.sort_by { |k,v| -v }


x, data = by_word.map { |k, v| ["#{k}(#{v})", v] }.transpose

puts Gchart.pie(:data => data,
             :labels => x,
             :size => '500x320',
             :title => 'Words used in Methods',
             :bg => 'efefdd',
             )


#>> http://chart.apis.google.com/chart?chf=bg,s,efefdd&chd=s:993ssppllffbb&chl=each%2818%29|to%2818%29|default%2816%29|method%2813%29|instance%2813%29|encoding%2812%29|path%2812%29|load%2811%29|class%2811%29|post%289%29|methods%289%29|public%288%29|by%288%29&chtt=Words+used+in+Methods&cht=p&chs=500x320&chxr=0,18,18

{% endhighlight %}

結果は次のとおりです。

![words in name noshadow](http://chart.apis.google.com/chart?chf=bg,s,efefdd&chd=s:993ssppllffbb&chl=each%2818%29\|to%2818%29\|default%2816%29\|method%2813%29\|instance%2813%29\|encoding%2812%29\|path%2812%29\|load%2811%29\|class%2811%29\|post%289%29\|methods%289%29\|public%288%29\|by%288%29&chtt=Words+used+in+Methods&cht=p&chs=500x320&chxr=0,18,18)

まあ予想通りの結果ですね。`each`,`to`が最多で18種類、`default`が16種類のメソッドで使われているようです。`each`と`to`を持ったメソッドをリストアップしてみましょう。

{% highlight ruby %}
puts methods.map { |m| "#{m}".scan(/[^_=!?~%&*<^@\[\]+\/-]+/) << m }
            .group_by { |ws| ws.any?{ |w| w.match(/^(each|to)$/) }; $& }
            .reject { |k, v| k.nil? }
            .map { |k, v| "%s => %s\n\n" % [k, v.map(&:last)] }
{% endhighlight %}


{% highlight bash %}
to => [:to_s, :to_i, :to_f, :to_r, :to_a, :to_proc, :to_path, :to_io, :to_write_io, :to_hash, :to_ary, :to_int, :to_c, :to_str, :to_sym, :respond_to?, :respond_to_missing?, :to_enum]

each => [:each, :each_with_index, :each_with_object, :each_object, :each_line, :each_byte, :each_char, :each_codepoint, :each_pair, :each_value, :each_key, :each_index, :reverse_each, :each_entry, :each_slice, :each_cons, :each_filename, :each_child]
{% endhighlight %}

みなさん、`each`と`to`の使いすぎには注意しましょう。用法用量を守って正しく...

----

以上、Rubyメソッドの命名傾向を調べたので紹介してみました。これが何の役に立つのかわかりませんが、眺めて、へぇ〜とかほぅ〜とか声が出たのなら記事にした価値があるというものです^ ^;

[Ruby Methods Analysis — Gist](https://gist.github.com/3121898 'Ruby Methods Analysis — Gist')

なお、Rubyのメソッドをもっとがっつりと眺めたい方には、拙作[Ruby Reference Index](http://rbref.heroku.com/ 'Ruby Reference Index')がお待ち申し上げておりますm(__)m


-----

(追記：2012-07-17) バグ修正と追記をしました。


(追記：2012-07-18) なかだ のぶさんのコメントを受けて、メソッド算出の不備に気が付きました。元の式では、定数スコープ演算子`::`を含むクラスのメソッドがカウントされていませんでした。指摘に基づいて記事を修正しました。また、Gemライブラリのメソッドも対象にしました。問題のある元の式をここに置いておきます。ごめんなさい。

{% highlight ruby %}
methods = Module.constants.flat_map do |c|
  next [] if c == :Gem
  k = Module.const_get(c)
  k.methods(false) + k.instance_methods(false) rescue []
end.reject { |m| "#{m}".start_with? '_deprecated' }.sort_by { |m| -m.size }

methods.size # => 1349
methods = methods.uniq
methods.size # => 753
{% endhighlight %}

----

{{ 4828863087 | amazon_medium_image }}

{{ 4828863087 | amazon_link }} by {{ 4828863087 | amazon_authors }}

----

{% footnotes %}
  {% fn 早速覚えたてのtap breakを使ってみる^ ^; %}
{% endfootnotes %}
