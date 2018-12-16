require File.dirname(__FILE__) + '/../../config/environment.rb'

# zips that you don't want the tweets deleted
EXCEPTIONS = ['50021', '50263', '60625']

twitter_zips = TwitterZip.registered.all(:order => :zip, :conditions => "zip > 50020 AND zip <= 50025")

twitter_zips.each do |tz|
  next if EXCEPTIONS.include?(tz.zip)
  puts "Enqueueing #{tz.zip}"
  tz.delay.delete_all_tweets
end
