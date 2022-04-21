require 'open-uri'
require 'nokogiri'


def scrap(url)
  return Nokogiri::HTML(URI.open(url))
end

def fetch_currencies(noko_page)
  currencies = []
  noko_page.xpath("//tbody//a[@class='cmc-table__column-name--symbol cmc-link']").each do |currency| 
    currencies << currency.text
  end
  return currencies
end

def fetch_prices(noko_page)
  prices = []
  noko_page.xpath("//tbody//td[@class='cmc-table__cell cmc-table__cell--sortable cmc-table__cell--right cmc-table__cell--sort-by__price']//a[@class='cmc-link']").each do |price| 
    prices << price.text[1..-1].to_f
  end
  return prices
end


def dark_trader(page = scrap('https://coinmarketcap.com/all/views/all/'))
  page = scrap('https://coinmarketcap.com/all/views/all/')
  currencies = fetch_currencies(page)
  prices = fetch_prices(page)
  currency_price_list = []
  currencies.each.with_index {|currency,i| currency_price_list << {currency => prices[i]}}
  return currency_price_list
end

puts dark_trader()

# Pour LTC
# //*[@id="__next"]/div[1]/div[2]/div/div[1]/div/div[2]/div[3]/div/table/tbody/tr[21]/td[3]/div
# Pour ATOM
# //*[@id="__next"]/div[1]/div[2]/div/div[1]/div/div[2]/div[3]/div/table/tbody/tr[22]/td[3]/div
# crypto_hash = Hash[fetch_currencies(page).zip(fetch_prices(page))]
# puts crypto_hash
