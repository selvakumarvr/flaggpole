require File.expand_path(File.dirname(__FILE__) + "/../../config/environment")
require 'rubygems'
require 'csv'

csv_file = File.join(Rails.root,'lib','twitzips','zipcodes.csv')
puts "Importing zip data from " + csv_file

source = Source.find_by_name('Outside.in')
CSV.foreach(csv_file, :encoding => 'ISO8859-1') do |row|
  primary = (row[1] == 'P')
  next if !primary
  
  tz = {}
  tz[:zip] = row[0]
  tz[:population] = row[69]
  tz[:latitude] = row[19]
  tz[:longitude] = row[20]
  tz[:state] = row[22]
  tz[:timezone] = "-#{row[32]}"
  tz[:city] = row[73]
  tz[:msa] = row[34]
  tz[:msa_name] = row[41]
  
  twitter_zip = TwitterZip.find_by_zip(tz[:zip])
  if twitter_zip.nil?
    puts tz[:zip] + " not exist"
    #tz[:password]
    tz[:email] = tz[:zip] + '@twitzip.com'
    tz[:registered] = 0
    #tz[:login]
    tz = TwitterZip.create!(tz)
    rss_url = 'http://outside.in/' + tz[:zip] + '.rss'
    RssFeed.create!(:source_id => source.id, :twitter_zip_id => tz.id, :rss_url => rss_url, :enabled => false)
  else
    twitter_zip.update_attributes(tz)
    puts tz[:zip]
  end

end
