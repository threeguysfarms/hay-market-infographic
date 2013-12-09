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

  search_results.parser.css("table#MNResultGrid tr td:first a").each do |report_link|
    p report_link["href"]
  end
end
