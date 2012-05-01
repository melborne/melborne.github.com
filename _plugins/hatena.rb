module Jekyll
  class HatenaBookmarkTag < Liquid::Tag
    def initialize(tag_name, text, token)
      super
      @text = text
    end

    def render(context)
      url, title = @text.match(/(https?:\/\/\S+)(.*)/){ [$1, $2] }
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

