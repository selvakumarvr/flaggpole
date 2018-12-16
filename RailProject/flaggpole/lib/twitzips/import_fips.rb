require File.expand_path(File.dirname(__FILE__) + "/../../config/environment")
require 'rubygems'
require 'csv'

csv_file = File.join(Rails.root,'lib','twitzips','zipcodes.csv')
puts "Importing zip data from " + csv_file

CSV.foreach(csv_file, :encoding => 'ISO8859-1') do |row|
  primary = (row[1] == 'P')
  next if !primary
  
  tz = {}
  tz[:zip] = row[0]
  tz[:county] = row[29]
  tz[:county_fips] = row[30]
  tz[:state_fips] = row[31]
  tz[:same] = "0" + tz[:state_fips] + tz[:county_fips]
 
  twitter_zip = TwitterZip.find_by_zip(tz[:zip])
  if twitter_zip
    twitter_zip.update_attributes(tz)
    puts tz[:zip]
  end
end
