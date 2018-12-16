require File.dirname(__FILE__) + '/../../config/environment.rb'
require 'rubygems'
require 'twitter'
require 'attempt'

# zips that you don't want the tweets deleted
exceptions = ['50021', '50263', '60625']

# list of Twitter login failures
badauth = File.new('badauth.log', 'a')

# read resume.log to find which zip to resume/start with
resumefile = File.new('resume.log', 'a+')
linearray = resumefile.readlines
resume_zip = linearray.last.chomp
puts 'Resuming with zip ' + resume_zip

# ensure user wants to delete tweets
puts 'This will delete all tweets for all twitter zips.'
puts 'Do you want to continue? yes/no'
answer = gets.chomp.downcase
exit unless answer == 'yes'

twitter_zips = TwitterZip.registered.all(:order => :zip, :conditions => "zip > #{resume_zip}")

twitter_zips.each do |tz|
  unless exceptions.include?(tz.zip)
    print tz.zip
    
    begin
      httpauth = Twitter::HTTPAuth.new(tz.zip, tz.password)
      client = Twitter::Base.new(httpauth)
      client.verify_credentials # so can rescue and log
    rescue
      # log the login failures to a file
      puts ' unable to login'
      badauth.puts tz.zip
      badauth.flush
      next
    end
    
    attempt(10, 5) {
      client.user_timeline.each do |tweet|
        client.status_destroy(tweet.id)
        #sleep 2
      end
    }
    
    puts " tweets DELETED"
    resumefile.puts tz.zip
    #sleep 1
  end
end
