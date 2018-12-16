class TimelineSerializer < ActiveModel::Serializer
  has_many :alerts
  has_many :zip_messages
  has_many :organization_messages
end
