require 'rubygems'
require 'bundler/setup'

require 'logger'

Bundler.require

a = Mechanize.new do |agent|
  agent.user_agent_alias = "Mac Safari"
  agent.follow_redirect = :all
end

a.get("http://search.ams.usda.gov/mnsearch/mnsearch.aspx") do |page|
  search_results = a.post "http://search.ams.usda.gov/mnsearch/mnsearch.aspx", {
    "locationCode" => "GX",
    "commodityCode" => "GR",
    "wireCode" => "312", 
    "documentType" => "MNDMS_TEXT", 
    "timeRange" => "Any", 
    "resultCount" => "10", 
    "sortField" => "Date", 
    "sortOrder" => "true", 
    "goButton.x" => "8", 
    "goButton.y" => "7", 
    "__EVENTVALIDATION" => page.parser.at("input#__EVENTVALIDATION")["value"], 
    "__VIEWSTATE" => page.parser.at("input#__VIEWSTATE")["value"]
  }
    #page.form_with(:id => "simplesearch", :method => "POST") do |search|
    ##binding.pry
    ##search.__EVENTVALIDATION = page.parser.at("input#__EVENTVALIDATION")["value"]
    ##search.__VIEWSTATE = page.parser.at("input#__VIEWSTATE")["value"]
    #search.add_field!("locationCode", "GX")
    #search.add_field!("commodityCode", "GR")
    #search.add_field!("wireCode", "312")
    #search.add_field!("documentType", "MNDMS_TEXT")
    #search.add_field!("timeRange", "Any")
    #search.add_field!("resultCount", "10")
    #search.add_field!("sortField", "Date")
    #search.add_field!("sortOrder", "true")
    #search.add_field!("goButton.x", "15")
    #search.add_field!("goButtoin.y", "7")
    p search_results.parser.css("table#MNResultGrid tr td a")
end
