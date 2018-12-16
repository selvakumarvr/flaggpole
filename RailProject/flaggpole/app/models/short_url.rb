class ShortUrl < ActiveRecord::Base
  attr_accessible :long_url, :long_url_sha1, :destination_url, :user_hash, :count

  def self.shorten(url)
    return if url.blank?
    sha1 = Digest::SHA1.hexdigest(url)
    short_url = self.find_by_long_url_sha1(sha1)
    if short_url.nil?
      destination_url = url
      #destination_url = self.remove_outsidein(destination_url)
      #destination_url = self.remove_feedproxy(destination_url)

      Bitly.use_api_version_3
      @bitly ||= Bitly.new(AppConfig.bitly_username, AppConfig.bitly_password)
      user_hash = @bitly.shorten(destination_url).user_hash
      self.create(:long_url => url, :long_url_sha1 => sha1, :destination_url => destination_url, :user_hash => user_hash, :count => 1)
    else
      short_url.increment!(:count)
      short_url
    end
  end
  
  def self.yourls(url)
    return if url.blank?
    sha1 = Digest::SHA1.hexdigest(url)
    short_url = self.find_by_long_url_sha1(sha1)
    if short_url.nil?
      destination_url = url
      
      @yourls ||= Yourls.new(AppConfig.yourls_address, AppConfig.yourls_api_key)
      short_url = @yourls.shorten(url)
      user_hash = short_url.keyword
      puts "user_hash is #{user_hash} for #{url} with sha1 of #{sha1}"
      
      self.create(:long_url => url, :long_url_sha1 => sha1, :destination_url => destination_url, :user_hash => user_hash, :count => 1)
    else
      short_url.increment!(:count)
      short_url
    end
  end

  def yourls_url
    'http://mk3.me/' + self.user_hash
  end

  def short_url
    'http://bit.ly/' + self.user_hash
  end
  
  def self.remove_outsidein(url)
    if url =~ /pubapi\.outside\.in/
      CGI.parse(URI.parse(url).query)['url'].first
    end
  end
  
  def self.remove_feedproxy(url)
    if url =~ /feedproxy\.google\.com/
      response = Net::HTTP.get_response(URI.parse(url))
      response['location']
    end
  end
end
