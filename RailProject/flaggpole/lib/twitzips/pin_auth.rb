require File.dirname(__FILE__) + '/../../config/environment.rb'

token = AppConfig.twitter.consumer_key
secret = AppConfig.twitter.consumer_secret
puts token
puts secret

oauth = Twitter::OAuth.new(token, secret)
rtoken = oauth.request_token.token
rsecret = oauth.request_token.secret

puts oauth.request_token.authorize_url

print "> what was the PIN twitter provided you with? "
pin = gets.chomp

begin
  oauth.authorize_from_request(rtoken, rsecret, pin)

  twitter = Twitter::Base.new(oauth)
#  twitter.user_timeline.each do |tweet|
  #    puts "#{tweet.user.screen_name}: #{tweet.text}"
  #  end
  rescue OAuth::Unauthorized
    puts "> FAIL!"
    end
