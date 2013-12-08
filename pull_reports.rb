require 'rubygems'
require 'bundler/setup'

require 'open-uri'

Bundler.require

report_names = ["MG_GR310", 
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
  "TO_GR310"]

report_names.each do |name|
  open("unprocessed_reports/#{name}20131205.txt", "wb") do |file|
    open("http://search.ams.usda.gov/mndms/2013/12/#{name}20131205.TXT") do |uri|
      file.write(uri.read)
    end
  end
end
