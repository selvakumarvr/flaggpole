require File.dirname(__FILE__) + '/../../config/environment.rb'

ids = [1, 2]
mentions = TwitterMention.all(:conditions => {:id => ids})
#m = TwitterMention.find '1'
#mentions = [m]

mentions.each do |m|
  puts "Enqueueing #{m.id}"
  Delayed::Job.enqueue(RetweetMentionJob.new(m.id))
end