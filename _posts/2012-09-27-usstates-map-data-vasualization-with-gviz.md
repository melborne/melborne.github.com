---
layout: post
title: "Ruby Graphvizラッパー「Gviz」でアメリカ合衆国をデータビジュアライズしよう！"
description: ""
category: 
tags: [graphviz, gem] 
date: 2012-09-27
published: true
---
{% include JB/setup %}

(追記：2014-3-3) Gvizについてのまとめ頁を作りました。

> [Gvizの目次 - Rubyの世界からGraphvizの世界にこんにちは！]({{ BASE_PATH }}/2014/02/27/gviz-posts/ "Gvizの目次 - Rubyの世界からGraphvizの世界にこんにちは！")

---

<p>RubyのGraphvizラッパー「<a href="https://rubygems.org/gems/gviz" title="gviz">Gviz</a>」を前回紹介しました。</p>

<blockquote><p><a href="/2012/09/25/ruby-plus-graphviz-should-eql-gviz/" title="Yet Another Ruby Graphviz Interfaceを作ったからみんなで大量のグラフを作って遊ぼうよ！">Yet Another Ruby Graphviz Interfaceを作ったからみんなで大量のグラフを作って遊ぼうよ！</a></p></blockquote>

<p>そこでは隣接県情報に基づき日本地図を作りました。出来は兎も角、僕はこのやり方がすっかり気に入りました。そこで今回はもう一歩進んでこの地図でデータビジュアライゼーションをしてみようと思います。題材はアメリカ合衆国です！</p>

<p>以下では、データの取得から順を追ってグラフ作成のやり方を説明しています。ちょっと長い投稿になります。</p>

<h2>隣接州情報の生成</h2>

<p>地図の形のベースとなる隣接州情報を用意します。<a href="http://en.wikipedia.org/wiki/List_of_U.S._state_abbreviations" title="List of U.S. state abbreviations - Wikipedia, the free encyclopedia">List of U.S. state abbreviations - Wikipedia, the free encyclopedia</a>などから州名と略称(USPS)を取得し、USPSを使って次のような隣接州情報のファイルを作ります。</p>

<script src="https://gist.github.com/3792505.js?file=uslinks.csv"></script>


<h2>アメリカ合衆国州情報の取得</h2>

<p>ビジュアライズするデータを見つけます。各州の人口や面積が入った情報がいいですね。ここでは次のサイトを使います。</p>

<p><a href="http://en.wikipedia.org/wiki/List_of_U.S._states" title="List of U.S. states - Wikipedia, the free encyclopedia">List of U.S. states - Wikipedia, the free encyclopedia</a></p>

<p>頁のソースをちょっと覗いて構造がわかったら、次のようなコードで対象データを取得します。</p>

<script src="https://gist.github.com/3792505.js?file=us_scraper.rb"></script>


<p>取得した各データをHEADER, BODY変数に割り当ててRubyスクリプトとして保存します。</p>

<script src="https://gist.github.com/3792505.js?file=usdata.rb"></script>


<h2>データの読み出しと統合</h2>

<p>次にこれらの情報をRubyスクリプト上に読み出し、整理して統合します。ファイル名を<code>usstates.rb</code>とします。まずは<code>uslinks.csv</code>を読み出します。</p>

<div class="highlight"><pre><code class="ruby"><span class="c1"># encoding: UTF-8</span>
<span class="nb">require</span> <span class="s2">&quot;csv&quot;</span>

<span class="n">_</span><span class="p">,</span> <span class="o">*</span><span class="n">links</span> <span class="o">=</span> <span class="no">CSV</span><span class="o">.</span><span class="n">read</span><span class="p">(</span><span class="s1">&#39;uslinks.csv&#39;</span><span class="p">)</span>

<span class="n">links</span> <span class="o">=</span> <span class="n">links</span><span class="o">.</span><span class="n">map</span> <span class="k">do</span> <span class="o">|</span><span class="n">usps</span><span class="p">,</span> <span class="nb">name</span><span class="p">,</span> <span class="o">*</span><span class="n">link</span><span class="o">|</span>
  <span class="o">[</span><span class="n">usps</span><span class="o">.</span><span class="n">intern</span><span class="p">,</span> <span class="nb">name</span><span class="p">,</span> <span class="n">link</span><span class="o">.</span><span class="n">map</span><span class="p">(</span><span class="o">&amp;</span><span class="ss">:intern</span><span class="p">)</span><span class="o">]</span>
<span class="k">end</span><span class="o">.</span><span class="n">sort</span>

<span class="n">links</span> <span class="c1"># =&gt; [[:AK, &quot;Alaska&quot;, [:WA]], [:AL, &quot;Alabama&quot;, [:MS, :FL, :GA, :TN]], [:AR, &quot;Arkansas&quot;, [:MO, :TN, :MS, :LA, :TX, :OK]], [:AZ, &quot;Arizona&quot;, [:CA, :NV, :UT, :NM, :CO]], [:CA, &quot;California&quot;, [:OR, :NV, :AZ]], [:CO, &quot;Colorado&quot;, [:WY, :NE, :KS, :OK, :NM, :AZ, :UT]], [:CT, &quot;Connecticut&quot;, [:NY, :MA, :RI]], [:DE, &quot;Delaware&quot;, [:MD, :PA, :NJ]], [:FL, &quot;Florida&quot;, [:AL, :GA]], [:GA, &quot;Georgia&quot;, [:FL, :AL, :TN, :NC, :SC]],   -- 中略 --   [:TN, &quot;Tennessee&quot;, [:KY, :VA, :NC, :GA, :AR, :MS, :AL, :MO]], [:TX, &quot;Texas&quot;, [:NM, :OK, :AR, :LA]], [:UT, &quot;Utah&quot;, [:ID, :WY, :CO, :NM, :AZ, :NV]], [:VA, &quot;Virginia&quot;, [:WV, :KY, :TN, :NC, :MD]], [:VT, &quot;Vermont&quot;, [:NY, :MA, :NH]], [:WA, &quot;Washington&quot;, [:OR, :ID, :AK]], [:WI, &quot;Wisconsin&quot;, [:MI, :IL, :IA, :MN]], [:WV, &quot;West Virginia&quot;, [:OH, :PA, :MD, :VA, :KY]], [:WY, &quot;Wyoming&quot;, [:MT, :SD, :NE, :CO, :UT, :ID]]]</span>
</code></pre>
</div>


<p>次に<code>usdata.rb</code>を読み出して、必要なデータを取り出します。</p>

<div class="highlight"><pre><code class="ruby"><span class="n">require_relative</span> <span class="s2">&quot;usdata&quot;</span>

<span class="n">usdata</span> <span class="o">=</span> <span class="no">BODY</span><span class="o">.</span><span class="n">map</span> <span class="k">do</span> <span class="o">|</span><span class="nb">name</span><span class="p">,</span> <span class="n">ipa</span><span class="p">,</span> <span class="n">usps</span><span class="p">,</span> <span class="n">flag</span><span class="p">,</span> <span class="n">sthood</span><span class="p">,</span> <span class="n">area</span><span class="p">,</span> <span class="n">pop</span><span class="p">,</span> <span class="n">cap</span><span class="p">,</span> <span class="n">popcity</span><span class="p">,</span> <span class="n">pre</span><span class="p">,</span> <span class="n">gdp</span><span class="o">|</span>
  <span class="nb">name</span> <span class="o">=</span> <span class="nb">name</span><span class="o">.</span><span class="n">sub</span><span class="p">(</span><span class="sr">/\[\d+\]$/</span><span class="p">,</span> <span class="s1">&#39;&#39;</span><span class="p">)</span>
  <span class="n">sthood</span> <span class="o">=</span> <span class="n">sthood</span><span class="o">[</span><span class="sr">/\d{4}$/</span><span class="o">]</span>
  <span class="n">area</span> <span class="o">=</span> <span class="n">area</span><span class="o">[</span><span class="sr">/(?&lt;=\()[\d,]+/</span><span class="o">]</span>
  <span class="o">[</span><span class="n">usps</span><span class="o">.</span><span class="n">intern</span><span class="p">,</span> <span class="nb">name</span><span class="p">,</span> <span class="n">cap</span><span class="o">]</span> <span class="o">+</span>
        <span class="o">[</span><span class="n">sthood</span><span class="p">,</span> <span class="n">area</span><span class="p">,</span> <span class="n">pop</span><span class="p">,</span> <span class="n">gdp</span><span class="o">].</span><span class="n">map</span> <span class="p">{</span> <span class="o">|</span><span class="n">e</span><span class="o">|</span> <span class="n">e</span><span class="o">.</span><span class="n">delete</span> <span class="s1">&#39;,&#39;</span> <span class="p">}</span><span class="o">.</span><span class="n">map</span><span class="p">(</span><span class="o">&amp;</span><span class="ss">:to_i</span><span class="p">)</span>
<span class="k">end</span><span class="o">.</span><span class="n">sort</span>

<span class="n">usdata</span> <span class="c1"># =&gt; [[:AK, &quot;Alaska&quot;, &quot;Juneau&quot;, 1959, 1717854, 722718, 45600], [:AL, &quot;Alabama&quot;, &quot;Montgomery&quot;, 1819, 135765, 4802740, 174400], [:AR, &quot;Arkansas&quot;, &quot;Little Rock&quot;, 1836, 137002, 2937979, 105800], [:AZ, &quot;Arizona&quot;, &quot;Phoenix&quot;, 1912, 295254, 6482505, 261300], [:CA, &quot;California&quot;, &quot;Sacramento&quot;, 1850, 423970, 37691912, 1936400], [:CO, &quot;Colorado&quot;, &quot;Denver&quot;, 1876, 269837, 5116796, 259700], [:CT, &quot;Connecticut&quot;, &quot;Hartford&quot;, 1788, 14356, 3580709, 233400],   -- 中略--   [:UT, &quot;Utah&quot;, &quot;Salt Lake City&quot;, 1896, 219887, 2817222, 116900], [:VA, &quot;Virginia&quot;, &quot;Richmond&quot;, 1788, 110785, 8096604, 427700], [:VT, &quot;Vermont&quot;, &quot;Montpelier&quot;, 1791, 24923, 626431, 26400], [:WA, &quot;Washington&quot;, &quot;Olympia&quot;, 1889, 184827, 6830038, 351100], [:WI, &quot;Wisconsin&quot;, &quot;Madison&quot;, 1848, 169639, 5711767, 251400], [:WV, &quot;West Virginia&quot;, &quot;Charleston&quot;, 1863, 62755, 1855364, 66600], [:WY, &quot;Wyoming&quot;, &quot;Cheyenne&quot;, 1890, 253348, 568158, 38200]]</span>
</code></pre>
</div>


<p>そしてこれらのデータを統合します。</p>

<div class="highlight"><pre><code class="ruby"><span class="n">usdata</span> <span class="o">=</span> <span class="n">usdata</span><span class="o">.</span><span class="n">zip</span><span class="p">(</span><span class="n">links</span><span class="p">)</span><span class="o">.</span><span class="n">map</span> <span class="p">{</span> <span class="o">|</span><span class="n">data</span><span class="p">,</span> <span class="n">links</span><span class="o">|</span> <span class="n">data</span> <span class="o">&lt;&lt;</span> <span class="n">links</span><span class="o">.</span><span class="n">last</span> <span class="p">}</span>

<span class="n">usdata</span> <span class="c1"># =&gt; [[:AK, &quot;Alaska&quot;, &quot;Juneau&quot;, 1959, 1717854, 722718, 45600, [:WA]], [:AL, &quot;Alabama&quot;, &quot;Montgomery&quot;, 1819, 135765, 4802740, 174400, [:MS, :FL, :GA, :TN]], [:AR, &quot;Arkansas&quot;, &quot;Little Rock&quot;, 1836, 137002, 2937979, 105800, [:MO, :TN, :MS, :LA, :TX, :OK]], [:AZ, &quot;Arizona&quot;, &quot;Phoenix&quot;, 1912, 295254, 6482505, 261300, [:CA, :NV, :UT, :NM, :CO]], [:CA, &quot;California&quot;, &quot;Sacramento&quot;, 1850, 423970, 37691912, 1936400, [:OR, :NV, :AZ]],  -- 中略 --  [:SD, &quot;South Dakota&quot;, &quot;Pierre&quot;, 1889, 199905, 824082, 39900, [:ND, :MN, :IA, :NE, :WY, :MT]], [:TN, &quot;Tennessee&quot;, &quot;Nashville&quot;, 1796, 109247, 6403353, 250300, [:KY, :VA, :NC, :GA, :AR, :MS, :AL, :MO]], [:TX, &quot;Texas&quot;, &quot;Austin&quot;, 1845, 696241, 25674681, 1207432, [:NM, :OK, :AR, :LA]], [:UT, &quot;Utah&quot;, &quot;Salt Lake City&quot;, 1896, 219887, 2817222, 116900, [:ID, :WY, :CO, :NM, :AZ, :NV]], [:VA, &quot;Virginia&quot;, &quot;Richmond&quot;, 1788, 110785, 8096604, 427700, [:WV, :KY, :TN, :NC, :MD]], [:VT, &quot;Vermont&quot;, &quot;Montpelier&quot;, 1791, 24923, 626431, 26400, [:NY, :MA, :NH]], [:WA, &quot;Washington&quot;, &quot;Olympia&quot;, 1889, 184827, 6830038, 351100, [:OR, :ID, :AK]], [:WI, &quot;Wisconsin&quot;, &quot;Madison&quot;, 1848, 169639, 5711767, 251400, [:MI, :IL, :IA, :MN]], [:WV, &quot;West Virginia&quot;, &quot;Charleston&quot;, 1863, 62755, 1855364, 66600, [:OH, :PA, :MD, :VA, :KY]], [:WY, &quot;Wyoming&quot;, &quot;Cheyenne&quot;, 1890, 253348, 568158, 38200, [:MT, :SD, :NE, :CO, :UT, :ID]]]</span>
</code></pre>
</div>


<h2>Gvizでグラフ化</h2>

<p>さて下準備が整ったので、これらのデータを<code>Gviz</code>を使ってグラフ化します。まずは隣接州情報で地形を作ります。</p>

<div class="highlight"><pre><code class="ruby"><span class="nb">require</span> <span class="s2">&quot;gviz&quot;</span>

<span class="n">gv</span> <span class="o">=</span> <span class="no">Gviz</span><span class="o">.</span><span class="n">new</span><span class="p">(</span><span class="ss">:USA</span><span class="p">)</span>
<span class="n">gv</span><span class="o">.</span><span class="n">graph</span> <span class="k">do</span>
  <span class="n">usdata</span><span class="o">.</span><span class="n">each</span> <span class="k">do</span> <span class="o">|</span><span class="nb">id</span><span class="p">,</span> <span class="nb">name</span><span class="p">,</span> <span class="n">cap</span><span class="p">,</span> <span class="n">sthood</span><span class="p">,</span> <span class="n">area</span><span class="p">,</span> <span class="n">pop</span><span class="p">,</span> <span class="n">gdp</span><span class="p">,</span> <span class="n">link</span><span class="o">|</span>
    <span class="n">route</span> <span class="nb">id</span> <span class="o">=&gt;</span> <span class="n">link</span>
  <span class="k">end</span>
<span class="k">end</span>

<span class="n">gv</span><span class="o">.</span><span class="n">save</span><span class="p">(</span><span class="ss">:usa</span><span class="p">,</span> <span class="ss">:png</span><span class="p">)</span>
</code></pre>
</div>


<p>出力を見てみます。</p>

<p><img src="/assets/images/usa1.png" alt="usa noshadow" /></p>

<p>前回同様、ヒドイ結果です。</p>

<p>ここでもlayoutを<code>neato</code>にして変化を見てみます。ラベルも変えます。</p>

<div class="highlight"><pre><code class="ruby"><span class="n">gv</span> <span class="o">=</span> <span class="no">Gviz</span><span class="o">.</span><span class="n">new</span><span class="p">(</span><span class="ss">:USA</span><span class="p">)</span>
<span class="n">gv</span><span class="o">.</span><span class="n">graph</span> <span class="k">do</span>
  <span class="n">global</span> <span class="n">layout</span><span class="ss">:&#39;neato&#39;</span><span class="p">,</span> <span class="n">overlap</span><span class="ss">:false</span>
  <span class="n">usdata</span><span class="o">.</span><span class="n">each</span> <span class="k">do</span> <span class="o">|</span><span class="nb">id</span><span class="p">,</span> <span class="nb">name</span><span class="p">,</span> <span class="n">cap</span><span class="p">,</span> <span class="n">sthood</span><span class="p">,</span> <span class="n">area</span><span class="p">,</span> <span class="n">pop</span><span class="p">,</span> <span class="n">gdp</span><span class="p">,</span> <span class="n">link</span><span class="o">|</span>
    <span class="n">route</span> <span class="nb">id</span> <span class="o">=&gt;</span> <span class="n">link</span>
    <span class="n">node</span> <span class="nb">id</span><span class="p">,</span> <span class="n">label</span><span class="p">:</span> <span class="nb">name</span>
  <span class="k">end</span>
<span class="k">end</span>

<span class="n">gv</span><span class="o">.</span><span class="n">save</span><span class="p">(</span><span class="ss">:usa</span><span class="p">,</span> <span class="ss">:png</span><span class="p">)</span>
</code></pre>
</div>


<p>どうでしょう。</p>

<p><img src="/assets/images/usa2.png" alt="usa noshadow" /></p>

<p>一気に地図っぽくなりました。</p>

<h2>州統合年のビジュアライズ</h2>

<p>次に、各州の合衆国への統合年(statehood)をビジュアライズします。<a href="http://en.wikipedia.org/wiki/List_of_U.S._states_by_date_of_statehood" title="List of U.S. states by date of statehood - Wikipedia, the free encyclopedia">List of U.S. states by date of statehood - Wikipedia, the free encyclopedia</a>にある区分に従って各州を９区分し、ノードの色の違いで表現します。<code>blues9</code>というカラーセットを使います。</p>

<p>まずは９区分をRangeのリストで表現します。</p>

<div class="highlight"><pre><code class="ruby"><span class="n">era</span> <span class="o">=</span> <span class="o">&lt;&lt;</span><span class="no">EOS</span><span class="o">.</span><span class="n">lines</span><span class="o">.</span><span class="n">map</span> <span class="p">{</span> <span class="o">|</span><span class="n">line</span><span class="o">|</span> <span class="no">Range</span><span class="o">.</span><span class="n">new</span> <span class="o">*</span><span class="n">line</span><span class="o">.</span><span class="n">split</span><span class="p">(</span><span class="s1">&#39;-&#39;</span><span class="p">)</span><span class="o">.</span><span class="n">map</span><span class="p">(</span><span class="o">&amp;</span><span class="ss">:to_i</span><span class="p">)</span> <span class="p">}</span>
<span class="sh">  1776-1790</span>
<span class="sh">  1791-1799</span>
<span class="sh">  1800-1819</span>
<span class="sh">  1820-1839</span>
<span class="sh">  1840-1859</span>
<span class="sh">  1860-1879</span>
<span class="sh">  1880-1899</span>
<span class="sh">  1900-1950</span>
<span class="sh">  1950-1959</span>
<span class="no">EOS</span>

<span class="n">era</span> <span class="c1"># =&gt; [1776..1790, 1791..1799, 1800..1819, 1820..1839, 1840..1859, 1860..1879, 1880..1899, 1900..1950, 1950..1959]</span>
</code></pre>
</div>


<p>これを使って各州の統合年を1〜9の何れかに割り当てて<code>fillcolor</code>にセットします。</p>

<div class="highlight"><pre><code class="ruby"><span class="n">gv</span> <span class="o">=</span> <span class="no">Gviz</span><span class="o">.</span><span class="n">new</span><span class="p">(</span><span class="ss">:USA</span><span class="p">)</span>
<span class="n">gv</span><span class="o">.</span><span class="n">graph</span> <span class="k">do</span>
  <span class="n">global</span> <span class="n">layout</span><span class="ss">:&#39;neato&#39;</span><span class="p">,</span> <span class="n">overlap</span><span class="ss">:false</span>
  <span class="n">nodes</span> <span class="n">colorscheme</span><span class="ss">:&#39;blues9&#39;</span><span class="p">,</span> <span class="n">style</span><span class="ss">:&#39;filled&#39;</span>

  <span class="n">usdata</span><span class="o">.</span><span class="n">each</span> <span class="k">do</span> <span class="o">|</span><span class="nb">id</span><span class="p">,</span> <span class="nb">name</span><span class="p">,</span> <span class="n">cap</span><span class="p">,</span> <span class="n">sthood</span><span class="p">,</span> <span class="n">area</span><span class="p">,</span> <span class="n">pop</span><span class="p">,</span> <span class="n">gdp</span><span class="p">,</span> <span class="n">link</span><span class="o">|</span>
    <span class="n">sthood</span> <span class="o">=</span> <span class="mi">9</span> <span class="o">-</span> <span class="n">era</span><span class="o">.</span><span class="n">index</span> <span class="p">{</span> <span class="o">|</span><span class="n">r</span><span class="o">|</span> <span class="n">r</span><span class="o">.</span><span class="n">include?</span> <span class="n">sthood</span> <span class="p">}</span>
    <span class="n">route</span> <span class="nb">id</span> <span class="o">=&gt;</span> <span class="n">link</span>
    <span class="n">node</span> <span class="nb">id</span><span class="p">,</span> <span class="n">label</span><span class="p">:</span> <span class="nb">name</span><span class="p">,</span> <span class="n">fillcolor</span><span class="ss">:sthood</span>
    <span class="n">node</span> <span class="nb">id</span><span class="p">,</span> <span class="n">fontcolor</span><span class="ss">:&#39;white&#39;</span> <span class="k">if</span> <span class="n">sthood</span> <span class="o">&gt;</span> <span class="mi">7</span>
  <span class="k">end</span>
<span class="k">end</span>

<span class="n">gv</span><span class="o">.</span><span class="n">save</span><span class="p">(</span><span class="ss">:usa</span><span class="p">,</span> <span class="ss">:png</span><span class="p">)</span>
</code></pre>
</div>


<p>結果を見てみます。</p>

<p><img src="/assets/images/usa3.png" alt="usa noshadow" /></p>

<p>キレイに色分けされました。色が薄くなるに連れて統合年が遅いということを表しています。</p>

<h2>州面積のビジュアライズ</h2>

<p>次に各州の面積データをビジュアライズします。合衆国の州面積は最小が3,140km2（Rhode Island）で
最大が1,717,854km2（Alaska）です。ビジュアライズのためにこれらを正規化する（一定の範囲の値に収める）必要があります。</p>

<p><code>minmax</code>関数で対象データの最小最大範囲を取得し、Fixnum#normを定義してこれを正規化するようにします。</p>

<div class="highlight"><pre><code class="ruby"><span class="k">def</span> <span class="nf">minmax</span><span class="p">(</span><span class="n">data</span><span class="p">,</span> <span class="n">idx</span><span class="p">)</span>
  <span class="n">data</span><span class="o">.</span><span class="n">map</span><span class="p">{</span> <span class="o">|</span><span class="n">d</span><span class="o">|</span> <span class="n">d</span><span class="o">[</span><span class="n">idx</span><span class="o">-</span><span class="mi">1</span><span class="o">]</span> <span class="p">}</span><span class="o">.</span><span class="n">minmax</span><span class="o">.</span><span class="n">tap</span> <span class="p">{</span> <span class="o">|</span><span class="n">minmax</span><span class="o">|</span> <span class="k">break</span> <span class="no">Range</span><span class="o">.</span><span class="n">new</span> <span class="o">*</span><span class="n">minmax</span> <span class="p">}</span>
<span class="k">end</span>

<span class="k">class</span> <span class="nc">Fixnum</span>
  <span class="k">def</span> <span class="nf">norm</span><span class="p">(</span><span class="n">range</span><span class="p">,</span> <span class="n">tgr</span><span class="o">=</span><span class="mi">1</span><span class="o">.</span><span class="n">.</span><span class="mi">10</span><span class="p">)</span>
    <span class="n">unit</span> <span class="o">=</span> <span class="p">(</span><span class="nb">self</span> <span class="o">-</span> <span class="n">range</span><span class="o">.</span><span class="n">min</span><span class="p">)</span> <span class="o">/</span> <span class="p">(</span><span class="n">range</span><span class="o">.</span><span class="n">max</span> <span class="o">-</span> <span class="n">range</span><span class="o">.</span><span class="n">min</span><span class="p">)</span><span class="o">.</span><span class="n">to_f</span>
    <span class="p">(</span><span class="n">unit</span> <span class="o">*</span> <span class="p">(</span><span class="n">tgr</span><span class="o">.</span><span class="n">max</span> <span class="o">-</span> <span class="n">tgr</span><span class="o">.</span><span class="n">min</span><span class="p">)</span> <span class="o">+</span> <span class="n">tgr</span><span class="o">.</span><span class="n">min</span><span class="p">)</span><span class="o">.</span><span class="n">round</span>
  <span class="k">end</span>
<span class="k">end</span>

<span class="n">area_minmax</span> <span class="o">=</span> <span class="n">minmax</span><span class="p">(</span><span class="n">usdata</span><span class="p">,</span> <span class="mi">5</span><span class="p">)</span> <span class="c1"># =&gt; 3140..1717854</span>

<span class="mi">295254</span><span class="o">.</span><span class="n">norm</span><span class="p">(</span><span class="n">area_minmax</span><span class="p">)</span> <span class="c1"># =&gt; 3</span>
</code></pre>
</div>


<p>さてこれらのメソッドを使って各州の面積を1〜6の範囲に正規化し、これを使ってノードの幅を決定します。エッジの矢印も消します。</p>

<div class="highlight"><pre><code class="ruby"><span class="n">area_minmax</span> <span class="o">=</span> <span class="n">minmax</span><span class="p">(</span><span class="n">usdata</span><span class="p">,</span> <span class="mi">5</span><span class="p">)</span>

<span class="n">gv</span> <span class="o">=</span> <span class="no">Gviz</span><span class="o">.</span><span class="n">new</span><span class="p">(</span><span class="ss">:USA</span><span class="p">)</span>
<span class="n">gv</span><span class="o">.</span><span class="n">graph</span> <span class="k">do</span>
  <span class="n">global</span> <span class="n">layout</span><span class="ss">:&#39;neato&#39;</span><span class="p">,</span> <span class="n">overlap</span><span class="ss">:false</span>
  <span class="n">nodes</span> <span class="n">colorscheme</span><span class="ss">:&#39;blues9&#39;</span><span class="p">,</span> <span class="n">style</span><span class="ss">:&#39;filled&#39;</span><span class="p">,</span> <span class="n">regular</span><span class="ss">:true</span>
  <span class="n">edges</span> <span class="n">arrowhead</span><span class="ss">:&#39;none&#39;</span>
  
  <span class="n">usdata</span><span class="o">.</span><span class="n">each</span> <span class="k">do</span> <span class="o">|</span><span class="nb">id</span><span class="p">,</span> <span class="nb">name</span><span class="p">,</span> <span class="n">cap</span><span class="p">,</span> <span class="n">sthood</span><span class="p">,</span> <span class="n">area</span><span class="p">,</span> <span class="n">pop</span><span class="p">,</span> <span class="n">gdp</span><span class="p">,</span> <span class="n">link</span><span class="o">|</span>
    <span class="n">sthood</span> <span class="o">=</span> <span class="mi">9</span> <span class="o">-</span> <span class="n">era</span><span class="o">.</span><span class="n">index</span> <span class="p">{</span> <span class="o">|</span><span class="n">r</span><span class="o">|</span> <span class="n">r</span><span class="o">.</span><span class="n">include?</span> <span class="n">sthood</span> <span class="p">}</span>
    <span class="n">area</span> <span class="o">=</span> <span class="n">area</span><span class="o">.</span><span class="n">norm</span><span class="p">(</span><span class="n">area_minmax</span><span class="p">,</span> <span class="mi">1</span><span class="o">.</span><span class="n">.</span><span class="mi">6</span><span class="p">)</span>
    <span class="n">route</span> <span class="nb">id</span> <span class="o">=&gt;</span> <span class="n">link</span>
    <span class="n">node</span> <span class="nb">id</span><span class="p">,</span> <span class="n">label</span><span class="p">:</span> <span class="nb">name</span><span class="p">,</span> <span class="n">fillcolor</span><span class="ss">:sthood</span><span class="p">,</span> <span class="n">width</span><span class="ss">:area</span><span class="p">,</span> <span class="n">fontsize</span><span class="p">:</span><span class="mi">14</span><span class="o">*</span><span class="n">area</span>
    <span class="n">node</span> <span class="nb">id</span><span class="p">,</span> <span class="n">fontcolor</span><span class="ss">:&#39;white&#39;</span> <span class="k">if</span> <span class="n">sthood</span> <span class="o">&gt;</span> <span class="mi">7</span>
  <span class="k">end</span>
<span class="k">end</span>

<span class="n">gv</span><span class="o">.</span><span class="n">save</span><span class="p">(</span><span class="ss">:usa</span><span class="p">,</span> <span class="ss">:png</span><span class="p">)</span>
</code></pre>
</div>


<p>結果を見てみます。</p>

<p><img src="/assets/images/usa4.png" alt="usa noshadow" /></p>

<p>州面積に応じてノードのサイズが変わりました。</p>

<h2>州人口のビジュアライズ</h2>

<p>最後に州人口のデータをビジュアライズします。州人口をノードにおける多角形の辺の数で表現します。州面積と同様にデータ値を正規化し4〜12の何れかに収めます。ノードのshapeをpolygonとして各ノードのsidesをこの数値で決定します。つまり人口が多い州ほど辺数の多い多角形となります。</p>

<div class="highlight"><pre><code class="ruby"><span class="n">pop_minmax</span> <span class="o">=</span> <span class="n">minmax</span><span class="p">(</span><span class="n">usdata</span><span class="p">,</span> <span class="mi">6</span><span class="p">)</span>

<span class="n">gv</span> <span class="o">=</span> <span class="no">Gviz</span><span class="o">.</span><span class="n">new</span><span class="p">(</span><span class="ss">:USA</span><span class="p">)</span>
<span class="n">gv</span><span class="o">.</span><span class="n">graph</span> <span class="k">do</span>
  <span class="n">global</span> <span class="n">layout</span><span class="ss">:&#39;neato&#39;</span><span class="p">,</span> <span class="n">overlap</span><span class="ss">:false</span>
  <span class="n">nodes</span> <span class="n">colorscheme</span><span class="ss">:&#39;blues9&#39;</span><span class="p">,</span> <span class="n">style</span><span class="ss">:&#39;filled&#39;</span><span class="p">,</span> <span class="n">shape</span><span class="ss">:&#39;polygon&#39;</span><span class="p">,</span> <span class="n">regular</span><span class="ss">:true</span>
  <span class="n">edges</span> <span class="n">arrowhead</span><span class="ss">:&#39;none&#39;</span>
  
  <span class="n">usdata</span><span class="o">.</span><span class="n">each</span> <span class="k">do</span> <span class="o">|</span><span class="nb">id</span><span class="p">,</span> <span class="nb">name</span><span class="p">,</span> <span class="n">cap</span><span class="p">,</span> <span class="n">sthood</span><span class="p">,</span> <span class="n">area</span><span class="p">,</span> <span class="n">pop</span><span class="p">,</span> <span class="n">gdp</span><span class="p">,</span> <span class="n">link</span><span class="o">|</span>
    <span class="n">sthood</span> <span class="o">=</span> <span class="mi">9</span> <span class="o">-</span> <span class="n">era</span><span class="o">.</span><span class="n">index</span> <span class="p">{</span> <span class="o">|</span><span class="n">r</span><span class="o">|</span> <span class="n">r</span><span class="o">.</span><span class="n">include?</span> <span class="n">sthood</span> <span class="p">}</span>
    <span class="n">area</span> <span class="o">=</span> <span class="n">area</span><span class="o">.</span><span class="n">norm</span><span class="p">(</span><span class="n">area_minmax</span><span class="p">,</span> <span class="mi">1</span><span class="o">.</span><span class="n">.</span><span class="mi">6</span><span class="p">)</span>
    <span class="n">pop</span> <span class="o">=</span> <span class="n">pop</span><span class="o">.</span><span class="n">norm</span><span class="p">(</span><span class="n">pop_minmax</span><span class="p">,</span> <span class="mi">4</span><span class="o">.</span><span class="n">.</span><span class="mi">12</span><span class="p">)</span>
    <span class="n">route</span> <span class="nb">id</span> <span class="o">=&gt;</span> <span class="n">link</span>
    <span class="n">node</span> <span class="nb">id</span><span class="p">,</span> <span class="n">label</span><span class="p">:</span> <span class="nb">name</span><span class="p">,</span> <span class="n">fillcolor</span><span class="ss">:sthood</span><span class="p">,</span> <span class="n">width</span><span class="ss">:area</span><span class="p">,</span> <span class="n">fontsize</span><span class="p">:</span><span class="mi">14</span><span class="o">*</span><span class="n">area</span><span class="p">,</span> <span class="n">sides</span><span class="ss">:pop</span>
    <span class="n">node</span> <span class="nb">id</span><span class="p">,</span> <span class="n">fontcolor</span><span class="ss">:&#39;white&#39;</span> <span class="k">if</span> <span class="n">sthood</span> <span class="o">&gt;</span> <span class="mi">7</span>
  <span class="k">end</span>
<span class="k">end</span>

<span class="n">gv</span><span class="o">.</span><span class="n">save</span><span class="p">(</span><span class="ss">:usa</span><span class="p">,</span> <span class="ss">:png</span><span class="p">)</span>
</code></pre>
</div>


<p>結果を見てみます。</p>

<p><img src="/assets/images/usa5.png" alt="usa noshadow" /></p>

<p>CaliforniaやTexasの人口が多いのが分かります。</p>

<h2>仕上げ</h2>

<p>Alaskaが大きすぎて全体のバランスが悪いのでこれを調整して完成とします。</p>

<p><a href="/assets/images/usa6.png" rel="lightbox" title="U.S states"><img src="/assets/images/usa6.png" alt="us states noshadow" /></a></p>

<p>（このグラフはクリックすれば拡大できます）</p>

<p>いいですね！</p>

<p>このグラフからアメリカ合衆国に関し概ね以下のことが分かります。</p>

<blockquote><ol>
<li>アメリカは東側から西側に向けて統合が進んだ。つまり東側のほうが歴史が古い。</li>
<li>西側のほうが州の区画面積が全体として広い。</li>
<li>東側は面積は小さいが人口が多い州が多く、西側はその逆である。</li>
</ol>
</blockquote>

<p>Gvizを使ってアメリカ合衆国における各州の統合年、面積および人口をビジュアライズする例を紹介しました。コード全体を以下に張っておきます。</p>

<script src="https://gist.github.com/3792505.js?file=usstates.rb"></script>


<p><a href="https://gist.github.com/3792505" title="melborne's gist: 3792505 — Gist">melborne's gist: 3792505 — Gist</a></p>

<hr />

<p>(追記：2012-9-30) Fixnum#normの実装が間違っていたので訂正しました。その結果添付のグラフの結果が一部間違っている点ご了承下さい。</p>

<p>(追記：2012-10-1) Fixnum#normの実装がまた間違ってましたm(__)m</p>

<hr />

<p><a href="http://www.amazon.co.jp/ビューティフルビジュアライゼーション-THEORY-PRACTICE-Julie-Steele/dp/4873115043?SubscriptionId=06WK2XPKDH9TJJ979P02&tag=keyesblog05-22&linkCode=xm2&camp=2025&creative=165953&creativeASIN=4873115043"><img class="amazon" src="http://ecx.images-amazon.com/images/I/51Yy4ezB85L._SL160_.jpg" /></a>
<a href="http://www.amazon.co.jp/ビューティフルビジュアライゼーション-THEORY-PRACTICE-Julie-Steele/dp/4873115043?SubscriptionId=06WK2XPKDH9TJJ979P02&tag=keyesblog05-22&linkCode=xm2&camp=2025&creative=165953&creativeASIN=4873115043">ビューティフルビジュアライゼーション (THEORY/IN/PRACTICE)</a> by Julie Steele and Noah Iliinsky</p>

