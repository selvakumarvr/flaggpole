class Promotion < ActiveRecord::Base
	has_many :promotion_zips, :dependent => :destroy
	has_many :twitter_zips, :through => :promotion_zips

	validates_presence_of :message_type, :message
	validates_presence_of :send_at
	validates_size_of :message, :maximum => 140
	validate :send_at_in_future
	validate :send_at_is_valid_datetime
	validate :must_have_one_zip

	# need to keep followers_count up to date in twitter_zip
	# better date picker for datetime, HTML5?
	# ajax total reached update
  # try jquery-ui autocomplete
  # specify timezone?
  # fix zip selection where have to click to select
  # check workflow and restrict crud actions
  # https://github.com/adzap/validates_timeliness

	MESSAGE_TYPES = {
		1 => 'Community Service Announcement',
		2 => 'Residential Announcement',
		3 => 'Commercial Offer',
		4 => 'Public Safety Announcement'
	}

  def zip_attributes=(zip_attributes)
    zip_attributes.each do |attributes|
      promotion_zips.build(attributes)
    end
  end
  
  def must_have_one_zip
    pzs = self.promotion_zips.clone
    pzs.reject!{|x| x.twitter_zip_id.nil? }
    errors.add(:zip, 'must specify a zip code') if pzs.empty?
  end
  
	def send_at_in_future
    	errors.add(:send_at, 'must be in the future') unless send_at.try(:future?)
  end

  def send_at_is_valid_datetime
    errors.add(:send_at, 'must be a valid datetime') if ((DateTime.parse(send_at.to_s) rescue ArgumentError) == ArgumentError)
  end
end
