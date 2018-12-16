# http://developers.outside.in/
# Mashery username/password: twitzip/tweetpole1
# server time must be accurate for sign() to work

class OutsideInApi
  include HTTParty
  
  KEY = 'n6avbrrapk8xcwcex8k5bph2'
  SECRET = '4G4AYy8JBA'
  
  base_uri 'http://hyperlocal-api.outside.in/v1.1'
  format :json
  
  def self.sig
    Digest::MD5.hexdigest(KEY + SECRET + Time.now.to_i.to_s)
  end

  default_params 'dev_key' => KEY
  # can not send sig as default_param because it is based on time
  # and should not be cached
  
  # TODO limit to news verticals ?
  
  def self.stories(zip)
    url = "/zipcodes/#{zip}/stories"
    params = {
              'sig' => sig,
              #'format' => 'stories',
              #'vertical' => 'news',
              'max_age' => '3d',
              'limit' => '15',
            }
    response = self.get(url, :query => params)

    if response.kind_of? String
      raise response.to_s
    elsif response.include?('error')
      raise response['error']
    end
    response
  end
  
end
