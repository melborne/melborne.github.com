# encoding: UTF-8

require 'amazon/aws'
require 'amazon/aws/search'
require 'cgi'

module Jekyll
  class AmazonResultCache
    def initialize
      @result_cache = {}
    end

    @@instance = AmazonResultCache.new

    def self.instance
      @@instance
    end

    def item_lookup(asin, try=5)
      item_lookup_with_retry(asin, try=5) do
        asin = asin.to_s.strip
        return @result_cache[asin] if @result_cache.has_key?(asin)
        il = Amazon::AWS::ItemLookup.new('ASIN', {'ItemId' => asin})
        resp = Amazon::AWS::Search::Request.new.search(il)
        @result_cache[asin] = resp
        return resp
      end
    end

    def item_lookup_with_retry(asin, try)
      begin
        times = 1
        yield
      rescue Amazon::AWS::HTTPError => e
        if try > 0
          puts "retry:#{asin}: #{try}:#{e}"
          sleep 0.5 * times
          try -= 1
          times += 1
          retry
        end
      end
    end

    private_class_method :new
  end

  module Filters
    def amazon_link(text)
      resp = AmazonResultCache.instance.item_lookup(text)
      item = resp.item_lookup_response[0].items[0].item[0]
      url = CGI::unescape(item.detail_page_url.to_s)
      title = item.item_attributes.title.to_s.gsub(/ \[Blu-ray\]/, '').gsub(/ \(Ultimate Edition\)/, '')
      '<a href="%s">%s</a>' % [url, title]
    end

    def amazon_authors(text)
      resp = AmazonResultCache.instance.item_lookup(text)
      item = resp.item_lookup_response[0].items[0].item[0]
      item_attr = item.item_attributes
      authors =
        if au = item_attr.author
          au.map(&:to_s)
        elsif au = item_attr.artist
          Array(au)
        else
          []
        end
      #authors = item.item_attributes.author.collect(&:to_s)
      array_to_sentence_string(authors)
    end

    def amazon_medium_image(text)
      resp = AmazonResultCache.instance.item_lookup(text)
      item = resp.item_lookup_response[0].items[0].item[0]
      url = CGI::unescape(item.detail_page_url.to_s)
      image_url = item.image_sets.image_set[0].medium_image.url
      '<a href="%s"><img class="amazon" src="%s" /></a>' % [url, image_url]
    end

    def amazon_large_image(text)
      resp = AmazonResultCache.instance.item_lookup(text)
      item = resp.item_lookup_response[0].items[0].item[0]
      url = CGI::unescape(item.detail_page_url.to_s)
      image_url = item.image_sets.image_set[0].large_image.url
      '<a href="%s"><img class="amazon" src="%s" /></a>' % [url, image_url]
    end

    def amazon_small_image(text)
      resp = AmazonResultCache.instance.item_lookup(text)
      item = resp.item_lookup_response[0].items[0].item[0]
      url = CGI::unescape(item.detail_page_url.to_s)
      image_url = item.image_sets.image_set[0].small_image.url
      '<a href="%s"><img class="amazon" src="%s" /></a>' % [url, image_url]
    end

    def amazon_release_date(text)
      resp = AmazonResultCache.instance.item_lookup(text)
      item = resp.item_lookup_response[0].items[0].item[0]
      item.item_attributes.theatrical_release_date.to_s
    end

    # Movie specific
    def amazon_actors(text)
      resp = AmazonResultCache.instance.item_lookup(text)
      item = resp.item_lookup_response[0].items[0].item[0]
      actors = item.item_attributes.actor.collect(&:to_s)
      array_to_sentence_string(actors)
    end

    def amazon_director(text)
      resp = AmazonResultCache.instance.item_lookup(text)
      item = resp.item_lookup_response[0].items[0].item[0]
      item.item_attributes.director.to_s
    end

    def amazon_running_time(text)
      resp = AmazonResultCache.instance.item_lookup(text)
      item = resp.item_lookup_response[0].items[0].item[0]
      item.item_attributes.running_time.to_s + " minutes"
    end

  end
end

