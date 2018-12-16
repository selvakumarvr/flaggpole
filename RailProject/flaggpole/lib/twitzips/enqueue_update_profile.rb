require File.dirname(__FILE__) + '/../../config/environment.rb'

twitter_zips = TwitterZip.registered.all(:order => :zip)
#twitter_zips = TwitterZip.find '31991'
#twitter_zips = [twitter_zips]

twitter_zips.each do |tz|
  puts "Enqueueing #{tz.zip}"
  
  profile = {}
  profile[:url] = 'http://twitzip.com'
  profile[:location] = tz.zip 
  profile[:description] = 'TwitZip: Building a Twitter Zip Code Infrastructure for Consistent Public Use'

  tz.delay.update_profile(profile)
end
