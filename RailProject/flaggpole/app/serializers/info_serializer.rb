class InfoSerializer < ActiveModel::Serializer
  attributes :category, :event, :response_type, :urgency, :severity, :certainty,
  	:effective, :onset, :expires, :headline, :description, :instruction, :web,
  	:contact
  has_many :event_codes, :parameters, :resources, :areas
end
