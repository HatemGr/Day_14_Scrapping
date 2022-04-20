require 'open-uri'
require 'nokogiri'

def scrap(url)
  return Nokogiri::HTML(URI.open(url))
end

def get_townhall_email(townhall_url,xpath_email)
  page = scrap(townhall_url)
  townhall_email = page.xpath(xpath_email).text
  return townhall_email
end

def get_townhall_urls(departement_url,xpath_cities_url)
  page = scrap(departement_url)
  liste_url = []
  page.xpath(xpath_cities_url).each do |city_url|
    liste_url << 'https://www.annuaire-des-mairies.com' + city_url.text[1..-1]
  end
  return liste_url
end

def get_townhall_names(departement_url,xpath_cities_name)
  page = scrap(departement_url)
  liste_city_names = []
  page.xpath(xpath_cities_name).each do |city_name|
    liste_city_names << city_name.text
  end
  return liste_city_names
end

def mayor_stalker (departement_url)
  xpath_email = '/html/body/div/main/section[2]/div/table/tbody/tr[4]/td[2]'
  xpath_cities_url = "//a[@class='lientxt']/@href"
  xpath_cities_name = "//a[@class='lientxt']"
  liste_mayor_stalker = []

  liste_urls = get_townhall_urls(departement_url,xpath_cities_url)
  liste_email = []
  liste_urls.each {|url| liste_email << get_townhall_email(url,xpath_email)}
  liste_cities = get_townhall_names(departement_url,xpath_cities_name)

  liste_cities.each.with_index {|city,i| liste_mayor_stalker << {city => liste_email[i]}}
  return liste_mayor_stalker
end

puts mayor_stalker('https://www.annuaire-des-mairies.com/val-d-oise.html')