require_relative "../lib/annuaire_depute"

describe "scrap should return a Nokogiri::HTML4::Document" do
  page = scrap('https://www2.assemblee-nationale.fr/')
  it "scrap should not return an empty object" do
  expect(page.nil?).to eq(false)
  end
  it "scrap class should be Nokogiri::HTML4::Document" do
    expect(page.class).to eq(Nokogiri::HTML4::Document)
  end
end

describe "get_deputy_email should return list of mails" do
  xpath_email = '/html/body/div/div[2]/div/div/div/section[1]/div/article/div[3]/div/dl/dd[4]/ul/li[2]/a'
  xpath_email_alt = '/html/body/div/div[2]/div/div/div/section[1]/div/article/div[3]/div/dl/dd[3]/ul/li[2]/a'
  
  it "when in main mail xpath, should return mail address" do
    expect(get_deputy_email("https://www2.assemblee-nationale.fr/deputes/fiche/OMC_PA605036",xpath_email,xpath_email_alt)).to  eq("damien.abad@assemblee-nationale.fr")
  end

  it "when in alternative mail xpath, should return mail address" do
    expect(get_deputy_email("https://www2.assemblee-nationale.fr/deputes/fiche/OMC_PA721864",xpath_email,xpath_email_alt)).to  eq("souad.zitouni@assemblee-nationale.fr")
  end

  it "if no address available shoud return No m@il address" do
    expect(get_deputy_email("https://www2.assemblee-nationale.fr/deputes/fiche/OMC_PA720668",xpath_email,xpath_email_alt)).to  eq("No m@il address")
  end

end

describe "get_deputy_urls should return list of deputies' urls" do
  xpath_deputies_url = "///div[@id='deputes-list']//a/@href"

  it "method should return list that has at least 15 elements" do
    expect(get_deputy_urls("https://www2.assemblee-nationale.fr/deputes/liste/alphabetique",xpath_deputies_url).size > 15).to eq(true)
  end
end


describe "get_deputy_names should return list of deputies" do
  xpath_deputies_name = "//div[@id='deputes-list']//a"

  it "method should return list that has at least 15 elements" do
    expect(get_deputy_names("https://www2.assemblee-nationale.fr/deputes/liste/alphabetique",xpath_deputies_name).size > 15).to eq(true)
  end
end



####################



describe "deputy_stalker returns at least 5 elements" do
  it "the size of the output list should be bigger than 5" do
  expect(deputy_stalker("https://www2.assemblee-nationale.fr/deputes/liste/alphabetique").size > 5).to  eq(true)
  end
end

describe "deputy_stalker containes at least THE MOST famous, THE ONE AND ONLY deputy" do
  it "the returned list should contain at least M. Jean Lassalle " do
  has_LASALLE = false

  deputy_stalker("https://www2.assemblee-nationale.fr/deputes/liste/alphabetique").each{|deputy| deputy.keys.first == "M. Jean Lassalle" ? has_LASALLE = true : deputy}
  expect(has_LASALLE).to  eq(true)
  end
end
