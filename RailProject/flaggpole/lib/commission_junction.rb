require 'rubygems'
require 'httparty'

# Your account identification number is: 3051343
# Your username is: nate@twitzip.com
# Your password is: HRrT6Vn

class CommissionJunction
  include HTTParty

  WEBSITE_ID = '4014706' # also known as PID
  GROUPON_ID = '2948661'
  DEFAULT_LINK = 'http://www.jdoqocy.com/click-4014706-10769830' # Daily Deals
  LINK_URI = 'https://linksearch.api.cj.com/v2/link-search'
  PRODUCT_URI = 'https://product-search.api.cj.com/v2/product-search?'
  API_KEY = '00a14045c2851cd9811e41a35cc00da157046d09841cb6ac55c6e9658aa6f41ab2f8d61e61c7b5559f1aee049d30ce2366a9775085493eeb66af19883f185c8023/6f3ea521dead998c8f701f20d4ca527d72eb3a7e6f44c33de61d8cd50bfb2a1327f6aab095e46b9c1819fdaf7d1d6271af911d2ca192d66ce650e72e7c5180d1'

  headers 'authorization' => API_KEY
  default_params  'website-id' => WEBSITE_ID
  
  def self.links()
    records_per_page = 100  # make sure large enough to get all Groupon Divisions
    page_number = 1
    params = {
          'promotion-type' => 'sale/discount',
          'link-type' => 'Text Link',
          'records-per-page' => records_per_page,
          'page-number' => page_number,
          'advertiser-ids' => GROUPON_ID
        }
    self.get(LINK_URI, :query => params)
    # TODO calculate number of pages needed and fetch more pages
  end
  
  # convert CJ link_name into a Groupon division_id
  def self.link_name_to_division_id(link_name)
    # get city name
    division = link_name.gsub('Groupon ', '')
    # basic slugify
    division_id = division.downcase.gsub(/[^a-z1-9]+/, '-').chomp('-')
    irregulars = {'minneapolis' => 'minneapolis-stpaul',
                  'st-louis' => 'stlouis'}
    irregulars.include?(division_id) ? irregulars[division_id] : division_id
  end
  
  def self.link_ids
    links = self.links['cj_api']['links']['link']
    link_ids = {}
    links.each do |link|
      division_id = self.link_name_to_division_id(link['link_name'])
      link_ids[division_id] = link['link_id']
    end
    link_ids
  end
  
  # could store division_id and link_uris in database table so that do not need to query for each division
  def self.link_uris
    links = self.links['cj_api']['links']['link']
    link_uris = {}
    links.each do |link|
      division_id = self.link_name_to_division_id(link['link_name'])
      link_uris[division_id] = URI.extract(link['link_code_html']).first
    end
    link_uris
  end
  
  def self.link_for_division(division_id)
    link_uris = self.link_uris
    link_uris[division_id]
    # returns nil if division_id does not exist
  end
  
  def self.products()
    params = {
#          'records-per-page' => 100,
#          'page-number' => 1,
#            'advertiser-ids' => GROUPON_ID
          'keywords' => 'chicago',
        }
    self.get(PRODUCT_URI, :query => params)
    #self.get(PRODUCT_URI)
  end
  
end
