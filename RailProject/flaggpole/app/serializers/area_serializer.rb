class AreaSerializer < ActiveModel::Serializer
  attributes :area_desc
  has_many :polygons, :circles, :geocodes
end
