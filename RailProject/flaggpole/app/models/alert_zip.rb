class AlertZip < ActiveRecord::Base
  belongs_to :alert
  belongs_to :twitter_zip
  attr_accessible :alert_id
end
