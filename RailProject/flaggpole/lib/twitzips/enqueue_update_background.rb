require File.dirname(__FILE__) + '/../../config/environment.rb'

twitter_zips = TwitterZip.can_login.all(:order => :zip)
#twitter_zips = TwitterZip.find_by_zip '00674'
#twitter_zips = [twitter_zips]

base_dir = File.expand_path(File.dirname(__FILE__))
twitter_zips.each do |tz|
  filename = File.join(base_dir, 'backgrounds', "tz1-bg-#{tz.zip}.png")
  next unless File.exist?(filename)
  puts "Enqueueing #{tz.zip} #{filename}"
  tz.delay.update_background(filename)
end