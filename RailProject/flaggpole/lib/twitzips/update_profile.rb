require File.dirname(__FILE__) + '/../../config/environment.rb'

module Twitter
  class Base
    # file should respond to #read and #path
    def update_profile_image(file)
      perform_post('/account/update_profile_image.json', build_multipart_bodies(:image => file))
    end
  end
end

#twitter_zips = TwitterZip.registered.all(:order => :zip, :conditions => "zip > #{resume_zip}")
tz = TwitterZip.find_by_zip('ejunkertest')
twitter_zips = [tz]

twitter_zips.each do |tz|
    print tz.zip.to_s + ' '
    
    begin
      httpauth = Twitter::HTTPAuth.new(tz.zip, tz.password)
      client = Twitter::Base.new(httpauth)
      client.verify_credentials
    rescue Twitter::Error::Unauthorized
      puts ' unable to login'
      next
    end
    
    profile = {}
    profile[:url] = 'http://twitzip.com'
    profile[:location] = tz.zip 
    profile[:description] = 'TwitZip: Building a Twitter Zip Code Infrastructure for Consistent Public Use'
    
    begin
      # update the profile text
      client.update_profile(profile)
      print " profile updated"
      
      # update the icon
      icon = File.open('owl.gif')
      client.update_profile_image(icon)
      print " icon updated"
      
      # update the background image
      background = File.open('spiral.jpg')
      client.update_profile_background(background)
      print " background updated"
      
      puts
    rescue Exception => e
      puts "#{e.class}: #{e.message}"
      puts 'Unable to update ' + tz.zip.to_s
      next
    end

end