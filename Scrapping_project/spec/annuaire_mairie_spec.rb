require_relative "../lib/annuaire_mairie"

describe "scrap should return a Nokogiri::HTML4::Document" do
  page = scrap('https://www.annuaire-des-mairies.com/val-d-oise.html')
  it "scrap should not return an empty object" do
  expect(page.nil?).to eq(false)
  end
  it "scrap class should be Nokogiri::HTML4::Document" do
    expect(page.class).to eq(Nokogiri::HTML4::Document)
  end
end

describe "get_townhall_email should return list of mails" do
  xpath_email = '/html/body/div/main/section[2]/div/table/tbody/tr[4]/td[2]'
  
  it "the returne element should contain an @ symbol" do
    expect(get_townhall_email("https://www.annuaire-des-mairies.com/95/wy-dit-joli-village.html",xpath_email).include?("@")).to  eq(true)
    end
end

describe "get_townhall_urls should return list of cities urls" do
  xpath_cities_url = "//a[@class='lientxt']/@href"

  it "method should return list that has at least 15 elements" do
    expect(get_townhall_urls('https://www.annuaire-des-mairies.com/val-d-oise.html',xpath_cities_url).size > 15).to eq(true)
  end
end

describe "get_townhall_names should return list of cities" do
  xpath_cities_name = "//a[@class='lientxt']"

  it "method should return list that has at least 15 elements" do
    expect(get_townhall_names('https://www.annuaire-des-mairies.com/val-d-oise.html',xpath_cities_name).size > 15).to eq(true)
  end
end

describe "mayor_stalker returns at least 5 elements" do
  it "the size of the output list should be bigger than 5" do
  expect(mayor_stalker("https://www.annuaire-des-mairies.com/val-d-oise.html").size > 5).to  eq(true)
  end
end

describe "mayor_stalker containes at least 2 VERY famous cities" do
  it "the returned list should contain at least ARGENTEUIL and PONTOISE" do

  has_ARGENTEUIL = false
  has_PONTOISE = false
  mayor_stalker("https://www.annuaire-des-mairies.com/val-d-oise.html").each{|city| city.keys.first == "ARGENTEUIL" ? has_ARGENTEUIL = true : city}
  mayor_stalker("https://www.annuaire-des-mairies.com/val-d-oise.html").each{|city| city.keys.first == "PONTOISE" ? has_PONTOISE = true : city}
  expect(has_ARGENTEUIL).to  eq(true)
  expect(has_PONTOISE).to  eq(true)
  end
end
