# encoding: UTF-8

# A Liquid tag for Jekyll sites that allows embedding Gumroad Overlay link.
# by: Kyo Endo
# Source URL: https://gist.github.com/
#
# Example usage: {% gumroad RjRO Title of Link %}
module Jekyll
  class GumroadTag < Liquid::Tag
    def initialize(tag_name, text, token)
      super
      @text = text
    end

    def render(context)
      url, title = @text.split(/\s/, 2).map(&:strip)
      %{<a href="http://gum.co/#{url}" class="gumroad-button" id="#{url}">#{title}</a><script type="text/javascript" src="https://gumroad.com/js/gumroad-button.js"></script><script type="text/javascript" src="https://gumroad.com/js/gumroad.js"></script>}
    end
  end
end

Liquid::Template.register_tag('gumroad', Jekyll::GumroadTag)

