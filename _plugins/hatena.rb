# A Liquid tag for Jekyll sites that allows embedding Hatena Bookmark counter.
# by: Kyo Endo
# Source URL: https://gist.github.com/2565302
#
# Example usage: {% hatebu http://yourblog.com/path_to_a_post/ Title of Post %}
module Jekyll
  class HatenaBookmarkTag < Liquid::Tag
    def initialize(tag_name, text, token)
      super
      @text = text
    end

    def render(context)
      url, title = @text.match(/(https?:\/\/\S+)(.*)/){ [$1, $2] }
      return "" unless url
      bm_url = %{<a href="http://b.hatena.ne.jp/entry/#{url}" class="http-bookmark" target="_blank"><img src="http://b.hatena.ne.jp/entry/image/#{url}" alt="" class="http-bookmark"></a>}

      unless title.nil?
        %{<a href="#{url}" target="_blank">#{title.strip} </a>} + bm_url
      else
        bm_url
      end
    end
  end
end

Liquid::Template.register_tag('hatebu', Jekyll::HatenaBookmarkTag)
