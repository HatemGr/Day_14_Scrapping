require 'open-uri'
require 'nokogiri'

doc = Nokogiri::HTML(URI.open('http://ruby.bastardsbook.com/files/hello-webpage.html'))
doc.xpath('//div/p').each do |node| # => Find all 'p' tags with a parent tag whose name is 'div'
  puts node.text
end