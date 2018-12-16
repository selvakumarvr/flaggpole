require 'open-uri'
require 'json'

module Yahoo
  class YQL
    def self.query(query)
      yahoo_url = 'http://query.yahooapis.com/v1/public/yql?format=json&q='
      url = URI.encode(yahoo_url + query)
      result = JSON.parse(open(url).read)
    end
  end
  
  class GeoPlanet
    def self.find_by_zip(zip)
      query = "SELECT * FROM geo.places WHERE placeTypeName = 'Zip Code' AND text = " + zip.to_s
      data = YQL::query(query)
      place = data["query"]["results"]["place"]
    end
  end

  class Weather
    def self.lookup_location(location)
      query = "SELECT * FROM weather.forecast WHERE location = " + location.to_s
      weather_data = YQL::query(query)
      weather_results = weather_data["query"]["results"]["channel"]
    end

    def self.message(location)
      weather_results = self.lookup_location(location)

      # Current conditions
      now = weather_results["item"]["condition"]
      currently = "CURRENTLY #{now['text']} #{now['temp']}"

      # Forecast
      f = weather_results["item"]["forecast"][0]
      today = "TODAY #{f['text']}, High: #{f['high']}, Low: #{f['low']}"
      f = weather_results["item"]["forecast"][1]
      tomorrow = "#{f['day'].upcase} #{f['text']}, High: #{f['high']}, Low: #{f['low']}"

      # Link
      link = weather_results["item"]["link"]
      short_url = ShortUrl::shorten(link).short_url

      "#{currently} | #{tomorrow} #{short_url}"
    end
  end
end