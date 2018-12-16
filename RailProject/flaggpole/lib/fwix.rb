# http://fwix.com/developer_tools/api

class Fwix
  include HTTParty
  base_uri 'http://geoapi.fwix.com'
  format :json
  default_params 'api_key' => '50cbca105303'

  def self.nearby(lat, lon, radius = 5, types = ['news'])
    params = {
      :lat => lat,
      :lng => lon,
      :radius => radius,
      :content_types => types.join(',')
    }
    result = self.get('/content.json', :query => params)[types.first]
    #puts "#{base_uri}/content.json?" + params.to_query
    result || []
  end
  
  def self.nearbyItems(lat, lon, radius = 5, types = ['news'])
    results = self.nearby(lat, lon, radius, types)
    items = []
    results.each do |result|
      items << FwixItem.new(result)
    end
    items
  end
  
end
