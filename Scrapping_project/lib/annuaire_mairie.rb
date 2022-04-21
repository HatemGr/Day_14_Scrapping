require 'open-uri'
require 'nokogiri'

def scrap(url)
  return Nokogiri::HTML(URI.open(url))
end

def get_townhall_email(townhall_url,xpath_email)
  page = scrap(townhall_url)
  townhall_email = page.xpath(xpath_email).text
  townhall_email.size == 0 ? townhall_email = "No m@il address" : townhall_email
  puts "Working on #{townhall_email}"
  return townhall_email
end

def get_townhall_urls(departement_url,xpath_cities_url)
  page = scrap(departement_url)
  liste_cities_url = []
  page.xpath(xpath_cities_url).each do |city_url|
    liste_cities_url << 'https://www.annuaire-des-mairies.com' + city_url.text[1..-1]
  end
  return liste_cities_url
end

def get_townhall_names(departement_url,xpath_cities_name)
  page = scrap(departement_url)
  liste_city_names = []
  page.xpath(xpath_cities_name).each do |city_name|
    liste_city_names << city_name.text
  end
  return liste_city_names
end


def loading_bar(total_size, current_size)
  current_size = 100 * current_size / total_size
  puts ("#" * current_size.to_i).ljust(100,"-")
end

def mayor_stalker (departement_url)
  xpath_email = '/html/body/div/main/section[2]/div/table/tbody/tr[4]/td[2]'
  xpath_cities_url = "//a[@class='lientxt']/@href"
  xpath_cities_name = "//a[@class='lientxt']"
  liste_mayor_stalker = []


  puts "Start fetching cities urls"
  liste_urls = get_townhall_urls(departement_url,xpath_cities_url)
  puts "Fetched all cities urls"

  total_bar = liste_urls.size

  puts "Start fetching mayors emails"
  liste_email = []
  liste_urls.each.with_index {|url,i| liste_email << get_townhall_email(url,xpath_email); loading_bar(total_bar,i) }
  puts "Fetched all mayors emails"

  puts "Merging all data"
  liste_cities = get_townhall_names(departement_url,xpath_cities_name)
  liste_cities.each.with_index {|city,i| liste_mayor_stalker << {city => liste_email[i]}}
  puts "All data printed"

  return liste_mayor_stalker
end

puts mayor_stalker('https://www.annuaire-des-mairies.com/val-d-oise.html')