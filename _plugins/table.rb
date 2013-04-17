# encoding: UTF-8

# A Liquid tag for table.
# by: Kyo Endo
# Source URL: https://gist.github.com/5393399
#
# Example usage:
#    {% table border='solid 1px' cellpadding=3px align=center %}
#    title aturhor price
#    "Programming Ruby" "Charlie Ace" $18.05
#    "Lisp" "Lisa Bee" $25.95
#    {% endtable %}
#

module Jekyll
  class Table < Liquid::Block
    def initialize(tag_name, text, token)
      super
      @text = text
    end
  
    def render(context)
      th = ->val{ "<th>#{val}</th>" }
      td = ->val{ "<td>#{val}</td>" }
      tr = ->tds{ "  <tr>#{tds}</tr>\n" }

      re = /".*?"|'.*?'/
      marker = "<__SPACE_MARKER__>"

      lines = super.each_line.reject{|line| line[/^$/] }
      trs = lines.map.with_index do |line, i|
        vals = line.gsub(re) { |m| m.gsub(" ", marker).delete('"') }.split
        tds = vals.inject(""){|m, val| m + (i==0 ? th[val] : td[val]) }
                  .gsub(marker, " ")
        tr[tds]
      end.join
      "<table #{@text}>\n#{trs}\n</table>"
    end
  end
end

Liquid::Template.register_tag('table', Jekyll::Table)

