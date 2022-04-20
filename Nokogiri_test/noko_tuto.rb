require 'rubygems'
require 'nokogiri'
require 'open-uri'
   
page_wiki = Nokogiri::HTML(URI.open("http://en.wikipedia.org/"))   
page = Nokogiri::HTML(URI.open("http://ruby.bastardsbook.com/files/hello-webpage.html"))   
puts page.class  # => Nokogiri::HTML::Document
puts page.css("title") # => <title>My webpage</title>
puts page.css("li")[0].text # => Youtube
puts page.css('li')[0]['href']
puts page.css("li[data-category='news']")
puts page.css('div#funstuff')[0] # => The complete div
puts page.css('div#references a')[0]['href'] #=> return href of first element of a inside div=references
puts "-" * 50
puts page.css('title') # => <title>My webpage</title>
puts page.css("title")[0].name   # => title
puts page.css("title")[0].text   # => My webpage
puts "-" * 50
links = page.css("a")
puts links.length   # => 6
puts links[0].text   # => Click here
puts links[0]["href"] # => http://www.google.com
puts "-" * 50
news_links = page.css("a").select{|link| link['data-category'] == "news"}
news_links.each{|link| puts link['href'] }
#=>   http://reddit.com
#=>   http://www.nytimes.com
puts news_links.class   #=>   Array  
puts "-" * 50
news_links = page.css("a[data-category=news]")
news_links.each{|link| puts link['href']}
#=>   http://reddit.com
#=>   http://www.nytimes.com
puts news_links.class   #=>   Nokogiri::XML::NodeSet

