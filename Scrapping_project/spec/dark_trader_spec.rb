require_relative "../lib/dark_trader"

describe "dark_trader returns at least 5 elements" do
  it "the size of the output list should be bigger than 5" do
  page = scrap('https://coinmarketcap.com/all/views/all/')
  expect(dark_trader(page).size > 5).to  eq(true)
  end
end

describe "dark_trader containes at least BTC and ETH" do
  it "the size of the output list should be bigger than 5" do
  page = scrap('https://coinmarketcap.com/all/views/all/')
  has_BTC = false
  has_ETH = false
  dark_trader(page).each{|crypto_hash| crypto_hash.keys.first == "BTC" ? has_BTC = true : crypto_hash}
  dark_trader(page).each{|crypto_hash| crypto_hash.keys.first == "ETH" ? has_ETH = true : crypto_hash}
  expect(has_BTC).to  eq(true)
  expect(has_ETH).to  eq(true)
  end
end

describe "fetch_currency should contain at least BTC and ETH" do
  it "the size of the output list should be bigger than 5" do
  page = scrap('https://coinmarketcap.com/all/views/all/')
 
  expect(fetch_currencies(page).include?("BTC")).to  eq(true)
  expect(fetch_currencies(page).include? ("ETH")).to  eq(true)
  end
end

describe "fetch_currency should have at least 5 currencies" do
  it "the size of the output list should be bigger than 5" do
  page = scrap('https://coinmarketcap.com/all/views/all/')
  expect(fetch_currencies(page).size >= 5).to  eq(true)
  end
end

describe "fetch_currency shouldn't containe nil values" do
  it "check whether or not there a nil element in the list" do
  page = scrap('https://coinmarketcap.com/all/views/all/')
 
  expect(fetch_currencies(page).include?(nil)).to  eq(false)
  end
end

describe "fetch_prices should have at least 5 currencies" do
  it "the size of the output list should be bigger than 5" do
  page = scrap('https://coinmarketcap.com/all/views/all/')
  expect(fetch_prices(page).size >= 5).to  eq(true)
  end
end

describe "scrap should return a Nokogiri::HTML4::Document" do
  page = scrap('https://coinmarketcap.com/all/views/all/')
  it "scrap should not return an empty object" do
  expect(page.nil?).to eq(false)
  end
  it "scrap class should be Nokogiri::HTML4::Document" do
    expect(page.class).to eq(Nokogiri::HTML4::Document)
  end
end
