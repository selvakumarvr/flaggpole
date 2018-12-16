class ZipMessage < ActiveRecord::Base
  attr_accessible :source_id, :zip, :content, :uid, :enqueued, :tweeted
  belongs_to :source
  scope :not_tweeted, :conditions => {:tweeted => false}
  scope :not_enqueued, :conditions => {:enqueued => false}
  MAX_LENGTH = 140
  
  before_create :set_created_at_date

  def set_created_at_date
    self.created_at_date = Date.today
    true # so that save doesn't fail
  end
  
  def source
    Source.source source_id
  end

  def self.excess(message)
    message.length - self::MAX_LENGTH
  end
  
  def tweet(client = nil, twitter_zip = nil)
    return if self.tweeted?
    twitter_zip ||= TwitterZip.find_by_zip(zip)
    # pass false to login to prevent verify_credentials
    client ||= twitter_zip.login(false)
    return unless client
    
    # have to catch any exceptions
    begin
      result = client.update(content, {:lat => twitter_zip.latitude.to_s, :long => twitter_zip.longitude.to_s})
    rescue Twitter::Error::Unauthorized
      twitter_zip.failed!
      twitter_zip.suspended! if twitter_zip.suspended?
    rescue Twitter::Error::BadGateway, Twitter::Error::ServiceUnavailable
      # ...
    rescue Twitter::Error::Forbidden => e
      if e.message =~ /Your account is suspended/
        twitter_zip.suspended!
      else
        raise unless e.message =~ /Status is a duplicate/
      end
    else
      # runs if no exception
      # TODO what does client.update() return on failure?
      update_attributes(:tweeted => true) if result
      twitter_zip.succeeded!
    end
    
  end
end
