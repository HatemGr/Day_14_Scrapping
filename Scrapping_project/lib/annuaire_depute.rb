require 'open-uri'
require 'nokogiri'

def scrap(url)
  return Nokogiri::HTML(URI.open(url))
end

def get_deputy_email(deputy_url,xpath_email,xpath_email_alt)
  page = scrap(deputy_url)
  page.xpath(xpath_email).text.size == 0 ? deputy_email = page.xpath(xpath_email_alt).text : deputy_email = page.xpath(xpath_email).text
  deputy_email.size == 0 ? deputy_email = "No m@il address" : deputy_email
  puts "Working on #{deputy_email}"
  return deputy_email
end

def get_deputy_urls(all_deputies_url,xpath_deputies_url)
  page = scrap(all_deputies_url)
  liste_deputies_url = []
  page.xpath(xpath_deputies_url).each do |deputy_url|
    liste_deputies_url << 'https://www2.assemblee-nationale.fr/' + deputy_url.text
  end
  return liste_deputies_url
end

def get_deputy_names(all_deputies_url,xpath_deputies_name)
  page = scrap(all_deputies_url)
  liste_deputy_names = []
  page.xpath(xpath_deputies_name).each do |deputy_name|
    liste_deputy_names << deputy_name.text
  end
  return liste_deputy_names.delete_if {|element| element.size == 0}
  #Est-ce plus rapide de retirer les elements vides à la fin ou de tester element par element pour entrer dans la liste ?
end

def deputy_stalker (all_deputies_url)
  xpath_email = '/html/body/div/div[2]/div/div/div/section[1]/div/article/div[3]/div/dl/dd[4]/ul/li[2]/a'
  xpath_email_alt = '/html/body/div/div[2]/div/div/div/section[1]/div/article/div[3]/div/dl/dd[3]/ul/li[2]/a'
  xpath_deputies_url = "///div[@id='deputes-list']//a/@href"
  xpath_deputies_name = "//div[@id='deputes-list']//a"
  liste_deputy_stalker = []
  
  puts "Fetching all deputies urls"
  liste_deputy_urls = get_deputy_urls(all_deputies_url,xpath_deputies_url)
  puts "Fetched all urls"
  
  puts "Start fetching all deputies names"
  liste_deputies_names = get_deputy_names(all_deputies_url,xpath_deputies_name)
  puts "Fetched all deputies names"

  puts "Start fetching all emails for each url"
  liste_deputies_emails = []
  liste_deputy_urls.each {|url| liste_deputies_emails << get_deputy_email(url,xpath_email,xpath_email_alt )}
  puts "Fetched all emails"
  
  puts "Merging all data"
  liste_deputies_names.each.with_index {|deputy,i| liste_deputy_stalker << {deputy => liste_deputies_emails[i]}}
  return liste_deputy_stalker
end

puts deputy_stalker('https://www2.assemblee-nationale.fr/deputes/liste/alphabetique')








all_deputies_url = 'https://www2.assemblee-nationale.fr/deputes/liste/alphabetique'
#xpath_email = '/html/body/div/div[2]/div/div/div/section[1]/div/article/div[3]/div/dl/dd[4]/ul/li[2]/a'
xpath_email = '/html/body/div/div[2]/div/div/div/section[1]/div/article/div[3]/div/dl/dd[3]/ul/li[2]/a'
xpath_deputies_url = "///div[@id='deputes-list']//a/@href"
xpath_deputies_name = "//div[@id='deputes-list']//a"
#puts get_deputy_email(get_deputy_urls(all_deputies_url,xpath_deputies_url)[14],xpath_email)
#puts get_deputy_urls(all_deputies_url,xpath_deputies_url)
#puts get_deputy_names(all_deputies_url,xpath_deputies_name)

### WORKS
#/html/body/div/div[2]/div/div/div/section[1]/div/article/div[3]/div/dl/dd[4]/ul/li[2]/a
#/html/body/div/div[2]/div/div/div/section[1]/div/article/div[3]/div/dl/dd[4]/ul/li[2]/a

## DOES NOT WORK
#/html/body/div/div[2]/div/div/div/section[1]/div/article/div[3]/div/dl/dd[3]/ul/li[2]/a
#/html/body/div/div[2]/div/div/div/section[1]/div/article/div[3]/div/dl/dd[3]/ul/li[2]/a
