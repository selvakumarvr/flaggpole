require File.dirname(__FILE__) + '/../../config/environment.rb'
require 'digest/sha1'

twitter_zips = TwitterZip.registered.all(:order => :zip)
#tz = TwitterZip.find_by_zip 'ejunkertest'
#twitter_zips = [tz]

salt = 'petey'
twitter_zips.each do |tz|
  new_password = Digest::SHA1.hexdigest(salt + tz.zip)
  
  puts "Enqueueing #{tz.zip} #{new_password}"
  Delayed::Job.enqueue(ChangePasswordJob.new(tz.zip, new_password))
end