# This code may not work properly on Ruby 1.9 because the
# OAuth library is coded mainly for Ruby 1.8.
# http://gist.github.com/304123

require "rubygems"
require "oauth"

module XAuth
module_function
  def retrieve_access_token(username, password, consumer_key, consumer_secret, site = 'https://api.twitter.com')
    consumer = OAuth::Consumer.new(
      consumer_key,
      consumer_secret,
      :site => site
    )
    
    # http://gist.github.com/259989
    access_token = consumer.get_access_token(nil, {}, {
      :x_auth_mode => "client_auth",
      :x_auth_username => username,
      :x_auth_password => password,
      })
    
    access_token
  end
end
