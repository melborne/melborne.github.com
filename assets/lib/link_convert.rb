#!/usr/bin/env ruby
SELF_URL = "http:\/\/d\.hatena\.ne\.jp/keyesberry"
SELF_BOOKMARK = /\[.*\]\(#{SELF_URL}\/.*bookmark\)/
TARGET_LINE = /\[(.*?)(?:\s+\-\s+hp12c)*\]\(#{SELF_URL}\/(\d+)\/.*?\)(?:#{SELF_BOOKMARK})*/

def read(fnames)
  target = {}
  fnames.each do |fname|
    #puts "read: #{fname}"
    open(fname) do |file|
      origin = file.read
      modified = origin.gsub(TARGET_LINE) do
        title, number = $1, $2
        short_title = title.scan(/[\d\w]+/).join('-')
        short_title = "notitle" if short_title.empty?
        url = 
          number.match(/(\d{4})(\d{2})(\d{2})/) do |m|
            "/#{m[1]}/#{m[2]}/#{m[3]}/#{short_title}/"
          end

        "[#{title}](#{url})"
      end
      target[fname] = modified if origin != modified
    end
  end
  target
end

def write(target)
  target.each do |fname, content|
    open(fname, 'w') do |file|
      file.puts content
    end
    puts "rewrite: #{fname}"
  end
end


def main(fnames)
  target = read(fnames)
  write(target)
end

arg = ARGV[0]
files = arg ? arg : '*.{md,markdown}'
main(Dir[files])
