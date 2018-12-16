class TandemApi
  include HTTParty
  
  TOKEN = 'twitzipftw'
  
  base_uri 'https://api.intand.com/rest/index.php'
  format :xml
  default_params 'token' => TOKEN

  def self.get_items(item, query)
    begin
      response = self.get('', :query => query).parsed_response
    rescue MultiXml::ParseError => e
      # XML had invalid entities &Eacute; should replace with &#201;
      puts "Error for query: " + query.to_s
      puts e.message
      return []
    end
    ary = response.nil? ? [] : response['data'][item]
    return ary.is_a?(Array) ? ary : [ary]
  end

  def self.countries
    self.get_items('country', {type: 'country'})
  end

  def self.subdivisions(country)
    self.get_items('subdivision', {type: 'subdivision', country: country})
  end

  def self.districts(subdivision)
    self.get_items('district', {type: 'districts', subdivision: subdivision})
  end

  # nces_id 12 digits, first 7 are school district, first 2 identify the state, remaining 5 school district
  # last 5 digits identify the school

  # accepts 7 digit NCES district id
  def self.schools(nces_id)
    self.get_items('school', {type: 'schools', nces_id: nces_id})
  end

  # accepts 12 digit NCES school id
  def self.school(nces_id)
    response = self.get('', :query => {type: 'school', nces_id: nces_id})
    response.parsed_response['data']['school']
  end

  # accepts 12 digit NCES school id
  def self.groups(nces_id)
    self.get_items('group', {type: 'groups', nces_id: nces_id})
  end

end
