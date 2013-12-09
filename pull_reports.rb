require 'rubygems'
require 'bundler/setup'

require 'open-uri'
require 'net/http'

Bundler.require

# get the report id components into a reports hash
reports = ["MG_GR310", 
  "GX_GR312", 
  "ML_GR311", 
  "GL_GR310", 
  "GX_GR313", 
  "ML_GR312", 
  "DC_GR310", 
  "NW_GR310", 
  "SF_GR313", 
  "JC_GR310", 
  "GX_GR310", 
  "BL_GR310", 
  "WH_GR310", 
  "AL_GR310", 
  "OK_GR310", 
  "ML_GR313", 
  "QA_GR111", 
  "SF_GR314", 
  "GX_GR314", 
  "SF_GR310", 
  "SF_GR315", 
  "SF_GR311", 
  "AM_GR310", 
  "AG_GR310", 
  "GX_GR311", 
  "RH_GR310", 
  "ML_GR310", 
  "TO_GR325", 
  "TO_GR310"].map do |name|
    { 
      location_code: name[0..1], 
      commodity_code: "GR",
      wire_code: name[-3..-1]
    }  
  end

reports.each do |report|
  a = Mechanize.new do |agent|
    agent.user_agent_alias = "Mac Safari"
    agent.follow_redirect = :all
  end

  a.get("http://search.ams.usda.gov/mnsearch/mnsearch.aspx") do |page|
    search_results = a.post "http://search.ams.usda.gov/mnsearch/mnsearch.aspx", {
      "locationCode" => report[:location_code],
      "commodityCode" => report[:commodity_code],
      "wireCode" => report[:wire_code], 
      "documentType" => "MNDMS_TEXT", 
      "timeRange" => "Any", 
      "resultCount" => "100", 
      "sortField" => "Date", 
      "sortOrder" => "true", 
      "goButton.x" => "8", 
      "goButton.y" => "7", 
      "__EVENTVALIDATION" => page.parser.at("input#__EVENTVALIDATION")["value"], 
      "__VIEWSTATE" => page.parser.at("input#__VIEWSTATE")["value"]
    }

    search_results.parser.css("table#MNResultGrid tr td:first a").each do |report_link|
      href = report_link["href"].downcase
      filename = "unprocessed_reports/#{File.basename(href)}"
      open(filename, "wb") do |file|
        open(href) do |uri|
          puts "About to write out file #{filename}"
          file.write(uri.read)
          puts "Done writing out file #{filename}"
        end
      end
    end
  end
end
