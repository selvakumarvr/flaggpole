require File.dirname(__FILE__) + '/../../config/environment.rb'

csv_file = File.join(Rails.root,'lib','twitzips','thousand.csv')
puts "Importing zip data from " + csv_file

source = Source.find_by_name('Outside.in')
Excelsior::Reader.rows(File.open(csv_file, 'rb')) do |row|
  zip = row[0]
  twitter_zip = TwitterZip.find_by_zip(zip)
  # find all feeds for the zip for outside.in
  rss_feeds = twitter_zip.rss_feeds.all(:conditions => {:source_id => source.id})

  rss_feeds.each do |feed|
    feed.update_attributes(:enabled => true)
  end
end
