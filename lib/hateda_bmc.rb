# encoding: UTF-8
require "uri"
require "xmlrpc/client"

module XMLRPC::ParseContentType
  def parse_content_type(str)
    str.sub('application/xml', 'text/xml').split(";")
  end
end

module HateDa
  class BookmarkCounter
    def initialize(hatena_id=nil)
      @hatena_id = hatena_id
    end

    def get(url, opt={})
      opt = { with_hateda: true, page: :p1}.merge(opt)
      url = URI.parse(url)
      hatena_url = build_hatena_url(url.path, opt[:page]) if opt[:with_hateda] && @hatena_id
      [url.to_s, hatena_url].compact.map { |url| [url, get_total(url)] }
    rescue Timeout::Error
      STDERR.puts "HTTP Access Timeout:#{e}"
      exit
    rescue URI::InvalidURIError
      STDERR.puts "URI parse error:#{e}"
      exit
    end

    private
    def build_hatena_url(path, page)
      date = path.gsub(/\D/, '')[0,8]
      path = date.empty? ? "/" : "/#{date}/#{page}"
      HOST(:diary) + path
    end

    def get_total(url)
      client = XMLRPC::Client.new2( HOST(:xmlrpc) )
      client.call("bookmark.getTotalCount", url)
    rescue => e
      STDERR.puts "Fail to get Total number of Bookmarks: #{e}"
    end

    def HOST(target)
      { diary:  "http://d.hatena.ne.jp/#{@hatena_id}",
        xmlrpc: "http://b.hatena.ne.jp/xmlrpc" }[target]
    end
  end
end
HateDa::BMC = HateDa::BookmarkCounter

hatena_id = :keyesberry
GitHub = 'http://melborne.github.com'
mel = '/2011/06/22/21-Ruby-21-Trivia-Notations-you-should-know-in-Ruby'
a = 'http://melborne.github.com/2010/02/06/Ruby_GraphViz/'
b = 'http://melborne.github.com/2010/02/06/Ruby/'
c = 'http://melborne.github.com/2012/04/09/to-newbie/#fn:3'
bm = HateDa::BMC.new(:keyesberry)
p bm.get(c)

# %23fn:1
