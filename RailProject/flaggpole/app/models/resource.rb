class Resource < ActiveRecord::Base
  belongs_to :info
  validates_presence_of :resource_desc, :mime_type
end
