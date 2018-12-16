require File.dirname(__FILE__) + '/../../config/environment.rb'
twitter_zips = TwitterZip.registered.all(:order => :zip)
twitter_zips.each do |tz|
  puts "Enqueueing #{tz.zip}"
  tz.delay.enable_geolocation
end
