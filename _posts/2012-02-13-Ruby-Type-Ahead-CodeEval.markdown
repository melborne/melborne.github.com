---
layout: post
title: RubyでType Aheadを解く-CodeEval
date: 2012-02-13
comments: true
categories:
tags: [ruby, codeeval]
---

一応パスしたけど75点^ ^;

Trigramのアルゴリズムが怪しいので多分そこが問題。まあ良として先に。

N-gramを使って特定ワードの次ぎに来るワードの確率リストを出力。
{% gist 1697463 type_ahead.rb %}
