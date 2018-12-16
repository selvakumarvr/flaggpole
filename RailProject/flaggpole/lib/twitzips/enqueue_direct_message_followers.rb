require File.dirname(__FILE__) + '/../../config/environment.rb'

msas = [60]
twitter_zips = TwitterZip.msa(msas).can_login.all(:order => :zip)
#tz = TwitterZip.find_by_zip 'ejunkertest'
#twitter_zips = [tz]

twitter_zips.each do |tz|
  message = "Broadcast local news, events, activities to TwitZip. Here's how 1) follow @#{tz.zip}, 2) mention @#{tz.zip} in your post, 3) include #twitzip."

  if message.length > 140
    puts "Message is longer than 140 characters"
    exit
  end
  
  puts "Enqueueing #{tz.zip}"
  Delayed::Job.enqueue(DirectMessageFollowersJob.new(tz.id, message))
end