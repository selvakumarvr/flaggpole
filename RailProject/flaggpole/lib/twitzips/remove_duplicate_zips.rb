require File.dirname(__FILE__) + '/../../config/environment.rb'

TwitterZip.all.each do |twitter_zip|
  # find all TwitterZip objects for a given zip
  tzs = TwitterZip.all(:conditions => ["zip = ?",twitter_zip.zip])
  # keep the first instance
  tzs.shift
  # delete remaining duplicates
  tzs.each do |tz|
    puts "Removing duplicate for #{tz.zip}"
    tz.destroy
  end
end
