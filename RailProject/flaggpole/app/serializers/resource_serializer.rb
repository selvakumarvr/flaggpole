class ResourceSerializer < ActiveModel::Serializer
  attributes :resource_desc, :mime_type, :size, :uri
end
