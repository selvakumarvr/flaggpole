require File.dirname(__FILE__) + '/../../config/environment.rb'

source = Source.find_by_name('Outside.in')
twitter_zips = TwitterZip.registered.all

twitter_zips.each do |tz|
  rss_url = "http://outside.in/#{tz.zip}.rss"
  RssFeed.create!(:source_id => source.id, :twitter_zip_id => tz.id, :rss_url => rss_url, :enabled => false)
end
