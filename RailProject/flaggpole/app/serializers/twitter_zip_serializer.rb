class TwitterZipSerializer < ActiveModel::Serializer
  attributes :id, :zip, :city, :state
end
