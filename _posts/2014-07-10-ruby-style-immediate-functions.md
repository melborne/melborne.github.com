---
layout: post
title: "Ruby的即時関数"
description: ""
category: 
tags: 
date: 2014-07-10
published: true
---
{% include JB/setup %}


{% highlight ruby %}
JQuery = Class.new {
  define_singleton_method(:click) { |name, &blk|
    blk.(name);
  }
}

alias :alert :puts

method(def _ _
  _.click("Charlie", &->name{ 
    alert "Hello, " + name + "!!"
    });
end).(JQuery)

# >> Hello, Charlie!!
{% endhighlight %}

意味不明。

