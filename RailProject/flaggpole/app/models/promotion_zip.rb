class PromotionZip < ActiveRecord::Base
  belongs_to :promotion
	belongs_to :twitter_zip
	validate :valid_twitzip
	
	def zip
    twitter_zip.try(:zip)
  end
  
  def zip=(zip)
    self.twitter_zip_id = TwitterZip.find_by_zip(zip).id unless zip.blank?
  end
  
  def valid_twitzip
    errors.add(:zip, 'not a valid TwitZip') unless (zip.blank? || TwitterZip.valid_twitzip(zip))
  end
  
end
