require File.dirname(__FILE__) + '/../../config/environment.rb'

twitter_zips = TwitterZip.can_login.all

twitter_zips.each do |tz|
  if tz.oauth_token.nil?
    tz.delay.get_oauth_tokens
  end
end
