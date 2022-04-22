require 'open-uri'
require 'nokogiri'

### ---- Methode pour scraper une page en paetant de son URL
def scrap(url)
  return Nokogiri::HTML(URI.open(url))
end

### ---- Mehode pour recuperer une liste de crypto monnaies
def fetch_currencies(noko_page)
  currencies = []
  noko_page.xpath("//tbody//a[@class='cmc-table__column-name--symbol cmc-link']").each do |currency| 
    currencies << currency.text
  end
  return currencies
end

### ---- Methode pour recuperer une liste de prix de crypto monnaie
def fetch_prices(noko_page)
  prices = []
  noko_page.xpath("//tbody//td[@class='cmc-table__cell cmc-table__cell--sortable cmc-table__cell--right cmc-table__cell--sort-by__price']//a[@class='cmc-link']").each do |price| 
    prices << price.text.delete(",$").to_f
  end
  return prices
end

### ---- Methode principale regroupant toutes les autres sous-methodes
def dark_trader(page = scrap('https://coinmarketcap.com/all/views/all/'))
  page = scrap('https://coinmarketcap.com/all/views/all/')
  currencies = fetch_currencies(page)
  prices = fetch_prices(page)
  currency_price_list = []
  currencies.each.with_index {|currency,i| currency_price_list << {currency => prices[i]}}
  return currency_price_list
end

puts dark_trader()
